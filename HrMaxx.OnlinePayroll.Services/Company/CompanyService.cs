using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Messages.Events;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Security;
using HrMaxx.Infrastructure.Services;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Messages.Events;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Repository;
using HrMaxx.OnlinePayroll.Repository.Companies;
using HrMaxx.OnlinePayroll.Repository.Payroll;
using Magnum;
using Newtonsoft.Json;

namespace HrMaxx.OnlinePayroll.Services
{
	public class CompanyService : BaseService, ICompanyService
	{
		private readonly ICompanyRepository _companyRepository;
		private readonly IMementoDataService _mementoDataService;
		private readonly IReaderService _readerService;
		private readonly IPayrollRepository _payrollRepository;
		
		public IBus Bus { get; set; }
		
		public CompanyService(ICompanyRepository companyRepository, IMementoDataService mementoDataService, IReaderService readerService, IPayrollRepository payrollRepository)
		{
			_companyRepository = companyRepository;
			_mementoDataService = mementoDataService;
			_readerService = readerService;
			_payrollRepository = payrollRepository;
		}

		
		public List<CaliforniaCompanyTax> GetCaliforniaCompanyTaxes(int year)
		{
			try
			{
				var companies = _readerService.GetCompanies().Where(c=>c.States.Any(s=>s.CountryId==1 && s.State.StateId==1) && c.CompanyTaxRates.Any(ct=>ct.TaxYear==year)).ToList();
				return companies.Select(c =>
						new CaliforniaCompanyTax()
						{
							CompanyId = c.Id,
							CompanyName = c.Name,
							EttRate = c.CompanyTaxRates.First(ct => ct.TaxYear == year && ct.TaxId == 9).Rate,
							ETTTaxId = 9,
							UiRate = c.CompanyTaxRates.First(ct => ct.TaxYear == year && ct.TaxId == 10).Rate, 
							StateEin = c.States.First(s=>s.CountryId==1 && s.State.StateId==1).StateEIN, 
							TaxYear=year, UITaxId = 10,
							SUIManagementRate = c.Contract.ContractOption == ContractOption.PostPaid ? c.Contract.InvoiceSetup.SUIManagement.ToString() : "NA"
						}
					).ToList();


			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "california state company taxes");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Company Save(Company company, bool updateEmployeeSchedules = false, bool ignoreEinCheck = false)
		{
			try
			{
				var exists = _companyRepository.CompanyExists(company.Id, company.FederalEIN);
				var comp = _readerService.GetCompany(company.Id);
				var notificationText = !exists ? "A new Company {0} has been created" : "{0} has been updated";
				var eventType = !exists ? NotificationTypeEnum.Created : NotificationTypeEnum.Updated;
				using (var txn = TransactionScopeHelper.Transaction())
				{
					company.CompanyTaxRates.ForEach(ct =>
					{
						ct.CompanyId = company.Id;

					});
					
					var savedcompany = _companyRepository.SaveCompany(company, ignoreEinCheck);
					company.CompanyTaxRates.Where(ctr=>ctr.Id==0).ToList().ForEach(ctr => _companyRepository.SaveCompanyTaxRate(ctr));
					var savedcontract = _companyRepository.SaveCompanyContract(savedcompany, company.Contract);
					if(company.RecurringCharges!=null && company.RecurringCharges.Any())
						savedcompany.RecurringCharges = _companyRepository.SaveRecurringCharges(savedcompany, company.RecurringCharges);
					
					var savedstates = _companyRepository.SaveTaxStates(savedcompany, company.States);
					savedcompany.Contract = savedcontract;
					savedcompany.States = savedstates;
					if (!company.IsLocation)
					{
						var children = _companyRepository.GetLocations(company.Id);
						children.ForEach(child =>
						{
							child.FileUnderHost = savedcompany.FileUnderHost;
							child.IsVisibleToHost = savedcompany.IsVisibleToHost;
							child.FederalEIN = savedcompany.FederalEIN;
							child.FederalPin = savedcompany.FederalPin;
							child.IsFiler944 = savedcompany.IsFiler944;
							child.AllowEFileFormFiling = savedcompany.AllowEFileFormFiling;
							child.AllowTaxPayments = savedcompany.AllowTaxPayments;
							child.DepositSchedule = savedcompany.DepositSchedule;
							for (var i = 0; i < child.States.Count; i++)
							{
								var cs = child.States[i];
								var ps =
									savedcompany.States.FirstOrDefault(s => s.CountryId == cs.CountryId && s.State.StateId == cs.State.StateId);
								if (ps != null)
								{
									cs.StateEIN = ps.StateEIN;
									cs.StatePIN = ps.StatePIN;
                                    cs.StateUIAccount = ps.StateUIAccount;
                                }
								else
								{
									child.States.Remove(cs);
								}
							}
							_companyRepository.SaveCompany(child);
							_companyRepository.SaveTaxStates(child, child.States);

						});
					}
					if (comp != null && savedcompany.MinWage.HasValue && savedcompany.MinWage > comp.MinWage)
					{
						var employees = _readerService.GetEmployees(company: savedcompany.Id);

						employees.Where(e => e.PayType != EmployeeType.Salary && (e.Rate < savedcompany.MinWage || e.PayCodes.Any(pc => pc.Id == 0 && pc.HourlyRate < savedcompany.MinWage)))
							.ToList()
							.ForEach(e =>
							{
								e.Rate = e.Rate < savedcompany.MinWage.Value ? savedcompany.MinWage.Value : e.Rate;
								e.PayCodes.Where(pc => pc.Id == 0 && pc.HourlyRate < savedcompany.MinWage).ToList().ForEach(pc => pc.HourlyRate = savedcompany.MinWage.Value);
								SaveEmployee(e);
							});
						
					}
					if (updateEmployeeSchedules && comp.PayrollSchedule != savedcompany.PayrollSchedule)
					{
						_companyRepository.UpdateEmployeePayrollSchedules(savedcompany.Id, savedcompany.PayrollSchedule);
					}
					
					txn.Complete();

					//if (comp != null && savedcompany.Contract.ContractOption==ContractOption.PostPaid && savedcompany.Contract.BillingOption==BillingOptions.Invoice 
					//	&& savedcompany.Contract.InvoiceSetup.SalesRep != null)
					//{
					//	Bus.Publish<CompanySalesRepChangeEvent>(new CompanySalesRepChangeEvent
					//	{
					//		SavedObject = savedcompany,
					//		UserId = company.UserId,
					//		UserName = company.UserName
					//	});			
					//}

					Bus.Publish<CompanyUpdatedEvent>(new CompanyUpdatedEvent
					{
						SavedObject = savedcompany,
						UserId = company.UserId,
						TimeStamp = DateTime.Now,
						NotificationText = string.Format("{0} by {1}", string.Format(notificationText, savedcompany.Name), savedcompany.UserName),
						EventType = eventType
					});
					
				}
				var returnCompany = _readerService.GetCompany(company.Id);
				var memento = Memento<Company>.Create(returnCompany, EntityTypeEnum.Company, returnCompany.UserName, "Company Updated", company.UserId);
				_mementoDataService.AddMementoData(memento);
				return returnCompany;

			}
			catch (Exception e)
			{
				var message = string.Empty;
				if(e.Message.StartsWith("FEIN"))
					message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, e.Message);
				else
					message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "company details for company " + company.Name);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}

		}

		public Company SaveHostCompany(Company company, Models.Host savedHost)
		{
			try
			{
					company.CompanyTaxRates.ForEach(ct =>
					{
						ct.CompanyId = company.Id;

					});
					var savedcompany = _companyRepository.SaveCompany(company);
					var savedcontract = _companyRepository.SaveCompanyContract(savedcompany, company.Contract);
					var savedstates = _companyRepository.SaveTaxStates(savedcompany, company.States);
					savedcompany.Contract = savedcontract;
					savedcompany.States = savedstates;

					if (savedHost.IsPeoHost)
					{
						var hostCompanies = _readerService.GetCompanies(host:savedHost.Id);
						hostCompanies.Where(c => !c.IsHostCompany && c.DepositSchedule != company.DepositSchedule).ToList().ForEach(c =>
						{
							c.DepositSchedule = company.DepositSchedule;
							var savedCompany = _companyRepository.SaveCompany(c);
							var mementoC = Memento<Company>.Create(savedCompany, EntityTypeEnum.Company, savedcompany.UserName, "Deposit Schedule updated because Host Company had different Deposit Schedule", company.UserId);
							_mementoDataService.AddMementoData(mementoC, true);
						});
					}
				

					var memento = Memento<Company>.Create(savedcompany, EntityTypeEnum.Company, savedcompany.UserName, "Host Company Updated", company.UserId);
					_mementoDataService.AddMementoData(memento);
					return savedcompany;
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "company details for company " + company.Name);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public CompanyDeduction SaveDeduction(CompanyDeduction deduction, string user, Guid userId)
		{
			try
			{
				var returnDed = _companyRepository.SaveDeduction(deduction);
				var returnCompany = _readerService.GetCompany(deduction.CompanyId);
				var memento = Memento<Company>.Create(returnCompany, EntityTypeEnum.Company, returnCompany.UserName, string.Format("Deduction Updated {0}", deduction.DeductionName), userId);
				_mementoDataService.AddMementoData(memento, true);
				
				return returnDed;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "deduction for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public CompanyWorkerCompensation SaveWorkerCompensation(CompanyWorkerCompensation workerCompensation, string user, Guid userId)
		{
			try
			{
				var wc = _companyRepository.SaveWorkerCompensation(workerCompensation);
				var returnCompany = _readerService.GetCompany(wc.CompanyId);
				var memento = Memento<Company>.Create(returnCompany, EntityTypeEnum.Company, user, string.Format("WC definition updated {0}", workerCompensation.Code), userId);
				_mementoDataService.AddMementoData(memento, true);
				return wc;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "worker compensation for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public AccumulatedPayType SaveAccumulatedPayType(AccumulatedPayType mappedResource, string user, Guid userId)
		{
			try
			{
				var apt =  _companyRepository.SaveAccumulatedPayType(mappedResource);
				var returnCompany = _readerService.GetCompany(apt.CompanyId);
				var memento = Memento<Company>.Create(returnCompany, EntityTypeEnum.Company, user, string.Format("Accumulated PayType Updated {0}", mappedResource.PayType.Name), userId);
				_mementoDataService.AddMementoData(memento, true);
				return apt;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "accumulated pay type for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public CompanyPayCode SavePayCode(CompanyPayCode mappedResource, string user, Guid userId)
		{
			try
			{
				var employees = _readerService.GetEmployees(company: mappedResource.CompanyId);
				using (var txn = TransactionScopeHelper.Transaction())
				{
					var pc = _companyRepository.SavePayCode(mappedResource);
					
					employees.Where(e => e.PayCodes.Any(ec => ec.Id == pc.Id)).ToList().ForEach(e =>
					{
						e.PayCodes.RemoveAll(ec => ec.Id == pc.Id);
						e.PayCodes.Add(pc);
						_companyRepository.SaveEmployee(e);
						
					});
					var returnCompany = _readerService.GetCompany(pc.CompanyId);
					var memento = Memento<Company>.Create(returnCompany, EntityTypeEnum.Company, user, "Pay Code updated: " + mappedResource.Code, userId);
					_mementoDataService.AddMementoData(memento, true);
					txn.Complete();
					return pc;	
				}
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "pay code for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		public CompanyRenewal SaveRenewal(CompanyRenewal renewal, string user, Guid userId)
		{
			try
			{
				
				using (var txn = TransactionScopeHelper.Transaction())
				{
					var pc = _companyRepository.SaveRenewal(renewal);

					var returnCompany = _readerService.GetCompany(pc.CompanyId);
					var memento = Memento<Company>.Create(returnCompany, EntityTypeEnum.Company, user, "Renewal updated: " + renewal.Description, userId);
					_mementoDataService.AddMementoData(memento, true);
					txn.Complete();
					return pc;
				}

			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "renewal for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<VendorCustomer> GetVendorCustomers(Guid? companyId, bool? isVendor = null)
		{
			try
			{
				return _companyRepository.GetVendorCustomers(companyId, isVendor);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format("getting vendor customer list for {0}, {1}", companyId, isVendor));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public VendorCustomer SaveVendorCustomers(VendorCustomer mappedResource)
		{
			try
			{
				var returnVal = _companyRepository.SaveVendorCustomer(mappedResource);
				var memento = Memento<Models.VendorCustomer>.Create(returnVal, returnVal.IsVendor? EntityTypeEnum.Vendor : EntityTypeEnum.Customer, returnVal.UserName);
				_mementoDataService.AddMementoData(memento);
				return returnVal;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "vendor customer for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<Account> GetComanyAccounts(Guid companyId)
		{
			try
			{
				return _companyRepository.GetCompanyAccounts(companyId);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "accounts for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Account SaveCompanyAccount(Account mappedResource)
		{
			try
			{
				return _companyRepository.SaveCompanyAccount(mappedResource);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "account for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<Employee> SaveEmployees(List<Employee> employees, bool ignoreSSNCheck = false)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					
					var result = new List<Employee>();
					employees.ForEach(e=>result.Add(SaveEmployee(e, false, ignoreSSNCheck)));
					txn.Complete();
					return result;
				}
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "imported employees for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
			
		}

		


		public Employee SaveEmployee(Employee employee, bool sendNotification = true , bool ignoreSSNCheck = false)
		{
			try
			{
				var dbEmployee = _companyRepository.GetEmployeeById(employee.Id);
				var exists = dbEmployee != null;
				using (var txn = TransactionScopeHelper.Transaction())
				{
					
					var notificationText = !exists ? "A new Employee {0} has been created" : "{0} has been updated";
					var eventType = !exists ? NotificationTypeEnum.Created : NotificationTypeEnum.Updated;
					if (employee.PayType == EmployeeType.Hourly &&
					    (employee.PayCodes == null || !employee.PayCodes.Any(pc => pc.Id == 0)))
					{
						if(employee.PayCodes==null)
							employee.PayCodes=new List<CompanyPayCode>();
						employee.PayCodes.Add(new CompanyPayCode()
						{
							Id=0, CompanyId = employee.CompanyId, Code = "Default", Description = "Base Rate", HourlyRate = employee.Rate
						});
					}
					var savedEmployee = _companyRepository.SaveEmployee(employee, ignoreSSNCheck);
					if (dbEmployee!=null && dbEmployee.SickLeaveHireDate < employee.SickLeaveHireDate)
					{
						_payrollRepository.UpdateEmployeeChecksForLeaveCycle(dbEmployee.Id, dbEmployee.SickLeaveHireDate,
							employee.SickLeaveHireDate);
					}
					var memento = Memento<Employee>.Create(savedEmployee, EntityTypeEnum.Employee, savedEmployee.UserName);
					_mementoDataService.AddMementoData(memento);
					if (sendNotification)
					{
						Bus.Publish<EmployeeUpdatedEvent>(new EmployeeUpdatedEvent
						{
							SavedObject = savedEmployee,
							UserId = savedEmployee.UserId,
							TimeStamp = DateTime.Now,
							NotificationText = string.Format("{0} by {1}", string.Format(notificationText, savedEmployee.FullName), savedEmployee.UserName),
							EventType = eventType
						});

					}
					txn.Complete();
					return savedEmployee;	
				}
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "employee for company " + employee.FirstName + ", " + employee.LastName + ", " + employee.SSN + ". " + e.Message);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public EmployeeDeduction SaveEmployeeDeduction(EmployeeDeduction deduction, string user)
		{
			try
			{
				var ed = _companyRepository.SaveEmployeeDeduction(deduction);
				var returnCompany = _readerService.GetEmployee(ed.EmployeeId);
				var memento = Memento<Employee>.Create(returnCompany, EntityTypeEnum.Employee, user, "Deduction Updated");
				_mementoDataService.AddMementoData(memento, true);
				return ed;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "deduction for employee ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		public EmployeeACA SaveEmployeeACA(EmployeeACA aca)
		{
			try
			{
				return _companyRepository.SaveEmployeeACA(aca);
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "ACA for employee ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void DeleteEmployeeDeduction(int deductionId)
		{
			try
			{
				_companyRepository.DeleteEmployeeDeduction(deductionId);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " delete deduction for employee ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<Account> GetCompanyPayrollAccounts(Guid id)
		{
			try
			{
				var companyAccounts = _companyRepository.GetCompanyAccounts(id);
				return
					companyAccounts.Where(a => !string.IsNullOrWhiteSpace(a.TaxCode) || (a.BankAccount != null && a.UseInPayroll))
						.ToList();
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " payroll COAs for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public CompanyTaxRate SaveCompanyTaxYearRate(CompanyTaxRate mappedResource, string user, Guid userId)
		{
			try
			{
				var tr = _companyRepository.SaveCompanyTaxRate(mappedResource);

				var returnCompany = _readerService.GetCompany(tr.CompanyId);
				var memento = Memento<Company>.Create(returnCompany, EntityTypeEnum.Company, user, string.Format("Tax rate updated {0}", mappedResource.TaxCode), userId);
				_mementoDataService.AddMementoData(memento, true);
				tr.TaxCode = mappedResource.TaxCode;
				return tr;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "tax year rate for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public VendorCustomer GetVendorCustomersById(Guid vcId)
		{
			try
			{
				return _companyRepository.GetVendorCustomersById(vcId);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "vendor customer by Id= " + vcId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void SaveTSImportMap(Guid id, ImportMap importMap, int type = 1)
		{
			try
			{
				_companyRepository.SaveTSImportMap(id, importMap, type);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, string.Format(" save TS Import Map"));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Company SaveLocation(CompanyLocation mappedResource, string fullName, Guid guid)
		{
			try
			{
				var parent = _readerService.GetCompany(mappedResource.ParentId);
				using (var txn = TransactionScopeHelper.Transaction())
				{
					
					var child = JsonConvert.DeserializeObject<Company>(JsonConvert.SerializeObject(parent));
					child.Id = mappedResource.Id;
					child.ParentId = parent.Id;
					child.CompanyAddress = mappedResource.Address;
					child.BusinessAddress = mappedResource.Address;
					child.Name = mappedResource.Name;
					child.Locations = null;
					child.Created = DateTime.Now;
					child.LastModified = DateTime.Now;
					child.UserName = fullName;
					child.UserId = guid;
					child.CompanyTaxRates.ForEach(ct =>
					{
						ct.CompanyId = child.Id;

					});
					
					child.States.ForEach(ct =>
					{
						ct.Id = 0;

					});
					
					var savedcompany = _companyRepository.SaveCompany(child);
					var savedcontract = _companyRepository.SaveCompanyContract(savedcompany, child.Contract);
					var savedstates = _companyRepository.SaveTaxStates(savedcompany, child.States);
					savedcompany.Contract = savedcontract;
					savedcompany.States = savedstates;
					child.Deductions.ForEach(ct =>
					{
						ct.Id = 0;
						ct.CompanyId = child.Id;
						ct.Id =_companyRepository.SaveDeduction(ct).Id;

					});
					child.WorkerCompensations.ForEach(ct =>
					{
						ct.Id = 0;
						ct.CompanyId = child.Id;
						ct.Id = _companyRepository.SaveWorkerCompensation(ct).Id;
					});
					child.PayCodes.ForEach(ct =>
					{
						ct.Id = 0;
						ct.CompanyId = child.Id;
						ct.Id = _companyRepository.SavePayCode(ct).Id;
					});
					child.AccumulatedPayTypes.ForEach(ct =>
					{
						ct.Id = 0;
						ct.CompanyId = child.Id;
						ct.Id = _companyRepository.SaveAccumulatedPayType(ct).Id;
					});
					
					txn.Complete();
					Bus.Publish<CompanyUpdatedEvent>(new CompanyUpdatedEvent
					{
						SavedObject = savedcompany,
						UserId = guid,
						TimeStamp = DateTime.Now,
						NotificationText = string.Format("{0} by {1}", string.Format("A new location has been added for {0}", parent.Name), child.UserName),
						EventType = NotificationTypeEnum.Created
					});
				}
				var saved = _readerService.GetCompany(mappedResource.Id);
				var memento = Memento<Company>.Create(saved, EntityTypeEnum.Company, saved.UserName, "Company Location Added", guid);
				_mementoDataService.AddMementoData(memento);
				return saved;

			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, string.Format(" location for company " + mappedResource.ParentId));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void RaiseMinWage(MinWageEligibilityCriteria criteria, string user, Guid userId)
		{
			try
			{
				if(!criteria.MinWage.HasValue)
					throw new Exception("Please provide minimum wage!");
				criteria.Companies.ForEach(c =>
				{
					var comp = _readerService.GetCompany(c.CompanyId);
					comp.MinWage = comp.MinWage.HasValue ? comp.MinWage.Value : 0;
					if (comp != null)
					{
						if (criteria.MinWage > comp.MinWage)
						{
							comp.MinWage = criteria.MinWage.Value;
							_companyRepository.SaveCompany(comp);
						}

						var employees = _readerService.GetEmployees(company: comp.Id);
						employees.Where(e => e.PayType != EmployeeType.Salary && (e.Rate < comp.MinWage || e.PayCodes.Any(pc => pc.Id == 0 && pc.HourlyRate < comp.MinWage.Value)))
							.ToList()
							.ForEach(e =>
							{
								e.Rate = e.Rate < comp.MinWage.Value ? comp.MinWage.Value : e.Rate;
								e.PayCodes.Where(pc => pc.Id == 0 && pc.HourlyRate < comp.MinWage.Value).ToList().ForEach(pc => pc.HourlyRate = comp.MinWage.Value);
								SaveEmployee(e, false);
							});
						var memento = Memento<Company>.Create(comp, EntityTypeEnum.Company, user, "Min Wage Raised", userId);
						_mementoDataService.AddMementoData(memento);
					}
				});
				
					
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "raise min wage for " + JsonConvert.SerializeObject(criteria));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(e.Message.Replace(Environment.NewLine, string.Empty), e);
			}
		}

		public void CopyEmployees(Guid sourceCompanyId, Guid targetCompanyId, List<Guid> employeeIds, string fullName, bool keepEmployeeNumbers)
		{
			try
			{
				var company = _readerService.GetCompany(targetCompanyId);
				using (var txn = TransactionScopeHelper.Transaction())
				{
					_companyRepository.CopyEmployees(sourceCompanyId, targetCompanyId, employeeIds, fullName, keepEmployeeNumbers);
					
					var employees = _readerService.GetEmployees(company: targetCompanyId);
					employees.Where(e => e.PayCodes.Any()).ToList().ForEach(e =>
					{
						e.PayCodes.ForEach(pc =>
						{
							if (pc.Id > 0)
								pc.Id = company.PayCodes.First(pc1 => pc1.Code.Equals(pc.Code)).Id;
							pc.CompanyId = company.Id;
						});
						SaveEmployee(e, true);

					});
					txn.Complete();
				}
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "company employees from " + sourceCompanyId + " to "+ targetCompanyId + ". "+e.Message);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(e.Message.Replace(Environment.NewLine, string.Empty), e);
			}
		}

		public void UpdateWCRates(List<CompanyWorkerCompensation> rates, string fullName, Guid guid, int wcImportOption)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					_companyRepository.SaveWorkerCompensations(rates, wcImportOption);	
					txn.Complete();
				}
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "updating wc rates" + e.Message);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(e.Message.Replace(Environment.NewLine, string.Empty), e);
			}
		}

		public List<EmployeeSSNCheck> CheckSSN(string ssn)
		{
			try
			{
				return _companyRepository.CheckSSN(Crypto.Encrypt(ssn));
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "ssn values" + e.Message);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(e.Message.Replace(Environment.NewLine, string.Empty), e);
			}
		}

		public void BulkTerminateEmployees(Guid companyId, List<Guid> employees, string userId, string name)
		{
			try
			{
				var emps = _readerService.GetEmployees(company: companyId);
				var employeeList = new List<Employee>();
				employees.ForEach(e =>
				{
					var employee = emps.First(e1 => e1.Id == e);
					employee.StatusId = StatusOption.Terminated;
					employee.LastModified = DateTime.Now;
					employee.UserId = new Guid(userId);
					employee.UserName = name;
					employeeList.Add(employee);
				});
				SaveEmployees(employeeList);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " bulk terminate employees" + e.Message);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(e.Message.Replace(Environment.NewLine, string.Empty), e);
			}
		}

		public Account GetComanyAccountById(Guid companyId, int accountId)
		{
			try
			{
				return _companyRepository.GetCompanyAccountById(companyId, accountId);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "account for company by id " + accountId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void SaveRenewalDate(Guid companyId, int renewalId, string fullName)
		{
			try
			{
				_companyRepository.SaveRenewalDate(companyId, renewalId, fullName);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " save renewal date completion " + renewalId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public CompanyProject SaveProject(CompanyProject project, Guid userId)
		{
			try
			{
				var project1 = _companyRepository.SaveProject(project);
				var returnCompany = _readerService.GetCompany(project.CompanyId);
				var memento = Memento<Company>.Create(returnCompany, EntityTypeEnum.Company, returnCompany.UserName, string.Format("Project Updated {0}", project.ProjectName), userId);
				_mementoDataService.AddMementoData(memento, true);
				return project1;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " save project " + project.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<TimesheetEntry> GetEmployeeTimesheet(Guid companyId, Guid? employeeId, int month, int year)
		{
			try
			{
				var data =  _companyRepository.GetEmployeeTimesheet(companyId, employeeId, new DateTime(year, month, 1).Date, new DateTime(year, month, DateTime.DaysInMonth(year, month)).Date);
				return data;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " get time sheet entry for employee " + employeeId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public TimesheetEntry SaveTimesheetEntry(TimesheetEntry resource)
		{
			try
			{
				return _companyRepository.SaveTimesheetEntry(resource);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " save time sheet entry for employee " + resource.EmployeeId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public TimesheetEntry DeleteEmployeeTimesheet(int id)
		{
			try
			{
				return _companyRepository.DeleteTimesheetEntry(id);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " delete time sheet entry with id " + id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<TimesheetEntry> SaveTimesheetEntries(List<TimesheetEntry> resources)
		{
			try
			{
				using(var txn = TransactionScopeHelper.Transaction())
				{
					resources.ForEach(t =>
					{
						t = _companyRepository.SaveTimesheetEntry(t);
					});
					txn.Complete();
				}
				return resources;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " delete time sheet entry with id ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Product SaveProduct(Product product)
		{
			try
			{
				
				return _companyRepository.SaveProduct(product);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " save product ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
	}
}
