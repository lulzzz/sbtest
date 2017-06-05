using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;

namespace HrMaxx.OnlinePayroll.Models.USTaxModels
{
	public class TaxDeductionPrecendence : IEquatable<TaxDeductionPrecendence>
	{
		public string TaxCode { get; set; }
		public int DeductionTypeId { get; set; }
		public bool Equals(TaxDeductionPrecendence other)
		{
			return this.TaxCode == other.TaxCode && this.DeductionTypeId == other.DeductionTypeId;
		}
	}
}
