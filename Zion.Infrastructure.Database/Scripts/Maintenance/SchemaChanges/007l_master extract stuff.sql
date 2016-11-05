IF EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollPayCheck'
                 AND COLUMN_NAME = 'TaxesPaidOn')
alter table PayrollPayCheck drop column TaxesPaidOn;
IF EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'PayrollPayCheck'
                 AND COLUMN_NAME = 'TaxesCreditedOn')
alter table PayrollPayCheck drop column TaxesCreditedOn;

Alter table VendorCustomer Alter Column CompanyId uniqueidentifier;


/****** Object:  Table [dbo].[MasterExtracts]    Script Date: 5/11/2016 11:59:12 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MasterExtracts]') AND type in (N'U'))
DROP TABLE [dbo].[MasterExtracts]
GO
/****** Object:  Table [dbo].[MasterExtracts]    Script Date: 5/11/2016 11:59:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MasterExtracts]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MasterExtracts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Extract] [varchar](max) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[ExtractName] [varchar](max) NOT NULL,
	[IsFederal] [bit] NOT NULL,
	[DepositDate] [datetime] NOT NULL,
	[Journals] [varchar](max) NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
 CONSTRAINT [PK_MasterExtracts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 5/11/2016 8:13:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetExtractData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetExtractData]
GO
/****** Object:  StoredProcedure [dbo].[GetExtractData]    Script Date: 5/11/2016 8:13:51 PM ******/
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
	@report varchar(max)
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
		union
		select id CompanyId, id FilingCompanyId, HostId Host
		from Company
		where FileUnderHost=0 and ManageEFileForms=1 and ManageTaxPayment=1
		and ((@depositSchedule is not null and DepositSchedule941=@depositSchedule) or @depositSchedule is null)
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
			ExtractCompany.*,
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
		from Company ExtractCompany Where Id in (select CompanyId from #tmpComp where FilingCompanyId=Host.CompanyId)
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



