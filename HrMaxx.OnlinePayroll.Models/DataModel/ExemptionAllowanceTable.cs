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
    
    public partial class ExemptionAllowanceTable
    {
        public int Id { get; set; }
        public Nullable<int> PayrollPeriodID { get; set; }
        public Nullable<int> NoOfAllowances { get; set; }
        public Nullable<decimal> Amount { get; set; }
        public Nullable<int> Year { get; set; }
    }
}
