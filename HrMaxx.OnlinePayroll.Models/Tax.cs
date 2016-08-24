using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class Tax
	{
		public int Id { get; set; }
		public string Code { get; set; }
		public string Name { get; set; }
		public int CountryId { get; set; }
		public int? StateId { get; set; }
		public decimal? DefaultRate { get; set; }
		public decimal? Rate { get; set; }
		public decimal? AnnualMax { get; set; }
		public bool IsEmployeeTax { get; set; }
		public bool IsCompanySpecific { get; set; }
	}
}
