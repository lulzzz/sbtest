using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;

namespace HrMaxx.OnlinePayroll.Models.USTaxModels
{
	public class USTaxTables
	{
		public List<TaxByYear> Taxes { get; set; }
		public List<FITTaxTableRow> FITTaxTable { get; set; }
		public List<FITWithholdingAllowanceTableRow> FitWithholdingAllowanceTable { get; set; }
		public List<CASITTaxTableRow> CASITTaxTable { get; set; }
		public List<CASITLowIncomeTaxTableRow> CASITLowIncomeTaxTable { get; set; }
		public List<CAStandardDeductionTableRow> CAStandardDeductionTable { get; set; }
		public List<EstimatedDeductionTableRow> EstimatedDeductionTable { get; set; }
		public List<ExemptionAllowanceTableRow> ExemptionAllowanceTable { get; set; }
		public List<TaxDeductionPrecendence> TaxDeductionPrecendences { get; set; } 
	}
}
