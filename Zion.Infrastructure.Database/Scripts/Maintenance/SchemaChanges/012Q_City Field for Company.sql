IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Company'
                 AND COLUMN_NAME = 'City')
Alter table Company Add City varchar(100) not null Default('');
Go
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Company]') AND name = N'IX_CompanyCity')
CREATE NONCLUSTERED INDEX [IX_CompanyCity] ON [dbo].[Company]
(
	[City] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[GetMinWageEligibleCompanies]    Script Date: 7/01/2019 3:23:10 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMinWageEligibleCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetMinWageEligibleCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetMinWageEligibleCompanies]    Script Date: 7/01/2019 3:23:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMinWageEligibleCompanies]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetMinWageEligibleCompanies] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetMinWageEligibleCompanies]
	@contractType int = 2,
	@minWage decimal(18,2) = null,
	@statusId int = 0,
	@city varchar(max) = null,
	@payrollYear int
AS
BEGIN
	select * into #tmpCompanyPaidEmployees from 
	(
	select p.companyid CompanyId, c.CompanyName, count(distinct e.SSN) Employees 
	from payroll p, PayrollPayCheck pc, Company c, Employee e
	where p.id=pc.payrollid and pc.IsVoid=0 and p.IsVoid=0
	and pc.EmployeeId=e.id
	and c.FileUnderHost=0
	and p.CompanyId=c.Id
	and year(p.payday)=@payrollYear
	group by p.CompanyId, c.CompanyName
	Union
	select hc.id CompanyId, hc.CompanyName, count(distinct e.SSN) Employees 
	from payroll p, PayrollPayCheck pc, Company c, Company hc, Employee e
	where p.id=pc.payrollid and pc.IsVoid=0 and p.IsVoid=0
	and pc.EmployeeId=e.id
	and year(p.payday)=@payrollYear
	and p.CompanyId=c.Id
	and c.FileUnderHost=1
	and c.HostId=hc.HostId and hc.IsHostCompany=1
	group by hc.Id, hc.CompanyName
	) a

	select h.firmname Host, c.Id CompanyId, c.CompanyName Company, c.MinWage, c.FileUnderHost, c.City,
	(select count(Id) from Employee where CompanyId=c.Id and StatusId=1) ActiveEmployeeCount,
	(select Employees from #tmpCompanyPaidEmployees where CompanyId=c.Id) PaidEmployeeCount,

	(
		select e.Id, e.FirstName, e.LastName, e.Rate from Employee e 
		where e.CompanyId=c.Id and e.PayType=1 
		and ((@minWage is not null and e.Rate<@minWage) or (@minWage is null))
		for xml path ('MinWageEligibleEmployee'), elements, type
	) 
	Employees
	from company c,  host h
	where c.hostId=h.id
	and ((@statusId>0 and c.statusid=@statusId) or @statusId=0)
	--and ((@contractType<>2 and c.FileUnderHost=@contractType) or (@contractType=2))
	and ((@city is not null and lower(c.City)=@city) or @city is null)
	and (
			(@contractType=1 and c.FileUnderHost=1 and c.IsHostCompany=1 and h.IsPeoHost=1) 
			OR
			(
				(@contractType=0 and c.FileUnderHost=1 and c.IsHostCompany=1 and h.IsPeoHost=0)
				OR
				(@contractType=0 and c.FileUnderHost=0)
			)
			OR
			@contractType=2
		)
	order by h.firmname, FileUnderHost desc, CompanyName
	for Xml path('MinWageEligibileCompany'), root('MinWageEligibleCompanyList'), Elements, type
	
END
GO
