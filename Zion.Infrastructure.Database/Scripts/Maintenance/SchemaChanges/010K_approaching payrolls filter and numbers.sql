/****** Object:  StoredProcedure [dbo].[GetCompaniesNextPayrollChartData]    Script Date: 29/05/2017 4:58:32 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesNextPayrollChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompaniesNextPayrollChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesNextPayrollChartData]    Script Date: 29/05/2017 4:58:32 PM ******/
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
	@role varchar(max) = null
AS
BEGIN
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration

	select HostId, CompanyId, Host, Company, 
		--case 
		--	when DateDiff(day, getdate(), [Next Payroll])<0 then
		--		'Overdue'
		--	when DateDiff(day, getdate(), [Next Payroll])=0 then
		--		'Today'
		--	when DateDiff(day, getdate(), [Next Payroll])=1 then
		--		'1 day'
		--	when DateDiff(day, getdate(), [Next Payroll])=2 then
		--		'2 days'
		--	when DateDiff(day, getdate(), [Next Payroll])=3 then
		--		'3 days'
		--	when DateDiff(day, getdate(), [Next Payroll])=4 then
		--		'4 days'
		--	when DateDiff(day, getdate(), [Next Payroll])=5 then
		--		'5 days'
		--	end
			DateDiff(day, getdate(), [Next Payroll]) Due
	
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
				Cast('01/01/' + cast(year(getdate()) as varchar(max)) as datetime)
					
			
		end [Next Payroll]
		
	from Company c, Host h 
	Where 
	c.StatusId=1
	and h.id = c.HostId
		and ((@role is not null and @role='HostStaff' and c.IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and c.IsHostCompany=0)
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	) a
	where DateDiff(day, getdate(), [Next Payroll])<6
	order by Due


END
GO
