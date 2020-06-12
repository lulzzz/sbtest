using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
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


		Company Save(Company mappedResource, bool updateEmployeeSchedules = false, bool ignoreEinCheck = false);
		Company SaveHostCompany(Company company, Host savedHost);
		CompanyDeduction SaveDeduction(CompanyDeduction deduction, string fullName, Guid userId);
		CompanyWorkerCompensation SaveWorkerCompensation(CompanyWorkerCompensation workerCompensation, string fullName, Guid guid);
		AccumulatedPayType SaveAccumulatedPayType(AccumulatedPayType mappedResource, string fullName, Guid guid);
		CompanyPayCode SavePayCode(CompanyPayCode mappedResource, string fullName, Guid guid);
		List<VendorCustomer> GetVendorCustomers(Guid? companyId, bool isVendor);
		VendorCustomer SaveVendorCustomers(VendorCustomer mappedResource);
		
		Account SaveCompanyAccount(Account mappedResource);

		Employee SaveEmployee(Employee mappedResource, bool sendNotification = true, bool ignoreSSNCheck = false);
		EmployeeDeduction SaveEmployeeDeduction(EmployeeDeduction mappedResource, string fullName);
		EmployeeACA SaveEmployeeACA(EmployeeACA aca);
		void DeleteEmployeeDeduction(int deductionId);
		
		CompanyTaxRate SaveCompanyTaxYearRate(CompanyTaxRate mappedResource, string fullName, Guid guid);

		List<Employee> SaveEmployees(List<Employee> employees, bool ignoreSSNCheck = false);

		
		void SaveTSImportMap(Guid id, ImportMap importMap, int type = 1);
		Company SaveLocation(CompanyLocation mappedResource, string fullName, Guid guid);
		void RaiseMinWage(MinWageEligibilityCriteria minWage, string user, Guid userId);
		void CopyEmployees(Guid sourceCompanyId, Guid targetCompanyId, List<Guid> employeeIds, string fullName, bool keepEmployeeNumbers);
		void UpdateWCRates(List<CompanyWorkerCompensation> rates, string fullName, Guid guid, int wcImportOption);
		List<EmployeeSSNCheck> CheckSSN(string ssn);
		void BulkTerminateEmployees(Guid companyId, List<Guid> employees, string userId, string name);

		Account GetComanyAccountById(Guid companyId, int accountId);
		CompanyRenewal SaveRenewal(CompanyRenewal renewal, string username, Guid userid);
        void SaveRenewalDate(Guid companyId, int renewalId, string fullName);
        CompanyProject SaveProject(CompanyProject resource, Guid userId);
        List<TimesheetEntry> GetEmployeeTimesheet(Guid companyId, Guid? employeeId, int month, int year);
        TimesheetEntry SaveTimesheetEntry(TimesheetEntry resource);
        TimesheetEntry DeleteEmployeeTimesheet(int id);
		List<TimesheetEntry> SaveTimesheetEntries(List<TimesheetEntry> resources);
    }
}
