using System;
using System.Collections;
using System.Collections.Generic;
using System.Web.Http;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxxAPI.Resources.Common;

namespace HrMaxxAPI.Controllers
{

	public class CommonController : BaseApiController
	{
		public readonly ICommonService _commonService;
		public CommonController(ICommonService commonService)
		{
			_commonService = commonService;
		}

		[HttpGet]
		[Route(HrMaxxRoutes.DeleteRelationship)]
		public void DeleteRelationship(int sourceTypeId, int targetTypeId, Guid sourceId, Guid targetId)
		{
			MakeServiceCall(() => _commonService.DeleteEntityRelation((EntityTypeEnum)sourceTypeId, (EntityTypeEnum)targetTypeId, sourceId, targetId), "Delete Entity Relationship");
		}

		[HttpGet]
		[Route(HrMaxxRoutes.GetAddresses)]
		public IList<Address> GetAddresses(int sourceTypeId, Guid sourceId)
		{
			return MakeServiceCall(() => _commonService.GetRelatedEntities<Address>((EntityTypeEnum)sourceTypeId, EntityTypeEnum.Address, sourceId), "Get Entity Addresses", true);
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
	}
}
