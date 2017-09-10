using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	[Serializable]
	[XmlRoot("PayrollInvoiceJsonList")]
	public class PayrollInvoiceJson
	{
		public Guid Id { get; set; }
		public Guid CompanyId { get; set; }
		public Guid PayrollId { get; set; }
		public int InvoiceNumber { get; set; }
		public DateTime InvoiceDate { get; set; }
		public DateTime PeriodStart { get; set; }
		public DateTime PeriodEnd { get; set; }
		public string InvoiceSetup { get; set; }
		public decimal GrossWages { get; set; }
		public string EmployerTaxes { get; set; }
		
		public int NoOfChecks { get; set; }
		public string Deductions { get; set; }
		public string WorkerCompensations { get; set; }
		public decimal EmployeeContribution { get; set; }
		public decimal EmployerContribution { get; set; }
		public decimal AdminFee { get; set; }
		public decimal EnvironmentalFee { get; set; }
		public string MiscCharges { get; set; }
		public decimal Total { get; set; }
		public int Status { get; set; }
		public DateTime? SubmittedOn { get; set; }
		public string SubmittedBy { get; set; }
		public DateTime? DeliveredOn { get; set; }
		public string DeliveredBy { get; set; }
		public DateTime LastModified { get; set; }
		public string LastModifiedBy { get; set; }
		public string Courier { get; set; }
		public string EmployeeTaxes { get; set; }
		public string Notes { get; set; }
		public string ProcessedBy { get; set; }
		public decimal Balance { get; set; }
		public DateTime ProcessedOn { get; set; }
		public string PayChecks { get; set; }
		public string VoidedCreditChecks { get; set; }
		public bool ApplyWCMinWageLimit { get; set; }
		public string DeliveryClaimedBy { get; set; }
		public DateTime? DeliveryClaimedOn { get; set; }
		public decimal NetPay { get; set; }
		public decimal CheckPay { get; set; }
		public decimal DDPay { get; set; }
		public Guid? SalesRep { get; set; }
		public decimal Commission { get; set; }
		public DateTime PayrollPayDay { get; set; }
		public DateTime PayrollTaxPayDay { get; set; }
		public CompanyJson Company { get; set; }
		public List<InvoicePaymentJson> InvoicePayments { get; set; }
		public bool CommissionClaimed { get; set; }
		public bool TaxesDelayed { get; set; }
		
	}

	public class InvoicePaymentJson
	{
		public int Id { get; set; }
		public Guid InvoiceId { get; set; }
		public DateTime PaymentDate { get; set; }
		public int Method { get; set; }
		public int Status { get; set; }
		public int? CheckNumber { get; set; }
		public decimal Amount { get; set; }
		public string Notes { get; set; }
		public DateTime LastModified { get; set; }
		public string LastModifiedBy { get; set; }
	}

	public class XmlResult
	{
		public List<PayrollInvoiceJson> ResultList { get; set; } 
	}
}
