/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 9/03/2017 11:29:24 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployees]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckPayTypeAccumulation_PayType]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]'))
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] DROP CONSTRAINT [FK_PayCheckPayTypeAccumulation_PayType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckPayTypeAccumulation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]'))
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] DROP CONSTRAINT [FK_PayCheckPayTypeAccumulation_PayrollPayCheck]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayCheckPayTypeAccumulation_CarryOver]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] DROP CONSTRAINT [DF_PayCheckPayTypeAccumulation_CarryOver]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayCheckPayTypeAccumulation_Used]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] DROP CONSTRAINT [DF_PayCheckPayTypeAccumulation_Used]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayCheckPayTypeAccumulation_AccumulatedValue]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] DROP CONSTRAINT [DF_PayCheckPayTypeAccumulation_AccumulatedValue]
END

GO
/****** Object:  Table [dbo].[PayCheckPayTypeAccumulation]    Script Date: 9/03/2017 11:29:24 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]') AND type in (N'U'))
DROP TABLE [dbo].[PayCheckPayTypeAccumulation]
GO
/****** Object:  Table [dbo].[PayCheckPayTypeAccumulation]    Script Date: 9/03/2017 11:29:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PayCheckPayTypeAccumulation](
	[PayCheckId] [int] NOT NULL,
	[PayTypeId] [int] NOT NULL,
	[FiscalStart] [datetime] NOT NULL,
	[FiscalEnd] [datetime] NOT NULL,
	[AccumulatedValue] [decimal](18, 2) NOT NULL,
	[Used] [decimal](18, 2) NOT NULL,
	[CarryOver] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_PayCheckPayTypeAccumulation] PRIMARY KEY CLUSTERED 
(
	[PayCheckId] ASC,
	[PayTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayCheckPayTypeAccumulation_AccumulatedValue]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] ADD  CONSTRAINT [DF_PayCheckPayTypeAccumulation_AccumulatedValue]  DEFAULT ((0)) FOR [AccumulatedValue]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayCheckPayTypeAccumulation_Used]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] ADD  CONSTRAINT [DF_PayCheckPayTypeAccumulation_Used]  DEFAULT ((0)) FOR [Used]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_PayCheckPayTypeAccumulation_CarryOver]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] ADD  CONSTRAINT [DF_PayCheckPayTypeAccumulation_CarryOver]  DEFAULT ((0)) FOR [CarryOver]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckPayTypeAccumulation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]'))
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckPayTypeAccumulation_PayrollPayCheck] FOREIGN KEY([PayCheckId])
REFERENCES [dbo].[PayrollPayCheck] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckPayTypeAccumulation_PayrollPayCheck]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]'))
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] CHECK CONSTRAINT [FK_PayCheckPayTypeAccumulation_PayrollPayCheck]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckPayTypeAccumulation_PayType]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]'))
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation]  WITH CHECK ADD  CONSTRAINT [FK_PayCheckPayTypeAccumulation_PayType] FOREIGN KEY([PayTypeId])
REFERENCES [dbo].[PayType] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayCheckPayTypeAccumulation_PayType]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayCheckPayTypeAccumulation]'))
ALTER TABLE [dbo].[PayCheckPayTypeAccumulation] CHECK CONSTRAINT [FK_PayCheckPayTypeAccumulation_PayType]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 9/03/2017 11:29:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployees]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetEmployees] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetEmployees]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@role varchar(max) = null,
	@status varchar(max) = null,
	@id uniqueidentifier=null
AS
BEGIN
	select 
		EmployeeJson.*, 
		Company.HostId HostId, 
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName, pta.CarryOver, pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt
			where pc.EmployeeId=EmployeeJson.Id and pc.IsVoid=0 and pc.Id=pta.PayCheckId
			and pta.PayTypeId = pt.Id
			and getdate() between pta.FiscalStart and pta.FiscalEnd
			and pt.Id=6--sick leave
			group by pt.id, pt.Name, pta.carryover, pta.fiscalstart, pta.fiscalend
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) Accumulations,
		(select *, (select *, (select * from DeductionType where Id=CompanyDeduction.TypeId for Xml path('DeductionType'), elements, type) from CompanyDeduction where Id=EmployeeDeduction.CompanyDeductionId for Xml path('CompanyDeduction'), elements, type) from EmployeeDeduction Where EmployeeId=EmployeeJson.Id for xml auto, elements, type) EmployeeDeductions,
		(select *, (select * from BankAccount where Id=EmployeeBankAccount.BankAccountId for Xml path('BankAccount'), elements, type) from EmployeeBankAccount Where EmployeeId=EmployeeJson.Id for xml auto, elements, type) EmployeeBankAccounts,
		(select * from CompanyWorkerCompensation where Id=EmployeeJson.WorkerCompensationId for Xml path('CompanyWorkerCompensation'), elements, type)
		
		From Employee EmployeeJson, Company
		Where
		EmployeeJson.CompanyId = Company.Id
		and ((@id is not null and EmployeeJson.Id=@id) or (@id is null))
		and ((@host is not null and Company.HostId=@host) or (@host is null))
		and ((@company is not null and EmployeeJson.CompanyId=@company) or (@company is null))
		and ((@status is not null and EmployeeJson.StatusId=cast(@status as int)) or (@status is null))
		
		for Xml path('EmployeeJson'), root('EmployeeList') , elements, type
		
	

END
GO
