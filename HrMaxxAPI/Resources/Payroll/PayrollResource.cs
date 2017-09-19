using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxxAPI.Resources.Common;
using HrMaxxAPI.Resources.OnlinePayroll;

namespace HrMaxxAPI.Resources.Payroll
{
	public class PayrollResource : BaseRestResource
	{
		[Required]
		public CompanyResource Company { get; set; }
		[Required]
		public DateTime StartDate { get; set; }
		[Required]
		public DateTime EndDate { get; set; }
		[Required]
		public DateTime PayDay { get; set; }
		[Required]
		public DateTime TaxPayDay { get; set; }
		[Required]
		public List<PayCheckResource> PayChecks { get; set; }
		public int StartingCheckNumber { get; set; }
		public string Notes { get; set; }
		public Guid? InvoiceId { get; set; }
		public decimal Total { get; set; }
		public int InvoiceNumber { get; set; }
		public InvoiceStatus InvoiceStatus { get; set; }
		public bool TaxesDelayed { get; set; }
		public PayrollStatus Status { get; set; }
		public DateTime LastModified { get; set; }

		public decimal TotalGrossWage { get; set; }
		public decimal TotalNetWage { get; set; }
		public decimal TotalCost { get; set; }
		public decimal DeductionAmount { get; set; }
		public decimal EmployeeTaxes { get; set; }
		public decimal EmployerTaxes { get; set; }

		public bool PEOASOCoCheck { get; set; }
		public bool IsHistory { get; set; }

		public Guid? CopiedFrom { get; set; }
		public Guid? MovedFrom { get; set; }

		public string StatusText
		{
			get { return Status.GetDbName(); }
		}
		public string InvoiceStatusText
		{
			get { return InvoiceStatus.GetDbName(); }
		}

		public string CompanyName
		{
			get { return Company.Name; }
		}

		public int MaxCheckId
		{
			get { return PayChecks.Max(pc => pc.Id != null ? pc.Id.Value : 0); }
		}

	}

	public class PayrollMinifiedResource
	{
		public Guid Id { get; set; }
		public string CompanyName { get; set; }
		public DateTime StartDate { get; set; }
		public DateTime EndDate { get; set; }
		public DateTime PayDay { get; set; }
		public DateTime LastModified { get; set; }
		public bool IsHistory { get; set; }
		public string ProcessedBy { get; set; }
		public PayrollStatus Status { get; set; }

		public Guid? InvoiceId { get; set; }
		public decimal Total { get; set; }
		public int InvoiceNumber { get; set; }
		public InvoiceStatus InvoiceStatus { get; set; }
		public decimal TotalGrossWage { get; set; }
		public decimal TotalNetWage { get; set; }

		public string PayDayText
		{
			get { return PayDay.ToString("MM/dd/yyyy"); }
		}

		public string StatusText
		{
			get { return Status.GetDbName(); }
		}
		public string InvoiceStatusText
		{
			get { return InvoiceStatus.GetDbName(); }
		}
	}
	public class PayCheckResource
	{
		public Guid PayrollId { get; set; }
		public Guid CompanyId { get; set; }
		public int? Id { get; set; }
		[Required]
		public EmployeeResource Employee { get; set; }
		public List<PayrollPayCodeResource> PayCodes { get; set; }
		public decimal Salary { get; set; }
		public List<PayrollPayTypeResource> Compensations { get; set; }
		public List<PayrollDeductionResource> Deductions { get; set; }
		public int? CheckNumber { get; set; }
		public List<PayrollTaxResource> Taxes { get; set; }
		public string Notes { get; set; }
		public List<PayTypeAccumulationResource> Accumulations { get; set; }
		public PaycheckStatus Status { get; set; }
		public EmployeePaymentMethod PaymentMethod { get; set; }

		public bool IsVoid { get; set; }
		public decimal GrossWage { get; set; }
		public decimal NetWage { get; set; }
		public decimal WCAmount { get; set; }
		public PayrollWorkerCompensationResource WorkerCompensation { get; set; }

		public decimal YTDSalary { get; set; }
		public decimal YTDGrossWage { get; set; }
		public decimal YTDNetWage { get; set; }

		public decimal DeductionAmount { get; set; }
		public decimal DeductionYTD { get; set; }
		public decimal CompensationTaxableAmount { get; set; }
		public decimal CompensationTaxableYTD { get; set; }
		public decimal CompensationNonTaxableAmount { get; set; }
		public decimal CompensationNonTaxableYTD { get; set; }
		public decimal CalculatedSalary { get; set; }
		public decimal CalculatedSalaryYTD { get; set; }
		public decimal EmployeeTaxes { get; set; }
		public decimal EmployerTaxes { get; set; }
		public decimal EmployeeTaxesYTD { get; set; }
		public decimal EmployerTaxesYTD { get; set; }
		public decimal EmployeeTaxesYTDWage { get; set; }
		public decimal EmployerTaxesYTDWage { get; set; }
		public decimal Cost { get; set; }

		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
		public DateTime? PayDay { get; set; }
		public DateTime? TaxPayDay { get; set; }

		public string LastModifiedBy { get; set; }
		public DateTime LastModified { get; set; }

		public bool PEOASOCoCheck { get; set; }
		public bool IsHistory { get; set; }

		public Guid? InvoiceId { get; set; }
		public DateTime? VoidedOn { get; set; }
		
		public Guid? CreditInvoiceId { get; set; }
		
		public bool Included { get; set; }

		public bool IsReIssued { get; set; }
		public int? OriginalCheckNumber { get; set; }
		public DateTime? ReIssuedDate { get; set; }

		public string PaymentMethodText
		{
			get { return PaymentMethod.GetDbName(); }
		}
		public string StatusText
		{
			get { return Status.GetDbName(); }
		}
		
		public string EmployeeName { get { return Employee.Name; } }
		public string Department { get { return Employee.Department; } }
	}

	public class PayrollWorkerCompensationResource
	{
		public CompanyWorkerCompensationResource WorkerCompensation { get; set; }
		public decimal Amount { get; set; }
		public decimal Wage { get; set; }
		public decimal YTD { get; set; }
	}

	public class PayrollPayCodeResource
	{
		[Required]
		public CompanyPayCodeResource PayCode { get; set; }
		public string ScreenHours { get; set; }
		public string ScreenOvertime { get; set; }
		public decimal Hours { get; set; }
		public decimal OvertimeHours { get; set; }
		public decimal PWAmount { get; set; }
		public decimal BreakTime { get; set; }
		public decimal SickLeaveTime { get; set; }
		public decimal Amount { get; set; }
		public decimal YTD { get; set; }
		public decimal OvertimeAmount { get; set; }
		public decimal YTDOvertime { get; set; }
	}

	public class PayrollTaxResource
	{
		public Tax Tax { get; set; }
		public decimal TaxableWage { get; set; }
		public decimal Amount { get; set; }

		public decimal YTDWage { get; set; }
		public decimal YTDTax { get; set; }

		public bool IsEmployeeTax
		{
			get { return Tax.IsEmployeeTax; }
		}
	}

	public class PayrollPayTypeResource
	{
		[Required]
		public PayType PayType { get; set; }
		[Required]
		public decimal Amount { get; set; }
		public decimal Hours { get; set; }
		public decimal Rate { get; set; }
		public decimal YTD { get; set; }
	}

	public class PayrollDeductionResource
	{
		[Required]
		public CompanyDeduction Deduction { get; set; }
		[Required]
		public EmployeeDeductionResource EmployeeDeduction { get; set; }
		[Required]
		public KeyValuePair<int, string> Method { get; set; }
		[Required]
		public decimal Rate { get; set; }
		public decimal? AnnualMax { get; set; }
		public decimal Wage { get; set; }
		public decimal Amount { get; set; }
		public decimal YTD { get; set; }
		public decimal YTDWage { get; set; }

		public string Name
		{
			get { return string.Format("{0} - {1}", Deduction.Type.Name, Deduction.DeductionName); }
		}
		public int Sort { get; set; }
	}

	public class PayTypeAccumulationResource
	{
		[Required]
		public AccumulatedPayTypeResource PayType { get; set; }
		[Required]
		public DateTime FiscalStart { get; set; }
		[Required]
		public DateTime FiscalEnd { get; set; }
		public decimal AccumulatedValue { get; set; }
		public decimal YTDFiscal { get; set; }
		public decimal Used { get; set; }
		public decimal YTDUsed { get; set; }
		public decimal CarryOver { get; set; }

		public decimal Available { get; set; }
	}
}