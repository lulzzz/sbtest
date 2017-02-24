/****** Object:  StoredProcedure [dbo].[GetPayrollChartData]    Script Date: 24/02/2017 6:24:11 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusPastDueChartData]    Script Date: 24/02/2017 6:24:11 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusPastDueChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceStatusPastDueChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusDetailedChartData]    Script Date: 24/02/2017 6:24:11 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusDetailedChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceStatusDetailedChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusChartData]    Script Date: 24/02/2017 6:24:11 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceStatusChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceChartData]    Script Date: 24/02/2017 6:24:11 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceChartData]    Script Date: 24/02/2017 6:24:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInvoiceChartData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetInvoiceChartData]
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
			When DateDiff(day, i.invoicedate, getdate())=1 then '1 day'
			when DateDiff(day, i.invoicedate, getdate())=2 then '2 days'
			when DateDiff(day, i.invoicedate, getdate())>2 and DateDiff(day, i.invoicedate, getdate())<5  then '3-4 days'
			when DateDiff(day, i.invoicedate, getdate())>5 and DateDiff(day, i.invoicedate, getdate())<10  then '5-9 days'
			when DateDiff(day, i.invoicedate, getdate())>9 and DateDiff(day, i.invoicedate, getdate())<20  then '10-20 days'
			else
				'Over 20 days'
			end 
		AgeText,
		i.Id
		into #tmpInspectionData
	from PayrollInvoice i, Company c 
	Where 
	i.CompanyId = c.Id
	and c.StatusId=1
	and i.Balance>0
	and DateDiff(day, i.invoicedate, getdate()) >0
	and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and not exists(select 'x' from InvoicePayment ip 
				where ip.InvoiceId=i.Id and 
					(
					(ip.Method=1 and DATEADD(Day,3,ip.PaymentDate)<=getdate())
					or
					(ip.Method=5 and ip.PaymentDate<=getdate())
					)
				)

	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + ',[' + cast(CompanyName as varchar(max)) + ']','[' + cast(CompanyName as varchar(max))+ ']')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = 'select (select top(1) AgeText from #tmpInspectionData t Where t.Age=row.Age1) Age, ' +@companies+ ' from (select Age as Age1,'+@companies+' from
	(select distinct Age, CompanyName , Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in ('+@companies+'))Data)row order by Age1'
	execute(@query)
	
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusChartData]    Script Date: 24/02/2017 6:24:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInvoiceStatusChartData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetInvoiceStatusChartData]
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

	select c.CompanyName, 
			case i.Status 
				when 1 then 'Draft' when 2 then 'Approved' when 3 then 'Delivered'
				when 5 then 'Taxes Delayed' when 6 then 'Bounced'
				when 7 then 'Partial Payment' when 9 then 'Not Deposited' when 10 then 'ACH Pending'
				end as  StatusName,
		i.Id
		into #tmpInspectionData
	from PayrollInvoice i, Company c 
	Where 
	i.CompanyId = c.Id
	and c.StatusId=1
	and i.Balance>0
	and i.Status not in (4, 8)
	and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and not exists(select 'x' from InvoicePayment ip 
				where ip.InvoiceId=i.Id and 
					(
					(ip.Method=1 and DATEADD(Day,3,ip.PaymentDate)<=getdate())
					or
					(ip.Method=5 and ip.PaymentDate<=getdate())
					)
				)

	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + ',[' + cast(StatusName as varchar(max)) + ']','[' + cast(StatusName as varchar(max))+ ']')
	FROM (select distinct StatusName from #tmpInspectionData) a
	
	print @companies
				
				
	set @query = 'select ' +@companies+ ' from (select '+@companies+' from
	(select distinct StatusName,  Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for StatusName in ('+@companies+'))Data)row';

	select 'GetInvoiceStatusChartData' Report;
	execute(@query)
	
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusDetailedChartData]    Script Date: 24/02/2017 6:24:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusDetailedChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInvoiceStatusDetailedChartData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetInvoiceStatusDetailedChartData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@criteria varchar(max)
AS
BEGIN
	--declare @projectNames varchar(max)
	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	declare @status int = null
	select @status = case @criteria
					when 'Draft' then 1
					when 'Approved' then 2
					when 'Delivered' then 3
					when 'Closed' then 4
					when 'Taxes Delayed' then 5
					when 'Bounced' then 6
					when 'Partial Payment' then 7
					when 'Deposited' then 8
					when 'Not Deposited' then 9
					when 'ACH Pending' then 10
					end
	select firmname, companyname, [Next Payroll Due], [Next PayDay], Id,
	case  
		when DateDiff(day, getdate(), [Next PayDay])>=5 then
			'5 days+'
		when DateDiff(day, getdate(), [Next PayDay])=4 then
			'4 days'
		when DateDiff(day, getdate(), [Next PayDay])=3 then
			'3 days'
		when DateDiff(day, getdate(), [Next PayDay])=2 then
			'2 days'
		when DateDiff(day, getdate(), [Next PayDay])=1 then
			'1 days'
		else
			'Past Due'

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
				'Never run'
			else
				Case
					When c.PayrollSchedule=1 then
						case when DateAdd(day, 7, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(day, 7, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 7, c.LastPayrollDate)),' days')
							end
					When c.PayrollSchedule=2 then
						case when DateAdd(day, 14, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(day, 14, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 14, c.LastPayrollDate)),' days')
							end
					When c.PayrollSchedule=3 then
						case when DateAdd(day, 15, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(day, 15, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 15, c.LastPayrollDate)),' days')
							end
					When c.PayrollSchedule=4 then
						case when DateAdd(MONTH, 1, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(MONTH, 1, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(MONTH, 1, c.LastPayrollDate)),' days')
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
	and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and not exists(select 'x' from InvoicePayment ip 
				where ip.InvoiceId=i.Id and 
					(
					(ip.Method=1 and DATEADD(Day,3,ip.PaymentDate)<=getdate())
					or
					(ip.Method=5 and ip.PaymentDate<=getdate())
					)
				)
	and ((@status is not null and i.Status=@status) or (@status is null))
	) a
	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + ',[' + cast(CompanyName as varchar(max)) + ']','[' + cast(CompanyName as varchar(max))+ ']')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = 'select (select top(1) [Days till Due] from #tmpInspectionData t Where t.[DaysDue]=row.[DaysDue]) [Days till Due], ' +@companies+ ' from (select [DaysDue],'+@companies+' from
	(select distinct [DaysDue], CompanyName, Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in ('+@companies+'))Data)row order by [DaysDue]';

	select 'GetInvoiceStatusDetailedChartData' Report;
	execute(@query)
	
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusPastDueChartData]    Script Date: 24/02/2017 6:24:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusPastDueChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInvoiceStatusPastDueChartData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetInvoiceStatusPastDueChartData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@criteria varchar(max)
AS
BEGIN
	--declare @projectNames varchar(max)
	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	declare @status int = null
	select @status = case @criteria
					when 'Draft' then 1
					when 'Approved' then 2
					when 'Delivered' then 3
					when 'Closed' then 4
					when 'Taxes Delayed' then 5
					when 'Bounced' then 6
					when 'Partial Payment' then 7
					when 'Deposited' then 8
					when 'Not Deposited' then 9
					when 'ACH Pending' then 10
					end

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
			When DateDiff(day, i.invoicedate, getdate())=1 then '1 day'
			when DateDiff(day, i.invoicedate, getdate())=2 then '2 days'
			when DateDiff(day, i.invoicedate, getdate())>2 and DateDiff(day, i.invoicedate, getdate())<5  then '3-4 days'
			when DateDiff(day, i.invoicedate, getdate())>5 and DateDiff(day, i.invoicedate, getdate())<10  then '5-9 days'
			when DateDiff(day, i.invoicedate, getdate())>9 and DateDiff(day, i.invoicedate, getdate())<20  then '10-20 days'
			else
				'Over 20 days'
			end 
		AgeText,
		i.Id
		into #tmpInspectionData
	from PayrollInvoice i, Company c 
	Where 
	i.CompanyId = c.Id
	and c.StatusId=1
	and i.Balance>0
	and DateDiff(day, i.invoicedate, getdate()) >0
	and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and not exists(select 'x' from InvoicePayment ip 
				where ip.InvoiceId=i.Id and 
					(
					(ip.Method=1 and DATEADD(Day,3,ip.PaymentDate)<=getdate())
					or
					(ip.Method=5 and ip.PaymentDate<=getdate())
					)
				)
	and ((@status is not null and i.Status=@status) or (@status is null))

	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + ',[' + cast(CompanyName as varchar(max)) + ']','[' + cast(CompanyName as varchar(max))+ ']')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = 'select (select top(1) AgeText from #tmpInspectionData t Where t.Age=row.Age1) Age, ' +@companies+ ' from (select Age as Age1,'+@companies+' from
	(select distinct Age, CompanyName , Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in ('+@companies+'))Data)row order by Age1';
	select 'GetInvoiceStatusPastDueChartData' Report;
	execute(@query)
	
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollChartData]    Script Date: 24/02/2017 6:24:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollChartData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPayrollChartData]
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
			'5 days+'
		when DateDiff(day, getdate(), [Next PayDay])=4 then
			'4 days'
		when DateDiff(day, getdate(), [Next PayDay])=3 then
			'3 days'
		when DateDiff(day, getdate(), [Next PayDay])=2 then
			'2 days'
		when DateDiff(day, getdate(), [Next PayDay])=1 then
			'1 days'
		else
			'Past Due'

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
				'Never run'
			else
				Case
					When c.PayrollSchedule=1 then
						case when DateAdd(day, 7, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(day, 7, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 7, c.LastPayrollDate)),' days')
							end
					When c.PayrollSchedule=2 then
						case when DateAdd(day, 14, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(day, 14, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 14, c.LastPayrollDate)),' days')
							end
					When c.PayrollSchedule=3 then
						case when DateAdd(day, 15, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(day, 15, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(day, 15, c.LastPayrollDate)),' days')
							end
					When c.PayrollSchedule=4 then
						case when DateAdd(MONTH, 1, c.LastPayrollDate)<GETDATE() then
								'Overdue'
							when DATEDIFF(day,getdate(),DateAdd(MONTH, 1, c.LastPayrollDate))>7 then
								'>7 days'
							else
								CONCAT(DATEDIFF(day,getdate(),DateAdd(MONTH, 1, c.LastPayrollDate)),' days')
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
	and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and not exists(select 'x' from InvoicePayment ip 
				where ip.InvoiceId=i.Id and 
					(
					(ip.Method=1 and DATEADD(Day,3,ip.PaymentDate)<=getdate())
					or
					(ip.Method=5 and ip.PaymentDate<=getdate())
					)
				)
	) a
	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + ',[' + cast(CompanyName as varchar(max)) + ']','[' + cast(CompanyName as varchar(max))+ ']')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = 'select (select top(1) [Days till Due] from #tmpInspectionData t Where t.[DaysDue]=row.[DaysDue]) [Days till Due], ' +@companies+ ' from (select [DaysDue],'+@companies+' from
	(select distinct [DaysDue], CompanyName, Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in ('+@companies+'))Data)row order by [DaysDue]'
	execute(@query)
	
	drop table #tmpInspectionData
END
GO

Update EntityType set EntityTypeName='HostHomePage' where EntityTypeId=17;
Update EntityType set EntityTypeName='Adjustment' where EntityTypeId=18;