using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Contracts.Services
{
	public interface ICompanyService
	{
		IList<Company> GetCompanies(Guid id, Guid hostId);
		Company Save(Company mappedResource);
		Company SaveHostCompany(Company company);
		CompanyDeduction SaveDeduction(CompanyDeduction deduction);
		CompanyWorkerCompensation SaveWorkerCompensation(CompanyWorkerCompensation workerCompensation);
		AccumulatedPayType SaveAccumulatedPayType(AccumulatedPayType mappedResource);
		CompanyPayCode SavePayCode(CompanyPayCode mappedResource);
		List<VendorCustomer> GetVendorCustomers(Guid companyId, bool isVendor);
		VendorCustomer SaveVendorCustomers(VendorCustomer mappedResource);
		List<Account> GetComanyAccounts(Guid companyId);
		Account SaveCompanyAccount(Account mappedResource);
		List<Employee> GetEmployeeList(Guid companyId);
		Employee SaveEmployee(Employee mappedResource, bool sendNotification = true);
		EmployeeDeduction SaveEmployeeDeduction(EmployeeDeduction mappedResource);
		void DeleteEmployeeDeduction(int deductionId);
		List<Account> GetCompanyPayrollAccounts(Guid id);
		CompanyTaxRate SaveCompanyTaxYearRate(CompanyTaxRate mappedResource);
		Company GetCompanyById(Guid companyId);
		VendorCustomer GetVendorCustomersById(Guid vcId);
		List<Employee> SaveEmployees(List<Employee> employees);
		
	}
}
