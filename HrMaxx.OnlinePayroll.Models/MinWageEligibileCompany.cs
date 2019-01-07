using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace HrMaxx.OnlinePayroll.Models
{
	[Serializable]
	[XmlRoot("MinWageEligibleCompanyList")]
	public class MinWageEligibileCompany
	{
		public string Host { get; set; }
		public Guid CompanyId { get; set; }
		public string Company { get; set; }
		public decimal MinWage { get; set; }
		public bool FileUnderHost { get; set; }
		public string ContractType { get { return FileUnderHost ? "PEO" : "ASO"; } }
		public List<MinWageEligibleEmployee> Employees { get; set; }
		public int ActiveEmployeeCount { get; set; }
		public int PaidEmployeeCount { get; set; }
		public string City { get; set; }
	}

	public class MinWageEligibleEmployee
	{
		public Guid EmployeeId { get; set; }
		public string FirstName { get; set; }
		public string MiddleInitial { get; set; }
		public string LastName { get; set; }
		public decimal Rate { get; set; }
		public string FullName
		{
			get { return string.Format("{0}{2}{1}", FirstName, LastName, string.Format(" {0}", !string.IsNullOrWhiteSpace(MiddleInitial) ? MiddleInitial.Substring(0, 1) + " " : string.Empty)); }
		}
	}
}
