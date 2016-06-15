using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using HrMaxx.Common.Models.Enum;

namespace HrMaxxAPI.Resources.Common
{
	public class CommentResource : BaseRestResource
	{
		[Required]
		public string Content { get; set; }
		[Required]
		public EntityTypeEnum SourceTypeId { get; set; }
		[Required]
		public EntityTypeEnum TargetTypeId { get; set; }
		[Required]
		public Guid SourceId { get; set; }
	}
}