/****** Object:  Table [dbo].[ACHTransaction]    Script Date: 8/12/2016 10:47:16 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND type in (N'U'))
DROP TABLE [dbo].[ACHTransaction]
GO
/****** Object:  StoredProcedure [dbo].[GetACHData]    Script Date: 8/12/2016 10:47:16 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetACHData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetACHData]
GO
/****** Object:  StoredProcedure [dbo].[GetACHData]    Script Date: 8/12/2016 10:47:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetACHData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetACHData]
	@startdate datetime = null,
	@enddate datetime = null
AS
BEGIN
	select 
	(select 
	Host.*, 
	(
		select HostCompany.*		
		from Company HostCompany where Id=Company.Id
		for xml path (''HostCompany''), elements, type
	),
	(
		select HostBank.Id,  case when Accounttype=1 then ''Checking'' else ''Savings'' end AccountType, BankName, AccountName, AccountNumber, RoutingNumber 				
		from BankAccount HostBank, CompanyAccount 
		where CompanyId=Company.Id
		and HostBank.Id=BankAccountId
		and UsedInPayroll=1
		for xml path (''HostBank''), elements, type
	),
	(
		select 
		Id, SourceParentId, SourceId, case when Transactiontype=1 then ''PPD'' else ''CCD'' end TransactionType, Amount, TransactionDate, TransactionDescription, 
		(select EntityTypeName from EntityType where EntityTypeId=OrignatorType) OriginatorType, 
		OriginatorId, 
		(select EntityTypeName from EntityType where EntityTypeId=ReceiverType) ReceiverType, 
		ReceiverId
		, Name,
		(
			select 
			*,
			(
				select Id, case when Accounttype=1 then ''Checking'' else ''Savings'' end AccountType, BankName, AccountName, AccountNumber, RoutingNumber 				
				from BankAccount where Id=EmployeeBankAccount.BankAccountId
				for xml path (''BankAccount''), elements, type
			)
			from EmployeeBankAccount
			Where 
			((TransactionType=1 and EmployeeId=ReceiverId) or (EmployeeId is null))
			for xml path (''EmployeeBankAccount''), elements, type
		) EmployeeBankAccounts,
		(
			select BankAccount.Id,  case when Accounttype=1 then ''Checking'' else ''Savings'' end AccountType, BankName, AccountName, AccountNumber, RoutingNumber 				
			from BankAccount, CompanyAccount 
			where 
			((TransactionType=2 and CompanyId=OriginatorId) or (CompanyId is null))
			and BankAccount.Id=BankAccountId
			and UsedInPayroll=1
			for xml path (''CompanyBankAccount''), elements, type
		)
		From ACHTransaction			
		Where 
		((OrignatorType=1 and OriginatorId=Host.Id) or (ReceiverType=1 and ReceiverId=Host.Id))
		and ((@startdate is not null and TransactionDate>=@startdate) or (@startdate is null))
		and ((@enddate is not null and TransactionDate<=@enddate) or (@enddate is null))
		for xml path (''ACHTransaction''), Elements, type

	)ACHTransactions
	 from
	Company, Host
	where Company.Id=Host.CompanyId
	and Company.HostId = Host.Id
	and Company.IsHostCompany=1
	for xml path(''ExtractHostDB''), ELEMENTS, type
	) Hosts
	for xml path(''ACHResponseDB''), ELEMENTS, type
	
	

END
' 
END
GO
/****** Object:  Table [dbo].[ACHTransaction]    Script Date: 8/12/2016 10:47:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ACHTransaction]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ACHTransaction](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SourceParentId] [uniqueidentifier] NOT NULL,
	[SourceId] [int] NOT NULL,
	[TransactionType] [int] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[TransactionDescription] [varchar](max) NOT NULL,
	[OrignatorType] [int] NOT NULL,
	[OriginatorId] [uniqueidentifier] NOT NULL,
	[ReceiverType] [int] NOT NULL,
	[ReceiverId] [uniqueidentifier] NOT NULL,
	[Name] [varchar](max) NOT NULL,
 CONSTRAINT [PK_ACHTransaction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
