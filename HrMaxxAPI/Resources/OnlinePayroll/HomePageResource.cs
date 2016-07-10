using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxxAPI.Resources.OnlinePayroll
{
	public class HomePageResource : BaseRestResource
	{
		[Required]
		public Guid StagingId { get; set; }
		public DocumentDto Logo { get; set; }
		public DocumentDto Contact { get; set; }
		[Required]
		public string Profile { get; set; }
		[Required]
		public string Services { get; set; }
		[Required]
		public string Email { get; set; }
		public string Telephone { get; set; }
		public string Fax { get; set; }
		public List<ContactHours> ContactHours { get; set; } 
	}
}