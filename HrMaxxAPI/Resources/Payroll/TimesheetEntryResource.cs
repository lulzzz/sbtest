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
    public class TimesheetEntryResource
    {
        public int Id { get; set; }
        public Guid EmployeeId { get; set; }
        public string EmployeeNo { get; set; }
        public string SSN { get; set; }
        public string Name { get; set; }
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

		public void FillFromImportWithMap(ExcelRead er, CompanyResource company, ImportMap importMap, IMapper mapper, List<HrMaxx.OnlinePayroll.Models.Employee> employees)
		{
			var style = NumberStyles.Number | NumberStyles.AllowCurrencySymbol;
			var culture = CultureInfo.CreateSpecificCulture("en-US");
			string[] formats = { "MM/dd/yyyy", "M/dd/yyyy", "M/d/yyyy", "MM/d/yyyy",
					"MM/dd/yy", "M/dd/yy", "M/d/yy", "MM/d/yy"};
			var error = string.Empty;
			var colcounter = (int)0;
			foreach (var col in importMap.ColumnMap)
			{
				var val = er.Value(col.Key);
				if (col.Key.Equals("SSN"))
				{
					const string ssnRegex = @"^(\d{3}-\d{2}-\d{4})$";
					if (!Regex.IsMatch(val, ssnRegex))
					{
						error += "SSN, ";
					}
					else
					{
						SSN = val.Replace("-", string.Empty);
						var emp = employees.FirstOrDefault(e => e.SSN.Equals(SSN));
						if (emp != null)
						{
							EmployeeId = emp.Id;
							EmployeeNo = emp.CompanyEmployeeNo.ToString();
							Name = emp.FullName;
						}
					}
				}
				else if (col.Key.Equals("Employee No"))
				{
					if (string.IsNullOrWhiteSpace(val))
					{
						error += "Employee No, ";
					}
					else
					{
						EmployeeNo = val;
						var emp = employees.FirstOrDefault(e => e.CompanyEmployeeNo.ToString().Equals(EmployeeNo));
						if (emp != null)
						{
							EmployeeId = emp.Id;
							SSN = emp.SSN.ToString();
							Name = emp.FullName;
						}
					}
				}
				
				else if (col.Key.Equals("Description"))
				{
					Description = val;
				}
				else if (col.Key.Equals("Project Id"))
				{
					if (!string.IsNullOrWhiteSpace(val) && company.CompanyProjects.Any(p=>p.ProjectId.Equals(val)))
					{
						var pr = company.CompanyProjects.First(p => p.ProjectId.Equals(val));
						ProjectId = pr.Id;
						ProjectName = pr.ProjectName;
					}
					
				}

				else if (col.Key.Equals("Hours"))
				{
					decimal bt = 0;
					decimal.TryParse(val, style, culture, out bt);
					if (bt > 0)
						Hours = bt;
				}
				else if (col.Key.Equals("Overtime"))
				{
					decimal slt = 0;
					decimal.TryParse(val, style, culture, out slt);
					if (slt > 0)
						Overtime = slt;
				}
				else if (col.Key.Equals("Entry Date"))
				{
					DateTime date;
					if (!DateTime.TryParseExact(val, formats, CultureInfo.InvariantCulture, DateTimeStyles.None, out date))
					{
						error += "Hire Date, ";
					}
					else
					{
						EntryDate = date;
					}
				}
				



			}
			
			if (!string.IsNullOrWhiteSpace(error))
			{
				error = "Employee at row# " + er.Row + " has invalid " + error;
				throw new Exception(error);
			}

		}
	}
}