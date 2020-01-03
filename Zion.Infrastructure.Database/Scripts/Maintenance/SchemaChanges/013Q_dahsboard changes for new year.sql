/****** Object:  StoredProcedure [dbo].[GetEmployeeDashboard]    Script Date: 2/01/2020 2:54:35 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetEmployeeDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetEmployeeDashboard]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyDashboard]    Script Date: 2/01/2020 2:54:35 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyDashboard]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyDashboard]    Script Date: 2/01/2020 2:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCompanyDashboard]
	@company uniqueidentifier
AS
BEGIN
	declare @year int = case when exists(select 'x' from Payroll where companyid=@company and year(TaxPayDay)=year(getdate())) then year(getdate()) else year(getdate())-1 end
	select
		(
			select * from 
			(
			  select pc.PayDay, count(pc.Id) NoOfChecks, sum(pc.grosswage) GrossWage, sum(pc.netwage) NetWage, sum(pc.employeetaxes) EmployeeTaxes, sum(pc.employertaxes) EmployerTaxes, sum(pc.deductionamount) Deductions,
			  rank() over (Partition by pc.CompanyId order by pc.payday desc) DRank
			  from 
			  Payroll p, PayrollPayCheck pc
			  where p.Id=pc.PayrollId
			  and pc.IsVoid=0
			  and pc.CompanyId=@company 
			  and p.IsHistory=0
			  and p.IsVoid=0
			  and year(pc.TaxPayDay)=@year
			  group by pc.PayDay, pc.CompanyId
			)
			a
			for xml path('PayrollMetricJson'), elements, type
		)PayrollHistory,
		(SELECT *  FROM 
			( 
			  SELECT me.ExtractName, me.DepositDate, sum(pct.amount) Amount,
				RANK() OVER (PARTITION BY ExtractName ORDER BY DepositDate DESC) DRank
				FROM MasterExtracts me, PayCheckExtract pce, PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr
				where me.Id=pce.MasterExtractId and pce.PayrollPayCheckId=pc.Id
				and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and 
				((me.ExtractName='Federal941' and tyr.TaxId<6) or (me.ExtractName='Federal940' and tyr.TaxId=6) or (me.ExtractName='StateCAPIT' and tyr.TaxId in (7,8)) or (me.ExtractName='StateCAUI' and tyr.TaxId in (9,10)))
				and year(pc.TaxPayDay)=@year
				and pc.CompanyId=@company
				group by me.ExtractName, me.DepositDate
			)a 			
			for xml path('TaxExtractJson'), elements, type
		) ExtractHistory,
		(
			 select * from (select pc.TaxPayDay DepositDate, c.CompanyName, sum(pct.amount) Amount, 'Federal941' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.CompanyId=@company
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=@year
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId<6
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='Federal941')
			  group by pc.TaxPayDay, c.CompanyName
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, sum(pct.amount) Amount, 'Federal940' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.CompanyId=@company
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=@year
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId=6
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='Federal940')
			  group by pc.TaxPayDay, c.CompanyName
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, sum(pct.amount) Amount, 'StateCAPIT' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.CompanyId=@company
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=@year
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId in (7,8)
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='StateCAPIT')
			  group by pc.TaxPayDay, c.CompanyName
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, sum(pct.amount) Amount, 'StateCAUI' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.CompanyId=@company
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=@year
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId in (9,10)
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='StateCAUI')
			  group by pc.TaxPayDay, c.CompanyName) a
			for xml path('TaxExtractJson'), elements, type
		)PendingExtracts,
		(	select 
			(
				select  eda.*, d.TargetEntityId DocumentId,
				(select *, (select * from DocumentType where Id=d.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=cd.Id for Xml path('CompanyDocumentSubType'), elements, type),
				(select *, (select * from DocumentType where Id=d.Type for Xml path('DocumentType'), elements, type), (select *, (select * from DocumentType where Id=d.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=d.CompanyDocumentSubType for Xml path('CompanyDocumentSubType'), elements, type) from Document where TargetEntityId=d.TargetEntityId for Xml path('Document'), elements, type) 
				from 
				(select e.Id EmployeeId, (e.FirstName +' '+ e.LastName) EmployeeName, ed.DocumentId, ed.FirstAccessed, ed.LastAccessed 
				from Employee e left outer join EmployeeDocumentAccess ed on e.Id=ed.EmployeeId
				where e.CompanyId=@company) eda
				left outer join
				Document d on eda.DocumentId=d.TargetEntityId or eda.DocumentId is null
				inner join CompanyDocumentSubType cd on d.Type=cd.Type and d.CompanyDocumentSubType=cd.Id	
				where cd.TrackAccess=1 and cd.CompanyId=@company 
				and cd.Type in (3,4)
				order by eda.EmployeeName
				for xml path('EmployeeDocumentAccess'), elements, type
			) EmployeeDocumentAccesses,
			(
				select eda.*, 
				(select *, (select * from DocumentType where Id=cd.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=cd.Id for Xml path('CompanyDocumentSubType'), elements, type),
	 
				cd.CompanyId, 
				(select *, (select * from DocumentType where Id=cd.Type for Xml path('DocumentType'), elements, type), (select *, (select * from DocumentType where Id=cd.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=cd.Id for Xml path('CompanyDocumentSubType'), elements, type) 
				from Document where TargetEntityId=eda.DocumentId for Xml path('Document'), elements, type) 
				from 
				(select e.Id EmployeeId, (e.FirstName +' '+ e.LastName) EmployeeName, ed.DocumentId, ed.CompanyDocumentSubType, ed.DateUploaded, ed.UploadedBy 
					from Employee e left outer join EmployeeDocument ed on e.Id=ed.EmployeeId
					where e.CompanyId=@company) eda
					left outer join CompanyDocumentSubType cd on eda.CompanyDocumentSubType=cd.Id or eda.CompanyDocumentSubType is null	
				where cd.CompanyId=@company 
				and cd.Type in (5) 
				order by eda.EmployeeName, eda.DocumentId
				for xml path('EmployeeDocument'), elements, type
			) EmployeeDocumentRequirements 
		for xml path('EmployeeDocumentMetaData'), elements, type
		)
	for xml Path('CompanyDashboardJson'), elements, type
END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeeDashboard]    Script Date: 2/01/2020 2:54:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmployeeDashboard]
	@company uniqueidentifier,
	@employee uniqueidentifier
AS
BEGIN
	declare @year int = case when exists(select 'x' from PayrollPayCheck where IsVoid=0 and companyid=@company and employeeid=@employee and year(TaxPayDay)=year(getdate())) then year(getdate()) else year(getdate())-1 end
	select
		(
			select * from 
			(
			  select pc.PayDay, pc.Deductions DeductionJson, pc.Accumulations, count(pc.Id) NoOfChecks, sum(pc.grosswage) GrossWage, 
			  sum(pc.netwage) NetWage, sum(pc.employeetaxes) EmployeeTaxes, sum(pc.employertaxes) EmployerTaxes, sum(pc.deductionamount) Deductions,
			  rank() over (Partition by pc.CompanyId order by pc.payday desc) DRank
			  from 
			  Payroll p, PayrollPayCheck pc
			  where p.Id=pc.PayrollId
			  and pc.IsVoid=0
			  and pc.CompanyId=@company 
			  and pc.EmployeeId=@employee
			  and p.IsHistory=0
			  and p.IsVoid=0
			  and year(pc.TaxPayDay)=@year
			  group by pc.PayDay, pc.CompanyId, pc.Deductions, pc.Accumulations
			)
			a
			for xml path('PayrollMetricJson'), elements, type
		)PayrollHistory,
		(
			select 
				pt.Id PayTypeId, pt.Name PayTypeName, sum(pta.accumulatedValue) YTDFiscal, sum(pta.used) YTDUsed
			from PayrollPayCheck pc, PayCheckPayTypeAccumulation pta, PayType pt
			where pc.EmployeeId=@employee and pc.IsVoid=0 and pc.Id=pta.PayCheckId
			and pta.PayTypeId = pt.Id		
			group by pt.id, pt.Name
			for Xml path('PayCheckPayTypeAccumulation') , elements, type
		) Accumulations

	for xml Path('CompanyDashboardJson'), elements, type
END
GO
