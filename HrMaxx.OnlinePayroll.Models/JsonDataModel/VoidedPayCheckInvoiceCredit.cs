using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	[Serializable]
	[XmlRoot("VoidedPayCheckInvoiceCreditList")]
	public class VoidedPayCheckInvoiceCreditJson
	{
		public int Id { get; set; }
		public string CheckNumber { get; set; }
		public int PaymentMethod { get; set; }
		public DateTime? VoidedOn { get; set; }
		public decimal GrossWage { get; set; }
		public decimal EmployeeTaxes { get; set; }
		public string Deductions { get; set; }
		public string InvoiceSetup { get; set; }
		public Guid InvoiceId { get; set; }
		public decimal Balance { get; set; }
		public int InvoiceNumber { get; set; }
		public string MiscCharges { get; set; }
		public string Taxes { get; set; }
		public DateTime PayDay { get; set; }
	}
}
