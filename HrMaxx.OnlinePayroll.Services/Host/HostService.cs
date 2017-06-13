using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Messages.Events;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Repository.Host;
using Newtonsoft.Json;

namespace HrMaxx.OnlinePayroll.Services.Host
{
	public class HostService : BaseService, IHostService
	{
		private readonly IHostRepository _hostRepository;
		private readonly IStagingDataService _stagingDataService;
		private readonly IDocumentService _documentService;
		private readonly ICommonService _commonService;
		private readonly ICompanyService _companyService;
		private readonly IMementoDataService _mementoDataService;
		public IBus Bus { get; set; }

		public HostService(IHostRepository hostRepository, IStagingDataService stagingDataService, IDocumentService documentService, ICommonService commonService, ICompanyService companyService, IMementoDataService mementoDataService)
		{
			_hostRepository = hostRepository;
			_stagingDataService = stagingDataService;
			_documentService = documentService;
			_commonService = commonService;
			_companyService = companyService;
			_mementoDataService = mementoDataService;
		}
		public IList<Models.Host> GetHostList(Guid host)
		{
			try
			{
				var hosts = _hostRepository.GetHostList(host);
				//hosts.Where(h=>h.CompanyId.HasValue).ToList().ForEach(h=>h.Company = _companyService.GetCompanyById(h.CompanyId.Value));
				return hosts;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "List of all Hosts");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Models.Host GetHost(Guid hostId)
		{
			try
			{
				return _hostRepository.GetHost(hostId);
				//if (host.CompanyId.HasValue)
				//	host.Company = _companyService.GetCompanyById(host.CompanyId.Value);
				//return host;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" Host details for Id {0}", hostId));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void Save(Models.Host host)
		{
			try
			{
				var original = _hostRepository.GetHost(host.Id);
				var notificationText = original.Id==Guid.Empty ? "A new Host {0} has been created" : "{0} has been updated";
				var eventType = original.Id == Guid.Empty ? NotificationTypeEnum.Created : NotificationTypeEnum.Updated;
				using (var txn = TransactionScopeHelper.Transaction())
				{

					host.Company.LastModified = host.LastModified;
					host.Company.UserName = host.UserName;
					host.Company.UserId = host.UserId;
					var savedHost = _hostRepository.Save(host);
					host.Company.HostId = savedHost.Id;
					var savedCompany = _companyService.SaveHostCompany(host.Company, savedHost);

					savedHost.CompanyId = savedCompany.Id;
					savedHost = _hostRepository.Save(savedHost);
					var memento = Memento<Models.Host>.Create(savedHost, EntityTypeEnum.Host, savedHost.UserName, string.Format("Host Update {0}", savedHost.FirmName), savedHost.UserId);
					_mementoDataService.AddMementoData(memento);
					txn.Complete();
					Bus.Publish<Notification>(new Notification
					{
						SavedObject = savedHost,
						SourceId = savedHost.Id,
						UserId = savedHost.UserId,
						Source = savedHost.UserName,
						TimeStamp = DateTime.Now,
						Roles = new List<RoleTypeEnum> { RoleTypeEnum.Master, RoleTypeEnum.CorpStaff, RoleTypeEnum.SuperUser },
						Text = string.Format("{0} by {1}", string.Format(notificationText, savedHost.FirmName), savedHost.UserName),
						ReturnUrl = "#!/?host=" + savedHost.FirmName,
						EventType = eventType
					});
				}
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, string.Format(" Host details for Id {0}", host.Id));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public HostHomePage GetHostHomePage(Guid hostId)
		{
			try
			{
				var hosthomepage = _hostRepository.GetHostHomePage(hostId);
				if (string.IsNullOrWhiteSpace(hosthomepage))
				{
					var homepage = new HostHomePage {Id = hostId};
					homepage.InitializeContactHours();
					return homepage;
				}
					
				return JsonConvert.DeserializeObject<HostHomePage>(hosthomepage);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" CPA Home Page details for Id {0}", hostId));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public HostHomePage SaveHomePage(Guid stagingId, Guid cpaId, HostHomePage homePage)
		{
			try
			{
				var hostImageMementos =
							 _stagingDataService.GetStagingData<HostHomePageStagingDocument>(stagingId);
				using (var txn = TransactionScopeHelper.Transaction())
				{
					
					if (hostImageMementos != null)
					{
						foreach (var hostImage in hostImageMementos)
						{
							var image = hostImage.Deserialize();
							if (image.ImageType)
								homePage.Contact = image.Document;
							else
							{
								homePage.Logo = image.Document;
							}
						}
					}
					
					_hostRepository.SaveHomePage(cpaId, JsonConvert.SerializeObject(homePage));
					_stagingDataService.DeleteStagingData<HostHomePageStagingDocument>(stagingId);
					
					
					txn.Complete();
					return homePage;
				}
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, string.Format(" CPA home page for Id {0}", cpaId));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void AddHomePageImageToStaging(HostHomePageDocument homePageDocument, string user)
		{
			DocumentDto document = Mapper.Map<HostHomePageDocument, DocumentDto>(homePageDocument);

			using (var txn = TransactionScopeHelper.Transaction())
			{
				var hosthomepagestagingdocument = new HostHomePageStagingDocument
				{
					Document = document,
					StagingId = homePageDocument.StagingId,
					HostId = homePageDocument.HostId,
					ImageType = homePageDocument.ImageType
				};
				var memento = Memento<HostHomePageStagingDocument>.Create(hosthomepagestagingdocument, EntityTypeEnum.HostHomePage, user);
				_stagingDataService.AddStagingData(memento);
				_documentService.MoveDocument(new MoveDocumentDto
				{
					SourceFileName = homePageDocument.SourceFileName,
					DestinationFileName = document.Id + "." + homePageDocument.FileExtension
				});
				
				txn.Complete();
			}
			
		}

		public object GetHostHomePageByUrl(string url, Guid hostId)
		{
			try
			{
				var host = _hostRepository.GetHostByUrl(url, hostId);
				var homepage = GetHostHomePage(host.Id);
				var address = _commonService.FirstRelatedEntity<Address>(EntityTypeEnum.Host, EntityTypeEnum.Address, host.Id);
				var newsfeed = _commonService.GetNewsforUser((int) RoleTypeEnum.Host, host.Id);
				return new {HostId=host.Id, HomePage=homepage, Address=address, Newsfeed = newsfeed};
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" Host home page for Url {0}", url));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public object GetNewsfeedMetaData(RoleTypeEnum role, Guid? entityId)
		{
			try
			{
				var hosts = _hostRepository.GetHostList(Guid.Empty).Select(h=>new {Key=h.Id, Value=h.FirmName}).ToList();
				return new {Hosts = hosts};
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" meta data for newsfeed"));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public object GetHostHomePageByFirmName(string firmName, Guid hostId)
		{
			try
			{
				var host = _hostRepository.GetHostByFirmName(firmName, hostId);
				var homepage = GetHostHomePage(host.Id);
				var address = _commonService.FirstRelatedEntity<Address>(EntityTypeEnum.Host, EntityTypeEnum.Address, host.Id);
				var newsfeed = _commonService.GetNewsforUser((int)RoleTypeEnum.Host, host.Id);
				return new { HostId = host.Id, HomePage = homepage, Address = address, Newsfeed = newsfeed };
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" Host home page for firm {0}", firmName));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public HostAndCompanies GetHostAndCompanies(Guid host, Guid company, string role)
		{
			throw new NotImplementedException();
		}
	}
}
