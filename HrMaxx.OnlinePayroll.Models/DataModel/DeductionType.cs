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
    
    public partial class DeductionType
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public DeductionType()
        {
            this.CompanyDeductions = new HashSet<CompanyDeduction>();
        }
    
        public int Id { get; set; }
        public string Name { get; set; }
        public int Category { get; set; }
        public string W2_12 { get; set; }
        public string W2_13R { get; set; }
        public string R940_R { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CompanyDeduction> CompanyDeductions { get; set; }
    }
}