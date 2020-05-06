using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using Newtonsoft.Json;
using MasterExtract = HrMaxx.OnlinePayroll.Models.MasterExtract;

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
		
		public List<DashboardData> GetDashboardData(DashboardRequest dashboardRequest)
		{
			return getDashboardData(dashboardRequest.Report, dashboardRequest.Host, dashboardRequest.Role, dashboardRequest.StartDate, dashboardRequest.EndDate, dashboardRequest.Criteria, dashboardRequest.OnlyActive);
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
					cmd.Parameters.AddWithValue("@isReverse", extractReport.IsReverse);
					cmd.Parameters.AddWithValue("@masterExtractId", extractReport.MasterExtractId);
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
					cmd.Parameters.AddWithValue("@isReverse", extractReport.IsReverse);
					cmd.Parameters.AddWithValue("@masterExtractId", extractReport.MasterExtractId);
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

		public Models.MasterExtract SaveACHExtract(ACHExtract extract, string fullName)
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
			//SaveExtractDetails(dbExtract.Id, JsonConvert.SerializeObject(extract));
			transactions.ForEach(t => _dbContext.ACHTransactionExtracts.Add(new ACHTransactionExtract
			{
				Id = 0,
				MasterExtractId = dbExtract.Id,
				ACHTransactionId = t.Id
			}));
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.MasterExtract, Models.MasterExtract>(dbExtract);

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
			//SaveExtractDetails(dbExtract.Id, JsonConvert.SerializeObject(extract));
			invoices.ForEach(t => _dbContext.CommissionExtracts.Add(new CommissionExtract
			{
				Id = 0,
				MasterExtractId = dbExtract.Id,
				PayrollInvoiceId = t.InvoiceId
			}));
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.MasterExtract, Models.MasterExtract>(dbExtract);
		}

		public void ConfirmExtract(MasterExtract extract)
		{
			var ext = _dbContext.MasterExtracts.First(e => e.Id == extract.Id);
			ext.ConfirmationNo = extract.ConfirmationNo;
			ext.ConfirmationNoTS = extract.ConfirmationNoTS;
			ext.ConfirmationNoUser = extract.ConfirmationNoUser;
			_dbContext.SaveChanges();
		}


		
		public SearchResults GetSearchResults(string criteria, string role, Guid host, Guid company)
		{
			using (var con = new SqlConnection(_sqlCon))
			{
				using (var cmd = new SqlCommand("GetSearchResults"))
				{
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Parameters.AddWithValue("@criteria", criteria.Replace("-", string.Empty));
					if (!role.Equals(RoleTypeEnum.Master.GetDbName()) && !role.Equals(RoleTypeEnum.SuperUser.GetDbName()))
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


		private List<DashboardData> getDashboardData(string query, Guid? host, string role, DateTime? startDate = null, DateTime? endDate = null, string criteria = null, bool onlyActive=true)
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

					cmd.Parameters.AddWithValue("@onlyActive", onlyActive);
					

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
