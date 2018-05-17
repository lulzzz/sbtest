/****** Object:  Table [dbo].[Journal]    Script Date: 15/05/2018 11:31:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CheckbookJournal](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[TransactionType] [int] NOT NULL,
	[PaymentMethod] [int] NOT NULL,
	[CheckNumber] [int] NOT NULL,
	[PayrollPayCheckId] [int] NULL,
	[EntityType] [int] NOT NULL,
	[PayeeId] [uniqueidentifier] NOT NULL,
	[PayeeName] [varchar](max) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Memo] [varchar](max) NULL,
	[IsDebit] [bit] NOT NULL,
	[IsVoid] [bit] NOT NULL,
	[MainAccountId] [int] NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
	[JournalDetails] [varchar](max) NOT NULL,
	[DocumentId] [uniqueidentifier] NOT NULL,
	[PEOASOCoCheck] [bit] NOT NULL,
	[OriginalDate] [datetime] NULL,
	[IsReIssued] [bit] NOT NULL,
	[OriginalCheckNumber] [int] NULL,
	[ReIssuedDate] [datetime] NULL,
	[PayrollId] [uniqueidentifier] NULL,
	[CompanyIntId] [int] NULL,
 CONSTRAINT [PK_ChecbookJournal] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Index [IX_JournalCheckNumber]    Script Date: 15/05/2018 11:31:49 AM ******/
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalCheckNumber] ON [dbo].[CheckbookJournal]
(
	[CheckNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_JournalCompanyId]    Script Date: 15/05/2018 11:31:49 AM ******/
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalCompanyId] ON [dbo].[CheckbookJournal]
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_JournalCompanyIntId]    Script Date: 15/05/2018 11:31:49 AM ******/
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalCompanyIntId] ON [dbo].[CheckbookJournal]
(
	[CompanyIntId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_JournalIsDebit]    Script Date: 15/05/2018 11:31:49 AM ******/
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalIsDebit] ON [dbo].[CheckbookJournal]
(
	[IsDebit] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_JournalIsVoid]    Script Date: 15/05/2018 11:31:49 AM ******/
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalIsVoid] ON [dbo].[CheckbookJournal]
(
	[IsVoid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_JournalMainAccountId]    Script Date: 15/05/2018 11:31:49 AM ******/
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalMainAccountId] ON [dbo].[CheckbookJournal]
(
	[MainAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO

/****** Object:  Index [IX_JournalPEOASOCoCheck]    Script Date: 15/05/2018 11:31:49 AM ******/
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalPEOASOCoCheck] ON [dbo].[CheckbookJournal]
(
	[PEOASOCoCheck] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [IX_JournalTransactionDate]    Script Date: 15/05/2018 11:31:49 AM ******/
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalTransactionDate] ON [dbo].[CheckbookJournal]
(
	[TransactionDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF, FILLFACTOR = 70) ON [PRIMARY]
GO
/****** Object:  Index [NonClusteredIndex-20180124-101638]    Script Date: 15/05/2018 11:31:49 AM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-CheckbookJournal-TransactionType] ON [dbo].[CheckbookJournal]
(
	[TransactionType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF, FILLFACTOR = 70) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CheckbookJournal] ADD  CONSTRAINT [DF_CheckbookJournal_IsVoid]  DEFAULT ((0)) FOR [IsVoid]
GO
ALTER TABLE [dbo].[CheckbookJournal] ADD  CONSTRAINT [DF_CheckbookJournal_TransactionDate]  DEFAULT (getdate()) FOR [TransactionDate]
GO
ALTER TABLE [dbo].[CheckbookJournal] ADD  CONSTRAINT [DF_CheckbookJournal_LastModified]  DEFAULT (getdate()) FOR [LastModified]
GO
ALTER TABLE [dbo].[CheckbookJournal] ADD  DEFAULT (newid()) FOR [DocumentId]
GO
ALTER TABLE [dbo].[CheckbookJournal] ADD  DEFAULT ((0)) FOR [PEOASOCoCheck]
GO
ALTER TABLE [dbo].[CheckbookJournal] ADD  DEFAULT ((0)) FOR [IsReIssued]
GO
ALTER TABLE [dbo].[CheckbookJournal]  WITH CHECK ADD  CONSTRAINT [FK_CheckbookJournal_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
ALTER TABLE [dbo].[CheckbookJournal] CHECK CONSTRAINT [FK_CheckbookJournal_Company]
GO
ALTER TABLE [dbo].[CheckbookJournal]  WITH CHECK ADD  CONSTRAINT [FK_CheckbookJournal_CompanyAccount] FOREIGN KEY([MainAccountId])
REFERENCES [dbo].[CompanyAccount] ([Id])
GO
ALTER TABLE [dbo].[CheckbookJournal] CHECK CONSTRAINT [FK_CheckbookJournal_CompanyAccount]
GO
ALTER TABLE [dbo].[CheckbookJournal]  WITH CHECK ADD  CONSTRAINT [FK_CheckbookJournal_EntityType] FOREIGN KEY([EntityType])
REFERENCES [dbo].[EntityType] ([EntityTypeId])
GO
ALTER TABLE [dbo].[CheckbookJournal] CHECK CONSTRAINT [FK_CheckbookJournal_EntityType]
GO


set identity_insert [dbo].[CheckbookJournal] On
insert into CheckbookJournal([Id]
      ,[CompanyId]
      ,[TransactionType]
      ,[PaymentMethod]
      ,[CheckNumber]
      ,[PayrollPayCheckId]
      ,[EntityType]
      ,[PayeeId]
      ,[PayeeName]
      ,[Amount]
      ,[Memo]
      ,[IsDebit]
      ,[IsVoid]
      ,[MainAccountId]
      ,[TransactionDate]
      ,[LastModified]
      ,[LastModifiedBy]
      ,[JournalDetails]
      ,[DocumentId]
      ,[PEOASOCoCheck]
      ,[OriginalDate]
      ,[IsReIssued]
      ,[OriginalCheckNumber]
      ,[ReIssuedDate]
      ,[PayrollId]
      ,[CompanyIntId])
select [Id]
      ,[CompanyId]
      ,[TransactionType]
      ,[PaymentMethod]
      ,[CheckNumber]
      ,[PayrollPayCheckId]
      ,[EntityType]
      ,[PayeeId]
      ,[PayeeName]
      ,[Amount]
      ,[Memo]
      ,[IsDebit]
      ,[IsVoid]
      ,[MainAccountId]
      ,[TransactionDate]
      ,[LastModified]
      ,[LastModifiedBy]
      ,[JournalDetails]
      ,[DocumentId]
      ,[PEOASOCoCheck]
      ,[OriginalDate]
      ,[IsReIssued]
      ,[OriginalCheckNumber]
      ,[ReIssuedDate]
      ,[PayrollId]
      ,[CompanyIntId] from Journal where TransactionType>1;
set identity_insert [dbo].[CheckbookJournal] Off
delete from journal where TransactionType>1;

/****** Object:  StoredProcedure [dbo].[GetJournals]    Script Date: 15/05/2018 11:42:50 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetJournals]
GO
/****** Object:  StoredProcedure [dbo].[GetJournalIds]    Script Date: 15/05/2018 11:42:50 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournalIds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetJournalIds]
GO
/****** Object:  StoredProcedure [dbo].[GetJournalIds]    Script Date: 15/05/2018 11:42:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournalIds]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetJournalIds] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetJournalIds]
	@company uniqueidentifier = null,
	@startdate datetime = null,
	@enddate datetime = null,
	@transactiontype int = null,
	@accountid int = null
AS
BEGIN
	
		select 
			Id
		from CheckbookJournal
		where
			 ((@accountid is not null and MainAccountId=@accountid) or @accountid is null)
			and ((@company is not null and CompanyId=@company) or (@company is null)) 
			and ((@transactiontype is not null and TransactionType=@transactiontype) or @transactiontype is null)
			and ((@startdate is not null and TransactionDate>=@startdate) or (@startdate is null)) 
			and ((@enddate is not null and TransactionDate<=@enddate) or (@enddate is null)) 
		Union
		select 
			Journal.Id
		from Journal
		where
			 ((@accountid is not null and MainAccountId=@accountid) or @accountid is null)
			and ((@company is not null and CompanyId=@company) or (@company is null)) 
			and ((@transactiontype is not null and @transactiontype=1) or @transactiontype is null)
			and ((@startdate is not null and TransactionDate>=@startdate) or (@startdate is null)) 
			and ((@enddate is not null and TransactionDate<=@enddate) or (@enddate is null)) 
			
		Order by Id 
		for Xml path('JournalJson'), root('JournalList'), Elements, type
		
	
	
END
GO

/****** Object:  StoredProcedure [dbo].[GetJournals]    Script Date: 17/05/2018 6:50:22 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetJournals]
GO
/****** Object:  StoredProcedure [dbo].[GetJournals]    Script Date: 17/05/2018 6:50:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetJournals] AS' 
END
GO

ALTER PROCEDURE [dbo].[GetJournals]
	@company uniqueidentifier = null,
	@paycheck int=null,
	@startdate datetime = null,
	@enddate datetime = null,
	@id int=null,
	@void int=null,
	@year int = null,
	@transactiontype int = null,
	@accountid int = null,
	@PEOASOCoCheck bit = null,
	@payrollid uniqueidentifier = null,
	@includePayrollJournals bit = 0,
	@includeDetails bit = 1
AS
BEGIN
	declare @where nvarchar(max) = ''
	if @id is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'Id=' + cast(@Id as varchar(max))
	if @payrollid is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollId=''' + cast(@payrollid as varchar(max)) + ''''
	if @accountid is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'MainAccountId=' + cast(@accountid as varchar(max))
	if @company is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'CompanyId=''' + cast(@company as varchar(max)) + ''''
	if @transactiontype is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionType=' + cast(@transactiontype as varchar(max))
	if @startdate is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionDate>=''' + cast(@startdate as varchar(max)) + ''''
	if @enddate is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionDate<=''' + cast(@enddate as varchar(max)) + ''''
	if @PEOASOCoCheck is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PEOASOCoCheck=' + cast(@PEOASOCoCheck as varchar(max))
	if @void is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'IsVoid=' + cast(@void as varchar(max))
	if @year is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'year(TransactionDate)=' + cast(@year as varchar(max))

	declare @query as nvarchar(max) = ''
	set @query = 'select 
			*
		from CheckbookJournal
		where ' + @where
	if @includePayrollJournals=1
	begin
		set @query = @query + ' Union select 
			[Id]
      ,[CompanyId]
      ,[TransactionType]
      ,[PaymentMethod]
      ,[CheckNumber]
      ,[PayrollPayCheckId]
      ,[EntityType]
      ,[PayeeId]
      ,[PayeeName]
      ,[Amount]
      ,[Memo]
      ,[IsDebit]
      ,[IsVoid]
      ,[MainAccountId]
      ,[TransactionDate]
      ,[LastModified]
      ,[LastModifiedBy],'
	  if @includeDetails=1 
		set @query = @query + '[JournalDetails] as JournalDetails, '
		else 
		set @query = @query + ''''' as JournalDetails, '
      --,case when @includeDetails=1 then [JournalDetails] else '' end as JournalDetails
      set @query = @query + '[DocumentId]
      ,[PEOASOCoCheck]
      ,[OriginalDate]
      ,[IsReIssued]
      ,[OriginalCheckNumber]
      ,[ReIssuedDate]
      ,[PayrollId]
      ,[CompanyIntId]
		from Journal
		where ' + @where
	end
	set @query = @query + 'for Xml path(''JournalJson''), root(''JournalList''), Elements, type'
	print @query
	Execute(@query)
	--select 
	--		*
	--	from CheckbookJournal
	--	where
	--		((@id is not null and Id=@id) or (@id is null)) 
	--		and ((@payrollid is null) or (@payrollid is not null and PayrollId = @payrollid))
	--		and ((@paycheck is null) or (@paycheck is not null and PayrollPayCheckId=@paycheck)) 
	--		and ((@accountid is not null and MainAccountId=@accountid) or @accountid is null)
	--		and ((@company is not null and CompanyId=@company) or (@company is null)) 
	--		and ((@transactiontype is not null and TransactionType=@transactiontype) or @transactiontype is null)
	--		and ((@startdate is not null and TransactionDate>=@startdate) or (@startdate is null)) 
	--		and ((@enddate is not null and TransactionDate<=@enddate) or (@enddate is null)) 
			
	--		and ((@PEOASOCoCheck is not null and PEOASOCoCheck=@PEOASOCoCheck) or @PEOASOCoCheck is null)
	--		and ((@void is not null and IsVoid=@void) or (@void is null))			
						
	--		and ((@year is not null and year(TransactionDate)=@year) or @year is null)
	--	Union
	--	select 
	--		[Id]
 --     ,[CompanyId]
 --     ,[TransactionType]
 --     ,[PaymentMethod]
 --     ,[CheckNumber]
 --     ,[PayrollPayCheckId]
 --     ,[EntityType]
 --     ,[PayeeId]
 --     ,[PayeeName]
 --     ,[Amount]
 --     ,[Memo]
 --     ,[IsDebit]
 --     ,[IsVoid]
 --     ,[MainAccountId]
 --     ,[TransactionDate]
 --     ,[LastModified]
 --     ,[LastModifiedBy]
 --     ,case when @includeDetails=1 then [JournalDetails] else '' end as JournalDetails
 --     ,[DocumentId]
 --     ,[PEOASOCoCheck]
 --     ,[OriginalDate]
 --     ,[IsReIssued]
 --     ,[OriginalCheckNumber]
 --     ,[ReIssuedDate]
 --     ,[PayrollId]
 --     ,[CompanyIntId]
	--	from Journal
	--	where
	--		@includePayrollJournals=1 
			
			
	--		and ( @accountid is null or (@accountid is not null and MainAccountId=@accountid))
	--		and ((@company is null) or (@company is not null and CompanyId=@company)) 
	--		and ((@startdate is null) or (@startdate is not null and TransactionDate>=@startdate)) 
	--		and ((@enddate is null) or (@enddate is not null and TransactionDate<=@enddate))
	--		--and ((@PEOASOCoCheck is not null and PEOASOCoCheck=@PEOASOCoCheck) or @PEOASOCoCheck is null) 
	--		--and ((@payrollid is null) or (@payrollid is not null and PayrollId = @payrollid))
	--		--and ((@id is null) or (@id is not null and Id=@id)) 
	--		--and ((@void is null) or (@void is not null and IsVoid=@void))			
			
	--		--and ((@paycheck is null) or (@paycheck is not null and PayrollPayCheckId=@paycheck)) 
			
			
	--		--and ( @year is null or (@year is not null and year(TransactionDate)=@year))

	--	Order by Id 
	--	for Xml path('JournalJson'), root('JournalList'), Elements, type
		
	
	
END


GO

/****** Object:  StoredProcedure [dbo].[GetExtractDataSpecial]    Script Date: 15/05/2018 12:04:00 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractDataSpecial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractDataSpecial]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 15/05/2018 12:04:00 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractData]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractAccumulation]    Script Date: 15/05/2018 12:04:00 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractAccumulation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractAccumulation]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractAccumulation]    Script Date: 15/05/2018 12:04:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractAccumulation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetExtractAccumulation] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetExtractAccumulation]
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
	@includeC1095 bit =0
	
AS
BEGIN
	
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
	where pc1.IsVoid<=@includeVoids 
	and ((@report<>'InternalPositivePayReport' and pc1.TaxPayDay between @startdate and @enddate) or (@report='InternalPositivePayReport' and ((pc1.IsReIssued=1 and pc1.ReIssuedDate between @startdate and @enddate) or (pc1.IsReIssued=0 and pc1.TaxPayDay between @startdate and @enddate))))
	and pc1.IsHistory<=@includeHistory
	and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@report and [Type]=1)
	--and InvoiceId is not null
	and not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId  and TaxesDelayed=1)
	and pc1.CompanyId in (select Id from Company where StatusId<>3)
	and @report<>'Report1099';

	insert into #tmpVoids(Id, CompanyId)
	select Id, CompanyId 
	from PayrollPayCheck pc1
	where IsVoid=1 
	and pc1.IsHistory=0
	and exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@report and [Type]=1)
	and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=pc1.Id and [Extract]=@report and [Type]=2)
	and VoidedOn between @startdate and @enddate
	and year(TaxPayDay)=year(@startdate)
	--and InvoiceId is not null
	and not exists (select 'x' from PayrollInvoice where id=pc1.InvoiceId  and TaxesDelayed=1)
	and CompanyId in (select Id from Company where StatusId<>3)
	and @report<>'Report1099'


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
	

select * into #tmpComp
	from
	(
		select c.id CompanyId, host.id FilingCompanyId, c.HostId Host
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		and host.StatusId<>3
		and ((@depositSchedule is not null and host.DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and c.HostId=@host) or (@host is null))
		and ((@includeC1095=1 and host.IsFiler1095=1) or (@includeC1095=0))
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 and ManageEFileForms=1 and ManageTaxPayment=1
		and ((@depositSchedule is not null and DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and HostId=@host) or (@host is null))
		and ParentId is null
		and StatusId<>3
		and ((@includeC1095=1 and IsFiler1095=1) or (@includeC1095=0))
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 and Parent.ManageEFileForms=1 and Parent.ManageTaxPayment=1
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and Company.StatusId<>3
		and ((@depositSchedule is not null and Parent.DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and Parent.HostId=@host) or (@host is null))
		and ((@includeC1095=1 and Parent.IsFiler1095=1) or (@includeC1095=0))
	)a
	

	select 
	(select 
	Host.*, 
	(
		select HostCompany.*,
		(
			select ctr.Id, ctr.CompanyId, ctr.TaxId, t.Code as TaxCode, ctr.TaxYear, ctr.Rate
			from CompanyTaxRate ctr, Tax t
			where ctr.TaxId=t.Id and ctr.TaxYear=year(@startdate)
			and ctr.CompanyId=Company.Id
			for xml path('CompanyTaxRate'), Elements, type
		) CompanyTaxRates,
		case when @includeC1095=1 then
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
		(select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=1 and TargetEntityTypeId=4 and SourceEntityId=Host.Id
		Union
		select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and (SourceEntityId=Host.CompanyId or SourceEntityId=Company.Id)
		
		)a
		for xml path ('ExtractContact'), ELEMENTS, type
	) Contacts,
	(
		select 
			ExtractCompany.*, IG.GroupNo InsuranceGroup, IG.GroupName InsuranceGroupName,
			
			(select 
				case when @includeC1095=0 then
				(
				select sum(GrossWage) GrossWage, sum(Salary) Salary, sum(NetWage) NetWage, 
					sum(case PaymentMethod when 1 then NetWage else 0 end) CheckPay,
					sum(case PaymentMethod when 1 then 0 else NetWage end) DDPay,
					sum(Quarter1FUTA) Quarter1FUTA, sum(Quarter2FUTA) Quarter2FUTA, sum(Quarter3FUTA) Quarter3FUTA, sum(Quarter4FUTA) Quarter4FUTA,
					sum(Quarter1FUTAWage) Quarter1FUTAWage, sum(Quarter2FUTAWage) Quarter2FUTAWage, sum(Quarter3FUTAWage) Quarter3FUTAWage, sum(Quarter4FUTAWage) Quarter4FUTAWage,
					sum(Immigrants) as Immigrants, sum(Twelve1) Twelve1, sum(Twelve2) Twelve2, sum(Twelve3) Twelve3
				from (
						select 
						pc.id, pc.GrossWage, pc.NetWage, pc.Salary,pc.PaymentMethod,
						case when e.TaxCategory=2 and pc.GrossWage>0 then 1 else 0 end Immigrants,
						case when month(pc.TaxPayDay)=@month-2 and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve1,
						case when month(pc.TaxPayDay)=@month-1 and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve2,
						case when month(pc.TaxPayDay)=@month and 12 between day(pc.StartDate) and day(pc.EndDate) and pc.GrossWage>0 then 1 else 0 end Twelve3,
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
						
						and @report<>'Report1099'
						group by pc.id, pc.GrossWage, pc.NetWage, pc.Salary, pc.PaymentMethod, e.TaxCategory, pc.TaxPayDay, pc.StartDate, pc.EndDate
					)a
			
				for xml path('PayCheckWages'), elements, type
			) end,
			case when @includeC1095=0 then
			(
				select pc.Id, pc.TaxPayDay as PayDay, pc.PaymentMethod, pc.CheckNumber, e.FirstName, e.LastName, pc.GrossWage, pc.PEOASOCoCheck, pc.NetWage, pc.IsVoid, pc.CompanyId,
				pc.IsReIssued, pc.OriginalCheckNumber, pc.ReIssuedDate
				from PayrollPayCheck pc, Employee e
				where pc.EmployeeId=e.Id
				and pc.Id in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				for xml path('PayCheckSummary'), elements, type

			) end PayCheckList,
			case when @includeDailyAccumulation=1 then
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
			case when @includeMonthlyAccumulation=1 then
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
			case when @includeTaxes=1 then
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
			case when @includeDeductions=1 then
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
			case when @includeCompensations=1 then
			(select pt.PayTypeId,
				p.Name PayTypeName,
				sum(pt.Amount) YTD
				from PayCheckCompensation pt, PayType p
				where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id) 
							
				group by pt.PayTypeId, p.Name
				for xml path('PayCheckCompensation'), elements, type
			) end Compensations,
			case when @includePayCodes=1 then
			(select pt.PayCodeId,
			
				sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
				from PayCheckPayCode pt
				where pt.PayCheckId in (select Id from #tmp where CompanyId=ExtractCompany.Id)
				
				group by pt.PayCodeId
				for xml path('PayCheckPayCode'), elements, type
			) end PayCodes,
			case when @includeWorkerCompensations=1 then
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
						
						and @report<>'Report1099'
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
			case when @includeTaxes=1 then
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
			case when @includeDeductions=1 then
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
			case when @includeCompensations=1 then
			(select pt.PayTypeId,
				p.Name PayTypeName,
				sum(pt.Amount) YTD
				from PayCheckCompensation pt, PayType p
				where pt.PayTypeId=p.Id and pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id) 
							
				group by pt.PayTypeId, p.Name
				for xml path('PayCheckCompensation'), elements, type
			) end Compensations,
			case when @includePayCodes=1 then
			(select pt.PayCodeId,
			
				sum(pt.Amount) YTDAmount, sum(pt.Overtime) YTDOvertime
				from PayCheckPayCode pt
				where pt.PayCheckId in (select Id from #tmpVoids where CompanyId=ExtractCompany.Id)
				
				group by pt.PayCodeId
				for xml path('PayCheckPayCode'), elements, type
			) end PayCodes,
			case when @includeWorkerCompensations=1 then
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
		
		case when @report='Report1099' then
			(
				select *, 
				(select sum(amount) from CheckbookJournal where CompanyId=ExtractCompany.Id and TransactionType=2 and PayeeId=VendorCustomer.Id and EntityType=15 and IsVoid=0 and TransactionDate between @startdate and @enddate) Amount 
				from VendorCustomer
				where CompanyId=ExtractCompany.Id and IsVendor=1 and StatusId=1 and IsVendor1099=1
				and @report='Report1099'
				for xml path ('ExtractVendor'), ELEMENTS, type
			)
			end Vendors
		from Company ExtractCompany, insuranceGroup IG
		Where 
		ExtractCompany.InsuranceGroupNo = IG.Id
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)
		and (
		(exists(select 'x' from #tmp where CompanyId=ExtractCompany.Id) and @report<>'Report1099' and @includeC1095=0)
		or
		(@report='Report1099')
		or
		(@includeC1095=1)
		)
		for xml path ('ExtractDBCompany'), Elements, type

	)Companies
	 from
	Company, (select distinct FilingCompanyId, Host from #tmpComp) List, Host
	where Company.Id=List.FilingCompanyId
	and Company.HostId = Host.Id
	and (
		(exists(select 'x' from #tmp where CompanyId in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)) and @report<>'Report1099')
		or
		(@report='Report1099')
		)
	--and Host.CompanyId=List.FilingCompanyId
	for xml path('ExtractHostDB'), ELEMENTS, type
	) Hosts
	for xml path('ExtractResponseDB'), ELEMENTS, type
	
	
	
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 15/05/2018 12:04:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetExtractData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetExtractData]
	@startdate datetime,
	@enddate datetime,
	@depositSchedule int = null,
	@report varchar(max),
	@host uniqueidentifier = null,
	@includeVoids bit = 0
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
		and ((@depositSchedule is not null and host.DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and c.HostId=@host) or (@host is null))
		and c.StatusId<>3
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 
		and ((@report<>'HostWCReport' and ManageEFileForms=1 and ManageTaxPayment=1) or (@report='HostWCReport'))
		and ((@depositSchedule is not null and DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and HostId=@host) or (@host is null))
				and ParentId is null
		and StatusId<>3
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 
		and ((@report<>'HostWCReport' and Parent.ManageEFileForms=1 and Parent.ManageTaxPayment=1) or (@report='HostWCReport'))
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and ((@depositSchedule is not null and Parent.DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and Parent.HostId=@host) or (@host is null))
		and Company.StatusId<>3
	)a

	select 
	(select 
	Host.*, 
	(
		select HostCompany.*		
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
		(select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=1 and TargetEntityTypeId=4 and SourceEntityId=Host.Id
		Union
		select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and (SourceEntityId=Host.CompanyId or SourceEntityId=Company.Id)
		)a
		for xml path ('ExtractContact'), ELEMENTS, type
	) Contacts,
	(
		select 
			ExtractCompany.*, IG.GroupNo InsuranceGroup, IG.GroupName InsuranceGroupName,
			(
				select *
				from PayrollPayCheck where CompanyId=ExtractCompany.Id 
				and IsVoid=0
				and taxpayday between @startdate and @enddate
				and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=1)
				and InvoiceId is not null
				and not exists (select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId  and TaxesDelayed=1)
				and @report<>'Report1099'
				--and (InvoiceId is null or not exists(select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path ('ExtractPayCheck'), ELEMENTS, type
			) PayChecks,
			(
				select *
				 from PayrollPayCheck 
				where CompanyId=ExtractCompany.Id 
				and IsVoid=1 
				and exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=1)
				and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=2)
				and VoidedOn between @startdate and @enddate
				and year(taxpayday)=year(@startdate)
				and InvoiceId is not null
				and not exists (select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId  and TaxesDelayed=1)
				and @report<>'Report1099'
				--and (InvoiceId is null or not exists(select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path ('ExtractPayCheck'), ELEMENTS, type
			) VoidedPayChecks,
			(
				select *, 
				(select sum(amount) from CheckbookJournal where CompanyId=ExtractCompany.Id and TransactionType=2 and PayeeId=VendorCustomer.Id and EntityType=15 and IsVoid=0 and TransactionDate between @startdate and @enddate) Amount 
				from VendorCustomer
				where CompanyId=ExtractCompany.Id and IsVendor=1 and StatusId=1 and IsVendor1099=1
				and @report='Report1099'
				for xml path ('ExtractVendor'), ELEMENTS, type
			)Vendors
		from Company ExtractCompany, insuranceGroup IG
		Where 
		ExtractCompany.InsuranceGroupNo = IG.Id
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)
		for xml path ('ExtractDBCompany'), Elements, type

	)Companies
	 from
	Company, (select distinct FilingCompanyId, Host from #tmpComp) List, Host
	where Company.Id=List.FilingCompanyId
	and Company.HostId = Host.Id
	--and Host.CompanyId=List.FilingCompanyId
	for xml path('ExtractHostDB'), ELEMENTS, type
	) Hosts,
	(
		select *
		from
		MasterExtracts where ExtractName=@report and year(startdate)=year(@startdate)
		and Id=0
		for xml path ('MasterExtractDB'), ELEMENTS, type
	) History
	for xml path('ExtractResponseDB'), ELEMENTS, type
	
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetExtractDataSpecial]    Script Date: 15/05/2018 12:04:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractDataSpecial]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetExtractDataSpecial] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetExtractDataSpecial]
	@startdate datetime,
	@enddate datetime,
	@depositSchedule int = null,
	@report varchar(max),
	@host uniqueidentifier = null,
	@includeVoids bit = 0
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
		and ((@depositSchedule is not null and host.DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and c.HostId=@host) or (@host is null))
		and c.StatusId<>3
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 
		and ((@report<>'HostWCReport' and ManageEFileForms=1 and ManageTaxPayment=1) or (@report='HostWCReport'))
		and ((@depositSchedule is not null and DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and HostId=@host) or (@host is null))
		and ParentId is null
		and StatusId<>3
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 
		and ((@report<>'HostWCReport' and Parent.ManageEFileForms=1 and Parent.ManageTaxPayment=1) or (@report='HostWCReport'))
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and ((@depositSchedule is not null and Parent.DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and Parent.HostId=@host) or (@host is null))
		and Company.StatusId<>3
	)a

	select distinct p.Id into #tmpp
	from Payroll p
	where 
	payday between @startdate and @enddate
	and p.Id not in (
	select distinct p1.Id 
	from Payroll p1, Company c , PayrollInvoice pi
	where month(p1.PayDay)<>month(p1.TaxPayDay)
	and p1.CompanyId=c.Id
	and p1.InvoiceId=pi.Id
	)

	

	select 
	(select 
	Host.*, 
	(
		select HostCompany.*		
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
		(select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=1 and TargetEntityTypeId=4 and SourceEntityId=Host.Id
		Union
		select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and (SourceEntityId=Host.CompanyId or SourceEntityId=Company.Id)
		)a
		for xml path ('ExtractContact'), ELEMENTS, type
	) Contacts,
	(
		select 
			ExtractCompany.*, IG.GroupNo InsuranceGroup, IG.GroupName InsuranceGroupName,
			(
				select *
				from PayrollPayCheck where CompanyId=ExtractCompany.Id 
				and IsVoid=0
				and PayrollId in (select Id from #tmpp)
				and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=1)
				and InvoiceId is not null
				and payday between @startdate and @enddate
				and not exists (select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId  and TaxesDelayed=1)
				and @report<>'Report1099'
				--and (InvoiceId is null or not exists(select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path ('ExtractPayCheck'), ELEMENTS, type
			) PayChecks,
			(
				select *
				 from PayrollPayCheck 
				where CompanyId=ExtractCompany.Id 
				and IsVoid=1 
				and exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=1)
				and not exists(select 'x' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=2)
				and PayrollId in (select Id from #tmpp)
				and VoidedOn between @startdate and @enddate
				and InvoiceId is not null
				and not exists (select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId  and TaxesDelayed=1)
				and @report<>'Report1099'
				--and (InvoiceId is null or not exists(select 'x' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path ('ExtractPayCheck'), ELEMENTS, type
			) VoidedPayChecks,
			(
				select *, 
				(select sum(amount) from CheckbookJournal where CompanyId=ExtractCompany.Id and TransactionType=2 and PayeeId=VendorCustomer.Id and EntityType=15 and IsVoid=0 and TransactionDate between @startdate and @enddate) Amount 
				from VendorCustomer
				where CompanyId=ExtractCompany.Id and IsVendor=1 and StatusId=1 and IsVendor1099=1
				and @report='Report1099'
				for xml path ('ExtractVendor'), ELEMENTS, type
			)Vendors
		from Company ExtractCompany, insuranceGroup IG
		Where 
		ExtractCompany.InsuranceGroupNo = IG.Id
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)
		for xml path ('ExtractDBCompany'), Elements, type

	)Companies
	 from
	Company, (select distinct FilingCompanyId, Host from #tmpComp) List, Host
	where Company.Id=List.FilingCompanyId
	and Company.HostId = Host.Id
	--and Host.CompanyId=List.FilingCompanyId
	for xml path('ExtractHostDB'), ELEMENTS, type
	) Hosts,
	(
		select *
		from
		MasterExtracts where ExtractName=@report and year(startdate)=year(@startdate)
		and Id=0
		for xml path ('MasterExtractDB'), ELEMENTS, type
	) History
	for xml path('ExtractResponseDB'), ELEMENTS, type
	
	

END
GO
/****** Object:  Index [CIX_CheckbookCheckNumber]    Script Date: 15/05/2018 12:15:38 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournalCheckBook]') AND name = N'CIX_CheckbookCheckNumber')
DROP INDEX [CIX_CheckbookCheckNumber] ON [dbo].[CompanyJournalCheckBook] WITH ( ONLINE = OFF )
GO
/****** Object:  View [dbo].[CompanyJournalCheckBook]    Script Date: 15/05/2018 12:15:38 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournalCheckBook]'))
DROP VIEW [dbo].[CompanyJournalCheckBook]
GO
/****** Object:  Index [CIX_PEOCheckNumber]    Script Date: 15/05/2018 12:15:38 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]') AND name = N'CIX_PEOCheckNumber')
DROP INDEX [CIX_PEOCheckNumber] ON [dbo].[CompanyJournal] WITH ( ONLINE = OFF )
GO
/****** Object:  View [dbo].[CompanyJournal]    Script Date: 15/05/2018 12:15:38 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]'))
DROP VIEW [dbo].[CompanyJournal]
GO
/****** Object:  Index [CIX_AccountDebitBalance]    Script Date: 15/05/2018 12:15:38 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookAccountDebitBalance]') AND name = N'CIX_CheckbookAccountDebitBalance')
DROP INDEX [CIX_CheckbookAccountDebitBalance] ON [dbo].[CheckbookAccountDebitBalance] WITH ( ONLINE = OFF )
GO
/****** Object:  View [dbo].[AccountDebitBalance]    Script Date: 15/05/2018 12:15:38 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookAccountDebitBalance]'))
DROP VIEW [dbo].[CheckbookAccountDebitBalance]
GO
/****** Object:  Index [CIX_AccountCreditBalance]    Script Date: 15/05/2018 12:15:38 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookAccountCreditBalance]') AND name = N'CIX_CheckbookAccountCreditBalance')
DROP INDEX [CIX_CheckbookAccountCreditBalance] ON [dbo].[CheckbookAccountCreditBalance] WITH ( ONLINE = OFF )
GO
/****** Object:  View [dbo].[AccountCreditBalance]    Script Date: 15/05/2018 12:15:38 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookAccountCreditBalance]'))
DROP VIEW [dbo].[CheckbookAccountCreditBalance]
GO
/****** Object:  View [dbo].[AccountCreditBalance]    Script Date: 15/05/2018 12:15:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookAccountCreditBalance]'))
EXEC dbo.sp_executesql @statement = N'
CREATE view [dbo].[CheckbookAccountCreditBalance]
With SchemaBinding 
As
select MainAccountId, sum(Amount) Credit, COUNT_BIG(*) counts from dbo.CheckbookJournal where IsVoid=0 and IsDebit=0 group by MainAccountId;
' 
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO
/****** Object:  Index [CIX_AccountCreditBalance]    Script Date: 15/05/2018 12:15:38 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookAccountCreditBalance]') AND name = N'CIX_CheckbookAccountCreditBalance')
CREATE UNIQUE CLUSTERED INDEX [CIX_CheckbookAccountCreditBalance] ON [dbo].[CheckbookAccountCreditBalance]
(
	[MainAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AccountDebitBalance]    Script Date: 15/05/2018 12:15:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookAccountDebitBalance]'))
EXEC dbo.sp_executesql @statement = N'
CREATE view [dbo].[CheckbookAccountDebitBalance]
With SchemaBinding 
As
select MainAccountId, sum(Amount) Debit, COUNT_BIG(*) counts from dbo.CheckbookJournal where IsVoid=0 and IsDebit=1 group by MainAccountId;
' 
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO
/****** Object:  Index [CIX_AccountDebitBalance]    Script Date: 15/05/2018 12:15:38 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookAccountDebitBalance]') AND name = N'CIX_CheckbookAccountDebitBalance')
CREATE UNIQUE CLUSTERED INDEX [CIX_CheckbookAccountDebitBalance] ON [dbo].[CheckbookAccountDebitBalance]
(
	[MainAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  View [dbo].[CompanyJournal]    Script Date: 15/05/2018 12:15:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]'))
EXEC dbo.sp_executesql @statement = N'CREATE view [dbo].[CompanyJournal]
With SchemaBinding 
As
select CompanyIntId, PayrollPayCheckId, PEOASOCoCheck, CheckNumber from dbo.Journal where CheckNumber>0;' 
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO
/****** Object:  Index [CIX_PEOCheckNumber]    Script Date: 15/05/2018 12:15:38 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]') AND name = N'CIX_PEOCheckNumber')
CREATE UNIQUE CLUSTERED INDEX [CIX_PEOCheckNumber] ON [dbo].[CompanyJournal]
(
	[CompanyIntId] ASC,
	[PEOASOCoCheck] ASC,
	[CheckNumber] DESC,
	[PayrollPayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  View [dbo].[CompanyJournalCheckBook]    Script Date: 15/05/2018 12:15:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournalCheckBook]'))
EXEC dbo.sp_executesql @statement = N'CREATE view [dbo].[CompanyJournalCheckBook]
With SchemaBinding 
As
select CompanyIntId, CheckNumber, TransactionType from dbo.CheckbookJournal where CheckNumber>0;' 
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO


/****** Object:  Index [CIX_CheckbookCheckNumber]    Script Date: 15/05/2018 12:15:38 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournalCheckBook]') AND name = N'CIX_CheckbookCheckNumber')
CREATE UNIQUE CLUSTERED INDEX [CIX_CheckbookCheckNumber] ON [dbo].[CompanyJournalCheckBook]
(
	[CompanyIntId] ASC,
	[TransactionType] ASC,
	[CheckNumber] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyAccount]') AND name = N'IX_CompanyAccountUseInPayroll')
CREATE NONCLUSTERED INDEX [IX_CompanyAccountUseInPayroll] ON [dbo].[CompanyAccount]
(
	[UsedInPayroll] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyAccount]') AND name = N'IX_CompanyAccountUseInInvoiceDeposit')
CREATE NONCLUSTERED INDEX [IX_CompanyAccountUseInInvoiceDeposit] ON [dbo].[CompanyAccount]
(
	[UsedInInvoiceDeposit] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND name = N'IX_ACHTransactionOriginatorType')
CREATE NONCLUSTERED INDEX [IX_ACHTransactionOriginatorType] ON [dbo].[ACHTransaction]
(
	[OrignatorType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND name = N'IX_ACHTransactionOriginatorId')
CREATE NONCLUSTERED INDEX [IX_ACHTransactionOriginatorId] ON [dbo].[ACHTransaction]
(
	[OriginatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND name = N'IX_ACHTransactionReceiverType')
CREATE NONCLUSTERED INDEX [IX_ACHTransactionReceiverType] ON [dbo].[ACHTransaction]
(
	[ReceiverType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND name = N'IX_ACHTransactionReceiverId')
CREATE NONCLUSTERED INDEX [IX_ACHTransactionReceiverId] ON [dbo].[ACHTransaction]
(
	[ReceiverId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND name = N'IX_ACHTransactionTransactionDate')
CREATE NONCLUSTERED INDEX [IX_ACHTransactionTransactionDate] ON [dbo].[ACHTransaction]
(
	[TransactionDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransactionExtract]') AND name = N'IX_ACHTransactionExtractTransactionId')
CREATE NONCLUSTERED INDEX [IX_ACHTransactionExtractTransactionId] ON [dbo].[ACHTransactionExtract]
(
	[ACHTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransactionExtract]') AND name = N'IX_ACHTransactionExtractMasterExtractId')
CREATE NONCLUSTERED INDEX [IX_ACHTransactionExtractMasterExtractId] ON [dbo].[ACHTransactionExtract]
(
	[MasterExtractId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyAccount]') AND name = N'IX_CompanyAccountBankAccountId')
CREATE NONCLUSTERED INDEX [IX_CompanyAccountBankAccountId] ON [dbo].[CompanyAccount]
(
	[BankAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeBankAccount]') AND name = N'IX_EmployeeBankAccountBankAccountId')
CREATE NONCLUSTERED INDEX [IX_EmployeeBankAccountBankAccountId] ON [dbo].[EmployeeBankAccount]
(
	[BankAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER FUNCTION [dbo].[GetJournalBalance] 
(
	@accountId int
)
RETURNS decimal(18,2)
AS
BEGIN
	declare @balance decimal(18,2) = 0
	declare @credits decimal(18,2) = 0
	declare @debits decimal(18,2) = 0
	declare @credits1 decimal(18,2) = 0
	declare @debits1 decimal(18,2) = 0

	select @credits = isnull(Credit,0) from AccountCreditBalance where MainAccountId=@accountId;
	select @credits1 = isnull(Credit,0) from CheckbookAccountCreditBalance where MainAccountId=@accountId;
	select @debits = isnull(sum(Debit),0) from AccountDebitBalance where MainAccountId=@accountId;
	select @debits1 = isnull(sum(Debit),0) from CheckbookAccountDebitBalance where MainAccountId=@accountId;
	set @balance = @credits + @credits1 - @debits - @debits1;
	return @balance
END
Go
/****** Object:  StoredProcedure [dbo].[EnsureCheckNumberIntegrity]    Script Date: 17/05/2018 5:28:24 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EnsureCheckNumberIntegrity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[EnsureCheckNumberIntegrity]
GO
/****** Object:  StoredProcedure [dbo].[EnsureCheckNumberIntegrity]    Script Date: 17/05/2018 5:28:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EnsureCheckNumberIntegrity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EnsureCheckNumberIntegrity] AS' 
END
GO
ALTER PROCEDURE [dbo].[EnsureCheckNumberIntegrity]
	@PayrollId uniqueidentifier,
	@PEOASOCoCheck bit
AS
BEGIN
	update pc set pc.CheckNumber=j.CheckNumber
	from PayrollPayCheck pc, Journal j
	where pc.Id=j.PayrollPayCheckId
	and pc.PayrollId=@payrollId
	and ((pc.PEOASOCoCheck=1 and j.PEOASOCoCheck=1) or (pc.PEOASOCoCheck=0 and j.PEOASOCoCheck=0))
	and pc.CheckNumber<>j.CheckNumber;

	if @PEOASOCoCheck=1
	begin
		update j
		set CheckNumber=pc.CheckNumber
		from Journal j, PayrollPayCheck pc
		where j.PayrollPayCheckId=pc.Id
		and pc.PayrollId=@payrollId
		and j.PEOASOCoCheck=0
		and j.CheckNumber<>pc.CheckNumber;

		select pc.Id PayCheckId, j.Id JournalId, pc.CheckNumber
		from Journal j, PayrollPayCheck pc
		where j.PayrollPayCheckId=pc.Id
		and pc.PayrollId=@payrollId
		and j.PEOASOCoCheck=1;
	end
	else
	begin
		select pc.Id PayCheckId, j.Id JournalId, pc.CheckNumber
		from Journal j, PayrollPayCheck pc
		where j.PayrollPayCheckId=pc.Id
		and pc.PayrollId=@payrollId
		and j.PEOASOCoCheck=0;
	end
	
END
GO
