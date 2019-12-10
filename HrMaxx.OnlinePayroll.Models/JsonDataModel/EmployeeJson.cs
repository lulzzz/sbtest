using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	[Serializable]
	[XmlRoot("EmployeeList")]
	public class EmployeeJson
	{
		public Guid Id { get; set; }
		public Guid CompanyId { get; set; }
		public Guid HostId { get; set; }
		public int EmployeeIntId { get; set; }
		public int StatusId { get; set; }
		public string FirstName { get; set; }
		public string LastName { get; set; }
		public string MiddleInitial { get; set; }
		public string Contact { get; set; }
		public int Gender { get; set; }
		public string SSN { get; set; }
		public DateTime? BirthDate { get; set; }
		public DateTime HireDate { get; set; }
		public DateTime? SickLeaveHireDate { get; set; }
		public decimal CarryOver { get; set; }
		public string Department { get; set; }
		public string EmployeeNo { get; set; }
		public string Memo { get; set; }
		public int PayrollSchedule { get; set; }
		public int PayType { get; set; }
		public decimal Rate { get; set; }
		public string PayCodes { get; set; }
		public string Compensations { get; set; }
		public string PayTypeAccruals { get; set; }
		public int PaymentMethod { get; set; }
		public bool DirectDebitAuthorized { get; set; }
		public int TaxCategory { get; set; }
		public int FederalStatus { get; set; }
		public int FederalExemptions { get; set; }
		public decimal FederalAdditionalAmount { get; set; }
		public string State { get; set; }
		public DateTime LastModified { get; set; }
		public string LastModifiedBy { get; set; }
		public int? WorkerCompensationId { get; set; }
		public DateTime? LastPayrollDate { get; set; }
		public DateTime? LastPayDay {get; set; }
		public int? CompanyEmployeeNo { get; set; }
		public string Notes { get; set; }



		public List<EmployeeDeduction> EmployeeDeductions { get; set; }
		public CompanyWorkerCompensation CompanyWorkerCompensation { get; set; }
		public List<EmployeeBankAccount> EmployeeBankAccounts { get; set; }
		public List<PayCheckPayTypeAccumulation> Accumulations { get; set; }
	}
	[Serializable]
	[XmlRoot("EmployeeMinifiedList")]
	public class EmployeeMinifiedJson
	{
		public Guid Id { get; set; }
		public Guid CompanyId { get; set; }
		public Guid HostId { get; set; }
		public int EmployeeIntId { get; set; }
		public int StatusId { get; set; }
		public string FirstName { get; set; }
		public string LastName { get; set; }
		public string MiddleInitial { get; set; }
		public string Contact { get; set; }
		
		public string SSN { get; set; }
		
		public DateTime HireDate { get; set; }
		
	}
	 public class EmployeeDeduction
    {
        public int Id { get; set; }
        public Guid EmployeeId { get; set; }
        public int Method { get; set; }
        public decimal Rate { get; set; }
        public decimal? EmployerRate { get; set; }
        public decimal? AnnualMax { get; set; }
        public int CompanyDeductionId { get; set; }
        public decimal? CeilingPerCheck { get; set; }
        public string AccountNo { get; set; }
        public Guid? AgencyId { get; set; }
        public int? Priority { get; set; }
        public decimal? Limit { get; set; }
        public int CeilingMethod { get; set; }
    
        public CompanyDeduction CompanyDeduction { get; set; }
        public decimal EmployeeWithheld { get; set; }
        public decimal EmployerWithheld { get; set; }

    }
	 public class EmployeeBankAccount
    {
        public int Id { get; set; }
        public Guid EmployeeId { get; set; }
        public int BankAccountId { get; set; }
        public decimal Percentage { get; set; }
    
        public BankAccount BankAccount { get; set; }
        
    }
	public partial class BankAccount
    {
        
        public int Id { get; set; }
        public int EntityTypeId { get; set; }
        public Guid? EntityId { get; set; }
        public int AccountType { get; set; }
        public string BankName { get; set; }
        public string AccountName { get; set; }
        public string AccountNumber { get; set; }
        public string RoutingNumber { get; set; }
        public DateTime LastModified { get; set; }
        public string LastModifiedBy { get; set; }
        public string FractionId { get; set; }
    
        
    }

}
