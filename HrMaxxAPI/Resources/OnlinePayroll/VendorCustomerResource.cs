using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxxAPI.Resources.OnlinePayroll
{
	public class VendorCustomerResource : BaseRestResource
	{
		public Guid? CompanyId { get; set; }
		[Required]
		public string Name { get; set; }
		[Required]
		public StatusOption StatusId { get; set; }
		public string AccountNo { get; set; }
		[Required]
		public bool IsVendor { get; set; }
		[Required]
		public Contact Contact { get; set; }
		public string Note { get; set; }
		public F1099Type? Type1099 { get; set; }
		public F1099SubType? SubType1099 { get; set; }
		public VCIdentifierType? IdentifierType { get; set; }
		public string IndividualSSN { get; set; }
		public string BusinessFIN { get; set; }
		public bool IsVendor1099 { get; set; }
		public bool IsTaxDepartment { get; set; }
		public bool IsAgency { get; set; }

		public string StatusText
		{
			get { return StatusId.GetDbName(); }
		}
	}
}