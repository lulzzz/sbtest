using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;

namespace HrMaxx.OnlinePayroll.Models
{
	public class Employee : BaseEntityDto, IOriginator<Employee>
	{
		public Guid HostId { get; set; }
		public Guid CompanyId { get; set; }
		public int EmployeeIntId { get; set; }
		public string FirstName { get; set; }
		public string MiddleInitial { get; set; }
		public string LastName { get; set; }
		public Contact Contact { get; set; }
		public GenderType Gender { get; set; }
		public string SSN { get; set; }
		public DateTime? BirthDate { get; set; }
		//Employment
		public DateTime HireDate { get; set; }
		public DateTime SickLeaveHireDate { get; set; }
		public DateTime? TerminationDate { get; set; }
		public decimal CarryOver { get; set; }
		public decimal SickLeaveCashPaidHours { get; set; }
		public string Department { get; set; }
		public StatusOption StatusId { get; set; }
		public string EmployeeNo { get; set; }
		public int? CompanyEmployeeNo { get; set; }
		public string ClockId { get; set; }
		public string Memo { get; set; }
		public string Notes { get; set; }
		//Payroll
		public PayrollSchedule PayrollSchedule { get; set; }
		public EmployeeType PayType { get; set; }
		public decimal Rate { get; set; }
		public List<CompanyPayCode> PayCodes { get; set; }
		public List<EmployeePayType> Compensations { get; set; }
		public List<int> PayTypeAccruals { get; set; } 
		public EmployeePaymentMethod PaymentMethod { get; set; }
		
		public List<EmployeeBankAccount> BankAccounts { get; set; }
		public bool DirectDebitAuthorized { get; set; }
		//Taxation
		public EmployeeTaxCategory TaxCategory { get; set; }
		public EmployeeTaxStatus FederalStatus { get; set; }
		public int FederalExemptions { get; set; }
		public decimal FederalAdditionalAmount { get; set; }
		public bool? UseW4Fields { get; set; }
		public bool? MultipleJobs { get; set; }
		public int? DependentChildren { get; set; }
		public int? OtherDependent { get; set; }
		public decimal? OtherIncome { get; set; }
		public decimal? FederalDeductions { get; set; }
		public decimal? FederalAdditionalWithholding { get; set; }
		public EmployeeState State { get; set; }
		public List<EmployeeACA> EmployeeACAs { get; set; }
		public List<EmployeeDeduction> Deductions { get; set; }
		public CompanyWorkerCompensation WorkerCompensation { get; set; }
		public List<PayCheckPayTypeAccumulation> Accumulations { get; set; } 
		public DateTime? LastPayrollDate { get; set; }
		public bool IsTipped { get; set; }
		public string GetSearchText
		{
			get
			{
				var searchText = string.Empty;
				searchText += FullName + " (" + SSN + ")";
				if (StatusId == StatusOption.Terminated || StatusId == StatusOption.InActive)
					searchText += " - " + StatusId.GetDbName();
				return searchText;
			}
		}

		public string FullName
		{
			get { return string.Format("{0}{2}{1}", FirstName, LastName, string.Format(" {0}",!string.IsNullOrWhiteSpace(MiddleInitial)? MiddleInitial.Substring(0,1) + " " : string.Empty) ); }
		}

		public string FullNameSpecial
		{
			get { return string.Format("{0}, {1} {2}", LastName, FirstName, string.Format(" {0}", !string.IsNullOrWhiteSpace(MiddleInitial) ? MiddleInitial.Substring(0, 1) + " " : string.Empty)); }
		}

		public Guid MementoId
		{
			get { return Id; }
		}

		public void ApplyMemento(Memento<Employee> memento)
		{
			throw new NotImplementedException();
		}
	}

	public class EmployeePayType
	{
		public PayType PayType { get; set; }
		public decimal Amount { get; set; }
	}

	public class EmployeeState
	{
		public State State { get; set; }
		public EmployeeTaxStatus TaxStatus { get; set; }
		public int Exemptions { get; set; }
		public decimal AdditionalAmount { get; set; }
		public bool IsSitExempt { get; set; }
	}

	public class EmployeeACA
	{
		public Guid EmployeeId { get; set; }
		public int Year { get; set; }
		public decimal Amount { get; set; }
		public DateTime LastModified { get; set; }
		public string LastModifiedBy { get; set; }
	}
	public class EmployeeDeduction
	{
		public int Id { get; set; }
		public Guid EmployeeId { get; set; }
		public CompanyDeduction Deduction { get; set; }
		public DeductionMethod Method { get; set; }
		public decimal Rate { get; set; }

        public decimal? EmployerRate { get; set; }
        public decimal? AnnualMax { get; set; }
		public DeductionMethod? CeilingMethod { get; set; }
		public decimal? CeilingPerCheck { get; set; }
		public decimal? Limit { get; set; }
		public int? Priority { get; set; }
		public string AccountNo { get; set; }
		public Guid? AgencyId { get; set; }
        public string Note { get; set; }
		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
		public decimal EmployeeWithheld { get; set; }
        public decimal EmployerWithheld { get; set; }
	}

	public class EmployeeBankAccount
	{
		public int Id { get; set; }
		public Guid EmployeeId { get; set; }
		public decimal Percentage { get; set; }
		public BankAccount BankAccount { get; set; }
	}

	public class EmployeeMinified
	{
		public Guid HostId { get; set; }
		public Guid CompanyId { get; set; }
		public int EmployeeIntId { get; set; }
		public string FirstName { get; set; }
		public string MiddleInitial { get; set; }
		public string LastName { get; set; }
		public Contact Contact { get; set; }
		
		public string SSN { get; set; }
		
		//Employment
		public DateTime HireDate { get; set; }
		
	}
}
