IF Not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'Company'
                 AND COLUMN_NAME = 'ProfitStarsPayer')
Alter table Company Add ProfitStarsPayer bit not null Default(0);
Go
insert into PaxolFeatureClaim values(1,'ProfitStars','http://Paxol/ProfitStars',90);
/****** Object:  Table [dbo].[DDPayrollRefundRequest]    Script Date: 28/01/2019 7:28:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayrollRefundRequest]') AND type in (N'U'))
DROP TABLE [dbo].[DDPayrollRefundRequest]
GO
/****** Object:  Table [dbo].[DDPayrollRefundReport]    Script Date: 28/01/2019 7:28:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayrollRefundReport]') AND type in (N'U'))
DROP TABLE [dbo].[DDPayrollRefundReport]
GO
/****** Object:  Table [dbo].[DDPayrollPayRequest]    Script Date: 28/01/2019 7:28:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayrollPayRequest]') AND type in (N'U'))
DROP TABLE [dbo].[DDPayrollPayRequest]
GO
/****** Object:  Table [dbo].[DDPayrollPayReport]    Script Date: 28/01/2019 7:28:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayrollPayReport]') AND type in (N'U'))
DROP TABLE [dbo].[DDPayrollPayReport]
GO
/****** Object:  Table [dbo].[DDPayrollPay]    Script Date: 28/01/2019 7:28:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayrollPay]') AND type in (N'U'))
DROP TABLE [dbo].[DDPayrollPay]
GO
/****** Object:  Table [dbo].[DDPayrollFundRequest]    Script Date: 28/01/2019 7:28:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayrollFundRequest]') AND type in (N'U'))
DROP TABLE [dbo].[DDPayrollFundRequest]
GO
/****** Object:  Table [dbo].[DDPayrollFundReport]    Script Date: 28/01/2019 7:28:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayrollFundReport]') AND type in (N'U'))
DROP TABLE [dbo].[DDPayrollFundReport]
GO
/****** Object:  Table [dbo].[DDPayrollFund]    Script Date: 28/01/2019 7:28:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayrollFund]') AND type in (N'U'))
DROP TABLE [dbo].[DDPayrollFund]
GO
/****** Object:  Table [dbo].[DDPayroll]    Script Date: 28/01/2019 7:28:18 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayroll]') AND type in (N'U'))
DROP TABLE [dbo].[DDPayroll]
GO
/****** Object:  Table [dbo].[DDPayroll]    Script Date: 28/01/2019 7:28:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayroll]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DDPayroll](
	[DDPayrollId] [int] IDENTITY(1000,1) NOT NULL,
	[payrollId] [int] NOT NULL,
	[payrollFundId] [int] NULL,
	[employeeId] [uniqueidentifier] NULL,
	[companyId] [uniqueidentifier] NULL,
	[netPayAmt] [money] NULL,
	[AccountType] [varchar](50) NULL,
	[AccountNumber] [varchar](50) NULL,
	[RoutingNumber] [varchar](50) NULL,
	[payDate] [smalldatetime] NULL,
	[TransactionDate] [smalldatetime] NULL,
	[enteredDate] [smalldatetime] NULL,
	[Voided] [smalldatetime] NULL,
	[status] [varchar](20) NULL,
	[HostCheck] [bit] NULL,
	[PayingCompanyId] [uniqueidentifier] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[DDPayrollFund]    Script Date: 28/01/2019 7:28:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayrollFund]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DDPayrollFund](
	[DDPayrollFundId] [int] IDENTITY(1000,1) NOT NULL,
	[companyId] [uniqueidentifier] NOT NULL,
	[netSum] [money] NULL,
	[enteredDate] [smalldatetime] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[DDPayrollFundReport]    Script Date: 28/01/2019 7:28:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayrollFundReport]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DDPayrollFundReport](
	[DDPayrollFundReportId] [int] IDENTITY(1000,1) NOT NULL,
	[DDPayrollFundRequestId] [int] NOT NULL,
	[ActionFlag] [varchar](50) NULL,
	[enteredDate] [smalldatetime] NULL,
	[TransactionStatus] [varchar](max) NULL,
	[SettlementStatus] [varchar](max) NULL,
	[reportDocumentId] [varchar](max) NULL,
	[manualUpdate] [bit] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[DDPayrollFundRequest]    Script Date: 28/01/2019 7:28:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayrollFundRequest]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DDPayrollFundRequest](
	[DDPayrollFundRequestId] [int] IDENTITY(1000,1) NOT NULL,
	[DDPayrollFundId] [int] NOT NULL,
	[netSum] [money] NULL,
	[AccountType] [varchar](max) NULL,
	[AccountNumber] [varchar](max) NULL,
	[RoutingNumber] [varchar](max) NULL,
	[RequestDate] [smalldatetime] NULL,
	[ResultCode] [varchar](max) NULL,
	[requestDocumentId] [varchar](max) NULL,
	[refNum] [varchar](max) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[DDPayrollPay]    Script Date: 28/01/2019 7:28:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayrollPay]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DDPayrollPay](
	[DDPayrollPayId] [int] IDENTITY(1000,1) NOT NULL,
	[DDPayrollId] [int] NOT NULL,
	[enteredDate] [smalldatetime] NOT NULL,
	[payStatus] [varchar](max) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[DDPayrollPayReport]    Script Date: 28/01/2019 7:28:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayrollPayReport]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DDPayrollPayReport](
	[DDPayrollPayReportId] [int] IDENTITY(1000,1) NOT NULL,
	[DDPayrollPayRequestId] [int] NOT NULL,
	[ActionFlag] [varchar](max) NULL,
	[enteredDate] [smalldatetime] NULL,
	[TransactionStatus] [varchar](max) NULL,
	[SettlementStatus] [varchar](max) NULL,
	[reportDocumentId] [varchar](max) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[DDPayrollPayRequest]    Script Date: 28/01/2019 7:28:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayrollPayRequest]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DDPayrollPayRequest](
	[DDPayrollPayRequestId] [int] IDENTITY(1000,1) NOT NULL,
	[DDPayrollPayId] [int] NOT NULL,
	[netPay] [money] NULL,
	[AccountType] [varchar](max) NULL,
	[AccountNumber] [varchar](max) NULL,
	[RoutingNumber] [varchar](max) NULL,
	[payDate] [datetime] NULL,
	[enteredDate] [datetime] NULL,
	[ResultCode] [varchar](max) NULL,
	[requestDocumentId] [varchar](max) NULL,
	[refNum] [varchar](max) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[DDPayrollRefundReport]    Script Date: 28/01/2019 7:28:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayrollRefundReport]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DDPayrollRefundReport](
	[DDPayrollRefundReportId] [int] IDENTITY(1000,1) NOT NULL,
	[DDPayrollRefundRequestId] [int] NULL,
	[ActionFlag] [varchar](max) NULL,
	[enteredDate] [datetime] NULL,
	[transactionStatus] [varchar](max) NULL,
	[settlementStatus] [varchar](max) NULL,
	[reportDocumentId] [varchar](max) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[DDPayrollRefundRequest]    Script Date: 28/01/2019 7:28:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DDPayrollRefundRequest]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DDPayrollRefundRequest](
	[ddPayrollRefundId] [int] IDENTITY(1000,1) NOT NULL,
	[ddPayrollPayId] [int] NULL,
	[companyId] [uniqueidentifier] NULL,
	[netSum] [money] NULL,
	[AccountType] [varchar](max) NULL,
	[AccountNumber] [varchar](max) NULL,
	[RoutingNumber] [varchar](max) NULL,
	[RequestDate] [datetime] NULL,
	[resultCode] [varchar](max) NULL,
	[refNum] [varchar](max) NULL,
	[requestDoc] [varchar](max) NULL
) ON [PRIMARY]
END
GO


/****** Object:  StoredProcedure [dbo].[usp_DDMoveToDDPayrollPay]    Script Date: 4/02/2019 10:02:22 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_RefreshProfitStarsData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_RefreshProfitStarsData]
GO
/****** Object:  StoredProcedure [dbo].[usp_DDMoveToDDPayrollFund]    Script Date: 4/02/2019 10:02:22 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetProfitStarsData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetProfitStarsData]
GO
/****** Object:  StoredProcedure [dbo].[usp_DDMoveRequestsToReports]    Script Date: 4/02/2019 10:02:22 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MoveProfitStarsRequestsToReports]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_MoveProfitStarsRequestsToReports]
GO
/****** Object:  StoredProcedure [dbo].[usp_DDMoveRequestsToReports]    Script Date: 4/02/2019 10:02:22 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MoveProfitStarsRequestsToReports]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_MoveProfitStarsRequestsToReports] AS' 
END
GO









/****** Object:  Stored Procedure dbo.usp_CheckBankCOA    Script Date: 3/21/2006 4:24:45 PM ******/

ALTER PROCEDURE [dbo].[usp_MoveProfitStarsRequestsToReports]
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

insert into #temp23 select min(requestdate) from ddpayrollfundreport d1, ddpayrollfundrequest d2 where d1.ddpayrollfundrequestid=d2.ddpayrollfundid and d1.transactionstatus not in ('Processed') or d1.settlementstatus not in ('Settled')
insert into #temp23 select min(d2.entereddate) from ddpayrollpayreport d1, ddpayrollpayrequest d2 where d1.ddpayrollpayrequestid=d2.ddpayrollpayid and d1.transactionstatus not in ('Processed') or d1.settlementstatus not in ('Settled')
insert into #temp23 select min(requestdate) from ddpayrollrefundreport d1, ddpayrollrefundrequest d2 where d1.ddpayrollrefundrequestid=d2.ddpayrollpayid and d1.transactionstatus not in ('Processed') or d1.settlementstatus not in ('Settled')

select min(entereddate) as entereddate from #temp23

drop table #temp23



GO
/****** Object:  StoredProcedure [dbo].[usp_DDMoveToDDPayrollFund]    Script Date: 4/02/2019 4:32:29 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_RefreshProfitStarsData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_RefreshProfitStarsData] AS' 
END
GO

/****** Object:  Stored Procedure dbo.usp_CheckBankCOA    Script Date: 3/21/2006 4:24:45 PM ******/

ALTER PROCEDURE [dbo].[usp_RefreshProfitStarsData]
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
	)b
	group by companyid
) a


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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetProfitStarsData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_GetProfitStarsData] AS' 
END
GO










/****** Object:  Stored Procedure dbo.usp_CheckBankCOA    Script Date: 3/21/2006 4:24:45 PM ******/

ALTER PROCEDURE [dbo].[usp_GetProfitStarsData]
AS

select ddpayrollfundid Id, 1 [Type], netsum Amount, accountType AccType, accountnumber AccNum, routingnumber RoutingNum 
from
ddpayrollfundrequest where requestdate is null and resultcode is null
Union
select ddpayrollrefundId Id, 3 [Type], netsum Amount, accountType AccType, accountnumber AccNum, routingnumber RoutingNum 
from ddpayrollrefundrequest where resultcode is null or resultcode ='' and requestdate is null
Union
select ddpayrollpayid Id, 2 [Type], netPay Amount, accounttype AccType, accountnumber AccNum, routingnumber RoutingNum
from ddpayrollpayrequest
where entereddate is null and 
resultcode is null or resultcode=''
for Xml path('ProfitStarsPaymentJson'), root('ProfitStarsPaymentList') , elements, type





GO

/****** Object:  Table [dbo].[RTGReportLog]    Script Date: 8/02/2019 4:49:55 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfitStarsReportLog]') AND type in (N'U'))
DROP TABLE [dbo].[ProfitStarsReportLog]
GO
/****** Object:  Table [dbo].[RTGReportLog]    Script Date: 8/02/2019 4:49:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfitStarsReportLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProfitStarsReportLog](
	[reportItemId] [int] IDENTITY(1000,1) NOT NULL,
	[eventItemId] [int] NOT NULL,
	[operationType] [int] NOT NULL,
	[eventType] [varchar](100) NOT NULL,
	[eventDateTime] [smalldatetime] NOT NULL,
	[transactionDateTime] [smalldatetime] NOT NULL,
	[enteredDate] [smalldatetime] NOT NULL,
	[transactionStatus] [varchar](100) NOT NULL,
	[SettlementStatus] [varchar](100) NOT NULL,
	[sequenceNumber] [varchar](100) NOT NULL,
	[transactionSequenceNumber] [varchar](100) NOT NULL,
	[document] [varchar](max) NOT NULL
) ON [PRIMARY]
END
GO

