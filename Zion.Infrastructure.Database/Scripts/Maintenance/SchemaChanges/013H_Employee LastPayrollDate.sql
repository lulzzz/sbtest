/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 18/10/2019 10:25:40 AM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetEmployees]
GO
/****** Object:  View [dbo].[EmployeeLastPayDay]    Script Date: 18/10/2019 10:25:40 AM ******/
DROP VIEW IF EXISTS [dbo].[EmployeeLastPayDay]
GO
/****** Object:  View [dbo].[EmployeeLastPayDay]    Script Date: 18/10/2019 10:25:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[EmployeeLastPayDay]
With SchemaBinding 
As
select EmployeeId, max(PayDay) PayDay, COUNT_BIG(*) counts from dbo.PayrollPayCheck where IsVoid=0 group by EmployeeId;
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 18/10/2019 10:25:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmployees]
	@host uniqueidentifier = null,
	@company uniqueidentifier = null,
	@role varchar(max) = null,
	@status varchar(max) = null,
	@id uniqueidentifier=null
AS
BEGIN
declare @host1 uniqueidentifier = @host,
	@company1 uniqueidentifier = @company,
	@role1 varchar(max) = @role,
	@status1 varchar(max) = @status,
	@id1 uniqueidentifier=@id

declare @ispeo as bit
declare @hostid as uniqueidentifier
select @ispeo=fileunderhost, @hostid=HostId from company where id=@company1
print @ispeo
print @hostid
select id into #tmpcomps from company
where 
((@ispeo=1 and HostId=@hostid and FileUnderHost=1)
or
(@ispeo=0 and id=@company1)
)

	declare @where nvarchar(max) = 'EmployeeJson.CompanyId = Company.Id'
	if @id1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'EmployeeJson.Id=''' + cast(@Id1 as varchar(max))+''''
	if @status1 is not null and cast(@status1 as int)>0
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'EmployeeJson.statusId=' + cast(@status1 as varchar(max))
	if @host1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Company.HostId=''' + cast(@host1 as varchar(max)) + ''''
	if @company1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'EmployeeJson.CompanyId=''' + cast(@company1 as varchar(max)) + ''''
	
	declare @query nvarchar(max) ='
	
	select 
		EmployeeJson.*, 
		(select PayDay from dbo.EmployeeLastPayDay where EmployeeId=EmployeeJson.Id) LastPayDay,
		Company.HostId HostId, 
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName, max(pta.CarryOver) CarryOver, pta.FiscalStart, pta.FiscalEnd, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt, Employee e
			where pc.EmployeeId=e.Id and pc.IsVoid=0 and pc.Id=pta.PayCheckId
			and pta.PayTypeId = pt.Id
			and e.SSN=EmployeeJson.SSN
			and pc.CompanyId in (select id from #tmpcomps)
			group by pt.id, pt.Name, pta.fiscalstart, pta.fiscalend
			for Xml path(''PayCheckPayTypeAccumulation'') , elements, type
		) Accumulations,
		(select *, (select *, (select * from DeductionType where Id=CompanyDeduction.TypeId for Xml path(''DeductionType''), elements, type) from CompanyDeduction where Id=EmployeeDeduction.CompanyDeductionId for Xml path(''CompanyDeduction''), elements, type) from EmployeeDeduction Where EmployeeId=EmployeeJson.Id for xml auto, elements, type) EmployeeDeductions,
		(select *, (select * from BankAccount where Id=EmployeeBankAccount.BankAccountId for Xml path(''BankAccount''), elements, type) from EmployeeBankAccount Where EmployeeId=EmployeeJson.Id for xml auto, elements, type) EmployeeBankAccounts,
		(select * from CompanyWorkerCompensation where Id=EmployeeJson.WorkerCompensationId for Xml path(''CompanyWorkerCompensation''), elements, type)
		
		From Employee EmployeeJson, Company
		Where
		 ' + @where + ' for Xml path(''EmployeeJson''), root(''EmployeeList'') , elements, type'
		
		Execute(@query)
		
	

END
GO
