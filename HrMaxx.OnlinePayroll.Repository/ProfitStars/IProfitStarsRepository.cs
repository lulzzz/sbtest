using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Repository.ProfitStars
{
	public interface IProfitStarsRepository
	{
		void RefreshProfitStarsData(DateTime payDay);
		string MoveRequestsToReports();
		List<ProfitStarsPayment> GetProfitStarsData();

		void SavePaymentRequests(List<ProfitStarsPayment> paymentRequests, string requestFile);
		void UpdatePaymentRequests(ProfitStarsReportResponse reportResponse, string responseFile);
		List<ProfitStarsPayrollFund> GetProfitStarsPayrollList();
		void MarkFundingSuccessful(int fundRequestId);
	}
}
