using HrMaxx.Common.Models;
using HrMaxx.Infrastructure.Mapping;
using HrMaxxAPI.Resources.OnlinePayroll;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Security.Cryptography;
using System.Text.RegularExpressions;
using System.Web;

namespace HrMaxxAPI.Resources.Payroll
{
    public class TimesheetRequestResource
    { 
        public Guid CompanyId { get; set; }
        public Guid? EmployeeId { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
    }
}