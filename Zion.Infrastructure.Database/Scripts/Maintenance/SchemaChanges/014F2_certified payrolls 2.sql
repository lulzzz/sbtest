IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Payroll'
                 AND COLUMN_NAME = 'IsCertified')
Alter table Payroll Add IsCertified bit, ApprovedOnly bit, LoadFromTimesheets bit, ProjectId int;
Go
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompayContract'
                 AND COLUMN_NAME = 'Options')
Alter table CompayContract Add Options varchar(max);
Go
ALTER TABLE [dbo].[Payroll]  WITH CHECK ADD  CONSTRAINT [FK_Payroll_CompanyProject] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[CompanyProject] ([Id])
GO
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Employee'
                 AND COLUMN_NAME = 'WorkClassification')
Alter table Employee Add WorkClassification varchar(max);
Go
/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 25/05/2020 5:15:32 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPayrolls]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPayrolls]
GO
/****** Object:  StoredProcedure [dbo].[GetPayrolls]    Script Date: 25/05/2020 5:15:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPayrolls]
	@company varchar(max) = null,
	@startdate varchar(max) = null,
	@enddate varchar(max) = null,
	@id uniqueidentifier=null,
	@invoice uniqueidentifier=null,
	@status varchar(max)=null,
	@void int=null
AS
BEGIN
	declare @company1 varchar(max) = @company,
	@startdate1 varchar(max) = @startdate,
	@enddate1 varchar(max) = @enddate,
	@id1 uniqueidentifier=@id,
	@invoice1 uniqueidentifier=@invoice,
	@status1 varchar(max)=@status,
	@void1 int=@void

	declare @where nvarchar(max) = ''
	if @id1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'Payroll.Id=''' + cast(@Id1 as varchar(max)) + ''''
	if @company1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.CompanyId=''' + cast(@company1 as varchar(max)) + ''''
	if @invoice1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Pinv.Id=''' + cast(@invoice1 as varchar(max)) + ''''
	if @startdate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.PayDay>=''' + cast(@startdate1 as varchar(max)) + ''''
		
	if @enddate1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.PayDay<=''' + cast(@enddate1 as varchar(max)) + ''''
		
	if @status1<>''
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.status =' + @status1
	if @void1 is not null
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'Payroll.IsVoid =0'

	declare @query nvarchar(max) = ''
	
	if exists(select 'x' from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId where 
		((@void1 is null) or (@void1 is not null and Payroll.IsVoid=0))
		and ((@invoice1 is not null and cast(@invoice1 as uniqueidentifier)=Pinv.Id) or (@invoice1 is null))
		and ((@id1 is not null and Payroll.Id=@id1) or (@id1 is null)) 
		and ((@company1 is not null and Payroll.CompanyId=@company1) or (@company1 is null)) 
		and ((@startdate1 is not null and PayDay>=@startdate1) or (@startdate1 is null)) 
		and ((@enddate1 is not null and PayDay<=@enddate1) or (@enddate1 is null)) 
		and ((@status1 is not null and Payroll.Status=cast(@status1 as int)) or @status1 is null)
		)
		set @query = 'select
		Payroll.*,
		Pinv.Id as InvoiceId,
		Pinv.Total, Pinv.InvoiceNumber, Pinv.Status as InvoiceStatus,
		case Payroll.IsCertified when 1 then (select count(Id)+1 from Payroll p2 where p2.IsCertified=1 and p2.ProjectId=Payroll.ProjectId and p2.PayDay<Payroll.PayDay) else 0 end PayrollNo,
		(select PayrollPayCheck.* from PayrollPayCheck where PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path(''PayrollPayCheckJson''), Elements, type) PayrollPayChecks,
		(select * from CompanyProject where Id=Payroll.ProjectId for Xml path(''CompanyProject''), Elements, type),
		case when exists(select ''x'' from PayrollPayCheck pc, PayCheckExtract pce where pc.Id=pce.PayrollPayCheckId and pc.PayrollId=Payroll.Id) then 1 else 0 end HasExtracts,
		case when exists(select ''x'' from PayrollPayCheck pc, ACHTransaction act where pc.Id=act.SourceId and act.TransactionType=1 and pc.PayrollId=Payroll.Id) then 1 else 0 end HasACH
		from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
		Where ' + @where + 'Order by PayDay
		for Xml path(''PayrollJson''), root(''PayrollList''), elements, type'
		
	else
		begin
			if @company1 is not null
				set @query = '
				select
				top(1) Payroll.*,
				Pinv.Id as InvoiceId,
				Pinv.Total, Pinv.InvoiceNumber, Pinv.Status as InvoiceStatus,
				case Payroll.IsCertified when 1 then (select count(Id)+1 from Payroll p2 where p2.IsCertified=1 and p2.ProjectId=Payroll.ProjectId and p2.PayDay<Payroll.PayDay) else 0 end PayrollNo,
				(select PayrollPayCheck.* from PayrollPayCheck where PayrollPayCheck.PayrollId=Payroll.Id Order by PayrollPayCheck.Id for Xml path(''PayrollPayCheckJson''), Elements, type) PayrollPayChecks,
				(select * from CompanyProject where Id=Payroll.ProjectId for Xml path(''CompanyProject''), Elements, type),
				case when exists(select ''x'' from PayrollPayCheck pc, PayCheckExtract pce where pc.Id=pce.PayrollPayCheckId and pc.PayrollId=Payroll.Id) then 1 else 0 end HasExtracts,
				case when exists(select ''x'' from PayrollPayCheck pc, ACHTransaction act where pc.Id=act.SourceId and act.TransactionType=1 and pc.PayrollId=Payroll.Id) then 1 else 0 end HasACH
				from Payroll left outer join  PayrollInvoice Pinv on Payroll.Id=Pinv.PayrollId
				Where				
				Payroll.CompanyId=''' + cast(@company1 as varchar(max)) + '''
				Order by PayDay desc
				for Xml path(''PayrollJson''), root(''PayrollList''), elements, type'
			else
				set @query = 'select * from Payroll where status='''' for Xml path(''PayrollJson''), root(''PayrollList''), elements, type';
			
		end
		
	execute (@query)
	
END
GO
