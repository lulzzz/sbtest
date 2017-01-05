using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class CompanySUIRate
	{
		public Guid Id { get; set; }
		public string CompanyNo { get; set; }
		public string Name { get; set; }
		public List<CompanyTaxRate> TaxRates { get; set; } 
		public decimal SUIManagementRate { get; set; }
	}
}
