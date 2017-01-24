﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	[Serializable]
	[XmlRoot("PayrollList")]
	public class PayrollJson
	{
		public Guid Id { get; set; }
		public Guid CompanyId { get; set; }
		public DateTime StartDate { get; set; }
		public DateTime EndDate { get; set; }
		public DateTime PayDay { get; set; }
		public int StartingCheckNumber { get; set; }
		public string Company { get; set; }
		public DateTime LastModified { get; set; }
		public string LastModifiedBy { get; set; }
		public int Status { get; set; }
		public Guid? InvoiceId { get; set; }
		public bool PEOASOCoCheck { get; set; }
		public string Notes { get; set; }
		public PayrollInvoiceJson PayrollInvoice { get; set; }
		public List<PayrollPayCheckJson> PayrollPayChecks { get; set; }
	}
}
