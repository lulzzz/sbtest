/****** Object:  Index [CIX_PEOCheckNumber]    Script Date: 13/03/2018 11:37:44 AM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]') AND name = N'CIX_PEOCheckNumber')
DROP INDEX [CIX_PEOCheckNumber] ON [dbo].[CompanyJournal] WITH ( ONLINE = OFF )
GO
/****** Object:  View [dbo].[CompanyJournal]    Script Date: 13/03/2018 11:37:44 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]'))
DROP VIEW [dbo].[CompanyJournal]
GO
/****** Object:  View [dbo].[CompanyJournal]    Script Date: 13/03/2018 11:37:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]'))
EXEC dbo.sp_executesql @statement = N'CREATE view [dbo].[CompanyJournal]
With SchemaBinding 
As
select CompanyIntId, PayrollPayCheckId, PEOASOCoCheck, CheckNumber from dbo.Journal where TransactionType=1 and CheckNumber>0;' 
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO
/****** Object:  Index [CIX_PEOCheckNumber]    Script Date: 13/03/2018 11:37:44 AM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]') AND name = N'CIX_PEOCheckNumber')
CREATE UNIQUE CLUSTERED INDEX [CIX_PEOCheckNumber] ON [dbo].[CompanyJournal]
(
	[CompanyIntId] ASC,
	[PEOASOCoCheck] ASC,
	[CheckNumber] DESC,
	[PayrollPayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [CIX_PEOCheckNumber]    Script Date: 13/03/2018 11:37:44 AM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournalCheckBook]') AND name = N'CIX_CheckbookCheckNumber')
DROP INDEX [CIX_CheckbookCheckNumber] ON [dbo].[CompanyJournalCheckBook] WITH ( ONLINE = OFF )
GO
/****** Object:  View [dbo].[CompanyJournal]    Script Date: 13/03/2018 11:37:44 AM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournalCheckBook]'))
DROP VIEW [dbo].[CompanyJournalCheckBook]
GO
/****** Object:  View [dbo].[CompanyJournal]    Script Date: 13/03/2018 11:37:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournalCheckBook]'))
EXEC dbo.sp_executesql @statement = N'CREATE view [dbo].[CompanyJournalCheckBook]
With SchemaBinding 
As
select CompanyIntId, CheckNumber, TransactionType from dbo.Journal where TransactionType<>1 and CheckNumber>0;' 
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO
/****** Object:  Index [CIX_PEOCheckNumber]    Script Date: 13/03/2018 11:37:44 AM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournalCheckBook]') AND name = N'CIX_CheckbookCheckNumber')
CREATE UNIQUE CLUSTERED INDEX [CIX_CheckbookCheckNumber] ON [dbo].[CompanyJournalCheckBook]
(
	[CompanyIntId] ASC,
	[TransactionType] ASC,
	[CheckNumber] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  UserDefinedFunction [dbo].[GetCheckNumber]    Script Date: 13/03/2018 11:42:46 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCheckNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetCheckNumber]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCheckNumber]    Script Date: 13/03/2018 11:42:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCheckNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[GetCheckNumber] 
(
	@CompanyId int,
	@PayrollPayCheckId int,
	@PEOASOCoCheck bit,
	@TransactionType int,
	@CheckNumber int
)
RETURNS int
AS
BEGIN
	declare @result int = @CheckNumber
	select @result = case
		when @TransactionType=1 then
			case when @PEOASOCoCheck=1 and exists(select ''x'' from dbo.CompanyJournal where CheckNumber=@CheckNumber and PayrollPayCheckId<>@PayrollPayCheckId) then
					(select isnull(max(CheckNumber),0)+1 from dbo.CompanyJournal where PEOASOCoCheck=1)
				when @PEOASOCoCheck=0 and exists(select ''x'' from dbo.CompanyPayCheckNumber where CompanyIntId=@CompanyId and Id<>@PayrollPayCheckId and CheckNumber=@CheckNumber) then
						(select isnull(max(CheckNumber),0)+1 from dbo.CompanyPayCheckNumber where CompanyIntId=@CompanyId)
				else 
					@result
				end
		when @TransactionType=2 or @TransactionType=6 then
			case when exists(select ''x'' from dbo.CompanyJournalCheckbook where CompanyIntId=@CompanyId and TransactionType in (2,6) and CheckNumber=@CheckNumber) then
				(select isnull(max(CheckNumber),0)+1 from dbo.CompanyJournalCheckbook where CompanyIntId=@CompanyId and TransactionType in (2,6))
				else
					@result
				end
		end


	return @result;

END' 
END

GO

/****** Object:  StoredProcedure [dbo].[GetJournals]    Script Date: 13/03/2018 5:05:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetJournalIds]
	@company uniqueidentifier = null,
	@startdate datetime = null,
	@enddate datetime = null,
	@transactiontype int = null,
	@accountid int = null
AS
BEGIN
	
		select 
			Journal.Id
		from Journal
		where
			 ((@accountid is not null and MainAccountId=@accountid) or @accountid is null)
			and ((@company is not null and CompanyId=@company) or (@company is null)) 
			and ((@transactiontype is not null and TransactionType=@transactiontype) or @transactiontype is null)
			and ((@startdate is not null and TransactionDate>=@startdate) or (@startdate is null)) 
			and ((@enddate is not null and TransactionDate<=@enddate) or (@enddate is null)) 
			
		Order by Id 
		for Xml path('JournalJson'), root('JournalList'), Elements, type
		
	
	
END
