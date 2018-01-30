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
    
    public partial class Company
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Company()
        {
            this.CompanyTaxRates = new HashSet<CompanyTaxRate>();
            this.CompanyTaxStates = new HashSet<CompanyTaxState>();
            this.CompanyContracts = new HashSet<CompanyContract>();
            this.CompanyDeductions = new HashSet<CompanyDeduction>();
            this.CompanyWorkerCompensations = new HashSet<CompanyWorkerCompensation>();
            this.CompanyAccumlatedPayTypes = new HashSet<CompanyAccumlatedPayType>();
            this.CompanyPayCodes = new HashSet<CompanyPayCode>();
            this.CompanyAccounts = new HashSet<CompanyAccount>();
            this.Employees = new HashSet<Employee>();
            this.Journals = new HashSet<Journal>();
            this.Hosts = new HashSet<Host>();
            this.VendorCustomers = new HashSet<VendorCustomer>();
            this.PayrollInvoices = new HashSet<PayrollInvoice>();
            this.Locations = new HashSet<Company>();
        }
    
        public System.Guid Id { get; set; }
        public string CompanyName { get; set; }
        public string CompanyNo { get; set; }
        public System.Guid HostId { get; set; }
        public int StatusId { get; set; }
        public bool IsVisibleToHost { get; set; }
        public bool FileUnderHost { get; set; }
        public bool DirectDebitPayer { get; set; }
        public int PayrollDaysInPast { get; set; }
        public int InsuranceGroupNo { get; set; }
        public string TaxFilingName { get; set; }
        public string CompanyAddress { get; set; }
        public string BusinessAddress { get; set; }
        public bool IsAddressSame { get; set; }
        public bool ManageTaxPayment { get; set; }
        public bool ManageEFileForms { get; set; }
        public string FederalEIN { get; set; }
        public string FederalPin { get; set; }
        public int DepositSchedule941 { get; set; }
        public int PayrollSchedule { get; set; }
        public int PayCheckStock { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModified { get; set; }
        public bool IsFiler944 { get; set; }
        public Nullable<System.DateTime> LastPayrollDate { get; set; }
        public decimal MinWage { get; set; }
        public bool IsHostCompany { get; set; }
        public string Memo { get; set; }
        public string ClientNo { get; set; }
        public System.DateTime Created { get; set; }
        public Nullable<System.Guid> ParentId { get; set; }
        public string Notes { get; set; }
        public string PayrollMessage { get; set; }
        public bool IsFiler1095 { get; set; }
        public int CompanyIntId { get; set; }
    
        public virtual Host Host { get; set; }
        public virtual Status Status { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CompanyTaxRate> CompanyTaxRates { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CompanyTaxState> CompanyTaxStates { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CompanyContract> CompanyContracts { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CompanyDeduction> CompanyDeductions { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CompanyWorkerCompensation> CompanyWorkerCompensations { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CompanyAccumlatedPayType> CompanyAccumlatedPayTypes { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CompanyPayCode> CompanyPayCodes { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CompanyAccount> CompanyAccounts { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Employee> Employees { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Journal> Journals { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Host> Hosts { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VendorCustomer> VendorCustomers { get; set; }
        public virtual InsuranceGroup InsuranceGroup { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PayrollInvoice> PayrollInvoices { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Company> Locations { get; set; }
        public virtual Company Parent { get; set; }
    }
}
