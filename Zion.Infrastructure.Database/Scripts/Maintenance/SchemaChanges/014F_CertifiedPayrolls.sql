
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TimesheetEntry_Employee]') AND parent_object_id = OBJECT_ID(N'[dbo].[TimesheetEntry]'))
ALTER TABLE [dbo].[TimesheetEntry] DROP CONSTRAINT [FK_TimesheetEntry_Employee]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TimesheetEntry_CompanyProject]') AND parent_object_id = OBJECT_ID(N'[dbo].[TimesheetEntry]'))
ALTER TABLE [dbo].[TimesheetEntry] DROP CONSTRAINT [FK_TimesheetEntry_CompanyProject]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ComapnyProject_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyProject]'))
ALTER TABLE [dbo].[CompanyProject] DROP CONSTRAINT [FK_ComapnyProject_Company]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_TimesheetEntry_IsApproved]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TimesheetEntry] DROP CONSTRAINT [DF_TimesheetEntry_IsApproved]
END
GO
/****** Object:  Table [dbo].[TimesheetEntry]    Script Date: 11/05/2020 12:46:19 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TimesheetEntry]') AND type in (N'U'))
DROP TABLE [dbo].[TimesheetEntry]
GO
/****** Object:  Table [dbo].[CompanyProject]    Script Date: 11/05/2020 12:46:19 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyProject]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyProject]
GO
/****** Object:  Table [dbo].[CompanyProject]    Script Date: 11/05/2020 12:46:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyProject](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[ProjectId] [varchar](max) NOT NULL,
	[ProjectName] [varchar](max) NOT NULL,
	[AwardingBody] [varchar](max) NOT NULL,
	[RegistrationNo] [varchar](max) NOT NULL,
	[LicenseNo] [varchar](max) NOT NULL,
	[LicenseType] [varchar](max) NOT NULL,
	[PolicyNo] [varchar](max) NOT NULL,
	[Classification] [varchar](max) NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
 CONSTRAINT [PK_ComapnyProject] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TimesheetEntry_Employee]') AND parent_object_id = OBJECT_ID(N'[dbo].[TimesheetEntry]'))
ALTER TABLE [dbo].[TimesheetEntry] DROP CONSTRAINT [FK_TimesheetEntry_Employee]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TimesheetEntry_CompanyProject]') AND parent_object_id = OBJECT_ID(N'[dbo].[TimesheetEntry]'))
ALTER TABLE [dbo].[TimesheetEntry] DROP CONSTRAINT [FK_TimesheetEntry_CompanyProject]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_TimesheetEntry_IsPaid]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TimesheetEntry] DROP CONSTRAINT [DF_TimesheetEntry_IsPaid]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_TimesheetEntry_IsApproved]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TimesheetEntry] DROP CONSTRAINT [DF_TimesheetEntry_IsApproved]
END
GO
/****** Object:  Table [dbo].[TimesheetEntry]    Script Date: 13/05/2020 12:23:10 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TimesheetEntry]') AND type in (N'U'))
DROP TABLE [dbo].[TimesheetEntry]
GO
/****** Object:  Table [dbo].[TimesheetEntry]    Script Date: 13/05/2020 12:23:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimesheetEntry](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[ProjectId] [int] NULL,
	[EntryDate] [datetime] NOT NULL,
	[Description] [varchar](max) NULL,
	[Hours] [decimal](18, 2) NOT NULL,
	[Overtime] [decimal](18, 2) NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
	[IsApproved] [bit] NOT NULL,
	[ApprovedBy] [varchar](max) NULL,
	[ApprovedOn] [datetime] NULL,
	[IsPaid] [bit] NOT NULL,
	[PayrollId] [uniqueidentifier] NULL,
	[PayDay] [datetime] NULL,
 CONSTRAINT [PK_TimesheetEntry] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[TimesheetEntry] ADD  CONSTRAINT [DF_TimesheetEntry_IsApproved]  DEFAULT ((0)) FOR [IsApproved]
GO
ALTER TABLE [dbo].[TimesheetEntry] ADD  CONSTRAINT [DF_TimesheetEntry_IsPaid]  DEFAULT ((0)) FOR [IsPaid]
GO
ALTER TABLE [dbo].[TimesheetEntry]  WITH CHECK ADD  CONSTRAINT [FK_TimesheetEntry_CompanyProject] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[CompanyProject] ([Id])
GO
ALTER TABLE [dbo].[TimesheetEntry] CHECK CONSTRAINT [FK_TimesheetEntry_CompanyProject]
GO
ALTER TABLE [dbo].[TimesheetEntry]  WITH CHECK ADD  CONSTRAINT [FK_TimesheetEntry_Employee] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO
ALTER TABLE [dbo].[TimesheetEntry] CHECK CONSTRAINT [FK_TimesheetEntry_Employee]
GO


/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 11/05/2020 12:47:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 11/05/2020 12:47:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCompanies]
	@host uniqueidentifier = null,
	@role varchar(max) = null,
	@status varchar(max) = null,
	@id uniqueidentifier=null
AS
BEGIN
	declare @host1 uniqueidentifier = @host,
	@role1 varchar(max) = @role,
	@status1 varchar(max) = @status,
	@id1 uniqueidentifier=@id

		declare @where nvarchar(max) = ''
	if @id1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'Id=''' + cast(@Id1 as varchar(max))+''''
	if @status1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'statusId=' + cast(@status1 as varchar(max))
	if @host1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'HostId=''' + cast(@host1 as varchar(max)) + ''''
	
	if @role1 is not null and @role1='HostStaff'
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'IsHostCompany=0 and IsVisibleToHost=1'
	if @role1 is not null and @role1='CorpStaff'
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'IsHostCompany=0'

		declare @query nvarchar(max) ='
		select 
		CompanyJson.*,
		case when exists(select ''x'' from company where parentid=CompanyJson.Id) then 1 else 0 end HasLocations
		,
		(select *, (select * from DeductionType where Id=CompanyDeduction.TypeId for Xml path(''DeductionType''), elements, type) from (select * from CompanyDeduction left outer join DeductionCompanyWithheld on Id=CompanyDeductionId where CompanyId=CompanyJson.Id) CompanyDeduction for xml auto, elements, type) CompanyDeductions,
		(select * from CompanyWorkerCompensation Where CompanyId=CompanyJson.Id for Xml auto, elements, type) CompanyWorkerCompensations,
		(select *, (select * from PayType Where Id=CompanyAccumlatedPayType.PayTypeId for xml path(''PayType''), elements, type) from CompanyAccumlatedPayType Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyAccumlatedPayTypes,
		(select * from CompanyContract Where CompanyId=CompanyJson.Id for xml path(''CompanyContract''), elements, type), 
		(select * from CompanyRecurringCharge Where CompanyId=CompanyJson.Id for xml auto, elements, type) RecurringCharges, 
		(select *,(select * from Tax where Id=CompanyTaxRate.TaxId for xml path(''Tax''), elements, type) from CompanyTaxRate Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyTaxRates,
		(select * from CompanyTaxState Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyTaxStates, 
		(select * from CompanyPayCode Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyPayCodes,
		(select * from CompanyRenewal Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyRenewals,
		(select * from CompanyProject Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyProjects,
		(select * from Company Where ParentId=CompanyJson.Id for xml path(''CompanyJson''), elements, type) Locations,
		(select * from InsuranceGroup Where Id=CompanyJson.InsuranceGroupNo for xml auto, elements, type),
		(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId=2 and SourceEntityId=CompanyJson.Id and TargetEntityTypeId=4 order by EntityRelation.EntityRelationId desc) Contact
		From Company CompanyJson '
		+ case when len(@where)>1 then ' Where ' + @where else '' end +
		' Order by CompanyJson.CompanyIntId
		for Xml path(''CompanyJson''), root(''CompanyList'') , elements, type'
		print @query
		Execute(@query)
		
		
	

END
GO
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'companytsimportmap'
                 AND COLUMN_NAME = 'Type')
Alter table companytsimportmap Add Type int not null default(1);
Go
if exists(SELECT 'x' FROM information_schema.table_constraints WHERE constraint_type = 'PRIMARY KEY' AND table_name = 'companytsimportmap')
	alter table companytsimportmap drop constraint PK_CompanyTSImportMap;
if not exists(SELECT 'x' FROM information_schema.table_constraints WHERE constraint_type = 'PRIMARY KEY' AND table_name = 'companytsimportmap')
	alter table companytsimportmap add primary key (CompanyId, Type);
