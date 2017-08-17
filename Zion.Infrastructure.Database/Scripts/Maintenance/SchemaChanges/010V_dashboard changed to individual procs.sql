/****** Object:  StoredProcedure [dbo].[GetUserDashboard]    Script Date: 17/08/2017 9:07:46 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetUserDashboard]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 17/08/2017 9:07:46 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithoutInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollsWithoutInvoice]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesWithoutPayroll]    Script Date: 17/08/2017 9:07:46 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesWithoutPayroll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompaniesWithoutPayroll]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesNextPayrollChartData]    Script Date: 17/08/2017 9:07:46 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesNextPayrollChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompaniesNextPayrollChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesNextPayrollChartData]    Script Date: 17/08/2017 9:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesNextPayrollChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompaniesNextPayrollChartData] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompaniesNextPayrollChartData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select 'GetCompaniesNextPayrollChartData' Report;
	select HostId, CompanyId, Host, Company, InvoiceSetup,
			DateDiff(day, getdate(), [Next Payroll]) Due
	
	from	
	(select c.Id as CompanyId, c.CompanyName as Company, h.Id as HostId, h.FirmName as Host, cc.InvoiceSetup,
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
					
			
		end [Next Payroll]
		
	from Company c, Host h , CompanyContract cc
	Where 
	c.StatusId=1
	and h.id = c.HostId
	and c.Id=cc.CompanyId
		and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	) a
	where DateDiff(day, getdate(), [Next Payroll])<6
	
	order by Due


END
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesWithoutPayroll]    Script Date: 17/08/2017 9:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesWithoutPayroll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompaniesWithoutPayroll] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompaniesWithoutPayroll]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration
	select 'GetCompaniesWithoutPayroll' Report;
	select HostId, CompanyId, Host, Company, InvoiceSetup,
		DateDiff(day, CreationDate, getdate() ) [Days past]
	from 
	(select c.Id as CompanyId, c.CompanyName as Company, h.Id as HostId, h.FirmName as Host, cc.InvoiceSetup,
		Case
			When exists(select 'x' from PaxolArchive.Common.Memento  where SourceTypeId=2 and MementoId=c.Id) Then
				(select max(DateCreated) from PaxolArchive.Common.Memento  where SourceTypeId=2 and MementoId=c.Id)
			Else
				c.LastModified
					
			
		end CreationDate
		
	from Company c, Host h , CompanyContract cc
	Where 
	c.StatusId=1
	and h.id = c.HostId
	and c.Id = cc.CompanyId
		and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and not exists(select 'x' from Payroll where CompanyId=c.Id)
	)a
	where 
	DateDiff(day, CreationDate, getdate() )>0
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 17/08/2017 9:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithoutInvoice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollsWithoutInvoice] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPayrollsWithoutInvoice]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	--declare @projectNames varchar(max)
	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration
	select 'GetPayrollsWithoutInvoice' Report;
	select h.Id HostId, c.Id as CompanyId, h.firmname Host, c.CompanyName Company, count(p.Id) Due
	from Company c, Host h, CompanyContract cc, Payroll p Left outer join PayrollInvoice i on p.Id = i.PayrollId
	Where 
	h.id = c.HostId
	and c.StatusId=1
	and c.id=cc.CompanyId
	and c.HostId = h.Id
	and c.id=p.CompanyId
	and cc.[Type]=2 and cc.BillingType=3
	and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and (c.HostId<>@rootHost or (c.HostId=@rootHost and c.IsHostCompany=0))) 
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and (i.Id is null or i.Status=1)
	and exists (select 'x' from PayrollPayCheck where PayrollId=p.Id and IsVoid=0)
	and p.CopiedFrom is null and p.MovedFrom is null
	--and p.Id is null
	group by h.Id, c.Id, h.FirmName, c.CompanyName
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetUserDashboard]    Script Date: 17/08/2017 9:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserDashboard]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetUserDashboard] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetUserDashboard]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	
	exec GetCompaniesNextPayrollChartData @startdate, @enddate, @host, @role, @onlyActive;
	
	exec GetCompaniesWithoutPayroll @startdate, @enddate, @host, @role, @onlyActive;
	--select 'GetInvoiceChartData' Report;
	--exec GetInvoiceChartData @startdate, @enddate, @host, @role;
	--select 'GetPayrollChartData' Report;
	--exec GetPayrollChartData @startdate, @enddate, @host, @role;
	
	exec GetPayrollsWithoutInvoice @startdate, @enddate, @host, @role, @onlyActive;
	
END
GO
