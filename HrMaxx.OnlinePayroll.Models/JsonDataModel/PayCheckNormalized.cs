using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using HrMaxx.OnlinePayroll.Models.Enum;
using Newtonsoft.Json;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	public class PayCheckPayTypeAccumulation
	{
		public int PayCheckId { get; set; }
		public int PayTypeId { get; set; }
		public string PayTypeName { get; set; }
		public DateTime FiscalStart { get; set; }
		public DateTime FiscalEnd { get; set; }
		public decimal AccumulatedValue { get; set; }
		public decimal Used { get; set; }
		public decimal CarryOver { get; set; }
		public decimal YTDFiscal { get; set; }
		public decimal YTDUsed { get; set; }
		public decimal Available
		{
			get { return CarryOver + YTDFiscal - YTDUsed; }
		}
	}
	
	public class PayCheckTax
	{
		public int PayCheckId { get; set; }
		public int TaxId { get; set; }
		public Models.Tax Tax { get; set; }
		public decimal TaxableWage { get; set; }
		public decimal Amount { get; set; }
		public decimal YTDWage { get; set; }
		public decimal YTD { get; set; }

		public bool IsEmployeeTax { get { return Tax.IsEmployeeTax; } }
	}
	
	public class PayCheckCompensation
	{
		public int PayCheckId { get; set; }
		public int PayTypeId { get; set; }
		public string PayTypeName { get; set; }
		public Models.PayType PayType { get; set; }
		public decimal Amount { get; set; }
		public decimal YTD { get; set; }
	}

	
	public class PayCheckDeduction
	{
		public int PayCheckId { get; set; }
		public int EmployeeDeductionId { get; set; }
		public int CompanyDeductionId { get; set; }
		public string EmployeeDeductionFlat { get; set; }
		public DeductionMethod Method { get; set; }
		public decimal Rate { get; set; }
		public decimal? AnnualMax { get; set; }
		public decimal Wage { get; set; }
		public decimal Amount { get; set; }
		public decimal YTD { get; set; }
		public decimal YTDWage { get; set; }
		public Models.CompanyDeduction CompanyDeduction { get; set; }
		public Models.EmployeeDeduction EmployeeDeduction
		{
			get { return !string.IsNullOrWhiteSpace(EmployeeDeductionFlat) ? JsonConvert.DeserializeObject<Models.EmployeeDeduction>(EmployeeDeductionFlat) : default(Models.EmployeeDeduction); }
		}
	}
	
	public class PayCheckPayCode
	{
		public int PayCheckId { get; set; }
		public int PayCodeId { get; set; }
		public string PayCodeFlat { get; set; }
		public decimal Amount { get; set; }
		public decimal Overtime { get; set; }
		public decimal YTDAmount { get; set; }
		public decimal YTDOvertime { get; set; }
		public Models.CompanyPayCode PayCode { get { return !string.IsNullOrWhiteSpace(PayCodeFlat) ? JsonConvert.DeserializeObject<Models.CompanyPayCode>(PayCodeFlat) : default(Models.CompanyPayCode); } }
	}
	
	public class PayCheckWorkerCompensation
	{
		public int PayCheckId { get; set; }
		public int WorkerCompensationId { get; set; }
		public Models.CompanyWorkerCompensation CompanyWorkerCompensation { get; set; }
		public string WorkerCompensationFlat { get; set; }
		public decimal Wage { get; set; }
		public decimal Amount { get; set; }
		public decimal YTD { get; set; }

		public Models.CompanyWorkerCompensation WorkerCompensation
		{
			get { return !string.IsNullOrWhiteSpace(WorkerCompensationFlat) ? JsonConvert.DeserializeObject<Models.CompanyWorkerCompensation>(WorkerCompensationFlat) : default(Models.CompanyWorkerCompensation); }
		}
	}

	public class PayCheckWages
	{
		public decimal GrossWage { get; set; }
		public decimal Salary { get; set; }
		public decimal NetWage { get; set; }
		public decimal CheckPay { get; set; }
		public decimal DDPay { get; set; }
		public decimal Quarter1FUTA { get; set; }
		public decimal Quarter2FUTA { get; set; }
		public decimal Quarter3FUTA { get; set; }
		public decimal Quarter4FUTA { get; set; }
		public decimal Quarter1FUTAWage { get; set; }
		public decimal Quarter2FUTAWage { get; set; }
		public decimal Quarter3FUTAWage { get; set; }
		public decimal Quarter4FUTAWage { get; set; }
		public decimal FUTARate { get; set; }
		public decimal MedicareExtraWages { get; set; }
		public int Immigrants { get; set; }

		public int Twelve1 { get; set; }
		public int Twelve2 { get; set; }
		public int Twelve3 { get; set; }

		public int EmployeeCount { get; set; }

		public decimal DepositAmount { get; set; }
	}

	public class PayCheckSummary
	{
		public int Id { get; set; }
		public int CheckNumber { get; set; }
		public int PaymentMethod { get; set; }
		public DateTime PayDay { get; set; }
		public string FirstName { get; set; }
		public string LastName { get; set; }
		public decimal GrossWage { get; set; }
		public string FullName { get { return string.Format("{0} {1}", FirstName, LastName); } }
		public bool PEOASOCoCheck { get; set; }
		public decimal NetWage { get; set; }
		public bool IsVoid { get; set; }
		public Guid CompanyId { get; set; }
		public bool IsReIssued { get; set; }
		public int? OriginalCheckNumber { get; set; }
		public DateTime? ReIssuedDate { get; set; }
		
	}

	public class PayCheckSummary1095
	{
		public decimal Salary { get; set; }
		public decimal GrossWage { get; set; }
		public DateTime PayDay { get; set; }
		public string PayCodesFlat { get; set; }
		
		public List<PayrollPayCode> PayCodes { get
		{
			return string.IsNullOrWhiteSpace(PayCodesFlat)
				? new List<PayrollPayCode>()
				: JsonConvert.DeserializeObject<List<PayrollPayCode>>(PayCodesFlat);
		} }
		public List<PayCheckDeduction> Deductions { get; set; }
	}
}
