using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxxAPI.Resources.Payroll
{
	public class InvoiceResource : BaseRestResource
	{
		[Required]
		public Guid CompanyId { get; set; }
		[Required]
		public DateTime InvoiceDate { get; set; }
		[Required]
		public DateTime DueDate { get; set; }
		public string InvoiceNumber { get; set; }
		[Required]
		public decimal InvoiceValue { get; set; }
		[Required]
		public InvoiceStatus Status { get; set; }
		public RiskLevel RiskLevel { get; set; }
		[Required]
		public VendorDepositMethod InvoiceMethod { get; set; }
		[Required]
		public decimal InvoiceRate { get; set; }
		[Required]
		public List<Guid> PayrollIds { get; set; }
		public List<InvoiceLineItemResource> LineItems { get; set; }

		public List<InvoicePaymentResource> Payments { get; set; }

		public decimal LineItemTotal { get; set; }
		public decimal PaidAmount { get; set; }
		public decimal Total { get; set; }

		public decimal Balance { get; set; }
		public DateTime? SubmittedOn { get; set; }
		public DateTime? DeliveredOn { get; set; }
		public string SubmittedBy { get; set; }
		public string DeliveredBy { get; set; }
		public string StatusText
		{
			get { return Status.GetDbName(); }
		}

		public string RiskLevelText
		{
			get { return RiskLevel.GetDbName(); }
		}
	}
	public class InvoiceLineItemResource
	{
		[Required]
		public string Description { get; set; }
		[Required]
		public decimal Amount { get; set; }
		public string Notes { get; set; }
	}
	
	public class InvoicePaymentResource
	{
		public int? Id { get; set; }
		public Guid InvoiceId { get; set; }
		public bool HasChanged { get; set; }
		public DateTime PaymentDate { get; set; }
		public InvoicePaymentMethod Method { get; set; }
		public PaymentStatus Status { get; set; }
		public int CheckNumber { get; set; }
		public decimal Amount { get; set; }
		public string LastModifiedBy { get; set; }
		public DateTime LastModified { get; set; }
		public string Notes { get; set; }
		public string StatusText
		{
			get { return Status.GetDbName(); }
		}
	}
}