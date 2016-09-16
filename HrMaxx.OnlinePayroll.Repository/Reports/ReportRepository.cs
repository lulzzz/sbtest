using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Metadata.Edm;
using System.Linq;
using System.Runtime.InteropServices;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using Newtonsoft.Json;
using CompanyPayrollCube = HrMaxx.OnlinePayroll.Models.CompanyPayrollCube;

namespace HrMaxx.OnlinePayroll.Repository.Reports
{
	public class ReportRepository : IReportRepository
	{
		private readonly OnlinePayrollEntities _dbContext;
		private readonly IMapper _mapper;

		public ReportRepository(IMapper mapper, OnlinePayrollEntities dbContext)
		{
			_dbContext = dbContext;
			_mapper = mapper;
			
		}

		private IQueryable<PayrollPayCheck> GetPayChecksQueryable(ReportRequest request, bool includeVoids)
		{
			var paychecks = _dbContext.PayrollPayChecks.Where(pc => pc.PayDay >= request.StartDate && pc.PayDay <= request.EndDate).AsQueryable();
			if (request.CompanyId != Guid.Empty)
				paychecks = paychecks.Where(pc => pc.CompanyId == request.CompanyId);

			if (!includeVoids)
				paychecks = paychecks.Where(pc => !pc.IsVoid);
			return paychecks;
		} 

		public List<PayCheck> GetReportPayChecks(ReportRequest request, bool includeVoids)
		{
			var paychecks = GetPayChecksQueryable(request, includeVoids);
			return _mapper.Map<List<PayrollPayCheck>, List<PayCheck>>(paychecks.ToList());
		}

		public List<EmployeeAccumulation> GetEmployeeGroupedChecks(ReportRequest request, bool includeVoids)
		{
			var paychecks = GetPayChecksQueryable(request, includeVoids);
			var paychecks1 = paychecks.GroupBy(p => p.EmployeeId).ToList();
			var result = new List<EmployeeAccumulation>();
			foreach (var group in paychecks1)
			{
				var ea = TransformPayChecksToAccumulation(group.ToList());
				var emp = _dbContext.Employees.First(e => e.Id == group.Key);
				ea.Employee = _mapper.Map<Models.DataModel.Employee, Models.Employee>(emp);
				result.Add(ea);
			}

			return result;
		}

		private EmployeeAccumulation TransformPayChecksToAccumulation(List<PayrollPayCheck> payChecks)
		{
			var ea = new EmployeeAccumulation
			{
				PayChecks = _mapper.Map<List<PayrollPayCheck>, List<Models.PayCheck>>(payChecks),
				Accumulation = new PayrollAccumulation()
			};
			ea.Accumulation.AddPayChecks(ea.PayChecks);
			return ea;
		}

		public PayrollAccumulation GetCompanyPayrollCube(ReportRequest request)
		{
			var dbval =
				_dbContext.CompanyPayrollCubes.Where(cpc => cpc.CompanyId == request.CompanyId && cpc.Year == request.Year)
					.AsQueryable();
			if (request.Quarter > 0)
				dbval = dbval.Where(cpc => cpc.Quarter == request.Quarter);
			else if (request.Month > 0)
				dbval = dbval.Where(cpc => cpc.Month == request.Month);
			var result = dbval.ToList();
			if(result.Any())
				return _mapper.Map<Models.DataModel.CompanyPayrollCube, CompanyPayrollCube>(result.First()).Accumulation;
			return null;
		}

		public List<Models.CompanyPayrollCube> GetCompanyCubesForYear(Guid companyId, int year)
		{
			var cubes = _dbContext.CompanyPayrollCubes.Where(c => c.CompanyId == companyId && c.Year == year).ToList();
			return _mapper.Map<List<Models.DataModel.CompanyPayrollCube>, List<Models.CompanyPayrollCube>>(cubes);
		}
	}
}
