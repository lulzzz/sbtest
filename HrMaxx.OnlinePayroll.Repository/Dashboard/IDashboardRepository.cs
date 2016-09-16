using System;
using System.Collections.Generic;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Repository.Dashboard
{
	public interface IDashboardRepository
	{
		void AddToPayrollCubes(Guid id, DateTime payDay, PayrollAccumulation accumulation);
		void RemoveFromPayrollCubes(Guid companyId, DateTime payDay, PayrollAccumulation accumulation);
		void UpdateCube(CompanyPayrollCube cube, CubeType cubeType, bool isAdd);
		void DeleteCubesForCompanyAndYear(Guid companyId, int year);
	}
}
