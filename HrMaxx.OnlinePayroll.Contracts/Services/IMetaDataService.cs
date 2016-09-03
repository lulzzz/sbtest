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
	public interface IMetaDataService
	{
		object GetCompanyMetaData();
		object GetAccountsMetaData();
		object GetEmployeeMetaData();
		object GetPayrollMetaData(Guid companyId);

		object GetJournalMetaData(Guid companyId);
		object GetInvoiceMetaData(Guid companyId);
	}
}
