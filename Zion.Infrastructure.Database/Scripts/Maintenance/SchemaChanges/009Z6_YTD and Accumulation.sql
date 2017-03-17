/****** Object:  StoredProcedure [dbo].[GetEmployeesYTD]    Script Date: 14/03/2017 7:04:06 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesYTD]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeesYTD]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyAccumulation]    Script Date: 14/03/2017 7:04:06 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyAccumulation]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckWorkerCompensation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckWorkerCompensation]'))
ALTER TABLE [dbo].[PayCheckWorkerCompensation] DROP CONSTRAINT [FK_PayCheckWorkerCompensation_PayrollPayCheck]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckTax_TaxYearRate]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckTax]'))
ALTER TABLE [dbo].[PayCheckTax] DROP CONSTRAINT [FK_PayCheckTax_TaxYearRate]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckTax_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckTax]'))
ALTER TABLE [dbo].[PayCheckTax] DROP CONSTRAINT [FK_PayCheckTax_PayrollPayCheck]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckPayCode_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckPayCode]'))
ALTER TABLE [dbo].[PayCheckPayCode] DROP CONSTRAINT [FK_PayCheckPayCode_PayrollPayCheck]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckDeduction_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]'))
ALTER TABLE [dbo].[PayCheckDeduction] DROP CONSTRAINT [FK_PayCheckDeduction_PayrollPayCheck]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckDeduction_CompanyDeduction]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]'))
ALTER TABLE [dbo].[PayCheckDeduction] DROP CONSTRAINT [FK_PayCheckDeduction_CompanyDeduction]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckCompensation_PayType]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]'))
ALTER TABLE [dbo].[PayCheckCompensation] DROP CONSTRAINT [FK_PayCheckCompensation_PayType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckCompensation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]'))
ALTER TABLE [dbo].[PayCheckCompensation] DROP CONSTRAINT [FK_PayCheckCompensation_PayrollPayCheck]
GO
/****** Object:  Index [IX_PayCheckPayCode]    Script Date: 14/03/2017 7:04:06 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayCode]') AND name = N'IX_PayCheckPayCode')
DROP INDEX [IX_PayCheckPayCode] ON [dbo].[PayCheckPayCode]
GO
/****** Object:  Index [IX_PayCheckDeduction]    Script Date: 14/03/2017 7:04:06 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]') AND name = N'IX_PayCheckDeduction')
DROP INDEX [IX_PayCheckDeduction] ON [dbo].[PayCheckDeduction]
GO
/****** Object:  Table [dbo].[PayCheckWorkerCompensation]    Script Date: 14/03/2017 7:04:06 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckWorkerCompensation]') AND type in (N'U'))
DROP TABLE [dbo].[PayCheckWorkerCompensation]
GO
/****** Object:  Table [dbo].[PayCheckTax]    Script Date: 14/03/2017 7:04:06 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckTax]') AND type in (N'U'))
DROP TABLE [dbo].[PayCheckTax]
GO
/****** Object:  Table [dbo].[PayCheckPayCode]    Script Date: 14/03/2017 7:04:06 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayCode]') AND type in (N'U'))
DROP TABLE [dbo].[PayCheckPayCode]
GO

/****** Object:  Table [dbo].[PayCheckDeduction]    Script Date: 14/03/2017 7:04:06 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]') AND type in (N'U'))
DROP TABLE [dbo].[PayCheckDeduction]
GO
/****** Object:  Table [dbo].[PayCheckCompensation]    Script Date: 14/03/2017 7:04:06 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]') AND type in (N'U'))
DROP TABLE [dbo].[PayCheckCompensation]
GO
/****** Object:  Table [dbo].[PayCheckCompensation]    Script Date: 14/03/2017 7:04:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayCheckCompensation](
	[PayCheckId] [int] NOT NULL,
	[PayTypeId] [int] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_PayCheckCompensation] PRIMARY KEY CLUSTERED 
(
	[PayCheckId] ASC,
	[PayTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[PayCheckDeduction]    Script Date: 14/03/2017 7:04:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayCheckDeduction](
	[PayCheckId] [int] NOT NULL,
	[EmployeeDeductionId] [int] NOT NULL,
	[CompanyDeductionId] [int] NOT NULL,
	[EmployeeDeductionFlat] [varchar](max) NULL,
	[Method] [int] NOT NULL,
	[Rate] [decimal](18, 2) NOT NULL,
	[AnnualMax] [decimal](18, 2) NULL,
	[Wage] [decimal](18, 2) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_PayCheckDeduction] PRIMARY KEY CLUSTERED 
(
	[PayCheckId] ASC,
	[EmployeeDeductionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayCode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayCheckPayCode](
	[PayCheckId] [int] NOT NULL,
	[PayCodeId] [int] NOT NULL,
	[PayCodeFlat] [varchar](max) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Overtime] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_PayCheckPayCode] PRIMARY KEY CLUSTERED 
(
	[PayCheckId] ASC,
	[PayCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[PayCheckTax]    Script Date: 14/03/2017 7:04:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckTax]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayCheckTax](
	[PayCheckId] [int] NOT NULL,
	[TaxId] [int] NOT NULL,
	[TaxableWage] [decimal](18, 2) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_PayCheckTax] PRIMARY KEY CLUSTERED 
(
	[PayCheckId] ASC,
	[TaxId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[PayCheckWorkerCompensation]    Script Date: 14/03/2017 7:04:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckWorkerCompensation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayCheckWorkerCompensation](
	[PayCheckId] [int] NOT NULL,
	[WorkerCompensationId] [int] NOT NULL,
	[WorkerCompensationFlat] [varchar](max) NOT NULL,
	[Wage] [decimal](18, 2) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_PayCheckWorkerCompensation] PRIMARY KEY CLUSTERED 
(
	[PayCheckId] ASC,
	[WorkerCompensationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Index [IX_PayCheckDeduction]    Script Date: 14/03/2017 7:04:06 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]') AND name = N'IX_PayCheckDeduction')
CREATE NONCLUSTERED INDEX [IX_PayCheckDeduction] ON [dbo].[PayCheckDeduction]
(
	[CompanyDeductionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PayCheckPayCode]    Script Date: 14/03/2017 7:04:06 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayCode]') AND name = N'IX_PayCheckPayCode')
CREATE NONCLUSTERED INDEX [IX_PayCheckPayCode] ON [dbo].[PayCheckPayCode]
(
	[PayCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckCompensation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]'))
ALTER TABLE [dbo].[PayCheckCompensation]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckCompensation_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckCompensation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]'))
ALTER TABLE [dbo].[PayCheckCompensation] CHECK CONSTRAINT [FK_PayCheckCompensation_PayrollPayCheck]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckCompensation_PayType]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]'))
ALTER TABLE [dbo].[PayCheckCompensation]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckCompensation_PayType] FOREIGN KEY([PayTypeId])
REFERENCES [dbo].[PayType] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckCompensation_PayType]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckCompensation]'))
ALTER TABLE [dbo].[PayCheckCompensation] CHECK CONSTRAINT [FK_PayCheckCompensation_PayType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckDeduction_CompanyDeduction]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]'))
ALTER TABLE [dbo].[PayCheckDeduction]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckDeduction_CompanyDeduction] FOREIGN KEY([CompanyDeductionId])
REFERENCES [dbo].[CompanyDeduction] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckDeduction_CompanyDeduction]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]'))
ALTER TABLE [dbo].[PayCheckDeduction] CHECK CONSTRAINT [FK_PayCheckDeduction_CompanyDeduction]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckDeduction_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]'))
ALTER TABLE [dbo].[PayCheckDeduction]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckDeduction_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckDeduction_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckDeduction]'))
ALTER TABLE [dbo].[PayCheckDeduction] CHECK CONSTRAINT [FK_PayCheckDeduction_PayrollPayCheck]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckPayCode_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckPayCode]'))
ALTER TABLE [dbo].[PayCheckPayCode]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckPayCode_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckPayCode_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckPayCode]'))
ALTER TABLE [dbo].[PayCheckPayCode] CHECK CONSTRAINT [FK_PayCheckPayCode_PayrollPayCheck]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckTax_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckTax]'))
ALTER TABLE [dbo].[PayCheckTax]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckTax_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckTax_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckTax]'))
ALTER TABLE [dbo].[PayCheckTax] CHECK CONSTRAINT [FK_PayCheckTax_PayrollPayCheck]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckTax_TaxYearRate]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckTax]'))
ALTER TABLE [dbo].[PayCheckTax]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckTax_TaxYearRate] FOREIGN KEY([TaxId])
REFERENCES [dbo].[TaxYearRate] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckTax_TaxYearRate]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckTax]'))
ALTER TABLE [dbo].[PayCheckTax] CHECK CONSTRAINT [FK_PayCheckTax_TaxYearRate]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckWorkerCompensation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckWorkerCompensation]'))
ALTER TABLE [dbo].[PayCheckWorkerCompensation]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckWorkerCompensation_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckWorkerCompensation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckWorkerCompensation]'))
ALTER TABLE [dbo].[PayCheckWorkerCompensation] CHECK CONSTRAINT [FK_PayCheckWorkerCompensation_PayrollPayCheck]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyAccumulation]    Script Date: 14/03/2017 7:04:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyAccumulation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompanyAccumulation] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompanyAccumulation]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@startdate smalldatetime,
	@enddate smalldatetime,
	@mode int = 0
AS
BEGIN
	declare @year as varchar(max)=cast(year(@startdate) as varchar(max))
	declare @quarter1sd smalldatetime='1/1/'+@year
	declare @quarter1ed smalldatetime='3/31/'+@year
	declare @quarter2sd smalldatetime='4/1/'+@year
	declare @quarter2ed smalldatetime='6/30/'+@year
	declare @quarter3sd smalldatetime='7/1/'+@year
	declare @quarter3ed smalldatetime='9/30/'+@year
	declare @quarter4sd smalldatetime='10/1/'+@year
	declare @quarter4ed smalldatetime='12/31/'+@year

	declare @month int = month(@enddate)
	
	
	select 
		Company.Id CompanyId, Company.CompanyName, Company.FederalEIN FEIN, Company.FederalPin FPIN,
		(
			select CompanyTaxState.* from CompanyTaxState where CompanyId=Company.Id
			for xml path('ExtractTaxState'), Elements, type
		) States,
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
					case when month(pc.payday)=@month-2 and day(pc.payday)=12 and pc.GrossWage>0 then 1 else 0 end Twelve1,
					case when month(pc.payday)=@month-1 and day(pc.payday)=12 and pc.GrossWage>0 then 1 else 0 end Twelve2,
					case when month(pc.payday)=@month and day(pc.payday)=12 and pc.GrossWage>0 then 1 else 0 end Twelve3,
					sum(case when pc.payday between @quarter1sd and @quarter1ed and t.Code='FUTA' then pct.Amount else 0 end) Quarter1FUTA,
					sum(case when pc.payday between @quarter2sd and @quarter2ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter2FUTA,
					sum(case when pc.payday between @quarter3sd and @quarter3ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter3FUTA,
					sum(case when pc.payday between @quarter4sd and @quarter4ed  and t.Code='FUTA' then pct.Amount else 0 end) Quarter4FUTA
					from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
					where pc.IsVoid=0
					and pc.Id=pct.PayCheckId
					and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
					and pc.payday  between @startdate and  @enddate
					and pc.CompanyId=@company
					group by pc.id, pc.GrossWage, pc.NetWage, pc.Salary, pc.PaymentMethod, e.TaxCategory, pc.PayDay
				)a
			
			for xml path('PayCheckWages'), elements, type
		),
		(
			select 
			month(pc.PayDay) Month, day(pc.PayDay) Day,
			sum(case when pc.payday between @quarter1sd and @quarter1ed and t.CountryId=1 and t.StateId is null and t.Code<>'FUTA' then pct.Amount else 0 end) Value
			from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t, Employee e
			where pc.IsVoid=0
			and pc.Id=pct.PayCheckId
			and pct.TaxId=ty.Id and ty.TaxId=t.Id and pc.EmployeeId=e.Id
			and pc.payday  between @startdate and  @enddate
			and pc.CompanyId=@company
			and @mode in (0,7,9)
			group by pc.PayDay
			for xml path('DailyAccumulation'), elements, type
		) DailyAccumulations,
		(
			select 
			month(pc.PayDay) Month,
			sum(case when t.Id<6 then pct.Amount else 0 end) IRS941,
			sum(case when t.Id=6 then pct.Amount else 0 end) IRS940,
			sum(case when t.Id between 7 and 10 then pct.Amount else 0 end) EDD
			from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate ty, tax t
			where pc.IsVoid=0
			and pc.Id=pct.PayCheckId
			and pct.TaxId=ty.Id and ty.TaxId=t.Id
			and pc.payday  between @startdate and  @enddate
			and pc.CompanyId=@company
			and @mode in (0,7,9,11)
			group by month(pc.PayDay)
			for xml path('MonthlyAccumulation'), elements, type
		) MonthlyAccumulations,
		(select pt.TaxId, 
			(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
							case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
							from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
			sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
			from PayrollPayCheck pc, PayCheckTax pt
			where pc.id=pt.paycheckid and pc.IsVoid=0
			and pc.payday  between @startdate and  @enddate
			and pc.CompanyId=Company.Id
			and @mode in (0,1,6,7, 9, 10, 11)
			group by pt.taxid
			for xml path('PayCheckTax'), elements, type
		) Taxes,
		(select pt.CompanyDeductionId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
			(
				select *, 
					(select Id, Name, 
					case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category
					from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type)
				from CompanyDeduction Where Id=pt.CompanyDeductionId 
				for xml path('CompanyDeduction'), elements, type
			) 
			from PayrollPayCheck pc, PayCheckDeduction pt
			where pc.id=pt.paycheckid and pc.IsVoid=0
			and pc.payday  between @startdate and  @enddate
			and pc.CompanyId=Company.Id
			and @mode in (0,2,6,7,10)
			group by pt.CompanyDeductionId
			for xml path('PayCheckDeduction'), elements, type
		) Deductions,
		(select pt.PayTypeId,
			p.Name PayTypeName,
			sum(pt.Amount) YTD
			from PayrollPayCheck pc, PayCheckCompensation pt, PayType p
			where pt.PayTypeId=p.Id and pc.id=pt.paycheckid and pc.IsVoid=0
			and pc.payday  between @startdate and  @enddate
			and pc.CompanyId=Company.Id
			and @mode in (0,3,6,7,11)
			group by pt.PayTypeId, p.Name
			for xml path('PayCheckCompensation'), elements, type
		) Compensations,
		(select pt.PayCodeId,
			
			sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
			from PayrollPayCheck pc, PayCheckPayCode pt
			where pc.id=pt.PayCheckId and pc.IsVoid=0
			and pc.payday  between @startdate and  @enddate
			and pc.CompanyId=Company.Id
			and @mode in (0,4,8)
			group by pt.PayCodeId
			for xml path('PayCheckPayCode'), elements, type
		) PayCodes,
		(select pt.WorkerCompensationId,			
			sum(pt.Amount) YTD,
			(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
			from PayrollPayCheck pc, PayCheckWorkerCompensation pt
			where pc.id=pt.PayCheckId and pc.IsVoid=0
			and pc.payday  between @startdate and  @enddate
			and pc.CompanyId=Company.Id
			and @mode in (0,4)
			group by pt.WorkerCompensationId
			for xml path('PayCheckWorkerCompensation'), elements, type
		) WorkerCompensations

		From Company
		Where
		((@host is not null and Company.HostId=@host) or (@host is null))
		and ((@company is not null and Id=@company) or (@company is null))
		
		
		for Xml path('Accumulation'), root('AccumulationList') , elements, type
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesYTD]    Script Date: 14/03/2017 7:04:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeesYTD]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetEmployeesYTD] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetEmployeesYTD]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@id uniqueidentifier=null,
	@startdate smalldatetime,
	@enddate smalldatetime,
	@mode int = 0
AS
BEGIN
	
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
			where pc.IsVoid=0
			and pc.payday  between @startdate and  @enddate
			and pc.EmployeeId=EmployeeJson.Id
			for xml path('PayCheckWages'), elements, type
		),
		(select pt.TaxId, 
			(select ty.Id, t.Code, t.Name, t.CountryId, t.StateId, t.DefaultRate, ty.Rate, ty.AnnualMaxPerEmployee AnnualMax, t.IsCompanySpecific, 
							case t.PaidBy when 'Employee' then 1 else 0 end IsEmployeeTax 
							from TaxYearRate ty, Tax t where ty.TaxId=t.Id and ty.Id=pt.taxid for xml path('Tax'), elements, type),
			sum(pt.amount) YTD, sum(pt.taxablewage) YTDWage
			from PayrollPayCheck pc, PayCheckTax pt
			where pc.id=pt.paycheckid and pc.IsVoid=0
			and pc.payday  between @startdate and  @enddate
			and pc.EmployeeId=EmployeeJson.Id
			group by pt.taxid
			for xml path('PayCheckTax'), elements, type
		) Taxes,
		(select pt.CompanyDeductionId,
			
			sum(pt.Amount) YTD, sum(pt.Wage) YTDWage,
			(
				select *, 
					(select Id, Name, 
					case Category when 1 then 'PostTaxDeduction' when 2 then  'PartialPreTaxDeduction' when 3 then 'TotalPreTaxDeduction' else 'Other' end Category
					from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) 
				from CompanyDeduction Where Id=pt.CompanyDeductionId for xml auto, elements, type
			) 
			from PayrollPayCheck pc, PayCheckDeduction pt
			where pc.id=pt.paycheckid and pc.IsVoid=0
			and pc.payday  between @startdate and  @enddate
			and pc.EmployeeId=EmployeeJson.Id
			
			group by pt.CompanyDeductionId
			for xml path('PayCheckDeduction'), elements, type
		) Deductions,
		(select pt.PayTypeId,
			p.Name PayTypeName,
			sum(pt.Amount) YTD
			from PayrollPayCheck pc, PayCheckCompensation pt, PayType p
			where pt.PayTypeId=p.Id and pc.id=pt.paycheckid and pc.IsVoid=0
			and pc.payday  between @startdate and  @enddate
			and pc.EmployeeId=EmployeeJson.Id
			group by pt.PayTypeId, p.Name
			for xml path('PayCheckCompensation'), elements, type
		) Compensations,
		(select pt.PayCodeId,
			
			sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
			from PayrollPayCheck pc, PayCheckPayCode pt
			where pc.id=pt.PayCheckId and pc.IsVoid=0
			and pc.payday  between @startdate and  @enddate
			and pc.EmployeeId=EmployeeJson.Id
			group by pt.PayCodeId
			for xml path('PayCheckPayCode'), elements, type
		) PayCodes,
		(select pt.WorkerCompensationId,
			
			sum(pt.Amount) YTD,
			(select * from CompanyWorkerCompensation Where Id=pt.WorkerCompensationId for Xml auto, elements, type)
			from PayrollPayCheck pc, PayCheckWorkerCompensation pt
			where pc.id=pt.PayCheckId and pc.IsVoid=0
			and pc.payday  between @startdate and  @enddate
			and pc.EmployeeId=EmployeeJson.Id
			group by pt.WorkerCompensationId
			for xml path('PayCheckWorkerCompensation'), elements, type
		) WorkerCompensations,
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName, pta.CarryOver, pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt
			where pc.EmployeeId=EmployeeJson.Id and pc.IsVoid=0 and pc.Id=pta.PayCheckId
			and pta.PayTypeId = pt.Id
			and @enddate between pta.FiscalStart and pta.FiscalEnd
			group by pt.id, pt.Name, pta.carryover, pta.fiscalstart, pta.fiscalend
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) Accumulations,
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName, pta.CarryOver, pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt
			where pc.EmployeeId=EmployeeJson.Id and pc.IsVoid=0 and pc.Id=pta.PayCheckId
			and pta.PayTypeId = pt.Id
			and dateadd(year,-1,@enddate) between pta.FiscalStart and pta.FiscalEnd
			group by pt.id, pt.Name, pta.carryover, pta.fiscalstart, pta.fiscalend
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) PreviousAccumulations

		From Employee EmployeeJson, Company
		Where
		EmployeeJson.CompanyId=Company.Id
		and ((@id is not null and EmployeeJson.Id=@id) or (@id is null))
		and ((@host is not null and Company.HostId=@host) or (@host is null))
		and ((@company is not null and EmployeeJson.CompanyId=@company) or (@company is null))
		
		
		for Xml path('Accumulation'), root('AccumulationList') , elements, type
		
	

END
GO
