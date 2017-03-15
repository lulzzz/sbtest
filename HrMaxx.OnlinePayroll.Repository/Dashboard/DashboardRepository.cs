using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Transactions;
using Dapper;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Repository;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Repository.Dashboard;
using Newtonsoft.Json;
using CompanyPayrollCube = HrMaxx.OnlinePayroll.Models.CompanyPayrollCube;
using Journal = HrMaxx.OnlinePayroll.Models.DataModel.Journal;

namespace HrMaxx.OnlinePayroll.Repository.Dashboard
{
	public class DashboardRepository : BaseDapperRepository, IDashboardRepository
	{
		private readonly IMapper _mapper;

		public DashboardRepository(IMapper mapper, DbConnection connection)
			: base(connection)
		{
			
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
			var m = _mapper.Map<Models.CompanyPayrollCube, Models.JsonDataModel.CompanyPayrollCube>(cube);
			const string sql =
				@"SELECT * FROM CompanyPayrollCube WHERE CompanyId = @CompanyId AND Year = @Year";
			OpenConnection();
			var dbCubes =
					Connection.Query<Models.JsonDataModel.CompanyPayrollCube>(sql, new { CompanyId = cube.CompanyId, Year = cube.Year }).AsQueryable<Models.JsonDataModel.CompanyPayrollCube>();

			Models.JsonDataModel.CompanyPayrollCube dbCube;
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
					const string insertSql =
				@"INSERT INTO CompanyPayrollCube(CompanyId, Year, Quarter, Month, Accumulation) VALUES (@CompanyId, @Year, @Quarter, @Month, @Accumulation)";
					Connection.Execute(insertSql, new
					{
						m.CompanyId,
						m.Year,
						m.Quarter,
						m.Month,
						m.Accumulation
					});
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
				const string updateSql =
				@"update CompanyPayrollCube set Accumulation=@Accumulation Where Id=@Id";
				Connection.ExecuteScalar(updateSql, new {Accumulation = JsonConvert.SerializeObject(dbc), Id = dbCube.Id});
				
			}
			Connection.Close();
			
		}

		public void DeleteCubesForCompanyAndYear(Guid companyId, int year)
		{
			const string sql = @"DELETE FROM CompanyPayrollCube WHERE CompanyId = @CompanyId and Year=@Year";
			OpenConnection();
			Connection.Execute(sql, new { CompanyId = companyId, Year = year });
			Connection.Close();
		}
	}
}
