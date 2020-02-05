using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models.USTaxModels
{
    public class MinWageYearRow : IEquatable<MinWageYearRow>
    {
        public int Id { get; set; }
        public int Year { get; set; }
        public int? StateId { get; set; }
        
        public decimal MinWage { get; set; }
        public decimal TippedMinWage { get; set; }
        public decimal MaxTipCredit { get; set; }
        public bool HasChanged { get; set; }
        public bool Equals(MinWageYearRow other)
        {
            if (this.Id == other.Id && this.StateId == other.StateId && 
                this.MinWage == other.MinWage && this.TippedMinWage == other.TippedMinWage && this.Year == other.Year 
                && this.MaxTipCredit == other.MaxTipCredit)
                return true;
            return false;

        }

        public string StateText { get { return StateId.HasValue ? ((States)StateId).GetDbName() : "Federal"; } }
    }
}
