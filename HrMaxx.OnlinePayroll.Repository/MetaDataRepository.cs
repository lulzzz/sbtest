using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data.Entity.Core.Metadata.Edm;
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
		private string _sqlCon;

		public MetaDataRepository(IMapper mapper, OnlinePayrollEntities dbContext, string sqlCon, DbConnection connection)
			: base(connection)
		{
			_dbContext = dbContext;
			_mapper = mapper;
			_sqlCon = sqlCon;
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
			

			using (var con = new SqlConnection(_sqlCon))
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
                                                            && e.StatusId==1
				).Select(e => new {e.Id, Name = e.FirstName + " " + e.LastName, Company=e.CompanyId}).OrderBy(e=>e.Name).ToList();
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

		public int GetMaxCheckNumberWithoutPayroll(int companyIntId, Guid payrollId)
		{

			string nonpeosql = "select isnull(max(CheckNumber),0) as maxnumber from dbo.CompanyPayCheckNumber where CompanyIntId=" + companyIntId + " and PayrollId<>'" + payrollId + "';";


			using (var con = new SqlConnection(_sqlCon))
			{
				using (var cmd = new SqlCommand(nonpeosql))
				{
					cmd.Connection = con;
					con.Open();
					var result = (int)cmd.ExecuteScalar();

					var max = result + 1;
					if (max < 1001)
							max = 1001;
					return max;

				}
			}
		}

		public DeductionType SaveDeductionType(DeductionType dt)
		{
			var mapped = Mapper.Map<Models.DeductionType, Models.DataModel.DeductionType>(dt);
			const string sql =
				"if exists(select 'x' from DeductionType where Id=@Id) " +
				"begin Update DeductionType set Name=@Name, Category=@Category, W2_12=@W2_12, W2_13R=@W2_13R, R940_R=@R940_R where Id=@Id; select @Id; end " +
				"else begin insert into DeductionType(Name, Category, W2_12, W2_13R, R940_R) " +
				"values(@Name, @Category, @W2_12, @W2_13R, @R940_R); select cast(scope_identity() as int) end";
			using (var conn = GetConnection())
			{
				mapped.Id = conn.Query<int>(sql, mapped).Single();
			}
			return Mapper.Map<Models.DataModel.DeductionType, Models.DeductionType>(mapped);
		}

		public List<KeyValuePair<int, DateTime>> GetBankHolidays()
		{
			const string sql = "select [Year] [Key], Holiday Value from Holidays order by Holiday desc";
			using (var conn = GetConnection())
			{
				return conn.Query<KeyValuePair<int, DateTime>>(sql).ToList();
			}
		}

		public KeyValuePair<int, DateTime> SaveBankHoliday(DateTime holiday, bool action)
		{
			const string sqladd = "insert into Holidays values(@Year, @Holiday);";
			const string sqlremove = "delete from Holidays where Holiday=@Holiday";
			using (var conn = GetConnection())
			{
				if (action)
					conn.Execute(sqladd, new {Year = holiday.Year, holiday});
				else
				{
					conn.Execute(sqlremove, new {Year = holiday.Year, holiday});
				}
			}
			return new KeyValuePair<int, DateTime>(holiday.Year, holiday);
		}

		public CompanyDocumentSubType SaveDocumentSubType(CompanyDocumentSubType subType)
		{
			const string sql =
				"if exists(select 'x' from CompanyDocumentSubType where Id=@Id) " +
				"begin Update CompanyDocumentSubType set Name=@Name, Type=@Type, IsEmployeeRequired=@IsEmployeeRequired, TrackAccess=@TrackAccess where Id=@Id; select @Id; end " +
				"else begin insert into CompanyDocumentSubType(Name, Type, IsEmployeeRequired, TrackAccess, CompanyId) " +
				"values(@Name, @Type, @IsEmployeeRequired, @TrackAccess, @CompanyId); select cast(scope_identity() as int) end";
			using (var conn = GetConnection())
			{
				subType.Id = conn.Query<int>(sql, new { Id=subType.Id, Name= subType.Name, Type = subType.DocumentType.Id, subType.IsEmployeeRequired, subType.TrackAccess, subType.CompanyId}).Single();
			}
			return subType;
		}

		public void SetEmployeeDocumentAccess(Guid employeeId, Guid documentId)
		{
			const string sql =
				"if exists(select 'x' from EmployeeDocumentAccess where EmployeeId=@EmployeeId and DocumentId=@DocumentId) " +
				"begin Update EmployeeDocumentAccess set LastAccessed=getdate()  where EmployeeId=@EmployeeId and DocumentId=@DocumentId; end " +
				"else begin insert into EmployeeDocumentAccess(EmployeeId, DocumentId, FirstAccessed, LastAccessed) " +
				"values(@EmployeeId, @DocumentId, getdate(), getdate()) end";
			using (var conn = GetConnection())
			{
				conn.Execute(sql, new { EmployeeId = employeeId, DocumentId = documentId});
			}
		}

        public PayType SavePayType(PayType payType)
        {
            const string sql = "if exists(select 'x' from PayType where Id=@Id) " +
                               "begin " +
                               "update PayType set Name=@Name, Description=@Description, IsTaxable=@IsTaxable, IsAccumulable=@IsAccumulable where Id=@Id;" +
                               "select @Id; end " +
                               "else " +
                               "begin " +
                               "insert into PayType(Name, Description, IsTaxable, IsAccumulable) values(@Name, @Description, @IsTaxable, @IsAccumulable); select cast(scope_identity() as int) end";
            using (var conn = GetConnection())
            {
                payType.Id = conn.Query<int>(sql, payType).Single();
            }
            return payType;
        }
    }
}
