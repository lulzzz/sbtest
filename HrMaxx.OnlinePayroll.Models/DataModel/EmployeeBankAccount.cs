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
    
    public partial class EmployeeBankAccount
    {
        public int Id { get; set; }
        public System.Guid EmployeeId { get; set; }
        public int BankAccountId { get; set; }
        public decimal Percentage { get; set; }
    
        public virtual BankAccount BankAccount { get; set; }
        public virtual Employee Employee { get; set; }
    }
}
