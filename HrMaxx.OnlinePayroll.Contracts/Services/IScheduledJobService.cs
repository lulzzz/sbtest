using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Contracts.Services
{
	public interface IScheduledJobService
	{
		void UpdateInvoicePayments();
		void FillACHData();
		void UpdateDBStats();
		void ProfitStarsNineAM();
		void ProfitStarsOnePM();
	}
}
