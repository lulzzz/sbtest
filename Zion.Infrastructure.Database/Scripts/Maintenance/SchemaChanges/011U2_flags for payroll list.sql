﻿/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 26/01/2018 5:23:17 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrolls]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrolls]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 26/01/2018 5:23:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrolls]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPayrolls] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPayrolls]
	@company varchar(max) = null,
	@startdate varchar(max) = null,
	@enddate varchar(max) = null,
	@id uniqueidentifier=null,
	@invoice uniqueidentifier=null,
	@status varchar(max)=null,
	@void int=null
AS
BEGIN
	if exists(select 'x' from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId where 
		((@void is null) or (@void is not null and Payroll.IsVoid=0))
		and ((@invoice is not null and cast(@invoice as uniqueidentifier)=Pinv.Id) or (@invoice is null))
		and ((@id is not null and Payroll.Id=@id) or (@id is null)) 
		and ((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
		and ((@startdate is not null and PayDay>=@startdate) or (@startdate is null)) 
		and ((@enddate is not null and PayDay<=@enddate) or (@enddate is null)) 
		and ((@status is not null and Payroll.Status=cast(@status as int)) or @status is null)
		)
	select
		Payroll.*,
		Pinv.Id as InvoiceId,
		Pinv.Total, Pinv.InvoiceNumber, Pinv.Status as InvoiceStatus,
		
		(select PayrollPayCheck.* from PayrollPayCheck where PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path('PayrollPayCheckJson'), Elements, type) PayrollPayChecks,
		
		case when exists(select 'x' from PayrollPayCheck pc, PayCheckExtract pce where pc.Id=pce.PayrollPayCheckId and pc.PayrollId=Payroll.Id) then 1 else 0 end HasExtracts,
		case when exists(select 'x' from PayrollPayCheck pc, ACHTransaction act where pc.Id=act.SourceId and act.TransactionType=1 and pc.PayrollId=Payroll.Id) then 1 else 0 end HasACH
		from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
		Where
		((@void is null) or (@void is not null and Payroll.IsVoid=0))
		and ((@invoice is not null and cast(@invoice as uniqueidentifier)=Pinv.Id) or (@invoice is null))
		and ((@id is not null and Payroll.Id=@id) or (@id is null)) 
		and ((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
		and ((@startdate is not null and PayDay>=@startdate) or (@startdate is null)) 
		and ((@enddate is not null and PayDay<=@enddate) or (@enddate is null)) 
		and ((@status is not null and Payroll.Status=cast(@status as int)) or @status is null)
		Order by PayDay
		for Xml path('PayrollJson'), root('PayrollList'), elements, type
	else
		begin
			if @company is not null
				select
				top(1) Payroll.*,
				Pinv.Id as InvoiceId,
				Pinv.Total, Pinv.InvoiceNumber, Pinv.Status as InvoiceStatus,
		
				(select PayrollPayCheck.* from PayrollPayCheck where PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path('PayrollPayCheckJson'), Elements, type) PayrollPayChecks,
				
				case when exists(select 'x' from PayrollPayCheck pc, PayCheckExtract pce where pc.Id=pce.PayrollPayCheckId and pc.PayrollId=Payroll.Id) then 1 else 0 end HasExtracts,
				case when exists(select 'x' from PayrollPayCheck pc, ACHTransaction act where pc.Id=act.SourceId and act.TransactionType=1 and pc.PayrollId=Payroll.Id) then 1 else 0 end HasACH
				from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
				Where				
				((@company is not null and Payroll.CompanyId=@company) or (@company is null)) 
				Order by PayDay desc
				for Xml path('PayrollJson'), root('PayrollList'), elements, type
			else
				select * from Payroll where status='' for Xml path('PayrollJson'), root('PayrollList'), elements, type;
			
		end
		
	
	
END
GO
