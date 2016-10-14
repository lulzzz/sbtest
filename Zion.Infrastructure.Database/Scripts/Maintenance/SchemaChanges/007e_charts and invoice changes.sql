IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollInvoice'
                 AND COLUMN_NAME = 'Balance')
Alter table PayrollInvoice Add Balance decimal(18,2) not null Default(0);
Go
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollInvoice'
                 AND COLUMN_NAME = 'ProcessedOn')
Alter table PayrollInvoice Add ProcessedOn DateTime not null Default(getdate());
Go
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollInvoice'
                 AND COLUMN_NAME = 'PayChecks')
Alter table PayrollInvoice Add PayChecks varchar(max) not null Default('');
Alter table PayrollInvoice Add VoidedCreditChecks varchar(max) not null Default('');
Alter table PayrollInvoice Add ApplyWCMinWageLimit bit not null Default(0);
Go
Update PayrollInvoice Set ProcessedOn = LastModified;
IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollPayCheck'
                 AND COLUMN_NAME = 'InvoiceId')
Alter table PayrollPayCheck Add InvoiceId uniqueidentifier;
Alter table PayrollPayCheck Add VoidedOn DateTime;
Alter table PayrollPayCheck Add TaxesPaidOn DateTime;
Alter table PayrollPayCheck Add CreditInvoiceId uniqueidentifier;
Alter table PayrollPayCheck Add TaxesCreditedOn DateTime;
Go

IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollPayCheck'
                 AND COLUMN_NAME = 'InvoiceId')
ALTER TABLE [dbo].[PayrollPayCheck]  WITH CHECK ADD  CONSTRAINT [FK_PayrollPayCheck_PayrollInvoice] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[PayrollInvoice] ([Id])
ON DELETE SET NULL
GO

IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollPayCheck'
                 AND COLUMN_NAME = 'InvoiceId')
ALTER TABLE [dbo].[PayrollPayCheck]  WITH CHECK ADD  CONSTRAINT [FK_PayrollPayCheck_PayrollInvoice11] FOREIGN KEY(CreditInvoiceId)
REFERENCES [dbo].[PayrollInvoice] ([Id])
ON DELETE SET NULL
GO


IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollPayCheck'
                 AND COLUMN_NAME = 'InvoiceId')
ALTER TABLE [dbo].[Payroll]  WITH CHECK ADD  CONSTRAINT [FK_Payroll_PayrollInvoice] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[PayrollInvoice] ([Id])
ON DELETE SET NULL
GO



/****** Object:  StoredProcedure [dbo].[GetPayrollChartData]    Script Date: 13/10/2016 3:43:32 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceChartData]    Script Date: 13/10/2016 3:43:32 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceChartData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoiceChartData]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoiceChartData]    Script Date: 13/10/2016 3:43:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceChartData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInvoiceChartData]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	--declare @projectNames varchar(max)
	declare @query varchar(max)

	select c.CompanyName, 
		cast(DateDiff(day, i.invoicedate, getdate()) as varchar(max)) + '' days'' Age,
		i.Id
		into #tmpInspectionData
	from PayrollInvoice i, Company c 
	Where 
	i.CompanyId = c.Id
	and c.StatusId=1
	and i.Balance>0
	and ((@role is not null and @role=''HostStaff'' and c.IsHostCompany=0) or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))

	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + '',['' + cast(CompanyName as varchar) + '']'',''['' + cast(CompanyName as varchar)+ '']'')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = ''select Age, '' +@companies+ '' from (select Age,''+@companies+'' from
	(select distinct Age, CompanyName , Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in (''+@companies+''))Data)row''
	execute(@query)
	
	drop table #tmpInspectionData
END' 
END
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollChartData]    Script Date: 13/10/2016 3:43:32 PM ******/
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

	select h.firmname, c.CompanyName, 
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
		i.Id
		into #tmpInspectionData
	from Company c, Host h, PayrollInvoice i
	Where c.StatusId=1
	and c.HostId = h.Id
	and c.id = i.CompanyId
	and i.balance>0
	--and exists(select ''x'' from PayrollInvoice i where i.CompanyId=c.Id and i.Balance>0)
	and ((@role is not null and @role=''HostStaff'' and c.IsHostCompany=0) or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))

	declare @companies varchar(max)
	SELECT @companies = COALESCE(@companies + '',['' + cast(CompanyName as varchar) + '']'',''['' + cast(CompanyName as varchar)+ '']'')
	FROM (select distinct CompanyName from #tmpInspectionData) a
	
	print @companies
				
	set @query = ''select [Next Payroll Due], '' +@companies+ '' from (select [Next Payroll Due],''+@companies+'' from
	(select distinct [Next Payroll Due], CompanyName, Id 
	from #tmpInspectionData
	) o
	PIVOT (count(Id) for CompanyName in (''+@companies+''))Data)row''
	execute(@query)
	
	drop table #tmpInspectionData
END' 
END
GO
