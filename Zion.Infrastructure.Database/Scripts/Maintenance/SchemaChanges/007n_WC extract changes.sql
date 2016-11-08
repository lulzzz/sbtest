IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Company'
                 AND COLUMN_NAME = 'ClientNo')
Alter table Company Add ClientNo varchar(max) not null default('');


/****** Object:  Table [dbo].[InsuranceGroup]    Script Date: 7/11/2016 10:53:26 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InsuranceGroup]') AND type in (N'U'))
DROP TABLE [dbo].[InsuranceGroup]
GO
/****** Object:  Table [dbo].[InsuranceGroup]    Script Date: 7/11/2016 10:53:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InsuranceGroup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InsuranceGroup](
	[Id] [int] IDENTITY(0,1) NOT NULL,
	[GroupNo] [varchar](max) NOT NULL,
	[GroupName] [varchar](max) NOT NULL,
 CONSTRAINT [PK_InsuranceGroup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[InsuranceGroup] ON 

GO
INSERT [dbo].[InsuranceGroup] ([Id], [GroupNo], [GroupName]) VALUES (0, N'CA070', N'CA070')
GO
INSERT [dbo].[InsuranceGroup] ([Id], [GroupNo], [GroupName]) VALUES (1, N'CA071', N'CA071')
GO
INSERT [dbo].[InsuranceGroup] ([Id], [GroupNo], [GroupName]) VALUES (2, N'CA072', N'CA072')
GO
INSERT [dbo].[InsuranceGroup] ([Id], [GroupNo], [GroupName]) VALUES (3, N'CA073', N'CA073')
GO
INSERT [dbo].[InsuranceGroup] ([Id], [GroupNo], [GroupName]) VALUES (4, N'CA075', N'CA075')
GO
SET IDENTITY_INSERT [dbo].[InsuranceGroup] OFF
GO


ALTER TABLE [dbo].[Company]  WITH CHECK ADD  CONSTRAINT [FK_Company_InsuranceGroup] FOREIGN KEY([InsuranceGroupNo])
REFERENCES [dbo].[InsuranceGroup] ([Id])
GO


/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 7/11/2016 11:19:26 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractData]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 7/11/2016 11:19:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetExtractData]
	@startdate datetime,
	@enddate datetime,
	@depositSchedule int = null,
	@report varchar(max),
	@host uniqueidentifier = null
AS
BEGIN
	select * into #tmpComp
	from
	(
		select c.id CompanyId, host.id FilingCompanyId, c.HostId Host
		from Company c, Company host
		where c.HostId=host.HostId
		and host.IsHostCompany=1
		and c.FileUnderHost=1
		and ((@depositSchedule is not null and c.DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and c.HostId=@host) or (@host is null))
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 and ManageEFileForms=1 and ManageTaxPayment=1
		and ((@depositSchedule is not null and DepositSchedule941=@depositSchedule) or @depositSchedule is null)
		and ((@host is not null and HostId=@host) or (@host is null))
	)a

	select 
	(select 
	Host.*, 
	(
		select HostCompany.*		
		from Company HostCompany where Id=Host.CompanyId
		for xml path (''HostCompany''), elements, type
	),
	(
		select * from CompanyTaxState where CompanyId=Host.CompanyId
		for xml path (''ExtractTaxState''), ELEMENTS, type
	) States,
	(
		select *
		from
		(select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=1 and TargetEntityTypeId=4 and SourceEntityId=Host.Id
		Union
		select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and SourceEntityId=Host.CompanyId
		)a
		for xml path (''ExtractContact''), ELEMENTS, type
	) Contacts,
	(
		select 
			ExtractCompany.*, IG.GroupNo InsuranceGroup, IG.GroupName InsuranceGroupName,
			(
				select * from PayrollPayCheck where CompanyId=ExtractCompany.Id and IsVoid=0 and payday between @startdate and @enddate
				and not exists(select ''x'' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=1)
				for xml path (''ExtractPayCheck''), ELEMENTS, type
			) PayChecks,
			(
				select * from PayrollPayCheck 
				where CompanyId=ExtractCompany.Id 
				and IsVoid=1 
				and exists(select ''x'' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=1)
				and not exists(select ''x'' from PayCheckExtract where PayrollPayCheckId=PayrollPayCheck.Id and [Extract]=@report and [Type]=2)
				and VoidedOn between @startdate and @enddate
				and (InvoiceId is null or not exists(select ''x'' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
				for xml path (''ExtractPayCheck''), ELEMENTS, type
			) VoidedPayChecks,
			(
				select *, 
				(select sum(amount) from Journal where CompanyId=ExtractCompany.Id and TransactionType=2 and IsVoid=0 and TransactionDate between @startdate and @enddate) Amount 
				from VendorCustomer
				where CompanyId=ExtractCompany.Id and IsVendor=1 and StatusId=1 and IsVendor1099=1
				for xml path (''ExtractVendor''), ELEMENTS, type
			)Vendors
		from Company ExtractCompany, insuranceGroup IG
		Where 
		ExtractCompany.InsuranceGroupNo = IG.Id
		and ExtractCompany.Id in (select CompanyId from #tmpComp where FilingCompanyId=Host.CompanyId)
		for xml path (''ExtractDBCompany''), Elements, type

	)Companies
	 from
	Host, (select distinct FilingCompanyId, Host from #tmpComp) List
	where Host.Id=List.Host
	and Host.CompanyId=List.FilingCompanyId
	for xml path(''ExtractHostDB''), ELEMENTS, type
	) Hosts
	for xml path(''ExtractResponseDB''), ELEMENTS, type
	
	--select
	--	(select
	--		c.*,
	--		(
	--			select * from CompanyTaxState where CompanyId=c.Id
	--			for xml path (''ExtractTaxState''), ELEMENTS, type
	--		) States,
	--		(
	--			select * from Host where Id=c.hostId
	--			for xml auto , ELEMENTS, type
	--		) ,
	--		(
	--			select *
	--			from
	--			(select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=1 and TargetEntityTypeId=4 and SourceEntityId=c.HostId
	--			Union
	--			select TargetObject as ContactObject from EntityRelation where SourceEntityTypeId=2 and TargetEntityTypeId=4 and SourceEntityId=c.Id
	--			)a
	--			for xml path (''ExtractContact''), ELEMENTS, type
	--		) Contacts,
	--		(
	--			select * from PayrollPayCheck where CompanyId in (select companyid from #tmpComp where FilingCompanyId=c.id) and IsVoid=0 and payday between @startdate and @enddate
	--			for xml path (''ExtractPayCheck''), ELEMENTS, type
	--		) PayChecks,
	--		(
	--			select * from PayrollPayCheck 
	--			where CompanyId in (select companyid from #tmpComp where FilingCompanyId=c.id) 
	--			and IsVoid=1 and TaxesPaidOn is not null and TaxesCreditedOn is null and VoidedOn between @startdate and @enddate
	--			and (InvoiceId is null or not exists(select ''x'' from PayrollInvoice where id=PayrollPayCheck.InvoiceId and StatusId=5))
	--			for xml path (''ExtractPayCheck''), ELEMENTS, type
	--		) VoidedPayChecks
	--		from Company c
	--		where 
	--		c.Id in (select distinct filingcompanyid from #tmpComp)
	--	for xml path (''ExtractDBCompany''), ELEMENTS, type
	--	) Companies
	--for xml path(''ExtractReportDB''), ELEMENTS, type

END
' 
END
GO


/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 8/11/2016 6:03:48 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithoutInvoice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrollsWithoutInvoice]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrollsWithoutInvoice]    Script Date: 8/11/2016 6:03:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrollsWithoutInvoice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrollsWithoutInvoice]
	@startdate datetime = null,
	@enddate datetime = null,
	@host varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	--declare @projectNames varchar(max)
	declare @query varchar(max)
	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration
	select h.Id HostId, c.Id as CompanyId, h.firmname Host, c.CompanyName Company, count(p.Id) Due
	from Company c, Host h, CompanyContract cc, Payroll p Left outer join PayrollInvoice i on p.Id = i.PayrollId
	Where 
	h.id = c.HostId
	and c.StatusId=1
	and c.id=cc.CompanyId
	and c.HostId = h.Id
	and c.id=p.CompanyId
	and cc.[Type]=2 and cc.BillingType=3
	and ((@role is not null and @role=''HostStaff'' and c.IsHostCompany=0) 
			or (@role is not null and @role=''CorpStaff'' and (c.HostId<>@rootHost or (c.HostId=@rootHost and c.IsHostCompany=0))) 
			or (@role is null))
	and ((@host is not null and c.HostId=@host) or (@host is null))
	and (i.Id is null or i.Status=1)
	and exists (select ''x'' from PayrollPayCheck where PayrollId=p.Id and IsVoid=0)
	group by h.Id, c.Id, h.FirmName, c.CompanyName
	
END' 
END
GO
