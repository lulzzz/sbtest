using System;
using System.Collections.Generic;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Repository.Companies
{
	public interface ICompanyRepository

	{
		IList<Company> GetCompanies(Guid hostId, Guid companyId);
		Models.Company SaveCompany(Models.Company company);
		ContractDetails SaveCompanyContract(Company savedcompany, ContractDetails contract);
		List<CompanyTaxState> SaveTaxStates(Company savedcompany, List<CompanyTaxState> states);
		CompanyDeduction SaveDeduction(CompanyDeduction deduction);
		CompanyWorkerCompensation SaveWorkerCompensation(CompanyWorkerCompensation workerCompensation);
		AccumulatedPayType SaveAccumulatedPayType(AccumulatedPayType mappedResource);
		CompanyPayCode SavePayCode(CompanyPayCode mappedResource);
		List<VendorCustomer> GetVendorCustomers(Guid? companyId, bool isVendor);
		VendorCustomer SaveVendorCustomer(VendorCustomer mappedResource);
		List<Account> GetCompanyAccounts(Guid companyId);
		Account SaveCompanyAccount(Account mappedResource);
		bool CompanyExists(Guid companyId, string name);
		List<Employee> GetEmployeeList(Guid companyId);
		Employee SaveEmployee(Employee mappedResource);
		EmployeeDeduction SaveEmployeeDeduction(EmployeeDeduction deduction);
		bool EmployeeExists(Guid id);
		void DeleteEmployeeDeduction(int deductionId);
		void UpdateLastPayrollDateCompany(Guid id, DateTime payDay);
		void UpdateLastPayrollDateEmployee(Guid id, DateTime payDay);
		CompanyTaxRate SaveCompanyTaxRate(CompanyTaxRate mappedResource);
		Company GetCompanyById(Guid companyId);
		VendorCustomer GetVendorCustomersById(Guid vcId);
		Company CopyCompany(Guid oldCompanyId, Guid companyId, Guid oldHostId, Guid newHostId, bool copyEmployees, bool copyPayrolls, DateTime? startDate, DateTime? endDate, string user);
		List<Company> GetAllCompanies();
	}
}
