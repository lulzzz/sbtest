using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class CheckBookMetaDataRequest
	{
		public Guid CompanyId { get; set; }
		public int CompanyIntId { get; set; }
		public Guid HostId { get; set; }
		public InvoiceSetup InvoiceSetup { get; set; }
		public Guid HostCompanyId { get; set; }
		public int HostCompanyIntId { get; set; }
	}
}
