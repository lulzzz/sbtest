/****** Object:  Index [CIX_DeductionEmployeeWithheld]    Script Date: 16/12/2019 10:19:04 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DeductionEmployeeWithheld]') AND name = N'CIX_DeductionEmployeeWithheld')
DROP INDEX [CIX_DeductionEmployeeWithheld] ON [dbo].[DeductionEmployeeWithheld] WITH ( ONLINE = OFF )
GO
/****** Object:  View [dbo].[DeductionEmployeeWithheld]    Script Date: 16/12/2019 10:19:04 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[DeductionEmployeeWithheld]'))
DROP VIEW [dbo].[DeductionEmployeeWithheld]
GO
/****** Object:  Index [CIX_DeductionCompanyWithheld]    Script Date: 16/12/2019 10:19:04 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DeductionCompanyWithheld]') AND name = N'CIX_DeductionCompanyWithheld')
DROP INDEX [CIX_DeductionCompanyWithheld] ON [dbo].[DeductionCompanyWithheld] WITH ( ONLINE = OFF )
GO
/****** Object:  View [dbo].[DeductionCompanyWithheld]    Script Date: 16/12/2019 10:19:04 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[DeductionCompanyWithheld]'))
DROP VIEW [dbo].[DeductionCompanyWithheld]
GO
/****** Object:  View [dbo].[DeductionCompanyWithheld]    Script Date: 16/12/2019 10:19:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[DeductionCompanyWithheld]
With SchemaBinding 
As
select CompanyDeductionId, sum(Amount) EmployeeWithheld, sum(isnull(EmployerAmount,0)) EmployerWithheld, COUNT_BIG(*) counts 
from dbo.PayrollPayCheck, dbo.PayCheckDeduction
where PayrollPayCheck.Id=PayCheckDeduction.PayCheckId and PayrollPayCheck.IsVoid=0
Group By CompanyDeductionId
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
/****** Object:  Index [CIX_DeductionCompanyWithheld]    Script Date: 16/12/2019 10:19:04 PM ******/
CREATE UNIQUE CLUSTERED INDEX [CIX_DeductionCompanyWithheld] ON [dbo].[DeductionCompanyWithheld]
(
	[CompanyDeductionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  View [dbo].[DeductionEmployeeWithheld]    Script Date: 16/12/2019 10:19:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[DeductionEmployeeWithheld]
With SchemaBinding 
As
SELECT        dbo.PayCheckDeduction.EmployeeDeductionId, SUM(dbo.PayCheckDeduction.Amount) AS EmployeeWithheld, SUM(ISNULL(dbo.PayCheckDeduction.EmployerAmount, 0)) AS EmployerWithheld, COUNT_BIG(*) AS counts
FROM            dbo.PayrollPayCheck INNER JOIN
                         dbo.PayCheckDeduction ON dbo.PayrollPayCheck.Id = dbo.PayCheckDeduction.PayCheckId
WHERE        (dbo.PayrollPayCheck.IsVoid = 0)
GROUP BY dbo.PayCheckDeduction.EmployeeDeductionId
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
/****** Object:  Index [CIX_DeductionEmployeeWithheld]    Script Date: 16/12/2019 10:19:04 PM ******/
CREATE UNIQUE CLUSTERED INDEX [CIX_DeductionEmployeeWithheld] ON [dbo].[DeductionEmployeeWithheld]
(
	[EmployeeDeductionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 16/12/2019 10:20:49 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 16/12/2019 10:20:49 PM ******/
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
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'IsHostCompany=0'
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
		(select * from Company Where ParentId=CompanyJson.Id for xml path(''CompanyJson''), elements, type) Locations,
		(select * from InsuranceGroup Where Id=CompanyJson.InsuranceGroupNo for xml auto, elements, type),
		(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId=2 and SourceEntityId=CompanyJson.Id and TargetEntityTypeId=4 order by EntityRelation.EntityRelationId desc) Contact
		From Company CompanyJson '
		+ case when len(@where)>1 then ' Where ' + @where else '' end +
		' Order by CompanyJson.CompanyIntId
		for Xml path(''CompanyJson''), root(''CompanyList'') , elements, type'

		Execute(@query)
		
		
	

END
GO
