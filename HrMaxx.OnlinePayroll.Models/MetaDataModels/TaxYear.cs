using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models.MetaDataModels
{
	public class TaxByYear : IEquatable<TaxByYear>
	{
		public int Id { get; set; }
		public TaxDefinition Tax { get; set; }
		public int TaxYear { get; set; }
		public decimal? Rate { get; set; }
		public decimal? AnnualMaxPerEmployee { get; set; }

        public decimal? WeeklyMaxWage { get; set; }
        public decimal? TaxRateLimit { get; set; }
		public bool HasChanged { get; set; }

		public bool IsFederal
		{
			get { return !Tax.StateId.HasValue; }
		}
		public bool IsState
		{
			get { return Tax.StateId.HasValue; }
		}

		public bool Equals(TaxByYear other)
		{
			if (this.Id == other.Id && this.TaxYear == other.TaxYear && this.Rate == other.Rate &&
					this.AnnualMaxPerEmployee == other.AnnualMaxPerEmployee && this.TaxRateLimit == other.TaxRateLimit &&
                    this.WeeklyMaxWage == other.WeeklyMaxWage &&
                    this.IsFederal == other.IsFederal && this.IsState == other.IsState && this.Tax.Equals(other.Tax))
			{
				return true;
			}
			return false;
		}
	}
}
