IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalMainAccountId')
CREATE NONCLUSTERED INDEX [IX_JournalMainAccountId] ON [dbo].[Journal]
(
	[MainAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF Not EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Journal]') AND name = N'IX_JournalIsDebit')
CREATE NONCLUSTERED INDEX [IX_JournalIsDebit] ON [dbo].[Journal]
(
	[IsDebit] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  UserDefinedFunction [dbo].[GetJournalBalance]    Script Date: 24/01/2018 11:39:14 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJournalBalance]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetJournalBalance]
GO
/****** Object:  UserDefinedFunction [dbo].[GetJournalBalance]    Script Date: 24/01/2018 11:39:14 AM ******/
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

	select @credits = isnull(sum(amount),0) from Journal where MainAccountId=@accountId and IsVoid=0 and IsDebit=0;
	select @debits = isnull(sum(amount),0) from Journal where MainAccountId=@accountId and IsVoid=0 and IsDebit=1;
	set @balance = @credits - @debits;
	return @balance
END' 
END

GO

/****** Object:  StoredProcedure [dbo].[GetInvoicePayments]    Script Date: 24/01/2018 5:15:55 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoicePayments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInvoicePayments]
GO
/****** Object:  StoredProcedure [dbo].[GetInvoicePayments]    Script Date: 24/01/2018 5:15:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoicePayments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInvoicePayments] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetInvoicePayments]
	
	@startdate varchar(max) = null,
	@enddate varchar(max) = null
AS
BEGIN
	
		select 
		p.CompanyId, i.PaymentDate, i.Method, i.Status, i.CheckNumber, i.Amount, i.InvoiceId, i.Id as PaymentId
		from
		InvoicePayment i, PayrollInvoice p with (nolock)
		where i.InvoiceId=p.Id
		and ((@startdate is not null and i.PaymentDate>=@startdate) or @startdate is null)
		and ((@enddate is not null and i.PaymentDate<@enddate) or @enddate is null)
		Order by i.Id
		for Xml path('ExtractInvoicePaymentJson'), root('InvoicePaymentList'), elements, type
	
		
	
	
END
GO

