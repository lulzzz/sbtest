using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	[Serializable]
	[XmlRoot("PayrollList")]
	public class PayrollJson
	{
		public Guid Id { get; set; }
		public Guid CompanyId { get; set; }
		public Guid? HostCompanyId { get; set; }
		public DateTime StartDate { get; set; }
		public DateTime EndDate { get; set; }
		public DateTime PayDay { get; set; }
		public DateTime TaxPayDay { get; set; }
		public int StartingCheckNumber { get; set; }
		public string Company { get; set; }
		public DateTime LastModified { get; set; }
		public string LastModifiedBy { get; set; }
		public int Status { get; set; }
		//public Guid? InvoiceId { get; set; }
		public bool PEOASOCoCheck { get; set; }
		public bool IsHistory { get; set; }
		public string Notes { get; set; }
		//public PayrollInvoiceJson PayrollInvoice { get; set; }
		public List<PayrollPayCheckJson> PayrollPayChecks { get; set; }

		public Guid? InvoiceId { get; set; }
		public decimal Total { get; set; }
		public int InvoiceNumber { get; set; }
		public int InvoiceStatus { get; set; }
		public bool TaxesDelayed { get; set; }

		public Guid? CopiedFrom { get; set; }
		public Guid? MovedFrom { get; set; }

		public bool HasExtracts { get; set; }
		public bool HasACH { get; set; }
		public bool IsPrinted { get; set; }
		public bool IsVoid { get; set; }
	}
	[Serializable]
	[XmlRoot("PayrollMinifiedList")]
	public class PayrollMinified
	{
		public Guid Id { get; set; }
		public string CompanyName { get; set; }
		public DateTime StartDate { get; set; }
		public DateTime EndDate { get; set; }
		public DateTime PayDay { get; set; }
		public DateTime LastModified { get; set; }
		public bool IsHistory { get; set; }
		public string ProcessedBy { get; set; }
		public int Status { get; set; }
		
		public Guid? InvoiceId { get; set; }
		public decimal Total { get; set; }
		public int InvoiceNumber { get; set; }
		public int InvoiceStatus { get; set; }
		public bool TaxesDelayed { get; set; }
		public decimal TotalGrossWage { get; set; }
		public decimal TotalNetWage { get; set; }
	}
}

