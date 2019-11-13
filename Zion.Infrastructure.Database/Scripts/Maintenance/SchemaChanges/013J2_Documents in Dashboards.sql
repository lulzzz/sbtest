/****** Object:  StoredProcedure [dbo].[GetStaffDashboardDocuments]    Script Date: 13/11/2019 3:59:06 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetStaffDashboardDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetStaffDashboardDocuments]
GO
/****** Object:  StoredProcedure [dbo].[GetStaffDashboard]    Script Date: 13/11/2019 3:59:06 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetStaffDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetStaffDashboard]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractDashboard]    Script Date: 13/11/2019 3:59:06 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractDashboard]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyDashboard]    Script Date: 13/11/2019 3:59:06 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanyDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanyDashboard]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyDashboard]    Script Date: 13/11/2019 3:59:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCompanyDashboard]
	@company uniqueidentifier
AS
BEGIN
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
			  and year(pc.TaxPayDay)=year(getdate())
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
				and year(pc.TaxPayDay)=year(getdate())
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
			  and year(pc.taxpayday)=year(getdate())
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId<6
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='Federal941')
			  group by pc.TaxPayDay, c.CompanyName
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, sum(pct.amount) Amount, 'Federal940' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.CompanyId=@company
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=year(getdate())
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId=6
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='Federal940')
			  group by pc.TaxPayDay, c.CompanyName
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, sum(pct.amount) Amount, 'StateCAPIT' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.CompanyId=@company
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=year(getdate())
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId in (7,8)
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='StateCAPIT')
			  group by pc.TaxPayDay, c.CompanyName
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, sum(pct.amount) Amount, 'StateCAUI' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.CompanyId=@company
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=year(getdate())
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
/****** Object:  StoredProcedure [dbo].[GetExtractDashboard]    Script Date: 13/11/2019 3:59:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetExtractDashboard]
	
AS
BEGIN
	select
		(SELECT *  FROM 
			( 
			  SELECT me.ExtractName, me.DepositDate, sum(pct.amount) Amount,
				RANK() OVER (PARTITION BY ExtractName ORDER BY DepositDate DESC) DRank
				FROM MasterExtracts me, PayCheckExtract pce, PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr
				where me.Id=pce.MasterExtractId and pce.PayrollPayCheckId=pc.Id
				and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and 
				((me.ExtractName='Federal941' and tyr.TaxId<6) or (me.ExtractName='Federal940' and tyr.TaxId=6) or (me.ExtractName='StateCAPIT' and tyr.TaxId in (7,8)) or (me.ExtractName='StateCAUI' and tyr.TaxId in (9,10)))
				and year(pc.TaxPayDay)=year(getdate())
				group by me.ExtractName, me.DepositDate
			)a 			
			for xml path('TaxExtractJson'), elements, type
		) ExtractHistory,
		(
			 select * from (select pc.TaxPayDay DepositDate, c.CompanyName, sum(pct.amount) Amount, 'Federal941' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=year(getdate())
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId<6
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='Federal941')
			  group by pc.TaxPayDay, c.CompanyName
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, sum(pct.amount) Amount, 'Federal940' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=year(getdate())
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId=6
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='Federal940')
			  group by pc.TaxPayDay, c.CompanyName
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, sum(pct.amount) Amount, 'StateCAPIT' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=year(getdate())
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId in (7,8)
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='StateCAPIT')
			  group by pc.TaxPayDay, c.CompanyName
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, sum(pct.amount) Amount, 'StateCAUI' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=year(getdate())
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId in (9,10)
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='StateCAUI')
			  group by pc.TaxPayDay, c.CompanyName) a
			for xml path('TaxExtractJson'), elements, type
		)PendingExtracts
	for xml Path('CompanyDashboardJson'), elements, type
END
GO
/****** Object:  StoredProcedure [dbo].[GetStaffDashboard]    Script Date: 13/11/2019 3:59:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetStaffDashboard]
	@host uniqueidentifier = null
AS
BEGIN
	select
		(SELECT *  FROM 
			( 
			  select c.HostId, p.CompanyId, c.CompanyName, p.LastModifiedBy UserName, p.LastModified TS from payroll p, Company c
				where p.CompanyId=c.Id
				and p.LastModified>DATEADD(day, -15, getdate())
				and ((@host is null) or (c.HostId=@host))
			)a 			
			for xml path('StaffDashboardCubeJson'), elements, type
		) PayrollsProcessed,
		(SELECT *  FROM 
			( 
			  select c.HostId, p.CompanyId, p.CompanyName, p.[User] UserName, p.TS from PayrollVoidLog p, Company c
				where p.CompanyId=c.Id
				and p.TS>DATEADD(day, -15, getdate())
				and ((@host is null) or (c.HostId=@host))
			)a 			
			for xml path('StaffDashboardCubeJson'), elements, type
		) PayrollsVoided,
		(SELECT *  FROM 
			( 
			  select c.HostId, p.CompanyId, c.CompanyName, p.ProcessedBy UserName, p.ProcessedOn TS from PayrollInvoice p, Company c
				where p.CompanyId=c.Id
				and p.ProcessedOn>DATEADD(day, -15, getdate())
				and ((@host is null) or (c.HostId=@host))
			)a 			
			for xml path('StaffDashboardCubeJson'), elements, type
		) InvoicesCreated,
		(SELECT *  FROM 
			( 
			  select c.HostId, p.CompanyId, c.CompanyName, p.DeliveryClaimedBy UserName, p.ProcessedOn TS from PayrollInvoice p, Company c
				where p.CompanyId=c.Id
				and p.DeliveryClaimedOn>DATEADD(day, -15, getdate())
				and ((@host is null) or (c.HostId=@host))
			)a  			
			for xml path('StaffDashboardCubeJson'), elements, type
		) InvoicesDelivered,
		(SELECT *  FROM 
			( 
			  select c.HostId, c.Id as CompanyId, c.CompanyName, c.LastModifiedBy UserName, c.LastModified TS 
			  from Company c
				where c.LastModified>DATEADD(day, -15, getdate())
				and ((@host is null) or (c.HostId=@host))
			)a  			
			for xml path('StaffDashboardCubeJson'), elements, type
		) CompaniesUpdated,
		(SELECT *  FROM 
			( 
			 select *
	
				from	
				(select c.Id as CompanyId, c.CompanyName, h.Id as HostId, 
					Case
						When c.LastPayrollDate is not null Then
							Case
								When c.PayrollSchedule=1 then
									DateAdd(day, 7, c.LastPayrollDate)
				
								When c.PayrollSchedule=2 then
									DateAdd(day, 14, c.LastPayrollDate)
				
								When c.PayrollSchedule=3 then
									DateAdd(day, 15, c.LastPayrollDate)
				
								When c.PayrollSchedule=4 then
									DateAdd(MONTH, 1, c.LastPayrollDate)
							End
						Else
							Cast('01/01/' + cast(year(getdate()) as varchar(max)) as datetime)
					
			
					end TS, dbo.GetLastBusinessDate() LastBusinessDay
		
				from Company c, Host h
				Where 
				c.StatusId=1
				and h.id = c.HostId
				and ((@host is null) or (c.HostId=@host))
				) a
				where DateDiff(day, dbo.GetLastBusinessDate(), [TS])<16
			)a 			
			for xml path('StaffDashboardCubeJson'), elements, type
		) MissedPayrolls

	for xml Path('StaffDashboardJson'), elements, type
END
GO
/****** Object:  StoredProcedure [dbo].[GetStaffDashboardDocuments]    Script Date: 13/11/2019 3:59:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[GetStaffDashboardDocuments]
	@host uniqueidentifier = null
AS
BEGIN
	select
			(
				select  eda.*, d.TargetEntityId DocumentId,
				(select *, (select * from DocumentType where Id=d.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=cd.Id for Xml path('CompanyDocumentSubType'), elements, type),
				(select *, (select * from DocumentType where Id=d.Type for Xml path('DocumentType'), elements, type), (select *, (select * from DocumentType where Id=d.Type for Xml path('DocumentType'), elements, type) from CompanyDocumentSubType where Id=d.CompanyDocumentSubType for Xml path('CompanyDocumentSubType'), elements, type) from Document where TargetEntityId=d.TargetEntityId for Xml path('Document'), elements, type) 
				from 
				(select h.FirmName HostName, h.Id HostId, c.CompanyName, c.Id CompanyId, e.Id EmployeeId, (e.FirstName +' '+ e.LastName) EmployeeName, ed.DocumentId, ed.FirstAccessed, ed.LastAccessed 
				from Host h, Company c, Employee e left outer join EmployeeDocumentAccess ed on e.Id=ed.EmployeeId
				where
				h.Id=c.HostId and c.Id=e.CompanyId
				and ((@host is null) or (c.HostId=@host))) eda
				left outer join
				Document d on eda.DocumentId=d.TargetEntityId or eda.DocumentId is null
				inner join CompanyDocumentSubType cd on d.Type=cd.Type and d.CompanyDocumentSubType=cd.Id	
				where cd.TrackAccess=1 and cd.CompanyId=eda.CompanyId 
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
				(select h.FirmName HostName, h.Id HostId, c.CompanyName, c.Id CompanyId, e.Id EmployeeId, (e.FirstName +' '+ e.LastName) EmployeeName, ed.DocumentId, ed.CompanyDocumentSubType, ed.DateUploaded, ed.UploadedBy 
					from Host h, Company c, Employee e left outer join EmployeeDocument ed on e.Id=ed.EmployeeId
					where h.Id=c.HostId and c.Id=e.CompanyId
				and ((@host is null) or (c.HostId=@host))) eda
					left outer join CompanyDocumentSubType cd on eda.CompanyDocumentSubType=cd.Id or eda.CompanyDocumentSubType is null	
				where cd.CompanyId=eda.CompanyId 
				and cd.Type in (5) 
				order by eda.EmployeeName, eda.DocumentId
				for xml path('EmployeeDocument'), elements, type
			) EmployeeDocumentRequirements 
		for xml path('EmployeeDocumentMetaData'), elements, type
		
		

	
END
GO

set identity_insert Document On
insert into Document(Id, SourceEntityTypeId, SourceEntityId, targetentityid, targetobject, Type, UploadedBy, Uploaded)
select EntityRelationId, SourceEntityTypeId, SourceEntityId, TargetEntityId,  
TargetObject, 1, '', GETDATE()
from EntityRelation where TargetEntityTypeId=13 
and SourceEntityTypeId in (2,3) 
set identity_insert Document Off
