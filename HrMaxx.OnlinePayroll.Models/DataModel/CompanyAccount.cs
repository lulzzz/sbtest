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
    
    public partial class CompanyAccount
    {
        public int Id { get; set; }
        public System.Guid CompanyId { get; set; }
        public int Type { get; set; }
        public int SubType { get; set; }
        public string Name { get; set; }
        public string TaxCode { get; set; }
        public Nullable<int> TemplateId { get; set; }
        public Nullable<decimal> OpeningBalance { get; set; }
        public Nullable<int> BankAccountId { get; set; }
        public System.DateTime LastModified { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime OpeningDate { get; set; }
    
        public virtual AccountTemplate AccountTemplate { get; set; }
        public virtual BankAccount BankAccount { get; set; }
        public virtual Company Company { get; set; }
    }
}
