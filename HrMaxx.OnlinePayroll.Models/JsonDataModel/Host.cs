using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
    [Serializable]
    [XmlRoot("HostList")]
    public class Host
    {
        public System.Guid Id { get; set; }
        public string FirmName { get; set; }
        public string Url { get; set; }
        public System.DateTime EffectiveDate { get; set; }
        public Nullable<System.DateTime> TerminationDate { get; set; }
        public int StatusId { get; set; }
        public string HomePage { get; set; }
        public string LastModifiedBy { get; set; }
        public System.DateTime LastModified { get; set; }
        public Nullable<System.Guid> CompanyId { get; set; }
        public string PTIN { get; set; }
        public string DesigneeName940941 { get; set; }
        public string PIN940941 { get; set; }
        public bool IsPeoHost { get; set; }
        public string BankCustomerId { get; set; }
        public int HostIntId { get; set; }
               
        public virtual CompanyJson Company { get; set; }
    }
}
