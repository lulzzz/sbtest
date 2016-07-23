using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models.MetaDataModels
{
	public class TaxDefinition
	{
		public int Id { get; set; }
		public string Code { get; set; }
		public string Name { get; set; }
		public int CountryId { get; set; }
		public int? StateId { get; set; }
		public bool IsCompanySpecific { get; set; }
		public decimal DefaultRate { get; set; }
		public string PaidBy { get; set; }
	}
}
