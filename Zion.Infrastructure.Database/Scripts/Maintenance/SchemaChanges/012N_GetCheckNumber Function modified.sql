/****** Object:  UserDefinedFunction [dbo].[GetCheckNumber]    Script Date: 7/11/2018 11:30:53 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCheckNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetCheckNumber]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCheckNumber]    Script Date: 7/11/2018 11:30:53 AM ******/
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
	@CheckNumber int,
	@IsPEOPayroll bit
)
RETURNS int
AS
BEGIN
	declare @result int = @CheckNumber
	select @result = case
		when @TransactionType=1 then
			case when @PEOASOCoCheck=1 and exists(select ''x'' from dbo.CompanyJournal where PEOASOCoCheck=1 and CheckNumber=@CheckNumber and PayrollPayCheckId<>@PayrollPayCheckId) then
					(select isnull(max(CheckNumber),0)+1 from dbo.CompanyJournal where PEOASOCoCheck=1)
				when @PEOASOCoCheck=0 and @IsPEOPayroll=0 and exists(select ''x'' from dbo.CompanyPayCheckNumber where CompanyIntId=@CompanyId and CheckNumber=@CheckNumber and Id<>@PayrollPayCheckId ) then
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

/****** Object:  StoredProcedure [dbo].[EnsureCheckNumberIntegrity]    Script Date: 8/11/2018 8:44:38 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EnsureCheckNumberIntegrity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[EnsureCheckNumberIntegrity]
GO
/****** Object:  StoredProcedure [dbo].[EnsureCheckNumberIntegrity]    Script Date: 8/11/2018 8:44:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EnsureCheckNumberIntegrity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EnsureCheckNumberIntegrity] AS' 
END
GO
ALTER PROCEDURE [dbo].[EnsureCheckNumberIntegrity]
	@PayrollId uniqueidentifier,
	@PEOASOCoCheck bit
AS
BEGIN
	update pc set pc.CheckNumber=j.CheckNumber
	from PayrollPayCheck pc, Journal j
	where pc.Id=j.PayrollPayCheckId
	and pc.PayrollId=@payrollId
	and ((pc.PEOASOCoCheck=1 and j.PEOASOCoCheck=1) or (pc.PEOASOCoCheck=0 and j.PEOASOCoCheck=0))
	and pc.CheckNumber<>j.CheckNumber;

	--if @PEOASOCoCheck=1
	--begin
	--	update j
	--	set CheckNumber=pc.CheckNumber
	--	from Journal j, PayrollPayCheck pc
	--	where j.PayrollPayCheckId=pc.Id
	--	and pc.PayrollId=@payrollId
	--	and j.PEOASOCoCheck=0
	--	and j.CheckNumber<>pc.CheckNumber;

	--	select pc.Id PayCheckId, j.Id JournalId, pc.CheckNumber
	--	from Journal j, PayrollPayCheck pc
	--	where j.PayrollPayCheckId=pc.Id
	--	and pc.PayrollId=@payrollId
	--	and j.PEOASOCoCheck=1;
	--end
	--else
	--begin
	--	select pc.Id PayCheckId, j.Id JournalId, pc.CheckNumber
	--	from Journal j, PayrollPayCheck pc
	--	where j.PayrollPayCheckId=pc.Id
	--	and pc.PayrollId=@payrollId
	--	and j.PEOASOCoCheck=0;
	--end
	
END
GO

