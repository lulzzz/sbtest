using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Repository;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using Newtonsoft.Json;
using Host = HrMaxx.OnlinePayroll.Models.DataModel.Host;
using MasterExtract = HrMaxx.OnlinePayroll.Models.MasterExtract;
using VendorCustomer = HrMaxx.OnlinePayroll.Models.DataModel.VendorCustomer;

namespace OPImportUtility
{
	public class WriteRepository : BaseDapperRepository, IWriteRepository
	{
		public WriteRepository(DbConnection wConnection) : base(wConnection)
		{

		}

		public void CopyBaseData()
		{
			const string taxyearrate = "delete from TaxYearRate;" +
			                           "insert into TaxYearRate(taxid, TaxYear, Rate, AnnualMaxPerEmployee, TaxRateLimit) " +
			                           "select (select Id from paxol.dbo.tax where code=taxcode collate Latin1_General_CI_AI) taxid, year(startdate) taxyear, TaxRatePercentage, AnnualMaxPerEmployee, TaxRateLimit from OnlinePayroll.dbo.TaxRuleTable " +
			                           "order by taxyear, taxid;" +
			                           "update tyr set Rate=t.DefaultRate from TaxYearRate tyr, Tax t where tyr.TaxId=t.Id and t.IsCompanySpecific=1 and tyr.Rate is null;";
			const string fit = "truncate table FITTaxTable;" +
			                   "insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year)" +
			                   "select PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, year(startdate) from OnlinePayroll.dbo.FITTaxTable order by year(startdate), payrollperiodid, filingstatus, startrange;";
			const string sit = "truncate table SITTaxTable;" +
			                   "insert into SITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year)" +
			                   "select PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, year(startdate) from OnlinePayroll.dbo.SITTaxTable order by year(startdate), payrollperiodid, filingstatus, startrange;";
			const string fitwith = "truncate table FITWithholdingAllowanceTable;" +
			                       "insert into FITWithholdingAllowanceTable(PayrollPeriodId, AmtForOneWithholdingAllow, year)" +
			                       "select PayrollPeriodId, AmtForOneWithholdingAllow, year(startdate) year from OnlinePayroll.dbo.FITWithholdingAllowanceTable order by year, PayrollPeriodId, AmtForOneWithholdingAllow;";
			const string sitlow = "truncate table SITLowIncomeTaxTable;" +
			                      "insert into SITLowIncomeTaxTable(PayrollPeriodId, FilingStatus, Amount, AmtIfExmpGrtThan2, year)" +
			                      "select PayrollPeriodId, FilingStatus, Amount, AmtIfExmpGrtThan2, year(startdate) year from OnlinePayroll.dbo.SITLowIncomeTaxTable order by year, payrollperiodid, filingstatus, amount;";
			const string stdded = "truncate table StandardDeductionTable;" +
			                      "insert into StandardDeductionTable(PayrollPeriodId, FilingStatus, Amount, AmtIfExmpGrtThan1, year)" +
			                      "select PayrollPeriodId, FilingStatus, Amount, AmtIfExmpGrtThan1, year(startdate) year from OnlinePayroll.dbo.StandardDeductionTable order by year, payrollperiodid, filingstatus, amount;";
			const string estded = "truncate table EstimatedDeductionsTable;" +
			                      "insert into EstimatedDeductionsTable(PayrollPeriodId, NoOfAllowances, Amount, year)" +
			                      "select PayrollPeriodId, NoOfAllowances, Amount, year(startdate) year from OnlinePayroll.dbo.EstimatedDeductionsTable order by year, payrollperiodid, noofallowances, amount;";
			const string exmpallow = "truncate table ExemptionAllowanceTable;" +
															 "insert into ExemptionAllowanceTable(PayrollPeriodId, NoOfAllowances, Amount, year)" +
			                         "select PayrollPeriodId, NoOfAllowances, Amount, year(startdate) year from OnlinePayroll.dbo.ExemptionAllowanceTable order by year, payrollperiodid, noofallowances, amount;";

			const string agencies = "set identity_insert VendorCustomer On;" +
															"insert into VendorCustomer(Id, CompanyId, Name, StatusId, AccountNo, IsVendor, IsVendor1099, Contact, Note, Type1099, SubType1099, IdentifierType, IndividualSSN, BusinessFIN, LastModified, LastModifiedBy, IsAgency, IsTaxDepartment, VendorCustomerIntId) " +
															"select Id, CompanyId, Name, StatusId, AccountNo, IsVendor, IsVendor1099, Contact, Note, Type1099, SubType1099, IdentifierType, IndividualSSN, BusinessFIN, LastModified, LastModifiedBy, IsAgency, IsTaxDepartment, VendorCustomerIntId from Paxol.dbo.VendorCustomer where vendorcustomerintid<3;" +
															"set identity_insert VendorCustomer On;";


			const string fixdata = "delete from onlinepayroll.dbo.deduction_payroll where deductionid=0; " +
			                       "update OnlinePayroll.dbo.Journal set status='Void' where journalid between 209750 and 209753;" +
			                       "update OnlinePayroll.dbo.Journal set status='Void' where journalid between 202859 and 202860;" +
			                       "update OnlinePayroll.dbo.Journal set status='Void' where journalid between 197429 and 197435;" +
			                       "update OnlinePayroll.dbo.Journal set status='Void' where journalid between 176912 and 176915;" +
			                       "update OnlinePayroll.dbo.Journal set status='Void' where journalid between 165227 and 165276;" +
			                       "update OnlinePayroll.dbo.Journal set status='Void' where journalid between 165127 and 165176;" +
														 "update OnlinePayroll.dbo.UserAccount set UserFirstName='Admin' where UserId=1;update OnlinePayroll.dbo.UserAccount set UserFirstName='Master' where UserId=17;";
			

			const string userstuff =
				"insert into aspnetusers select * from Paxol.dbo.AspNetUsers where username='sherjeel';insert into AspNetUserRoles select * from Paxol.dbo.AspNetUserRoles where USERID=(select Id from Paxol.dbo.AspNetUsers where username='sherjeel');insert into AspNetUserClaims(userid, claimtype, claimvalue) select userid, claimtype, claimvalue from paxol.dbo.AspNetUserClaims where userid=(select Id from paxol.dbo.AspNetUsers where username='sherjeel')";

			const string reportconstant = "update rc set FileSequence=rc1.FileSeqID from ReportConstants rc, OnlinePayroll.dbo.ReportLookup rc1 where rc.Form=rc1.FormName collate Latin1_General_CI_AI and rc.DepositSchedule=case rc1.FormTiming when 'EachPayroll' then 1 when 'Monthly' then 2 when 'Quarterly' then 3 end";
			const string config = "delete from ApplicationConfiguration;set identity_insert ApplicationConfiguration On;insert into ApplicationConfiguration (Id, config, RootHostId) select * from paxol.dbo.ApplicationConfiguration; set identity_insert ApplicationConfiguration Off;insert into DeductionType(Name, Category, W2_12, W2_13R) values('ROTH 401(k)', 2,'AA', 0);";
			using (var con = GetConnection())
			{
				con.Execute(userstuff);
				con.Execute(agencies);
				con.Execute(config);
				con.Execute(taxyearrate);
				con.Execute(fit);
				con.Execute(fitwith);
				con.Execute(sit);
				con.Execute(sitlow);
				con.Execute(stdded);
				con.Execute(estded);
				con.Execute(exmpallow);
				con.Execute(fixdata);
				con.Execute("insert into Holidays(Year, Holiday) select * from OnlinePayroll.dbo.Holidays");
				con.Execute(reportconstant);
			}
		}

		public void SaveHosts(List<Host> dbhosts)
		{
			const string sql =
				"set identity_insert dbo.Host on; insert into Host(Id,FirmName,Url,EffectiveDate,TerminationDate,StatusId,HomePage,LastModifiedBy,LastModified,CompanyId,PTIN,DesigneeName940941,PIN940941,IsPeoHost,BankCustomerId,HostIntId) values(@Id,@FirmName,@Url,@EffectiveDate,@TerminationDate,@StatusId,@HomePage,@LastModifiedBy,@LastModified,@CompanyId,@PTIN,@DesigneeName940941,@PIN940941,@IsPeoHost,@BankCustomerId,@HostIntId);set identity_insert dbo.Host off; ";
			using (var con = GetConnection())
			{
				con.Execute(sql, dbhosts);
			}
		}

		public void SaveCompanies(List<HrMaxx.OnlinePayroll.Models.DataModel.Company> dbcompanies)
		{
			const string sql =
				"set identity_insert dbo.Company on; insert into Company( Id,CompanyName,CompanyNo,HostId,StatusId,IsVisibleToHost,FileUnderHost,DirectDebitPayer,PayrollDaysInPast,InsuranceGroupNo,TaxFilingName,CompanyAddress,BusinessAddress,IsAddressSame,ManageTaxPayment,ManageEFileForms,FederalEIN,FederalPin,DepositSchedule941,PayrollSchedule,PayCheckStock,IsFiler944,LastModifiedBy,LastModified,LastPayrollDate,MinWage,IsHostCompany,Memo,ClientNo,Created,ParentId,Notes,PayrollMessage,IsFiler1095,CompanyIntId,CompanyCheckPrintOrder,PayrollScheduleDay,DashboardNotes,City,ProfitStarsPayer) values(@Id,@CompanyName,@CompanyNo,@HostId,@StatusId,@IsVisibleToHost,@FileUnderHost,@DirectDebitPayer,@PayrollDaysInPast,@InsuranceGroupNo,@TaxFilingName,@CompanyAddress,@BusinessAddress,@IsAddressSame,@ManageTaxPayment,@ManageEFileForms,@FederalEIN,@FederalPin,@DepositSchedule941,@PayrollSchedule,@PayCheckStock,@IsFiler944,@LastModifiedBy,@LastModified,@LastPayrollDate,@MinWage,@IsHostCompany,@Memo,@ClientNo,@Created,@ParentId,@Notes,@PayrollMessage,@IsFiler1095,@CompanyIntId,@CompanyCheckPrintOrder,@PayrollScheduleDay,@DashboardNotes,@City,@ProfitStarsPayer);set identity_insert dbo.Company Off";
			const string statesql =
				"insert into CompanyTaxState(CompanyId, CountryId, StateId, StateCode, StateName, EIN, PIN) values((select Id from Company where CompanyIntId=@CompanyIntId), @CountryId, @StateId, @StateCode, @StateName, @EIN, @PIN);";


			using (var con = GetConnection())
			{
				con.Execute(sql, dbcompanies);
				dbcompanies.ForEach(c =>
				{
					var state = c.CompanyTaxStates.First();
					con.Execute(statesql,
						new
						{
							CompanyIntId = c.CompanyIntId,
							CountryId = state.CountryId,
							StateId = state.StateId,
							StateCode = state.StateCode,
							StateName = state.StateName,
							EIN = state.EIN,
							PIN = state.Pin
						});
				});
			}
		}

		public void SaveCompanyContract(Guid companyIntId, ContractDetails contract)
		{
			const string sql =
				"insert into CompanyContract(CompanyId, Type, PrePaidSubscriptionType, BillingType, CardDetails, BankDetails, InvoiceRate, Method, InvoiceSetup) values(@CompanyId, @Type, @PrePaidSubscriptionType, @BillingType, @CardDetails, @BankDetails, @InvoiceRate, @Method, @InvoiceSetup);";
			var mapped = Mapper.Map<ContractDetails, CompanyContract>(contract);
			mapped.CompanyId = companyIntId;
			using (var con = GetConnection())
			{
				con.Execute(sql, mapped);
			}
		}

		public void SaveCompanyAssociatedData(int companyId)
		{
			const string mergetaxrates =
				"merge CompanyTaxRate t using (Select (select Id from company where companyintid=@CompanyId) CompanyId, (select Id from Tax where Code=Taxcode collate Latin1_General_CI_AI) TaxId, year(startdate) TaxYear, taxrate from OnlinePayroll.dbo.CompanyTaxRates where CompanyId=@CompanyId) s " +
				"on (t.CompanyId=s.CompanyId " +
				"and t.TaxId=s.TaxId and t.TaxYear=s.TaxYear) " +
				"when matched and t.Rate<>s.TaxRate then Update set t.Rate=s.taxrate " +
				"when not matched by target then insert (CompanyId, TaxId, TaxYear, Rate) values( s.CompanyId, s.TaxId, s.TaxYear, s.taxrate );";// +
																	 //"when not matched by source and t.CompanyId=(select Id from company where companyintid=@CompanyId) then delete; ";

			const string mergepaytypes = "set identity_insert CompanyAccumlatedPayType On;" +
																	 "merge CompanyAccumlatedPayType t using (select PayTypeId Id,(select Id from company where companyintid=@CompanyId) CompanyId, PayTypeRate, PayTypeLimit from OnlinePayroll.dbo.CompanyPayType where CompanyId=@CompanyId) s " +
																	 "on (t.CompanyId=s.CompanyId and t.PayTypeId=6 and t.Id=s.Id) " +
																	 "when matched and (t.RatePerHour<>s.PayTypeRate or t.AnnualLimit<>s.PayTypeLimit) then Update set t.RatePerHour=s.PayTypeRate, AnnualLimit=s.PayTypeLimit " +
																	 "when not matched by target then insert (Id, PayTypeId, CompanyId, RatePerHour, AnnualLimit, CompanyManaged, IsLumpSum, IsEmployeeSpecific) " +
																	 "values (s.Id, 6, s.CompanyId, s.PayTypeRate, s.PayTypeLimit, 0, 0, 0); " +
																	 //"when not matched by source and t.CompanyId=(select Id from company where companyintid=@CompanyId) then delete; " +
			                             "set identity_insert CompanyAccumlatedPayType Off;";

			const string mergedeductions = "set identity_insert CompanyDeduction On;" +
			                               "merge CompanyDeduction t using (select DeductionId Id, (select Id from company where companyintid=@CompanyId) CompanyId, (select Id from DeductionType where Name=(select replace(DeductionType, 'Wage Advanced Repay','Wage Advance Repay') from OnlinePayroll.dbo.Deduction_Type where Id=DeductionTypeID) collate Latin1_General_CI_AI) TypeId, DeductionName, DeductionDescription, AnnualMaxAmt, null FloorPerCheck, 0 ApplyInvoiceCredit from OnlinePayroll.dbo.Deduction_Company where CompanyId=@CompanyId) s" +
			                               " on (t.CompanyId=s.CompanyId	and t.Id=s.Id) " +
			                               "when matched and (t.Name<>s.DeductionName collate Latin1_General_CI_AI or t.Description<>s.DeductionDescription collate Latin1_General_CI_AI or t.AnnualMax<>s.AnnualMaxAmt) 	" +
			                               "then Update set t.Name=s.DeductionName, Description=s.DeductionDescription, AnnualMax=s.AnnualMaxAmt " +
			                               "when not matched by target then 	" +
			                               "insert (Id, CompanyId, TypeId, Name, Description, AnnualMax, FloorPerCheck, ApplyInvoiceCredit) 	" +
			                               "values(s.Id, s.CompanyId, s.TypeId, s.DeductionName, s.DeductionDescription, s.AnnualMaxAmt, s.FloorPerCheck, s.ApplyinvoiceCredit); " +
			                               //"when not matched by source and t.CompanyId=(select Id from company where companyintid=@CompanyId) then delete; " +
			                               "set identity_insert CompanyDeduction Off;";

			const string mergewcs =
				"merge CompanyWorkerCompensation t using (select (select Id from company where companyintid=@CompanyId) CompanyId,case when WCCode<2 then 1 else WCCode end Code, WCDescription, WCRate, null MinGrossWage from OnlinePayroll.dbo.WorkersComp_Company where CompanyId=@CompanyId) s " +
				"on (t.CompanyId=s.CompanyId and t.Code=s.Code) " +
				"when matched and (t.Description<>s.WCDescription  collate Latin1_General_CI_AI or t.Rate<>s.WCRate) then Update set t.Description=s.WCDescription, t.Rate=s.WCRate " +
				"when not matched by target then insert (CompanyId, Code, Description, Rate, MinGrossWage) values (s.CompanyId, s.Code, s.WCDescription, s.WCRate, s.MinGrossWage); "; 
															//+"when not matched by source and t.CompanyId=(select Id from company where companyintid=@CompanyId) then delete;";

			const string mergepcs =
				"merge CompanyPayCode t using (select (select Id from company where companyintid=@CompanyId) CompanyId, format(ROW_NUMBER() OVER(Partition by c.CompanyId ORDER BY ep.PayRateDescription),'00##') AS Code, ep.PayRateDescription, ep.PayRateAmount from OnlinePayroll.dbo.Company c, " +
				"(select distinct e.CompanyID,epr.PayRateDescription, epr.PayRateAmount from OnlinePayroll.dbo.employee e, OnlinePayroll.dbo.EmployeePayRates epr where e.EmployeeID=epr.EmployeeId) ep where c.Companyid=ep.CompanyID and c.CompanyId=@CompanyId) s " +
				"on (t.CompanyId=s.CompanyId and t.Code=s.Code) " +
				"when matched and (t.Description<>s.PayRateDescription collate Latin1_General_CI_AI or t.HourlyRate<>s.PayRateAmount) then Update set t.Description=s.PayRateDescription, t.HourlyRate=s.PayRateAmount " +
				"when not matched by target then insert (CompanyId, Code, Description, HourlyRate) values(s.CompanyId, s.Code, s.PayRateDescription, s.PayRateAmount); "; 
															//+"when not matched by source and t.CompanyId=(select Id from company where companyintid=@CompanyId) then delete; ";
			//const string taxrates =
			//	"delete from CompanyTaxRate where CompanyId=(select Id from company where companyintid=@CompanyId); " +
			//	"insert into CompanyTaxRate(CompanyId, TaxId, TaxYear, Rate) select (select Id from company where companyintid=@CompanyId), " +
			//	"(select Id from Tax where Code=Taxcode collate Latin1_General_CI_AI), year(startdate), taxrate " +
			//	"from OnlinePayroll.dbo.CompanyTaxRates where CompanyId=@CompanyId;";
			//const string paytypes =
			//	"delete from CompanyAccumlatedPayType where CompanyId=(select Id from company where companyintid=@CompanyId); " +
			//	"set identity_insert CompanyAccumlatedPayType On;" +
			//	"insert into CompanyAccumlatedPayType(Id, PayTypeId, CompanyId, RatePerHour, AnnualLimit, CompanyManaged, IsLumpSum, IsEmployeeSpecific) " +
			//	"select PayTypeID, 6, (select Id from company where companyintid=@CompanyId), PayTypeRate, PayTypeLimit, 0, 0, 0 " +
			//	"from OnlinePayroll.dbo.CompanyPayType where CompanyId=@CompanyId;set identity_insert CompanyAccumlatedPayType Off;";
			//const string deductions =
			//	"delete from CompanyDeduction where CompanyId=(select Id from company where companyintid=@CompanyId);" +
			//	"set identity_insert CompanyDeduction On;" +
			//	"insert into CompanyDeduction (Id, CompanyId, TypeId, Name, Description, AnnualMax, FloorPerCheck, ApplyInvoiceCredit) " +
			//	"select DeductionId, (select Id from company where companyintid=@CompanyId), " +
			//	"(select Id from DeductionType where Name=(select replace(DeductionType, 'Wage Advanced Repay','Wage Advance Repay') " +
			//	"from OnlinePayroll.dbo.Deduction_Type where Id=DeductionTypeID) collate Latin1_General_CI_AI), " +
			//	"DeductionName, DeductionDescription, AnnualMaxAmt, null, 0 " +
			//	"from OnlinePayroll.dbo.Deduction_Company where CompanyID=@CompanyId;" +
			//	"set identity_insert CompanyDeduction Off;";
			//const string wcs = "delete from CompanyWorkerCompensation where CompanyId=(select Id from company where companyintid=@CompanyId);" +
			//									 "insert into CompanyWorkerCompensation(CompanyId, Code, Description, Rate, MinGrossWage) " +
			//									 "select (select Id from company where companyintid=@CompanyId), " +
			//									 "case when WCCode<2 then 1 else WCCode end, WCDescription, WCRate, null " +
			//									 "from OnlinePayroll.dbo.WorkersComp_Company " +
			//									 "where CompanyID=@CompanyId";
			//const string pcs = "delete from CompanyPayCode where CompanyId=(select Id from company where companyintid=@CompanyId);" +
			//									 "insert into CompanyPayCode(CompanyId, Code, Description, HourlyRate) " +
			//									 "select (select Id from company where companyintid=@CompanyId), format(ROW_NUMBER() OVER(Partition by c.CompanyId ORDER BY ep.PayRateDescription),'00##') AS Code, ep.PayRateDescription, ep.PayRateAmount " +
			//									 "from OnlinePayroll.dbo.Company c, " +
			//									 "(select distinct e.CompanyID,epr.PayRateDescription, epr.PayRateAmount from OnlinePayroll.dbo.employee e, OnlinePayroll.dbo.EmployeePayRates epr " +
			//									 "where e.EmployeeID=epr.EmployeeId) ep " +
			//									 "where c.Companyid=ep.CompanyID and c.CompanyId=@CompanyId";
			using (var con = GetConnection())
			{

				con.Execute(mergetaxrates, new {CompanyId=companyId});
				con.Execute(mergepaytypes, new { CompanyId = companyId });
				con.Execute(mergedeductions, new { CompanyId = companyId });
				con.Execute(mergewcs, new { CompanyId = companyId });
				con.Execute(mergepcs, new { CompanyId = companyId });

			}
		}

		public void ExecuteQuery(string sql, object unknown)
		{
			using (var con = GetConnection())
			{

				con.Execute(sql, unknown);
				
			}
		}

		public void SaveBanks(List<HrMaxx.OnlinePayroll.Models.DataModel.BankAccount> mbanks)
		{
			const string sql = "set identity_insert BankAccount On; " +
			                   "insert into BankAccount(Id, EntityTypeId, EntityId, AccountType, BankName, AccountName, AccountNumber, RoutingNumber, LastModified, LastModifiedBy, FractionId) " +
			                   "values(@Id, @EntityTypeId, (select CompanyId from CompanyAccount where Id=@EntityId), @AccountType, @BankName, @AccountName, @AccountNumber, @RoutingNumber, @LastModified, @LastModifiedBy, @FractionId);" +
			                   "set identity_insert BankAccount On;" +
												 "update CompanyAccount set bankaccountid=@Id where Id=@EntityId and ba.entitytypeid=@EntityTypId;";
			using (var con = GetConnection())
			{

				con.Execute(sql);

			}
		}

		public void SaveVendors(List<VendorCustomer> dbvendors)
		{
			const string sql = "set identity_insert VendorCustomer On; " +
												 "insert into VendorCustomer(Id, CompanyId, Name, StatusId, AccountNo, IsVendor, IsVendor1099, Contact, Note, Type1099, SubType1099, IdentifierType, IndividualSSN, BusinessFIN, LastModified, LastModifiedBy, IsAgency, IsTaxDepartment, VendorCustomerIntId) " +
												 "values(@Id, @CompanyId, @Name, @StatusId, @AccountNo, @IsVendor, @IsVendor1099, @Contact, @Note, @Type1099, @SubType1099, @IdentifierType, @IndividualSSN, @BusinessFIN, @LastModified, @LastModifiedBy, @IsAgency, @IsTaxDepartment, @VendorCustomerIntId);" +
												 "set identity_insert VendorCustomer On;";
			using (var con = GetConnection())
			{

				con.Execute(sql, dbvendors);

			}
		}

		public void SaveEmployees(List<HrMaxx.OnlinePayroll.Models.DataModel.Employee> emplList, int companyId)
		{
			const string sql = "set identity_insert Employee On; " +
												 "insert into Employee(Id, CompanyId, StatusId, FirstName, LastName, MiddleInitial, Contact, Gender, SSN, BirthDate, HireDate, Department, EmployeeNo, Memo, PayrollSchedule, PayType, Rate, PayCodes, Compensations, PaymentMethod, DirectDebitAuthorized, TaxCategory, FederalStatus, FederalExemptions, FederalAdditionalAmount, State, LastModified, LastModifiedBy, LastPayrollDate, WorkerCompensationId, CompanyEmployeeNo, Notes, SickLeaveHireDate, CarryOver, EmployeeIntId)" +
												 "values(@Id, @CompanyId, @StatusId, @FirstName, @LastName, @MiddleInitial, @Contact, @Gender, @SSN, @BirthDate, @HireDate, @Department, @EmployeeNo, @Memo, @PayrollSchedule, @PayType, @Rate, @PayCodes, @Compensations, @PaymentMethod, @DirectDebitAuthorized, @TaxCategory, @FederalStatus, @FederalExemptions, @FederalAdditionalAmount, @State, @LastModified, @LastModifiedBy, @LastPayrollDate, @WorkerCompensationId, @CompanyEmployeeNo, @Notes, @SickLeaveHireDate, @CarryOver, @EmployeeIntId);" +
			                   "set identity_insert Employee Off; ";
			const string dedsql = "merge EmployeeDeduction t using ( select (select Id from Employee where EmployeeIntId=ed.EmployeeId) EmployeeId, case ed.DedutionMethod when 2 then 1 when 1 then 2 else 0 end Method,ed.DeductionAmount Rate,ed.AnnualMaxAmt AnnualMax," +
			                      "DeductionID CompanyDeductionId from OnlinePayroll.dbo.Employee_Deduction ed, " +
			                      "OnlinePayroll.dbo.Employee e where ed.EmployeeId=e.EmployeeId and ed.DeductionID>0 and e.CompanyId=@CompanyId) s " +
			                      "on (t.EmployeeId=s.EmployeeId and t.CompanyDeductionId=s.CompanyDeductionId) " +
			                      "when matched and (t.Method<>s.Method or t.Rate<>s.Rate or t.AnnualMax<>s.AnnualMax) " +
			                      "then Update set t.Method=s.Method, t.Rate=s.Rate, t.AnnualMax=s.AnnualMax " +
			                      "when not matched by target then insert (EmployeeId, Method, Rate, AnnualMax, CompanyDeductionId) " +
			                      "values(s.EmployeeId, s.Method, s.Rate, s.AnnualMax, s.CompanyDeductionId) " +
			                      "when not matched by source and t.EmployeeId in (select Id from Employee where CompanyId=(select Id From Company where companyintid=@CompanyId)) then delete;";

			const string banksql = "set identity_insert BankAccount On; " +
					"merge BankAccount t using ( select AccountId Id, 3 EntityTypeId, (select Id from Employee where EmployeeIntId=EntityID) EntityId, " +
					"case when AccountType='Checking' then 1 else 2 end AccountType, isnull(BankName,'') BankName, isnull(BankName,'') AccountName, AccountNumber, RoutingNumber, ba.LastUpdateDate LastModified, ba.LastUpdateBy LastModifiedBy,null FractionId " +
					"from OnlinePayroll.dbo.BankAccount ba, OnlinePayroll.dbo.employee e " +
					"where EntityTypeID=3 and ba.EntityId=e.EmployeeId and e.CompanyId=@CompanyId and ba.BankName<>'') s " +
					"on (t.EntityId=s.EntityId and t.EntityTypeId=3 and t.Id=s.Id) " +
					"when matched and (t.AccountType<>s.AccountType or t.BankName<>s.BankName collate Latin1_General_CI_AS or t.AccountName<>s.AccountName collate Latin1_General_CI_AS or t.AccountNumber<>s.AccountNumber collate Latin1_General_CI_AS or t.RoutingNumber<>s.RoutingNumber collate Latin1_General_CI_AS) " +
					"then Update set t.AccountType=s.AccountType, t.BankName=s.BankName, t.AccountName=s.AccountName, t.AccountNumber=s.AccountNumber, t.RoutingNumber=s.RoutingNumber " +
					"when not matched by target then " +
					"insert (Id, EntityTypeId, EntityId, AccountType, BankName, AccountName, AccountNumber, RoutingNumber, LastModified, LastModifiedBy, FractionId) " +
					"values(s.Id, s.EntityTypeId, s.EntityId, s.AccountType, s.BankName, s.AccountName, s.AccountNumber, s.RoutingNumber, s.LastModified, s.LastModifiedBy, s.FractionId) " +
					"when not matched by source and t.EntityTypeId=3 and t.EntityId in (select Id from Employee where CompanyId=(select Id from company where companyintid=@CompanyId)) then delete; " +
					"set identity_insert BankAccount Off; " +
					"merge EmployeeBankAccount t using ( select EntityId EmployeeId, Id BankAccountId, 100.00 Percentage from BankAccount where EntityTypeId=3 and EntityId in (select e.Id from Employee e, Company c where e.CompanyId=c.Id and c.CompanyIntId=30)) s " +
					"on (t.EmployeeId=s.EmployeeId and t.BankAccountId=s.BankAccountId) " +
					"when matched and (t.Percentage<>s.Percentage) then Update set t.Percentage=s.Percentage " +
					"when not matched by target then insert (EmployeeId, BankAccountId, Percentage) values(s.EmployeeId, s.BankAccountId, s.Percentage); ";
			using (var con = GetConnection())
			{
				con.Execute(sql, emplList);
				con.Execute(dedsql, new { CompanyId=companyId});
				con.Execute(banksql, new { CompanyId = companyId });
			}
		}

		public void SavePayrolls(List<HrMaxx.OnlinePayroll.Models.DataModel.Payroll> payrolls)
		{
			const string payrollsql = "insert into Payroll( Id ,CompanyId,StartDate,EndDate,PayDay,StartingCheckNumber,Status,Company,LastModified,LastModifiedBy,InvoiceId,PEOASOCoCheck,Notes,TaxPayDay,IsHistory,CopiedFrom,MovedFrom,IsPrinted,IsVoid,HostCompanyId,CompanyIntId,IsQueued,QueuedTime,ConfirmedTime,IsConfirmFailed,InvoiceSpecialRequest)" +
																"values( @Id, @CompanyId, @StartDate, @EndDate, @PayDay, @StartingCheckNumber, @Status, @Company, @LastModified, @LastModifiedBy, @InvoiceId, @PEOASOCoCheck, @Notes, @TaxPayDay, @IsHistory, @CopiedFrom, @MovedFrom, @IsPrinted, @IsVoid, @HostCompanyId, @CompanyIntId, @IsQueued, @QueuedTime, @ConfirmedTime, @IsConfirmFailed, @InvoiceSpecialRequest);";
			const string paychecksql = "set identity_insert dbo.PayrollPayCheck On;" +
																 "insert into PayrollPayCheck (Id, PayrollId, CompanyId, EmployeeId, Employee, GrossWage, NetWage, WCAmount, Compensations, Deductions, Taxes, Accumulations, Salary, YTDSalary, PayCodes, DeductionAmount, EmployeeTaxes, EmployerTaxes, Status, IsVoid, PayrmentMethod, PrintStatus, StartDate, EndDate, PayDay, CheckNumber, PaymentMethod, Notes, YTDGrossWage, YTDNetWage, LastModified, LastModifiedBy, WorkerCompensation, PEOASOCoCheck, InvoiceId, VoidedOn, CreditInvoiceId, TaxPayDay, IsHistory, IsReIssued, OriginalCheckNumber, ReIssuedDate, CompanyIntId)" +
																 "values(@Id, @PayrollId, @CompanyId, @EmployeeId, @Employee, @GrossWage, @NetWage, @WCAmount, @Compensations, @Deductions, @Taxes, @Accumulations, @Salary, @YTDSalary, @PayCodes, @DeductionAmount, @EmployeeTaxes, @EmployerTaxes, @Status, @IsVoid, @PayrmentMethod, @PrintStatus, @StartDate, @EndDate, @PayDay, @CheckNumber, @PaymentMethod, @Notes, @YTDGrossWage, @YTDNetWage, @LastModified, @LastModifiedBy, @WorkerCompensation, @PEOASOCoCheck, @InvoiceId, @VoidedOn, @CreditInvoiceId, @TaxPayDay, @IsHistory, @IsReIssued, @OriginalCheckNumber, @ReIssuedDate, @CompanyIntId);" +
			                           "set identity_insert dbo.PayrollPayCheck Off;";
			payrolls.ForEach(p=>p.PayrollPayChecks.ToList().ForEach(pc =>
			{
				pc.PayrollId = p.Id;
				pc.CompanyId = p.CompanyId;
			}));
			using (var conn = GetConnection())
			{
				conn.Execute(payrollsql, payrolls);
				conn.Execute(paychecksql, payrolls.SelectMany(p => p.PayrollPayChecks).ToList());
			}

		}

		public void SaveJournals(List<HrMaxx.OnlinePayroll.Models.DataModel.Journal> journals)
		{
			const string payrolljournal = "set identity_insert Journal On;" +
																		"insert into Journal (Id, CompanyId, TransactionType, PaymentMethod, CheckNumber, PayrollPayCheckId, EntityType, PayeeId, PayeeName, Amount, Memo, IsDebit, IsVoid, MainAccountId, TransactionDate, LastModified, LastModifiedBy, JournalDetails, DocumentId, PEOASOCoCheck, OriginalDate, IsReIssued, OriginalCheckNumber, ReIssuedDate, PayrollId, CompanyIntId, IsCleared, ClearedBy, ClearedOn)" +
																		"values(@Id, @CompanyId, @TransactionType, @PaymentMethod, @CheckNumber, @PayrollPayCheckId, @EntityType, @PayeeId, @PayeeName, @Amount, @Memo, @IsDebit, @IsVoid, @MainAccountId, @TransactionDate, @LastModified, @LastModifiedBy, @JournalDetails, @DocumentId, @PEOASOCoCheck, @OriginalDate, @IsReIssued, @OriginalCheckNumber, @ReIssuedDate, @PayrollId, @CompanyIntId, @IsCleared, @ClearedBy, @ClearedOn)" +
			                              "set identity_insert Journal Off;";
			const string checkbookjournal = "set identity_insert CheckbookJournal On;" +
																		"insert into CheckbookJournal (Id, CompanyId, TransactionType, PaymentMethod, CheckNumber, PayrollPayCheckId, EntityType, PayeeId, PayeeName, Amount, Memo, IsDebit, IsVoid, MainAccountId, TransactionDate, LastModified, LastModifiedBy, JournalDetails, DocumentId, PEOASOCoCheck, OriginalDate, IsReIssued, OriginalCheckNumber, ReIssuedDate, PayrollId, CompanyIntId, IsCleared, ClearedBy, ClearedOn)" +
																		"values(@Id, @CompanyId, @TransactionType, @PaymentMethod, @CheckNumber, @PayrollPayCheckId, @EntityType, @PayeeId, @PayeeName, @Amount, @Memo, @IsDebit, @IsVoid, @MainAccountId, @TransactionDate, @LastModified, @LastModifiedBy, @JournalDetails, @DocumentId, @PEOASOCoCheck, @OriginalDate, @IsReIssued, @OriginalCheckNumber, @ReIssuedDate, @PayrollId, @CompanyIntId, @IsCleared, @ClearedBy, @ClearedOn)" +
																		"set identity_insert CheckbookJournal Off;";
			using (var con = GetConnection())
			{
				con.Execute(payrolljournal, journals.Where(j => j.TransactionType == 1 && j.PayrollId.HasValue));
				con.Execute(checkbookjournal, journals.Where(j => j.TransactionType == 2 && j.PayeeId!=Guid.Empty ));
				con.Execute(checkbookjournal, journals.Where(j => j.TransactionType >2));
			}
		}

		public int AddExtract(MasterExtract extract, List<HrMaxx.OnlinePayroll.Models.DataModel.Journal> journals )
		{
			const string maxIdSql = "select isnull(max(Id),0)+1 from MasterExtracts";
			using (var conn = GetConnection())
			{
				var maxId = conn.ExecuteScalar<int>(maxIdSql);
				if (extract.Id != maxId)
					extract.Id = maxId;
			}
			ExecuteQuery("set identity_insert MasterExtracts On;insert into MasterExtracts(Id, Extract, Startdate, Enddate, ExtractName, Isfederal, depositdate, Journals, lastmodified, lastmodifiedby) values(@Id,'', @StartDate, @EndDate, @ExtractName, @IsFederal, @DepositDate, @Journals, @LastModified, @LastModifiedBy);set identity_insert MasterExtracts Off;", new { Id = extract.Id, StartDate = extract.StartDate, EndDate = extract.EndDate, DepositDate = extract.DepositDate, ExtractName = extract.ExtractName, LastModified = extract.LastModified, LastModifiedBy = extract.LastModifiedBy, IsFederal = extract.IsFederal, Journals = JsonConvert.SerializeObject(extract.Journals) });
			extract.Journals.ForEach(j => ExecuteQuery("insert into MasterExtractJournal(MasterExtractId, JournalId) values(@Id, @JournalId)", new { Id = extract.Id, JournalId = j }));
			//payCheckList.ForEach(p => ExecuteQuery("insert into PayCheckExtract(PayrollPayCheckId, MasterExtractId, Extract, Type) values(@Id, @MId, @ExtractName, 1)", new { Id = p, MId = extract.Id, ExtractName = extract.ExtractName }));
			extract.Journals.ForEach(j =>
			{
				var j1 = journals.First(j2 => j2.Id == j);
				var query =
					string.Format(
						"insert into PayCheckExtract(PayrollPayCheckId, MasterExtractId, Extract, Type)" +
						"select pc.Id, {4}, '{5}', 1 from Payroll p, PayrollPayCheck pc " +
						"where pc.payrollid=p.id " +
						"and (pc.IsVoid=0 or (pc.isvoid=1 and pc.VoidedOn >= cast('{0}' as date))) " +
						"and p.LastModified<'{0}' and pc.PayDay between '{1}' and '{2}' and pc.CompanyIntId={3}" +
						"and not exists (select 'x' from PayCheckExtract where PayrollPayCheckId=pc.Id and Extract='{5}' and Type=1)",
						j1.LastModified.ToString("MM/dd/yyyy hh:mm:ss tt"), extract.StartDate.ToString("MM/dd/yyyy"), extract.EndDate.ToString("MM/dd/yyyy"),
						j1.CompanyIntId, extract.Id, extract.ExtractName);
				ExecuteQuery(query, new {});
			});
			return extract.Id++;
		}

		public void AddToExtract(DateTime startdate, DateTime enddate, HrMaxx.OnlinePayroll.Models.DataModel.Journal journal, string extractName, MasterExtract extract)
		{
			const string getextract =
				"select * from MasterExtracts where Startdate=@StartDate and EndDate=@EndDate and Extractname=@ExtractName";
			const string updateextract = "update MasterExtracts set Journals=@Journals where Id=@Id";
			const string insertJournal = "if not exists( select 'x' from MasterExtractJournal where MasterExtractId=@Id and JournalId=@JournalId)" +
			                             "insert into MasterExtractJournal(MasterExtractId, JournalId) values(@Id, @JournalId)";
			const string insertpaychecks = "insert into PayCheckExtract(PayrollPayCheckId, MasterExtractId, Extract, Type) " +
						"select pc.Id, @ExtractId, @ExtractName, 1 from Payroll p, PayrollPayCheck pc " +
						"where pc.payrollid=p.id " +
						"and (pc.IsVoid=0 or (pc.isvoid=1 and pc.VoidedOn >= cast(@LastModified as date))) " +
						"and p.LastModified<@LastModified and pc.PayDay between @StartDate and @EndDate and pc.CompanyIntId=@CompanyIntId " +
						"and not exists (select 'x' from PayCheckExtract where PayrollPayCheckId=pc.Id and Extract=@ExtractName and Type=1)";
			using (var conn = GetConnection())
			{
				var extracts =
					conn.Query<HrMaxx.OnlinePayroll.Models.DataModel.MasterExtract>(getextract,
						new {StartDate = startdate, EndDate = enddate, ExtractName = extractName}).ToList();
				if (extracts.Any())
				{
					var e = extracts.First();
					var jList = JsonConvert.DeserializeObject<List<int>>(e.Journals);
					jList.Add(journal.Id);
					conn.Execute(updateextract, new {Journals = JsonConvert.SerializeObject(jList), Id = e.Id});
					conn.Execute(insertJournal, new {Id = e.Id, JournalId = journal.Id});
					conn.Execute(insertpaychecks,
						new
						{
							ExtractId = e.Id,
							ExtractName = extractName,
							LastModified = journal.LastModified,
							StartDate = startdate,
							EndDate = enddate,
							CompanyIntId = journal.CompanyIntId
						});

				}
				else
				{
					extract.Journals.Add(journal.Id);
					AddExtract(extract, new List<HrMaxx.OnlinePayroll.Models.DataModel.Journal>() {journal});
				}
				
			}
		}
	}
}
