/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusChartData]    Script Date: 17/04/2017 1:21:46 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceStatusChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceStatusChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceStatusChartData]    Script Date: 17/04/2017 1:21:46 PM ******/
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
	
	select 'GetInvoiceStatusChartData' Report;
	select StatusName Status, count(Id) NoOfInvoices
	from #tmpInspectionData
	group by StatusName
	execute(@query)
	
	drop table #tmpInspectionData
END
GO
