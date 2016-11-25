using System;
using System.Collections;
using System.Collections.Generic;
using HrMaxx.Common.Models;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;

namespace HrMaxx.OnlinePayroll.Repository
{
	public interface IMetaDataRepository
	{
		IList<TaxByYear> GetCompanyOverridableTaxes();
		IList<DeductionType> GetDeductionTypes();
		IList<PayType> GetAccumulablePayTypes();
		IList<PayType> GetAllPayTypes();
		IList<TaxByYear> GetAllTaxes();
		Account GetPayrollAccount(Guid companyId);
		int GetMaxCheckNumber(Guid companyId);
		int GetMaxAdjustmenetNumber(Guid companyId);
		List<Models.Payroll> GetUnInvoicedPayrolls(Guid companyId);
		string GetMaxInvoiceNumber(Guid companyId);
		object GetMetaDataForUser(Guid? host, Guid? company, Guid? employee);
		ApplicationConfig GetConfigurations();
		void SaveApplicationConfig(ApplicationConfig config);
		int PullReportConstat(string form940, int quarterly);

		List<CaliforniaCompanyTax> SaveTaxRates(List<CaliforniaCompanyTax> rates);
		List<SearchResult> FillSearchResults(List<SearchResult> searchResults);
		void UpdateSearchTable(SearchResult searchResult);
		ImportMap GetCompanyTsImportMap(Guid companyId);
	}
}
