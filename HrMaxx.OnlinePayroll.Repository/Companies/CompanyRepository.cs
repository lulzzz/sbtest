using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Core.Metadata.Edm;
using System.Linq;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Models.Enum;
using Newtonsoft.Json;
using Company = HrMaxx.OnlinePayroll.Models.Company;
using CompanyDeduction = HrMaxx.OnlinePayroll.Models.CompanyDeduction;
using CompanyPayCode = HrMaxx.OnlinePayroll.Models.CompanyPayCode;
using CompanyTaxRate = HrMaxx.OnlinePayroll.Models.CompanyTaxRate;
using CompanyTaxState = HrMaxx.OnlinePayroll.Models.CompanyTaxState;
using CompanyWorkerCompensation = HrMaxx.OnlinePayroll.Models.CompanyWorkerCompensation;
using Employee = HrMaxx.OnlinePayroll.Models.Employee;
using EmployeeDeduction = HrMaxx.OnlinePayroll.Models.EmployeeDeduction;
using VendorCustomer = HrMaxx.OnlinePayroll.Models.VendorCustomer;

namespace HrMaxx.OnlinePayroll.Repository.Companies
{
	public class CompanyRepository : ICompanyRepository
	{
		private readonly OnlinePayrollEntities _dbContext;
		private readonly IMapper _mapper;
		private readonly IUtilRepository _utilRepository;

		public CompanyRepository(IMapper mapper, OnlinePayrollEntities dbContext, IUtilRepository utilRepository)
		{
			_dbContext = dbContext;
			_mapper = mapper;
			_utilRepository = utilRepository;
		}

		public IList<Company> GetCompanies(Guid hostId, Guid companyId)
		{
			var companies = _dbContext.Companies.Where(c => c.HostId == hostId);
			if (companyId != Guid.Empty)
				companies = companies.Where(c => c.Id == companyId);
			return _mapper.Map<List<Models.DataModel.Company>, List<Models.Company>>(companies.ToList());
		}

		public Models.Company SaveCompany(Models.Company company)
		{
			var dbMappedCompany = _mapper.Map<Models.Company, Models.DataModel.Company>(company);
			var dbCompany = _dbContext.Companies.FirstOrDefault(c => c.Id == company.Id);
			if (dbCompany == null)
			{
				_dbContext.Companies.Add(dbMappedCompany);
			}
			else
			{
				dbCompany.BusinessAddress = dbMappedCompany.BusinessAddress;
				dbCompany.CompanyAddress = dbMappedCompany.CompanyAddress;
				dbCompany.CompanyName = dbMappedCompany.CompanyName;
				dbCompany.CompanyNo = dbMappedCompany.CompanyNo;
				dbCompany.DepositSchedule941 = dbMappedCompany.DepositSchedule941;
				dbCompany.DirectDebitPayer = dbMappedCompany.DirectDebitPayer;
				dbCompany.FederalEIN = dbMappedCompany.FederalEIN;
				dbCompany.FederalPin = dbMappedCompany.FederalPin;
				dbCompany.FileUnderHost = dbMappedCompany.FileUnderHost;
				dbCompany.HostId = dbMappedCompany.HostId;
				dbCompany.InsuranceGroupNo = dbMappedCompany.InsuranceGroupNo;
				dbCompany.IsAddressSame = dbMappedCompany.IsAddressSame;
				dbCompany.IsVisibleToHost = dbMappedCompany.IsVisibleToHost;
				dbCompany.LastModified = dbMappedCompany.LastModified;
				dbCompany.LastModifiedBy = dbMappedCompany.LastModifiedBy;
				dbCompany.ManageEFileForms = dbMappedCompany.ManageEFileForms;
				dbCompany.ManageTaxPayment = dbMappedCompany.ManageTaxPayment;
				dbCompany.PayCheckStock = dbMappedCompany.PayCheckStock;
				dbCompany.PayrollDaysInPast = dbMappedCompany.PayrollDaysInPast;
				dbCompany.PayrollSchedule = dbMappedCompany.PayrollSchedule;
				dbCompany.StatusId = dbMappedCompany.StatusId;
				dbCompany.TaxFilingName = dbMappedCompany.TaxFilingName;
				dbCompany.MinWage = dbMappedCompany.MinWage;
			}
			_dbContext.SaveChanges();
			_utilRepository.FillCompanyAccounts(dbMappedCompany.Id, company.UserName);
			var dbcomp = _dbContext.Companies.First(c => c.Id == dbMappedCompany.Id);
			return _mapper.Map<Models.DataModel.Company, Models.Company>(dbcomp);
		}

		public ContractDetails SaveCompanyContract(Company savedcompany, ContractDetails contract)
		{
			if (contract.BankDetails != null)
			{
				contract.BankDetails.SourceTypeId = EntityTypeEnum.Company;
				contract.BankDetails.SourceId = savedcompany.Id;
				contract.BankDetails.LastModifiedBy = savedcompany.UserName;
				contract.BankDetails = _utilRepository.SaveBankAccount(contract.BankDetails);
			}
			if (contract.InvoiceSetup != null && contract.InvoiceSetup.RecurringCharges.Any(rc=>rc.Id==0))
			{
				contract.InvoiceSetup.RecurringCharges.Where(rc=>rc.Id==0).ToList().ForEach(rc =>
				{
					rc.Id = contract.InvoiceSetup.RecurringCharges.Max(rc1 => rc1.Id) + 1;
				});
			}
			var mapped = _mapper.Map<ContractDetails, CompanyContract>(contract);
			mapped.CompanyId = savedcompany.Id;
			
			var dbContract = _dbContext.CompanyContracts.FirstOrDefault(c => c.CompanyId == savedcompany.Id);
			if (dbContract == null)
			{
				_dbContext.CompanyContracts.Add(mapped);
			}
			else
			{
				dbContract.BankDetails = mapped.BankDetails;
				dbContract.CardDetails = mapped.CardDetails;
				dbContract.BillingType = mapped.BillingType;
				dbContract.InvoiceRate = mapped.InvoiceRate;
				dbContract.Method = mapped.Method;
				dbContract.Type = mapped.Type;
				dbContract.InvoiceSetup = mapped.InvoiceSetup;
			}
			_dbContext.SaveChanges();
			return _mapper.Map<CompanyContract, ContractDetails>(mapped);
		}

		public List<CompanyTaxState> SaveTaxStates(Company savedcompany, List<CompanyTaxState> states)
		{
			var mapped = _mapper.Map<List<CompanyTaxState>, List<Models.DataModel.CompanyTaxState>>(states);
			mapped.ForEach(ct=>ct.CompanyId=savedcompany.Id);
			_dbContext.CompanyTaxStates.AddRange(mapped.Where(s => s.Id == 0));
			var dbStates = _dbContext.CompanyTaxStates.Where(c => c.CompanyId == savedcompany.Id).ToList();
			foreach (var existingState in mapped.Where(s=>s.Id!=0))
			{
				var dbState = dbStates.First(s => s.Id == existingState.Id);
				dbState.EIN = existingState.EIN;
				dbState.Pin = existingState.Pin;
			}
			_dbContext.SaveChanges();
			return _mapper.Map<List<Models.DataModel.CompanyTaxState>, List<CompanyTaxState>>(dbStates);
		}

		public CompanyDeduction SaveDeduction(CompanyDeduction deduction)
		{
			
			var mappeddeduction = _mapper.Map<CompanyDeduction, Models.DataModel.CompanyDeduction>(deduction);
			if (mappeddeduction.Id == 0)
			{
				_dbContext.CompanyDeductions.Add(mappeddeduction);
			}
			else
			{
				var dbdeduction = _dbContext.CompanyDeductions.FirstOrDefault(cd => cd.Id == mappeddeduction.Id);
				if (dbdeduction != null)
				{
					dbdeduction.TypeId = mappeddeduction.TypeId;
					dbdeduction.Description = mappeddeduction.Description;
					dbdeduction.Name = mappeddeduction.Name;
					dbdeduction.AnnualMax = mappeddeduction.AnnualMax;
				}
			}
			_dbContext.SaveChanges();
			
			var ret = _mapper.Map<Models.DataModel.CompanyDeduction, CompanyDeduction>(mappeddeduction);
			ret.Type = deduction.Type;
			return ret;
		}

		public CompanyWorkerCompensation SaveWorkerCompensation(CompanyWorkerCompensation workerCompensation)
		{
			var mappedwc = _mapper.Map<CompanyWorkerCompensation, Models.DataModel.CompanyWorkerCompensation>(workerCompensation);
			if (mappedwc.Id == 0)
			{
				_dbContext.CompanyWorkerCompensations.Add(mappedwc);
				var employeesWithoutWC =
					_dbContext.Employees.Where(e => e.CompanyId == mappedwc.CompanyId && !e.WorkerCompensationId.HasValue);
				if (employeesWithoutWC.Any())
				{
					employeesWithoutWC.ForEachAsync(e => e.WorkerCompensationId = mappedwc.Id);
				}
			}
			else
			{
				var wc = _dbContext.CompanyWorkerCompensations.FirstOrDefault(cd => cd.Id == mappedwc.Id);
				if (wc != null)
				{
					wc.Code = mappedwc.Code;
					wc.Description = mappedwc.Description;
					wc.Rate = mappedwc.Rate;
					wc.MinGrossWage = mappedwc.MinGrossWage;
				}
			}
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.CompanyWorkerCompensation, CompanyWorkerCompensation>(mappedwc);
		}

		public AccumulatedPayType SaveAccumulatedPayType(AccumulatedPayType mappedAccPayType)
		{
			var mappedwc = _mapper.Map<AccumulatedPayType, Models.DataModel.CompanyAccumlatedPayType>(mappedAccPayType);
			if (mappedwc.Id == 0)
			{
				_dbContext.CompanyAccumlatedPayTypes.Add(mappedwc);
			}
			else
			{
				var wc = _dbContext.CompanyAccumlatedPayTypes.FirstOrDefault(cd => cd.Id == mappedwc.Id);
				if (wc != null)
				{
					wc.RatePerHour = mappedwc.RatePerHour;
					wc.AnnualLimit = mappedwc.AnnualLimit;
				}
			}
			_dbContext.SaveChanges();
			var ret = _mapper.Map<Models.DataModel.CompanyAccumlatedPayType, AccumulatedPayType>(mappedwc);
			ret.PayType = mappedAccPayType.PayType;
			return ret;
		}

		public CompanyPayCode SavePayCode(CompanyPayCode mappedResource)
		{
			var mappedpc = _mapper.Map<CompanyPayCode, Models.DataModel.CompanyPayCode>(mappedResource);
			if (mappedpc.Id == 0)
			{
				_dbContext.CompanyPayCodes.Add(mappedpc);
			}
			else
			{
				var wc = _dbContext.CompanyPayCodes.FirstOrDefault(cd => cd.Id == mappedpc.Id);
				if (wc != null)
				{
					wc.Code = mappedpc.Code;
					wc.Description = mappedpc.Description;
					wc.HourlyRate = mappedpc.HourlyRate;
				}
			}
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.CompanyPayCode, CompanyPayCode>(mappedpc);
		}

		public List<VendorCustomer> GetVendorCustomers(Guid companyId, bool isVendor)
		{
			var list = _dbContext.VendorCustomers.Where(vc => vc.CompanyId == companyId && vc.IsVendor == isVendor);
			return _mapper.Map<List<Models.DataModel.VendorCustomer>, List<VendorCustomer>>(list.ToList());
		}

		public VendorCustomer SaveVendorCustomer(VendorCustomer mappedResource)
		{
			var vc = _mapper.Map<VendorCustomer, Models.DataModel.VendorCustomer>(mappedResource);
			var dbVC = _dbContext.VendorCustomers.FirstOrDefault(v => v.Id == vc.Id);
			if (dbVC==null)
			{
				_dbContext.VendorCustomers.Add(vc);
			}
			else
			{
				dbVC.Name = vc.Name;
				dbVC.AccountNo = vc.AccountNo;
				dbVC.StatusId = vc.StatusId;
				dbVC.Note = vc.Note;
				dbVC.LastModifiedBy = vc.LastModifiedBy;
				dbVC.LastModified = vc.LastModified;
				dbVC.Contact = vc.Contact;
				dbVC.IdentifierType = vc.IdentifierType;
				dbVC.IndividualSSN = vc.IndividualSSN;
				dbVC.BusinessFIN = vc.BusinessFIN;
				dbVC.Type1099 = vc.Type1099;
				dbVC.SubType1099 = vc.SubType1099;
				dbVC.IsVendor1099 = vc.IsVendor1099;
			}
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.VendorCustomer, VendorCustomer>(vc);
		}

		public List<Account> GetCompanyAccounts(Guid companyId)
		{
			var accounts = _dbContext.CompanyAccounts.Where(c => c.CompanyId == companyId);
			return _mapper.Map<List<CompanyAccount>, List<Account>>(accounts.ToList());
		}

		public Account SaveCompanyAccount(Account account)
		{
			if (account.Type == AccountType.Assets && account.SubType == AccountSubType.Bank && account.BankAccount != null)
			{
				account.BankAccount.SourceTypeId = EntityTypeEnum.Company;
				account.BankAccount.SourceId = account.CompanyId;
				account.BankAccount.LastModified = DateTime.Now;
				account.BankAccount.LastModifiedBy = account.LastModifiedBy;
				account.BankAccount = _utilRepository.SaveBankAccount(account.BankAccount);
				if (account.UseInPayroll)
				{
					var payrollAccount =
						_dbContext.CompanyAccounts.FirstOrDefault(
							c => c.CompanyId==account.CompanyId && c.Type == (int) AccountType.Assets && c.SubType == (int) AccountSubType.Bank && c.UsedInPayroll);
					if (payrollAccount != null)
						payrollAccount.UsedInPayroll = false;
				}
			}
			var mapped = _mapper.Map<Account, CompanyAccount>(account);
			if (mapped.Id == 0)
			{
				_dbContext.CompanyAccounts.Add(mapped);
			}
			else
			{
				var dbAccount = _dbContext.CompanyAccounts.FirstOrDefault(ca => ca.Id == mapped.Id);
				if (dbAccount != null)
				{
					dbAccount.LastModified = mapped.LastModified;
					dbAccount.LastModifiedBy = mapped.LastModifiedBy;
					dbAccount.Name = mapped.Name;
					dbAccount.OpeningBalance = mapped.OpeningBalance;
					dbAccount.UsedInPayroll = mapped.UsedInPayroll;
				}
			}
			_dbContext.SaveChanges();
			return _mapper.Map<CompanyAccount, Account>(mapped);
		}

		public bool CompanyExists(Guid companyId)
		{
			return _dbContext.Companies.Any(c => c.Id == companyId);
		}

		public List<Employee> GetEmployeeList(Guid companyId)
		{
			var employees = _dbContext.Employees.Where(e => e.CompanyId == companyId);
			return _mapper.Map<List<Models.DataModel.Employee>, List<Employee>>(employees.ToList());
		}

		public Employee SaveEmployee(Employee employee)
		{
			if (employee.BankAccount != null)
			{
				employee.BankAccount.SourceTypeId = EntityTypeEnum.Employee;
				employee.BankAccount.SourceId = employee.Id;
				employee.BankAccount.LastModifiedBy = employee.UserName;
				employee.BankAccount = _utilRepository.SaveBankAccount(employee.BankAccount);
			}
			var me = _mapper.Map<Employee, Models.DataModel.Employee>(employee);
			var dbEmployee = _dbContext.Employees.FirstOrDefault(e => e.Id == me.Id || e.SSN.Equals(me.SSN));
			if (dbEmployee == null)
			{
				_dbContext.Employees.Add(me);
			}
			else
			{
				dbEmployee.FirstName = me.FirstName;
				dbEmployee.LastName = me.LastName;
				dbEmployee.LastModified = me.LastModified;
				dbEmployee.LastModifiedBy = me.LastModifiedBy;
				dbEmployee.Contact = me.Contact;
				dbEmployee.Department = me.Department;
				dbEmployee.SSN = me.SSN;
				dbEmployee.BirthDate = me.BirthDate;
				dbEmployee.HireDate = me.HireDate;
				dbEmployee.Gender = me.Gender;
				dbEmployee.EmployeeNo = me.EmployeeNo;
				dbEmployee.Memo = me.Memo;
				dbEmployee.PayrollSchedule = me.PayrollSchedule;
				dbEmployee.PayType = me.PayType;
				dbEmployee.Compensations = me.Compensations;
				dbEmployee.PayCodes = me.PayCodes;
				dbEmployee.PaymentMethod = me.PaymentMethod;
				dbEmployee.DirectDebitAuthorized = me.DirectDebitAuthorized;
				dbEmployee.TaxCategory = me.TaxCategory;
				dbEmployee.FederalAdditionalAmount = me.FederalAdditionalAmount;
				dbEmployee.FederalExemptions = me.FederalExemptions;
				dbEmployee.FederalStatus = me.FederalStatus;
				dbEmployee.State = me.State;
				dbEmployee.WorkerCompensationId = me.WorkerCompensationId;
				dbEmployee.Rate = me.Rate;
				if (employee.BankAccount != null)
					dbEmployee.BankAccountId = employee.BankAccount.Id;
			}

			_dbContext.SaveChanges();
			var dbemp = _dbContext.Employees.Include("CompanyWorkerCompensation").First(e => e.Id == me.Id);
			return _mapper.Map<Models.DataModel.Employee, Employee>(dbemp);
		}

		public EmployeeDeduction SaveEmployeeDeduction(EmployeeDeduction deduction)
		{
			var mappeddeduction = _mapper.Map<EmployeeDeduction, Models.DataModel.EmployeeDeduction>(deduction);
			if (mappeddeduction.Id == 0)
			{
				_dbContext.EmployeeDeductions.Add(mappeddeduction);
			}
			else
			{
				var dbdeduction = _dbContext.EmployeeDeductions.FirstOrDefault(cd => cd.Id == mappeddeduction.Id);
				if (dbdeduction != null)
				{
					dbdeduction.Method = mappeddeduction.Method;
					dbdeduction.Rate = mappeddeduction.Rate;
					dbdeduction.AnnualMax = mappeddeduction.AnnualMax;
					dbdeduction.CompanyDeductionId = mappeddeduction.CompanyDeductionId;
				}
			}
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.EmployeeDeduction, EmployeeDeduction>(mappeddeduction);
		}

		public bool EmployeeExists(Guid id)
		{
			return _dbContext.Employees.Any(c => c.Id == id);
		}

		public void DeleteEmployeeDeduction(int deductionId)
		{
			var dbdeduction = _dbContext.EmployeeDeductions.FirstOrDefault(d => d.Id == deductionId);
			if (dbdeduction != null)
			{
				_dbContext.EmployeeDeductions.Remove(dbdeduction);
				_dbContext.SaveChanges();
			}
				
		}

		public void UpdateLastPayrollDateCompany(Guid id, DateTime payDay)
		{
			var dbCompany = _dbContext.Companies.FirstOrDefault(c => c.Id == id);
			if (dbCompany != null)
			{
				dbCompany.LastPayrollDate = payDay;
				_dbContext.SaveChanges();
			}
		}

		public void UpdateLastPayrollDateEmployee(Guid id, DateTime payDay)
		{
			var dbEmployee = _dbContext.Employees.FirstOrDefault(c => c.Id == id);
			if (dbEmployee != null)
			{
				var maxPayDay = _dbContext.PayrollPayChecks.Where(p => p.EmployeeId == id && !p.IsVoid).Max(p => p.PayDay);
				dbEmployee.LastPayrollDate = maxPayDay;
				_dbContext.SaveChanges();
			}
		}

		public CompanyTaxRate SaveCompanyTaxRate(CompanyTaxRate taxrate)
		{
			var taxyearrate = _mapper.Map<CompanyTaxRate, Models.DataModel.CompanyTaxRate>(taxrate);
			if (taxyearrate.Id == 0)
			{
				_dbContext.CompanyTaxRates.Add(taxyearrate);
			}
			else
			{
				var dbtaxyearrate = _dbContext.CompanyTaxRates.FirstOrDefault(cd => cd.Id == taxyearrate.Id);
				if (dbtaxyearrate != null)
				{
					dbtaxyearrate.Rate = taxyearrate.Rate;
				}
			}
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.CompanyTaxRate, CompanyTaxRate>(taxyearrate);
		}

		public Company GetCompanyById(Guid companyId)
		{
			var dbCompany = _dbContext.Companies.First(c => c.Id == companyId);
			return _mapper.Map<Models.DataModel.Company, Models.Company>(dbCompany);
		}

		public VendorCustomer GetVendorCustomersById(Guid vcId)
		{
			var db = _dbContext.VendorCustomers.First(vc => vc.Id == vcId);
			return _mapper.Map<Models.DataModel.VendorCustomer, VendorCustomer>(db);
		}

	}
}
