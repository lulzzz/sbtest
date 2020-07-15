using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
    public class VendorCustomerJson
    {
        public System.Guid Id { get; set; }
        public Nullable<System.Guid> CompanyId { get; set; }
        public string Name { get; set; }
        public int StatusId { get; set; }
        public string AccountNo { get; set; }
        public bool IsVendor { get; set; }
        public bool IsVendor1099 { get; set; }
        public string Contact { get; set; }
        public string Note { get; set; }
        public Nullable<int> Type1099 { get; set; }
        public Nullable<int> SubType1099 { get; set; }
        public Nullable<int> IdentifierType { get; set; }
        public string IndividualSSN { get; set; }
        public string BusinessFIN { get; set; }
        public System.DateTime LastModified { get; set; }
        public string LastModifiedBy { get; set; }
        public bool IsAgency { get; set; }
        public bool IsTaxDepartment { get; set; }
        public int VendorCustomerIntId { get; set; }
        public decimal OpenBalance { get; set; }
    }
}
