IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Payroll'
                 AND COLUMN_NAME = 'IsCertified')
Alter table Payroll Add IsCertified bit, ApprovedOnly bit, LoadFromTimesheets bit, ProjectId int;
Go

IF EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyContract'
                 AND COLUMN_NAME = 'Options')
Alter table CompanyContract Drop Column Options;
Go
IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'CompanyContract'
                 AND COLUMN_NAME = 'DirectDeposit')
Alter table CompanyContract Add DirectDeposit bit not null default(0), ProfitStarsPayer bit not null default(0), Timesheets bit not null default(0), CertifiedPayrolls bit not null default(0), RestaurantPayrolls bit not null default(0);
Go
update cc set DirectDeposit=c.DirectDebitPayer, ProfitStarsPayer=c.ProfitStarsPayer
from Company c, CompanyContract cc where c.Id=cc.CompanyId;

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

/****** Object:  StoredProcedure [dbo].[usp_RefreshProfitStarsData]    Script Date: 13/06/2020 12:51:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_RefreshProfitStarsData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_RefreshProfitStarsData]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProfitStarsPayrollList]    Script Date: 13/06/2020 12:51:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetProfitStarsPayrollList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetProfitStarsPayrollList]
GO
/****** Object:  StoredProcedure [dbo].[CopyCompany]    Script Date: 13/06/2020 12:51:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CopyCompany]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CopyCompany]
GO
/****** Object:  StoredProcedure [dbo].[CopyCompany]    Script Date: 13/06/2020 12:51:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.usp_AddCompany    Script Date: 3/21/2006 4:24:45 PM ******/
------------------------------------------------------------------------------------------------------------------------
-- Date Created: Friday, October 01, 2004
-- Created By:   Generated by CodeSmith
------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[CopyCompany]
	@oldHost uniqueidentifier,
	@newHost uniqueidentifier,
	@oldCompanyId uniqueidentifier,
	@CompanyID uniqueidentifier ,
	@LastModifiedBy varchar(max),
	@copyEmployees bit,
	@copyPayrolls bit,
	@payrollStart DateTime = null,
	@payrollEnd DateTime = null
AS

declare @oldHost1 uniqueidentifier = @oldHost,
	@newHost1 uniqueidentifier = @newHost,
	@oldCompanyId1 uniqueidentifier = @oldCompanyId,
	@CompanyID1 uniqueidentifier = @CompanyID,
	@LastModifiedBy1 varchar(max) = @LastModifiedBy,
	@copyEmployees1 bit = @copyEmployees,
	@copyPayrolls1 bit = @copyPayrolls,
	@payrollStart1 DateTime = @payrollStart,
	@payrollEnd1 DateTime = @payrollEnd

--company
select * into #tempcomp from Company where Id=@oldCompanyId1;
update #tempcomp set HostId = @newHost1, Id=@CompanyID1, LastModifiedBy=@LastModifiedBy1, LastModified=GetDate();
declare @isPEOHost bit
select @isPEOHost = IsPeoHost from Host where Id=@newHost1
if @isPEOHost=1
	update #tempcomp set FileUnderHost=1, ManageEFileForms=1, ManageTaxPayment=1;

insert into Company([Id], [CompanyName],[CompanyNo],[HostId],[StatusId],[IsVisibleToHost],[FileUnderHost],[DirectDebitPayer],[PayrollDaysInPast],[InsuranceGroupNo],[TaxFilingName],[CompanyAddress],[BusinessAddress],[IsAddressSame],[ManageTaxPayment],[ManageEFileForms],[FederalEIN],[FederalPin],[DepositSchedule941],[PayrollSchedule],[PayCheckStock],[IsFiler944],[LastModifiedBy],[LastModified],[MinWage],[IsHostCompany],[Memo],[ClientNo],[Created],[ParentId],[Notes])
select [Id], [CompanyName],[CompanyNo],[HostId],[StatusId],[IsVisibleToHost],[FileUnderHost],[DirectDebitPayer],[PayrollDaysInPast],[InsuranceGroupNo],[TaxFilingName],[CompanyAddress],[BusinessAddress],[IsAddressSame],[ManageTaxPayment],[ManageEFileForms],[FederalEIN],[FederalPin],[DepositSchedule941],[PayrollSchedule],[PayCheckStock],[IsFiler944],[LastModifiedBy],[LastModified],[MinWage],[IsHostCompany],[Memo],[ClientNo],[Created],[ParentId],[Notes] from #tempcomp;

--contract
insert into CompanyContract(CompanyId, Type, PrePaidSubscriptionType, BillingType, CardDetails, BankDetails, InvoiceRate, Method, InvoiceSetup, DirectDeposit, ProfitStarsPayer, Timesheets, CertifiedPayrolls, RestaurantPayrolls)
select @CompanyId1, Type, PrePaidSubscriptionType, BillingType, CardDetails, BankDetails, InvoiceRate, Method, InvoiceSetup, DirectDeposit, ProfitStarsPayer, Timesheets, CertifiedPayrolls, RestaurantPayrolls from CompanyContract where CompanyId=@oldCompanyId1;

--entity relations
select * into #tmper  from EntityRelation where SourceEntityTypeId=2 and SourceEntityId=@oldCompanyId1;
update #tmper set sourceentityid=@CompanyID1;
insert into EntityRelation(SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject) select SourceEntityTypeId, TargetEntityTypeId, SourceEntityId, TargetEntityId, TargetObject from #tmper;

--deductions
insert into CompanyDeduction(CompanyId, TypeId, Name, Description, AnnualMax)
select @CompanyID1, TypeId, Name, Description, AnnualMax from CompanyDeduction where CompanyId=@oldCompanyId1;

select a.Id as olddedid, b.Id as newdedid into #dedTable from
(select * from CompanyDeduction where companyid=@oldcompanyid1)a,
(select * from CompanyDeduction where companyid=@companyid1)b 
where a.TypeId = b.TypeId and a.Name=b.Name;

--pay codes
insert into CompanyPayCode(CompanyId, Code, Description, HourlyRate)
select @CompanyID1, Code, Description, HourlyRate from CompanyPayCode where CompanyId=@oldCompanyId1;

--Accumulated Pay type
insert into CompanyAccumlatedPayType(PayTypeId, CompanyId, RatePerHour, AnnualLimit)
select PayTypeId, @CompanyID1, RatePerHour, AnnualLimit from CompanyAccumlatedPayType where CompanyId=@oldCompanyId1;

--Company State
insert into CompanyTaxState(CompanyId, CountryId, StateId, StateCode, StateName, EIN, Pin)
select @CompanyID1, CountryId, StateId, StateCode, StateName, EIN, Pin from CompanyTaxState where CompanyId=@oldCompanyId1;

--Company Tax rate
insert into CompanyTaxRate(CompanyId, TaxId, TaxYear, Rate)
select @CompanyID1, TaxId, TaxYear, Rate from CompanyTaxRate where CompanyId=@oldCompanyId1;

-- worker compensation
insert into CompanyWorkerCompensation(CompanyId, Code, Description, Rate, MinGrossWage)
select @CompanyId1, Code, Description, Rate, MinGrossWage from CompanyWorkerCompensation where CompanyId=@oldCompanyId1;

select a.Id as oldwcid, b.Id as newwcid into #wcTable from
(select * from CompanyWorkerCompensation where companyid=@oldcompanyid1)a,
(select * from CompanyWorkerCompensation where companyid=@companyid1)b 
where a.Code = b.Code;

-- vednor customers
insert into VendorCustomer(Id, CompanyId, Name, StatusId, AccountNo, IsVendor, IsVendor1099, Contact, Note, Type1099, SubType1099, IdentifierType, IndividualSSN, BusinessFIN, LastModified, LastModifiedBy)
select newid(),@CompanyId1, Name, StatusId, AccountNo, IsVendor, IsVendor1099, Contact, Note, Type1099, SubType1099, IdentifierType, IndividualSSN, BusinessFIN, GETDATE(), LastModifiedBy from VendorCustomer where CompanyId=@oldCompanyId1;

----vendor customer id old and new
select a.Id as oldvcid, b.Id as newvcid into #vcTable from
(select * from vendorcustomer where companyid=@oldcompanyid1)a,
(select * from vendorcustomer where companyid=@companyid1)b 
where a.Name=b.Name and a.individualssn=b.individualssn and a.BusinessFIN=b.BusinessFIN;

-----bank accounts
insert into BankAccount(EntityTypeId, EntityId, AccountType, BankName, AccountName, AccountNumber, RoutingNumber, LastModified, LastModifiedBy)
select EntityTypeId, @CompanyID1, AccountType, BankName, AccountName, AccountNumber, RoutingNumber, GETDATE(), @LastModifiedBy1 from BankAccount where EntityTypeId=2 and EntityId=@oldCompanyId1;

select a.Id as oldbankid, b.Id as newbankid into #bankTable from
(select * from BankAccount where EntityTypeId=2 and EntityId=@oldcompanyid1)a,
(select * from BankAccount where EntityTypeId=2 and EntityId=@companyid1)b 
where a.AccountNumber=b.AccountNumber and a.RoutingNumber=b.RoutingNumber and a.AccountName=b.AccountName and a.AccountType=b.AccountType;

insert into CompanyAccount(CompanyId, Type, SubType, Name, TaxCode, TemplateId, OpeningBalance, OpeningDate, BankAccountId, LastModified, LastModifiedBy, UsedInPayroll)
select @CompanyId1, Type, SubType, Name, TaxCode, TemplateId, OpeningBalance, OpeningDate, 
case when BankAccountId is not null then
	(select top(1) newbankid from #bankTable where oldbankid=BankAccountId)
	else
		null
	end
BankAccountId, getdate(), @LastModifiedBy1, UsedInPayroll 
from CompanyAccount Left outer join BankAccount on CompanyAccount.BankAccountId = BankAccount.Id
Where CompanyId = @oldCompanyId1
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProfitStarsPayrollList]    Script Date: 13/06/2020 12:51:29 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.usp_CheckBankCOA    Script Date: 3/21/2006 4:24:45 PM ******/

CREATE PROCEDURE [dbo].[usp_GetProfitStarsPayrollList]
AS

SELECT dpfr.DDPayrollFundId Id , c.CompanyName PayingCompanyName, dpfr.netSum Amount, dpfr.RequestDate,
	dpfr.AccountType, dpfr.AccountNumber, dpfr.RoutingNumber,
	(
		select dp.DDPayrollId Id, dp.payrollId as PayCheckId, dp.EmployeeId,
			e.FirstName, e.LastName, e.MiddleInitial,dp.PayDate, TransactionDate ConfirmedTime, dp.EnteredDate, Status, netPayAmt Amount, 
			dppr.DDPayrollPayRequestId PayRequestId, dppr.enteredDate PayRequestDate, 
			dp.AccountType, dp.AccountNumber, dp.RoutingNumber , c1.CompanyName
		from DDPayroll dp inner join employee e on dp.employeeId=e.id inner join Company c1 on dp.companyId=c1.Id
		left outer join ddpayrollpay dpp on dp.DDPayrollId = dpp.DDPayrollId 
		left outer join DDPayrollPayRequest dppr on dppr.DDPayrollPayId=dpp.DDPayrollPayId 
		where dp.payrollFundId=dpfr.DDPayrollFundId
		for xml path('ProfitStarsPayrollPay'), elements, type
	) Payrolls
from DDPayrollFundRequest dpfr, DDPayrollFund dpf, Company c
where 
dpfr.DDPayrollFundId=dpf.DDPayrollFundId
and dpf.companyId=c.Id
and dpfr.RequestDate>DateAdd(day, -15, getdate())
union all
select null as Id, CompanyName PayingCompanyName, netSum1 as Amount, null as RequestDate,
(select ba.AccountType from CompanyAccount ca, bankaccount ba where ca.CompanyId=ba.entityid and ba.entitytypeid=2 and ca.BankAccountId=ba.Id and ca.companyid=a.Id and ca.SubType=2 and ca.UsedInPayroll=1) AccountType,
(select ba.AccountNumber from CompanyAccount ca, bankaccount ba where ca.CompanyId=ba.entityid and ba.entitytypeid=2 and ca.BankAccountId=ba.Id and ca.companyid=a.Id and ca.SubType=2 and ca.UsedInPayroll=1) AccountNumber,
(select ba.RoutingNumber from CompanyAccount ca, bankaccount ba where ca.CompanyId=ba.entityid and ba.entitytypeid=2 and ca.BankAccountId=ba.Id and ca.companyid=a.Id and ca.SubType=2 and ca.UsedInPayroll=1) RoutingNumber,
(
	select null as Id, p.Id as PayCheckId, p.EmployeeId,
	e.FirstName, e.LastName, e.MiddleInitial,p.payDay as PayDate, null as ConfirmedTime, null as EnteredDate, 
	'To be Initiated' Status, cast((p.NetWage*eba.Percentage/100) as decimal(18,2)) Amount, 
	ba.AccountType, ba.AccountNumber, ba.RoutingNumber , c2.CompanyName
	from 
	PayrollPayCheck p inner join employee e on p.employeeid=e.id 
	inner join company c2 on  c2.Id=e.CompanyId
	inner join EmployeeBankAccount eba on eba.EmployeeId=p.EmployeeId
	inner join BankAccount ba on eba.BankAccountId=ba.Id
	inner join CompanyContract c3 on c2.Id=c3.CompanyId
	where p.payday=a.PayDay
	and p.id not in (select distinct PayrollId from ddpayroll)
	and p.IsVoid=0
	and p.IsHistory=0
	and (p.paymentmethod=3)
	and isnull(c3.ProfitStarsPayer,0)=1
	and c2.Id=a.Id
	for xml path('ProfitStarsPayrollPay'), elements, type
)Payrolls

from
(
	select c1.Id, CompanyName, PayDay, sum(round(NetWage,2)) as netSum1
	from
	(
		select  case when p.peoasococheck=1 then h.CompanyId else p.CompanyId end CompanyId, p.PayDay, p.NetWage
		from PayrollPayCheck p 
		inner join employee e on p.employeeid=e.id
		inner join company c on e.companyid=c.id
		inner join CompanyContract c3 on c.Id=c3.CompanyId
		inner join host h on c.HostId=h.Id
		where p.IsVoid=0   and 
		p.paymentmethod=3 
		and p.id not in (select distinct PayrollId from ddpayroll) 
		and isnull(c3.profitstarspayer,0)=1
		and p.IsHistory=0
	)b, Company c1 
	where b.CompanyId=c1.Id
	group by c1.Id, CompanyName, PayDay
) a 

for xml path('ProfitStarsPayrollFund'), root('ProfitStarsPayrollList'), elements, type
GO
/****** Object:  StoredProcedure [dbo].[usp_RefreshProfitStarsData]    Script Date: 13/06/2020 12:51:29 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.usp_CheckBankCOA    Script Date: 3/21/2006 4:24:45 PM ******/

CREATE PROCEDURE [dbo].[usp_RefreshProfitStarsData]
	@payDate smalldatetime
AS

declare @currentDate varchar(10)

set @currentDate=convert(varchar,month(getDate()))+'/'+convert(varchar,day(getDate()))+'/'+convert(varchar,year(getDate()))




insert into ddpayrollfund (companyid, netSum, entereddate) 
select a.companyid, a.netSum1, @currentDate from
(
	select companyid, sum(round(NetWage,2)) as netSum1
	from
	(
		select  case when p.peoasococheck=1 then h.CompanyId else p.CompanyId end CompanyId, p.NetWage
		from PayrollPayCheck p 
		inner join employee e on p.employeeid=e.id
		inner join company c on e.companyid=c.id
		inner join host h on c.HostId=h.Id
		inner join CompanyContract c3 on c.Id=c3.CompanyId
		where p.IsVoid=0   and 
		p.paymentmethod=3 
		and p.id not in (select distinct PayrollId from ddpayroll) 
		and isnull(c3.profitstarspayer,0)=1
		and p.IsHistory=0
	)b
	group by companyid
) a
where not exists(select 'x' from DDPayrollFund dpf where dpf.CompanyId=a.CompanyId and dpf.netSum=a.netSum1 and dpf.enteredDate=@currentDate)

insert into DDPayroll (payrollId, payrollfundid, employeeId, companyId, netPayAmt, accounttype, accountnumber, routingnumber, paydate, transactiondate, entereddate, status, HostCheck, PayingCompanyId) 
select p.Id, (select ddpayrollfundid from ddpayrollfund where companyid=(case when p.PEOASOCOCHECK=1 then (select CompanyId from host where id=c.hostId) else p.CompanyId end) and entereddate=@currentDate), p.employeeid, e.companyid,
cast((p.NetWage*eba.Percentage/100) as decimal(18,2)), 
ba.AccountType, ba.accountnumber, ba.routingnumber, p.payday, py.ConfirmedTime, @currentDate, 'To be Transmitted', p.PEOASOCOCheck, case when p.PEOASOCOCHECK=1 then (select CompanyId from host where id=c.hostId) else p.CompanyId end 
from 
PayrollPayCheck p inner join employee e on p.employeeid=e.id 
inner join company c on e.companyid=c.id
inner join EmployeeBankAccount eba on eba.EmployeeId=p.EmployeeId
inner join BankAccount ba on eba.BankAccountId=ba.Id
inner join payroll py on p.PayrollId=py.Id
inner join CompanyContract c3 on c.Id=c3.CompanyId
where p.payday<=@paydate 
and p.id not in (select distinct PayrollId from ddpayroll)
and p.IsVoid=0
and p.IsHistory=0
and (p.paymentmethod=3)
and isnull(c3.ProfitStarsPayer,0)=1

insert into ddpayrollrefundrequest(ddpayrollpayid, companyid, netsum, accounttype, accountnumber, routingnumber)
select dpp.ddpayrollpayid, dp.companyid, dp.netPayAmt,
b.AccountType  accType,
b.AccountNumber  accNum,
b.RoutingNumber  routingNum
from ddpayrollpayreport dppr
inner join ddpayrollpay dpp on dppr.ddpayrollpayrequestid=dpp.ddpayrollpayid
inner join ddpayroll dp on dpp.ddpayrollid=dp.ddpayrollid
inner join CompanyAccount c on dp.CompanyId=c.CompanyId and c.Type=1 and c.SubType=2 and c.UsedInPayroll=1
inner join BankAccount b on c.CompanyId=b.EntityId and b.EntityTypeId=2 and c.BankAccountId=b.Id
where 
dppr.transactionstatus not in ('Processed')
and dppr.settlementstatus='Charged_Back'
and dpp.ddpayrollpayid not in (select distinct ddpayrollpayid from ddpayrollrefundrequest)


insert into ddpayrollfundrequest(ddpayrollfundid, netsum, accounttype, accountnumber, routingnumber)
select distinct a.ddpayrollfundid, a.netsum, 
(select b.accounttype from CompanyAccount c, bankaccount b where c.CompanyId=b.entityid and b.entitytypeid=2 and c.BankAccountId=b.Id and c.companyid=a.PayingCompanyId and c.SubType=2 and c.UsedInPayroll=1)  accType,
(select b.accountnumber from CompanyAccount c, bankaccount b where c.CompanyId=b.entityid and b.entitytypeid=2 and c.BankAccountId=b.Id and c.companyid=a.PayingCompanyId and c.SubType=2 and c.UsedInPayroll=1)  accNum,
(select b.routingnumber from CompanyAccount c, bankaccount b where c.CompanyId=b.entityid and b.entitytypeid=2 and c.BankAccountId=b.Id and c.companyid=a.PayingCompanyId and c.SubType=2 and c.UsedInPayroll=1)  routingNum
from 
(select dpf.*, dp.PayingCompanyId
from ddpayrollfund dpf inner join ddpayroll dp on dpf.ddpayrollfundid=dp.payrollfundid
where dp.status='To be Transmitted'  and dpf.ddpayrollfundid not in (select ddpayrollfundid from ddpayrollfundrequest)) a

insert into ddpayrollpay (ddpayrollid, entereddate, payStatus)
select distinct dp.ddpayrollid, dp.entereddate, 'Payment Requested'  from 
ddpayroll dp inner join ddpayrollfundrequest dpf on dp.payrollfundid=dpf.ddpayrollfundid
inner join ddpayrollfundreport dpfr on dpf.ddpayrollfundid=dpfr.ddpayrollfundrequestid
where dp.voided is null and dpfr.transactionstatus='Processed'  and dpfr.settlementstatus='Settled' and dp.ddpayrollid not in (select ddpayrollid from ddpayrollpay)


insert into ddpayrollpayrequest(ddpayrollpayid,netpay,accounttype,accountnumber, routingnumber,paydate)
select dpp.ddpayrollpayid, dp.netPayAmt, dp.accounttype, dp.accountnumber, dp.routingnumber, dp.paydate
from ddpayrollpay dpp inner join ddpayroll dp on dpp.ddpayrollid=dp.ddpayrollid
where dpp.payStatus='Payment Requested' and 
dpp.ddpayrollpayid not in (select ddpayrollpayid from ddpayrollpayrequest)
GO

Alter table Company Alter Column ClientNo varchar(max);
Alter table Company Alter Column FederalPin varchar(max);
Alter table CompanyTaxState Alter Column Pin varchar(max);
