﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;

namespace HrMaxx.OnlinePayroll.Models
{
	public class VoidedPayCheckInvoiceCredit
	{
		public int Id { get; set; }
		public string CheckNumber { get; set; }
		public EmployeePaymentMethod PaymentMethod { get; set; }
		public DateTime? VoidedOn { get; set; }
		public decimal GrossWage { get; set; }
		public decimal EmployeeTaxes { get; set; }
		public decimal EmployerTaxes { get { return EmployerTaxList.Sum(t => t.Amount); } }
		public List<PayrollDeduction> Deductions { get; set; }
		public InvoiceSetup InvoiceSetup { get; set; }
		public Guid InvoiceId { get; set; }
		public decimal Balance { get; set; }
		public int InvoiceNumber { get; set; }
		public List<MiscFee> MiscCharges { get; set; }

		public List<PayrollTax> Taxes { get; set; }
		public DateTime PayDay { get; set; }
		public List<PayrollTax> EmployerTaxList { get { return Taxes.Where(t => !t.IsEmployeeTax).ToList(); } }

	}

	public class InvoiceByStatus
	{
		public int InvoiceNumber { get; set; }
		public int Status { get; set; }
	}

}
