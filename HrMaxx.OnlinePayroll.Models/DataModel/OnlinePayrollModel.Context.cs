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
        public virtual DbSet<AccountTemplate> AccountTemplates { get; set; }
        public virtual DbSet<BankAccount> BankAccounts { get; set; }
        public virtual DbSet<CompanyAccount> CompanyAccounts { get; set; }
        public virtual DbSet<EntityType> EntityTypes { get; set; }
        public virtual DbSet<Employee> Employees { get; set; }
        public virtual DbSet<EmployeeDeduction> EmployeeDeductions { get; set; }
        public virtual DbSet<Payroll> Payrolls { get; set; }
        public virtual DbSet<Journal> Journals { get; set; }
        public virtual DbSet<ApplicationConfiguration> ApplicationConfigurations { get; set; }
        public virtual DbSet<ReportConstant> ReportConstants { get; set; }
        public virtual DbSet<VendorCustomer> VendorCustomers { get; set; }
        public virtual DbSet<PayCheckExtract> PayCheckExtracts { get; set; }
        public virtual DbSet<InsuranceGroup> InsuranceGroups { get; set; }
        public virtual DbSet<SearchTable> SearchTables { get; set; }
        public virtual DbSet<InvoiceDeliveryClaim> InvoiceDeliveryClaims { get; set; }
        public virtual DbSet<CompanyTSImportMap> CompanyTSImportMaps { get; set; }
        public virtual DbSet<EmployeeBankAccount> EmployeeBankAccounts { get; set; }
        public virtual DbSet<InvoicePayment> InvoicePayments { get; set; }
        public virtual DbSet<PayrollInvoice> PayrollInvoices { get; set; }
        public virtual DbSet<PayrollPayCheck> PayrollPayChecks { get; set; }
        public virtual DbSet<ACHTransaction> ACHTransactions { get; set; }
        public virtual DbSet<ACHTransactionExtract> ACHTransactionExtracts { get; set; }
        public virtual DbSet<MasterExtract> MasterExtracts { get; set; }
        public virtual DbSet<CommissionExtract> CommissionExtracts { get; set; }
        public virtual DbSet<CheckbookJournal> CheckbookJournals { get; set; }
        public virtual DbSet<CompanyRecurringCharge> CompanyRecurringCharges { get; set; }
        public virtual DbSet<EmployeeACA> EmployeeACAs { get; set; }
        public virtual DbSet<PayrollInvoiceCommission> PayrollInvoiceCommissions { get; set; }
        public virtual DbSet<CompanyRenewal> CompanyRenewals { get; set; }
        public virtual DbSet<CompanyProject> CompanyProjects { get; set; }
    }
}
