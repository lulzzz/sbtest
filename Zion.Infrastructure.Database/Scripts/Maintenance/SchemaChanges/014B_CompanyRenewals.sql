/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 2/03/2020 7:02:59 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanies]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyRenewal_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyRenewal]'))
ALTER TABLE [dbo].[CompanyRenewal] DROP CONSTRAINT [FK_CompanyRenewal_Company]
GO
/****** Object:  Table [dbo].[CompanyRenewal]    Script Date: 2/03/2020 7:02:59 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyRenewal]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyRenewal]
GO
/****** Object:  Table [dbo].[CompanyRenewal]    Script Date: 2/03/2020 7:02:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyRenewal](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[Month] [int] NOT NULL,
	[Day] [int] NOT NULL,
 CONSTRAINT [PK_CompanyRenewal] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[CompanyRenewal]  WITH CHECK ADD  CONSTRAINT [FK_CompanyRenewal_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
ALTER TABLE [dbo].[CompanyRenewal] CHECK CONSTRAINT [FK_CompanyRenewal_Company]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 2/03/2020 7:02:59 PM ******/
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
