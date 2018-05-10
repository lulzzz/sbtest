IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Company'
                 AND COLUMN_NAME = 'DashboardNotes')
Alter table Company add DashboardNotes varchar(max);
Go
/****** Object:  StoredProcedure [dbo].[GetCompanyPayrollSchedules]    Script Date: 10/05/2018 5:25:06 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyPayrollSchedules]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyPayrollSchedules]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyPayrollSchedules]    Script Date: 10/05/2018 5:25:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyPayrollSchedules]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCompanyPayrollSchedules] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetCompanyPayrollSchedules]
	@role varchar(max) = null,
	@criteria varchar(max) = null,
	@onlyActive bit = 1
AS
BEGIN
	
	declare @tmpSchedules table (
		schedule int not null
	)
	insert into @tmpSchedules
	SELECT 
		 Split.a.value('.', 'VARCHAR(100)') AS schedule  
	FROM  
	(
		SELECT CAST ('<M>' + REPLACE(@criteria, ',', '</M><M>') + '</M>' AS XML) AS CVS 
	) AS A CROSS APPLY CVS.nodes ('/M') AS Split(a)

	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration
	select 'GetCompanyPayrollSchedules' Report;
	select 
	HostId, c.Id CompanyId, h.FirmName Host, c.CompanyName Company, c.PayrollScheduleDay, c.DashboardNotes,
	case 
		when exists(select 'x' TargetObject from EntityRelation where SourceEntityTypeId=2 and SourceEntityId=c.Id and TargetEntityTypeId=4) then
			(select top(1) TargetObject from EntityRelation where SourceEntityTypeId=2 and SourceEntityId=c.Id and TargetEntityTypeId=4) 
		else
			case when c.ParentId is not null and exists(select 'x' TargetObject from EntityRelation where SourceEntityTypeId=2 and SourceEntityId=c.ParentId and TargetEntityTypeId=4) then
				(select top(1) TargetObject from EntityRelation where SourceEntityTypeId=2 and SourceEntityId=c.ParentId and TargetEntityTypeId=4) 
			end
		end Contact
	from
	Company c, Host h 
	where
	c.HostId = h.Id
	and c.StatusId=1
	and ((@criteria is null) or (@criteria is not null and exists(select 'x' from @tmpSchedules where schedule=c.PayrollScheduleDay)))
	and ((@role is not null and @role='HostStaff' and IsHostCompany=0) 
			or (@role is not null and @role='CorpStaff' and (HostId<>@rootHost or (HostId=@rootHost and IsHostCompany=0))) 
			or (@role is null))
	order by c.PayrollScheduleDay desc
	
	
END
GO

