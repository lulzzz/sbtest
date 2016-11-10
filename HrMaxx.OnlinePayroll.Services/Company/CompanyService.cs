using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Messages.Events;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Messages.Events;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Repository;
using HrMaxx.OnlinePayroll.Repository.Companies;
using Magnum;

namespace HrMaxx.OnlinePayroll.Services
{
	public class CompanyService : BaseService, ICompanyService
	{
		private readonly ICompanyRepository _companyRepository;
		private readonly IMementoDataService _mementoDataService;
		
		public IBus Bus { get; set; }
		
		public CompanyService(ICompanyRepository companyRepository, IMementoDataService mementoDataService)
		{
			_companyRepository = companyRepository;
			_mementoDataService = mementoDataService;
		}

		

		public IList<Company> GetCompanies(Guid hostId, Guid companyId)
		{
			try
			{
				var companies = _companyRepository.GetCompanies(hostId, companyId);
				return companies;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "company list for host");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<Company> GetAllCompanies()
		{
			try
			{
				var companies = _companyRepository.GetAllCompanies();
				return companies;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "all companies in the system");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Company Save(Company company)
		{
			try
			{
				var exists = _companyRepository.CompanyExists(company.Id, company.FederalEIN);
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

					
					txn.Complete();
					
					//Bus.Publish<CompanyUpdatedEvent>(new CompanyUpdatedEvent
					//{
					//	SavedObject = savedcompany,
					//	UserId = savedcompany.UserId,
					//	TimeStamp = DateTime.Now,
					//	NotificationText = string.Format("{0} by {1}", string.Format(notificationText, savedcompany.Name), savedcompany.UserName),
					//	EventType = eventType
					//});
					
				}
				var returnCompany = _companyRepository.GetCompanyById(company.Id);
				var memento = Memento<Company>.Create(returnCompany, EntityTypeEnum.Company, returnCompany.UserName);
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

		public Company SaveHostCompany(Company company)
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

					var memento = Memento<Company>.Create(savedcompany, EntityTypeEnum.Company, savedcompany.UserName);
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

		public CompanyDeduction SaveDeduction(CompanyDeduction deduction, string user)
		{
			try
			{
				var returnDed = _companyRepository.SaveDeduction(deduction);
				var memento = Memento<CompanyDeduction>.Create(returnDed, EntityTypeEnum.CompanyDeductions, user);
				_mementoDataService.AddMementoData(memento);
				return returnDed;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "deduction for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public CompanyWorkerCompensation SaveWorkerCompensation(CompanyWorkerCompensation workerCompensation)
		{
			try
			{
				return _companyRepository.SaveWorkerCompensation(workerCompensation);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "worker compensation for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public AccumulatedPayType SaveAccumulatedPayType(AccumulatedPayType mappedResource)
		{
			try
			{
				return _companyRepository.SaveAccumulatedPayType(mappedResource);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "accumulated pay type for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public CompanyPayCode SavePayCode(CompanyPayCode mappedResource)
		{
			try
			{
				return _companyRepository.SavePayCode(mappedResource);
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

		public List<Employee> GetEmployeeList(Guid companyId)
		{
			try
			{
				return _companyRepository.GetEmployeeList(companyId);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format("getting employee list for {0}", companyId));
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
				var exists = _companyRepository.EmployeeExists(employee.Id);
				var notificationText = !exists ? "A new Employee {0} has been created" : "{0} has been updated";
				var eventType = !exists ? NotificationTypeEnum.Created : NotificationTypeEnum.Updated;
				var savedEmployee = _companyRepository.SaveEmployee(employee);
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
				
				return savedEmployee;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "employee for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public EmployeeDeduction SaveEmployeeDeduction(EmployeeDeduction deduction)
		{
			try
			{
				return _companyRepository.SaveEmployeeDeduction(deduction);
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

		public CompanyTaxRate SaveCompanyTaxYearRate(CompanyTaxRate mappedResource)
		{
			try
			{
				return _companyRepository.SaveCompanyTaxRate(mappedResource);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "tax year rate for company ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Company GetCompanyById(Guid companyId)
		{
			try
			{
				return _companyRepository.GetCompanyById(companyId);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "company by Id= "+companyId);
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

		
	}
}
