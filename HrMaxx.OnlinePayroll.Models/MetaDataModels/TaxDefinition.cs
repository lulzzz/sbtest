using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models.MetaDataModels
{
	public class TaxDefinition : IEquatable<TaxDefinition>
	{
		public int Id { get; set; }
		public string Code { get; set; }
		public string Name { get; set; }
		public int CountryId { get; set; }
		public int? StateId { get; set; }
		public bool IsCompanySpecific { get; set; }
		public decimal DefaultRate { get; set; }
		public string PaidBy { get; set; }

		public bool Equals(TaxDefinition other)
		{
			if (this.Id == other.Id && this.Code == other.Code && this.Name == other.Name && this.CountryId == other.CountryId &&
			    this.StateId == other.StateId && this.IsCompanySpecific == other.IsCompanySpecific &&
			    this.DefaultRate == other.DefaultRate && this.PaidBy == other.PaidBy)
			{
				return true;
			}
			return false;
		}
	}
}
