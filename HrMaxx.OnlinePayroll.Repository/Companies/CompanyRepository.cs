using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.Entity;
using System.Data.Entity.Core.Metadata.Edm;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using Dapper;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Repository;
using HrMaxx.Infrastructure.Security;
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
	public class CompanyRepository : BaseDapperRepository, ICompanyRepository
	{
		private readonly OnlinePayrollEntities _dbContext;
		private readonly IMapper _mapper;
		private readonly IUtilRepository _utilRepository;
		private string _sqlCon;

		public CompanyRepository(IMapper mapper, OnlinePayrollEntities dbContext, IUtilRepository utilRepository, DbConnection connection, string sqlCon)
			: base(connection)
		{
			_dbContext = dbContext;
			_mapper = mapper;
			_utilRepository = utilRepository;
			_sqlCon = sqlCon;
		}


		public Models.Company SaveCompany(Models.Company company)
		{
			var dbMappedCompany = _mapper.Map<Models.Company, Models.DataModel.Company>(company);
			var dbCompanies = _dbContext.Companies.Where(c => c.HostId == company.HostId && (c.Id == company.Id || (!company.IsLocation && c.FederalEIN==dbMappedCompany.FederalEIN))).ToList();
			if (!dbCompanies.Any())
			{
				_dbContext.Companies.Add(dbMappedCompany);
			}
			else if (!company.IsLocation && dbCompanies.Any(c => c.Id != company.Id && c.FederalEIN == dbMappedCompany.FederalEIN && !c.ParentId.HasValue))
				throw new Exception("FEIN already exists for another Company withing the same Host");
			else
			{
				var dbCompany = dbCompanies.First(c=>c.Id==company.Id);
				dbCompany.BusinessAddress = dbMappedCompany.BusinessAddress;
				dbCompany.CompanyAddress = dbMappedCompany.CompanyAddress;
				dbCompany.CompanyName = dbMappedCompany.CompanyName;
				dbCompany.CompanyNo = dbMappedCompany.CompanyNo;
				dbCompany.DepositSchedule941 = dbMappedCompany.DepositSchedule941;
				dbCompany.DirectDebitPayer = dbMappedCompany.DirectDebitPayer;
				dbCompany.ProfitStarsPayer = dbMappedCompany.ProfitStarsPayer;
				dbCompany.FederalEIN = dbMappedCompany.FederalEIN;
				dbCompany.FederalPin = dbMappedCompany.FederalPin;
				dbCompany.FileUnderHost = dbMappedCompany.FileUnderHost;
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
				dbCompany.PayrollScheduleDay = dbMappedCompany.PayrollScheduleDay;
				dbCompany.StatusId = dbMappedCompany.StatusId;
				dbCompany.TaxFilingName = dbMappedCompany.TaxFilingName;
				dbCompany.MinWage = dbMappedCompany.MinWage;
				dbCompany.Memo = dbMappedCompany.Memo;
				dbCompany.ClientNo = dbMappedCompany.ClientNo;
				dbCompany.Notes = dbMappedCompany.Notes;
				dbCompany.DashboardNotes = dbMappedCompany.DashboardNotes;
				dbCompany.PayrollMessage = dbMappedCompany.PayrollMessage;
				dbCompany.IsFiler944 = dbMappedCompany.IsFiler944;
				dbCompany.IsFiler1095 = dbMappedCompany.IsFiler1095;
				dbCompany.CompanyCheckPrintOrder = dbMappedCompany.CompanyCheckPrintOrder;
				dbCompany.City = dbMappedCompany.City;
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
			//if (contract.InvoiceSetup != null && contract.InvoiceSetup.RecurringCharges.Any())
			//{
			//	contract.InvoiceSetup.RecurringCharges.Where(rc=>rc.Id==0).ToList().ForEach(rc =>
			//	{
			//		rc.Id = contract.InvoiceSetup.RecurringCharges.Max(rc1 => rc1.Id) + 1;
			//	});
			//}
			
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
			return _mapper.Map<List<Models.DataModel.CompanyTaxState>, List<CompanyTaxState>>(_dbContext.CompanyTaxStates.Where(c => c.CompanyId == savedcompany.Id).ToList());
		}

		public List<Models.CompanyRecurringCharge> SaveRecurringCharges(Company savedcompany, List<Models.CompanyRecurringCharge> charges)
		{
			var mapped = _mapper.Map<List<Models.CompanyRecurringCharge>, List<Models.DataModel.CompanyRecurringCharge>>(charges);
			mapped.ForEach(ct => ct.CompanyId = savedcompany.Id);
			_dbContext.CompanyRecurringCharges.AddRange(mapped.Where(s => s.Id == 0));
			var dbrc = _dbContext.CompanyRecurringCharges.Where(c => c.CompanyId == savedcompany.Id).ToList();
			foreach (var rc in mapped.Where(s => s.Id != 0))
			{
				var recurringCharge = dbrc.First(s => s.Id == rc.Id);
				recurringCharge.Description = rc.Description;
				recurringCharge.Amount = rc.Amount;
				recurringCharge.AnnualLimit = rc.AnnualLimit;
				recurringCharge.OldId = rc.OldId;
				recurringCharge.IsPaidInFull = rc.IsPaidInFull;
				recurringCharge.Comments = rc.Comments;
			}
			foreach (var rc1 in dbrc.Where(rc=>!mapped.Any(r=>r.Id==rc.Id)))
			{
				_dbContext.CompanyRecurringCharges.Remove(rc1);
			}
			_dbContext.SaveChanges();
			return _mapper.Map<List<Models.DataModel.CompanyRecurringCharge>, List<Models.CompanyRecurringCharge>>(_dbContext.CompanyRecurringCharges.Where(c => c.CompanyId == savedcompany.Id).ToList());
		}
		public List<Models.CompanyRecurringCharge> SaveRecurringChargesTemp(Company savedcompany, List<Models.CompanyRecurringCharge> charges)
		{
			var mapped = _mapper.Map<List<Models.CompanyRecurringCharge>, List<Models.DataModel.CompanyRecurringCharge>>(charges);
			
			var dbrc = _dbContext.CompanyRecurringCharges.Where(c => c.CompanyId == savedcompany.Id).ToList();
			foreach (var rc in mapped.Where(s => s.Id != 0))
			{
				var recurringCharge = dbrc.First(s => s.Id == rc.Id);
				recurringCharge.Claimed = rc.Claimed;
			}
			
			_dbContext.SaveChanges();
			return _mapper.Map<List<Models.DataModel.CompanyRecurringCharge>, List<Models.CompanyRecurringCharge>>(_dbContext.CompanyRecurringCharges.Where(c => c.CompanyId == savedcompany.Id).ToList());
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
					dbdeduction.FloorPerCheck = mappeddeduction.FloorPerCheck;
					dbdeduction.ApplyInvoiceCredit = mappeddeduction.ApplyInvoiceCredit;
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
				_dbContext.SaveChanges();
				var employeesWithoutWC =
					_dbContext.Employees.Where(e => e.CompanyId == mappedwc.CompanyId && !e.WorkerCompensationId.HasValue);
				if (employeesWithoutWC.Any())
				{
					employeesWithoutWC.ToList().ForEach(e => e.WorkerCompensationId = mappedwc.Id);
					_dbContext.SaveChanges();
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
					_dbContext.SaveChanges();
				}
			}
			
			return _mapper.Map<Models.DataModel.CompanyWorkerCompensation, CompanyWorkerCompensation>(mappedwc);
		}

		public AccumulatedPayType SaveAccumulatedPayType(AccumulatedPayType mappedAccPayType)
		{
			var mappedwc = _mapper.Map<AccumulatedPayType, Models.DataModel.CompanyAccumlatedPayType>(mappedAccPayType);
			if (mappedwc.Id == 0 && !_dbContext.CompanyAccumlatedPayTypes.Any(cat=>cat.CompanyId==mappedwc.CompanyId && cat.PayTypeId==mappedwc.PayTypeId))
			{
				_dbContext.CompanyAccumlatedPayTypes.Add(mappedwc);
			}
			else
			{
				var wc = _dbContext.CompanyAccumlatedPayTypes.FirstOrDefault(cd => cd.Id == mappedwc.Id || (cd.CompanyId==mappedwc.CompanyId && cd.PayTypeId==mappedwc.PayTypeId));
				if (wc != null)
				{
					wc.RatePerHour = mappedwc.RatePerHour;
					wc.AnnualLimit = mappedwc.AnnualLimit;
					wc.CompanyManaged = mappedwc.CompanyManaged;
					wc.IsLumpSum = mappedwc.IsLumpSum;
					wc.IsEmployeeSpecific = mappedwc.IsEmployeeSpecific;
					wc.Option = mappedwc.Option;
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

		public List<VendorCustomer> GetVendorCustomers(Guid? companyId, bool isVendor)
		{
			var list = _dbContext.VendorCustomers.Where(vc => ((companyId.HasValue && vc.CompanyId.HasValue && vc.CompanyId == companyId.Value) || (!companyId.HasValue && !vc.CompanyId.HasValue)) && vc.IsVendor == isVendor);
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
				dbVC.IsAgency = vc.IsAgency;
				dbVC.IsTaxDepartment = vc.IsTaxDepartment;
			}
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.VendorCustomer, VendorCustomer>(vc);
		}

		public List<Account> GetCompanyAccounts(Guid companyId)
		{
			const string sql = "select * from CompanyAccount where CompanyId=@CompanyId";
			const string sql2 = "select * from BankAccount where Id=@Id";
			using (var conn = GetConnection())
			{
				var accounts = conn.Query<CompanyAccount>(sql, new { CompanyId = companyId }).ToList();
				accounts.Where(a => a.BankAccountId != null).ToList().ForEach(a =>
				{
					a.BankAccount = conn.Query<Models.DataModel.BankAccount>(sql2, new { Id = @a.BankAccountId }).FirstOrDefault();
				});
				return _mapper.Map<List<CompanyAccount>, List<Account>>(accounts.ToList());
			}
			
			
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
					dbAccount.UsedInInvoiceDeposit = mapped.UsedInInvoiceDeposit;
				}
			}
			_dbContext.SaveChanges();
			return _mapper.Map<CompanyAccount, Account>(mapped);
		}

		public bool CompanyExists(Guid companyId, string federalEIN)
		{
			var fein = Crypto.Encrypt(federalEIN);
			return _dbContext.Companies.Any(c => c.Id == companyId || c.FederalEIN.Equals(fein));
		}

		public Employee SaveEmployee(Employee employee)
		{
			if (employee.BankAccounts != null && employee.BankAccounts.Any())
			{
				employee.BankAccounts.ForEach(b =>
				{
					b.BankAccount.SourceTypeId = EntityTypeEnum.Employee;
					b.BankAccount.SourceId = employee.Id;
					b.BankAccount.LastModifiedBy = employee.UserName;
					//b.BankAccount = _utilRepository.SaveBankAccount(b.BankAccount);
				});
				
			}
			var me = _mapper.Map<Employee, Models.DataModel.Employee>(employee);
			var dbEmployees = _dbContext.Employees.Where(e => e.CompanyId==employee.CompanyId && (e.Id == me.Id || e.SSN.Equals(me.SSN))).ToList();
			if (!dbEmployees.Any())
			{
				var emps = _dbContext.Employees.Where(e => e.CompanyId == employee.CompanyId);
				if (string.IsNullOrWhiteSpace(employee.EmployeeNo) || employee.EmployeeNo.Equals("0"))
				{
					
					var maxEmployeeNumber = emps.Select(e => e.EmployeeNo).ToList();
					if (maxEmployeeNumber.Any(e => !string.IsNullOrWhiteSpace(e)))
					{
						me.EmployeeNo = (maxEmployeeNumber.Select(e => Convert.ToInt32(e)).Max() + 1).ToString();
					}
					else
					{
						me.EmployeeNo = "1";
					}
				}
				if (!employee.CompanyEmployeeNo.HasValue)
					me.CompanyEmployeeNo = emps.Max(e => e.CompanyEmployeeNo) + 1;
				_dbContext.Employees.Add(me);
			}
			else if(dbEmployees.Count>1)
			{
				throw new Exception("Another employee with the same SSN exists in this company");
			}
			else
			{
				var dbEmployee = dbEmployees.First();
				me.Id = dbEmployee.Id;
				dbEmployee.FirstName = me.FirstName;
				dbEmployee.LastName = me.LastName;
				dbEmployee.LastModified = me.LastModified;
				dbEmployee.LastModifiedBy = me.LastModifiedBy;
				dbEmployee.Contact = me.Contact;
				dbEmployee.Department = me.Department;
				dbEmployee.SSN = me.SSN;
				dbEmployee.BirthDate = me.BirthDate;
				dbEmployee.HireDate = me.HireDate; 
				dbEmployee.SickLeaveHireDate = me.SickLeaveHireDate;
				dbEmployee.CarryOver = me.CarryOver;
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
				dbEmployee.CompanyEmployeeNo = me.CompanyEmployeeNo;
				dbEmployee.Notes = me.Notes;
				dbEmployee.StatusId = me.StatusId;
				dbEmployee.PayTypeAccruals = me.PayTypeAccruals;

				var removeCounter = 0;
				for (removeCounter = 0; removeCounter < dbEmployee.EmployeeBankAccounts.Count; removeCounter++)
				{
					var existingSor = dbEmployee.EmployeeBankAccounts.ToList()[removeCounter];
					if (me.EmployeeBankAccounts.All(mer => mer.Id != existingSor.Id))
					{
						_dbContext.EmployeeBankAccounts.Remove(existingSor);
						removeCounter--;
					}
				}
				
				foreach (var b in dbEmployee.EmployeeBankAccounts.Where(eb => me.EmployeeBankAccounts.Any(meb => meb.Id == eb.Id)))
				{
					var matching = me.EmployeeBankAccounts.First(meb => meb.Id == b.Id);
					b.BankAccount.AccountName = matching.BankAccount.AccountName;
					b.BankAccount.AccountNumber = matching.BankAccount.AccountNumber;
					b.BankAccount.FractionId = matching.BankAccount.FractionId;
					b.BankAccount.AccountType = matching.BankAccount.AccountType;
					b.BankAccount.RoutingNumber = matching.BankAccount.RoutingNumber;
					b.BankAccount.BankName = matching.BankAccount.BankName;
					b.BankAccount.LastModified = matching.BankAccount.LastModified;
					b.BankAccount.LastModifiedBy = matching.BankAccount.LastModifiedBy;
					b.Percentage = matching.Percentage;
				}
				_dbContext.EmployeeBankAccounts.AddRange(me.EmployeeBankAccounts.Where(meb => meb.Id == 0));
				
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
					dbdeduction.AccountNo = mappeddeduction.AccountNo;
					dbdeduction.AgencyId = mappeddeduction.AgencyId;
					dbdeduction.CeilingPerCheck = mappeddeduction.CeilingPerCheck;
					dbdeduction.Limit = mappeddeduction.Limit;
					dbdeduction.Priority = mappeddeduction.Priority;
					dbdeduction.CeilingMethod = mappeddeduction.CeilingMethod;
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


		public VendorCustomer GetVendorCustomersById(Guid vcId)
		{
			var db = _dbContext.VendorCustomers.First(vc => vc.Id == vcId);
			return _mapper.Map<Models.DataModel.VendorCustomer, VendorCustomer>(db);
		}

		public Company CopyCompany(Guid oldCompanyId, Guid companyId, Guid oldHostId, Guid newHostId, bool copyEmployees,
			bool copyPayrolls, DateTime? startDate, DateTime? endDate, string user)
		{
			using (var con = new SqlConnection(_sqlCon))
			{
				using (var cmd = new SqlCommand("CopyCompany"))
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Parameters.AddWithValue("@oldHost", oldHostId);
					cmd.Parameters.AddWithValue("@newHost", newHostId);
					cmd.Parameters.AddWithValue("@oldCompanyId", oldCompanyId);
					cmd.Parameters.AddWithValue("@CompanyId", companyId);
					cmd.Parameters.AddWithValue("@LastModifiedBy", user);
					cmd.Parameters.AddWithValue("@copyEmployees", copyEmployees);
					cmd.Parameters.AddWithValue("@copyPayrolls", copyPayrolls);
					if(startDate.HasValue)
						cmd.Parameters.AddWithValue("@payrollStart", startDate.Value);
					if(endDate.HasValue)
						cmd.Parameters.AddWithValue("@payrollEnd", endDate.Value);

					cmd.Connection = con;
					con.Open();


					var data = string.Empty;
					cmd.ExecuteNonQuery();
					con.Close();
					var dbCompany = _dbContext.Companies.First(c => c.Id == companyId);
					return _mapper.Map<Models.DataModel.Company, Models.Company>(dbCompany);

				}
			}
		}
		
		public void SaveTSImportMap(Guid id, ImportMap importMap)
		{
			var dbVal = _dbContext.CompanyTSImportMaps.FirstOrDefault(m => m.CompanyId == id);
			if (dbVal != null)
				dbVal.TimeSheetImportMap = JsonConvert.SerializeObject(importMap);
			else
			{
				_dbContext.CompanyTSImportMaps.Add(new CompanyTSImportMap
				{
					CompanyId = id,
					TimeSheetImportMap = JsonConvert.SerializeObject(importMap)
				});
			}
			_dbContext.SaveChanges();
		}

		public List<Company> GetLocations(Guid parentId)
		{
			var companies = _dbContext.Companies.Where(c => c.ParentId == parentId);
			return _mapper.Map<List<Models.DataModel.Company>, List<Models.Company>>(companies.ToList());
		}

		public void UpdateMinWage(decimal minWage, List<Employee> selectEmployees, List<Company> selectedCompanies)
		{
			var companies = _dbContext.Companies.ToList();
			companies.ForEach(c =>
			{
				var comp = selectedCompanies.FirstOrDefault(c1 => c1.Id == c.Id);
				if (comp != null)
				{
					c.MinWage = 10;
				}
			});
			_dbContext.Employees.ToList().ForEach(e1 =>
			{
				var e = selectEmployees.FirstOrDefault(e2 => e2.Id == e1.Id);
				if (e != null)
				{
					e1.Rate = 10;
					e1.PayCodes = JsonConvert.SerializeObject(e.PayCodes);
				}
				
			});
			
			_dbContext.SaveChanges();
		}

		public void CopyEmployees(Guid sourceCompanyId, Guid targetCompanyId, List<Guid> employeeIds, string user, bool keepEmployeeNumbers)
		{
			using (var con = new SqlConnection(_sqlCon))
			{
				using (var cmd = new SqlCommand("CopyEmployees"))
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Parameters.AddWithValue("@oldCompanyId", sourceCompanyId);
					cmd.Parameters.AddWithValue("@CompanyId", targetCompanyId);
					if(employeeIds.Any())
						cmd.Parameters.AddWithValue("@employeeIds", employeeIds.Aggregate(string.Empty, (current, m) => current + m + ", "));
					cmd.Parameters.AddWithValue("@LastModifiedBy", user);
					cmd.Parameters.AddWithValue("@KeepEmployeeNumbers", keepEmployeeNumbers);
				
					cmd.Connection = con;
					con.Open();


					var data = string.Empty;
					cmd.ExecuteNonQuery();
					con.Close();
				}
			}
		}

		public void SaveWorkerCompensations(List<CompanyWorkerCompensation> rates, int wcImportOption)
		{
			string update = @"update CompanyWorkerCompensation set Rate=@Rate where CompanyId=@CompanyId and Code=@Code {0}";
			var query = string.Format(update, wcImportOption == 2 ? " and Rate<@Rate;" : ";");
			using (var conn = GetConnection())
			{
				conn.Execute(query, rates);
			}
		}

		public Employee GetEmployeeById(Guid id)
		{
			var emp = _dbContext.Employees.FirstOrDefault(e => e.Id == id);
			return _mapper.Map<Models.DataModel.Employee, Models.Employee>(emp);
		}

		public void SaveEmployeeSickLeaveAndCarryOver(Employee employee)
		{
			var mapped = _mapper.Map<Models.Employee, Models.DataModel.Employee>(employee);
			var company = _dbContext.Companies.First(c => c.Id == employee.CompanyId);
			const string update = @"update e set SickLeaveHireDate=@SickLeaveHireDate, CarryOver=@CarryOver from Employee e, Company c where e.CompanyId=c.Id and e.SSN=@SSN and ((@IsPeo=1 and c.Id in (select Id from Company where HostId=@HostId and FileUnderHost=1)) or (@IsPeo=0 and c.Id=@Company))";
			using (var conn = GetConnection())
			{
				conn.Execute(update, new { SickLeaveHireDate=mapped.SickLeaveHireDate, CarryOver=mapped.CarryOver, SSN=mapped.SSN, HostId=company.HostId, IsPeo=company.FileUnderHost, Company=employee.CompanyId});
			}
		}

		public List<EmployeeSSNCheck> CheckSSN(string ssn)
		{
			const string query =
				"select e.Id as Id, h.FirmName as Host, c.CompanyName as Company, FirstName, MiddleInitial, LastName from employee e, company c, host h where e.companyId=c.Id and c.HostId=h.Id and e.ssn=@SSN;";
			using (var conn = GetConnection())
			{
				return conn.Query<EmployeeSSNCheck>(query, new { SSN = ssn }).ToList();
				
			}
		}

		public void SaveCompanyInvoiceSetup(Guid id, string invoiceSetup)
		{
			const string query = "update CompanyContract set InvoiceSetup=@InvoiceSetup where CompanyId=@Id";
			using (var conn = GetConnection())
			{
				conn.Execute(query, new {Id = id, InvoiceSetup = invoiceSetup});

			}
		}

		public Account GetCompanyAccountById(Guid companyId, int accountId)
		{
			const string sql = "select * from CompanyAccount where CompanyId=@CompanyId and Id=@AccountId";
			const string sql2 = "select * from BankAccount where Id=@Id";
			using (var conn = GetConnection())
			{
				var account = conn.Query<CompanyAccount>(sql, new { CompanyId = companyId, AccountId=accountId }).Single();
				account.BankAccount = conn.Query<Models.DataModel.BankAccount>(sql2, new { Id = account.BankAccountId }).FirstOrDefault();
				
				return _mapper.Map<CompanyAccount, Account>(account);
			}
		}

		public void UpdateEmployeePayrollSchedules(Guid id, PayrollSchedule payrollSchedule)
		{
			const string sql = "update Employee set PayrollSchedule=@PayrollSchedule where CompanyId=@CompanyId";
			using (var conn = GetConnection())
			{
				conn.Execute(sql, new {CompanyId = id, PayrollSchedule = (int) payrollSchedule});
			}
		}
	}
}
