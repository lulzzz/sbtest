using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;

namespace HrMaxx.OnlinePayroll.Contracts.Services
{
	public interface IMetaDataService
	{
		object GetCompanyMetaData();
		object GetAccountsMetaData();
		object GetEmployeeMetaData();
		object GetPayrollMetaData(CheckBookMetaDataRequest companyId);

		object GetJournalMetaData(Guid companyId);
		object GetInvoiceMetaData(Guid companyId);
		object GetUsersMetaData(Guid? host, Guid? company, Guid? employee);

		List<TaxByYear> GetCompanyTaxesForYear(int year);
		List<CaliforniaCompanyTax> SaveTaxRates(List<CaliforniaCompanyTax> rates);
		List<SearchResult> FillSearchTable();
		List<CompanySUIRate> GetPEOCompanies();
	}
}
