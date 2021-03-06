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
    
    public partial class EmployeeDeduction
    {
        public int Id { get; set; }
        public System.Guid EmployeeId { get; set; }
        public int Method { get; set; }
        public Nullable<decimal> Rate { get; set; }
        public Nullable<decimal> AnnualMax { get; set; }
        public int CompanyDeductionId { get; set; }
        public Nullable<decimal> CeilingPerCheck { get; set; }
        public string AccountNo { get; set; }
        public Nullable<System.Guid> AgencyId { get; set; }
        public Nullable<int> Priority { get; set; }
        public Nullable<decimal> Limit { get; set; }
        public int CeilingMethod { get; set; }
        public Nullable<decimal> EmployerRate { get; set; }
        public string Note { get; set; }
        public Nullable<System.DateTime> StartDate { get; set; }
        public Nullable<System.DateTime> EndDate { get; set; }
    
        public virtual CompanyDeduction CompanyDeduction { get; set; }
        public virtual Employee Employee { get; set; }
    }
}
