using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
    public class ScheduledPayrollJson
    {
        public int Id { get; set; }
        public Guid CompanyId { get; set; }
        public int PaySchedule { get; set; }
        public DateTime ScheduleStartDate { get; set; }
        public DateTime PayDateStart { get; set; }
        public DateTime? LastPayrollDate { get; set; }
        public int Status { get; set; }
        public string Data { get; set; }
        public DateTime LastModified { get; set; }
        public string LastModifiedBy { get; set; }
    }
}
