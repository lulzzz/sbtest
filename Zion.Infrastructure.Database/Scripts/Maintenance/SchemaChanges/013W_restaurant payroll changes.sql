IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_MinWageYear_MaxTipCredit]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MinWageYear] DROP CONSTRAINT [DF_MinWageYear_MaxTipCredit]
END
GO
/****** Object:  Table [dbo].[MinWageYear]    Script Date: 26/01/2020 9:11:48 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MinWageYear]') AND type in (N'U'))
DROP TABLE [dbo].[MinWageYear]
GO
/****** Object:  Table [dbo].[MinWageYear]    Script Date: 26/01/2020 9:11:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MinWageYear](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Year] [int] NOT NULL,
	[StateId] [int] NULL,
	[MinWage] [decimal](18, 2) NOT NULL,
	[TippedMinWage] [decimal](18, 2) NOT NULL,
	[MaxTipCredit] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_MinWageYear] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MinWageYear] ADD  CONSTRAINT [DF_MinWageYear_MaxTipCredit]  DEFAULT ((0)) FOR [MaxTipCredit]
GO

insert into MinWageYear(Year, StateId, MinWage, TippedMinWage, MaxTipCredit) values(2017, null, 7.25, 2.13, 5.12);
insert into MinWageYear(Year, StateId, MinWage, TippedMinWage, MaxTipCredit) values(2017, 1, 10.00, 10.00, 0.00);
insert into MinWageYear(Year, StateId, MinWage, TippedMinWage, MaxTipCredit) values(2017, 10, 9.25, 8.50, 0.75);
insert into MinWageYear(Year, StateId, MinWage, TippedMinWage, MaxTipCredit) values(2018, null, 7.25, 2.13, 5.12);
insert into MinWageYear(Year, StateId, MinWage, TippedMinWage, MaxTipCredit) values(2018, 1, 10.50, 10.50, 0.00);
insert into MinWageYear(Year, StateId, MinWage, TippedMinWage, MaxTipCredit) values(2018, 10, 10.10, 9.35, 0.75);
insert into MinWageYear(Year, StateId, MinWage, TippedMinWage, MaxTipCredit) values(2019, null, 7.25, 2.13, 5.12);
insert into MinWageYear(Year, StateId, MinWage, TippedMinWage, MaxTipCredit) values(2019, 1, 11.00, 11.00, 0.00);
insert into MinWageYear(Year, StateId, MinWage, TippedMinWage, MaxTipCredit) values(2019, 10, 10.10, 9.35, 0.75);
insert into MinWageYear(Year, StateId, MinWage, TippedMinWage, MaxTipCredit) values(2020, null, 7.25, 2.13, 5.12)
insert into MinWageYear(Year, StateId, MinWage, TippedMinWage, MaxTipCredit) values(2020, 1, 12.00, 12.00, 0.00);
insert into MinWageYear(Year, StateId, MinWage, TippedMinWage, MaxTipCredit) values(2020, 10, 10.10, 9.35, 0.75);



IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Company'
                 AND COLUMN_NAME = 'IsRestaurant')
alter table Company Add IsRestaurant bit not null default(0);
alter table Company alter column MinWage decimal(18,2);
Go
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Employee'
                 AND COLUMN_NAME = 'IsTipped')
alter table Employee Add IsTipped bit not null default(0);
Go
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayType'
                 AND COLUMN_NAME = 'IsTip')
alter table PayType Add IsTip bit not null default(0), PaidInCash bit not null default(0);
Go
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyPayCode'
                 AND COLUMN_NAME = 'RateType')
alter table CompanyPayCode Add RateType int not null default(1), TimesFactor decimal(18,2);
Go
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyDeduction'
                 AND COLUMN_NAME = 'StartDate')
alter table CompanyDeduction Add StartDate datetime, EndDate datetime;
alter table EmployeeDeduction Add StartDate datetime, EndDate datetime;
Go
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Employee'
                 AND COLUMN_NAME = 'TerminationDate')
alter table Employee Add TerminationDate DateTime;
Go
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'ScheduledPayroll'
                 AND COLUMN_NAME = 'LastPayrollId')
alter table ScheduledPayroll Add LastPayrollId uniqueidentifier;
Go
update PayType set IsTip=1 where Id=3;
if not exists(select 'x' from PaxolFeatureClaim where ClaimType='http://Paxol/Company/DeductionDates')
begin
insert into PaxolFeatureClaim(FeatureId, ClaimName, ClaimType, AccessLevel)
values (3, 'Deduction Dates', 'http://Paxol/Company/DeductionDates', 30);

insert into PaxolFeatureClaim(FeatureId, ClaimName, ClaimType, AccessLevel)
values (4, 'Deduction Dates', 'http://Paxol/Employee/DeductionDates', 10);

insert into PaxolFeatureClaim(FeatureId, ClaimName, ClaimType, AccessLevel)
values (5, 'Schedule Payroll', 'http://Paxol/Payroll/SchedulePayroll', 90);


insert into AspNetUserClaims(UserId, ClaimType, ClaimValue)
select u.Id, 'http://Paxol/Company/DeductionDates', 1 from AspNetUsers u, AspNetUserRoles ur, AspNetRoles r
where u.Id=ur.UserId and ur.RoleId=r.Id
and r.Id>=30;
insert into AspNetUserClaims(UserId, ClaimType, ClaimValue)
select u.Id, 'http://Paxol/Employee/DeductionDates', 1 from AspNetUsers u, AspNetUserRoles ur, AspNetRoles r
where u.Id=ur.UserId and ur.RoleId=r.Id
and r.Id>=10;
insert into AspNetUserClaims(UserId, ClaimType, ClaimValue)
select u.Id, 'http://Paxol/Payroll/SchedulePayroll', 1 from AspNetUsers u, AspNetUserRoles ur, AspNetRoles r
where u.Id=ur.UserId and ur.RoleId=r.Id
and r.Id>=90;
end
/****** Object:  StoredProcedure [dbo].[GetExtractAccumulation]    Script Date: 26/01/2020 10:51:50 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesYTD]    Script Date: 26/01/2020 10:51:50 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesYTD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeesYTD]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesAccumulation]    Script Date: 26/01/2020 10:51:50 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeesAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyTaxAccumulation]    Script Date: 26/01/2020 10:51:50 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyTaxAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyTaxAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyTaxAccumulation]    Script Date: 26/01/2020 10:51:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCompanyTaxAccumulation]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@startdate smalldatetime,
	@enddate smalldatetime,
	@includeVoids bit = 0,
	@includeTaxes bit = 0,
	@includeDeductions bit = 0,
	@includeCompensations bit = 0,
	@includeWorkerCompensations bit = 0,
	@includeDailyAccumulation bit = 0,
	@includeMonthlyAccumulation bit = 0,
	@includePayCodes bit = 0,
	@includeHistory bit = 0,
	@includeC1095 bit = 0,
	@includeClients bit = 0,
	@includeTaxDelayed bit = 0,
	@includeMedicareExtraWage bit = 0,
	@report varchar(max) = 'PayrollSummary',
	@extractDepositName varchar(max) ='',
	@state int = null
AS
BEGIN
declare @hostL uniqueidentifier = @host,
	@companyL uniqueidentifier = @company,
	@startdateL smalldatetime = @startdate,
	@enddateL smalldatetime = @enddate,
	@includeVoidsL bit = @includeVoids,
	@includeTaxesL bit = @includeTaxes,
	@includeDeductionsL bit = @includeDeductions,
	@includeCompensationsL bit = @includeCompensations,
	@includeWorkerCompensationsL bit = @includeWorkerCompensations,
	@includeDailyAccumulationL bit = @includeDailyAccumulation,
	@includeMonthlyAccumulationL bit = @includeMonthlyAccumulation,
	@includePayCodesL bit = @includePayCodes,
	@includeHistoryL bit = @includeHistory,
	@includeC1095L bit = @includeC1095,
	@includeClientsL bit = @includeClients,
	@includeTaxDelayedL bit = @includeTaxDelayed,
	@reportL varchar(max) = @report,
	@extractDepositNameL varchar(max) =@extractDepositName,
	@includeMedicareExtraWage1 bit  = @includeMedicareExtraWage,
	@MedicareExtraWage decimal(18,2) = 0,
	@stateL int = @state
	
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmp')
)
DROP TABLE #tmp;
create table #tmp(Id int not null Primary Key, CompanyId uniqueidentifier not null);
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckCompanyId] ON #tmp
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

select * into #tmpCompany
	from
	(
		select c.id CompanyId, host.id FilingCompanyId, c.HostId Host
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		and Host.Id=@companyL
		and host.StatusId<>3
		and ((@includeC1095L=1 and host.IsFiler1095=1) or (@includeC1095L=0))
		and ((@includeClientsL=0 and c.Id=@company) or (@includeClientsL=1))
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=1 
		and StatusId<>3
		and Id=@companyL
		and ((@includeC1095L=1 and IsFiler1095=1) or (@includeC1095L=0))
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 
		and StatusId<>3
		and Id=@companyL
		and ((@includeC1095L=1 and IsFiler1095=1) or (@includeC1095L=0))
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and Company.StatusId<>3
		and Parent.Id=@companyL
		and ((@includeC1095L=1 and Parent.IsFiler1095=1) or (@includeC1095L=0))
		and ((@includeClientsL=0 and Company.Id=@companyL) or (@includeClientsL=1))
	)a
	where ((@stateL is null) or (@stateL is not null and exists(select 'x' from CompanyTaxState cts where cts.CompanyId=a.CompanyId and cts.StateId=@stateL)))

insert into #tmp(Id, CompanyId)
	select pc1.Id, pc1.CompanyId
	from PayrollPayCheck pc1
	where 
	pc1.IsVoid=0  and pc1.TaxPayDay between @startdateL and @enddateL
	and pc1.IsHistory<=@includeHistoryL
	and ( pc1.CompanyId in (select CompanyId from #tmpCompany ))
	and ((@stateL is not null and pc1.StateId=@stateL) or (@stateL is null))
	and ( @reportL is null or (
			not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@reportL and [Type]=1)
			and ((@includeTaxDelayedL=1) or (@includeTaxDelayedL=0 and (not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId  and TaxesDelayed=1))))
			and @reportL<>'Report1099'
		)	
	);
	if @includeMedicareExtraWage=1
	begin
		declare @companyTable IdTable
		insert into @companyTable
		select CompanyId as Id from #tmpCompany ;
		declare @mdeStartdate varchar(max) = '1/1/'+cast(year(@startdateL) as varchar(max))
		select @MedicareExtraWage = dbo.GetMedicareExtraWages(@companyTable, @mdeStartdate, @enddateL, 200000);
	end
	declare @year as varchar(max)=cast(year(@startdateL) as varchar(max))
	declare @quarter1sd smalldatetime='1/1/'+@year
	declare @quarter1ed smalldatetime='3/31/'+@year
	declare @quarter2sd smalldatetime='4/1/'+@year
	declare @quarter2ed smalldatetime='6/30/'+@year
	declare @quarter3sd smalldatetime='7/1/'+@year
	declare @quarter3ed smalldatetime='9/30/'+@year
	declare @quarter4sd smalldatetime='10/1/'+@year
	declare @quarter4ed smalldatetime='12/31/'+@year

	declare @month int = month(@enddateL)
	declare @twelve1date smalldatetime = dateadd(month,-2, @endDateL)
	declare @twelve2date smalldatetime = dateadd(month,-1, @endDateL)
	
	declare @twelve1d smalldatetime= cast(month(@twelve1date) as varchar(max)) + '/12/' + cast(year(@twelve1date) as varchar(max)) 
	declare @twelve2d smalldatetime= cast(month(@twelve2date) as varchar(max)) + '/12/' + cast(year(@twelve2date) as varchar(max)) 
	declare @twelve3d smalldatetime= cast(@month as varchar(max)) + '/12/' + @year 
	
	print 'hellp'
	select 
		Company.Id CompanyId, Company.CompanyName, Company.FederalEIN FEIN, Company.FederalPin FPIN,
		(
			select CompanyTaxState.* from CompanyTaxState where CompanyId=Company.Id
			for xml path('ExtractTaxState'), Elements, type
		) States,
		(
			select ctr.Id, ctr.CompanyId, ctr.TaxId, t.Code as TaxCode, ctr.TaxYear, ctr.Rate
			from CompanyTaxRate ctr, Tax t
			where ctr.TaxId=t.Id and ctr.TaxYear=year(@startdateL)
			and ctr.CompanyId=Company.Id
			for xml path('CompanyTaxRate'), Elements, type
		) CompanyTaxRates,
		(
			select sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage, 
				sum(case PaymentMethod when 1 then NetWage else 0 end) CheckPay,
				sum(case PaymentMethod when 1 then 0 else NetWage end) DDPay,
				sum(Quarter1FUTA) Quarter1FUTA, sum(Quarter2FUTA) Quarter2FUTA, sum(Quarter3FUTA) Quarter3FUTA, sum(Quarter4FUTA) Quarter4FUTA,
				sum(Quarter1FUTAWage) Quarter1FUTAWage, sum(Quarter2FUTAWage) Quarter2FUTAWage, sum(Quarter3FUTAWage) Quarter3FUTAWage, sum(Quarter4FUTAWage) Quarter4FUTAWage,
				sum(Immigrants) as Immigrants, 
				(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp) and @twelve1d between pc2.StartDate and pc2.EndDate and pc2.GrossWage>0) Twelve1, 
				(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp) and @twelve2d between pc2.StartDate and pc2.EndDate and pc2.GrossWage>0) Twelve2, 
				(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp) and @twelve3d between pc2.StartDate and pc2.EndDate and pc2.GrossWage>0) Twelve3, 
				count(distinct SSN) EmployeeCount,
				case when @extractDepositNameL='' then 0 else dbo.GetExtractDepositAmount(@extractDepositNameL, @companyL, @startdateL, @enddateL) end DepositAmount,
				(select rate from TaxYearRate where taxyear=year(@startdateL) and TaxId=6) FUTARate, @MedicareExtraWage MedicareExtraWages
			from (
					select 
					pc.id, pc.GrossWage, pc.NetWage, pc.Salary,pc.PaymentMethod, e.SSN,
					case when e.TaxCategory=2 and pc.GrossWage>0 then 1 else 0 end Immigrants,
					
					sum(case when pc.TaxPayDay between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.Amount else 0 end) Quarter1FUTA,
					sum(case when pc.TaxPayDay between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter2FUTA,
					sum(case when pc.TaxPayDay between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter3FUTA,
					sum(case when pc.TaxPayDay between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter4FUTA,
					sum(case when pc.TaxPayDay between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter1FUTAWage,
					sum(case when pc.TaxPayDay between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter2FUTAWage,
					sum(case when pc.TaxPayDay between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter3FUTAWage,
					sum(case when pc.TaxPayDay between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter4FUTAWage
					from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
					where pc.Id=pct.PayCheckId
					and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
					and pc.Id in (select Id from #tmp)
					group by pc.id, pc.GrossWage, pc.NetWage, pc.Salary, pc.PaymentMethod, e.ssn, e.TaxCategory, pc.TaxPayDay, pc.StartDate, pc.EndDate
				)a
			
			for xml path('PayCheckWages'), elements, type
		),
		case when @includeDailyAccumulationL=1 then
		(
			select 
			month(pc.TaxPayDay) Month, day(pc.TaxPayDay) Day,
			sum(case when t.CountryId=1 and t.StateId is null and t.Code<>'FUTA' then pct.Amount else 0 end) Value
			from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
			where pc.Id=pct.PayCheckId
			and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
			and pc.Id in (select Id from #tmp)
			group by pc.TaxPayDay
			for xml path('DailyAccumulation'), elements, type
		) end DailyAccumulations,
		case when @includeMonthlyAccumulationL=1 then
		(
			select 
			month(pc.TaxPayDay) Month,
			sum(case when t.Id<6 then pct.Amount else 0 end) IRS941,
			sum(case when t.Id=6 then pct.Amount else 0 end) IRS940,
			sum(case when t.Id between 7 and 10 then pct.Amount else 0 end) EDD
			from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t
			where pc.Id=pct.PayCheckId
			and pct.TaxId=ty.Id and ty.TaxId=t.Id
			and pc.Id in (select Id from #tmp)
			group by month(pc.TaxPayDay)
			for xml path('MonthlyAccumulation'), elements, type
		) end MonthlyAccumulations,
		case when @includeTaxesL=1 then
		(select pt.TaxId, 
			(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
							case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
							from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
			sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
			from PayCheckTax pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.taxid
			for xml path('PayCheckTax'), elements, type
		) end Taxes,
		case when @includeDeductionsL=1 then
		(select pt.CompanyDeductionId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage, sum(pt.EmployerAmount) YTDEmployer,
			(
				select Id, CompanyId, TypeId, Name as DeductionName, Description, AnnualMax, FloorPerCheck, 
					(select Id, Name, 
					case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category,
					W2_12, W2_13R, R940_R
					from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
				from CompanyDeduction Where Id=pt.CompanyDeductionId 
				for xml path('CompanyDeduction'), elements, type
			) ,
			case when @reportL='Deductions' then
			(
				select pc.Id, pc.EmployeeId, pcd.EmployeeDeductionId TypeId, pcd.Amount EmployeeWithheld, isnull(pcd.EmployerAmount, 0) EmployerWithheld, pc.PayDay 
				from PayrollPayCheck pc, PayCheckDeduction pcd
				where pc.Id=pcd.PayCheckId and pcd.CompanyDeductionId=pt.CompanyDeductionId and pc.Id in (select Id from #tmp)
				and pcd.Amount>0
				for xml path('PayCheckSummaryByType'), elements, type
			)end PayChecks
			from PayCheckDeduction pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.CompanyDeductionId
			for xml path('PayCheckDeduction'), elements, type
		) end Deductions,
		case when @includeCompensationsL=1 then
		(select pt.PayTypeId,
			p.Name PayTypeName, p.IsTip,
			sum(pt.Amount) YTD
			from PayCheckCompensation pt, PayType p
			where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp)
			group by pt.PayTypeId, p.Name, p.IsTip
			for xml path('PayCheckCompensation'), elements, type
		) end Compensations,
		case when @includePayCodesL=1 then
		(select pt.PayCodeId,
			
			sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
			from PayCheckPayCode pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.PayCodeId
			for xml path('PayCheckPayCode'), elements, type
		) end PayCodes,
		case when @includeWorkerCompensationsL=1 then
		(select pt.WorkerCompensationId,			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
			(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type),
			case when @reportL='WorkerCompensations' then
			(
				select pc.Id, pc.EmployeeId, pcd.WorkerCompensationId TypeId, pcd.Amount EmployeeWithheld, pc.PayDay , pcd.Wage EmployeeWage
				from PayrollPayCheck pc, PayCheckWorkerCompensation pcd
				where pc.Id=pcd.PayCheckId and pcd.WorkerCompensationId=pt.WorkerCompensationId and pc.Id in (select Id from #tmp)
				and pcd.Amount>0
				for xml path('PayCheckSummaryByType'), elements, type
			)end PayChecks
			from PayCheckWorkerCompensation pt
			where pt.PayCheckId in (select Id from #tmp)
			group by pt.WorkerCompensationId
			for xml path('PayCheckWorkerCompensation'), elements, type
		) end WorkerCompensations

		From Company
		Where
		((@hostL is not null and Company.HostId=@hostL) or (@hostL is null))
		and ((@companyL is not null and Id=@companyL) or (@companyL is null))
		
		
		for Xml path('Accumulation'), root('AccumulationList') , elements, type
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesAccumulation]    Script Date: 26/01/2020 10:51:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmployeesAccumulation]
	@company uniqueidentifier = null,
	@employee uniqueidentifier = null,
	@startdate smalldatetime,
	@enddate smalldatetime,
	@includeVoids bit = 0,
	@includeTaxes bit = 0,
	@includeDeductions bit = 0,
	@includeCompensations bit = 0,
	@includeWorkerCompensations bit = 0,
	@includeAccumulation bit = 0,
	@includePayCodes bit = 0,
	@includeHistory bit = 0,
	@includeC1095 bit = 0,
	@includeClients bit = 0,
	@includeClientEmployees bit = 0,
	@includeTaxDelayed bit = 0,
	@report varchar(max) = 'PayrollSummary',
	@state int = null
AS
BEGIN

declare @company1 uniqueidentifier = @company,
	@employee1 uniqueidentifier = @employee,
	@startdate1 smalldatetime = @startdate,
	@enddate1 smalldatetime=@enddate,
	@includeVoids1 bit = @includeVoids,
	@includeTaxes1 bit = @includeTaxes,
	@includeDeductions1 bit = @includeDeductions,
	@includeCompensations1 bit = @includeCompensations,
	@includeWorkerCompensations1 bit = @includeWorkerCompensations,
	@includeAccumulation1 bit = @includeAccumulation,
	@includePayCodes1 bit = @includePayCodes,
	@includeHistory1 bit = @includeHistory,
	@includeC10951 bit = @includeC1095,
	@includeClients1 bit = @includeClients,
	@includeClientEmployees1 bit = @includeClientEmployees,
	@includeTaxDelayed1 bit = @includeTaxDelayed,
	@report1 varchar(max) = @report,
	@stateL int = @state

if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmpemployee')
)
DROP TABLE #tmpemployee;
create table #tmpemployee(Id uniqueidentifier not null Primary Key);
CREATE NONCLUSTERED INDEX [IX_tmpEmployeeId] ON #tmpemployee
(
	Id ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmp')
)
DROP TABLE #tmp;
create table #tmp(Id int not null primary key, EmployeeId uniqueidentifier not null, SSN varchar(24) not null, CompanyId uniqueidentifier not null, PayDay datetime not null );
CREATE NOnCLUSTERED INDEX [IX_tmpPaycheckEmployeeId] ON #tmp
(
	
	EmployeeId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckSSN] ON #tmp
(
	SSN ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckCompanyId] ON #tmp
(
	CompanyId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckPayDay] ON #tmp
(
	PayDay Asc
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


declare @ispeo as bit
declare @ishostcompany as bit
declare @islocation as bit
declare @parent as uniqueidentifier
declare @hostid as uniqueidentifier
select @ispeo=fileunderhost, @hostid=HostId, @ishostcompany=IsHostCompany, @islocation=(case when ParentId is null then 0 else 1 end), @parent=ParentId from company where id=@company1
print @ispeo
print @hostid
select id into #tmpComps from company
where 
((@stateL is null) or (@stateL is not null and exists (select 'x' from CompanyTaxState cts where cts.StateId=@stateL and cts.CompanyId=Company.Id) ))
and
(
	(@ispeo=1 and HostId=@hostid and FileUnderHost=1 
		and ((@includeClients1=0 and Id=@company1) or (@includeClients1=1))
	)
or
	(company.StatusId<>3 and @ispeo=0 and id=@company1)
or
	(company.StatusId<>3 and @ispeo=0 and id<>@company1 and @includeClients1=1 and ParentId=@company1)
or
	(company.StatusId<>3 and @ispeo=0 and @islocation=1 and @includeClients1=1 and (id=@parent or ParentId=@parent))
)

;WITH essn AS
(
   SELECT *,
         ROW_NUMBER() OVER (PARTITION BY SSN ORDER BY HireDate) AS rn
   FROM employee 
   where 
   (
		(@report1 in ('W2Employee','W2Employer','SSAW2MagneticReport','SSAW2MagneticEmployerReport') and Companyid =@company1  ) 
		or 
		(@report1 not in ('PayrollSummary','W2Employee','W2Employer','SSAW2MagneticReport','SSAW2MagneticEmployerReport') and CompanyId in (select Id from #tmpComps))
		or 
		(@report1 ='PayrollSummary' and ((@includeClientEmployees1=1 and CompanyId in (select Id from #tmpComps)) or (@includeClientEmployees1=0 and Companyid=@company1)))
	)
   and (@employee1 is null or (@employee1 is not null and Id=@employee1))
)
insert into #tmpemployee(Id)
SELECT Id 
FROM essn
WHERE rn = 1;

Print CAST(GETDATE() as Datetime2(7)) 

insert into #tmp(Id, EmployeeId, SSN, CompanyId, PayDay)
	select pc1.Id, EmployeeId, SSN, pc1.CompanyId, pc1.PayDay
	from PayrollPayCheck pc1, Employee e
	where pc1.IsVoid=0  and pc1.TaxPayDay between @startdate1 and @enddate1
	and pc1.EmployeeId=e.Id
	and ((@includeHistory1=0 and pc1.IsHistory=@includeHistory1) or @includeHistory1=1)
	and ((@company1 is not null and pc1.CompanyId in (select id from #tmpComps)) or (@company1 is null))
	and ((@stateL is not null and pc1.StateId=@stateL) or (@stateL is null))
	and (@report1 is null or (
			not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@report1 and [Type]=1)
			--and InvoiceId is not null
			and ((@includeTaxDelayed1=1) or (@includeTaxDelayed1=0 and (not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId  and TaxesDelayed=1))))
			and @report1<>'Report1099'
		)
	)

	 
	select 
		
		EmployeeJson.Id EmployeeId, EmployeeJson.SSN, EmployeeJson.Department, EmployeeJson.HireDate, EmployeeJson.BirthDate, EmployeeJson.PayType EmpPayType,
		EmployeeJson.Contact ContactStr, EmployeeJson.State StateStr,
		EmployeeJson.FirstName, EmployeeJson.MiddleInitial, EmployeeJson.LastName,
		(select * from CompanyWorkerCompensation where Id=EmployeeJson.WorkerCompensationId for Xml path('CompanyWorkerCompensation'), elements, type),
		(select top(1) CompanyId from #tmp where id in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI) order by Id desc) LastCheckCompany,
		case when @includeC10951=0 then
		(
			select 
			sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage,
			sum(case pc.PaymentMethod when 1 then NetWage else 0 end) CheckPay,
			sum(case pc.PaymentMethod when 1 then 0 else NetWage end) DDPay,
			(select sum(eaca.Amount) from EmployeeACA eaca where eaca.EmployeeId=EmployeeJson.Id and eaca.Year=year(@startdate1)) ACAAmount
			from PayrollPayCheck pc
			where 
			pc.Id in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			for xml path('PayCheckWages'), elements, type
		)
		end,
		case when @includeTaxes1=1 then
		(select pt.TaxId, 
			(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
							case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
							from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
			sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
			from PayCheckTax pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.taxid
			for xml path('PayCheckTax'), elements, type
		) end Taxes,
		case when @includeDeductions1=1 then
		(select pt.CompanyDeductionId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage, sum(pt.EmployerAmount) YTDEmployer,
			(
				select *, 
					(select Id, Name, 
					case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category,
					W2_12, W2_13R, R940_R
					from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) 
				from CompanyDeduction Where Id=pt.CompanyDeductionId for xml auto, elements, type
			) 
			from PayCheckDeduction pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.CompanyDeductionId
			for xml path('PayCheckDeduction'), elements, type
		) end Deductions,
		case when @includeCompensations1=1 then
		(select pt.PayTypeId,
			p.Name PayTypeName, p.IsTip,
			sum(pt.Amount) YTD
			from PayCheckCompensation pt, PayType p
			where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.PayTypeId, p.Name, p.IsTip
			for xml path('PayCheckCompensation'), elements, type
		) end Compensations,
		case when @includePayCodes1=1 then
		(select pt.PayCodeId,
			
			sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
			from PayCheckPayCode pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.PayCodeId
			for xml path('PayCheckPayCode'), elements, type
		) end PayCodes,
		case when @includeWorkerCompensations1=1 then
		(select pt.WorkerCompensationId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
			(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
			from PayCheckWorkerCompensation pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.WorkerCompensationId
			for xml path('PayCheckWorkerCompensation'), elements, type
		) end WorkerCompensations,
		case when @includeAccumulation1=1 then
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName,  pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt, Employee e
			where pc.EmployeeId=e.Id and e.SSN=EmployeeJson.SSN and pc.IsVoid=0 and pc.Id=pta.PayCheckId
			and pc.PayDay <= @enddate1
			and pc.CompanyId in (select id from #tmpcomps)
			and pta.PayTypeId = pt.Id		
			and (year(pta.FiscalStart)=year(@startdate1) or year(pta.fiscalend)=year(@enddate1))
			group by pt.id, pt.Name, pta.fiscalstart, pta.fiscalend
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) 
		end Accumulations,
		case when @includeC10951=1 then
		(
			select 
			GrossWage, Salary, PayCodes PayCodesFlat, TaxPayDay PayDay,
			(	select pt.CompanyDeductionId,			
				pt.Amount, pt.Wage,
				(
					select *, 
						(select Id, Name, 
						case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category
						from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) 
					from CompanyDeduction Where Id=pt.CompanyDeductionId for xml auto, elements, type
				) 
				from PayCheckDeduction pt, CompanyDeduction cd, DeductionType dt
				where pt.PayCheckId=pc.Id
				and pt.CompanyDeductionId=cd.Id and cd.TypeId=dt.Id
				and dt.id=10
				for xml path('PayCheckDeduction'), elements, type
			) Deductions
			from PayrollPayCheck pc
			where 
			pc.Id in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			for xml path('PayCheckSummary1095'), elements, type
		) end PayCheck1095Summaries

		From Employee EmployeeJson
		Where
		EmployeeJson.Id in (select Id from #tmpemployee)
		
		for Xml path('Accumulation'), root('AccumulationList') , elements, type
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesYTD]    Script Date: 26/01/2020 10:51:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmployeesYTD]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@id uniqueidentifier=null,
	@startdate smalldatetime,
	@enddate smalldatetime,
	@includeVoids bit = 0,
	@includeTaxes bit = 0,
	@includeDeductions bit = 0,
	@includeCompensations bit = 0,
	@includeWorkerCompensations bit = 0,
	@includeAccumulation bit = 0,
	@includePayCodes bit = 0,
	@report varchar(max) = null,
	@ssns varchar(max) = null
AS
BEGIN

declare @host1 uniqueidentifier = @host,
	@company1 uniqueidentifier = @company,
	@id1 uniqueidentifier=@id,
	@startdate1 smalldatetime = @startdate,
	@enddate1 smalldatetime = @enddate,
	@includeVoids1 bit = @includeVoids,
	@includeTaxes1 bit = @includeTaxes,
	@includeDeductions1 bit = @includeDeductions,
	@includeCompensations1 bit = @includeCompensations,
	@includeWorkerCompensations1 bit = @includeWorkerCompensations,
	@includeAccumulation1 bit = @includeAccumulation,
	@includePayCodes1 bit = @includePayCodes,
	@report1 varchar(max) = @report,
	@ssns1 varchar(max) = @ssns
	
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmp')
)
DROP TABLE #tmp;
create table #tmp(Id int not null Primary Key, EmployeeId uniqueidentifier not null, SSN varchar(24) not null);
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckCompanyId] ON #tmp
(
	EmployeeId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckSSN] ON #tmp
(
	SSN ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

declare @ispeo as bit
declare @hostid as uniqueidentifier
declare @parent as uniqueidentifier
select @ispeo=fileunderhost, @hostid=HostId, @parent=ParentId from company where id=@company1
print @ispeo
print @hostid
select id into #tmpcomps from company
where 
((@ispeo=1 and HostId=@hostid and FileUnderHost=1)
or
(@ispeo=0 and (id=@company1 or ParentId=@company1))
or
(@ispeo=0 and @parent is not null and (id=@parent or ParentId=@parent))
)


declare @tmpSSNs table (
		ssn varchar(24) not null
	)
	if @ssns1 is not null
		insert into @tmpSSNs
		SELECT 
			 Split.a.value('.', 'VARCHAR(24)') AS ssn  
		FROM  
		(
			SELECT CAST ('<M>' + REPLACE(@ssns1, ',', '</M><M>') + '</M>' AS XML) AS CVS 
		) AS A CROSS APPLY CVS.nodes ('/M') AS Split(a)


	insert into #tmp(Id, EmployeeId, SSN)
	select pc1.Id, EmployeeId, e.SSN into#tmp
	from PayrollPayCheck pc1, Employee e, Company c
	where pc1.IsVoid=0  and pc1.PayDay between @startdate1 and @enddate1
	and pc1.EmployeeId=e.Id
	and pc1.CompanyId = c.Id
	and ((@id1 is not null and EmployeeId=@id1) or (@id1 is null))
	and ((@company1 is not null and pc1.CompanyId in (select id from #tmpcomps)) or (@company1 is null))
	and ((@ssns1 is not null and e.SSN in (select ssn from @tmpSSNs)) or (@ssns1 is null))
		
	
	select 
		EmployeeJson.Id EmployeeId, EmployeeJson.SSN, EmployeeJson.Department, EmployeeJson.HireDate, EmployeeJson.PayType EmpPayType,
		EmployeeJson.Contact ContactStr, 
		EmployeeJson.FirstName, EmployeeJson.MiddleInitial, EmployeeJson.LastName,
		(
			select 
			sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage,
			sum(case pc.PaymentMethod when 1 then NetWage else 0 end) CheckPay,
			sum(case pc.PaymentMethod when 1 then 0 else NetWage end) DDPay
			from PayrollPayCheck pc
			where 
			pc.Id in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			for xml path('PayCheckWages'), elements, type
		),
		
		(select pt.TaxId, 
			(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
							case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
							from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
			sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
			from PayCheckTax pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.taxid
			for xml path('PayCheckTax'), elements, type
		) Taxes,
		
		(select pt.CompanyDeductionId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,sum(pt.EmployerAmount) YTDEmployer,
			(
				select *, 
					(select Id, Name, 
					case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category
					from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) 
				from CompanyDeduction Where Id=pt.CompanyDeductionId for xml auto, elements, type
			) 
			from PayCheckDeduction pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.CompanyDeductionId
			for xml path('PayCheckDeduction'), elements, type
		) Deductions,
		
		(select pt.PayTypeId,
			p.Name PayTypeName, p.IsTip,
			sum(pt.Amount) YTD
			from PayCheckCompensation pt, PayType p
			where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.PayTypeId, p.Name, p.IsTip
			for xml path('PayCheckCompensation'), elements, type
		) Compensations,
		
		(select pt.PayCodeId,
			
			sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
			from PayCheckPayCode pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.PayCodeId
			for xml path('PayCheckPayCode'), elements, type
		)  PayCodes,
		
		(select pt.WorkerCompensationId,
			
			sum(pt.Amount) YTD,
			(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
			from PayCheckWorkerCompensation pt
			where pt.PayCheckId in (select Id from #tmp where SSN= EmployeeJson.SSN collate Latin1_General_CI_AI)
			group by pt.WorkerCompensationId
			for xml path('PayCheckWorkerCompensation'), elements, type
		) WorkerCompensations,
		
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName,  pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed, max(pta.carryover) CarryOver
			from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt, Employee e
			where pc.EmployeeId=e.Id and e.SSN=EmployeeJson.SSN and pc.IsVoid=0 and pc.Id=pta.PayCheckId
			and pc.PayDay <= @enddate1
			and pc.CompanyId in (select id from #tmpcomps)
			and pta.PayTypeId = pt.Id			
			group by pt.id, pt.Name, pta.fiscalstart, pta.fiscalend
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) Accumulations
		
		
		From Employee EmployeeJson, Company
		Where
		EmployeeJson.CompanyId=Company.Id
		and ((@id1 is not null and EmployeeJson.Id=@id1) or (@id1 is null))
		and ((@host1 is not null and Company.HostId=@host1) or (@host1 is null))
		and ((@company1 is not null and EmployeeJson.CompanyId=@company1) or (@company1 is null))
		and ((@ssns1 is not null and EmployeeJson.SSN in (select ssn from @tmpSSNs)) or (@ssns1 is null))
		
		for Xml path('Accumulation'), root('AccumulationList') , elements, type
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetExtractAccumulation]    Script Date: 26/01/2020 10:51:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetExtractAccumulation]
	@startdate datetime,
	@enddate datetime,
	@depositSchedule int = null,
	@report varchar(max),
	@host uniqueidentifier = null,
	@includeVoids bit = 0,
	@includeTaxes bit = 0,
	@includeDeductions bit = 0,
	@includeCompensations bit = 0,
	@includeWorkerCompensations bit = 0,
	@includeDailyAccumulation bit = 0,
	@includeMonthlyAccumulation bit = 0,
	@includePayCodes bit = 0,
	@includeHistory bit = 0,
	@includeC1095 bit =0,
	@CheckEFileFormsFlag bit = 1,
	@CheckTaxPaymentFlag bit = 1,
	@extractDepositName varchar(max) = '',
	@state int = null
	
AS
BEGIN
declare @startdateL datetime = @startdate,
	@enddateL datetime = @enddate,
	@depositScheduleL int = @depositSchedule,
	@reportL varchar(max) = @report,
	@hostL uniqueidentifier = @host,
	@includeVoidsL bit = @includeVoids,
	@includeTaxesL bit = @includeTaxes,
	@includeDeductionsL bit = @includeDeductions,
	@includeCompensationsL bit = @includeCompensations,
	@includeWorkerCompensationsL bit = @includeWorkerCompensations,
	@includeDailyAccumulationL bit = @includeDailyAccumulation,
	@includeMonthlyAccumulationL bit = @includeMonthlyAccumulation,
	@includePayCodesL bit = @includePayCodes,
	@includeHistoryL bit = @includeHistory,
	@includeC1095L bit =@includeC1095,
	@CheckEFileFormsFlagL bit = @CheckEFileFormsFlag,
	@CheckTaxPaymentFlagL bit = @CheckTaxPaymentFlag,
	@extractDepositNameL varchar(max) = @extractDepositName,
	@stateL int = @state
	
if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmpComp')
)
DROP TABLE #tmpComp;

if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmp')
)
DROP TABLE #tmp;

if exists (
    select  * from tempdb.dbo.sysobjects o
    where o.xtype in ('U') 

   and o.id = object_id(N'tempdb..#tmpVoids')
)
DROP TABLE #tmpVoids;

create table #tmp(Id int not null Primary Key, CompanyId uniqueidentifier not null);
CREATE NONCLUSTERED INDEX [IX_tmpPaycheckCompanyId] ON #tmp
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

create table #tmpVoids(Id int not null Primary Key, CompanyId uniqueidentifier not null);
CREATE NONCLUSTERED INDEX [IX_tmpVoidPaycheckCompanyId] ON #tmpVoids
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


	insert into #tmp(Id, CompanyId)
	select pc1.Id, pc1.CompanyId
	from PayrollPayCheck pc1
	where pc1.IsVoid<=@includeVoidsL 
	and ((@reportL<>'InternalPositivePayReport' and pc1.TaxPayDay between @startdateL and @enddateL) or (@reportL='InternalPositivePayReport' and ((pc1.IsReIssued=1 and pc1.ReIssuedDate between @startdateL and @enddateL) or (pc1.IsReIssued=0 and pc1.TaxPayDay between @startdateL and @enddateL))))
	and pc1.IsHistory<=@includeHistoryL
	and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@reportL and [Type]=1)
	--and InvoiceId is not null
	and not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId  and TaxesDelayed=1)
	and pc1.CompanyId in (select Id from Company where StatusId<>3)
	and @reportL<>'Report1099';

	insert into #tmpVoids(Id, CompanyId)
	select Id, CompanyId 
	from PayrollPayCheck pc1
	where IsVoid=1 
	and pc1.IsHistory=0
	and exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@reportL and [Type]=1)
	and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@reportL and [Type]=2)
	and VoidedOn between @startdateL and @enddateL
	and year(TaxPayDay)=year(@startdateL)
	--and InvoiceId is not null
	and not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId  and TaxesDelayed=1)
	and CompanyId in (select Id from Company where StatusId<>3)
	and @reportL<>'Report1099'
	and ((@stateL is not null and pc1.StateId=@stateL) or (@stateL is null))


declare @year as varchar(max)=cast(year(@startdateL) as varchar(max))
	declare @quarter1sd smalldatetime='1/1/'+@year
	declare @quarter1ed smalldatetime='3/31/'+@year
	declare @quarter2sd smalldatetime='4/1/'+@year
	declare @quarter2ed smalldatetime='6/30/'+@year
	declare @quarter3sd smalldatetime='7/1/'+@year
	declare @quarter3ed smalldatetime='9/30/'+@year
	declare @quarter4sd smalldatetime='10/1/'+@year
	declare @quarter4ed smalldatetime='12/31/'+@year

	declare @month int = month(@enddateL)
	declare @twelve1date smalldatetime = dateadd(month,-2, @endDateL)
	declare @twelve2date smalldatetime = dateadd(month,-1, @endDateL)
	
	declare @twelve1d smalldatetime= cast(month(@twelve1date) as varchar(max)) + '/12/' + cast(year(@twelve1date) as varchar(max)) 
	declare @twelve2d smalldatetime= cast(month(@twelve2date) as varchar(max)) + '/12/' + cast(year(@twelve2date) as varchar(max)) 
	declare @twelve3d smalldatetime= cast(@month as varchar(max)) + '/12/' + @year 

select * into #tmpComp
	from
	(
		select c.id CompanyId, host.id FilingCompanyId, c.HostId Host
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		and host.StatusId<>3
		and ((@depositScheduleL is not null and host.DepositSchedule941=@depositScheduleL) or @depositScheduleL is null)
		and ((@hostL is not null and c.HostId=@hostL) or (@hostL is null))
		and ((@includeC1095L=1 and host.IsFiler1095=1) or (@includeC1095L=0))
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 
		and ((@CheckEFileFormsFlagL=1 and ManageEFileForms=1 ) or @CheckEFileFormsFlagL=0)
		and ((@CheckTaxPaymentFlagL=1 and ManageTaxPayment=1 )  or @CheckTaxPaymentFlagL=0)
		and ((@depositScheduleL is not null and DepositSchedule941=@depositScheduleL) or @depositScheduleL is null)
		and ((@hostL is not null and HostId=@hostL) or (@hostL is null))
		and ParentId is null
		and StatusId<>3
		and ((@includeC1095L=1 and IsFiler1095=1) or (@includeC1095L=0))
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 
		and ((@CheckEFileFormsFlagL=1 and Parent.ManageEFileForms=1 ) or @CheckEFileFormsFlagL=0)
		and ((@CheckTaxPaymentFlagL=1 and Parent.ManageTaxPayment=1 )  or @CheckTaxPaymentFlagL=0)
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and Company.StatusId<>3
		and ((@depositScheduleL is not null and Parent.DepositSchedule941=@depositScheduleL) or @depositScheduleL is null)
		and ((@hostL is not null and Parent.HostId=@hostL) or (@hostL is null))
		and ((@includeC1095L=1 and Parent.IsFiler1095=1) or (@includeC1095L=0))
	)a
	where ((@stateL is null) or (@stateL is not null and exists(select 'x' from CompanyTaxState cts where cts.CompanyId=a.CompanyId and cts.StateId=@stateL)))

	select 
	(select 
	Host.*, 
	(
		select HostCompany.*,
		(
			select 
			isnull(ctr.Id,0) Id, Company.Id CompanyId, t.Id TaxId, t.Code as TaxCode, year(@startdateL) TaxYear, isnull(ctr.Rate, t.defaultrate) Rate
			from Tax t left outer join CompanyTaxRate ctr on t.Id=ctr.TaxId and ctr.TaxYear=year(@startdateL) and CompanyId=Company.Id
			where t.IsCompanySpecific=1
			for xml path('CompanyTaxRate'), Elements, type
		) CompanyTaxRates,
		case when @includeC1095L=1 then
		(select Id, CompanyId, TypeId, Name as DeductionName, Description, AnnualMax, FloorPerCheck, 
			(select Id, Name, 
			case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category,
					W2_12, W2_13R, R940_R
			from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
		from CompanyDeduction Where CompanyId=Company.Id 
		for xml path('CompanyDeduction'), elements, type) 
		end Deductions		
		from Company HostCompany where Id=List.FilingCompanyId
		for xml path ('HostCompany'), elements, type
	),
	(
		select * from CompanyTaxState where CompanyId=Company.Id
		for xml path ('ExtractTaxState'), ELEMENTS, type
	) States,
	(
		select *
		from
		(select SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=1 and TargetEntityTypeId=4 and SourceEntityId=Host.Id
		Union
		select SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and (SourceEntityId=Host.CompanyId or SourceEntityId=Company.Id)
		
		)a
		for xml path ('ExtractContact'), ELEMENTS, type
	) Contacts,
	(
		select 
			ExtractCompany.*, IG.GroupNo InsuranceGroup, IG.GroupName InsuranceGroupName,
			
			(select 
				case when @includeC1095L=0 then
				(
				select sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage, 
					sum(case PaymentMethod when 1 then NetWage else 0 end) CheckPay,
					sum(case PaymentMethod when 1 then 0 else NetWage end) DDPay,
					sum(Quarter1FUTA) Quarter1FUTA, sum(Quarter2FUTA) Quarter2FUTA, sum(Quarter3FUTA) Quarter3FUTA, sum(Quarter4FUTA) Quarter4FUTA,
					sum(Quarter1FUTAWage) Quarter1FUTAWage, sum(Quarter2FUTAWage) Quarter2FUTAWage, sum(Quarter3FUTAWage) Quarter3FUTAWage, sum(Quarter4FUTAWage) Quarter4FUTAWage,
					sum(Immigrants) as Immigrants, 
					--sum(Twelve1) Twelve1, 
					--sum(Twelve2) Twelve2, 
					--sum(Twelve3) Twelve3,
					(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id) and @twelve1d between pc2.StartDate and pc2.EndDate  and pc2.GrossWage>0) Twelve1, 
					(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id) and @twelve2d between pc2.StartDate and pc2.EndDate  and pc2.GrossWage>0) Twelve2, 
					(select count(distinct e2.SSN) from PayrollPayCheck pc2, Employee e2 where pc2.EmployeeId=e2.Id and pc2.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id) and @twelve3d between pc2.StartDate and pc2.EndDate  and pc2.GrossWage>0) Twelve3, 
					case when @extractDepositNameL='' then 0 else dbo.GetExtractDepositAmount(@extractDepositNameL, ExtractCompany.Id, @startdateL, @enddateL) end DepositAmount,
					case when @extractDepositNameL='' and @report='TaxReport' then dbo.GetExtractDepositAmount('Federal940', ExtractCompany.Id, @startdateL, @enddateL) else 0 end DepositAmount940,
					case when @extractDepositNameL='' and @report='TaxReport' then dbo.GetExtractDepositAmount('Federal941', ExtractCompany.Id, @startdateL, @enddateL) else 0 end DepositAmount941,
					case when @extractDepositNameL='' and @report='TaxReport' then dbo.GetExtractDepositAmount('StateCAPIT', ExtractCompany.Id, @startdateL, @enddateL) else 0 end DepositAmountCAPIT,
					case when @extractDepositNameL='' and @report='TaxReport' then dbo.GetExtractDepositAmount('StateCAUI', ExtractCompany.Id, @startdateL, @enddateL) else 0 end DepositAmountCAUI
					,
				(select rate from TaxYearRate where taxyear=year(@startdateL) and TaxId=6) FUTARate
				from (
						select 
						pc.id, pc.GrossWage, pc.NetWage, pc.Salary,pc.PaymentMethod,
						case when e.TaxCategory=2 and pc.GrossWage>0 then 1 else 0 end Immigrants,
						
						--case when month(pc.TaxPayDay)=@month-2 and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve1,
						--case when month(pc.TaxPayDay)=@month-1 and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve2,
						--case when month(pc.TaxPayDay)=@month and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve3,
						sum(case when pc.TaxPayDay between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.Amount else 0 end) Quarter1FUTA,
						sum(case when pc.TaxPayDay between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter2FUTA,
						sum(case when pc.TaxPayDay between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter3FUTA,
						sum(case when pc.TaxPayDay between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter4FUTA,
						sum(case when pc.TaxPayDay between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter1FUTAWage,
						sum(case when pc.TaxPayDay between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter2FUTAWage,
						sum(case when pc.TaxPayDay between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter3FUTAWage,
						sum(case when pc.TaxPayDay between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter4FUTAWage
						from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
						where pc.Id=pct.PayCheckId
						and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
						and pc.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id)
						
						and @reportL<>'Report1099'
						group by pc.id, pc.GrossWage, pc.NetWage, pc.Salary, pc.PaymentMethod, e.TaxCategory, pc.TaxPayDay, pc.StartDate, pc.EndDate
					)a
			
				for xml path('PayCheckWages'), elements, type
			) end,
			case when @includeC1095L=0 then
			(
				select pc.Id, pc.TaxPayDay as PayDay, pc.PaymentMethod, pc.CheckNumber, e.FirstName, e.LastName, pc.GrossWage, pc.PEOASOCoCheck, pc.NetWage, pc.IsVoid, pc.CompanyId,
				pc.IsReIssued, pc.OriginalCheckNumber, pc.ReIssuedDate
				from PayrollPayCheck pc, Employee e
				where pc.EmployeeId=e.Id
				and pc.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				for xml path('PayCheckSummary'), elements, type

			) end PayCheckList,
			case when @includeDailyAccumulationL=1 then
			(
				
				select 
				month(pc.TaxPayDay) Month, day(pc.TaxPayDay) Day,
				sum(case when t.CountryId=1 and t.StateId is null and t.Code<>'FUTA' then pct.Amount else 0 end) Value
				from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
				where pc.Id=pct.PayCheckId
				and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
				and pc.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				group by pc.TaxPayDay
				for xml path('DailyAccumulation'), elements, type
				
				
			) end DailyAccumulations,
			case when @includeMonthlyAccumulationL=1 then
			(
				select 
				month(pc.TaxPayDay) Month,
				sum(case when t.Id<6 then pct.Amount else 0 end) IRS941,
				sum(case when t.Id=6 then pct.Amount else 0 end) IRS940,
				sum(case when t.Id between 7 and 10 then pct.Amount else 0 end) EDD
				from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t
				where pc.Id=pct.PayCheckId
				and pct.TaxId=ty.Id and ty.TaxId=t.Id
				and pc.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				
				group by month(pc.TaxPayDay)
				for xml path('MonthlyAccumulation'), elements, type
			) end MonthlyAccumulations,
			case when @includeTaxesL=1 then
			(select pt.TaxId, 
				(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
								case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
								from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
				sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
				from PayCheckTax pt
				where pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id)
						
				group by pt.taxid
				for xml path('PayCheckTax'), elements, type
			) end Taxes,
			case when @includeDeductionsL=1 then
			(select pt.CompanyDeductionId,
			
				sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
				(
					select Id, CompanyId, TypeId, Name as DeductionName, Description, AnnualMax, FloorPerCheck, 
						(select Id, Name, 
						case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category,
					W2_12, W2_13R, R940_R
						from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
					from CompanyDeduction Where Id=pt.CompanyDeductionId 
					for xml path('CompanyDeduction'), elements, type
				) 
				from PayCheckDeduction pt
				where pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id) 
						
				group by pt.CompanyDeductionId
				for xml path('PayCheckDeduction'), elements, type
			) end Deductions,
			case when @includeCompensationsL=1 then
			(select pt.PayTypeId,
				p.Name PayTypeName, p.IsTip,
				sum(pt.Amount) YTD
				from PayCheckCompensation pt, PayType p
				where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id) 
							
				group by pt.PayTypeId, p.Name, p.IsTip
				for xml path('PayCheckCompensation'), elements, type
			) end Compensations,
			case when @includePayCodesL=1 then
			(select pt.PayCodeId,
			
				sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
				from PayCheckPayCode pt
				where pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				
				group by pt.PayCodeId
				for xml path('PayCheckPayCode'), elements, type
			) end PayCodes,
			case when @includeWorkerCompensationsL=1 then
			(select pt.WorkerCompensationId,			
				sum(pt.Amount) YTD,
				(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
				from PayCheckWorkerCompensation pt
				where pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				
				group by pt.WorkerCompensationId
				for xml path('PayCheckWorkerCompensation'), elements, type
			) end WorkerCompensations
			for xml path ('Accumulation'), elements, type
		)Accumulations,
		case when exists(select 'x' from #tmpVoids) then
			(select 
				(
				select sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage, 
					sum(case PaymentMethod when 1 then NetWage else 0 end) CheckPay,
					sum(case PaymentMethod when 1 then 0 else NetWage end) DDPay,
					sum(Quarter1FUTA) Quarter1FUTA, sum(Quarter2FUTA) Quarter2FUTA, sum(Quarter3FUTA) Quarter3FUTA, sum(Quarter4FUTA) Quarter4FUTA,
					sum(Immigrants) as Immigrants, sum(Twelve1) Twelve1, sum(Twelve2) Twelve2, sum(Twelve3) Twelve3
				from (
						select 
						pc.id, pc.GrossWage, pc.NetWage, pc.Salary,pc.PaymentMethod,
						case when e.TaxCategory=2 and pc.GrossWage>0 then 1 else 0 end Immigrants,
						case when month(pc.TaxPayDay)=@month-2 and day(pc.TaxPayDay)=12 and pc.GrossWage>0 then 1 else 0 end Twelve1,
						case when month(pc.TaxPayDay)=@month-1 and day(pc.TaxPayDay)=12 and pc.GrossWage>0 then 1 else 0 end Twelve2,
						case when month(pc.TaxPayDay)=@month and day(pc.TaxPayDay)=12 and pc.GrossWage>0 then 1 else 0 end Twelve3,
						sum(case when pc.TaxPayDay between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.Amount else 0 end) Quarter1FUTA,
						sum(case when pc.TaxPayDay between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter2FUTA,
						sum(case when pc.TaxPayDay between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter3FUTA,
						sum(case when pc.TaxPayDay between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter4FUTA,
						sum(case when pc.TaxPayDay between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter1FUTAWage,
						sum(case when pc.TaxPayDay between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter2FUTAWage,
						sum(case when pc.TaxPayDay between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter3FUTAWage,
						sum(case when pc.TaxPayDay between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.TaxableWage else 0 end) Quarter4FUTAWage
						from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
						where pc.Id=pct.PayCheckId
						and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
						and pc.Id in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id)
						
						and @reportL<>'Report1099'
						group by pc.id, pc.GrossWage, pc.NetWage, pc.Salary, pc.PaymentMethod, e.TaxCategory, pc.TaxPayDay
					)a
			
				for xml path('PayCheckWages'), elements, type
			),
			(
				select pc.Id, pc.TaxPayDay as PayDay, pc.PaymentMethod, pc.CheckNumber, e.FirstName, e.LastName
				from PayrollPayCheck pc, Employee e
				where pc.EmployeeId=e.Id
				and pc.Id in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id)
				for xml path('PayCheckSummary'), elements, type

			) VoidedPayCheckList,
			case when @includeTaxesL=1 then
			(select pt.TaxId, 
				(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
								case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
								from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
				sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
				from PayCheckTax pt
				where pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id)
						
				group by pt.taxid
				for xml path('PayCheckTax'), elements, type
			) end Taxes,
			case when @includeDeductionsL=1 then
			(select pt.CompanyDeductionId,
			
				sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
				(
					select Id, CompanyId, TypeId, Name as DeductionName, Description, AnnualMax, FloorPerCheck, 
						(select Id, Name, 
						case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category,
					W2_12, W2_13R, R940_R
						from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
					from CompanyDeduction Where Id=pt.CompanyDeductionId 
					for xml path('CompanyDeduction'), elements, type
				) 
				from PayCheckDeduction pt
				where pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id) 
						
				group by pt.CompanyDeductionId
				for xml path('PayCheckDeduction'), elements, type
			) end Deductions,
			case when @includeCompensationsL=1 then
			(select pt.PayTypeId,
				p.Name PayTypeName,
				sum(pt.Amount) YTD
				from PayCheckCompensation pt, PayType p
				where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id) 
							
				group by pt.PayTypeId, p.Name
				for xml path('PayCheckCompensation'), elements, type
			) end Compensations,
			case when @includePayCodesL=1 then
			(select pt.PayCodeId,
			
				sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
				from PayCheckPayCode pt
				where pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id)
				
				group by pt.PayCodeId
				for xml path('PayCheckPayCode'), elements, type
			) end PayCodes,
			case when @includeWorkerCompensationsL=1 then
			(select pt.WorkerCompensationId,			
				sum(pt.Amount) YTD,
				(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
				from PayCheckWorkerCompensation pt
				where pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id)
				
				group by pt.WorkerCompensationId
				for xml path('PayCheckWorkerCompensation'), elements, type
			) end WorkerCompensations
			for xml path ('Accumulation'), elements, type
		) end VoidedAccumulations,
		
		case when @reportL='Report1099' then
			(
				select *, 
				(select sum(amount) from CheckbookJournal where CompanyId=ExtractCompany.Id and TransactionType=2 and PayeeId=VendorCustomer.Id and EntityType=15 and IsVoid=0 and TransactionDate between @startdateL and @enddateL) Amount 
				from VendorCustomer
				where CompanyId=ExtractCompany.Id and IsVendor=1 and StatusId=1 and IsVendor1099=1
				and @reportL='Report1099'
				for xml path ('ExtractVendor'), ELEMENTS, type
			)
			end Vendors
		from Company ExtractCompany, insuranceGroup IG
		Where 
		ExtractCompany.InsuranceGroupNo = IG.Id
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)
		and (
		(exists(select 'x' from #tmp where CompanyId=ExtractCompany.Id) and @reportL<>'Report1099' and @includeC1095L=0)
		or
		(@reportL='Report1099')
		or
		(@includeC1095L=1)
		)
		for xml path ('ExtractDBCompany'), Elements, type

	)Companies
	 from
	Company, (select distinct FilingCompanyId, Host from #tmpComp) List, Host
	where Company.Id=List.FilingCompanyId
	and Company.HostId = Host.Id
	and (
		(exists(select 'x' from #tmp where CompanyId in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)) and @reportL<>'Report1099')
		or
		(@reportL='Report1099')
		)
	--and Host.CompanyId=List.FilingCompanyId
	for xml path('ExtractHostDB'), ELEMENTS, type
	) Hosts
	for xml path('ExtractResponseDB'), ELEMENTS, type
	
	
	
	

END
GO

/****** Object:  StoredProcedure [dbo].[GetExtractDashboard]    Script Date: 31/01/2020 11:14:03 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractDashboard]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyDashboard]    Script Date: 31/01/2020 11:14:03 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyDashboard]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyDashboard]    Script Date: 31/01/2020 11:14:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCompanyDashboard]
	@company uniqueidentifier
AS
BEGIN
	declare @year int = case when exists(select 'x' from Payroll where companyid=@company and year(TaxPayDay)=year(getdate())) then year(getdate()) else year(getdate())-1 end
	select
		(
			select * from 
			(
			  select pc.PayDay, count(pc.Id) NoOfChecks, sum(pc.grosswage) GrossWage, sum(pc.netwage) NetWage, sum(pc.employeetaxes) EmployeeTaxes, sum(pc.employertaxes) EmployerTaxes, sum(pc.deductionamount) Deductions,
			  rank() over (Partition by pc.CompanyId order by pc.payday desc) DRank
			  from 
			  Payroll p, PayrollPayCheck pc
			  where p.Id=pc.PayrollId
			  and pc.IsVoid=0
			  and pc.CompanyId=@company 
			  and p.IsHistory=0
			  and p.IsVoid=0
			  and year(pc.TaxPayDay)=@year
			  group by pc.PayDay, pc.CompanyId
			)
			a
			for xml path('PayrollMetricJson'), elements, type
		)PayrollHistory,
		(SELECT *  FROM 
			( 
			  SELECT me.ExtractName, me.DepositDate, sum(pct.amount) Amount,
				RANK() OVER (PARTITION BY ExtractName ORDER BY DepositDate DESC) DRank
				FROM MasterExtracts me, PayCheckExtract pce, PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr
				where me.Id=pce.MasterExtractId and pce.PayrollPayCheckId=pc.Id
				and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and 
				((me.ExtractName='Federal941' and tyr.TaxId<6) or (me.ExtractName='Federal940' and tyr.TaxId=6) or (me.ExtractName='StateCAPIT' and tyr.TaxId in (7,8)) or (me.ExtractName='StateCAUI' and tyr.TaxId in (9,10)))
				and year(pc.TaxPayDay)=@year
				and pc.CompanyId=@company
				group by me.ExtractName, me.DepositDate
			)a 			
			for xml path('TaxExtractJson'), elements, type
		) ExtractHistory,
		(
			 select * from (select pc.TaxPayDay DepositDate, c.CompanyName, c.DepositSchedule941 Schedule, sum(pct.amount) Amount, 'Federal941' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c, PayrollInvoice pii
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.CompanyId=@company
			  and pc.InvoiceId=pii.Id
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=@year
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId<6
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='Federal941')
			  group by pc.TaxPayDay, c.CompanyName, pii.TaxesDelayed, c.DepositSchedule941
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, 3 Schedule, sum(pct.amount) Amount, 'Federal940' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c, PayrollInvoice pii
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.CompanyId=@company
			  and pc.InvoiceId=pii.Id
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=@year
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId=6
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='Federal940')
			  group by pc.TaxPayDay, c.CompanyName, pii.TaxesDelayed
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, c.DepositSchedule941, sum(pct.amount) Amount, 'StateCAPIT' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c, PayrollInvoice pii
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.CompanyId=@company
			  and pc.InvoiceId=pii.Id
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=@year
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId in (7,8)
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='StateCAPIT')
			  group by pc.TaxPayDay, c.CompanyName, pii.TaxesDelayed, c.DepositSchedule941
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, 3 Schedule, sum(pct.amount) Amount, 'StateCAUI' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c, PayrollInvoice pii
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.CompanyId=@company
			  and pc.InvoiceId=pii.Id
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=@year
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId in (9,10)
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='StateCAUI')
			  group by pc.TaxPayDay, c.CompanyName, pii.TaxesDelayed) a
			for xml path('TaxExtractJson'), elements, type
		)PendingExtracts,
		(	select 
			(
				select  eda.*, d.TargetEntityId DocumentId,
				(select *, (select * from DocumentType where Id=d.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=cd.Id for Xml path('CompanyDocumentSubType'), elements, type),
				(select *, (select * from DocumentType where Id=d.Type for Xml path('DocumentType'), elements, type), (select *, (select * from DocumentType where Id=d.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=d.CompanyDocumentSubType for Xml path('CompanyDocumentSubType'), elements, type) from Document where TargetEntityId=d.TargetEntityId for Xml path('Document'), elements, type) 
				from 
				(select e.Id EmployeeId, (e.FirstName +' '+ e.LastName) EmployeeName, ed.DocumentId, ed.FirstAccessed, ed.LastAccessed 
				from Employee e left outer join EmployeeDocumentAccess ed on e.Id=ed.EmployeeId
				where e.CompanyId=@company) eda
				left outer join
				Document d on eda.DocumentId=d.TargetEntityId or eda.DocumentId is null
				inner join CompanyDocumentSubType cd on d.Type=cd.Type and d.CompanyDocumentSubType=cd.Id	
				where cd.TrackAccess=1 and cd.CompanyId=@company 
				and cd.Type in (3,4)
				order by eda.EmployeeName
				for xml path('EmployeeDocumentAccess'), elements, type
			) EmployeeDocumentAccesses,
			(
				select eda.*, 
				(select *, (select * from DocumentType where Id=cd.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=cd.Id for Xml path('CompanyDocumentSubType'), elements, type),
	 
				cd.CompanyId, 
				(select *, (select * from DocumentType where Id=cd.Type for Xml path('DocumentType'), elements, type), (select *, (select * from DocumentType where Id=cd.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=cd.Id for Xml path('CompanyDocumentSubType'), elements, type) 
				from Document where TargetEntityId=eda.DocumentId for Xml path('Document'), elements, type) 
				from 
				(select e.Id EmployeeId, (e.FirstName +' '+ e.LastName) EmployeeName, ed.DocumentId, ed.CompanyDocumentSubType, ed.DateUploaded, ed.UploadedBy 
					from Employee e left outer join EmployeeDocument ed on e.Id=ed.EmployeeId
					where e.CompanyId=@company) eda
					left outer join CompanyDocumentSubType cd on eda.CompanyDocumentSubType=cd.Id or eda.CompanyDocumentSubType is null	
				where cd.CompanyId=@company 
				and cd.Type in (5) 
				order by eda.EmployeeName, eda.DocumentId
				for xml path('EmployeeDocument'), elements, type
			) EmployeeDocumentRequirements 
		for xml path('EmployeeDocumentMetaData'), elements, type
		)
	for xml Path('CompanyDashboardJson'), elements, type
END
GO
/****** Object:  StoredProcedure [dbo].[GetExtractDashboard]    Script Date: 31/01/2020 11:14:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetExtractDashboard]
	
AS
BEGIN
	select
		(SELECT *  FROM 
			( 
			  SELECT me.ExtractName, me.DepositDate, sum(pct.amount) Amount,
				RANK() OVER (PARTITION BY ExtractName ORDER BY DepositDate DESC) DRank
				FROM MasterExtracts me, PayCheckExtract pce, PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr
				where me.Id=pce.MasterExtractId and pce.PayrollPayCheckId=pc.Id
				and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and 
				((me.ExtractName='Federal941' and tyr.TaxId<6) or (me.ExtractName='Federal940' and tyr.TaxId=6) or (me.ExtractName='StateCAPIT' and tyr.TaxId in (7,8)) or (me.ExtractName='StateCAUI' and tyr.TaxId in (9,10)))
				and year(pc.TaxPayDay)=year(getdate())
				group by me.ExtractName, me.DepositDate
			)a 			
			for xml path('TaxExtractJson'), elements, type
		) ExtractHistory,
		(
			 select * from (select pc.TaxPayDay DepositDate, c.CompanyName, c.DepositSchedule941 Schedule, pii.TaxesDelayed, sum(pct.amount) Amount, 'Federal941' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c, PayrollInvoice pii
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.InvoiceId=pii.Id
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=year(getdate())
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId<6
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='Federal941')
			  group by pc.TaxPayDay, c.CompanyName, pii.TaxesDelayed, c.DepositSchedule941
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, 3 Schedule, pii.TaxesDelayed, sum(pct.amount) Amount, 'Federal940' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c, PayrollInvoice pii
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pii.id=pc.InvoiceId
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=year(getdate())
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId=6
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='Federal940')
			  group by pc.TaxPayDay, c.CompanyName, pii.TaxesDelayed
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, c.DepositSchedule941 Schedule, pii.TaxesDelayed, sum(pct.amount) Amount, 'StateCAPIT' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c, PayrollInvoice pii
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.InvoiceId=pii.Id
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=year(getdate())
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId in (7,8)
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='StateCAPIT')
			  group by pc.TaxPayDay, c.CompanyName, pii.TaxesDelayed, c.DepositSchedule941
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, 3 Schedule, pii.TaxesDelayed, sum(pct.amount) Amount, 'StateCAUI' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c, PayrollInvoice pii
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pii.id=pc.InvoiceId
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=year(getdate())
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId in (9,10)
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='StateCAUI')
			  group by pc.TaxPayDay, c.CompanyName, pii.TaxesDelayed) a
			for xml path('TaxExtractJson'), elements, type
		)PendingExtracts
	for xml Path('CompanyDashboardJson'), elements, type
END
GO

