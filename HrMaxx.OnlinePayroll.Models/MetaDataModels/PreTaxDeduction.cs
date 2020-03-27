using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models.MetaDataModels
{
    public class PreTaxDeduction
    {
        public string TaxCode { get; set; }
        public int DeductionTypeId { get; set; }
        public bool Selected { get; set; }
        public int? StateId { get; set; }
        public string StateCode { get { return StateId.HasValue ? ((States)StateId).GetHrMaxxName() : "Federal"; } }
    }
}
