using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Contracts.Services
{
	public interface IACHService
	{
		void FillACH();
		List<ProfitStarsPayment> ProfitStarsPayments();
		ProfitStarsReportResponse ProfitStarsStatusUpdate();

		List<ProfitStarsPayrollFund> GetProfitStarsPayrollList();
		List<ProfitStarsPayrollFund> MarkFundingSuccessful(int fundRequestId);
		DateTime GetProfitStarsPaymentDate(DateTime today);
		DateTime GetProfitStarsMinRunDate(DateTime today);

	}
}
