/****** Object:  StoredProcedure [dbo].[GetUserDashboard]    Script Date: 30/01/2018 6:13:21 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetUserDashboard]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 30/01/2018 6:13:21 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithoutInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollsWithoutInvoice]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithDraftInvoice]    Script Date: 30/01/2018 6:13:21 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithDraftInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollsWithDraftInvoice]
GO
/****** Object:  Index [CIX_NoPayrollInvoices]    Script Date: 30/01/2018 6:13:21 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollNoInvoices]') AND name = N'CIX_NoPayrollInvoices')
DROP INDEX [CIX_NoPayrollInvoices] ON [dbo].[PayrollNoInvoices] WITH ( ONLINE = OFF )
GO
/****** Object:  View [dbo].[PayrollNoInvoices]    Script Date: 30/01/2018 6:13:21 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PayrollNoInvoices]'))
DROP VIEW [dbo].[PayrollNoInvoices]
GO
/****** Object:  Index [CIX_DraftPayrollInvoices]    Script Date: 30/01/2018 6:13:21 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollDraftInvoices]') AND name = N'CIX_DraftPayrollInvoices')
DROP INDEX [CIX_DraftPayrollInvoices] ON [dbo].[PayrollDraftInvoices] WITH ( ONLINE = OFF )
GO
/****** Object:  View [dbo].[PayrollDraftInvoices]    Script Date: 30/01/2018 6:13:21 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PayrollDraftInvoices]'))
DROP VIEW [dbo].[PayrollDraftInvoices]
GO
/****** Object:  Index [CIX_PEOCheckNumber]    Script Date: 30/01/2018 6:13:21 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]') AND name = N'CIX_PEOCheckNumber')
DROP INDEX [CIX_PEOCheckNumber] ON [dbo].[CompanyJournal] WITH ( ONLINE = OFF )
GO
/****** Object:  View [dbo].[CompanyJournal]    Script Date: 30/01/2018 6:13:21 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]'))
DROP VIEW [dbo].[CompanyJournal]
GO
/****** Object:  View [dbo].[CompanyJournal]    Script Date: 30/01/2018 6:13:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]'))
EXEC dbo.sp_executesql @statement = N'CREATE view [dbo].[CompanyJournal]
With SchemaBinding 
As
select CompanyIntId, PayrollPayCheckId, PEOASOCoCheck, TransactionType, CheckNumber from dbo.Journal where CheckNumber>0;' 
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO
/****** Object:  Index [CIX_PEOCheckNumber]    Script Date: 30/01/2018 6:13:21 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]') AND name = N'CIX_PEOCheckNumber')
CREATE UNIQUE CLUSTERED INDEX [CIX_PEOCheckNumber] ON [dbo].[CompanyJournal]
(
	[CompanyIntId] ASC,
	[PEOASOCoCheck] ASC,
	[TransactionType] ASC,
	[CheckNumber] DESC,
	[PayrollPayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  View [dbo].[PayrollDraftInvoices]    Script Date: 30/01/2018 6:13:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PayrollDraftInvoices]'))
EXEC dbo.sp_executesql @statement = N'CREATE view [dbo].[PayrollDraftInvoices]
With SchemaBinding 
As
select [Host].Id HostId, [Company].Id as CompanyId, [Company].IsHostCompany, [Host].firmname Host, [Company].CompanyName Company, [Payroll].Id PayrollId, Count_Big(*) Counts
	from dbo.Company, dbo.Host, dbo.CompanyContract, dbo.Payroll, dbo.PayrollInvoice
	Where 
	[Host].id = [Company].HostId
	and [Company].StatusId=1
	and [Company].id=[CompanyContract].CompanyId
	and [Company].HostId = [Host].Id
	and [Company].id=[Payroll].CompanyId
	and [CompanyContract].[Type]=2 and [CompanyContract].BillingType=3	
	and [Payroll].InvoiceId=[PayrollInvoice].Id
	and [PayrollInvoice].Status =1
	and [Payroll].IsVoid=0
	and [Payroll].CopiedFrom is null and [Payroll].MovedFrom is null
	and [Payroll].IsHistory=0 and [Payroll].IsQueued=0
	Group By [Host].Id, [Company].Id, [Company].IsHostCompany, [Host].firmname, [Company].CompanyName, [Payroll].Id;' 
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO
/****** Object:  Index [CIX_DraftPayrollInvoices]    Script Date: 30/01/2018 6:13:21 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollDraftInvoices]') AND name = N'CIX_DraftPayrollInvoices')
CREATE UNIQUE CLUSTERED INDEX [CIX_DraftPayrollInvoices] ON [dbo].[PayrollDraftInvoices]
(
	[IsHostCompany] ASC,
	[HostId] ASC,
	[PayrollId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  View [dbo].[PayrollNoInvoices]    Script Date: 30/01/2018 6:13:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PayrollNoInvoices]'))
EXEC dbo.sp_executesql @statement = N'CREATE view [dbo].[PayrollNoInvoices]
With SchemaBinding 
As
select [Host].Id HostId, [Company].Id as CompanyId, [Company].IsHostCompany, [Host].firmname Host, [Company].CompanyName Company, [Payroll].Id PayrollId, Count_Big(*) Counts
	from dbo.Company, dbo.Host, dbo.CompanyContract, dbo.Payroll
	Where 
	[Host].id = [Company].HostId
	and [Company].StatusId=1
	and [Company].id=[CompanyContract].CompanyId
	and [Company].HostId = [Host].Id
	and [Company].id=[Payroll].CompanyId
	and [CompanyContract].[Type]=2 and [CompanyContract].BillingType=3
	
	and [Payroll].InvoiceId is null
	and [Payroll].IsVoid=0
	and [Payroll].CopiedFrom is null and [Payroll].MovedFrom is null
	and [Payroll].IsHistory=0 and [Payroll].IsQueued=0
	Group By [Host].Id, [Company].Id, [Company].IsHostCompany, [Host].firmname, [Company].CompanyName, [Payroll].Id;' 
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO
/****** Object:  Index [CIX_NoPayrollInvoices]    Script Date: 30/01/2018 6:13:21 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayrollNoInvoices]') AND name = N'CIX_NoPayrollInvoices')
CREATE UNIQUE CLUSTERED INDEX [CIX_NoPayrollInvoices] ON [dbo].[PayrollNoInvoices]
(
	[IsHostCompany] ASC,
	[HostId] ASC,
	[PayrollId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithDraftInvoice]    Script Date: 30/01/2018 6:13:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithDraftInvoice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollsWithDraftInvoice] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPayrollsWithDraftInvoice]
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
	select 'GetPayrollsWithDraftInvoice' Report;
	select 
	HostId, CompanyId, Host, Company, count(PayrollId) Due
	from
	dbo.PayrollDraftInvoices
	where
	((@role is not null and @role='HostStaff' and IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and (HostId<>@rootHost or (HostId=@rootHost and IsHostCompany=0))) 
			or (@role is null))
	and ((@host is not null and HostId=@host) or (@host is null))
	group by HostId, CompanyId, Host, Company
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 30/01/2018 6:13:21 PM ******/
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
	dbo.PayrollNoInvoices
	where
	((@role is not null and @role='HostStaff' and IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and (HostId<>@rootHost or (HostId=@rootHost and IsHostCompany=0))) 
			or (@role is null))
	and ((@host is not null and HostId=@host) or (@host is null))
	group by HostId, CompanyId, Host, Company
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetUserDashboard]    Script Date: 30/01/2018 6:13:21 PM ******/
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

	exec GetPayrollsWithDraftInvoice @startdate, @enddate, @host, @role, @onlyActive;
	
END
GO
/****** Object:  Index [CIX_CompanyPayCheckNumber]    Script Date: 30/01/2018 6:45:18 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayCheckNumber]') AND name = N'CIX_CompanyPayCheckNumber')
DROP INDEX [CIX_CompanyPayCheckNumber] ON [dbo].[CompanyPayCheckNumber] WITH ( ONLINE = OFF )
GO
/****** Object:  View [dbo].[CompanyPayCheckNumber]    Script Date: 30/01/2018 6:45:18 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayCheckNumber]'))
DROP VIEW [dbo].[CompanyPayCheckNumber]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCheckNumber]    Script Date: 30/01/2018 6:45:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCheckNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetCheckNumber]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCheckNumber]    Script Date: 30/01/2018 6:45:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCheckNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[GetCheckNumber] 
(
	@CompanyId int,
	@PayrollPayCheckId int,
	@PEOASOCoCheck bit,
	@TransactionType int,
	@CheckNumber int
)
RETURNS int
AS
BEGIN
	declare @result int = @CheckNumber
	select @result = case
		when @TransactionType=1 then
			case when @PEOASOCoCheck=1 and exists(select ''x'' from dbo.CompanyJournal where CheckNumber=@CheckNumber and PayrollPayCheckId<>@PayrollPayCheckId) then
					(select isnull(max(CheckNumber),0)+1 from dbo.CompanyJournal where PEOASOCoCheck=1)
				when @PEOASOCoCheck=0 and exists(select ''x'' from dbo.CompanyPayCheckNumber where CompanyIntId=@CompanyId and Id<>@PayrollPayCheckId and CheckNumber=@CheckNumber) then
						(select isnull(max(CheckNumber),0)+1 from dbo.CompanyPayCheckNumber where CompanyIntId=@CompanyId)
				else 
					@result
				end
		end


	return @result;

END' 
END

GO
/****** Object:  View [dbo].[CompanyPayCheckNumber]    Script Date: 30/01/2018 6:45:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayCheckNumber]'))
EXEC dbo.sp_executesql @statement = N'
CREATE view [dbo].[CompanyPayCheckNumber]
With SchemaBinding 
As
select CompanyIntId, Id, CheckNumber from dbo.PayrollPayCheck where CheckNumber>0;
' 
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO
/****** Object:  Index [CIX_CompanyPayCheckNumber]    Script Date: 30/01/2018 6:45:18 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayCheckNumber]') AND name = N'CIX_CompanyPayCheckNumber')
CREATE UNIQUE CLUSTERED INDEX [CIX_CompanyPayCheckNumber] ON [dbo].[CompanyPayCheckNumber]
(
	[CompanyIntId] ASC,
	[CheckNumber] DESC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
