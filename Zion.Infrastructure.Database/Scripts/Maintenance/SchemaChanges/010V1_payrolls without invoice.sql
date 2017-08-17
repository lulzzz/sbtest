/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 17/08/2017 12:01:21 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithoutInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollsWithoutInvoice]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 17/08/2017 12:01:21 PM ******/
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
	select 
	HostId, CompanyId, Host, Company, count(PayrollId) Due
	from
	(select distinct h.Id HostId, c.Id as CompanyId, h.firmname Host, c.CompanyName Company, p.Id PayrollId
	from Company c, Host h, CompanyContract cc,PayrollPayCheck pc, Payroll p Left outer join PayrollInvoice i on p.Id = i.PayrollId
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
	--and exists (select 'x' from PayrollPayCheck where PayrollId=p.Id and IsVoid=0)
	and pc.PayrollId=p.Id and pc.IsVoid=0
	and p.CopiedFrom is null and p.MovedFrom is null
	and p.IsHistory=0
	--and p.Id is null
	)a
	group by HostId, CompanyId, Host, Company
	
END
GO
