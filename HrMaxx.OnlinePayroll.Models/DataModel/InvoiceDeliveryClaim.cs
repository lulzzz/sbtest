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
    
    public partial class InvoiceDeliveryClaim
    {
        public int Id { get; set; }
        public System.Guid UserId { get; set; }
        public string UserName { get; set; }
        public string Invoices { get; set; }
        public System.DateTime DeliveryClaimedOn { get; set; }
    }
}
