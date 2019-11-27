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
		DocumentServiceMetaData GetDocumentServiceMetaData(Guid companyId);
		EmployeeDocumentMetaData GetEmployeeDocumentServiceMetaData(Guid companyId, Guid employeeId);
		object GetAccountsMetaData();
		object GetEmployeeMetaData();
		object GetPayrollMetaData(CheckBookMetaDataRequest companyId);

		object GetJournalMetaData(Guid companyId, int companyIntId);
		object GetInvoiceMetaData(Guid companyId);
		object GetUsersMetaData(Guid? host, Guid? company, Guid? employee);

		IList<DeductionType> GetDeductionTypes();

		List<TaxByYear> GetCompanyTaxesForYear(int year);
		List<CaliforniaCompanyTax> SaveTaxRates(List<CaliforniaCompanyTax> rates);
		List<SearchResult> FillSearchTable();
		List<CompanySUIRate> GetPEOCompanies();
		List<Access> GetAccessMetaData();
		DeductionType SaveDeductionType(DeductionType dt);
		List<KeyValuePair<int, DateTime>> GetBankHolidays();
		object SaveBankHoliday(DateTime holiday, bool action);
		CompanyDocumentSubType SaveDocumentSubType(CompanyDocumentSubType subType);
		void SetEmployeeAccess(Guid employeeId, Guid documentId);
        IList<PayType> GetAllPayTypes();
        PayType SavePayType(PayType payType);
    }
}
