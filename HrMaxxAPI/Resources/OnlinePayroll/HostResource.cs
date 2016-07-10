using System;
using System.ComponentModel.DataAnnotations;
using HrMaxx.Common.Models.Enum;

namespace HrMaxxAPI.Resources.OnlinePayroll
{
	public class HostResource : BaseRestResource
	{
		[Required]
		public string FirmName { get; set; }
		[Required]
		public string Url { get; set; }
		[Required]
		public DateTime EffectiveDate { get; set; }
		public DateTime? TerminationDate { get; set; }
		[Required]
		public int StatusId { get; set; }
	}
}