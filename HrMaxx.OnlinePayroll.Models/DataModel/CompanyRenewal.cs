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
    
    public partial class CompanyRenewal
    {
        public int Id { get; set; }
        public System.Guid CompanyId { get; set; }
        public string Description { get; set; }
        public int Month { get; set; }
        public int Day { get; set; }
        public int ReminderDays { get; set; }
    
        public virtual Company Company { get; set; }
    }
}
