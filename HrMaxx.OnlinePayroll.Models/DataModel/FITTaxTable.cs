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
        public Nullable<double> StartRange { get; set; }
        public Nullable<double> EndRange { get; set; }
        public Nullable<double> FlatRate { get; set; }
        public Nullable<double> AdditionalPercentage { get; set; }
        public Nullable<double> ExcessOvrAmt { get; set; }
        public Nullable<int> Year { get; set; }
    }
}
