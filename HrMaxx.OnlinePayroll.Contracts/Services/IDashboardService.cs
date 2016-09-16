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
	public interface IDashboardService
	{
		void AddPayrollToCubes(Payroll payroll);
		void RemovePayCheckFromCubes(PayCheck payCheck);
		List<Payroll> FixCompanyCubes(List<Payroll> payrolls, Guid companyId, int year);
	}
}
