IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'ApplicationConfiguration'
                 AND COLUMN_NAME = 'RootHostId')
alter table ApplicationConfiguration add RootHostId uniqueidentifier;

update c set c.LastPayrollDate=(select max(payday) from payroll where companyid=c.Id)
from company c;

/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 19/10/2016 5:51:40 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithoutInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollsWithoutInvoice]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollChartData]    Script Date: 19/10/2016 5:51:40 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceChartData]    Script Date: 19/10/2016 5:51:40 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesNextPayrollChartData]    Script Date: 19/10/2016 5:51:40 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesNextPayrollChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompaniesNextPayrollChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesNextPayrollChartData]    Script Date: 19/10/2016 5:51:40 PM ******/
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
			end
			Due
	
	from	
	(select c.Id as CompanyId, c.CompanyName as Company, h.Id as HostId, h.FirmName as Host,
		Case
			When c.PayrollSchedule=1 then
				DateAdd(day, 7, c.LastPayrollDate)
				
			When c.PayrollSchedule=2 then
				DateAdd(day, 14, c.LastPayrollDate)
				
			When c.PayrollSchedule=3 then
				DateAdd(day, 15, c.LastPayrollDate)
				
			When c.PayrollSchedule=4 then
				DateAdd(MONTH, 1, c.LastPayrollDate)
							
			
		end [Next Payroll]
		
	from Company c, Host h 
	Where 
	c.StatusId=1
	and h.id = c.HostId
	and c.LastPayrollDate is not null
	and ((@role is not null and @role=''HostStaff'' and c.IsHostCompany=0) 
			or (@role is not null and @role=''CorpStaff'' and (c.HostId<>@rootHost or (c.HostId=@rootHost and c.IsHostCompany=0))) 
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	) a
	where DateDiff(day, getdate(), [Next Payroll])<3
	order by Due


END' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceChartData]    Script Date: 19/10/2016 5:51:40 PM ******/
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
			When DateDiff(day, i.invoicedate, getdate())=1 then ''1 day''
			when DateDiff(day, i.invoicedate, getdate())=2 then ''2 days''
			when DateDiff(day, i.invoicedate, getdate())=3 then ''3 days''
			else
				''Over 3 days''
			end 
		Age,
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
				
	set @query = ''select Age, '' +@companies+ '' from (select Age,''+@companies+'' from
	(select distinct Age, CompanyName , Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in (''+@companies+''))Data)row''
	execute(@query)
	
	drop table #tmpInspectionData
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollChartData]    Script Date: 19/10/2016 5:51:40 PM ******/
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
	[Days till Due]
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
			or (@role is not null and @role=''CorpStaff'' and (c.HostId<>@rootHost or (c.HostId=@rootHost and c.IsHostCompany=0))) 
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	) a
	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + '',['' + cast(CompanyName as varchar) + '']'',''['' + cast(CompanyName as varchar)+ '']'')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = ''select [Days till Due], '' +@companies+ '' from (select [Days till Due],''+@companies+'' from
	(select distinct [Days till Due], CompanyName, Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in (''+@companies+''))Data)row''
	execute(@query)
	
	drop table #tmpInspectionData
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 19/10/2016 5:51:40 PM ******/
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
	from Company c, Host h, Payroll p, CompanyContract cc
	Where 
	h.id = c.HostId
	and c.StatusId=1
	and c.id=cc.CompanyId
	and c.HostId = h.Id
	and p.InvoiceId is null
	and c.id=p.CompanyId
	and cc.[Type]=2 and cc.BillingType=3
	and ((@role is not null and @role=''HostStaff'' and c.IsHostCompany=0) 
			or (@role is not null and @role=''CorpStaff'' and (c.HostId<>@rootHost or (c.HostId=@rootHost and c.IsHostCompany=0))) 
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	group by h.Id, c.Id, h.FirmName, c.CompanyName
	
END' 
END
GO
