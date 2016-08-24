using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxxAPI.Resources.Common;
using EmployeePayType = HrMaxx.OnlinePayroll.Models.EmployeePayType;

namespace HrMaxxAPI.Resources.OnlinePayroll
{
	public class EmployeeResource : BaseRestResource
	{
		public Guid CompanyId { get; set; }
		public Contact Contact { get; set; }
		public GenderType Gender { get; set; }
		public string SSN { get; set; }
		public DateTime BirthDate { get; set; }
		//Employment
		public DateTime HireDate { get; set; }
		public string Department { get; set; }
		public StatusOption StatusId { get; set; }
		public string EmployeeNo { get; set; }
		public string Memo { get; set; }
		//Payroll
		public PayrollSchedule PayrollSchedule { get; set; }
		public EmployeeType PayType { get; set; }
		public decimal Rate { get; set; }
		public List<CompanyPayCodeResource> PayCodes { get; set; }
		public List<EmployeePayTypeResource> Compensations { get; set; }
		public EmployeePaymentMethod PaymentMethod { get; set; }
		public BankAccountResource BankAccount { get; set; }
		public bool DirectDebitAuthorized { get; set; }
		//Taxation
		public EmployeeTaxCategory TaxCategory { get; set; }
		public EmployeeTaxStatus FederalStatus { get; set; }
		public int FederalExemptions { get; set; }
		public decimal FederalAdditionalAmount { get; set; }
		public EmployeeStateResource State { get; set; }
		public List<EmployeeDeductionResource> Deductions { get; set; }
		public CompanyWorkerCompensationResource WorkerCompensation { get; set; }

		public DateTime? LastPayrollDate { get; set; }

		public string StatusText
		{
			get { return StatusId.GetDbName(); }
		}

		public string Name
		{
			get { return string.Format("{0} {1} {2}", Contact.FirstName, Contact.MiddleInitial, Contact.LastName); }
		}
		
	}
	public class EmployeePayTypeResource
	{
		public PayType PayType { get; set; }
		public decimal Amount { get; set; }
	}

	public class EmployeeStateResource
	{
		public State State { get; set; }
		public EmployeeTaxStatus TaxStatus { get; set; }
		public int Exemptions { get; set; }
		public decimal AdditionalAmount { get; set; }
	}

	public class EmployeeDeductionResource
	{
		public int? Id { get; set; }
		[Required]
		public Guid EmployeeId { get; set; }
		[Required]
		public CompanyDeductionResource Deduction { get; set; }
		[Required]
		public KeyValuePair<int, string> Method { get; set; }
		[Required]
		public decimal Rate { get; set; }
		public decimal? AnnualMax { get; set; }
	}
}