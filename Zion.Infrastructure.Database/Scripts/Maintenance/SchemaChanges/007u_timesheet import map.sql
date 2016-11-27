/****** Object:  Table [dbo].[CompanyTSImportMap]    Script Date: 25/11/2016 8:17:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyTSImportMap]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyTSImportMap]
GO
/****** Object:  Table [dbo].[CompanyTSImportMap]    Script Date: 25/11/2016 8:17:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyTSImportMap]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyTSImportMap](
	[CompanyId] [uniqueidentifier] NOT NULL,
	[TimeSheetImportMap] [varchar](max) NOT NULL,
 CONSTRAINT [PK_CompanyTSImportMap] PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollChartData]    Script Date: 26/11/2016 7:23:55 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollChartData]    Script Date: 26/11/2016 7:23:55 PM ******/
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
			or (@role is not null and @role=''CorpStaff'' and (c.HostId<>@rootHost or (c.HostId=@rootHost and c.IsHostCompany=0))) 
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
