using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LinqToExcel.Attributes;

namespace SiteInspectionStatus_Utility
{
	public class Company
	{
		[ExcelColumn("CompanyName")] //maps the "Name" property to the "Company Title" column
		public string Name { get; set; }

		[ExcelColumn("CompanyNo")] //maps the "State" property to the "Providence" column
		public string CompanyNo { get; set; }

		[ExcelColumn("Host")] //maps the "Employees" property to the "Employee Count" column
		public string HostId { get; set; }

		[ExcelColumn("Parent")] //maps the "Employees" property to the "Employee Count" column
		public string ParentNo { get; set; }
	}
}
