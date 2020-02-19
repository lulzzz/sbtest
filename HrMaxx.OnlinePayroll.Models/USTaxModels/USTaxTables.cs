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
		public List<int> Years { get; set; } 
		public List<TaxByYear> Taxes { get; set; }
		public List<FITTaxTableRow> FITTaxTable { get; set; }
		public List<FITWithholdingAllowanceTableRow> FitWithholdingAllowanceTable { get; set; }
		public List<FITW4TaxTableRow> FITW4Table { get; set; }
		public List<CASITTaxTableRow> CASITTaxTable { get; set; }
		public List<CASITLowIncomeTaxTableRow> CASITLowIncomeTaxTable { get; set; }
		public List<CAStandardDeductionTableRow> CAStandardDeductionTable { get; set; }
		public List<EstimatedDeductionTableRow> EstimatedDeductionTable { get; set; }
		public List<ExemptionAllowanceTableRow> ExemptionAllowanceTable { get; set; }
		public List<TaxDeductionPrecendence> TaxDeductionPrecendences { get; set; }
        public List<FITTaxTableRow> HISITTaxTable { get; set; }
        public List<FITWithholdingAllowanceTableRow> HISitWithholdingAllowanceTable { get; set; }
        public List<FITAlienAdjustmentTableRow> FITAlienAdjustmentTable { get; set; }

		public List<MinWageYearRow> MinWageYearTable { get; set; }
		public List<MTSITTaxTableRow> MTSITTaxTable { get; set; }
		public List<MTSITExemptionConstantTableRow> MTSITExemptionConstantTable { get; set; }
	}
}
