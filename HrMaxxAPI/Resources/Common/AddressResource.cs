using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using HrMaxx.Common.Models.Enum;

namespace HrMaxxAPI.Resources.Common
{
	public class AddressResource : BaseRestResource
	{
		[Required]
		public string AddressLine1 { get; set; }
		public string City { get; set; }
		[Required]
		public int StateId { get; set; }
		[Required]
		public int CountryId { get; set; }
		[Required]
		public string Zip { get; set; }
		public string ZipExtension { get; set; }
		public AddressType Type { get; set; }
		[Required]
		public EntityTypeEnum SourceTypeId { get; set; }
		[Required]
		public EntityTypeEnum TargetTypeId { get; set; }
		[Required]
		public Guid SourceId { get; set; }
		public string AddressLine2 { get; set; }
		
	}
}