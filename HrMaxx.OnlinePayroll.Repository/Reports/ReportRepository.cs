﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.Entity.Core.Metadata.Edm;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Xml.Serialization;
using Dapper;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Repository;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using Newtonsoft.Json;
using CompanyPayrollCube = HrMaxx.OnlinePayroll.Models.CompanyPayrollCube;
using MasterExtract = HrMaxx.OnlinePayroll.Models.MasterExtract;

namespace HrMaxx.OnlinePayroll.Repository.Reports
{
	public class ReportRepository : BaseDapperRepository, IReportRepository
	{
		private readonly OnlinePayrollEntities _dbContext;
		private readonly IMapper _mapper;
		private string _sqlCon;

		public ReportRepository(IMapper mapper, OnlinePayrollEntities dbContext, string sqlCon, DbConnection connection):base(connection)
		{
			_dbContext = dbContext;
			_mapper = mapper;
			_sqlCon = sqlCon;
		}
		
		public PayrollAccumulation GetCompanyPayrollCube(ReportRequest request)
		{
			using (var conn = GetConnection())
			{
				const string sql = "select * from CompanyPayrollCube Where CompanyId=@CompanyId and Year=@Year";
				var dbval = conn.Query<Models.JsonDataModel.CompanyPayrollCube>(sql, new { request.CompanyId, request.Year }).AsQueryable();
				if (request.Quarter > 0)
					dbval = dbval.Where(cpc => cpc.Quarter == request.Quarter);
				else if (request.Month > 0)
					dbval = dbval.Where(cpc => cpc.Month == request.Month);
				var result = dbval.ToList();
				if (result.Any())
					return _mapper.Map<Models.JsonDataModel.CompanyPayrollCube, CompanyPayrollCube>(result.First()).Accumulation;
				return null;
			}
			
		}

		public List<Models.CompanyPayrollCube> GetCompanyCubesForYear(Guid companyId, int year)
		{
			using (var conn = GetConnection())
			{
				const string sql = "select * from CompanyPayrollCube Where CompanyId=@CompanyId and Year=@Year";
				var cubes = conn.Query<Models.JsonDataModel.CompanyPayrollCube>(sql, new { companyId, year });
				return _mapper.Map<List<Models.JsonDataModel.CompanyPayrollCube>, List<Models.CompanyPayrollCube>>(cubes.ToList());
			}
			
		}

		public List<DashboardData> GetDashboardData(DashboardRequest dashboardRequest)
		{
			return getDashboardData(dashboardRequest.Report, dashboardRequest.Host, dashboardRequest.Role, dashboardRequest.StartDate, dashboardRequest.EndDate, dashboardRequest.Criteria);
		}

		public ExtractResponse GetExtractReport(ReportRequest extractReport)
		{
			using (var con = new SqlConnection(_sqlCon))
			{
				using (var cmd = new SqlCommand("GetExtractData"))
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Parameters.AddWithValue("@report", extractReport.ReportName);
					cmd.Parameters.AddWithValue("@startDate", extractReport.StartDate);
					cmd.Parameters.AddWithValue("@endDate", extractReport.EndDate);
					;
					if (extractReport.DepositSchedule != null)
					{
						cmd.Parameters.AddWithValue("@depositSchedule", (int)extractReport.DepositSchedule);	
					}
					if (extractReport.HostId != Guid.Empty)
					{
						cmd.Parameters.AddWithValue("@host", extractReport.HostId);
					}
					if (extractReport.IncludeVoids)
					{
						cmd.Parameters.AddWithValue("@includeVoids", extractReport.IncludeVoids);
					}
					
					cmd.Connection = con;
					con.Open();


					var data = string.Empty;
					using (var reader = cmd.ExecuteXmlReader())
					{
						var sb = new StringBuilder();

						while (reader.Read())
							sb.AppendLine(reader.ReadOuterXml());

						data = sb.ToString();
					}
					con.Close();
					var serializer = new XmlSerializer(typeof(ExtractResponseDB));
					var memStream = new MemoryStream(Encoding.UTF8.GetBytes(data));
					var dbReport = (ExtractResponseDB)serializer.Deserialize(memStream);

					var returnVal = _mapper.Map<ExtractResponseDB, ExtractResponse>(dbReport);
					
					dbReport.Hosts.ForEach(c =>
					{
						var contact = new List<Contact>();
						c.Contacts.ForEach(ct=>contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
						var selcontact = contact.Any(c2 => c2.IsPrimary) ? contact.First(c1 => c1.IsPrimary) : contact.FirstOrDefault();
						if (selcontact != null)
						{
							returnVal.Hosts.First(host=>host.Host.Id==c.Id).Contact = selcontact;
						}
					});
					return returnVal;

				}
			}
		}

		public ACHResponse GetACHReport(ReportRequest extractReport)
		{
			using (var con = new SqlConnection(_sqlCon))
			{
				using (var cmd = new SqlCommand("GetACHData"))
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Parameters.AddWithValue("@startDate", extractReport.StartDate);
					cmd.Parameters.AddWithValue("@endDate", extractReport.EndDate);
					
					cmd.Connection = con;
					con.Open();


					var data = string.Empty;
					using (var reader = cmd.ExecuteXmlReader())
					{
						var sb = new StringBuilder();

						while (reader.Read())
							sb.AppendLine(reader.ReadOuterXml());

						data = sb.ToString();
					}
					con.Close();
					var serializer = new XmlSerializer(typeof(ACHResponseDB));
					var memStream = new MemoryStream(Encoding.UTF8.GetBytes(data));
					var dbReport = (ACHResponseDB)serializer.Deserialize(memStream);

					var returnVal = _mapper.Map<ACHResponseDB, ACHResponse>(dbReport);

					return returnVal;

				}
			}
		}

		public void SaveACHExtract(ACHExtract extract, string fullName)
		{
			var transactions = extract.Data.Hosts.SelectMany(h => h.ACHTransactions).ToList();
			var dbExtract = new Models.DataModel.MasterExtract
			{
				DepositDate = extract.Report.DepositDate.Value,
				EndDate = extract.Report.EndDate,
				//Extract = JsonConvert.SerializeObject(extract),
				ExtractName = "ACH",
				Id = 0,
				IsFederal = false,
				Journals = JsonConvert.SerializeObject(new List<int>()),
				LastModified = DateTime.Now,
				LastModifiedBy = fullName,
				StartDate = extract.Report.StartDate,
				
			};
			_dbContext.MasterExtracts.Add(dbExtract);
			_dbContext.SaveChanges();
			SaveExtractDetails(dbExtract.Id, JsonConvert.SerializeObject(extract));
			transactions.ForEach(t => _dbContext.ACHTransactionExtracts.Add(new ACHTransactionExtract
			{
				Id = 0,
				MasterExtractId = dbExtract.Id,
				ACHTransactionId = t.Id
			}));
			_dbContext.SaveChanges();

		}

		private void SaveExtractDetails(int extractId, string extract)
		{
			using (var conn = GetConnection())
			{
				const string selectSql =
				@"SELECT MasterExtractId FROM MasterExtract WHERE MasterExtractId=@extractId";
				
				dynamic exists =
						conn.Query(selectSql, new { extractId }).FirstOrDefault();
				if (exists != null)
				{
					conn.Execute("delete from MasterExtract where MasterExtractId=@extractId", new { extractId });
				}
				const string sql =
					@"INSERT INTO dbo.MasterExtract(MasterExtractId, Extract) VALUES (@extractId, @extract)";
				conn.Execute(sql, new
				{
					extractId,
					extract
				});
				
			}
			
		}
		public List<ACHMasterExtract> GetACHExtractList()
		{
			var list = 
				_dbContext.MasterExtracts.Where(r => r.ExtractName.Equals("ACH"))
					.ToList();

			return _mapper.Map<List<Models.DataModel.MasterExtract>, List<Models.ACHMasterExtract>>(list);
		}

		public Models.MasterExtract SaveCommissionExtract(CommissionsExtract extract, string fullName)
		{
			var invoices = extract.Data.SalesReps.SelectMany(h => h.Commissions).ToList();
			var dbExtract = new Models.DataModel.MasterExtract
			{
				DepositDate = DateTime.Today,
				EndDate = extract.Report.EndDate.HasValue ? extract.Report.EndDate.Value : DateTime.Today,
				//Extract = JsonConvert.SerializeObject(extract),
				ExtractName = "Commissions",
				Id = 0,
				IsFederal = false,
				Journals = JsonConvert.SerializeObject(new List<int>()),
				LastModified = DateTime.Now,
				LastModifiedBy = fullName,
				StartDate = extract.Report.StartDate.HasValue ? extract.Report.StartDate.Value : new DateTime(2017,1,1).Date,

			};
			_dbContext.MasterExtracts.Add(dbExtract);
			_dbContext.SaveChanges();
			SaveExtractDetails(dbExtract.Id, JsonConvert.SerializeObject(extract));
			invoices.ForEach(t => _dbContext.CommissionExtracts.Add(new CommissionExtract
			{
				Id = 0,
				MasterExtractId = dbExtract.Id,
				PayrollInvoiceId = t.InvoiceId
			}));
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.MasterExtract, Models.MasterExtract>(dbExtract);
		}

		public List<MasterExtract> GetExtractList(string report)
		{
			var extracts = _dbContext.MasterExtracts.Where(e => e.ExtractName.Equals(report)).ToList();
			var returnList = _mapper.Map<List<Models.DataModel.MasterExtract>, List<Models.MasterExtract>>(extracts);
			returnList.ForEach(me => me.Extract.Data.Hosts.ForEach(h =>
			{
				h.Accumulation.ExtractType = me.Extract.Report.ExtractType;
				h.Companies.ForEach(c=>c.Accumulation.ExtractType=me.Extract.Report.ExtractType);
			}));
			return returnList;
		}

		public SearchResults GetSearchResults(string criteria, string role, Guid host, Guid company)
		{
			using (var con = new SqlConnection(_sqlCon))
			{
				using (var cmd = new SqlCommand("GetSearchResults"))
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Parameters.AddWithValue("@criteria", criteria.Replace("-", string.Empty));
					if(!role.Equals(RoleTypeEnum.Master.GetDbName()))
						cmd.Parameters.AddWithValue("@role", role);
					if(host!=Guid.Empty)
						cmd.Parameters.AddWithValue("@host", host);
					if (company != Guid.Empty)
						cmd.Parameters.AddWithValue("@company", company);
					
					cmd.Connection = con;
					con.Open();


					var data = string.Empty;
					using (var reader = cmd.ExecuteXmlReader())
					{
						var sb = new StringBuilder();

						while (reader.Read())
							sb.AppendLine(reader.ReadOuterXml());

						data = sb.ToString();
					}
					con.Close();
					var serializer = new XmlSerializer(typeof(SearchResults));
					var memStream = new MemoryStream(Encoding.UTF8.GetBytes(data));
					return (SearchResults)serializer.Deserialize(memStream);


				}
			}
		}


		private List<DashboardData> getDashboardData(string query, Guid? host, string role, DateTime? startDate = null, DateTime? endDate = null, string criteria = null)
		{
			
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
					var returnList = new List<DashboardData>();
					using (SqlDataReader sdr = cmd.ExecuteReader())
					{
						while (sdr.HasRows)
						{
							var resultset = sdr.GetName(0);
							if (!string.IsNullOrWhiteSpace(resultset) && resultset.Equals("Report"))
							{
								sdr.Read();
								var dashboardData = new DashboardData() { Result = sdr[resultset].ToString() };
								sdr.NextResult();
								var chartData = new List<object>();
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
								dashboardData.Data = chartData;
								returnList.Add(dashboardData);
							}
							sdr.NextResult();
							
						}
						
					}
					con.Close();
					return returnList;
				}
			}
		}
	}
}
