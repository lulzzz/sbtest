IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetUsers]') AND type in (N'U'))
begin
  insert into AspNetRoles values(100, 'SuperUser1');
  insert into AspNetRoles values(90, 'Master1');
  insert into AspNetRoles values(70, 'CorpStaff1');
  insert into AspNetRoles values(50, 'Host1');
  insert into AspNetRoles values(40, 'HostStaff1');
  insert into AspNetRoles values(30, 'Company1');
  insert into AspNetRoles values(10, 'CompanyManager1');
  insert into AspNetRoles values(0, 'Employee1');

  update AspNetUserRoles set RoleId=0 where RoleId=5;
  update AspNetUserRoles set RoleId=30 where RoleId=4;
  update AspNetUserRoles set RoleId=40 where RoleId=6;
  update AspNetUserRoles set RoleId=50 where RoleId=3;
  update AspNetUserRoles set RoleId=70 where RoleId=2;
  update AspNetUserRoles set RoleId=90 where RoleId=1;
  update AspNetUserRoles set RoleId=100 where RoleId=7;

  delete from AspNetRoles where Id in (1,2,3,4,5,6,7);
  update AspNetRoles set [Name]='Employee' where Id=0;
  update AspNetRoles set [Name]='CompanyManager' where Id=10;
  update AspNetRoles set [Name]='Company' where Id=30;
  update AspNetRoles set  [Name]='HostStaff' where Id=40;
  update AspNetRoles set  [Name]='Host' where Id=50;
  update AspNetRoles set  [Name]='CorpStaff' where Id=70;
  update AspNetRoles set  [Name]='Master' where Id=90;
  update AspNetRoles set  [Name]='SuperUser' where Id=100;
end
  update News set AudienceScope=90 where AudienceScope=1;

  IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PaxolFeatureClaim_PaxolFeature]') AND parent_object_id = OBJECT_ID(N'[dbo].[PaxolFeatureClaim]'))
ALTER TABLE [dbo].[PaxolFeatureClaim] DROP CONSTRAINT [FK_PaxolFeatureClaim_PaxolFeature]
GO
/****** Object:  Table [dbo].[PaxolFeatureClaim]    Script Date: 13/04/2018 11:41:38 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaxolFeatureClaim]') AND type in (N'U'))
DROP TABLE [dbo].[PaxolFeatureClaim]
GO
/****** Object:  Table [dbo].[PaxolFeature]    Script Date: 13/04/2018 11:41:38 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaxolFeature]') AND type in (N'U'))
DROP TABLE [dbo].[PaxolFeature]
GO
/****** Object:  Table [dbo].[PaxolFeature]    Script Date: 13/04/2018 11:41:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaxolFeature]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PaxolFeature](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](max) NOT NULL,
 CONSTRAINT [PK_PaxolFeature] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[PaxolFeatureClaim]    Script Date: 13/04/2018 11:41:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaxolFeatureClaim]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PaxolFeatureClaim](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FeatureId] [int] NOT NULL,
	[ClaimName] [varchar](max) NOT NULL,
	[ClaimType] [varchar](max) NOT NULL,
	[AccessLevel] [int] NOT NULL,
 CONSTRAINT [PK_PaxolFeatureClaim] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PaxolFeatureClaim_PaxolFeature]') AND parent_object_id = OBJECT_ID(N'[dbo].[PaxolFeatureClaim]'))
ALTER TABLE [dbo].[PaxolFeatureClaim]  WITH CHECK ADD  CONSTRAINT [FK_PaxolFeatureClaim_PaxolFeature] FOREIGN KEY([FeatureId])
REFERENCES [dbo].[PaxolFeature] ([Id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PaxolFeatureClaim_PaxolFeature]') AND parent_object_id = OBJECT_ID(N'[dbo].[PaxolFeatureClaim]'))
ALTER TABLE [dbo].[PaxolFeatureClaim] CHECK CONSTRAINT [FK_PaxolFeatureClaim_PaxolFeature]
GO


set identity_insert [dbo].[PaxolFeature] On
insert into PaxolFeature(Id, Name) values(1,'Configuration');
insert into PaxolFeature(Id, Name) values(2,'Host');
insert into PaxolFeature(Id, Name) values(3,'Company');
insert into PaxolFeature(Id, Name) values(4,'Employee');
insert into PaxolFeature(Id, Name) values(5,'Payroll');
insert into PaxolFeature(Id, Name) values(6,'Invoice');
insert into PaxolFeature(Id, Name) values(7,'Checkbook');
insert into PaxolFeature(Id, Name) values(8,'COA');
insert into PaxolFeature(Id, Name) values(9,'Vendor');
insert into PaxolFeature(Id, Name) values(10,'Customer');
insert into PaxolFeature(Id, Name) values(11,'Report');
insert into PaxolFeature(Id, Name) values(12,'Dashboard');
set identity_insert [dbo].[PaxolFeature] Off

insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (1, 'Manage Configurations', 'http://Paxol/ManageConfiguration', 90);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (1, 'Data Extracts', 'http://Paxol/DataExtracts', 90);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (1, 'ACH', 'http://Paxol/ACH', 90);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (2, 'Manage Hosts','http://Paxol/Host/Manage', 70);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (2, 'Contract', 'http://Paxol/Host/Contract', 90);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (2, 'PEO Flag', 'http://Paxol/Host/PEOFlag', 90);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (2, 'Profile','http://Paxol/Host/HostProfile', 40);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (3, 'Profile', 'http://Paxol/Company/Profile', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (3, 'Versions', 'http://Paxol/Company/Versions', 70);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (3, 'Contract', 'http://Paxol/Company/Contract', 40);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (3, 'Payroll Days in Past', 'http://Paxol/Company/PayrollDaysinPast', 70);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (3, 'Acumulated Paytypes Company Managed', 'http://Paxol/Company/AcumulatedPaytypesCompanyManaged', 70);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (3, 'Accumulated PayTypes LumpSum', 'http://Paxol/Company/AccumulatedPayTypesLumpSum', 70);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (3, 'Copy', 'http://Paxol/Company/Copy', 40);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (3, 'Copy Payrolls', 'http://Paxol/Company/CopyPayrolls', 40);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (4, 'Manage Employees', 'http://Paxol/Employee/ManageEmployees', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (4, 'Bulk Terminate', 'http://Paxol/Employee/BulkTerminate', 70);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (4, 'SickLeave Export', 'http://Paxol/Employee/SickLeaveExport', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (4, 'Copy', 'http://Paxol/Employee/Copy', 40);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (4, 'ImportExport', 'http://Paxol/Employee/ImportExport', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (4, 'Versions', 'http://Paxol/Employee/Versions', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (4, 'Editable Accumulatated Pay Types', 'http://Paxol/Employee/EditableAccumulatatedPayTypes', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (4, 'Profile', 'http://Paxol/Employee/Profile', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (4, 'PayChecks', 'http://Paxol/Employee/PayChecks', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (4, 'Reports', 'http://Paxol/Employee/Reports', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (4, 'Deductions', 'http://Paxol/Employee/Deductions', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (5, 'Process', 'http://Paxol/Payroll/Process', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (5, 'Confirm', 'http://Paxol/Payroll/Confirm', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (5, 'Void', 'http://Paxol/Payroll/Void', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (5, 'Delete', 'http://Paxol/Payroll/Delete', 70);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (5, 'Re-Process Re-Confirm', 'http://Paxol/Payroll/ReProcessReConfirm', 70);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (5, 'Void PayCheck', 'http://Paxol/Payroll/VoidPayCheck', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (5, 'Update PayCycle Dates', 'http://Paxol/Payroll/UpdatePayCycleDates', 70);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (5, 'Change CheckNumber series', 'http://Paxol/Payroll/ChangeCheckNumberseries', 90);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (5, 'Fix YTDs', 'http://Paxol/Payroll/FixYTDs', 90);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (5, 'Editable Taxes', 'http://Paxol/Payroll/EditableTaxes', 90);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (5, 'UnVoid Check', 'http://Paxol/Payroll/UnVoidCheck', 40);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (5, 'History Payroll', 'http://Paxol/Payroll/HistoryPayroll', 40);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (5, 'Delivery', 'http://Paxol/Payroll/Delivery', 70);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (5, 'Awaiting Print', 'http://Paxol/Payroll/AwaitingPrint', 70);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (6, 'List', 'http://Paxol/Invoice/List', 70);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (6, 'Commissions', 'http://Paxol/Invoice/Commissions', 90);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (6, 'Delete', 'http://Paxol/Invoice/Delete', 90);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (6, 'Versions', 'http://Paxol/Invoice/Versions', 70);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (6, 'Editable', 'http://Paxol/Invoice/Editable', 70);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (6, 'Payments', 'http://Paxol/Invoice/Payments', 70);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (7, 'Manage', 'http://Paxol/Checkbook/Manage', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (8, 'Manage', 'http://Paxol/COA/Manage', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (9, 'Manage', 'http://Paxol/Vendors/Manage', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (10, 'Manage', 'http://Paxol/Customers/Manage', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (11, 'Manage', 'http://Paxol/Reports/Manage', 30);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (11, 'CPA Report', 'http://Paxol/Reports/CPAReport', 40);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (12, 'Company Lists', 'http://Paxol/Dashboard/CompanyLists', 70);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (12, 'Account Receivable', 'http://Paxol/Dashboard/AccountReceivable', 70);
insert into PaxolFeatureClaim (FeatureId, ClaimName, ClaimType, AccessLevel) values (12, 'Performance', 'http://Paxol/Dashboard/Performance', 70);

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AspNetUsers]') AND type in (N'U'))
insert into AspNetUserClaims(userId, ClaimType, ClaimValue)
select u.Id,  c.claimtype, 1
from AspNetUsers u, AspNetUserRoles ur, AspNetRoles r, paxolfeatureclaim c
where u.id=ur.UserId and ur.RoleId=r.Id
and r.id>=c.accesslevel;

/****** Object:  StoredProcedure [dbo].[GetAccessMetaData]    Script Date: 13/04/2018 11:39:44 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetAccessMetaData]
	
AS
BEGIN
	select 
	Feature.Name FeatureName, Access.*
	
	from 
	PaxolFeature Feature, PaxolFeatureClaim Access
	where Feature.Id=Access.FeatureId
	order by Feature.Id, Access.ClaimName, Access.AccessLevel desc
	for xml path('Access'), root('AccessList'), elements, type
	
	
END
GO







