


Use PaxolArchive
/****** Object:  Index [IX_CompanyPayrollCube_1]    Script Date: 6/03/2017 11:09:38 AM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayrollCube]') AND name = N'IX_CompanyPayrollCube_1')
DROP INDEX [IX_CompanyPayrollCube_1] ON [dbo].[CompanyPayrollCube]
GO
/****** Object:  Index [IX_CompanyPayrollCube]    Script Date: 6/03/2017 11:09:38 AM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayrollCube]') AND name = N'IX_CompanyPayrollCube')
DROP INDEX [IX_CompanyPayrollCube] ON [dbo].[CompanyPayrollCube]
GO
/****** Object:  Table [dbo].[CompanyPayrollCube]    Script Date: 6/03/2017 11:09:38 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayrollCube]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyPayrollCube]
GO
/****** Object:  Table [dbo].[CompanyPayrollCube]    Script Date: 6/03/2017 11:09:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayrollCube]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyPayrollCube](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[Year] [int] NOT NULL,
	[Quarter] [int] NULL,
	[Month] [int] NULL,
	[Accumulation] [varchar](max) NOT NULL,
 CONSTRAINT [PK_CompanyPayrollCube] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Index [IX_CompanyPayrollCube]    Script Date: 6/03/2017 11:09:38 AM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayrollCube]') AND name = N'IX_CompanyPayrollCube')
CREATE NONCLUSTERED INDEX [IX_CompanyPayrollCube] ON [dbo].[CompanyPayrollCube]
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CompanyPayrollCube_1]    Script Date: 6/03/2017 11:09:38 AM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyPayrollCube]') AND name = N'IX_CompanyPayrollCube_1')
CREATE NONCLUSTERED INDEX [IX_CompanyPayrollCube_1] ON [dbo].[CompanyPayrollCube]
(
	[Year] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

set identity_insert CompanyPayrollCube On;
insert into CompanyPayrollCube(Id, CompanyId, Year, Quarter, Month, Accumulation)
select Id, CompanyId, Year, Quarter, Month, Accumulation from Paxol.dbo.CompanyPayrollCube;
set identity_insert CompanyPayrollCube Off;

Use Paxol
drop table CompanyPayrollCube;

/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 6/03/2017 3:55:35 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrolls]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrolls]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 6/03/2017 3:55:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrolls]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrolls] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPayrolls]
	@company varchar(max) = null,
	@startdate varchar(max) = null,
	@enddate varchar(max) = null,
	@id uniqueidentifier=null,
	@invoice uniqueidentifier=null,
	@status varchar(max)=null,
	@void int=null
AS
BEGIN
	if exists(select 'x' from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId where 
		((@void is null) or (@void is not null and exists(select 'x' from PayrollPayCheck where PayrollId=Payroll.Id and IsVoid=0)))
		and ((@invoice is not null and cast(@invoice as uniqueidentifier)=Pinv.Id) or (@invoice is null))
		and ((@id is not null and Payroll.Id=@id) or (@id is null)) 
		and ((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
		and ((@startdate is not null and PayDay>=@startdate) or (@startdate is null)) 
		and ((@enddate is not null and PayDay<=@enddate) or (@enddate is null)) 
		and ((@status is not null and Payroll.Status=cast(@status as int)) or @status is null)
		)
	select
		Payroll.*,
		Pinv.Id as InvoiceId,
		Pinv.Total, Pinv.InvoiceNumber, Pinv.Status as InvoiceStatus,
		
		(select PayrollPayCheck.*, Journal.DocumentId DocumentId from PayrollPayCheck, Journal where PayrollPayCheck.Id=Journal.PayrollPayCheckId and PayrollPayCheck.PEOASOCoCheck=Journal.PEOASOCoCheck and PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path('PayrollPayCheckJson'), Elements, type) PayrollPayChecks
		from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
		Where
		((@void is null) or (@void is not null and exists(select 'x' from PayrollPayCheck where PayrollId=Payroll.Id and IsVoid=0)))
		and ((@invoice is not null and cast(@invoice as uniqueidentifier)=Pinv.Id) or (@invoice is null))
		and ((@id is not null and Payroll.Id=@id) or (@id is null)) 
		and ((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
		and ((@startdate is not null and PayDay>=@startdate) or (@startdate is null)) 
		and ((@enddate is not null and PayDay<=@enddate) or (@enddate is null)) 
		and ((@status is not null and Payroll.Status=cast(@status as int)) or @status is null)
		Order by PayDay
		for Xml path('PayrollJson'), root('PayrollList'), elements, type
	else
		begin
			if @company is not null
				select
				top(1) Payroll.*,
				Pinv.Id as InvoiceId,
				Pinv.Total, Pinv.InvoiceNumber, Pinv.Status as InvoiceStatus,
		
				(select PayrollPayCheck.*, Journal.DocumentId DocumentId from PayrollPayCheck, Journal where PayrollPayCheck.Id=Journal.PayrollPayCheckId and PayrollPayCheck.PEOASOCoCheck=Journal.PEOASOCoCheck and PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path('PayrollPayCheckJson'), Elements, type) PayrollPayChecks
				from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
				Where				
				((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
				Order by PayDay
				for Xml path('PayrollJson'), root('PayrollList'), elements, type
			
			
		end
		
	
	
END
GO

