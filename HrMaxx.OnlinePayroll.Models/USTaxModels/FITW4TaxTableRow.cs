using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models.USTaxModels
{
    public class FITW4TaxTableRow : IEquatable<FITW4TaxTableRow>
    {
        public int Id { get; set; }
        public USFederalFilingStatus FilingStatus { get; set; }
        public decimal DependentWageLimit { get; set; }
        public decimal DependentAllowance1 { get; set; }
        public decimal DependentAllowance2 { get; set; }
        public decimal AdditionalDeductionW4 { get; set; }
        public decimal DeductionForExemption { get; set; }
        public int Year { get; set; }
        public bool HasChanged { get; set; }
        public string FilingStatusText { get { return FilingStatus.GetDbName(); } }
        public bool Equals(FITW4TaxTableRow other)
        {
            if (this.Id == other.Id && this.FilingStatus == other.FilingStatus &&
                this.DependentWageLimit == other.DependentWageLimit && this.DependentAllowance1 == other.DependentAllowance1 && this.DependentAllowance2 == other.DependentAllowance2 &&
                    this.AdditionalDeductionW4 == other.AdditionalDeductionW4 && this.DeductionForExemption == other.DeductionForExemption && this.Year == other.Year)
                return true;
            return false;

        }
    }
}
