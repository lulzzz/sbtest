IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyRenewal'
                 AND COLUMN_NAME = 'LastRenewed')
Alter table CompanyRenewal Add LastRenewed datetime, LastRenewedBy varchar(max);
Go

/****** Object:  StoredProcedure [dbo].[GetStaffDashboard]    Script Date: 31/03/2020 6:15:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetStaffDashboard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetStaffDashboard]
GO
/****** Object:  StoredProcedure [dbo].[GetStaffDashboard]    Script Date: 31/03/2020 6:15:27 PM ******/
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
		--(SELECT *  FROM 
		--	( 
		--	  select c.HostId, p.CompanyId, c.CompanyName, p.ProcessedBy UserName, p.ProcessedOn TS from PayrollInvoice p, Company c
		--		where p.CompanyId=c.Id
		--		and p.ProcessedOn>DATEADD(day, -15, getdate())
		--		and ((@host is null) or (c.HostId=@host))
		--	)a 			
		--	for xml path('StaffDashboardCubeJson'), elements, type
		--) InvoicesCreated,
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
		) MissedPayrolls,
		(
			select Host, Company, InvoiceSetup, Description,  DueDate, CompanyId, RenewalId, ReminderDays RemindDaysBefore
	
			from	
			(select c.Id as CompanyId, c.CompanyName as Company, h.Id as HostId, h.FirmName as Host, cc.InvoiceSetup, cr.description,
				Case
					when cr.LastRenewed is not null then
						DATEADD(year, 1, cr.LastRenewed)
					else 
						case 
							when month(getdate())=cr.Month and day(getdate())<=cr.Day then
								cast((cast(cr.[month] as varchar(2)) + '/' + cast(cr.[day] as varchar(2)) + '/' + cast(year(getdate())+1 as varchar(4))) as datetime)
							Else
								cast((cast(cr.[month] as varchar(2)) + '/' + cast(cr.[day] as varchar(2)) + '/' + cast(year(getdate()) as varchar(4))) as datetime)
						end
			
				end DueDate, cr.Id RenewalId, cr.ReminderDays
		
			from Company c, Host h , CompanyRenewal cr, CompanyContract cc
			Where 
			c.StatusId=1
			and h.id = c.HostId
			and c.Id=cc.CompanyId
			and c.Id=cr.CompanyId
				
			and ((@host is not null and c.HostId=@host) or (@host is null))
			) a
			where DATEAdd(day, -1*ReminderDays, DueDate) between dateadd(day, -15, getdate()) and dateadd(day, 15, getdate())
			for xml path('CompanyDueDateJson'), elements, type
		) RenewalDue

	for xml Path('StaffDashboardJson'), elements, type
END
GO
