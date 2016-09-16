using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.Common.Models
{

	public class ReportTransformed
	{
		public string Name { get; set; }
		public List<Report> Reports { get; set; }
	}

	public class Report
	{
		public string TemplatePath { get; set; }
		public string Template { get; set; }
		public List<Field> Fields { get; set; }
	}

	public class Field
	{
		public string Name { get; set; }
		public string Type { get; set; }
		public string Value { get; set; }
	}
}
