using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Infrastructure.Attributes;

namespace HrMaxx.Common.Models.Enum
{
	public enum EntityTypeEnum
	{
		[HrMaxxSecurity(DbId = 0, DbName = "General")]
		General=0,
		[HrMaxxSecurity(DbId = 1, DbName = "Host")]
		Host=1,
		[HrMaxxSecurity(DbId = 2, DbName = "Company")]
		Company=2,
		[HrMaxxSecurity(DbId = 3, DbName = "Employee")]
		Employee=3,
		[HrMaxxSecurity(DbId = 4, DbName = "Contact")]
		Contact=4,
		[HrMaxxSecurity(DbId = 5, DbName = "Address")]
		Address=5,
		[HrMaxxSecurity(DbId = 6, DbName = "COA")]
		COA=6,
		[HrMaxxSecurity(DbId = 7, DbName = "Pay Check")]
		PayCheck=7,
		[HrMaxxSecurity(DbId = 8, DbName = "Regular Check")]
		RegularCheck=8,
		[HrMaxxSecurity(DbId = 9, DbName = "EFT")]
		EFT=9,
		[HrMaxxSecurity(DbId = 10, DbName = "Deposit")]
		Deposit=10,
		[HrMaxxSecurity(DbId = 11, DbName = "Invoice")]
		Invoice=11,
		[HrMaxxSecurity(DbId = 12, DbName = "User")]
		User =12,
		[HrMaxxSecurity(DbId = 13, DbName = "Document")]
		Document = 13,
		[HrMaxxSecurity(DbId = 14, DbName = "Comment")]
		Comment = 14,
		[HrMaxxSecurity(DbId = 15, DbName = "Vendor")]
		Vendor=15,
		[HrMaxxSecurity(DbId = 16, DbName = "Customer")]
		Customer=16,
		[HrMaxxSecurity(DbId = 17, DbName = "HostHomePage")]
		HostHomePage=17,
		[HrMaxxSecurity(DbId = 18, DbName = "Adjustment")]
		Adjustment=18,
		[HrMaxxSecurity(DbId = 19, DbName = "Tax Payment")]
		TaxPayment=19,
		[HrMaxxSecurity(DbId = 20, DbName = "Payroll")]
		Payroll=20,
		[HrMaxxSecurity(DbId = 21, DbName = "Extract")]
		Extract = 21,
		[HrMaxxSecurity(DbId = 22, DbName = "Invoice Deposit")]
		InvoiceDeposit = 22
	}
}
