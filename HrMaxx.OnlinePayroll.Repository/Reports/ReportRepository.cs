﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Core.Metadata.Edm;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.InteropServices;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
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
		private string _sqlCon;

		public ReportRepository(IMapper mapper, OnlinePayrollEntities dbContext, string sqlCon)
		{
			_dbContext = dbContext;
			_mapper = mapper;
			_sqlCon = sqlCon;
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

		public DashboardData GetDashboardData(DashboardRequest dashboardRequest)
		{
			return getDashboardData(dashboardRequest.Report, dashboardRequest.Host, dashboardRequest.Role, dashboardRequest.StartDate, dashboardRequest.EndDate, dashboardRequest.Criteria);
		}


		private DashboardData getDashboardData(string query, Guid? host, string role, DateTime? startDate = null, DateTime? endDate = null, string criteria = null)
		{
			var chartData = new List<object>();
			using (var con = new SqlConnection(_sqlCon))
			{
				using (var cmd = new SqlCommand(query))
				{
					cmd.CommandType = CommandType.StoredProcedure;
					if (startDate.HasValue)
						cmd.Parameters.AddWithValue("@startdate", startDate.Value);
					if (endDate.HasValue)
						cmd.Parameters.AddWithValue("@enddate", endDate.Value);
					
					if (!string.IsNullOrWhiteSpace(criteria))
						cmd.Parameters.AddWithValue("@criteria", criteria);
					if (host.HasValue)
						cmd.Parameters.AddWithValue("@host", host);
					if (role==RoleTypeEnum.HostStaff.GetDbName() || role==RoleTypeEnum.CorpStaff.GetDbName())
						cmd.Parameters.AddWithValue("@role", role);
					

					cmd.Connection = con;
					con.Open();
					using (SqlDataReader sdr = cmd.ExecuteReader())
					{
						var columns = new List<object>();
						for (int i = 0; i < sdr.FieldCount; i++)
						{
							columns.Add(sdr.GetName(i));
						}
						chartData.Add(columns.ToArray());
						while (sdr.Read())
						{
							var row = new List<object>();
							for (int i = 0; i < sdr.FieldCount; i++)
							{
								row.Add(sdr[columns[i].ToString()]);
							}
							chartData.Add(row.ToArray());
						}
					}
					con.Close();
					return new DashboardData { Data = chartData };
				}
			}
		}
	}
}
