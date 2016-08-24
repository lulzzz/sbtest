using System;
using HrMaxx.Infrastructure.Services;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Repository.Dashboard;

namespace HrMaxx.OnlinePayroll.Services.Dashboard
{
	public class DashboardService : BaseService, IDashboardService
	{
		private readonly IDashboardRepository _dashboardRepository;
		
		public DashboardService(IDashboardRepository dashboardRepository)
		{
			_dashboardRepository = dashboardRepository;
		}


		public void AddPayrollToCubes(Models.Payroll payroll)
		{
			try
			{
				var accumulation = new PayrollAccumulation();
				accumulation.AddPayroll(payroll);
				var yearlyCube = new CompanyPayrollCube
				{
					CompanyId = payroll.Company.Id,
					Year = payroll.PayDay.Year,
					Accumulation = accumulation
				};
				var quarterlyCube = new CompanyPayrollCube
				{
					CompanyId = payroll.Company.Id,
					Year = payroll.PayDay.Year,
					Quarter = GetQuarterFromPayDay(payroll.PayDay),
					Accumulation = accumulation
				};
				var monthlyCube = new CompanyPayrollCube
				{
					CompanyId = payroll.Company.Id,
					Year = payroll.PayDay.Year,
					Month = payroll.PayDay.Month,
					Accumulation = accumulation
				};
				using (var txn = TransactionScopeHelper.Transaction())
				{
					_dashboardRepository.UpdateCube(yearlyCube, CubeType.Yearly, true);
					_dashboardRepository.UpdateCube(quarterlyCube, CubeType.Quarterly, true);
					_dashboardRepository.UpdateCube(monthlyCube, CubeType.Monthly, true);
					txn.Complete();
					
				}
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Add to Payroll Cubes. Payroll Id="+payroll.Id);
				Log.Error(message, e);
				
			}
		}

		public void RemovePayCheckFromCubes(PayCheck payroll)
		{
			try
			{
				var accumulation = new PayrollAccumulation();
				accumulation.AddPayCheck(payroll);
				var yearlyCube = new CompanyPayrollCube
				{
					CompanyId = payroll.Employee.CompanyId,
					Year = payroll.PayDay.Year,
					Accumulation = accumulation
				};
				var quarterlyCube = new CompanyPayrollCube
				{
					CompanyId = payroll.Employee.CompanyId,
					Year = payroll.PayDay.Year,
					Quarter = GetQuarterFromPayDay(payroll.PayDay),
					Accumulation = accumulation
				};
				var monthlyCube = new CompanyPayrollCube
				{
					CompanyId = payroll.Employee.CompanyId,
					Year = payroll.PayDay.Year,
					Month = payroll.PayDay.Month,
					Accumulation = accumulation
				};
				using (var txn = TransactionScopeHelper.Transaction())
				{
					_dashboardRepository.UpdateCube(yearlyCube, CubeType.Yearly, false);
					_dashboardRepository.UpdateCube(quarterlyCube, CubeType.Quarterly, false);
					_dashboardRepository.UpdateCube(monthlyCube, CubeType.Monthly, false);
					txn.Complete();
				}
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Remove from Payroll Cubes. Pay check Id=" + payroll.Id);
				Log.Error(message, e);
			}
		}

		private int GetQuarterFromPayDay(DateTime payDay)
		{
			var month = payDay.Month;
			if (month < 4)
				return 1;
			else if (month < 7)
				return 2;
			else if (month < 10)
				return 3;
			else
			{
				return 4;
			}

		}
	}
}
