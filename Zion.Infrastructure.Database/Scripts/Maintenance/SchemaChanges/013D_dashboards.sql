/****** Object:  StoredProcedure [dbo].[GetStaffDashboard]    Script Date: 6/08/2019 4:04:13 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetStaffDashboard]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractDashboard]    Script Date: 6/08/2019 4:04:13 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetExtractDashboard]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeeDashboard]    Script Date: 6/08/2019 4:04:13 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetEmployeeDashboard]
GO
/****** Object:  UserDefinedFunction [dbo].[GetLastBusinessDate]    Script Date: 6/08/2019 4:04:13 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetLastBusinessDate]
GO
/****** Object:  UserDefinedFunction [dbo].[GetLastBusinessDate]    Script Date: 6/08/2019 4:04:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[GetLastBusinessDate] 
(
)
RETURNS DateTime
AS
BEGIN
	return  DATEADD(DAY, CASE DATENAME(WEEKDAY, GETDATE()) 
                        WHEN 'Sunday' THEN -2 
                        WHEN 'Monday' THEN -3 
                        ELSE -1 END, DATEDIFF(DAY, 0, GETDATE()))
END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeeDashboard]    Script Date: 6/08/2019 4:04:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[GetEmployeeDashboard]
	@company uniqueidentifier,
	@employee uniqueidentifier
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
			  and pc.EmployeeId=@employee
			  and p.IsHistory=0
			  and p.IsVoid=0
			  and year(pc.TaxPayDay)=year(getdate())
			  group by pc.PayDay, pc.CompanyId
			)
			a
			for xml path('PayrollMetricJson'), elements, type
		)PayrollHistory

	for xml Path('CompanyDashboardJson'), elements, type
END
GO
/****** Object:  StoredProcedure [dbo].[GetExtractDashboard]    Script Date: 6/08/2019 4:04:13 PM ******/
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
			  and year(pc.taxpayday)=2019
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId<6
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='Federal941')
			  group by pc.TaxPayDay, c.CompanyName
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, sum(pct.amount) Amount, 'Federal940' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=2019
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId=6
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='Federal940')
			  group by pc.TaxPayDay, c.CompanyName
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, sum(pct.amount) Amount, 'StateCAPIT' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=2019
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId in (7,8)
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='StateCAPIT')
			  group by pc.TaxPayDay, c.CompanyName
			  union
			  select pc.TaxPayDay DepositDate, c.CompanyName, sum(pct.amount) Amount, 'StateCAUI' ExtractName
			  from PayrollPayCheck pc, PayCheckTax pct, TaxYearRate tyr, Company c
			  where pc.CompanyId=c.Id and c.StatusId<>3 and c.ManageTaxPayment=1
			  and pc.IsVoid=0 and pc.IsHistory=0
			  and year(pc.taxpayday)=2019
			  and pc.Id=pct.PayCheckId and pct.TaxId=tyr.Id and tyr.TaxId in (9,10)
			  and not exists(select 'x' from PayCheckExtract pce, MasterExtracts me where pce.PayrollPayCheckId=pc.Id and pce.Type=1 and pce.MasterExtractId=me.Id and me.ExtractName='StateCAUI')
			  group by pc.TaxPayDay, c.CompanyName) a
			for xml path('TaxExtractJson'), elements, type
		)PendingExtracts
	for xml Path('CompanyDashboardJson'), elements, type
END
GO
/****** Object:  StoredProcedure [dbo].[GetStaffDashboard]    Script Date: 6/08/2019 4:04:13 PM ******/
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
