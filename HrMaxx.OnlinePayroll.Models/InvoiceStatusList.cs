using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	[Serializable]
	[XmlRoot("InvoiceStatusList")]
	public class InvoiceStatusListItem
	{
		public string FirmName { get; set; }
		public string CompanyName { get; set; }
		public int InvoiceNumber { get; set; }
		public DateTime InvoiceDate { get; set; }
		public DateTime PayDay { get; set; }
		public DateTime TaxPayDay { get; set; }
		public Guid Id { get; set; }
		public int Status { get; set; }

		public string StatusText { get { return ((InvoiceStatus)Status).GetDbName(); } }
	}
}
