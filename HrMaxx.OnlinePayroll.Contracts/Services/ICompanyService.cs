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
		Company SaveHostCompany(Company company, Host savedHost);
		CompanyDeduction SaveDeduction(CompanyDeduction deduction, string fullName, Guid userId);
		CompanyWorkerCompensation SaveWorkerCompensation(CompanyWorkerCompensation workerCompensation, string fullName, Guid guid);
		AccumulatedPayType SaveAccumulatedPayType(AccumulatedPayType mappedResource, string fullName, Guid guid);
		CompanyPayCode SavePayCode(CompanyPayCode mappedResource, string fullName, Guid guid);
		List<VendorCustomer> GetVendorCustomers(Guid? companyId, bool isVendor);
		VendorCustomer SaveVendorCustomers(VendorCustomer mappedResource);
		List<Account> GetComanyAccounts(Guid companyId);
		Account SaveCompanyAccount(Account mappedResource);
		List<Employee> GetEmployeeList(Guid companyId);
		Employee SaveEmployee(Employee mappedResource, bool sendNotification = true);
		EmployeeDeduction SaveEmployeeDeduction(EmployeeDeduction mappedResource, string fullName);
		void DeleteEmployeeDeduction(int deductionId);
		List<Account> GetCompanyPayrollAccounts(Guid id);
		CompanyTaxRate SaveCompanyTaxYearRate(CompanyTaxRate mappedResource, string fullName, Guid guid);
		Company GetCompanyById(Guid companyId);
		VendorCustomer GetVendorCustomersById(Guid vcId);
		List<Employee> SaveEmployees(List<Employee> employees);

		List<Company> GetAllCompanies();
		List<CaliforniaCompanyTax> GetCaliforniaCompanyTaxes(int year);

		List<Employee> GetAllEmployees();
		void SaveTSImportMap(Guid id, ImportMap importMap);
		Company SaveLocation(CompanyLocation mappedResource, string fullName, Guid guid);
	}
}
