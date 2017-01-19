using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Contracts.Services
{
	public interface IReaderService
	{
		T GetDataFromStoredProc<T>(string proc, List<FilterParam> paramList);
		T GetDataFromStoredProc<T, T1>(string proc, List<FilterParam> paramList);
		T GetDataFromJsonStoredProc<T, T1>(string proc, List<FilterParam> paramList);
		List<PayrollInvoice> GetPayrollInvoices(Guid host);
		List<PayrollInvoice> GetPayrollInvoicesXml(Guid host);
	}
}
