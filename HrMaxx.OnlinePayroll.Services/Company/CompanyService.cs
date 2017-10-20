﻿using System;
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
							TaxYear=year, UITaxId = 10
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

		public Company Save(Company company)
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
					var savedcompany = _companyRepository.SaveCompany(company);
					var savedcontract = _companyRepository.SaveCompanyContract(savedcompany, company.Contract);
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
					if (comp != null && savedcompany.MinWage > comp.MinWage)
					{
						var employees = _readerService.GetEmployees(company: savedcompany.Id);
						employees.Where(e => e.PayType != EmployeeType.Salary && (e.Rate < savedcompany.MinWage || e.PayCodes.Any(pc => pc.Id == 0 && pc.HourlyRate < savedcompany.MinWage)))
							.ToList()
							.ForEach(e =>
							{
								e.Rate = e.Rate < savedcompany.MinWage ? savedcompany.MinWage : e.Rate;
								e.PayCodes.Where(pc => pc.Id == 0 && pc.HourlyRate < savedcompany.MinWage).ToList().ForEach(pc => pc.HourlyRate = savedcompany.MinWage);
								SaveEmployee(e);
							});
					}
					
					
					txn.Complete();

					if (comp != null && savedcompany.Contract.InvoiceSetup.SalesRep != null)
					{
						Bus.Publish<CompanySalesRepChangeEvent>(new CompanySalesRepChangeEvent
						{
							SavedObject = savedcompany,
							UserId = company.UserId,
							UserName = company.UserName
						});			
					}

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

		public List<VendorCustomer> GetVendorCustomers(Guid? companyId, bool isVendor)
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

		public List<Employee> SaveEmployees(List<Employee> employees)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					
					var result = new List<Employee>();
					employees.ForEach(e=>result.Add(SaveEmployee(e, false)));
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

		


		public Employee SaveEmployee(Employee employee, bool sendNotification = true)
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
					var savedEmployee = _companyRepository.SaveEmployee(employee);
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
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "employee for company " + employee.FirstName + ", " + employee.LastName + ", " + employee.SSN);
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
				var memento = Memento<Employee>.Create(returnCompany, EntityTypeEnum.Employee, user);
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

		public void SaveTSImportMap(Guid id, ImportMap importMap)
		{
			try
			{
				_companyRepository.SaveTSImportMap(id, importMap);
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

		public void RaiseMinWage(decimal minWage)
		{
			try
			{
				var companies = _readerService.GetCompanies().Where(c => c.HostId == new Guid("75A78BE4-7226-466B-86BA-A6E200DCAAAC") || c.HostId == new Guid("9AF2FC03-5D35-4A82-9E17-A6E200DDBA73")).ToList();
				var employees = _readerService.GetEmployees().Where(e => e.PayType == EmployeeType.Hourly).ToList();
				using (var txn = TransactionScopeHelper.Transaction())
				{
					
					var selectEmployees = new List<Employee>();
					var selectedCompanies = new List<Company>();
					companies.ForEach(c =>
					{
						var emps = employees.Where(e => e.CompanyId == c.Id).ToList();
						if (emps.Count() <= 25)
						{
							selectedCompanies.Add(c);
							emps.ForEach(e =>
							{
								var resave = false;
								
								if (e.Rate ==(decimal)10.5)
								{
									e.Rate = 10;
									resave = true;
								}

								if (e.PayCodes != null && e.PayCodes.Any())
								{
									e.PayCodes.Where(pc => pc.Id == 0).ToList().ForEach(pc =>
									{
										if (pc.HourlyRate ==(decimal)10.5)
										{
											pc.HourlyRate = 10;
											resave = true;
										}

									});
								}
								if (resave)
									selectEmployees.Add(e);
							});
						}
							


					});
					
					
					_companyRepository.UpdateMinWage(minWage, selectEmployees, selectedCompanies);
					txn.Complete();
				}
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "raise min wage");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
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

		public void UpdateWCRates(List<CompanyWorkerCompensation> rates, string fullName, Guid guid)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					_companyRepository.SaveWorkerCompensations(rates);	
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
	}
}
