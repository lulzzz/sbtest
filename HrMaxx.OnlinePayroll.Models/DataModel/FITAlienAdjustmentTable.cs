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
    
    public partial class FITAlienAdjustmentTable
    {
        public int Id { get; set; }
        public int PayrollPeriodId { get; set; }
        public decimal Amount { get; set; }
        public int Year { get; set; }
        public bool Pre2020 { get; set; }
    }
}
