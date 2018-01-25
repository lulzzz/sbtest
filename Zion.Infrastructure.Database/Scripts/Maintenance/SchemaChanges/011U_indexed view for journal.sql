/****** Object:  Index [CIX_PEOCheckNumber]    Script Date: 25/01/2018 12:57:18 PM ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]') AND name = N'CIX_PEOCheckNumber')
DROP INDEX [CIX_PEOCheckNumber] ON [dbo].[CompanyJournal] WITH ( ONLINE = OFF )
GO
/****** Object:  View [dbo].[CompanyJournal]    Script Date: 25/01/2018 12:57:18 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]'))
DROP VIEW [dbo].[CompanyJournal]
GO
/****** Object:  View [dbo].[CompanyJournal]    Script Date: 25/01/2018 12:57:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]'))
EXEC dbo.sp_executesql @statement = N'CREATE view [dbo].[CompanyJournal]
With SchemaBinding 
As
select CompanyId, PayrollPayCheckId, PEOASOCoCheck, TransactionType, CheckNumber from dbo.Journal where CheckNumber>0;' 
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF

GO
/****** Object:  Index [CIX_PEOCheckNumber]    Script Date: 25/01/2018 12:57:18 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CompanyJournal]') AND name = N'CIX_PEOCheckNumber')
CREATE UNIQUE CLUSTERED INDEX [CIX_PEOCheckNumber] ON [dbo].[CompanyJournal]
(
	[CompanyId] ASC,
	[PEOASOCoCheck] ASC,
	[TransactionType] ASC,
	[CheckNumber] ASC,
	[PayrollPayCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  UserDefinedFunction [dbo].[GetCheckNumber]    Script Date: 25/01/2018 12:58:14 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCheckNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetCheckNumber]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCheckNumber]    Script Date: 25/01/2018 12:58:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCheckNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[GetCheckNumber] 
(
	@CompanyId uniqueidentifier,
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
				when @PEOASOCoCheck=0 and exists(select ''x'' from dbo.CompanyJournal where CompanyId=@CompanyId and PEOASOCoCheck=0 and TransactionType=@TransactionType and CheckNumber=@CheckNumber  and PayrollPayCheckId<>@PayrollPayCheckId) then
						(select isnull(max(CheckNumber),0)+1 from dbo.CompanyJournal where CompanyId=@CompanyId and PEOASOCoCheck=0 and TransactionType=@TransactionType)
				else 
					@result
				end
		end


	return @result;

END' 
END

GO
