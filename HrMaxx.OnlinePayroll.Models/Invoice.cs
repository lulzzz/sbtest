using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class Invoice : BaseEntityDto
	{
		public Guid CompanyId { get; set; }
		public DateTime InvoiceDate { get; set; }
		public DateTime DueDate { get; set; }
		public string InvoiceNumber { get; set; }
		public decimal InvoiceValue { get; set; }
		public InvoiceStatus Status { get; set; }
		public RiskLevel RiskLevel { get; set; }
		public VendorDepositMethod InvoiceMethod { get; set; }
		public decimal InvoiceRate { get; set; }
		public decimal LineItemTotal
		{
			get { return Math.Round( LineItems.Sum(l => l.Amount), 2, MidpointRounding.AwayFromZero); }
		}

		public decimal Total
		{
			get { return Math.Round( InvoiceValue + LineItemTotal, 2, MidpointRounding.AwayFromZero); }
		}

		public decimal PaidAmount
		{
			get { return Math.Round(Payments.Where(p=>p.Status==PaymentStatus.Paid).Sum(p => p.Amount), 2, MidpointRounding.AwayFromZero); }
		}

		public decimal Balance
		{
			get { return Math.Round(Total - PaidAmount, 2, MidpointRounding.AwayFromZero); }
		}

		public DateTime? SubmittedOn { get; set; }
		public DateTime? DeliveredOn { get; set; }
		public string SubmittedBy { get; set; }
		public string DeliveredBy { get; set; }

		public List<Guid> PayrollIds { get; set; }
		public List<InvoiceLineItem> LineItems { get; set; }
		public List<InvoicePayment> Payments { get; set; } 

	}

	public class InvoiceLineItem
	{
		public string Description { get; set; }
		public decimal Amount { get; set; }
		public string Notes { get; set; }
	}

	public class InvoicePayment
	{
		public int Id { get; set; }
		public Guid InvoiceId { get; set; }
		public DateTime PaymentDate { get; set; }
		public InvoicePaymentMethod Method { get; set; }
		public PaymentStatus Status { get; set; }
		public int CheckNumber { get; set; }
		public decimal Amount { get; set; }
		public string LastModifiedBy { get; set; }
		public DateTime LastModified { get; set; }
		public string Notes { get; set; }
		public bool HasChanged { get; set; }
	}
	
}
