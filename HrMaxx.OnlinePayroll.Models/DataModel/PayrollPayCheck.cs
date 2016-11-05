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
    
    public partial class PayrollPayCheck
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public PayrollPayCheck()
        {
            this.Journals = new HashSet<Journal>();
            this.PayCheckExtracts = new HashSet<PayCheckExtract>();
        }
    
        public int Id { get; set; }
        public System.Guid PayrollId { get; set; }
        public System.Guid CompanyId { get; set; }
        public System.Guid EmployeeId { get; set; }
        public string Employee { get; set; }
        public decimal GrossWage { get; set; }
        public decimal NetWage { get; set; }
        public string Compensations { get; set; }
        public string Deductions { get; set; }
        public string Taxes { get; set; }
        public string PayCodes { get; set; }
        public int Status { get; set; }
        public bool IsVoid { get; set; }
        public int PrintStatus { get; set; }
        public System.DateTime StartDate { get; set; }
        public System.DateTime EndDate { get; set; }
        public System.DateTime PayDay { get; set; }
        public int CheckNumber { get; set; }
        public int PaymentMethod { get; set; }
        public string Notes { get; set; }
        public decimal WCAmount { get; set; }
        public decimal DeductionAmount { get; set; }
        public decimal EmployeeTaxes { get; set; }
        public decimal EmployerTaxes { get; set; }
        public int PayrmentMethod { get; set; }
        public decimal Salary { get; set; }
        public decimal YTDSalary { get; set; }
        public decimal YTDGrossWage { get; set; }
        public decimal YTDNetWage { get; set; }
        public string Accumulations { get; set; }
        public System.DateTime LastModified { get; set; }
        public string LastModifiedBy { get; set; }
        public string WorkerCompensation { get; set; }
        public bool PEOASOCoCheck { get; set; }
        public Nullable<System.Guid> InvoiceId { get; set; }
        public Nullable<System.DateTime> VoidedOn { get; set; }
        public Nullable<System.Guid> CreditInvoiceId { get; set; }
    
        public virtual Payroll Payroll { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Journal> Journals { get; set; }
        public virtual PayrollInvoice PayrollInvoice { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PayCheckExtract> PayCheckExtracts { get; set; }
    }
}
