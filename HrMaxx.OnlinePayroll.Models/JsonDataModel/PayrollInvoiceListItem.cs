using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	public class PayrollInvoiceListItem
	{
		public Guid Id { get; set; }
		public Guid CompanyId { get; set; }
		public string CompanyName { get; set; }
		public bool IsHostCompany { get; set; }
		public bool IsVisibleToHost { get; set; }
		public Guid HostId { get; set; }
		public int InvoiceNumber { get; set; }
		public DateTime InvoiceDate { get; set; }
		public DateTime PayrollTaxPayDay { get; set; }
		public DateTime PayrollPayDay { get; set; }
		public decimal Total { get; set; }
		public decimal Balance { get; set; }
		public string ProcessedBy { get; set; }
		public int Status { get; set; }
		public DateTime ProcessedOn { get; set; }
		public DateTime? DeliveredOn { get; set; }
		public string Courier { get; set; }
		public string CheckNumbers { get; set; }
		public DateTime? LastPayment { get; set; }
		public string EmployeeTaxes { get; set; }
		public string EmployerTaxes { get; set; }
		public string DeliveryClaimedBy { get; set; }
		public DateTime? DeliveryClaimedOn { get; set; }
		public string BusinessAddress { get; set; }
		public bool TaxesDelayed { get; set; }
		public string Notes { get; set; }
		public string SpecialRequest { get; set; }
		public string InvoiceSetup1 { get; set; }
		public bool IsRedated
		{
			get { return PayrollPayDay != PayrollTaxPayDay; }

		}
	}
}
