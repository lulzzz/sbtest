using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data.Entity.Core.Common.CommandTrees.ExpressionBuilder;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;
using HrMaxxAPI.Resources.Common;
using Microsoft.Ajax.Utilities;
using EmployeePayType = HrMaxx.OnlinePayroll.Models.EmployeePayType;
using PayType = HrMaxx.OnlinePayroll.Models.PayType;

namespace HrMaxxAPI.Resources.OnlinePayroll
{
	public class EmployeeResource : BaseRestResource
	{
		public Guid HostId { get; set; }
		[Required]
		public Guid CompanyId { get; set; }
		[Required]
		public Contact Contact { get; set; }
		[Required]
		public GenderType Gender { get; set; }
		[Required]
		[RegularExpression(@"^(\d{9})$", ErrorMessage = "Characters are not allowed.")]
		public string SSN { get; set; }
		public DateTime? BirthDate { get; set; }
		//Employment
		[Required]
		public DateTime HireDate { get; set; }
		[Required]
		public DateTime SickLeaveHireDate { get; set; }
		public decimal CarryOver { get; set; }
		public string Department { get; set; }
		[Required]
		public StatusOption StatusId { get; set; }
		public string EmployeeNo { get; set; }
		public int? CompanyEmployeeNo { get; set; }
		public string Memo { get; set; }
		public string Notes { get; set; }
		//Payroll
		[Required]
		public PayrollSchedule PayrollSchedule { get; set; }
		[Required]
		public EmployeeType PayType { get; set; }
		public decimal Rate { get; set; }
		public List<CompanyPayCodeResource> PayCodes { get; set; }
		public List<EmployeePayTypeResource> Compensations { get; set; }
		[Required]
		public EmployeePaymentMethod PaymentMethod { get; set; }
		
		public List<EmployeeBankAccountResource> BankAccounts { get; set; } 
		public bool DirectDebitAuthorized { get; set; }
		//Taxation
		[Required]
		public EmployeeTaxCategory TaxCategory { get; set; }
		[Required]
		public EmployeeTaxStatus FederalStatus { get; set; }
		[Required]
		[Range(0, 10)]
		public int FederalExemptions { get; set; }
		[Required]
		public decimal FederalAdditionalAmount { get; set; }
		[Required]
		public EmployeeStateResource State { get; set; }
		public List<EmployeeDeductionResource> Deductions { get; set; }
		public CompanyWorkerCompensationResource WorkerCompensation { get; set; }
		public List<PayCheckPayTypeAccumulationResource> Accumulations { get; set; } 
		public DateTime? LastPayrollDate { get; set; }

		public string WcCode
		{
			get { return WorkerCompensation != null ? WorkerCompensation.Code.ToString() : string.Empty; }
		}

		public string Address
		{
			get { return string.Format("{0}, {1}",Contact.Address.AddressLine1, Contact.Address.AddressLine2); }
		}

		public string PayTypeText
		{
			get { return PayType.GetDbName(); }
		}
		public string FederalStatusText
		{
			get { return FederalStatus.GetDbName(); }
		}
		public string StateStatusText
		{
			get { return State.TaxStatus.GetDbName(); }
		}

		public string StatusText
		{
			get { return StatusId.GetDbName(); }
		}

		public string SSNText
		{
			get { return string.Format("{0}-{1}-{2}", SSN.Substring(0, 3), SSN.Substring(3, 2), SSN.Substring(5, 4)); }
		}

		public string Name
		{
			get { return string.Format("{0}{2}{1}", Contact.FirstName, Contact.LastName, string.Format(" {0}", !string.IsNullOrWhiteSpace(Contact.MiddleInitial) ? Contact.MiddleInitial.Substring(0, 1) + " " : string.Empty)); }
		}

		public EmployeeResource FillFromImport(ExcelRead er, CompanyResource company)
		{
			var error = string.Empty;
			const string ssnRegex = @"^(\d{3}-\d{2}-\d{4})$";
			if (!Regex.IsMatch(er.Value("ssn"), ssnRegex))
			{
				error += "SSN, ";
			}
			if (string.IsNullOrWhiteSpace(er.Value("first name")))
			{
				error += "First Name, ";
			}
			if (string.IsNullOrWhiteSpace(er.Value("last name")))
			{
				error += "Last Name, ";
			}
			if (!Utilities.IsValidEmail(er.Value("email")))
			{
				error += "Email, ";
			}
			if (string.IsNullOrWhiteSpace(er.Value("address")))
			{
				error += "Address, ";
			}
			if (!IsValidState(er.Value("address state")))
			{
				error += "Address State";
			}
			
			if (!Regex.IsMatch(er.Value("zip"), @"^\d{5}$"))
			{
				error += "Zip, ";
			}
			if (string.IsNullOrWhiteSpace(er.Value("employee no")) || Int32.Parse(er.Value("employee no"))==0)
			{
				error += "Employee No, ";
			}
			if (!Regex.IsMatch(er.Value("wc job class"), @"^\d{4}$") || !company.WorkerCompensations.Any(wc=>wc.Code==Convert.ToInt32(er.Value("wc job class"))))
			{
				error += "WC Job Class, ";
			}
			DateTime date;
			if (!DateTime.TryParse(er.Value("hire date"), out date))
			{
				error += "Hire Date, ";
			}
			if (string.IsNullOrWhiteSpace(er.Value("pay type")))
			{
				error += "Pay Type, ";
			}
			if (string.IsNullOrWhiteSpace(er.Value("tax status")))
			{
				error += "Tax Status, ";
			}
			if (string.IsNullOrWhiteSpace(er.Value("federal filing status")))
			{
				error += "Federal Filing Status, ";
			}
			if (string.IsNullOrWhiteSpace(er.Value("federal exemptions")) && !Regex.IsMatch(er.Value("federal exemptions"), @"^\d$"))
			{
				error += "Federal Exemptions, ";
			}
			if (string.IsNullOrWhiteSpace(er.Value("federal additional amount")) && !Regex.IsMatch(er.Value("federal additional amount"), @"^[0-9]+(\.[0-9]{1,2})?$"))
			{
				error += "Federal Additional Amount, ";
			}
			if (!IsValidState(er.Value("state")))
			{
				error += "Tax State, ";
			}
			if (string.IsNullOrWhiteSpace(er.Value("state filing status")))
			{
				error += "State Filing Status, ";
			}
			if (string.IsNullOrWhiteSpace(er.Value("state exemptions")) && !Regex.IsMatch(er.Value("state exemptions"), @"^\d$"))
			{
				error += "State Exemptions, ";
			}
			if (string.IsNullOrWhiteSpace(er.Value("state additional amount")) && !Regex.IsMatch(er.Value("state additional amount"), @"^[0-9]+(\.[0-9]{1,2})?$"))
			{
				error += "state Additional Amount, ";
			}
			
			CompanyId = company.Id.Value;
			SSN = er.Value("ssn").Replace("-", string.Empty);
			Contact = new Contact
			{
				FirstName = er.Value("first name"),
				LastName = er.Value("last name"),
				Address = new Address
				{
					AddressLine1 = er.Value("address"),
					City = er.Value("city"),
					CountryId = 1,
					StateId = StateId(er.Value("address state")),
					Type = AddressType.Personal,
					Zip = er.Value("zip"),
					ZipExtension = er.Value("zip extension")
				},
				Email = er.Value("email"),
				Phone = er.Value("phone").Replace("-", string.Empty),
				Mobile = er.Value("mobile").Replace("-", string.Empty),
				Fax = er.Value("fax").Replace("-", string.Empty),
				IsPrimary = true
			};
			Gender = er.Value("gender").ToLower().Equals("male") ? GenderType.Male : GenderType.Female;
			if(! string.IsNullOrWhiteSpace(er.Value("birth date")))
				BirthDate = Convert.ToDateTime(er.Value("birth date"));

			HireDate = Convert.ToDateTime(er.Value("hire date"));

			Department = er.Value("department");
			EmployeeNo = er.Value("employee no");
			WorkerCompensation = company.WorkerCompensations.First(wc => wc.Code == Convert.ToInt32(er.Value("wc job class")));
			PayrollSchedule = GetPayrollSchedule(er.Value("payroll schedule"), company.PayrollSchedule);
			PayType = er.Value("pay type").ToLower().Equals("salary")
				? EmployeeType.Salary
				: (er.Value("pay type").ToLower().Equals("hourly") ? EmployeeType.Hourly : EmployeeType.PieceWork);
			if (PayType == EmployeeType.Hourly)
			{
				PayCodes = new List<CompanyPayCodeResource>();
				foreach (var code in company.PayCodes)
				{
					if(!string.IsNullOrWhiteSpace(er.Value(code.Description.ToLower())))
						PayCodes.Add(code);
				}
				if (string.IsNullOrWhiteSpace(er.Value("base salary")) && !Regex.IsMatch(er.Value("base salary"), @"^[0-9]+(\.[0-9]{1,2})?$"))
				{
					error += "PayCode/Base salary, ";
				}
				else
				{
					Rate = Convert.ToDecimal(er.Value("base salary"));
					PayCodes.Add(new CompanyPayCodeResource
					{
						Id=0, CompanyId = company.Id.Value, Code="Default", Description = "Base Rate", HourlyRate = Rate
					});
				}
			}
			else if (PayType == EmployeeType.Salary)
			{
				if (string.IsNullOrWhiteSpace(er.Value("base salary")) && !Regex.IsMatch(er.Value("base salary"), @"^[0-9]+(\.[0-9]{1,2})?$"))
					error += "Base Salary, ";
				else
				{
					Rate = Convert.ToDecimal(er.Value("base salary"));
				}
			}

			PaymentMethod = EmployeePaymentMethod.Check;
			StatusId = StatusOption.Active;

			if (!string.IsNullOrWhiteSpace(error))
			{
				error = "Employee at row# " + er.Row + " has invalid " + error;
				throw new Exception(error);
			}

			TaxCategory = er.Value("tax status").Equals("1") || er.Value("tax status").ToLower().StartsWith("us")
				? EmployeeTaxCategory.USWorkerNonVisa
				: er.Value("tax status").Equals("3") || er.Value("tax status").ToLower().StartsWith("clergy") ? EmployeeTaxCategory.Clergy : EmployeeTaxCategory.NonImmigrantAlien;

			FederalStatus = GetFederalStatus(er.Value("federal filing status"));
			FederalExemptions = Convert.ToInt32(er.Value("federal exemptions"));
			FederalAdditionalAmount = Convert.ToDecimal(er.Value("federal additional amount"));

			var state = StateId(er.Value("state"));
			State = new EmployeeStateResource
			{
				State = company.States.First(s=>s.State.StateId==state).State,
				TaxStatus = GetFederalStatus(er.Value("state filing status")),
				Exemptions = Convert.ToInt32(er.Value("state exemptions")),
				AdditionalAmount = Convert.ToDecimal(er.Value("state additional amount")),
			};
			if (FederalExemptions < 0 || FederalExemptions > 10)
				error += "Federal Exemptions, ";
			if (State.Exemptions < 0 || State.Exemptions > 10)
				error += "State Exemptions, ";
			if (!string.IsNullOrWhiteSpace(error))
			{
				error = "Employee at row# " + er.Row + " has invalid " + error;
				throw new Exception(error);
			}
			
			return this;

		}

		private EmployeeTaxStatus GetFederalStatus(string val)
		{
			if(val=="1" || val.StartsWith("S"))
				return EmployeeTaxStatus.Single;
			if (val == "2" || val.StartsWith("M"))
				return EmployeeTaxStatus.Married;

			return EmployeeTaxStatus.UnmarriedHeadofHousehold;
		}
		private PayrollSchedule GetPayrollSchedule(string val, PayrollSchedule def)
		{
			if (string.IsNullOrWhiteSpace(val))
				return def;
			if (HrMaaxxSecurity.GetEnumFromDbName<PayrollSchedule>(val).HasValue)
				return HrMaaxxSecurity.GetEnumFromDbName<PayrollSchedule>(val).Value;
			if (HrMaaxxSecurity.GetEnumFromDbId<PayrollSchedule>(Convert.ToInt32(val)).HasValue)
				return HrMaaxxSecurity.GetEnumFromDbId<PayrollSchedule>(Convert.ToInt32(val)).Value;
			return def;
		}
		private bool IsValidState(string val)
		{
			if (string.IsNullOrWhiteSpace(val))
				return false;
			if (HrMaaxxSecurity.GetEnumFromDbName<States>(val) == null &&
							 HrMaaxxSecurity.GetEnumFromHrMaxxName<States>(val) == null)
				return false;
			return true;
		}

		public int StateId(string state)
		{
			return HrMaaxxSecurity.GetEnumFromDbName<States>(state) != null
				? HrMaaxxSecurity.GetEnumFromDbName<States>(state).GetValueOrDefault().GetDbId().Value
				: HrMaaxxSecurity.GetEnumFromHrMaxxName<States>(state).GetValueOrDefault().GetDbId().Value;
		}

		public string SLDates { 
			get{
			return Accumulations.Any()
				? string.Format("{0} ({1} - {2})", Accumulations.First().PayTypeName, Accumulations.First().FiscalStart.ToString("MM/dd/yyyy"),
					Accumulations.First().FiscalEnd.ToString("MM/dd/yyyy"))
				: string.Empty;
			} 
		}

		public decimal SLUsed
		{
			get { return Accumulations.Any() ? Accumulations.First().YTDUsed : 0; }
		}
		public decimal SLAccumulated
		{
			get { return Accumulations.Any() ? Accumulations.First().YTDFiscal : 0; }
		}
		public decimal SLCarryOver
		{
			get { return Accumulations.Any() ? Accumulations.First().CarryOver : 0; }
		}
		public decimal SLAvailable
		{
			get { return Accumulations.Any() ? Accumulations.First().Available : 0; }
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
		[Range(0, 10)]
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
		public int? CeilingMethod { get; set; }
		public decimal? CeilingPerCheck { get; set; }
		public decimal? Limit { get; set; }
		public int? Priority { get; set; }
		public string AccountNo { get; set; }
		public Guid? AgencyId { get; set; }
	}

	public class EmployeeBankAccountResource
	{
		public int? Id { get; set; }
		[Required]
		public Guid EmployeeId { get; set; }
		[Required]
		public decimal Percentage { get; set; }
		[Required]
		public BankAccountResource BankAccount { get; set; }
	}
	public class PayCheckPayTypeAccumulationResource
	{
		public int PayCheckId { get; set; }
		public int PayTypeId { get; set; }
		public string PayTypeName { get; set; }
		public DateTime FiscalStart { get; set; }
		public DateTime FiscalEnd { get; set; }
		public DateTime NewFiscalStart { get; set; }
		public DateTime NewFiscalEnd { get; set; }
		public decimal AccumulatedValue { get; set; }
		public decimal Used { get; set; }
		public decimal CarryOver { get; set; }
		public decimal YTDFiscal { get; set; }
		public decimal YTDUsed { get; set; }
		public decimal Available { get; set; }
		public Guid EmployeeId { get; set; }
	}
}