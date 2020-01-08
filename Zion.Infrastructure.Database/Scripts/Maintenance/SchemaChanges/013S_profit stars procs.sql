/****** Object:  StoredProcedure [dbo].[usp_RefreshProfitStarsData]    Script Date: 6/01/2020 7:20:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_RefreshProfitStarsData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_RefreshProfitStarsData]
GO
/****** Object:  StoredProcedure [dbo].[usp_MoveProfitStarsRequestsToReports]    Script Date: 6/01/2020 7:20:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MoveProfitStarsRequestsToReports]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_MoveProfitStarsRequestsToReports]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProfitStarsData]    Script Date: 6/01/2020 7:20:39 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetProfitStarsData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetProfitStarsData]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProfitStarsData]    Script Date: 6/01/2020 7:20:39 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.usp_CheckBankCOA    Script Date: 3/21/2006 4:24:45 PM ******/

CREATE PROCEDURE [dbo].[usp_GetProfitStarsData]
AS

select ddpayrollfundid Id, 1 [Type], netsum Amount, case accounttype when 'Checking' then 1 else 2 end AccType, accountnumber AccNum, routingnumber RoutingNum 
from
ddpayrollfundrequest where requestdate is null and resultcode is null
Union
select ddpayrollrefundId Id, 3 [Type], netsum Amount, case accounttype when 'Checking' then 1 else 2 end AccType, accountnumber AccNum, routingnumber RoutingNum 
from ddpayrollrefundrequest where resultcode is null or resultcode ='' and requestdate is null
Union
select ddpayrollpayid Id, 2 [Type], netPay Amount, case accounttype when 'Checking' then 1 else 2 end AccType, accountnumber AccNum, routingnumber RoutingNum
from ddpayrollpayrequest
where entereddate is null and 
resultcode is null or resultcode=''
for Xml path('ProfitStarsPaymentJson'), root('ProfitStarsPaymentList') , elements, type
GO
/****** Object:  StoredProcedure [dbo].[usp_MoveProfitStarsRequestsToReports]    Script Date: 6/01/2020 7:20:39 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.usp_CheckBankCOA    Script Date: 3/21/2006 4:24:45 PM ******/

CREATE PROCEDURE [dbo].[usp_MoveProfitStarsRequestsToReports]
AS

insert into ddpayrollfundreport (ddpayrollfundrequestid, entereddate)
select distinct dpfr.ddpayrollfundid as ddpayrollrequestid, getdate()
from ddpayrollfundrequest dpfr inner join ddpayroll dp on dpfr.ddpayrollfundid=dp.payrollfundid
where dpfr.resultCode='Success' 
and dp.status='Funding Requested' and dpfr.ddpayrollfundid not in (select ddpayrollfundrequestid from ddpayrollfundreport)

insert into ddpayrollpayreport (ddpayrollpayrequestid, entereddate)
select distinct dppr.ddpayrollpayid as ddpayrollrequestid, getdate()
from ddpayrollpayrequest dppr inner join ddpayrollpay dpp on dppr.ddpayrollpayid=dpp.ddpayrollpayid
inner join ddpayroll dp on dpp.ddpayrollid=dp.ddpayrollid
where dppr.resultCode='Success' and dpp.paystatus='Payment Requested'
and dppr.ddpayrollpayid not in (select ddpayrollpayrequestid from ddpayrollpayreport)


insert into ddpayrollrefundreport(ddpayrollrefundrequestid, entereddate)
select ddpayrollrefundid, getdate()
from ddpayrollrefundrequest 
where 
requestdate is not null 
and resultcode='Success' and ddpayrollrefundid not in (select ddpayrollrefundrequestid from ddpayrollrefundreport)



create table #temp23 (entereddate smalldatetime)

insert into #temp23 select min(requestdate) from ddpayrollfundreport d1, ddpayrollfundrequest d2 where d1.ddpayrollfundrequestid=d2.ddpayrollfundid and (d1.transactionstatus not in ('Processed') or d1.settlementstatus not in ('Settled'))
insert into #temp23 select min(d2.entereddate) from ddpayrollpayreport d1, ddpayrollpayrequest d2 where d1.ddpayrollpayrequestid=d2.ddpayrollpayid and (d1.transactionstatus not in ('Processed') or d1.settlementstatus not in ('Settled'))
insert into #temp23 select min(requestdate) from ddpayrollrefundreport d1, ddpayrollrefundrequest d2 where d1.ddpayrollrefundrequestid=d2.ddpayrollpayid and (d1.transactionstatus not in ('Processed') or d1.settlementstatus not in ('Settled'))

select min(entereddate) as entereddate from #temp23

drop table #temp23
GO
/****** Object:  StoredProcedure [dbo].[usp_RefreshProfitStarsData]    Script Date: 6/01/2020 7:20:39 PM ******/
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

		where p.IsVoid=0   and 
		p.paymentmethod=3 
		and p.id not in (select distinct PayrollId from ddpayroll) 
		and isnull(c.profitstarspayer,0)=1
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
where p.payday<=@paydate 
and p.id not in (select distinct PayrollId from ddpayroll)
and p.IsVoid=0
and p.IsHistory=0
and (p.paymentmethod=3)
and isnull(c.ProfitStarsPayer,0)=1

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

/****** Object:  StoredProcedure [dbo].[GetSearchResults]    Script Date: 7/01/2020 12:13:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSearchResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetSearchResults]
GO
/****** Object:  StoredProcedure [dbo].[GetHostAndCompanies]    Script Date: 7/01/2020 12:13:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetHostAndCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetHostAndCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 7/01/2020 12:13:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompanies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompanies]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanies]    Script Date: 7/01/2020 12:13:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCompanies]
	@host uniqueidentifier = null,
	@role varchar(max) = null,
	@status varchar(max) = null,
	@id uniqueidentifier=null
AS
BEGIN
	declare @host1 uniqueidentifier = @host,
	@role1 varchar(max) = @role,
	@status1 varchar(max) = @status,
	@id1 uniqueidentifier=@id

		declare @where nvarchar(max) = ''
	if @id1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'Id=''' + cast(@Id1 as varchar(max))+''''
	if @status1 is not null
		set @where = @where + case when @where ='' then '' else ' and ' end  + 'statusId=' + cast(@status1 as varchar(max))
	if @host1 is not null 
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'HostId=''' + cast(@host1 as varchar(max)) + ''''
	
	if @role1 is not null and @role1='HostStaff'
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'IsHostCompany=0 and IsVisibleToHost=1'
	if @role1 is not null and @role1='CorpStaff'
		set @where = @where +case when @where ='' then '' else ' and ' end  + + 'IsHostCompany=0'

		declare @query nvarchar(max) ='
		select 
		CompanyJson.*,
		case when exists(select ''x'' from company where parentid=CompanyJson.Id) then 1 else 0 end HasLocations
		,
		(select *, (select * from DeductionType where Id=CompanyDeduction.TypeId for Xml path(''DeductionType''), elements, type) from (select * from CompanyDeduction left outer join DeductionCompanyWithheld on Id=CompanyDeductionId where CompanyId=CompanyJson.Id) CompanyDeduction for xml auto, elements, type) CompanyDeductions,
		(select * from CompanyWorkerCompensation Where CompanyId=CompanyJson.Id for Xml auto, elements, type) CompanyWorkerCompensations,
		(select *, (select * from PayType Where Id=CompanyAccumlatedPayType.PayTypeId for xml path(''PayType''), elements, type) from CompanyAccumlatedPayType Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyAccumlatedPayTypes,
		(select * from CompanyContract Where CompanyId=CompanyJson.Id for xml path(''CompanyContract''), elements, type), 
		(select * from CompanyRecurringCharge Where CompanyId=CompanyJson.Id for xml auto, elements, type) RecurringCharges, 
		(select *,(select * from Tax where Id=CompanyTaxRate.TaxId for xml path(''Tax''), elements, type) from CompanyTaxRate Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyTaxRates,
		(select * from CompanyTaxState Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyTaxStates, 
		(select * from CompanyPayCode Where CompanyId=CompanyJson.Id for xml auto, elements, type) CompanyPayCodes,
		(select * from Company Where ParentId=CompanyJson.Id for xml path(''CompanyJson''), elements, type) Locations,
		(select * from InsuranceGroup Where Id=CompanyJson.InsuranceGroupNo for xml auto, elements, type),
		(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId=2 and SourceEntityId=CompanyJson.Id and TargetEntityTypeId=4 order by EntityRelation.EntityRelationId desc) Contact
		From Company CompanyJson '
		+ case when len(@where)>1 then ' Where ' + @where else '' end +
		' Order by CompanyJson.CompanyIntId
		for Xml path(''CompanyJson''), root(''CompanyList'') , elements, type'
		print @query
		Execute(@query)
		
		
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetHostAndCompanies]    Script Date: 7/01/2020 12:13:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetHostAndCompanies]
	@host varchar(max) = null,
	@company varchar(max) = null,
	@role varchar(max) = null,
	@status int = 1
AS
BEGIN
	declare @rootHost uniqueidentifier
	declare @host1 uniqueidentifier = @host
	declare @company1 uniqueidentifier = @company
	declare @role1 varchar(max)= @role
	declare @status1 int = @status
	select @rootHost = RootHostId from ApplicationConfiguration

	select 
		(
			select Id, FirmName, Url, EffectiveDate, CompanyId, HomePage, IsPeoHost, (select CompanyIntId from Company where Id=CompanyId) CompanyIntId,
			(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId=1 and SourceEntityId=Id and TargetEntityTypeId=4 order by EntityRelation.EntityRelationId desc) Contact,
			(select DirectDebitPayer from Company where HostId=Host.Id and IsHostCompany=1) IsHostAllowsDirectDebit
			from Host 
			where ((@host1 is not null and Id=@host1) or (@host1 is null))
			for xml path ('HostListItem'), elements, type
		)Hosts,
		(
			select Id, HostId, CompanyName Name, CompanyNo, LastPayrollDate, FileUnderHost, IsHostCompany, Created, DepositSchedule941 DepositSchedule,
				case StatusId When 1 then 'Active' When 2 then 'InActive' else 'Terminated' end StatusId,
				(select InvoiceSetup from CompanyContract cc where cc.CompanyId=Company.Id) InvoiceSetup,
				(select Rate from CompanyTaxRate where TaxYear=year(getdate()) and TaxId=9 and CompanyId=Company.Id) ETTRate,
				(select Rate from CompanyTaxRate where TaxYear=year(getdate()) and TaxId=10 and CompanyId=Company.Id) UIRate,
				CompanyAddress, FederalEIN,
				(select * from CompanyTaxState Where CompanyId=Company.Id for xml auto, elements, type) CompanyTaxStates, 
				(select * from InsuranceGroup Where Id=Company.InsuranceGroupNo for xml auto, elements, type),
				(select top(1) TargetObject from EntityRelation Where SourceEntityTypeId=2 and SourceEntityId=Id and TargetEntityTypeId=4 order by EntityRelation.EntityRelationId desc) Contact
			from Company
			where 
			((@company1 is not null and Id=@company1) or (@company1 is null))
			and (( @status1>0 and StatusId=@status1) or @status1=0 )
			and (
					(@role1 is not null and @role1='Host' and HostId=@host1)
					or (@role1 is not null and @role1='HostStaff' and IsHostCompany=0 and HostId=@host1 and IsVisibleToHost=1) 
					or (@role1 is not null and @role1='CorpStaff' and IsHostCompany=0) 
					or (@role1 is null or @role1='Company' or @role1='Employee')
				)
			for xml path ('CompanyListItem'), elements, type
		)Companies
	for xml path('HostAndCompanies')
	

END
GO
/****** Object:  StoredProcedure [dbo].[GetSearchResults]    Script Date: 7/01/2020 12:13:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSearchResults]
	@criteria varchar(max),
	@company varchar(max) = null,
	@host varchar(max) = null,
	@role varchar(max) = null
AS
BEGIN
	declare @criteria1 varchar(max)=@criteria,
	@company1 varchar(max) = @company,
	@host1 varchar(max) = @host,
	@role1 varchar(max) = @role

	declare @rootHost uniqueidentifier
	select @rootHost = RootHostId from ApplicationConfiguration
	select 
	(select SearchTable.Id, 
	case 
		when SearchTable.SourceTypeId=2 then
			'Company'
		else
			'Employee'
		end SourceTypeId, SearchTable.SourceId, SearchTable.HostId, SearchTable.CompanyId, SearchTable.SearchText
	
	from 
	SearchTable, Company, Host
	Where 
	SearchTable.HostId = Host.Id
	and SearchTable.CompanyId = Company.Id
	and (
			(@role1 is not null and @role1='HostStaff' and Company.IsHostCompany=0 and Company.IsVisibleToHost=1) 
			or (@role1 is not null and @role1='CorpStaff' and IsHostCompany=0)
			or (@role1 is null) or (@role1='Host')
		)
	and ((@host1 is not null and SearchTable.HostId=@host1) or (@host1 is null))
	and ((@company1 is not null and SearchTable.CompanyId=@company1) or (@company1 is null))
	and SearchTable.SearchText like '%' + @criteria1 + '%'
	for xml path ('SearchResult'), elements, type
	) Results
	for xml path('SearchResults'), ELEMENTS, type


END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProfitStarsPayrollList]    Script Date: 7/01/2020 3:40:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetProfitStarsPayrollList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetProfitStarsPayrollList]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProfitStarsPayrollList]    Script Date: 7/01/2020 3:40:37 PM ******/
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
	where p.payday=a.PayDay
	and p.id not in (select distinct PayrollId from ddpayroll)
	and p.IsVoid=0
	and p.IsHistory=0
	and (p.paymentmethod=3)
	and isnull(c2.ProfitStarsPayer,0)=1
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
		inner join host h on c.HostId=h.Id
		where p.IsVoid=0   and 
		p.paymentmethod=3 
		and p.id not in (select distinct PayrollId from ddpayroll) 
		and isnull(c.profitstarspayer,0)=1
		and p.IsHistory=0
	)b, Company c1 
	where b.CompanyId=c1.Id
	group by c1.Id, CompanyName, PayDay
) a 

for xml path('ProfitStarsPayrollFund'), root('ProfitStarsPayrollList'), elements, type
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProfitStarsData]    Script Date: 7/01/2020 7:31:43 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetProfitStarsData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetProfitStarsData]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProfitStarsData]    Script Date: 7/01/2020 7:31:43 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.usp_CheckBankCOA    Script Date: 3/21/2006 4:24:45 PM ******/

CREATE PROCEDURE [dbo].[usp_GetProfitStarsData]
AS

select ddpayrollfundid Id, 1 [Type], netsum Amount, AccountType AccType, accountnumber AccNum, routingnumber RoutingNum 
from
ddpayrollfundrequest where requestdate is null and resultcode is null
Union
select ddpayrollrefundId Id, 3 [Type], netsum Amount, AccountType AccType, accountnumber AccNum, routingnumber RoutingNum 
from ddpayrollrefundrequest where resultcode is null or resultcode ='' and requestdate is null
Union
select ddpayrollpayid Id, 2 [Type], netPay Amount, AccountType AccType, accountnumber AccNum, routingnumber RoutingNum
from ddpayrollpayrequest
where entereddate is null and 
resultcode is null or resultcode=''
for Xml path('ProfitStarsPaymentJson'), root('ProfitStarsPaymentList') , elements, type
GO
