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
	}
}
