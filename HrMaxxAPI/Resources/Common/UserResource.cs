using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;

namespace HrMaxxAPI.Resources.Common
{
	public class UserResource : BaseRestResource
	{
		public Guid? UserId { get; set; }
		[Required]
		public string FirstName { get; set; }
		[Required]
		public string LastName { get; set; }
		[Required]
		public string Email { get; set; }
		[Required]
		public string UserName { get; set; }
		public string Phone { get; set; }
		public EntityTypeEnum? SourceTypeId { get; set; }
		public Guid? HostId { get; set; }
		public Guid? CompanyId { get; set; }
		public Guid? EmployeeId { get; set; }
		public bool Active { get; set; }
		
	}
}