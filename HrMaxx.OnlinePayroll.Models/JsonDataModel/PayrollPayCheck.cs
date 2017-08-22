using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	[Serializable]
	[XmlRoot("PayCheckList")]
	public class PayrollPayCheckJson
	{
		public int Id { get; set; }
		public Guid PayrollId { get; set; }
		public Guid CompanyId { get; set; }
		public Guid EmployeeId { get; set; }
		public string Employee { get; set; }
		public decimal GrossWage { get; set; }
		public decimal NetWage { get; set; }
		public decimal WCAmount { get; set; }
		public string Compensations { get; set; }
		public string Deductions { get; set; }
		public string Taxes { get; set; }
		public string Accumulations { get; set; }
		public decimal Salary { get; set; }
		public decimal YTDSalary { get; set; }
		public string PayCodes { get; set; }
		public decimal DeductionAmount { get; set; }
		public decimal EmployeeTaxes { get; set; }
		public decimal EmployerTaxes { get; set; }
		public int Status { get; set; }
		public bool IsVoid { get; set; }
		public int PayrmentMethod { get; set; }
		public int PrintStatus { get; set; }
		public DateTime StartDate { get; set; }
		public DateTime EndDate { get; set; }
		public DateTime PayDay { get; set; }
		public DateTime TaxPayDay { get; set; }
		public int CheckNumber { get; set; }
		public int PaymentMethod { get; set; }
		public string Notes { get; set; }
		public decimal YTDGrossWage { get; set; }
		public decimal YTDNetWage { get; set; }
		public DateTime LastModified { get; set; }
		public string LastModifiedBy { get; set; }
		public string WorkerCompensation { get; set; }
		public bool PEOASOCoCheck { get; set; }
		public bool IsHistory { get; set; }
		public Guid? InvoiceId { get; set; }
		public DateTime? VoidedOn { get; set; }
		public Guid? CreditInvoiceId { get; set; }
		
		public bool IsReIssued { get; set; }
		public int? OriginalCheckNumber { get; set; }
		public DateTime? ReIssuedDate { get; set; }
	}
}
