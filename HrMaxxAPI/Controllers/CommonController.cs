using System;
using System.Collections;
using System.Collections.Generic;
using System.Web.Mvc;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.USTaxModels;
using HrMaxxAPI.Resources.Common;
using HrMaxxAPI.Resources.OnlinePayroll;

namespace HrMaxxAPI.Controllers
{

	public class CommonController : BaseApiController
	{
		public readonly ICommonService _commonService;
		public readonly IMetaDataService _metaDataService;
		private readonly IMementoDataService _mementoDataService;
		private readonly IReaderService _readerService;
		private readonly ITaxationService _taxationService;
		private readonly IEmailService _emailService;
		
		public CommonController(ICommonService commonService, IMetaDataService metaDataService, IMementoDataService mementoDataService, IReaderService readerService, ITaxationService taxationService, IEmailService emailService)
		{
			_commonService = commonService;
			_metaDataService = metaDataService;
			_mementoDataService = mementoDataService;
			_readerService = readerService;
			_taxationService = taxationService;
			_emailService = emailService;
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.SendTestEmail)]
		public void SendTestEmail(string email)
		{
			MakeServiceCall(() => _emailService.SendEmail("sherjeel.bedaar@gmail.com", "Test Email", "this is test Email"), "Test Email", true);
		}
		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.BankHolidays)]
		public IList<KeyValuePair<int, DateTime>> GetBankHolidays()
		{
			return MakeServiceCall(() => _metaDataService.GetBankHolidays(), "Get Bank Holidays in the System", true);
		}
		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.BankHoliday)]
		public object SaveBankHoliday(string holiday, bool action1)
		{
			return MakeServiceCall(() => _metaDataService.SaveBankHoliday(DateTime.ParseExact(holiday, "ddMMyyyy", null), action1), "save Bank Holidays in the System", true);
			
		}
		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.DeductionTypes)]
		public IList<DeductionType> GetDeductionTypes()
		{
			return MakeServiceCall(() => _metaDataService.GetDeductionTypes(), "Get Deduction Types in the System", true);
		}
		[HttpPost	]
		[System.Web.Http.Route(HrMaxxRoutes.SaveDeductionType)]
		public DeductionType SaveDeductionType(DeductionType dt)
		{
			return MakeServiceCall(() => _metaDataService.SaveDeductionType(dt), "save Deduction Types in the System", true);
		}
		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(HrMaxxRoutes.SaveDocumentType)]
		public CompanyDocumentSubType SaveDocumentType(CompanyDocumentSubType subType)
		{
			return MakeServiceCall(() => _metaDataService.SaveDocumentSubType(subType), "save document sub stype");

		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.DocumentsMetaData)]
		public DocumentServiceMetaData GetDocumentServiceMetaData(Guid companyId)
		{
			return MakeServiceCall(() => _metaDataService.GetDocumentServiceMetaData(companyId), "Documents Meta Data", true);
		}
		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.EmployeeDocumentsMetaData)]
		public EmployeeDocumentMetaData GetEmployeeDocumentsMetaData(Guid companyId, Guid employeeId)
		{
			return MakeServiceCall(() => _metaDataService.GetEmployeeDocumentServiceMetaData(companyId, employeeId), "Documents Meta Data for Employees", true);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.AccountsMetaData)]
		public object GetAccountsMetaData()
		{
			return MakeServiceCall(() => _metaDataService.GetAccountsMetaData(), "Accounts Meta Data", true);
		}
		
		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.DeleteRelationship)]
		public void DeleteRelationship(int sourceTypeId, int targetTypeId, Guid sourceId, Guid targetId)
		{
			MakeServiceCall(() => _commonService.DeleteEntityRelation((EntityTypeEnum)sourceTypeId, (EntityTypeEnum)targetTypeId, sourceId, targetId), "Delete Entity Relationship");
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.Addresses)]
		public IList<Address> Addresses(int sourceTypeId, Guid sourceId)
		{
			return MakeServiceCall(() => _commonService.GetRelatedEntities<Address>((EntityTypeEnum)sourceTypeId, EntityTypeEnum.Address, sourceId), "Get Entity Addresses", true);
		}
		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.FirstAddress)]
		public Address FirstAddress(int sourceTypeId, Guid sourceId)
		{
			var address = MakeServiceCall(() => _commonService.FirstRelatedEntity<Address>((EntityTypeEnum)sourceTypeId, EntityTypeEnum.Address, sourceId), "Get First Entity Address", true);
			return address;
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.Documents)]
		public IList<DocumentDto> Documents(int sourceTypeId, Guid sourceId)
		{
			return MakeServiceCall(() => _commonService.GetRelatedEntities<DocumentDto>((EntityTypeEnum)sourceTypeId, EntityTypeEnum.Document, sourceId), "Get Entity Documents", true);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.Comments)]
		public IList<Comment> Comments(int sourceTypeId, Guid sourceId)
		{
			return MakeServiceCall(() => _commonService.GetRelatedEntityList<Comment>((EntityTypeEnum)sourceTypeId, EntityTypeEnum.Comment, sourceId), "Get Entity Comments", true);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.Contacts)]
		public IList<Contact> Contacts(int sourceTypeId, Guid sourceId)
		{
			return MakeServiceCall(() => _commonService.GetRelatedEntities<Contact>((EntityTypeEnum)sourceTypeId, EntityTypeEnum.Contact, sourceId), "Get Entity Contcats", true);
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(HrMaxxRoutes.SaveComment)]
		public Comment SaveComment(CommentResource resource)
		{
			var comment = Mapper.Map<CommentResource, Comment>(resource);
			return MakeServiceCall(() => _commonService.AddToList<Comment>(resource.SourceTypeId, EntityTypeEnum.Comment, resource.SourceId, comment), "Add Comment to List of Comments", true);
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(HrMaxxRoutes.SaveContact)]
		public Contact SaveContact(ContactResource resource)
		{
			var contact = Mapper.Map<ContactResource, Contact>(resource);
			return MakeServiceCall(() => _commonService.SaveEntityRelation<Contact>(resource.SourceTypeId, EntityTypeEnum.Contact, resource.SourceId, contact), "Add contact", true);
		}
		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(HrMaxxRoutes.SaveAddress)]
		public Address SaveAddress(AddressResource resource)
		{
			var address = Mapper.Map<AddressResource, Address>(resource);
			return MakeServiceCall(() => _commonService.SaveEntityRelation<Address>(resource.SourceTypeId, EntityTypeEnum.Address, resource.SourceId, address), "Add Address", true);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.Newsfeed)]
		public List<NewsResource> GetNewsfeed(int? audienceScope, Guid? audienceId = null)
		{
			var news = MakeServiceCall(() => _commonService.GetNewsforUser(audienceScope, audienceId), "get newsfeed", true);
			return Mapper.Map<List<News>, List<NewsResource>>(news);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.UserNewsfeed)]
		public List<NewsResource> GetUserNewsfeed()
		{
			var news = MakeServiceCall(() => _commonService.GetUserNewsfeed(CurrentUser.Host, CurrentUser.Company, CurrentUser.UserId, CurrentUser.Role), "get newsfeed for current user", true);
			return Mapper.Map<List<News>, List<NewsResource>>(news);
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(HrMaxxRoutes.SaveNewsfeed)]
		public NewsResource SaveNewsfeed(NewsResource resource)
		{
			var news = Mapper.Map<NewsResource, News>(resource);
			MakeServiceCall(() => _commonService.SaveNewsItem(news), "save newsfeed");
			return Mapper.Map<News, NewsResource>(news);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.InsuranceGroups)]
		public List<InsuranceGroupDto> GetInsuranceGroups()
		{
			return MakeServiceCall(() => _commonService.GetInsuranceGroups(), "get insurance groups ", true);
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(HrMaxxRoutes.InsuranceGroup)]
		public InsuranceGroupDto SaveInsuranceGroup(InsuranceGroupDto resource)
		{
			return MakeServiceCall(() => _commonService.SaveInsuranceGroup(resource), "save insurance group ", true);
		}
		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.Mementos)]
		public List<object> GetMementos(Guid sourceId, int sourceTypeId)
		{
			return MakeServiceCall(() => _mementoDataService.GetMementos((EntityTypeEnum)sourceTypeId, sourceId), "get mementos for source type " + sourceTypeId, true);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.FillSearchTable)]
		public List<SearchResult> FillSearchTable()
		{
			return MakeServiceCall(() => _metaDataService.FillSearchTable(), "fill search table", true);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.GetHostsAndCompanies)]
		public HostAndCompaniesResource GetHostsAndCompanies(int? status = 1, Guid? company = null)
		{
			var paramList = new List<FilterParam>
			{
				new FilterParam() {Key = "host", Value = CurrentUser.Host==Guid.Empty ? null : CurrentUser.Host.ToString()},
				new FilterParam() {Key = "status", Value = status.ToString()},
				new FilterParam() {Key = "company", Value = CurrentUser.Company==Guid.Empty ? company.HasValue ? company.Value.ToString(): default(Guid?).ToString() : CurrentUser.Company.ToString()},
				new FilterParam() {Key = "role", Value = (CurrentUser.Role==RoleTypeEnum.Master.GetDbName() ||CurrentUser.Role==RoleTypeEnum.SuperUser.GetDbName()) ? null : CurrentUser.Role}
			};

			var data = MakeServiceCall(() => _readerService.GetDataFromStoredProc<HostAndCompanies>("GetHostAndCompanies", paramList), "fill search table", true);
			return Mapper.Map<HostAndCompanies, HostAndCompaniesResource>(data);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.GetTaxTableYear)]
		public List<int> GetTaxTableYear()
		{
			return MakeServiceCall(() => _taxationService.GetTaxTableYears(), "Tax Tables Years", true);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.GetTaxes)]
		public USTaxTables GetTaxes(int year)
		{
			return MakeServiceCall(() => _taxationService.GetTaxTables(year), "Tax Tables", true);
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(HrMaxxRoutes.SaveTaxes)]
		public USTaxTables SaveTaxes(SaveTaxesResource resource)
		{
			return MakeServiceCall(() => _taxationService.SaveTaxTables(resource.Year, resource.TaxTables), "Save Tax Tables", true);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.CreateTaxes)]
		public USTaxTables CreateTaxes(int year)
		{
			return MakeServiceCall(() => _taxationService.CreateTaxes(year), "create entries in Tax Tables for year " + year, true);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.AccessMetaData)]
		public List<Access> AccessMetaData()
		{
			return MakeServiceCall(() => _metaDataService.GetAccessMetaData(), "get access meta data", true);
		}
	}
}
