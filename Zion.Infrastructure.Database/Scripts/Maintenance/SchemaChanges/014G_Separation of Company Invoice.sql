/****** Object:  StoredProcedure [dbo].[GetVendorInvoices]    Script Date: 14/06/2020 1:20:25 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetVendorInvoices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetVendorInvoices]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CompanyInvoice_Company]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyInvoice]'))
ALTER TABLE [dbo].[CompanyInvoice] DROP CONSTRAINT [FK_CompanyInvoice_Company]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_CompanyInvoice_LastModified]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyInvoice] DROP CONSTRAINT [DF_CompanyInvoice_LastModified]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_CompanyInvoice_TransactionDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyInvoice] DROP CONSTRAINT [DF_CompanyInvoice_TransactionDate]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_CompanyInvoice_IsVoid]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyInvoice] DROP CONSTRAINT [DF_CompanyInvoice_IsVoid]
END
GO
/****** Object:  Index [IX_CompanyInvoice]    Script Date: 14/06/2020 1:20:25 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyInvoice]') AND name = N'IX_CompanyInvoice')
DROP INDEX [IX_CompanyInvoice] ON [dbo].[CompanyInvoice]
GO
/****** Object:  Table [dbo].[CompanyInvoice]    Script Date: 14/06/2020 1:20:25 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyInvoice]') AND type in (N'U'))
DROP TABLE [dbo].[CompanyInvoice]
GO
/****** Object:  Table [dbo].[CompanyInvoice]    Script Date: 14/06/2020 1:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyInvoice](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[InvoiceNumber] [int] NOT NULL,
	[PayeeId] [uniqueidentifier] NOT NULL,
	[PayeeName] [varchar](max) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Memo] [varchar](max) NULL,
	[IsVoid] [bit] NOT NULL,
	[InvoiceDate] [datetime] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [varchar](max) NOT NULL,
	[ListItems] [varchar](max) NULL,
 CONSTRAINT [PK_CompanyInvoice] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX_CompanyInvoice]    Script Date: 14/06/2020 1:20:25 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_CompanyInvoice] ON [dbo].[CompanyInvoice]
(
	[CompanyId] ASC,
	[InvoiceNumber] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CompanyInvoice] ADD  CONSTRAINT [DF_CompanyInvoice_IsVoid]  DEFAULT ((0)) FOR [IsVoid]
GO
ALTER TABLE [dbo].[CompanyInvoice] ADD  CONSTRAINT [DF_CompanyInvoice_TransactionDate]  DEFAULT (getdate()) FOR [InvoiceDate]
GO
ALTER TABLE [dbo].[CompanyInvoice] ADD  CONSTRAINT [DF_CompanyInvoice_LastModified]  DEFAULT (getdate()) FOR [LastModified]
GO
ALTER TABLE [dbo].[CompanyInvoice]  WITH CHECK ADD  CONSTRAINT [FK_CompanyInvoice_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO
ALTER TABLE [dbo].[CompanyInvoice] CHECK CONSTRAINT [FK_CompanyInvoice_Company]
GO
/****** Object:  StoredProcedure [dbo].[GetVendorInvoices]    Script Date: 14/06/2020 1:20:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetVendorInvoices]
	@company uniqueidentifier = null,
	@startdate datetime = null,
	@enddate datetime = null,
	@id int=null,
	@void int=null,
	@year int = null
AS
BEGIN
	declare @company1 uniqueidentifier = @company,
	
	@startdate1 datetime = @startdate,
	@enddate1 datetime = @enddate,
	@id1 int=@id,
	@void1 int=@void,
	@year1 int = @year
	

	declare @where nvarchar(max) = ''
	if @id1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'Id=' + cast(@Id1 as varchar(max))
	
	if @company1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'CompanyId=''' + cast(@company1 as varchar(max)) + ''''
	
	if @startdate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'InvoiceDate>=''' + cast(@startdate1 as varchar(max)) + ''''
	if @enddate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'InvoiceDate<=''' + cast(@enddate1 as varchar(max)) + ''''
	
	if @void1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'IsVoid=' + cast(@void1 as varchar(max))
	if @year1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'year(InvoiceDate)=' + cast(@year1 as varchar(max))

	declare @query as nvarchar(max) = ''
	set @query = 'select 
			*, (select Contact from VendorCustomer where Id=CompanyInvoice.PayeeId) Contact
		from CompanyInvoice 
		where ' + @where
	
	set @query = @query + 'for Xml path(''CompanyInvoiceJson''), root(''CompanyInvoiceList''), Elements, type'
	print @query
	Execute(@query)
	
	
END
GO
insert into CompanyInvoice(CompanyId, InvoiceNumber, PayeeId, PayeeName, Amount, Memo, IsVoid, InvoiceDate, LastModified, LastModifiedBy, ListItems)
select CompanyId, ROW_NUMBER() OVER (
    partition by companyid order by Id
)+100, PayeeId, PayeeName, Amount, Memo, IsVoid, TransactionDate, LastModified, LastModifiedBy, ListItems
from CheckbookJournal where TransactionType=8 and EntityType=15 order by Id;
