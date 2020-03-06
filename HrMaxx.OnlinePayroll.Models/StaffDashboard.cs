using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;

namespace HrMaxx.OnlinePayroll.Models
{
	public class StaffDashboard
	{
		public List<StaffDashboardCube> PayrollsProcessed { get; set; }
		public int PayrollsProcessedToday { get { return PayrollsProcessed.Count(p => p.TS.Date == DateTime.Today); } }
		public PieChart PayrollsProcessedChart { get{ return new PieChart(){Items = PayrollsProcessed.GroupBy(p=>p.UserName).Select(g=> new PieChartItem { Label=g.Key, Value=g.ToList().Count}).ToList()};} }

		public List<StaffDashboardCube> PayrollsVoided { get; set; }
		public int PayrollsVoidedToday { get { return PayrollsVoided.Count(p => p.TS.Date == DateTime.Today); } }
		public PieChart PayrollsVoidedChart { get { return new PieChart() { Items = PayrollsVoided.GroupBy(p => p.UserName).Select(g => new PieChartItem { Label = g.Key, Value = g.ToList().Count }).ToList() }; } }

		public List<StaffDashboardCube> InvoicesCreated { get; set; }
		public int InvoicesCreatedToday { get { return InvoicesCreated.Count(p => p.TS.Date == DateTime.Today); } }
		public PieChart InvoicesCreatedChart { get { return new PieChart() { Items = InvoicesCreated.GroupBy(p => p.UserName).Select(g => new PieChartItem { Label = g.Key, Value = g.ToList().Count }).ToList() }; } }

		public List<StaffDashboardCube> InvoicesDelivered { get; set; }
		public int InvoicesDeliveredToday { get { return InvoicesDelivered.Count(p => p.TS.Date == DateTime.Today); } }
		public PieChart InvoicesDeliveredChart { get { return new PieChart() { Items = InvoicesDelivered.GroupBy(p => p.UserName).Select(g => new PieChartItem { Label = g.Key, Value = g.ToList().Count }).ToList() }; } }

		public List<StaffDashboardCube> CompaniesUpdated { get; set; }
		public int CompaniesUpdatedToday { get { return CompaniesUpdated.Count(p => p.TS.Date == DateTime.Today); } }
		public PieChart CompaniesUpdatedChart { get { return new PieChart() { Items = CompaniesUpdated.GroupBy(p => p.UserName).Select(g => new PieChartItem { Label = g.Key, Value = g.ToList().Count }).ToList() }; } }

		public List<StaffDashboardCube> MissedPayrolls { get; set; }
		public List<StaffDashboardCube> MissedPayrollsYesterday { get { return MissedPayrolls.Where(p => p.TS.Date == p.LastBusinessDay).ToList(); } }
		public EmployeeDocumentMetaData EmployeeDocumentMetaData { get; set; }
		public List<CompanyDueDate> RenewalDue { get; set; }
		public List<CompanyDueDate> Renewals { get { return RenewalDue.GroupBy(r => r.DueDate).Select(g => new CompanyDueDate { DueDate = g.Key.Date, Details = g.ToList().GroupBy(r1 => r1.Description)
			.Select(g2 => new CompanyDueDate { DueDate = g.Key.Date, Description = g2.Key, Details = g2.ToList() }).ToList() }).OrderBy(c=>c.DueDate).ToList(); } }
		public int RenewalDueToday { get { return RenewalDue.Count(cr=>cr.DueInDays<=1); } }
		public int RenewalDueNext { get { return RenewalDue.Count(cr => cr.DueInDays <= 15); } }
	}

	public class StaffDashboardCube
	{
		public Guid HostId { get; set; }
		public Guid CompanyId { get; set; }
		public string CompanyName { get; set; }
		public string UserName { get; set; }
		public DateTime TS { get; set; }
		public DateTime LastBusinessDay { get; set; }
	}
	public class CompanyDueDate
	{
		public string Host { get; set; }
		public string Company { get; set; }
		public string Description { get; set; }
		public DateTime DueDate { get; set; }
		public InvoiceSetup InvoiceSetup { get; set; }
		public int DueInDays { get { return (int)((DueDate - DateTime.Today).TotalDays); } }
		public List<CompanyDueDate> Details { get; set; }
	}

	public class PieChart
	{
		public List<PieChartItem> Items { get; set; }

		public List<KeyValuePair<string, decimal>> Legend
		{
			get
			{
				return
					Items.Select(i => new KeyValuePair<string, decimal>(i.Label, Math.Round((i.Value/Items.Sum(i1 => i1.Value))*100, 2))).ToList();
			}
		}
	}

	public class PieChartItem
	{
		public string Label { get; set; }
		public decimal Value { get; set; }
	}
}
