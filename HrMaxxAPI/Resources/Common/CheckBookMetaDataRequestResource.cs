using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using HrMaxxAPI.Resources.OnlinePayroll;

namespace HrMaxxAPI.Resources.Common
{
	public class CheckBookMetaDataRequestResource
	{
		[Required]
		public Guid CompanyId { get; set; }
		[Required]
		public Guid HostId { get; set; }
		[Required]
		public InvoiceSetupResource InvoiceSetup { get; set; }
		[Required]
		public Guid HostCompanyId { get; set; }
		[Required]
		public int CompanyIntId { get; set; }
		[Required]
		public int HostCompanyIntId { get; set; }
	}
}