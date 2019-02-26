using System;
using System.ComponentModel.DataAnnotations;
using HrMaxx.Common.Models.Enum;

namespace HrMaxxAPI.Resources.OnlinePayroll
{
	public class HostResource : BaseRestResource
	{
		public int HostIntId { get; set; }
		[Required]
		public string FirmName { get; set; }
		[Required]
		public string Url { get; set; }
		[Required]
		public DateTime EffectiveDate { get; set; }
		public DateTime? TerminationDate { get; set; }
		[Required]
		public int StatusId { get; set; }
		[Required]
		public CompanyResource Company { get; set; }
		public Guid? CompanyId { get; set; }
		public string PTIN { get; set; }
		public string DesigneeName940941 { get; set; }
		public string PIN940941 { get; set; }
		public bool IsPeoHost { get; set; }
		public string BankCustomerId { get; set; }

		public HomePageResource HomePage { get; set; }
	}
}