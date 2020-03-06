IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyRenewal'
                 AND COLUMN_NAME = 'ReminderDays')
Alter table CompanyRenewal Add ReminderDays int not null default(1);
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Journal'
                 AND COLUMN_NAME = 'ListItems')
Alter table Journal Add ListItems varchar(max);
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CheckbookJournal'
                 AND COLUMN_NAME = 'ListItems')
Alter table CheckbookJournal Add ListItems varchar(max);

Go
/****** Object:  StoredProcedure [dbo].[GetJournals]    Script Date: 5/03/2020 11:05:44 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetJournals]
GO
/****** Object:  StoredProcedure [dbo].[GetJournals]    Script Date: 5/03/2020 11:05:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetJournals]
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
	declare @company1 uniqueidentifier = @company,
	@paycheck1 int=@paycheck,
	@startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@id1 int=@id,
	@void1 int=@void,
	@year1 int = @year,
	@transactiontype1 int = @transactiontype,
	@accountid1 int = @accountid,
	@PEOASOCoCheck1 bit = @PEOASOCoCheck,
	@payrollid1 uniqueidentifier = @payrollid,
	@includePayrollJournals1 bit = @includePayrollJournals,
	@includeDetails1 bit = @includeDetails

	declare @where nvarchar(max) = ''
	if @id1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'Id=' + cast(@Id1 as varchar(max))
	if @paycheck1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'PayrollPayCheckId=' + cast(@paycheck1 as varchar(max))
	if @payrollid1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PayrollId=''' + cast(@payrollid1 as varchar(max)) + ''''
	if @accountid1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'MainAccountId=' + cast(@accountid1 as varchar(max))
	if @company1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'CompanyId=''' + cast(@company1 as varchar(max)) + ''''
	if @transactiontype1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionType=' + cast(@transactiontype1 as varchar(max))
	if @startdate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionDate>=''' + cast(@startdate1 as varchar(max)) + ''''
	if @enddate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'TransactionDate<=''' + cast(@enddate1 as varchar(max)) + ''''
	if @PEOASOCoCheck1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'PEOASOCoCheck=' + cast(@PEOASOCoCheck1 as varchar(max))
	if @void1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'IsVoid=' + cast(@void1 as varchar(max))
	if @year1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'year(TransactionDate)=' + cast(@year1 as varchar(max))

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
      ,[CompanyIntId], [IsCleared], [ClearedBy], [ClearedOn], [ListItems]
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
      ,[CompanyIntId], [IsCleared], [ClearedBy], [ClearedOn], [ListItems]
		from Journal
		where ' + @where
	end
	set @query = @query + 'for Xml path(''JournalJson''), root(''JournalList''), Elements, type'
	print @query
	Execute(@query)
	
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetStaffDashboard]    Script Date: 6/03/2020 7:30:03 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetStaffDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetStaffDashboard]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesRenewalData]    Script Date: 6/03/2020 7:30:03 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesRenewalData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompaniesRenewalData]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesRenewalData]    Script Date: 6/03/2020 7:30:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCompaniesRenewalData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	declare @startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@host1 varchar(max) = @host,
	@role1 varchar(max) = @role,
	@onlyActive1 bit = @onlyActive
	
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select 'GetCompaniesRenewalData' Report;
	select HostId, CompanyId, Host, Company, InvoiceSetup, Description,
			DueDate Due, 
			case when DateDiff(day, getdate(), DueDate) <=15 then 1 when DateDiff(day, getdate(), DueDate) <=30 then 2 when DateDiff(day, getdate(), DueDate) <=60 then 3 else 4 end DueRange
	
	from	
	(select c.Id as CompanyId, c.CompanyName as Company, h.Id as HostId, h.FirmName as Host, cc.InvoiceSetup, cr.description,
		Case
			When cast((cast(cr.[month] as varchar(2)) + '/' + cast(cr.[day] as varchar(2)) + '/' + cast(year(getdate()) as varchar(4))) as datetime)<GETDATE() Then
				cast((cast(cr.[month] as varchar(2)) + '/' + cast(cr.[day] as varchar(2)) + '/' + cast(year(getdate())+1 as varchar(4))) as datetime)
			Else
				cast((cast(cr.[month] as varchar(2)) + '/' + cast(cr.[day] as varchar(2)) + '/' + cast(year(getdate()) as varchar(4))) as datetime)
					
			
		end DueDate
		
	from Company c, Host h , CompanyRenewal cr, CompanyContract cc
	Where 
	c.StatusId=1
	and h.id = c.HostId
	and c.Id=cc.CompanyId
	and c.Id=cr.CompanyId
		and ((@role1 is not null and @role1='HostStaff' and c.IsHostCompany=0) 
			or (@role1 is not null and @role1='CorpStaff' and c.IsHostCompany=0)
			or (@role1 is null))
	and ((@host1 is not null and c.HostId=@host1) or (@host1 is null))
	) a
	where DateDiff(day, getdate(), DueDate)<=90
	
	order by Due


END
GO
/****** Object:  StoredProcedure [dbo].[GetStaffDashboard]    Script Date: 6/03/2020 7:30:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetStaffDashboard]
	@host uniqueidentifier = null
AS
BEGIN
	select
		(SELECT *  FROM 
			( 
			  select c.HostId, p.CompanyId, c.CompanyName, p.LastModifiedBy UserName, p.LastModified TS from payroll p, Company c
				where p.CompanyId=c.Id
				and p.LastModified>DATEADD(day, -15, getdate())
				and ((@host is null) or (c.HostId=@host))
			)a 			
			for xml path('StaffDashboardCubeJson'), elements, type
		) PayrollsProcessed,
		(SELECT *  FROM 
			( 
			  select c.HostId, p.CompanyId, p.CompanyName, p.[User] UserName, p.TS from PayrollVoidLog p, Company c
				where p.CompanyId=c.Id
				and p.TS>DATEADD(day, -15, getdate())
				and ((@host is null) or (c.HostId=@host))
			)a 			
			for xml path('StaffDashboardCubeJson'), elements, type
		) PayrollsVoided,
		--(SELECT *  FROM 
		--	( 
		--	  select c.HostId, p.CompanyId, c.CompanyName, p.ProcessedBy UserName, p.ProcessedOn TS from PayrollInvoice p, Company c
		--		where p.CompanyId=c.Id
		--		and p.ProcessedOn>DATEADD(day, -15, getdate())
		--		and ((@host is null) or (c.HostId=@host))
		--	)a 			
		--	for xml path('StaffDashboardCubeJson'), elements, type
		--) InvoicesCreated,
		(SELECT *  FROM 
			( 
			  select c.HostId, p.CompanyId, c.CompanyName, p.DeliveryClaimedBy UserName, p.ProcessedOn TS from PayrollInvoice p, Company c
				where p.CompanyId=c.Id
				and p.DeliveryClaimedOn>DATEADD(day, -15, getdate())
				and ((@host is null) or (c.HostId=@host))
			)a  			
			for xml path('StaffDashboardCubeJson'), elements, type
		) InvoicesDelivered,
		(SELECT *  FROM 
			( 
			  select c.HostId, c.Id as CompanyId, c.CompanyName, c.LastModifiedBy UserName, c.LastModified TS 
			  from Company c
				where c.LastModified>DATEADD(day, -15, getdate())
				and ((@host is null) or (c.HostId=@host))
			)a  			
			for xml path('StaffDashboardCubeJson'), elements, type
		) CompaniesUpdated,
		(SELECT *  FROM 
			( 
			 select *
	
				from	
				(select c.Id as CompanyId, c.CompanyName, h.Id as HostId, 
					Case
						When c.LastPayrollDate is not null Then
							Case
								When c.PayrollSchedule=1 then
									DateAdd(day, 7, c.LastPayrollDate)
				
								When c.PayrollSchedule=2 then
									DateAdd(day, 14, c.LastPayrollDate)
				
								When c.PayrollSchedule=3 then
									DateAdd(day, 15, c.LastPayrollDate)
				
								When c.PayrollSchedule=4 then
									DateAdd(MONTH, 1, c.LastPayrollDate)
							End
						Else
							Cast('01/01/' + cast(year(getdate()) as varchar(max)) as datetime)
					
			
					end TS, dbo.GetLastBusinessDate() LastBusinessDay
		
				from Company c, Host h
				Where 
				c.StatusId=1
				and h.id = c.HostId
				and ((@host is null) or (c.HostId=@host))
				) a
				where DateDiff(day, dbo.GetLastBusinessDate(), [TS])<16
			)a 			
			for xml path('StaffDashboardCubeJson'), elements, type
		) MissedPayrolls,
		(
			select Host, Company, InvoiceSetup, Description,  DueDate
	
			from	
			(select c.Id as CompanyId, c.CompanyName as Company, h.Id as HostId, h.FirmName as Host, cc.InvoiceSetup, cr.description,
				Case
					When cast((cast(cr.[month] as varchar(2)) + '/' + cast(cr.[day] as varchar(2)) + '/' + cast(year(getdate()) as varchar(4))) as datetime)<GETDATE() Then
						cast((cast(cr.[month] as varchar(2)) + '/' + cast(cr.[day] as varchar(2)) + '/' + cast(year(getdate())+1 as varchar(4))) as datetime)
					Else
						cast((cast(cr.[month] as varchar(2)) + '/' + cast(cr.[day] as varchar(2)) + '/' + cast(year(getdate()) as varchar(4))) as datetime)
					
			
				end DueDate
		
			from Company c, Host h , CompanyRenewal cr, CompanyContract cc
			Where 
			c.StatusId=1
			and h.id = c.HostId
			and c.Id=cc.CompanyId
			and c.Id=cr.CompanyId
				
			and ((@host is not null and c.HostId=@host) or (@host is null))
			) a
			--where DATEDIFF(day, getdate(), DueDate)<15
			for xml path('CompanyDueDateJson'), elements, type
		) RenewalDue

	for xml Path('StaffDashboardJson'), elements, type
END
GO

