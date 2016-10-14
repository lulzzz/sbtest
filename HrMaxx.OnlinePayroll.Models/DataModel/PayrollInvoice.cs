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
    
    public partial class PayrollInvoice
    {
        public System.Guid Id { get; set; }
        public System.Guid CompanyId { get; set; }
        public System.Guid PayrollId { get; set; }
        public string InvoiceSetup { get; set; }
        public string EmployerTaxes { get; set; }
        public System.DateTime InvoiceDate { get; set; }
        public int NoOfChecks { get; set; }
        public string WorkerCompensations { get; set; }
        public decimal EmployeeContribution { get; set; }
        public decimal EmployerContribution { get; set; }
        public decimal AdminFee { get; set; }
        public decimal EnvironmentalFee { get; set; }
        public string MiscCharges { get; set; }
        public System.DateTime LastModified { get; set; }
        public string LastModifiedBy { get; set; }
        public int Status { get; set; }
        public Nullable<System.DateTime> SubmittedOn { get; set; }
        public string SubmittedBy { get; set; }
        public Nullable<System.DateTime> DeliveredOn { get; set; }
        public string DeliveredBy { get; set; }
        public decimal GrossWages { get; set; }
        public decimal Total { get; set; }
        public int InvoiceNumber { get; set; }
        public System.DateTime PeriodStart { get; set; }
        public System.DateTime PeriodEnd { get; set; }
        public string Payrments { get; set; }
        public string Deductions { get; set; }
        public string Courier { get; set; }
        public string EmployeeTaxes { get; set; }
        public string Notes { get; set; }
        public string ProcessedBy { get; set; }
        public decimal Balance { get; set; }
        public System.DateTime ProcessedOn { get; set; }
    
        public virtual Company Company { get; set; }
        public virtual Payroll Payroll { get; set; }
    }
}
