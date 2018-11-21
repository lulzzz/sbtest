IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Journal'
                 AND COLUMN_NAME = 'IsCleared')
Alter table Journal Add IsCleared bit not null Default(0), ClearedBy varchar(max), ClearedOn datetime;
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CheckbookJournal'
                 AND COLUMN_NAME = 'IsCleared')
Alter table CheckbookJournal Add IsCleared bit not null Default(0), ClearedBy varchar(max), ClearedOn datetime;

Go

--Update Journal set IsCleared=1, ClearedBy='System', ClearedOn=getdate();
--Update CheckbookJournal set IsCleared=1, ClearedBy='System', ClearedOn=getdate();
Go
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalIsCleared')
CREATE NONCLUSTERED INDEX [IX_JournalIsCleared] ON [dbo].[Journal]
(
	[IsCleared] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CheckbookJournal]') AND name = N'IX_CheckbookJournalIsCleared')
CREATE NONCLUSTERED INDEX [IX_CheckbookJournalIsCleared] ON [dbo].[CheckbookJournal]
(
	[IsCleared] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[GetJournals]    Script Date: 14/11/2018 5:06:09 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetJournals]
GO
/****** Object:  StoredProcedure [dbo].[GetJournals]    Script Date: 14/11/2018 5:06:09 PM ******/
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
	if @paycheck is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'PayrollPayCheckId=' + cast(@paycheck as varchar(max))
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
      ,[LastModifiedBy],[JournalDetails] as JournalDetails, [DocumentId]
      ,[PEOASOCoCheck]
      ,[OriginalDate]
      ,[IsReIssued]
      ,[OriginalCheckNumber]
      ,[ReIssuedDate]
      ,[PayrollId]
      ,[CompanyIntId], [IsCleared], [ClearedBy], [ClearedOn]
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
      ,[CompanyIntId], [IsCleared], [ClearedBy], [ClearedOn]
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
