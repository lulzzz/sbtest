using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	public class CompanyDashboardJson
	{
		public List<TaxExtractJson> ExtractHistory { get; set; }
		public List<TaxExtractJson> PendingExtracts { get; set; }
		public List<PayrollMetricJson> PayrollHistory { get; set; }
		public EmployeeDocumentMetaData EmployeeDocumentMetaData { get; set; }
	}

	public class TaxExtractJson
	{
		public DateTime DepositDate { get; set; }
		public string CompanyName { get; set; }
		public string ExtractName { get; set; }
		public decimal Amount { get; set; }
		public int DRank { get; set; }
	}

	public class PayrollMetricJson
	{
		public DateTime PayDay { get; set; }
		public int NoOfChecks { get; set; }
		public decimal GrossWage { get; set; }
		public decimal NetWage { get; set; }
		public decimal EmployeeTaxes { get; set; }
		public decimal EmployerTaxes { get; set; }
		public decimal Deductions { get; set; }
		public int DRank { get; set; }
	}
}
