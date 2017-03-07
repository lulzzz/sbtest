﻿using System;
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
	}
}
