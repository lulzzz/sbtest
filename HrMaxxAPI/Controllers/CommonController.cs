using System;
using System.Collections;
using System.Collections.Generic;
using System.Web.Http;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxxAPI.Resources.Common;

namespace HrMaxxAPI.Controllers
{

	public class CommonController : BaseApiController
	{
		public readonly ICommonService _commonService;
		public readonly IMetaDataService _metaDataService;
		private readonly IMementoDataService _mementoDataService;
		
		public CommonController(ICommonService commonService, IMetaDataService metaDataService, IMementoDataService mementoDataService)
		{
			_commonService = commonService;
			_metaDataService = metaDataService;
			_mementoDataService = mementoDataService;
		}

		[HttpGet]
		[Route(HrMaxxRoutes.AccountsMetaData)]
		public object GetAccountsMetaData()
		{
			return MakeServiceCall(() => _metaDataService.GetAccountsMetaData(), "Accounts Meta Data", true);
		}
		
		[HttpGet]
		[Route(HrMaxxRoutes.DeleteRelationship)]
		public void DeleteRelationship(int sourceTypeId, int targetTypeId, Guid sourceId, Guid targetId)
		{
			MakeServiceCall(() => _commonService.DeleteEntityRelation((EntityTypeEnum)sourceTypeId, (EntityTypeEnum)targetTypeId, sourceId, targetId), "Delete Entity Relationship");
		}

		[HttpGet]
		[Route(HrMaxxRoutes.Addresses)]
		public IList<Address> Addresses(int sourceTypeId, Guid sourceId)
		{
			return MakeServiceCall(() => _commonService.GetRelatedEntities<Address>((EntityTypeEnum)sourceTypeId, EntityTypeEnum.Address, sourceId), "Get Entity Addresses", true);
		}
		[HttpGet]
		[Route(HrMaxxRoutes.FirstAddress)]
		public Address FirstAddress(int sourceTypeId, Guid sourceId)
		{
			var address = MakeServiceCall(() => _commonService.FirstRelatedEntity<Address>((EntityTypeEnum)sourceTypeId, EntityTypeEnum.Address, sourceId), "Get First Entity Address", true);
			return address;
		}

		[HttpGet]
		[Route(HrMaxxRoutes.Documents)]
		public IList<DocumentDto> Documents(int sourceTypeId, Guid sourceId)
		{
			return MakeServiceCall(() => _commonService.GetRelatedEntities<DocumentDto>((EntityTypeEnum)sourceTypeId, EntityTypeEnum.Document, sourceId), "Get Entity Documents", true);
		}

		[HttpGet]
		[Route(HrMaxxRoutes.Comments)]
		public IList<Comment> Comments(int sourceTypeId, Guid sourceId)
		{
			return MakeServiceCall(() => _commonService.GetRelatedEntityList<Comment>((EntityTypeEnum)sourceTypeId, EntityTypeEnum.Comment, sourceId), "Get Entity Comments", true);
		}

		[HttpGet]
		[Route(HrMaxxRoutes.Contacts)]
		public IList<Contact> Contacts(int sourceTypeId, Guid sourceId)
		{
			return MakeServiceCall(() => _commonService.GetRelatedEntities<Contact>((EntityTypeEnum)sourceTypeId, EntityTypeEnum.Contact, sourceId), "Get Entity Contcats", true);
		}

		[HttpPost]
		[Route(HrMaxxRoutes.SaveComment)]
		public Comment SaveComment(CommentResource resource)
		{
			var comment = Mapper.Map<CommentResource, Comment>(resource);
			return MakeServiceCall(() => _commonService.AddToList<Comment>(resource.SourceTypeId, EntityTypeEnum.Comment, resource.SourceId, comment), "Add Comment to List of Comments", true);
		}

		[HttpPost]
		[Route(HrMaxxRoutes.SaveContact)]
		public Contact SaveContact(ContactResource resource)
		{
			var contact = Mapper.Map<ContactResource, Contact>(resource);
			return MakeServiceCall(() => _commonService.SaveEntityRelation<Contact>(resource.SourceTypeId, EntityTypeEnum.Contact, resource.SourceId, contact), "Add contact", true);
		}
		[HttpPost]
		[Route(HrMaxxRoutes.SaveAddress)]
		public Address SaveAddress(AddressResource resource)
		{
			var address = Mapper.Map<AddressResource, Address>(resource);
			return MakeServiceCall(() => _commonService.SaveEntityRelation<Address>(resource.SourceTypeId, EntityTypeEnum.Address, resource.SourceId, address), "Add Address", true);
		}

		[HttpGet]
		[Route(HrMaxxRoutes.Newsfeed)]
		public List<NewsResource> GetNewsfeed(int? audienceScope, Guid? audienceId = null)
		{
			var news = MakeServiceCall(() => _commonService.GetNewsforUser(audienceScope, audienceId), "get newsfeed", true);
			return Mapper.Map<List<News>, List<NewsResource>>(news);
		}

		[HttpGet]
		[Route(HrMaxxRoutes.UserNewsfeed)]
		public List<NewsResource> GetUserNewsfeed()
		{
			var news = MakeServiceCall(() => _commonService.GetUserNewsfeed(CurrentUser.Host, CurrentUser.Company, CurrentUser.UserId, CurrentUser.Role), "get newsfeed for current user", true);
			return Mapper.Map<List<News>, List<NewsResource>>(news);
		}

		[HttpPost]
		[Route(HrMaxxRoutes.SaveNewsfeed)]
		public NewsResource SaveNewsfeed(NewsResource resource)
		{
			var news = Mapper.Map<NewsResource, News>(resource);
			MakeServiceCall(() => _commonService.SaveNewsItem(news), "save newsfeed");
			return Mapper.Map<News, NewsResource>(news);
		}

		[HttpGet]
		[Route(HrMaxxRoutes.InsuranceGroups)]
		public List<InsuranceGroupDto> GetInsuranceGroups()
		{
			return MakeServiceCall(() => _commonService.GetInsuranceGroups(), "get insurance groups ", true);
		}

		[HttpPost]
		[Route(HrMaxxRoutes.InsuranceGroup)]
		public InsuranceGroupDto SaveInsuranceGroup(InsuranceGroupDto resource)
		{
			return MakeServiceCall(() => _commonService.SaveInsuranceGroup(resource), "save insurance group ", true);
		}
		[HttpGet]
		[Route(HrMaxxRoutes.Mementos)]
		public List<object> GetMementos(Guid sourceId, int sourceTypeId)
		{
			return MakeServiceCall(() => _mementoDataService.GetMementos((EntityTypeEnum)sourceTypeId, sourceId), "get mementos for source type " + sourceTypeId, true);
		}

		[HttpGet]
		[Route(HrMaxxRoutes.FillSearchTable)]
		public List<SearchResult> FillSearchTable()
		{
			return MakeServiceCall(() => _metaDataService.FillSearchTable(), "fill search table", true);
		}
	}
}
