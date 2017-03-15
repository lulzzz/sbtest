﻿/****** Object:  StoredProcedure [dbo].[GetPayrollProcessingPerformanceChart]    Script Date: 15/03/2017 4:40:02 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollProcessingPerformanceChart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollProcessingPerformanceChart]
GO
/****** Object:  StoredProcedure [dbo].[GetCommissionPerformanceChart]    Script Date: 15/03/2017 4:40:02 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommissionPerformanceChart]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCommissionPerformanceChart]
GO
/****** Object:  StoredProcedure [dbo].[GetCommissionPerformanceChart]    Script Date: 15/03/2017 4:40:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCommissionPerformanceChart]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCommissionPerformanceChart] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCommissionPerformanceChart]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	declare @users varchar(max)
	declare @query varchar(max)	

	select (u.FirstName + ' ' + u.LastName) [User], LEFT(datename(month,InvoiceDate),3) + ' ' + Right(cast(year(InvoiceDate) as varchar),2) Month, Commission 
	into #tmpInspectionData
	from PayrollInvoice i, AspNetUsers u, Company c
	where 
		i.SalesRep=u.Id
		and i.CompanyId = c.Id
		and c.StatusId=1

		
	SELECT @users = COALESCE(@users + ',[' + cast([User] as varchar) + ']','[' + cast([User] as varchar)+ ']')
	FROM (select distinct [User] from #tmpInspectionData)a
	

	set @query = 'select Month, ' +@users+ ' from (select Data.Month,'+@users+' from
	(select distinct Month, [User], Commission
	from #tmpInspectionData
	) o
	PIVOT (sum(Commission) for [User] in ('+@users+'))Data)t order by convert(datetime, ''01 ''+Month, 6)'
	
	select 'GetCommissionPerformanceChart' Report;			
	execute(@query)
	drop table #tmpInspectionData
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollProcessingPerformanceChart]    Script Date: 15/03/2017 4:40:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollProcessingPerformanceChart]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollProcessingPerformanceChart] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPayrollProcessingPerformanceChart]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	declare @users varchar(max)
	declare @query varchar(max)	

	select i.ProcessedBy [User], LEFT(datename(month,i.ProcessedOn),3) + ' ' + Right(cast(year(i.ProcessedOn) as varchar),2) Month, i.Id 
	into #tmpInspectionData
	from PayrollInvoice i, Payroll p
	where 
		i.Id=p.InvoiceId
		and exists(select 'x' from PayrollPayCheck pp where pp.PayrollId=p.Id and pp.IsVoid=0)

		
	SELECT @users = COALESCE(@users + ',[' + cast([User] as varchar) + ']','[' + cast([User] as varchar)+ ']')
	FROM (select distinct [User] from #tmpInspectionData)a
	
	set @query = 'select Month, ' +@users+ ' from (select Data.Month,'+@users+' from
	(select distinct Month, [User], Id
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for [User] in ('+@users+'))Data)t order by convert(datetime, ''01 ''+Month, 6)'
	
	select 'GetPayrollProcessingPerformanceChart' Report;	
	execute(@query)
	drop table #tmpInspectionData
END
GO
