using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	[Serializable]
	[XmlRoot("CompanyInvoiceList")]
	public class CompanyInvoiceJson
	{
		public int Id { get; set; }
		public int InvoiceNumber { get; set; }
		public Guid PayeeId { get; set; }
		public decimal Amount { get; set; }
		public string Memo { get; set; }
		public bool IsVoid { get; set; }
		public DateTime InvoiceDate { get; set; }
		public DateTime LastModified { get; set; }
		public string LastModifiedBy { get; set; }
		public string ListItems { get; set; }
		public Guid CompanyId { get; set; }
		public string PayeeName { get; set; }
		public string Contact { get; set; }
		public List<CompanyInvoiceItem> InvoiceItems { get; set; }
		public decimal SalesTaxRate { get; set; }
		public decimal DiscountRate { get; set; }
		public int DiscountType { get; set; }
		public decimal Discount { get; set; }
		public decimal SalesTax { get; set; }
		public decimal Total { get; set; }
		public decimal Balance { get { return Total - InvoicePayments.Sum(p => p.Amount); } }
		public DateTime DueDate { get; set; }
		public bool IsQuote { get; set; }
		public List<InvoicePaymentJson> InvoicePayments { get; set; }
	}
}
