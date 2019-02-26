using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using HrMaxx.Infrastructure.Repository;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using Host = HrMaxx.OnlinePayroll.Models.DataModel.Host;
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
			                           "select (select Id from paxoltest.dbo.tax where code=taxcode collate Latin1_General_CI_AI) taxid, year(startdate) taxyear, TaxRatePercentage, AnnualMaxPerEmployee, TaxRateLimit from OnlinePayroll.dbo.TaxRuleTable " +
			                           "order by taxyear, taxid;";
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
			                         "insert into EstimatedDeductionsTable(PayrollPeriodId, NoOfAllowances, Amount, year)" +
			                         "select PayrollPeriodId, NoOfAllowances, Amount, year(startdate) year from OnlinePayroll.dbo.ExemptionAllowanceTable order by year, payrollperiodid, noofallowances, amount;";

			const string userstuff =
				"insert into aspnetroles select * from paxol.dbo.AspNetRoles;insert into aspnetusers select * from Paxol.dbo.AspNetUsers where username='sherjeel';insert into AspNetUserRoles select * from Paxol.dbo.AspNetUserRoles where USERID=(select Id from Paxol.dbo.AspNetUsers where username='sherjeel');insert into AspNetUserClaims(userid, claimtype, claimvalue) select userid, claimtype, claimvalue from paxol.dbo.AspNetUserClaims where userid=(select Id from paxol.dbo.AspNetUsers where username='sherjeel')";
			using (var con = GetConnection())
			{
				con.Execute(taxyearrate);
				con.Execute(fit);
				con.Execute(fitwith);
				con.Execute(sit);
				con.Execute(sitlow);
				con.Execute(stdded);
				con.Execute(estded);
				con.Execute(exmpallow);
				con.Execute(userstuff);
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

		public void SaveCompanyAssociatedData()
		{
			const string taxrates =
				"delete from CompanyTaxRate; insert into CompanyTaxRate(CompanyId, TaxId, TaxYear, Rate) select (select Id from company where companyintid=CompanyId), (select Id from Tax where Code=Taxcode collate Latin1_General_CI_AI), year(startdate), taxrate from OnlinePayroll.dbo.CompanyTaxRates;";
			const string paytypes =
				"delete from CompanyAccumlatedPayType; set identity_insert CompanyAccumlatedPayType On;insert into CompanyAccumlatedPayType(Id, PayTypeId, CompanyId, RatePerHour, AnnualLimit, CompanyManaged, IsLumpSum) select PayTypeID, 6, (select Id from company where companyintid=CompanyId), PayTypeRate, PayTypeLimit, 0, 0 from OnlinePayroll.dbo.CompanyPayType;set identity_insert CompanyAccumlatedPayType Off;";
			const string deductions =
				"delete from CompanyDeduction;" +
				"set identity_insert CompanyDeduction On;" +
				"insert into CompanyDeduction (Id, CompanyId, TypeId, Name, Description, AnnualMax, FloorPerCheck, ApplyInvoiceCredit) " +
				"select DeductionId, (select Id from company where companyintid=CompanyId), " +
				"(select Id from DeductionType where Name=(select replace(DeductionType, 'Wage Advanced Repay','Wage Advance Repay') from OnlinePayroll.dbo.Deduction_Type where Id=DeductionTypeID) collate Latin1_General_CI_AI), " +
				"DeductionName, DeductionDescription, AnnualMaxAmt, null, 0 " +
				"from OnlinePayroll.dbo.Deduction_Company;" +
				"set identity_insert CompanyDeduction Off;";
			const string wcs = "delete from CompanyWorkerCompensation;" +
			                   "insert into CompanyWorkerCompensation(CompanyId, Code, Description, Rate, MinGrossWage) " +
			                   "select (select Id from company where companyintid=CompanyId), " +
			                   "case when WCCode<2 then 1 else WCCode end, WCDescription, WCRate, null " +
			                   "from OnlinePayroll.dbo.WorkersComp_Company";
			const string pcs = "delete from CompanyPayCode;" +
			                   "insert into CompanyPayCode(CompanyId, Code, Description, HourlyRate) " +
												 "select (select Id from company where companyintid=c.CompanyId), format(ROW_NUMBER() OVER(Partition by c.CompanyId ORDER BY ep.PayRateDescription),'00##') AS Code, ep.PayRateDescription, ep.PayRateAmount " +
												 "from OnlinePayroll.dbo.Company c, " +
												 "(select distinct e.CompanyID,epr.PayRateDescription, epr.PayRateAmount from OnlinePayroll.dbo.employee e, OnlinePayroll.dbo.EmployeePayRates epr " +
			                   "where e.EmployeeID=epr.EmployeeId) ep " +
			                   "where c.Companyid=ep.CompanyID";
			using (var con = GetConnection())
			{

				con.Execute(taxrates);
				con.Execute(paytypes);
				con.Execute(deductions);
				con.Execute(wcs);
				con.Execute(pcs);

			}
		}

		public void ExecuteQuery(string sql)
		{
			using (var con = GetConnection())
			{

				con.Execute(sql);
				
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

		public void SaveEmployees(List<HrMaxx.OnlinePayroll.Models.DataModel.Employee> emplList)
		{
			const string sql = "set identity_insert Employee On; " +
												 "insert into Employee(Id, CompanyId, StatusId, FirstName, LastName, MiddleInitial, Contact, Gender, SSN, BirthDate, HireDate, Department, EmployeeNo, Memo, PayrollSchedule, PayType, Rate, PayCodes, Compensations, PaymentMethod, DirectDebitAuthorized, TaxCategory, FederalStatus, FederalExemptions, FederalAdditionalAmount, State, LastModified, LastModifiedBy, LastPayrollDate, WorkerCompensationId, CompanyEmployeeNo, Notes, SickLeaveHireDate, CarryOver, EmployeeIntId)" +
												 "values(@Id, @CompanyId, @StatusId, @FirstName, @LastName, @MiddleInitial, @Contact, @Gender, @SSN, @BirthDate, @HireDate, @Department, @EmployeeNo, @Memo, @PayrollSchedule, @PayType, @Rate, @PayCodes, @Compensations, @PaymentMethod, @DirectDebitAuthorized, @TaxCategory, @FederalStatus, @FederalExemptions, @FederalAdditionalAmount, @State, @LastModified, @LastModifiedBy, @LastPayrollDate, @WorkerCompensationId, @CompanyEmployeeNo, @Notes, @SickLeaveHireDate, @CarryOver, @EmployeeIntId);" +
			                   "set identity_insert Employee Off; ";
			const string dedsql = "insert into EmployeeDeduction(EmployeeId, Method, Rate, AnnualMax, CompanyDeductionId) " +
			                      "select (select Id from Employee where EmployeeIntId=EmployeeId), DedutionMethod,DeductionAmount,AnnualMaxAmt, " +
			                      "DeductionID from OnlinePayroll.dbo.Employee_Deduction where DeductionID>0;";

			const string banksql = "set identity_insert BankAccount On; " +
															 "insert into BankAccount(Id, EntityTypeId, EntityId, AccountType, BankName, AccountName, AccountNumber, RoutingNumber, LastModified, LastModifiedBy, FractionId) " +
															 "select AccountId, 3, (select Id from Employee where EmployeeIntId=EntityID), " +
															 "case when AccountType='Checking' then 1 else 2 end, isnull(BankName,''), isnull(BankName,''), AccountNumber, RoutingNumber, ba.LastUpdateDate, ba.LastUpdateBy,null " +
															 "from OnlinePayroll.dbo.BankAccount ba " +
															 "where EntityTypeID=3;" +
															 "set identity_insert BankAccount Off;" +
															 "insert into EmployeeBankAccount(EmployeeId, BankAccountId, Percentage) select EntityId, Id, 100.00 from BankAccount where EntityTypeId=3;";
			using (var con = GetConnection())
			{
				con.Execute(sql, emplList);
				con.Execute(dedsql);
				con.Execute(banksql);
			}
		}
	}
}
