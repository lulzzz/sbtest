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
		List<Account> GetComanyAccounts(Guid companyId);
		List<Account> GetCompanyPayrollAccounts(Guid id);
		VendorCustomer GetVendorCustomersById(Guid vcId);
		List<CaliforniaCompanyTax> GetCaliforniaCompanyTaxes(int year);
		

		Company Save(Company mappedResource);
		Company SaveHostCompany(Company company, Host savedHost);
		CompanyDeduction SaveDeduction(CompanyDeduction deduction, string fullName, Guid userId);
		CompanyWorkerCompensation SaveWorkerCompensation(CompanyWorkerCompensation workerCompensation, string fullName, Guid guid);
		AccumulatedPayType SaveAccumulatedPayType(AccumulatedPayType mappedResource, string fullName, Guid guid);
		CompanyPayCode SavePayCode(CompanyPayCode mappedResource, string fullName, Guid guid);
		List<VendorCustomer> GetVendorCustomers(Guid? companyId, bool isVendor);
		VendorCustomer SaveVendorCustomers(VendorCustomer mappedResource);
		
		Account SaveCompanyAccount(Account mappedResource);
		
		Employee SaveEmployee(Employee mappedResource, bool sendNotification = true);
		EmployeeDeduction SaveEmployeeDeduction(EmployeeDeduction mappedResource, string fullName);
		void DeleteEmployeeDeduction(int deductionId);
		
		CompanyTaxRate SaveCompanyTaxYearRate(CompanyTaxRate mappedResource, string fullName, Guid guid);
		
		List<Employee> SaveEmployees(List<Employee> employees);

		
		void SaveTSImportMap(Guid id, ImportMap importMap);
		Company SaveLocation(CompanyLocation mappedResource, string fullName, Guid guid);
		void RaiseMinWage(decimal minWage);
	}
}
