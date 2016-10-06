using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
  public class ApplicationConfig
  {
		public Guid? RootHostId { get; set; }
		public decimal EnvironmentalChargeRate { get; set; }
		public List<string> Couriers { get; set; } 
		public List<InvoiceLateFeeConfig> InvoiceLateFeeConfigs { get; set; } 
		 
  }
	public class InvoiceLateFeeConfig
	{
		public int DaysFrom { get; set; }
		public int? DaysTo { get; set; }
		public decimal Rate { get; set; }
	}
}
