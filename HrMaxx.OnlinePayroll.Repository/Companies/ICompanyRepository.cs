﻿using System;
using System.Collections.Generic;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Repository.Companies
{
	public interface ICompanyRepository

	{
		List<VendorCustomer> GetVendorCustomers(Guid? companyId, bool isVendor);
		List<Account> GetCompanyAccounts(Guid companyId);
		
		VendorCustomer GetVendorCustomersById(Guid vcId);
		
		Models.Company SaveCompany(Models.Company company);
		ContractDetails SaveCompanyContract(Company savedcompany, ContractDetails contract);
		List<CompanyTaxState> SaveTaxStates(Company savedcompany, List<CompanyTaxState> states);
		CompanyDeduction SaveDeduction(CompanyDeduction deduction);
		CompanyWorkerCompensation SaveWorkerCompensation(CompanyWorkerCompensation workerCompensation);
		AccumulatedPayType SaveAccumulatedPayType(AccumulatedPayType mappedResource);
		CompanyPayCode SavePayCode(CompanyPayCode mappedResource);
		
		VendorCustomer SaveVendorCustomer(VendorCustomer mappedResource);
		
		Account SaveCompanyAccount(Account mappedResource);
		bool CompanyExists(Guid companyId, string name);
		
		Employee SaveEmployee(Employee mappedResource);
		EmployeeDeduction SaveEmployeeDeduction(EmployeeDeduction deduction);
		bool EmployeeExists(Guid id);
		void DeleteEmployeeDeduction(int deductionId);
		void UpdateLastPayrollDateCompany(Guid id, DateTime payDay);
		void UpdateLastPayrollDateAndPayRateEmployee(Guid id, decimal rate);
		CompanyTaxRate SaveCompanyTaxRate(CompanyTaxRate mappedResource);
		
		Company CopyCompany(Guid oldCompanyId, Guid companyId, Guid oldHostId, Guid newHostId, bool copyEmployees, bool copyPayrolls, DateTime? startDate, DateTime? endDate, string user);
		
		void SaveTSImportMap(Guid id, ImportMap importMap);
		List<Company> GetLocations(Guid parentId);
		void UpdateMinWage(decimal minWage, List<Employee> selectEmployees, List<Company> selectedCompanies);
		void CopyEmployees(Guid sourceCompanyId, Guid targetCompanyId, List<Guid> employeeIds, string fullName);
		void SaveWorkerCompensations(List<CompanyWorkerCompensation> rates);
	}
}
