//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace HrMaxx.OnlinePayroll.Models.DataModel
{
    using System;
    using System.Collections.Generic;
    
    public partial class FITTaxTable
    {
        public int Id { get; set; }
        public Nullable<int> PayrollPeriodID { get; set; }
        public string FilingStatus { get; set; }
        public Nullable<decimal> StartRange { get; set; }
        public Nullable<decimal> EndRange { get; set; }
        public Nullable<decimal> FlatRate { get; set; }
        public Nullable<decimal> AdditionalPercentage { get; set; }
        public Nullable<decimal> ExcessOvrAmt { get; set; }
        public Nullable<int> Year { get; set; }
        public bool ForMultiJobs { get; set; }
    }
}
