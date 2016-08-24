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
    
    public partial class Journal
    {
        public int Id { get; set; }
        public int TransactionType { get; set; }
        public int PaymentMethod { get; set; }
        public int CheckNumber { get; set; }
        public Nullable<int> PayrollPayCheckId { get; set; }
        public int EntityType { get; set; }
        public System.Guid PayeeId { get; set; }
        public decimal Amount { get; set; }
        public string Memo { get; set; }
        public bool IsDebit { get; set; }
        public bool IsVoid { get; set; }
        public System.DateTime TransactionDate { get; set; }
        public System.DateTime LastModified { get; set; }
        public string LastModifiedBy { get; set; }
        public string JournalDetails { get; set; }
        public System.Guid CompanyId { get; set; }
        public string PayeeName { get; set; }
        public int MainAccountId { get; set; }
    
        public virtual EntityType EntityType1 { get; set; }
        public virtual PayrollPayCheck PayrollPayCheck { get; set; }
        public virtual Company Company { get; set; }
        public virtual CompanyAccount CompanyAccount { get; set; }
    }
}
