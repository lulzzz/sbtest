﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class Employee : BaseEntityDto
	{
		public Guid CompanyId { get; set; }
		public string FirstName { get; set; }
		public string MiddleInitial { get; set; }
		public string LastName { get; set; }
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
}
