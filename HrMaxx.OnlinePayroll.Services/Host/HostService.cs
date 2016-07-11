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
		public IBus Bus { get; set; }

		public HostService(IHostRepository hostRepository, IStagingDataService stagingDataService, IDocumentService documentService, ICommonService commonService)
		{
			_hostRepository = hostRepository;
			_stagingDataService = stagingDataService;
			_documentService = documentService;
			_commonService = commonService;
		}
		public IList<Models.Host> GetHostList()
		{
			try
			{
				return _hostRepository.GetHostList();
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
				var notificationText = original == null ? "A new Host {0} has been created" : "{0} has been updated";
				_hostRepository.Save(host);
				Bus.Publish<Notification>(new Notification
				{
					SavedObject = host,
					SourceId = host.Id,
					UserId = host.UserId,
					Source = host.UserName,
					TimeStamp = DateTime.Now,
					Roles = new List<RoleTypeEnum> { RoleTypeEnum.Master, RoleTypeEnum.Admin },
					Text = string.Format("{0} by {1}", string.Format(notificationText, host.FirmName), host.UserName),
					ReturnUrl = "#/?host="+host.FirmName

				});
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
				using (var txn = TransactionScopeHelper.Transaction())
				{
					var hostImageMementos =
							_stagingDataService.GetStagingData<HostHomePageStagingDocument>(stagingId);
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

		public void AddHomePageImageToStaging(HostHomePageDocument homePageDocument)
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
				var memento = Memento<HostHomePageStagingDocument>.Create(hosthomepagestagingdocument);
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
				var hosts = _hostRepository.GetHostList().Select(h=>new {Key=h.Id, Value=h.FirmName}).ToList();
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
	}
}
