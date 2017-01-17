/****** Object:  StoredProcedure [dbo].[GetSearchResults]    Script Date: 16/01/2017 10:45:58 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSearchResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetSearchResults]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 16/01/2017 10:45:58 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithoutInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollsWithoutInvoice]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollChartData]    Script Date: 16/01/2017 10:45:58 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceChartData]    Script Date: 16/01/2017 10:45:58 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetHostAndCompanies]    Script Date: 16/01/2017 10:45:58 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetHostAndCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetHostAndCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 16/01/2017 10:45:58 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractData]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesWithoutPayroll]    Script Date: 16/01/2017 10:45:58 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesWithoutPayroll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompaniesWithoutPayroll]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesNextPayrollChartData]    Script Date: 16/01/2017 10:45:58 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesNextPayrollChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompaniesNextPayrollChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesNextPayrollChartData]    Script Date: 16/01/2017 10:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesNextPayrollChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompaniesNextPayrollChartData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select HostId, CompanyId, Host, Company, 
		case 
			when [Next Payroll]<getdate() then
				''Overdue''
			when DateDiff(day, getdate(), [Next Payroll])=0 then
				''Today''
			when DateDiff(day, getdate(), [Next Payroll])=1 then
				''1 day''
			when DateDiff(day, getdate(), [Next Payroll])=2 then
				''2 days''
			when DateDiff(day, getdate(), [Next Payroll])=3 then
				''3 days''
			when DateDiff(day, getdate(), [Next Payroll])=4 then
				''4 days''
			when DateDiff(day, getdate(), [Next Payroll])=5 then
				''5 days''
			end
			Due
	
	from	
	(select c.Id as CompanyId, c.CompanyName as Company, h.Id as HostId, h.FirmName as Host,
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
				Cast(''01/01/'' + cast(year(getdate()) as varchar(max)) as datetime)
					
			
		end [Next Payroll]
		
	from Company c, Host h 
	Where 
	c.StatusId=1
	and h.id = c.HostId
		and ((@role is not null and @role=''HostStaff'' and c.IsHostCompany=0) 
			or (@role is not null and @role=''CorpStaff'' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	) a
	where DateDiff(day, getdate(), [Next Payroll])<6
	order by Due


END' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesWithoutPayroll]    Script Date: 16/01/2017 10:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesWithoutPayroll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompaniesWithoutPayroll]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select HostId, CompanyId, Host, Company,
		DateDiff(day, CreationDate, getdate() ) [Days past]
	from 
	(select c.Id as CompanyId, c.CompanyName as Company, h.Id as HostId, h.FirmName as Host,
		Case
			When exists(select ''x'' from Common.Memento  where SourceTypeId=2 and MementoId=c.Id) Then
				(select max(DateCreated) from Common.Memento  where SourceTypeId=2 and MementoId=c.Id)
			Else
				c.LastModified
					
			
		end CreationDate
		
	from Company c, Host h 
	Where 
	c.StatusId=1
	and h.id = c.HostId
		and ((@role is not null and @role=''HostStaff'' and c.IsHostCompany=0) 
			or (@role is not null and @role=''CorpStaff'' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and not exists(select ''x'' from Payroll where CompanyId=c.Id)
	)a
	where 
	DateDiff(day, CreationDate, getdate() )>0
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 16/01/2017 10:45:58 PM ******/
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
		
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 and ManageEFileForms=1 and ManageTaxPayment=1
		and ((@depositSchedule is not null and DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and HostId=@host) or (@host is null))
		and ParentId is null
		union
		select Company.id CompanyId, Parent.id FilingCompanyId, Parent.HostId Host
		from Company, Company Parent
		where Parent.FileUnderHost=0 and Parent.ManageEFileForms=1 and Parent.ManageTaxPayment=1
		and Company.ParentId is not null
		and Company.ParentId=Parent.Id
		and ((@depositSchedule is not null and Parent.DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and Parent.HostId=@host) or (@host is null))
	)a

	select 
	(select 
	Host.*, 
	(
		select HostCompany.*		
		from Company HostCompany where Id=List.FilingCompanyId
		for xml path (''HostCompany''), elements, type
	),
	(
		select * from CompanyTaxState where CompanyId=Company.Id
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
				select * from PayrollPayCheck where CompanyId=ExtractCompany.Id 
				and IsVoid<=@includeVoids
				and payday between @startdate and @enddate
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
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Company.Id)
		for xml path (''ExtractDBCompany''), Elements, type

	)Companies
	 from
	Company, (select distinct FilingCompanyId, Host from #tmpComp) List, Host
	where Company.Id=List.FilingCompanyId
	and Company.HostId = Host.Id
	--and Host.CompanyId=List.FilingCompanyId
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
/****** Object:  StoredProcedure [dbo].[GetHostAndCompanies]    Script Date: 16/01/2017 10:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetHostAndCompanies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetHostAndCompanies]
	@host varchar(max) = null,
	@company varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select 
		(
			select Id, FirmName, Url, EffectiveDate, CompanyId		
			from Host 
			where ((@host is not null and Id=@host) or (@host is null))
			for xml path (''HostListItem''), elements, type
		)Hosts,
		(
			select Id, HostId, CompanyName Name, CompanyNumber, CompanyNo, LastPayrollDate, FileUnderHost, IsHostCompany, Created, 
				case StatusId When 1 then ''Active'' When 2 then ''InActive'' else ''Terminated'' end StatusId,
				(select InvoiceSetup from CompanyContract cc where cc.CompanyId=Company.Id) InvoiceSetup
			from Company
			where 
			((@company is not null and Id=@company) or (@company is null))
			and (
					(@role is not null and @role=''HostStaff'' and IsHostCompany=0) 
					or (@role is not null and @role=''CorpStaff'' and IsHostCompany=0) 
					or (@role is null)
				)
			for xml path (''CompanyListItem''), elements, type
		)Companies
	for xml path(''HostAndCompanies'')
	

END' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceChartData]    Script Date: 16/01/2017 10:45:58 PM ******/
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
			or (@role is not null and @role=''CorpStaff'' and c.IsHostCompany=0)
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
/****** Object:  StoredProcedure [dbo].[GetPayrollChartData]    Script Date: 16/01/2017 10:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollChartData]
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
	select firmname, companyname, [Next Payroll Due], [Next PayDay], Id,
	case  
		when DateDiff(day, getdate(), [Next PayDay])>=5 then
			''5 days+''
		when DateDiff(day, getdate(), [Next PayDay])=4 then
			''4 days''
		when DateDiff(day, getdate(), [Next PayDay])=3 then
			''3 days''
		when DateDiff(day, getdate(), [Next PayDay])=2 then
			''2 days''
		when DateDiff(day, getdate(), [Next PayDay])=1 then
			''1 days''
		else
			''Past Due''

	end
	[Days till Due],
	case  
		when DateDiff(day, getdate(), [Next PayDay])>=5 then
			5
		when DateDiff(day, getdate(), [Next PayDay])=4 then
			4
		when DateDiff(day, getdate(), [Next PayDay])=3 then
			3
		when DateDiff(day, getdate(), [Next PayDay])=2 then
			2
		when DateDiff(day, getdate(), [Next PayDay])=1 then
			1
		else
			0

	end
	[DaysDue]
	into #tmpInspectionData
	from
	(
	select h.firmname, c.CompanyName, i.InvoiceDate,
		case 
			when c.LastPayrollDate is null then 
				''Never run''
			else
				Case
					When c.PayrollSchedule=1 then
						case when DateAdd(day, 7, c.LastPayrollDate)<GETDATE() then
								''Overdue''
							when DATEDIFF(day,getdate(),DateAdd(day, 7, c.LastPayrollDate))>7 then
								''>7 days''
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 7, c.LastPayrollDate)),'' days'')
							end
					When c.PayrollSchedule=2 then
						case when DateAdd(day, 14, c.LastPayrollDate)<GETDATE() then
								''Overdue''
							when DATEDIFF(day,getdate(),DateAdd(day, 14, c.LastPayrollDate))>7 then
								''>7 days''
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 14, c.LastPayrollDate)),'' days'')
							end
					When c.PayrollSchedule=3 then
						case when DateAdd(day, 15, c.LastPayrollDate)<GETDATE() then
								''Overdue''
							when DATEDIFF(day,getdate(),DateAdd(day, 15, c.LastPayrollDate))>7 then
								''>7 days''
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 15, c.LastPayrollDate)),'' days'')
							end
					When c.PayrollSchedule=4 then
						case when DateAdd(MONTH, 1, c.LastPayrollDate)<GETDATE() then
								''Overdue''
							when DATEDIFF(day,getdate(),DateAdd(MONTH, 1, c.LastPayrollDate))>7 then
								''>7 days''
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(MONTH, 1, c.LastPayrollDate)),'' days'')
							end					
				end
		end [Next Payroll Due],
		Case
			When c.PayrollSchedule=1 then
				DateAdd(day, 7, p.PayDay)
			When c.PayrollSchedule=2 then
				DateAdd(day, 14, p.PayDay)
			When c.PayrollSchedule=3 then
				DateAdd(day, 15, p.PayDay)
			When c.PayrollSchedule=4 then
				DateAdd(month, 1, p.PayDay)				
		end
		[Next PayDay],
		i.Id
		
	from Company c, Host h, PayrollInvoice i, Payroll p
	Where 
	i.PayrollId=p.Id
	and c.StatusId=1
	and c.HostId = h.Id
	and c.id = i.CompanyId
	and i.balance>0
	--and i.Status>=1
	and ((@role is not null and @role=''HostStaff'' and c.IsHostCompany=0) 
			or (@role is not null and @role=''CorpStaff'' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	) a
	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + '',['' + cast(CompanyName as varchar) + '']'',''['' + cast(CompanyName as varchar)+ '']'')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = ''select (select top(1) [Days till Due] from #tmpInspectionData t Where t.[DaysDue]=row.[DaysDue]) [Days till Due], '' +@companies+ '' from (select [DaysDue],''+@companies+'' from
	(select distinct [DaysDue], CompanyName, Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in (''+@companies+''))Data)row order by [DaysDue]''
	execute(@query)
	
	drop table #tmpInspectionData
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 16/01/2017 10:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithoutInvoice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollsWithoutInvoice]
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
	select h.Id HostId, c.Id as CompanyId, h.firmname Host, c.CompanyName Company, count(p.Id) Due
	from Company c, Host h, CompanyContract cc, Payroll p Left outer join PayrollInvoice i on p.Id = i.PayrollId
	Where 
	h.id = c.HostId
	and c.StatusId=1
	and c.id=cc.CompanyId
	and c.HostId = h.Id
	and c.id=p.CompanyId
	and cc.[Type]=2 and cc.BillingType=3
	and ((@role is not null and @role=''HostStaff'' and c.IsHostCompany=0) 
			or (@role is not null and @role=''CorpStaff'' and (c.HostId<>@rootHost or (c.HostId=@rootHost and c.IsHostCompany=0))) 
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and (i.Id is null or i.Status=1)
	and exists (select ''x'' from PayrollPayCheck where PayrollId=p.Id and IsVoid=0)
	group by h.Id, c.Id, h.FirmName, c.CompanyName
	
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetSearchResults]    Script Date: 16/01/2017 10:45:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSearchResults]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetSearchResults]
	@criteria varchar(max),
	@company varchar(max) = null,
	@host varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration
	select 
	(select SearchTable.Id, 
	case 
		when SearchTable.SourceTypeId=2 then
			''Company''
		else
			''Employee''
		end SourceTypeId, SearchTable.SourceId, SearchTable.HostId, SearchTable.CompanyId, SearchTable.SearchText
	
	from 
	SearchTable, Company, Host
	Where 
	SearchTable.HostId = Host.Id
	and SearchTable.CompanyId = Company.Id
	and (
			(@role is not null and @role=''HostStaff'' and Company.IsHostCompany=0) 
			or (@role is not null and @role=''CorpStaff'' and IsHostCompany=0)
			or (@role is null)
		)
	and ((@host is not null and SearchTable.HostId=@host) or (@host is null))
	and ((@company is not null and SearchTable.CompanyId=@company) or (@company is null))
	and SearchTable.SearchText like ''%'' + @criteria + ''%''
	for xml path (''SearchResult''), elements, type
	) Results
	for xml path(''SearchResults''), ELEMENTS, type


END' 
END
GO
