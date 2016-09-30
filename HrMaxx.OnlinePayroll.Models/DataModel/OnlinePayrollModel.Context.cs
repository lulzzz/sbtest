﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class OnlinePayrollEntities : DbContext
    {
        public OnlinePayrollEntities()
            : base("name=OnlinePayrollEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<Status> Status { get; set; }
        public virtual DbSet<Host> Hosts { get; set; }
        public virtual DbSet<Company> Companies { get; set; }
        public virtual DbSet<CompanyTaxRate> CompanyTaxRates { get; set; }
        public virtual DbSet<CompanyTaxState> CompanyTaxStates { get; set; }
        public virtual DbSet<Tax> Taxes { get; set; }
        public virtual DbSet<TaxYearRate> TaxYearRates { get; set; }
        public virtual DbSet<CompanyContract> CompanyContracts { get; set; }
        public virtual DbSet<CompanyDeduction> CompanyDeductions { get; set; }
        public virtual DbSet<CompanyWorkerCompensation> CompanyWorkerCompensations { get; set; }
        public virtual DbSet<DeductionType> DeductionTypes { get; set; }
        public virtual DbSet<CompanyAccumlatedPayType> CompanyAccumlatedPayTypes { get; set; }
        public virtual DbSet<PayType> PayTypes { get; set; }
        public virtual DbSet<CompanyPayCode> CompanyPayCodes { get; set; }
        public virtual DbSet<VendorCustomer> VendorCustomers { get; set; }
        public virtual DbSet<AccountTemplate> AccountTemplates { get; set; }
        public virtual DbSet<BankAccount> BankAccounts { get; set; }
        public virtual DbSet<CompanyAccount> CompanyAccounts { get; set; }
        public virtual DbSet<EntityType> EntityTypes { get; set; }
        public virtual DbSet<Employee> Employees { get; set; }
        public virtual DbSet<EmployeeDeduction> EmployeeDeductions { get; set; }
        public virtual DbSet<Payroll> Payrolls { get; set; }
        public virtual DbSet<PayrollPayCheck> PayrollPayChecks { get; set; }
        public virtual DbSet<Journal> Journals { get; set; }
        public virtual DbSet<CompanyPayrollCube> CompanyPayrollCubes { get; set; }
        public virtual DbSet<Invoice> Invoices { get; set; }
        public virtual DbSet<PayrollInvoice> PayrollInvoices { get; set; }
    }
}
