using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;

namespace HrMaxxAPI.Resources.Common
{
	public class ContactResource : BaseRestResource
	{
		[Required]
		public string FirstName { get; set; }
		[Required]
		public string LastName { get; set; }
		public string MiddleInitial { get; set; }
		[Required]
		public string Email { get; set; }
		public string Phone { get; set; }
		public string Mobile { get; set; }
		public string Fax { get; set; }
		public Address Address { get; set; }
		[Required]
		public EntityTypeEnum SourceTypeId { get; set; }
		[Required]
		public EntityTypeEnum TargetTypeId { get; set; }
		[Required]
		public Guid SourceId { get; set; }
		public bool IsPrimary { get; set; }
	}
}