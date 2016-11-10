using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class Employee : BaseEntityDto, IOriginator<Employee>
	{
		public Guid CompanyId { get; set; }
		public string FirstName { get; set; }
		public string MiddleInitial { get; set; }
		public string LastName { get; set; }
		public Contact Contact { get; set; }
		public GenderType Gender { get; set; }
		public string SSN { get; set; }
		public DateTime? BirthDate { get; set; }
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
		public List<CompanyPayCode> PayCodes { get; set; }
		public List<EmployeePayType> Compensations { get; set; }
		public EmployeePaymentMethod PaymentMethod { get; set; }
		public BankAccount BankAccount { get; set; }
		public bool DirectDebitAuthorized { get; set; }
		//Taxation
		public EmployeeTaxCategory TaxCategory { get; set; }
		public EmployeeTaxStatus FederalStatus { get; set; }
		public int FederalExemptions { get; set; }
		public decimal FederalAdditionalAmount { get; set; }
		public EmployeeState State { get; set; }
		public List<EmployeeDeduction> Deductions { get; set; }
		public CompanyWorkerCompensation WorkerCompensation { get; set; }

		public DateTime? LastPayrollDate { get; set; }

		public string FullName
		{
			get { return string.Format("{0} {1}", FirstName, LastName); }
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
	}

	public class EmployeeDeduction
	{
		public int Id { get; set; }
		public Guid EmployeeId { get; set; }
		public CompanyDeduction Deduction { get; set; }
		public DeductionMethod Method { get; set; }
		public decimal Rate { get; set; }
		public decimal? AnnualMax { get; set; }
	}
}
