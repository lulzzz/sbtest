using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models.Enum;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
    public class SchedulePayroll
    {
        public int Id { get; set; }
        public Guid CompanyId { get; set; }
        public PayrollSchedule PaySchedule { get; set; }
        public DateTime ScheduleStartDate { get; set; }
        public DateTime PayDateStart { get; set; }
        public DateTime? LastPayrollDate { get; set; }
        public StatusOption Status { get; set; }
        public Payroll Data { get; set; }
        public DateTime LastModified { get; set; }
        public string LastModifiedBy { get; set; }
    }
}
