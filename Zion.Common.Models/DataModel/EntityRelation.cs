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
    
    public partial class EntityRelation
    {
        public int EntityRelationId { get; set; }
        public int SourceEntityTypeId { get; set; }
        public int TargetEntityTypeId { get; set; }
        public System.Guid SourceEntityId { get; set; }
        public System.Guid TargetEntityId { get; set; }
        public string TargetObject { get; set; }
    
        public virtual EntityType EntityType { get; set; }
        public virtual EntityType EntityType1 { get; set; }
    }
}
