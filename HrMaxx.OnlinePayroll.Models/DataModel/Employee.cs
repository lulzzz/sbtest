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
    
    public partial class Employee
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Employee()
        {
            this.EmployeeDeductions = new HashSet<EmployeeDeduction>();
        }
    
        public System.Guid Id { get; set; }
        public System.Guid CompanyId { get; set; }
        public int StatusId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string MiddleInitial { get; set; }
        public string Contact { get; set; }
        public int Gender { get; set; }
        public string SSN { get; set; }
        public System.DateTime BirthDate { get; set; }
        public System.DateTime HireDate { get; set; }
        public string Department { get; set; }
        public string EmployeeNo { get; set; }
        public string Memo { get; set; }
        public int PayrollSchedule { get; set; }
        public int PayType { get; set; }
        public decimal Rate { get; set; }
        public string PayCodes { get; set; }
        public string Compensations { get; set; }
        public int PaymentMethod { get; set; }
        public Nullable<int> BankAccountId { get; set; }
        public bool DirectDebitAuthorized { get; set; }
        public int TaxCategory { get; set; }
        public int FederalStatus { get; set; }
        public int FederalExemptions { get; set; }
        public decimal FederalAdditionalAmount { get; set; }
        public string State { get; set; }
        public System.DateTime LastModified { get; set; }
        public string LastModifiedBy { get; set; }
    
        public virtual BankAccount BankAccount { get; set; }
        public virtual Status Status { get; set; }
        public virtual Company Company { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<EmployeeDeduction> EmployeeDeductions { get; set; }
    }
}
