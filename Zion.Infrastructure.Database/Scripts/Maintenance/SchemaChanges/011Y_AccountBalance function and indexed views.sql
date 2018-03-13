/****** Object:  Index [CIX_AccountDebitBalance]    Script Date: 28/02/2018 9:59:52 AM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AccountDebitBalance]') AND name = N'CIX_AccountDebitBalance')
DROP INDEX [CIX_AccountDebitBalance] ON [dbo].[AccountDebitBalance] WITH ( ONLINE = OFF )
GO
/****** Object:  View [dbo].[AccountDebitBalance]    Script Date: 28/02/2018 9:59:52 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AccountDebitBalance]'))
DROP VIEW [dbo].[AccountDebitBalance]
GO
/****** Object:  Index [CIX_AccountCreditBalance]    Script Date: 28/02/2018 9:59:52 AM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AccountCreditBalance]') AND name = N'CIX_AccountCreditBalance')
DROP INDEX [CIX_AccountCreditBalance] ON [dbo].[AccountCreditBalance] WITH ( ONLINE = OFF )
GO
/****** Object:  View [dbo].[AccountCreditBalance]    Script Date: 28/02/2018 9:59:52 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AccountCreditBalance]'))
DROP VIEW [dbo].[AccountCreditBalance]
GO
/****** Object:  UserDefinedFunction [dbo].[GetJournalBalance]    Script Date: 28/02/2018 9:59:52 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournalBalance]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetJournalBalance]
GO

/****** Object:  View [dbo].[AccountCreditBalance]    Script Date: 28/02/2018 9:59:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AccountCreditBalance]'))
EXEC dbo.sp_executesql @statement = N'
CREATE view [dbo].[AccountCreditBalance]
With SchemaBinding 
As
select MainAccountId, sum(Amount) Credit, COUNT_BIG(*) counts from dbo.Journal where IsVoid=0 and IsDebit=0 group by MainAccountId;
' 
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO
/****** Object:  Index [CIX_AccountCreditBalance]    Script Date: 28/02/2018 9:59:52 AM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AccountCreditBalance]') AND name = N'CIX_AccountCreditBalance')
CREATE UNIQUE CLUSTERED INDEX [CIX_AccountCreditBalance] ON [dbo].[AccountCreditBalance]
(
	[MainAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AccountDebitBalance]    Script Date: 28/02/2018 9:59:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AccountDebitBalance]'))
EXEC dbo.sp_executesql @statement = N'
CREATE view [dbo].[AccountDebitBalance]
With SchemaBinding 
As
select MainAccountId, sum(Amount) Debit, COUNT_BIG(*) counts from dbo.Journal where IsVoid=0 and IsDebit=1 group by MainAccountId;
' 
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO
/****** Object:  Index [CIX_AccountDebitBalance]    Script Date: 28/02/2018 9:59:52 AM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AccountDebitBalance]') AND name = N'CIX_AccountDebitBalance')
CREATE UNIQUE CLUSTERED INDEX [CIX_AccountDebitBalance] ON [dbo].[AccountDebitBalance]
(
	[MainAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[GetJournalBalance]    Script Date: 28/02/2018 9:59:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournalBalance]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[GetJournalBalance] 
(
	@accountId int
)
RETURNS decimal(18,2)
AS
BEGIN
	declare @balance decimal(18,2) = 0
	declare @credits decimal(18,2) = 0
	declare @debits decimal(18,2) = 0

	select @credits = isnull(Credit,0) from AccountCreditBalance where MainAccountId=@accountId;
	select @debits = isnull(sum(Debit),0) from AccountDebitBalance where MainAccountId=@accountId;
	set @balance = @credits - @debits;
	return @balance
END' 
END

GO