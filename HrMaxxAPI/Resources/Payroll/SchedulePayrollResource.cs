using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HrMaxxAPI.Resources.Payroll
{
    public class SchedulePayrollResource
    {
        public int Id { get; set; }
        public Guid CompanyId { get; set; }
        public PayrollSchedule PaySchedule { get; set; }
        public DateTime ScheduleStartDate { get; set; }
        public DateTime PayDateStart { get; set; }
        public DateTime? LastPayrollDate { get; set; }
        public StatusOption Status { get; set; }
        public PayrollResource Data { get; set; }
        public DateTime LastModified { get; set; }
        public string LastModifiedBy { get; set; }
        public string StatusText { get { return Status.GetDbName(); } }
    }
}