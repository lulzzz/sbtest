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
	[XmlRoot("InvoicePaymentList")]
	public class ExtractInvoicePaymentJson
	{
		public Guid CompanyId { get; set; }
		public DateTime PaymentDate { get; set; }
		public int Method { get; set; }
		public int Status { get; set; }
		public int CheckNumber { get; set; }
		public decimal Amount { get; set; }
		public Guid? InvoiceId { get; set; }
		public int PaymentId { get; set; }
	}
}
