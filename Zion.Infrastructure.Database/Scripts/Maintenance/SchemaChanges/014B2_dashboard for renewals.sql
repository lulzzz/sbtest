/****** Object:  StoredProcedure [dbo].[GetCompaniesRenewalData]    Script Date: 3/03/2020 9:02:11 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompaniesRenewalData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompaniesRenewalData]
GO
/****** Object:  StoredProcedure [dbo].[GetCompaniesRenewalData]    Script Date: 3/03/2020 9:02:11 PM ******/
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
			[Next Payroll] Due
	
	from	
	(select c.Id as CompanyId, c.CompanyName as Company, h.Id as HostId, h.FirmName as Host, cc.InvoiceSetup, cr.description,
		Case
			When cast((cast(cr.[month] as varchar(2)) + '/' + cast(cr.[day] as varchar(2)) + '/' + cast(year(getdate()) as varchar(4))) as datetime)<GETDATE() Then
				DateDiff(day, getdate(), cast((cast(cr.[month] as varchar(2)) + '/' + cast(cr.[day] as varchar(2)) + '/' + cast(year(getdate())+1 as varchar(4))) as datetime) )
			Else
				DateDiff(day, getdate(), cast((cast(cr.[month] as varchar(2)) + '/' + cast(cr.[day] as varchar(2)) + '/' + cast(year(getdate()) as varchar(4))) as datetime) )
					
			
		end [Next Payroll]
		
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
	where DateDiff(day, getdate(), [Next Payroll])<6
	
	order by Due


END
GO
