using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace HrMaxx.OnlinePayroll.Models
{
    
    public class TimesheetEntry
    {
        public int Id { get; set; }
        public Guid EmployeeId { get; set; }
        public int? ProjectId { get; set; }
        public DateTime EntryDate { get; set; }
        public decimal Hours { get; set; }
        public decimal Overtime { get; set; }
        public string LastModifiedBy { get; set; }
        public DateTime LastModified { get; set; }
        public bool IsApproved { get; set; }
        public string ApprovedBy { get; set; }
        public DateTime? ApprovedOn { get; set; }
        public string Description { get; set; }
        public string ProjectName { get; set; }
        public bool IsPaid { get; set; }
        public Guid? PayrollId { get; set; }
        public DateTime? PayDay { get; set; }
        public string Title { get { return $"{ProjectName}: R: {Hours}, O: {Overtime}"; } }
        public DateTime Start { get { return EntryDate.Date; } }
        public DateTime End { get { return EntryDate.AddDays(1).Date; } }
        public string EntryDateStr { get { return EntryDate.ToString("MM/dd/yyyy"); } set { } }
        public string ApprovedOnStr { get { return ApprovedOn.HasValue ? ApprovedOn.Value.ToString("MM/dd/yyyy") : string.Empty; } set { } }
        public string PaidOn { get { return PayDay.HasValue ? PayDay.Value.ToString("MM/dd/yyyy") : string.Empty; } set { } }
        public string Day { get { return ((int)(EntryDate.DayOfWeek)).ToString(); } set { } }
    }
}
