using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HrMaxxAPI.Resources.Common
{
    public class DeductionTypeResource
    {
        public DeductionType DeductionType { get; set; }
        public List<PreTaxDeduction> Precedence { get; set; }
    }
}