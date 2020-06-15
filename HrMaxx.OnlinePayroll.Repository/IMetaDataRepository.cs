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
		int GetMaxCheckNumber(int companyId, bool b);
		int GetMaxAdjustmenetNumber(int companyId);
		List<Models.Payroll> GetUnInvoicedPayrolls(Guid companyId);
		string GetMaxInvoiceNumber(Guid companyId);
		object GetMetaDataForUser(Guid? host, Guid? company, Guid? employee);
		ApplicationConfig GetConfigurations();
		void SaveApplicationConfig(ApplicationConfig config);
		int PullReportConstat(string form940, int quarterly);

		List<CaliforniaCompanyTax> SaveTaxRates(List<CaliforniaCompanyTax> rates);
		List<SearchResult> FillSearchResults(List<SearchResult> searchResults);
		void UpdateSearchTable(SearchResult searchResult);
		ImportMap GetCompanyTsImportMap(Guid companyId, int type=1);
		List<VendorCustomer> GetGarnishmentAgencies();
		int GetMaxRegularCheckNumber(int companyId);
		int GetMaxCheckNumberWithoutPayroll(int companyIntId, Guid id);
		DeductionType SaveDeductionType(DeductionType dt);
		List<KeyValuePair<int, DateTime>> GetBankHolidays();
		KeyValuePair<int, DateTime> SaveBankHoliday(DateTime holiday, bool action);
		
		CompanyDocumentSubType SaveDocumentSubType(CompanyDocumentSubType dt);
		void SetEmployeeDocumentAccess(Guid employeeId, Guid documentId);
        PayType SavePayType(PayType payType);
        List<PreTaxDeduction> GetDeductionTaxPrecendence();
		void SaveDeductionPrecedence(List<PreTaxDeduction> precedence);
        int GetMaxVendorInvoiceNumber(Guid companyIntId);
    }
}
