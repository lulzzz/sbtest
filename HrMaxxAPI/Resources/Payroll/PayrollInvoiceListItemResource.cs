using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxxAPI.Resources.Payroll
{
	public class PayrollInvoiceListItemResource
	{
		public Guid Id { get; set; }
		public Guid CompanyId { get; set; }
		public string CompanyName { get; set; }
		public bool IsHostCompany { get; set; }
		public bool IsVisibleToHost { get; set; }
		public Guid HostId { get; set; }
		public int InvoiceNumber { get; set; }
		public DateTime InvoiceDate { get; set; }
		public decimal Total { get; set; }
		public decimal Balance { get; set; }
		public string ProcessedBy { get; set; }
		public InvoiceStatus Status { get; set; }
		public DateTime ProcessedOn { get; set; }
		public DateTime? DeliveredOn { get; set; }
		public string Courier { get; set; }
		public string CheckNumbers { get; set; }
		public DateTime? LastPayment { get; set; }
		public List<InvoiceLateFeeConfig> TaxPaneltyConfig { get; set; }
		public List<PayrollTax> EmployeeTaxes { get; set; }
		public List<PayrollTax> EmployerTaxes { get; set; }
		public string StatusText
		{
			get { return Status.GetDbName(); }
		}
		public int DaysOverdue
		{
			get
			{
				if (Balance <= 0)
				{
					if (LastPayment.HasValue)
						return LastPayment.Value.Date.Subtract(InvoiceDate.Date).Days;
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
				var penalty = (decimal)0;
				var rate = (decimal)0;
				if (DaysOverdue <= 0 || TaxPaneltyConfig == null || !TaxPaneltyConfig.Any())
					return 0;
				var configRow = TaxPaneltyConfig.FirstOrDefault(t => t.DaysFrom <= DaysOverdue && t.DaysTo >= DaysOverdue);
				if (configRow == null)
					return 0;

				var taxes = EmployeeTaxes.Sum(t => t.Amount) + EmployerTaxes.Sum(t => t.Amount);

				penalty = Math.Round((configRow.Rate / 100) * taxes, 2, MidpointRounding.AwayFromZero);
				return penalty;
			}
		}
	}
}