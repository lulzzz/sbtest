﻿using System;
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
		public DateTime PayrollPayDay { get; set; }
		public DateTime PayrollTaxPayDay { get; set; }
		
		public int NoOfChecks { get; set; }
		public decimal GrossWages { get; set; }
		public decimal EmployeeContribution { get; set; }
		public decimal EmployerContribution { get; set; }
		public decimal AdminFee { get; set; }
		public decimal EnvironmentalFee { get; set; }
		public List<PayrollTaxResource> EmployerTaxes { get; set; }
		public List<PayrollTaxResource> EmployeeTaxes { get; set; }
		public List<PayrollDeductionResource> Deductions { get; set; }
		public List<InvoiceWorkerCompensation> WorkerCompensations { get; set; }
		public List<MiscFee> MiscCharges { get; set; }

		public decimal WorkerCompensationCharges { get; set; }
		public decimal MiscFees { get; set; }
		public decimal Total { get; set; }

		public InvoiceStatus Status { get; set; }
		public DateTime? SubmittedOn { get; set; }
		public DateTime? DeliveredOn { get; set; }
		public string SubmittedBy { get; set; }
		public string DeliveredBy { get; set; }
		public CompanyResource Company { get; set; }
		public string Courier { get; set; }
		public List<InvoicePaymentResource> InvoicePayments { get; set; }
		public List<InvoiceLateFeeConfig> TaxPaneltyConfig { get; set; }
		public string Notes { get; set; }
		public string ProcessedBy { get; set; }
		public DateTime ProcessedOn { get; set; }
		public decimal PaidAmount { get; set; }
		
		public decimal Balance { get; set; }
		public List<int> PayChecks { get; set; }
		public List<int> VoidedCreditedChecks { get; set; }
		public bool ApplyWCMinWageLimit { get; set; }

		public decimal CheckPay { get; set; }
		public decimal DDPay { get; set; }
		public decimal NetPay { get; set; }

		public Guid? SalesRep { get; set; }
		public decimal Commission { get; set; }
		public bool CommissionClaimed { get; set; }

		public string DeliveryClaimedBy { get; set; }
		public DateTime DeliveryClaimedOn { get; set; }

		public bool HasVoidedCredits
		{
			get { return MiscCharges.Any(mc => mc.PayCheckId > 0); }
		}

		public string StatusText
		{
			get { return Status.GetDbName(); }
		}

		public string CompanyName
		{
			get { return Company.Name; }
		}

		public string City
		{
			get { return Company.BusinessAddress.City; }
		}
		public int DaysOverdue
		{
			get 
			{
				if (Balance <= 0 )
				{
					var lastPayment =
						InvoicePayments.Where(p => p.Status == PaymentStatus.Paid).OrderByDescending(p => p.PaymentDate.Date).FirstOrDefault();
					if(lastPayment!=null)
						return lastPayment.PaymentDate.Date.Subtract(InvoiceDate.Date).Days;
					else
					{
						return 0;
					}

				}
				return DateTime.Today.Subtract(InvoiceDate).Days;
			}
		}

		public decimal LateTaxPenalty
		{
			get
			{
				var penalty = (decimal) 0;
				var rate = (decimal) 0;
				if (DaysOverdue <= 0 || TaxPaneltyConfig==null || !TaxPaneltyConfig.Any())
					return 0;
				var configRow = TaxPaneltyConfig.FirstOrDefault(t => t.DaysFrom <= DaysOverdue && t.DaysTo >= DaysOverdue);
				if (configRow == null)
					return 0;
				
				var taxes = EmployeeTaxes.Sum(t => t.Amount) + EmployerTaxes.Sum(t => t.Amount);
					
				penalty = Math.Round((configRow.Rate / 100) * taxes, 2, MidpointRounding.AwayFromZero);
				return penalty;
			}
		}

		public DateTime? LastDepositDate
		{
			get { return InvoicePayments.Any() ? InvoicePayments.OrderByDescending(p => p.PaymentDate).First().PaymentDate : default(DateTime?); }
		}

		public string CheckNumbers
		{
			get
			{
				return InvoicePayments.Any(p => p.Method == InvoicePaymentMethod.Check)
					? InvoicePayments.Where(p => p.Method == InvoicePaymentMethod.Check)
						.ToList()
						.Aggregate(string.Empty, (current, m) => current + m.CheckNumber + ", ")
					: string.Empty;
			}
		}
	}
	
}