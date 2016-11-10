/****** Object:  StoredProcedure [dbo].[GetInvoiceChartData]    Script Date: 10/11/2016 9:58:25 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 10/11/2016 8:00:13 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractData]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 10/11/2016 8:00:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetExtractData]
	@startdate datetime,
	@enddate datetime,
	@depositSchedule int = null,
	@report varchar(max),
	@host uniqueidentifier = null
AS
BEGIN
	select * into #tmpComp
	from
	(
		select c.id CompanyId, host.id FilingCompanyId, c.HostId Host
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		and ((@depositSchedule is not null and c.DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and c.HostId=@host) or (@host is null))
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 and ManageEFileForms=1 and ManageTaxPayment=1
		and ((@depositSchedule is not null and DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and HostId=@host) or (@host is null))
	)a

	select 
	(select 
	Host.*, 
	(
		select HostCompany.*		
		from Company HostCompany where Id=Host.CompanyId
		for xml path (''HostCompany''), elements, type
	),
	(
		select * from CompanyTaxState where CompanyId=Host.CompanyId
		for xml path (''ExtractTaxState''), ELEMENTS, type
	) States,
	(
		select *
		from
		(select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=1 and TargetEntityTypeId=4 and SourceEntityId=Host.Id
		Union
		select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and SourceEntityId=Host.CompanyId
		)a
		for xml path (''ExtractContact''), ELEMENTS, type
	) Contacts,
	(
		select 
			ExtractCompany.*, IG.GroupNo InsuranceGroup, IG.GroupName InsuranceGroupName,
			(
				select * from PayrollPayCheck where CompanyId=ExtractCompany.Id and IsVoid=0 and payday between @startdate and @enddate
				and not exists(select ''x'' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=1)
				and (InvoiceId is null or not exists(select ''x'' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path (''ExtractPayCheck''), ELEMENTS, type
			) PayChecks,
			(
				select * from PayrollPayCheck 
				where CompanyId=ExtractCompany.Id 
				and IsVoid=1 
				and exists(select ''x'' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=1)
				and not exists(select ''x'' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=2)
				and VoidedOn between @startdate and @enddate
				and year(PayDay)=year(@startdate)
				and (InvoiceId is null or not exists(select ''x'' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path (''ExtractPayCheck''), ELEMENTS, type
			) VoidedPayChecks,
			(
				select *, 
				(select sum(amount) from Journal where CompanyId=ExtractCompany.Id and TransactionType=2 and IsVoid=0 and TransactionDate between @startdate and @enddate) Amount 
				from VendorCustomer
				where CompanyId=ExtractCompany.Id and IsVendor=1 and StatusId=1 and IsVendor1099=1
				for xml path (''ExtractVendor''), ELEMENTS, type
			)Vendors
		from Company ExtractCompany, insuranceGroup IG
		Where 
		ExtractCompany.InsuranceGroupNo = IG.Id
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Host.CompanyId)
		for xml path (''ExtractDBCompany''), Elements, type

	)Companies
	 from
	Host, (select distinct FilingCompanyId, Host from #tmpComp) List
	where Host.Id=List.Host
	and Host.CompanyId=List.FilingCompanyId
	for xml path(''ExtractHostDB''), ELEMENTS, type
	) Hosts,
	(
		select *
		from
		MasterExtracts where ExtractName=@report and year(startdate)=year(@startdate)
		for xml path (''MasterExtractDB''), ELEMENTS, type
	) History
	for xml path(''ExtractResponseDB''), ELEMENTS, type
	
	

END
' 
END
GO

/****** Object:  StoredProcedure [dbo].[GetInvoiceChartData]    Script Date: 10/11/2016 9:58:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInvoiceChartData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	--declare @projectNames varchar(max)
	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select c.CompanyName, DateDiff(day, i.invoicedate, getdate()) age1,i.invoicedate,
		case  
			When DateDiff(day, i.invoicedate, getdate())=1 then 1
			when DateDiff(day, i.invoicedate, getdate())=2 then 2
			when DateDiff(day, i.invoicedate, getdate())>2 and DateDiff(day, i.invoicedate, getdate())<5  then 3
			when DateDiff(day, i.invoicedate, getdate())>5 and DateDiff(day, i.invoicedate, getdate())<10  then 5
			when DateDiff(day, i.invoicedate, getdate())>9 and DateDiff(day, i.invoicedate, getdate())<20  then 10
			else
				20
			end 
		Age,
		case  
			When DateDiff(day, i.invoicedate, getdate())=1 then ''1 day''
			when DateDiff(day, i.invoicedate, getdate())=2 then ''2 days''
			when DateDiff(day, i.invoicedate, getdate())>2 and DateDiff(day, i.invoicedate, getdate())<5  then ''3-4 days''
			when DateDiff(day, i.invoicedate, getdate())>5 and DateDiff(day, i.invoicedate, getdate())<10  then ''5-9 days''
			when DateDiff(day, i.invoicedate, getdate())>9 and DateDiff(day, i.invoicedate, getdate())<20  then ''10-20 days''
			else
				''Over 20 days''
			end 
		AgeText,
		i.Id
		into #tmpInspectionData
	from PayrollInvoice i, Company c 
	Where 
	i.CompanyId = c.Id
	--and c.StatusId>1
	and i.Balance>0
	and DateDiff(day, i.invoicedate, getdate()) >0
	and ((@role is not null and @role=''HostStaff'' and c.IsHostCompany=0) 
			or (@role is not null and @role=''CorpStaff'' and (c.HostId<>@rootHost or (c.HostId=@rootHost and c.IsHostCompany=0))) 
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	

	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + '',['' + cast(CompanyName as varchar) + '']'',''['' + cast(CompanyName as varchar)+ '']'')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = ''select (select top(1) AgeText from #tmpInspectionData t Where t.Age=row.Age1) Age, '' +@companies+ '' from (select Age as Age1,''+@companies+'' from
	(select distinct Age, CompanyName , Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in (''+@companies+''))Data)row order by Age1''
	execute(@query)
	
	drop table #tmpInspectionData
END' 
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Common].[DF_Memento_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[Memento] DROP CONSTRAINT [DF_Memento_DateCreated]
END

GO
/****** Object:  Table [Common].[Memento]    Script Date: 10/11/2016 3:09:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND type in (N'U'))
DROP TABLE [Common].[Memento]
GO
/****** Object:  Table [Common].[Memento]    Script Date: 10/11/2016 3:09:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Common].[Memento]') AND type in (N'U'))
BEGIN
CREATE TABLE [Common].[Memento](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Memento] [varchar](max) NOT NULL,
	[OriginatorType] [varchar](max) NOT NULL,
	[SourceTypeId] [int] NOT NULL,
	[MementoId] [uniqueidentifier] NOT NULL,
	[Version] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Common.Memento] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Common].[DF_Memento_DateCreated]') AND type = 'D')
BEGIN
ALTER TABLE [Common].[Memento] ADD  CONSTRAINT [DF_Memento_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
END

GO
