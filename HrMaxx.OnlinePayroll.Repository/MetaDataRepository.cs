using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Transactions;
using Dapper;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Repository;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;
using Newtonsoft.Json;
using DeductionType = HrMaxx.OnlinePayroll.Models.DeductionType;
using PayType = HrMaxx.OnlinePayroll.Models.PayType;
using Tax = HrMaxx.OnlinePayroll.Models.Tax;
using VendorCustomer = HrMaxx.OnlinePayroll.Models.VendorCustomer;

namespace HrMaxx.OnlinePayroll.Repository
{
	public class MetaDataRepository : BaseDapperRepository, IMetaDataRepository
	{
		private readonly OnlinePayrollEntities _dbContext;
		private readonly IMapper _mapper;
		
		public MetaDataRepository(IMapper mapper, OnlinePayrollEntities dbContext, DbConnection connection):base(connection)
		{
			_dbContext = dbContext;
			_mapper = mapper;
		}

		public IList<TaxByYear> GetCompanyOverridableTaxes()
		{
			const string sql =
				"select TaxYearRate.* from TaxYearRate, Tax where TaxYearRate.TaxId=Tax.Id and Tax.IsCompanySpecific=1";
			const string sql2 = "select * from Tax where Id=@Id";
			using (var conn = GetConnection())
			{
				var taxes = conn.Query<TaxYearRate>(sql).ToList();
				taxes.ForEach(t =>
				{
					t.Tax = conn.Query<Models.DataModel.Tax>(sql2, new {Id = t.TaxId}).FirstOrDefault();
				});
				return _mapper.Map<List<TaxYearRate>, List<TaxByYear>>(taxes);
			}
			
			
		}

		public IList<DeductionType> GetDeductionTypes()
		{
			const string sql = "select * from DeductionType";
			using (var conn = GetConnection())
			{
				var types = conn.Query<Models.DataModel.DeductionType>(sql).ToList();
				return _mapper.Map<List<Models.DataModel.DeductionType>, List<DeductionType>>(types);
			}
			
		}

		public IList<PayType> GetAccumulablePayTypes()
		{
			const string sql = "select * from PayType where IsAccumulable=1";
			using (var conn = GetConnection())
			{
				var paytypes = conn.Query<Models.DataModel.PayType>(sql).ToList();
				return _mapper.Map<List<Models.DataModel.PayType>, List<PayType>>(paytypes);
			}
		}

		public IList<PayType> GetAllPayTypes()
		{
			const string sql = "select * from PayType";
			using (var conn = GetConnection())
			{
				var paytypes = conn.Query<Models.DataModel.PayType>(sql).ToList();
				return _mapper.Map<List<Models.DataModel.PayType>, List<PayType>>(paytypes);
			}
			
		}

		public IList<TaxByYear> GetAllTaxes()
		{
			var taxes = _dbContext.TaxYearRates.ToList();
			return _mapper.Map<List<TaxYearRate>, List<TaxByYear>>(taxes);
		}

		public Account GetPayrollAccount(Guid companyId)
		{
			const string sql = "select * from CompanyAccount where CompanyId=@CompanyId and Type=@Type and SubType=@SubType and UsedInPayroll=1";
			const string sql2 = "select * from BankAccount where Id=@Id";
			using (var conn = GetConnection())
			{
				var account =
					conn.Query<Models.DataModel.CompanyAccount>(sql,
						new {CompanyId = companyId, Type = (int) AccountType.Assets, SubType = (int) AccountSubType.Bank})
						.FirstOrDefault();
				if (account != null && account.BankAccountId != null)
				{
					account.BankAccount =
					conn.Query<Models.DataModel.BankAccount>(sql2, new { Id = account.BankAccountId }).FirstOrDefault();
				}
				
				return _mapper.Map<CompanyAccount, Account>(account);
			}
			//var account =
			//	_dbContext.CompanyAccounts.FirstOrDefault(
			//		c =>
			//			c.CompanyId == companyId && c.Type == (int) AccountType.Assets && c.SubType == (int) AccountSubType.Bank &&
			//			c.UsedInPayroll);
			//return _mapper.Map<CompanyAccount, Account>(account);
		}

		public int GetMaxCheckNumber(int companyId, bool isPeo)
		{
			//const string sql = "select max(CheckNumber) as maxnumber from dbo.CompanyJournal where (( @IsPEO=0 and PEOASOCOCHECK=0 and CompanyIntId=@CompanyId and TransactionType=@TransactionType) or (@IsPEO=1 and PEOASOCoCheck=1))";
			string peosql = "select isnull(max(CheckNumber),0) as maxnumber from dbo.CompanyJournal where PEOASOCOCHECK=1";
			string nonpeosql = "select isnull(max(CheckNumber),0) as maxnumber from dbo.CompanyPayCheckNumber where CompanyIntId=" +companyId + ";";
			

			using (var con = new SqlConnection(_dbContext.Database.Connection.ConnectionString))
			{
				using (var cmd = new SqlCommand(isPeo?peosql:nonpeosql))
				{
					cmd.Connection = con;
					con.Open();
					var result = (int)cmd.ExecuteScalar();
					
						var max = result + 1;
						if (isPeo && max < 100001)
						{
							max = 100001 + max;
						}
						else
						{
							if (max < 1001)
								max = 1001;
						}

						return max;
					
				}
			}
			//using (var conn = GetConnection())
			//{
			//	dynamic result =
			//		conn.Query(sql, new { CompanyId = companyId, TransactionType=(int)TransactionType.PayCheck, IsPEO = isPeo }).FirstOrDefault();

			//	if (result!=null && result.maxnumber != null)
			//	{

			//		var max = result.maxnumber + 1;
			//		if (isPeo && max < 100001)
			//		{
			//			max = 100001 + max;
			//		}
			//		else
			//		{
			//			if (max < 1001)
			//				max = 1001;
			//		}

			//		return max;
			//	}
			//	else
			//	{
			//		if (isPeo)
			//		{
			//			return 100001;
			//		}
			//		else
			//			return 1001;
			//	}
			//}
			
			//var journals = _dbContext.Journals.Where(p => p.CompanyId == companyId && !p.IsVoid && p.TransactionType==(int)TransactionType.PayCheck).Select(j=>j.CheckNumber).ToList();
			//if (journals.Any())
			//{
			//	var max = journals.Max(p => p) + 1;

			//	if ((companyId == new Guid("DB5D88AE-0DF5-4561-A543-A6E200DC8092") || companyId == new Guid("50423097-59B6-425B-9964-A6E200DCAAAC") || companyId == new Guid("C0548C98-E69A-4D47-9302-A6E200DDBA73")) && max < 100001)
			//	{
			//		max = 100001 + max;
			//	}
			//	else
			//	{
			//		if (max < 1001)
			//			max = 1001;
			//	}

			//	return max;
			//}
			//else
			//{
			//	if (companyId == new Guid("DB5D88AE-0DF5-4561-A543-A6E200DC8092") || companyId == new Guid("50423097-59B6-425B-9964-A6E200DCAAAC") || companyId == new Guid("C0548C98-E69A-4D47-9302-A6E200DDBA73"))
			//	{
			//		return 100001;
			//	}
			//	else
			//		return 1001;
			//}
			
		}

		public int GetMaxAdjustmenetNumber(int companyId)
		{
			const string sql = "select max(CheckNumber) as maxnumber from dbo.CompanyJournalCheckbook where CompanyIntId=@CompanyId and TransactionType=@TransactionType";
			using (var conn = GetConnection())
			{
				dynamic result =
					conn.Query(sql, new { CompanyId = companyId, TransactionType = (int)TransactionType.Adjustment }).FirstOrDefault();

				if (result!=null && result.maxnumber != null)
				{
					return result.maxnumber + 1;
				}
				else
				{
					return 1;
				}
			}
			
		}

		public List<Models.Payroll> GetUnInvoicedPayrolls(Guid companyId)
		{
			var payrolls = _dbContext.Payrolls.Where(p => p.CompanyId == companyId && !p.InvoiceId.HasValue && p.Status==3);
			return _mapper.Map<List<Models.DataModel.Payroll>, List<Models.Payroll>>(payrolls.ToList());
		}

		public string GetMaxInvoiceNumber(Guid companyId)
		{
			var maxInvoiceNumber = string.Empty;
			var invoices =
				_dbContext.PayrollInvoices.Where(i => i.CompanyId == companyId).OrderByDescending(i => i.InvoiceDate).ToList();
			if (invoices.Any())
				return invoices.First().InvoiceNumber.ToString();
			else
			{
				return "1111".PadLeft(8, '0');
			}
		}

		public object GetMetaDataForUser(Guid? host, Guid? company, Guid? employee)
		{
			var hosts = _dbContext.Hosts.Where(h => (host.HasValue && h.Id == host.Value) || (!host.HasValue)).Select(h=>new { h.Id, Name = h.FirmName }).ToList();
			var companies = _dbContext.Companies.Where(c => ((host.HasValue && c.HostId == host.Value) || (!host.HasValue))
																					&& ((company.HasValue && c.Id == company.Value) || (!company.HasValue))).Select(h => new { h.Id, Name = h.CompanyName, Host=h.HostId }).ToList();
			var employees = _dbContext.Employees.Where(e => ((employee.HasValue && e.Id == employee.Value) || !employee.HasValue)
			                                                &&
			                                                ((company.HasValue && e.CompanyId == company.Value) ||
			                                                 !company.HasValue)
			                                                &&
			                                                ((host.HasValue && e.Company.HostId == host.Value) || !host.HasValue)
				).Select(e => new {e.Id, Name = e.FirstName + " " + e.LastName, Company=e.CompanyId}).ToList();
			return new {Hosts = hosts, Companies = companies, Employees = employees};
		}

		public ApplicationConfig GetConfigurations()
		{
			var db = _dbContext.ApplicationConfigurations.First();
			var returnVal = JsonConvert.DeserializeObject<ApplicationConfig>(db.config);
			return returnVal;
		}

		public void SaveApplicationConfig(ApplicationConfig config)
		{
			var dbConfig = _dbContext.ApplicationConfigurations.First();
			dbConfig.config = JsonConvert.SerializeObject(config);
			dbConfig.RootHostId = config.RootHostId;
			_dbContext.SaveChanges();

		}

		public int PullReportConstat(string form940, int quarterly)
		{
			var returnVal = 1;
			
			var dbReportConstants =
				_dbContext.ReportConstants.FirstOrDefault(r => r.Form.Equals(form940) && r.DepositSchedule == quarterly);
			if (dbReportConstants == null)
			{
				_dbContext.ReportConstants.Add(new ReportConstant {DepositSchedule = quarterly, Form = form940, FileSequence = 1});
			}
			else
			{
				returnVal = dbReportConstants.FileSequence++;
			}
			_dbContext.SaveChanges();
			return returnVal;

		}

		public List<CaliforniaCompanyTax> SaveTaxRates(List<CaliforniaCompanyTax> rates)
		{
			var mapped = new List<Models.DataModel.CompanyTaxRate>();
			rates.ForEach(r=>
			{
				mapped.Add(new Models.DataModel.CompanyTaxRate()
				{
					Id = 0,
					CompanyId = r.CompanyId,
					Rate = r.UiRate,
					TaxId = 10,
					TaxYear = r.TaxYear
				});
				mapped.Add(new Models.DataModel.CompanyTaxRate()
				{
					Id = 0,
					CompanyId = r.CompanyId,
					Rate = r.EttRate,
					TaxId = 9,
					TaxYear = r.TaxYear
				});

			});
			var year = rates.First().TaxYear;
			var dbRates = _dbContext.CompanyTaxRates.Where(t => t.TaxYear == year).ToList();
			dbRates = dbRates.Where(ctr => rates.Any(r => r.CompanyId == ctr.CompanyId)).ToList();
			_dbContext.CompanyTaxRates.RemoveRange(dbRates);
			_dbContext.CompanyTaxRates.AddRange(mapped);
			_dbContext.SaveChanges();
			return rates;
		}

		public List<SearchResult> FillSearchResults(List<SearchResult> searchResults)
		{
			var _dbSearchResults = _dbContext.SearchTables.ToList();
			_dbContext.SearchTables.RemoveRange(_dbSearchResults);
			var mapped = _mapper.Map<List<Models.SearchResult>, List<Models.DataModel.SearchTable>>(searchResults);
			_dbContext.SearchTables.AddRange(mapped);
			_dbContext.SaveChanges();
			return searchResults;
		}

		public void UpdateSearchTable(SearchResult searchResult)
		{
			var _dbSearchEntry =
				_dbContext.SearchTables.FirstOrDefault(
					st => st.SourceTypeId == (int) searchResult.SourceTypeId && st.SourceId == searchResult.SourceId);
			if (_dbSearchEntry == null)
			{
				_dbContext.SearchTables.Add(_mapper.Map<Models.SearchResult, Models.DataModel.SearchTable>(searchResult));
				_dbContext.SaveChanges();
			}
			else
			{
				if (!_dbSearchEntry.SearchText.Equals(searchResult.SearchText))
				{
					_dbSearchEntry.SearchText = searchResult.SearchText;
					_dbContext.SaveChanges();
				}
			}
		}

		public ImportMap GetCompanyTsImportMap(Guid companyId)
		{
			const string sql = "select * from CompanyTSImportMap where CompanyId=@CompanyId";
			using (var conn = GetConnection())
			{
				var result = conn.Query<Models.DataModel.CompanyTSImportMap>(sql, new {CompanyId = companyId}).FirstOrDefault();
				if (result != null)
					return JsonConvert.DeserializeObject<ImportMap>(result.TimeSheetImportMap);
				return null;
			}
			
		}

		public List<VendorCustomer> GetGarnishmentAgencies()
		{
			const string sql = "select * from VendorCustomer where CompanyId is null and IsAgency=1";
			using (var conn = GetConnection())
			{
				var agencies = conn.Query<Models.DataModel.VendorCustomer>(sql);
				return _mapper.Map<List<Models.DataModel.VendorCustomer>, List<Models.VendorCustomer>>(agencies.ToList());
			}
			
			
		}

		public int GetMaxRegularCheckNumber(int companyId)
		{
			const string sql = "select max(CheckNumber) as maxnumber from dbo.CompanyJournalCheckbook where CompanyIntId=@CompanyId and TransactionType in (2,6)";
			using (var conn = GetConnection())
			{
				dynamic result =
					conn.Query(sql, new {CompanyId = companyId}).FirstOrDefault();

				if (result!=null && result.maxnumber != null)
				{
					return result.maxnumber + 1;
				}
				else
				{
					return 101;
				}
			}
		}
	}
}
