using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models.MetaDataModels
{
	public class TaxByYear
	{
		public int Id { get; set; }
		public TaxDefinition Tax { get; set; }
		public int TaxYear { get; set; }
		public decimal? Rate { get; set; }
		public decimal? AnnualMaxPerEmployee { get; set; }
		public decimal? TaxRateLimit { get; set; }

	}
}
