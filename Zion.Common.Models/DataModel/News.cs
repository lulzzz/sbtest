//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace HrMaxx.Common.Models.DataModel
{
    using System;
    using System.Collections.Generic;
    
    public partial class News
    {
        public System.Guid Id { get; set; }
        public string NewsContent { get; set; }
        public Nullable<int> AudienceScope { get; set; }
        public string Audience { get; set; }
        public System.DateTime LastModified { get; set; }
        public string LastModifiedBy { get; set; }
        public string Title { get; set; }
        public bool IsActive { get; set; }
    }
}
