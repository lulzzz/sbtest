using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Repository.Dashboard;
using Newtonsoft.Json;
using CompanyPayrollCube = HrMaxx.OnlinePayroll.Models.CompanyPayrollCube;
using Journal = HrMaxx.OnlinePayroll.Models.DataModel.Journal;

namespace HrMaxx.OnlinePayroll.Repository.Dashboard
{
	public class DashboardRepository : IDashboardRepository
	{
		private readonly OnlinePayrollEntities _dbContext;
		private readonly IMapper _mapper;

		public DashboardRepository(IMapper mapper, OnlinePayrollEntities dbContext)
		{
			_dbContext = dbContext;
			_mapper = mapper;
		}


		public void AddToPayrollCubes(Guid id, DateTime payDay, PayrollAccumulation accumulation)
		{
			
		}

		public void RemoveFromPayrollCubes(Guid companyId, DateTime payDay, PayrollAccumulation accumulation)
		{
			

		}

		public void UpdateCube(CompanyPayrollCube cube, CubeType cubeType, bool isAdd)
		{
			var dbCubes = _dbContext.CompanyPayrollCubes.Where(cpc => cpc.CompanyId == cube.CompanyId
			                                                          && cpc.Year == cube.Year

				).AsQueryable();
			Models.DataModel.CompanyPayrollCube dbCube;
			if (cubeType == CubeType.Yearly)
			{
				dbCube = dbCubes.FirstOrDefault(cpc=>!cpc.Quarter.HasValue && !cpc.Month.HasValue);
			}
			else if (cubeType == CubeType.Quarterly)
			{
				dbCube = dbCubes.FirstOrDefault(cpc => cpc.Quarter == cube.Quarter);
			}
			else
			{
				dbCube = dbCubes.FirstOrDefault(cpc => cpc.Month == cube.Month);
			}
			if (dbCube == null)
			{
				if (isAdd)
				{
					var m = _mapper.Map<Models.CompanyPayrollCube, Models.DataModel.CompanyPayrollCube>(cube);
					_dbContext.CompanyPayrollCubes.Add(m);
				}
				
			}
			else
			{
				var dbc = JsonConvert.DeserializeObject<PayrollAccumulation>(dbCube.Accumulation);
				if(isAdd)
					dbc.Add(cube.Accumulation);
				else
				{
					dbc.Remove(cube.Accumulation);
				}
				dbCube.Accumulation = JsonConvert.SerializeObject(dbc);
			}
			_dbContext.SaveChanges();
		}
	}
}
