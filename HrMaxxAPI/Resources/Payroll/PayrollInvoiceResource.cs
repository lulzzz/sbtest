using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxxAPI.Resources.OnlinePayroll;

namespace HrMaxxAPI.Resources.Payroll
{
	public class PayrollInvoiceResource : BaseRestResource
	{
		public Guid CompanyId { get; set; }
		public Guid PayrollId { get; set; }
		public InvoiceSetupResource CompanyInvoiceSetup { get; set; }
		public int InvoiceNumber { get; set; }
		public DateTime PeriodStart { get; set; }
		public DateTime PeriodEnd { get; set; }
		public DateTime InvoiceDate { get; set; }
		public DateTime DueDate { get; set; }
		public DateTime ExpiryDate { get; set; }
		public int NoOfChecks { get; set; }
		public decimal GrossWages { get; set; }
		public decimal EmployeeContribution { get; set; }
		public decimal EmployerContribution { get; set; }
		public decimal AdminFee { get; set; }
		public decimal EnvironmentalFee { get; set; }
		public List<PayrollDeductionResource> Deductions { get; set; } 
		public List<PayrollTaxResource> EmployerTaxes { get; set; }
		public List<PayrollWorkerCompensationResource> WorkerCompensations { get; set; }
		public List<MiscFee> MiscCharges { get; set; }

		public decimal DeductionsCredit { get; set; }
		public decimal WorkerCompensationCharges { get; set; }
		public decimal MiscFees { get; set; }
		public decimal Total { get; set; }

		public InvoiceStatus Status { get; set; }
		public DateTime? SubmittedOn { get; set; }
		public DateTime? DeliveredOn { get; set; }
		public string SubmittedBy { get; set; }
		public string DeliveredBy { get; set; }
		public CompanyResource Company { get; set; }

		public List<InvoicePaymentResource> Payments { get; set; }

		public decimal PaidAmount { get; set; }
		
		public decimal Balance { get; set; }

		public string StatusText
		{
			get { return Status.GetDbName(); }
		}

	}
	
}