using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	public class StaffDashboardJson
	{
		public List<StaffDashboardCubeJson> PayrollsProcessed { get; set; }
		public List<StaffDashboardCubeJson> PayrollsVoided { get; set; }
		public List<StaffDashboardCubeJson> InvoicesCreated { get; set; }
		public List<StaffDashboardCubeJson> InvoicesDelivered { get; set; }
		public List<StaffDashboardCubeJson> CompaniesUpdated { get; set; }
		public List<StaffDashboardCubeJson> MissedPayrolls { get; set; }
		public EmployeeDocumentMetaData EmployeeDocumentMetaData { get; set; }
	}

	public class StaffDashboardCubeJson
	{
		public Guid HostId { get; set; }
		public Guid CompanyId { get; set; }
		public string CompanyName { get; set; }
		public string UserName { get; set; }
		public DateTime TS { get; set; }
		public DateTime LastBusinessDay { get; set; }
	}
}
