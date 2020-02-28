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
        public Guid? LastPayrollId { get; set; }
        public DateTime NextPayrollDate
        {
            get
            {
                var nextPayDay = !LastPayrollDate.HasValue ? PayDateStart : (PaySchedule == PayrollSchedule.Weekly ? LastPayrollDate.Value.AddDays(7) :
                PaySchedule == PayrollSchedule.BiWeekly ? LastPayrollDate.Value.AddDays(14) :
                PaySchedule == PayrollSchedule.SemiMonthly ? LastPayrollDate.Value.AddDays(15) :
                LastPayrollDate.Value.AddMonths(1)).Date;
                while (nextPayDay.DayOfWeek == DayOfWeek.Saturday || nextPayDay.DayOfWeek == DayOfWeek.Sunday)
                {
                    nextPayDay = nextPayDay.AddDays(1);
                }
                return nextPayDay;
            }
        }

    }
}
