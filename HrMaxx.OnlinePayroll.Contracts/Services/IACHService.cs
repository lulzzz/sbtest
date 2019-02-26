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

		List<ProfitStarsPayroll> GetProfitStarsPayrollList();
	}
}
