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
    
    public partial class USTaxTableEntities : DbContext
    {
        public USTaxTableEntities()
            : base("name=USTaxTableEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<TaxDeductionPrecedence> TaxDeductionPrecedences { get; set; }
        public virtual DbSet<EstimatedDeductionsTable> EstimatedDeductionsTables { get; set; }
        public virtual DbSet<ExemptionAllowanceTable> ExemptionAllowanceTables { get; set; }
        public virtual DbSet<FITTaxTable> FITTaxTables { get; set; }
        public virtual DbSet<FITWithholdingAllowanceTable> FITWithholdingAllowanceTables { get; set; }
        public virtual DbSet<SITLowIncomeTaxTable> SITLowIncomeTaxTables { get; set; }
        public virtual DbSet<SITTaxTable> SITTaxTables { get; set; }
        public virtual DbSet<StandardDeductionTable> StandardDeductionTables { get; set; }
    }
}
