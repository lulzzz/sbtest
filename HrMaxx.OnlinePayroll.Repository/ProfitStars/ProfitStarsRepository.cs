using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Xml.Serialization;
using Dapper;
using HrMaxx.Common.Models;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Repository;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;
using HrMaxx.OnlinePayroll.ReadRepository;

namespace HrMaxx.OnlinePayroll.Repository.ProfitStars
{
	public class ProfitStarsRepository : BaseDapperRepository, IProfitStarsRepository
	{
		private readonly IReadRepository _readRepository;
		private readonly IMapper _mapper;
		private string _sqlCon;
		public ProfitStarsRepository(IMapper mapper, IReadRepository readRepository, string sqlCon, DbConnection connection): base(connection)
		{
			_readRepository = readRepository;
			_sqlCon = sqlCon;
			_mapper = mapper;
		}

		public void RefreshProfitStarsData(DateTime payDay)
		{
			string sql = "exec usp_RefreshProfitStarsData @payDate='" + payDay + "'";

			using (var con = new SqlConnection(_sqlCon))
			{
				using (var cmd = new SqlCommand(sql))
				{
					cmd.CommandTimeout = 0;
					cmd.CommandType = CommandType.Text;
					cmd.Connection = con;
					con.Open();
					cmd.ExecuteNonQuery();
					con.Close();
				}
			}
		}

		public string MoveRequestsToReports()
		{
			string sql = "exec usp_MoveProfitStarsRequestsToReports";

			using (var con = new SqlConnection(_sqlCon))
			{
				using (var cmd = new SqlCommand(sql))
				{
					cmd.CommandTimeout = 0;
					cmd.CommandType = CommandType.Text;
					cmd.Connection = con;
					con.Open();
					
					var result = cmd.ExecuteScalar();
					con.Close();
					return result.ToString();
				}
			}
		}

		public List<ProfitStarsPayment> GetProfitStarsData()
		{
			return _readRepository.GetDataFromStoredProc<List<ProfitStarsPayment>, List<ProfitStarsPaymentJson>>("usp_GetProfitStarsData", new List<FilterParam>(), new XmlRootAttribute("ProfitStarsPaymentList"));
			
		}

		public void SavePaymentRequests(List<ProfitStarsPayment> paymentRequests, string requestFile)
		{
			const string fundrequest = "update ddpayrollfundrequest set requestdate=getdate(), resultcode=@ResultCode, requestdocumentid=@Doc, refnum=@RefNum where ddpayrollfundid=@Id;if @ResultCode='success' update ddpayroll set status='Funding Requested' where PayrollFundId=@Id;";
			const string payrequest = "update ddpayrollpayrequest set resultcode=@ResultCode, entereddate=getdate(), requestdocumentid=@Doc, refnum=@RefNum where ddpayrollpayid=@Id;if @ResultCode='success' begin update ddpayrollpay set payStatus='Payment Requested' where ddpayrollpayid=@Id; update ddpayroll set status='Payment Requested' where ddpayrollid in (select ddpayrollid from ddpayrollpay where ddpayrollpayid=@Id) end";
			const string refundrequest = "update ddpayrollrefundrequest set resultcode=@ResultCode, requestdate=getdate(), requestdoc=@Doc, refnum=@RefNum where ddpayrollpayid=@Id;";
			using (var conn = GetConnection())
			{
				conn.Execute(fundrequest, paymentRequests.Where(pr => pr.Type == ProfitStarsPaymentType.Fund).Select(pr => new {Id = pr.Id, RefNum = pr.PayResponse.refNum, ResultCode=pr.PayResponse.resultCode, Doc = requestFile}));
				conn.Execute(payrequest, paymentRequests.Where(pr => pr.Type == ProfitStarsPaymentType.Pay).Select(pr => new { Id = pr.Id, RefNum = pr.PayResponse.refNum, ResultCode = pr.PayResponse.resultCode, Doc = requestFile }));
				conn.Execute(refundrequest, paymentRequests.Where(pr => pr.Type == ProfitStarsPaymentType.Refund).Select(pr => new { Id = pr.Id, RefNum = pr.PayResponse.refNum, ResultCode = pr.PayResponse.resultCode, Doc = requestFile }));
			}
		}

		public void UpdatePaymentRequests(ProfitStarsReportResponse reportResponse, string responseFile)
		{
			const string updateRTGLog = "declare @counter as int;select @counter=reportItemId from ProfitStarsReportLog where eventItemId=@Id and operationType=@Type and eventType=@EventType and transactionDateTime=@TransactionDateTime and sequenceNumber=@SequenceNumber; " +
																	"if isnull(@counter,0)=0 begin insert into ProfitStarsReportLog(eventItemId,operationType,eventtype,eventdatetime,transactiondatetime,entereddate,transactionstatus,settlementstatus,sequencenumber,transactionsequencenumber,document) " +
			                            "values(@Id,@Type,@EventType,@EventDatetime,@TransactionDateTime,getDate(),@TransactionStatus, @SettlementStatus,@SequenceNumber, @TransactionSequenceNumber,@Doc) end " +
																	"else update ProfitStarsReportLog set TransactionStatus=@TransactionStatus, SettlementStatus=@SettlementStatus where eventitemid=@Id and reportItemId=@counter";

			const string updateFundRequest = "declare @maxEventDate as int;select @maxEventDate=max(reportItemId) from ProfitStarsReportLog where eventItemId=@Id and operationtype=1;" +
			                                 "update fr set entereddate=convert(varchar(50),rl.eventdatetime), transactionstatus=rl.transactionStatus, settlementstatus=rl.settlementstatus, reportdocumentid=rl.document " +
																			 "from ddpayrollfundreport fr,ProfitStarsReportLog rl where fr.ddpayrollfundrequestid=rl.eventItemId and rl.operationType=1 and rl.reportItemId=@maxEventDate " +
																			 "and isnull(fr.manualUpdate,0)=0; " +
			                                 "if @TransactionStatus='Processed' and @SettlementStatus='Settled' update ddpayroll set status = 'Funding Succeeded' where payrollfundid=@Id";

			const string updatePayRequest = "declare @maxEventDate as int;select @maxEventDate=max(reportItemId) from ProfitStarsReportLog where eventItemId=@Id and operationtype=2;" +
																			 "update fr set entereddate=convert(varchar(50),rl.eventdatetime), transactionstatus=rl.transactionStatus, settlementstatus=rl.settlementstatus, reportdocumentid=rl.document " +
																			 "from ddpayrollpayreport fr,ProfitStarsReportLog rl where fr.ddpayrollpayrequestid=rl.eventItemId and rl.operationType=2 and rl.reportItemId=@maxEventDate " +
																			 "if @TransactionStatus='Processed' and @SettlementStatus='Settled' begin " +
																			"update ddpayrollpay set paystatus='Payment Succeeded' where ddpayrollpayid=@Id; update ddpayroll set status='Payment Succeeded' where ddpayrollid=(select dp.ddpayrollid from ddpayrollpayrequest dppr, ddpayrollpay dpp, ddpayroll dp where dppr.ddpayrollpayid=dpp.ddpayrollpayid and dpp.ddpayrollid=dp.ddpayrollid and dppr.ddpayrollpayid=@Id);end";

			const string updateReFundRequest = "declare @maxEventDate as int;select @maxEventDate=max(reportItemId) from ProfitStarsReportLog where eventItemId=@Id and operationtype=3;" +
																			 "update fr set entereddate=convert(varchar(50),rl.eventdatetime), transactionstatus=rl.transactionStatus, settlementstatus=rl.settlementstatus, reportdocumentid=rl.document " +
																			 "from ddpayrollrefundreport fr,ProfitStarsReportLog rl where fr.ddpayrollrefundid=rl.eventItemId and rl.operationType=3 and rl.reportItemId=@maxEventDate " +
																			 "if @TransactionStatus='Processed' and @SettlementStatus='Settled' begin " +
																			"update ddpayrollpay set paystatus='ReFund Succeeded' where ddpayrollpayid=(select ddpayrollpayid from ddpayrollrefundrequest where ddpayrollrefundid=@Id); update ddpayroll set status='ReFund Succeeded' where ddpayrollid=(select dp.ddpayrollid from ddpayrollrefundrequest dppr, ddpayrollpay dpp, ddpayroll dp where dppr.ddpayrollpayid=dpp.ddpayrollpayid and dpp.ddpayrollid=dp.ddpayrollid and dppr.ddpayrollrefundid=@Id);end";
			using (var con = GetConnection())
			{
				reportResponse.Events.ForEach(e =>
				{
					con.Execute(updateRTGLog,
						new
						{
							Id = e.Transaction.Id,
							Type = (int) e.Transaction.Type,
							EventType = e.eventType,
							EventDateTime = e.EventTime,
							TransactionDateTime = e.Transaction.TransactionTime,
							TransactionStatus = e.Transaction.TransactionStatus,
							SettLementStatus = e.Transaction.SettlementStatus,
							SequenceNumber = e.sequenceNumber,
							TransactionSequenceNumber = e.Transaction.SequenceNumber,
							Doc = responseFile
						});

					if (e.Transaction.Type == ProfitStarsPaymentType.Fund)
						con.Execute(updateFundRequest, e.Transaction);
					if (e.Transaction.Type == ProfitStarsPaymentType.Pay)
						con.Execute(updatePayRequest, e.Transaction);
					if (e.Transaction.Type == ProfitStarsPaymentType.Refund)
						con.Execute(updateReFundRequest, e.Transaction);


				});
				
			}
		}

		public List<ProfitStarsPayroll> GetProfitStarsPayrollList()
		{
			const string sql = "select dp.DDPayrollId as Id, PayrollId as PayCheckId, dp.CompanyId, (select CompanyName from Company where Id=dp.CompanyId) CompanyName," +
			                   "PayingCompanyId,(select CompanyName from Company where Id=PayingCompanyId) PayingCompanyName,HostCheck IsHostCheck," +
			                   "EmployeeId, e.FirstName, e.LastName, e.MiddleInitial," +
			                   "dp.PayDate, TransactionDate ConfirmedTime, dp.EnteredDate, Status, netPayAmt Amount, dpfr.DDPayrollFundRequestId FundRequestId, dpfr.RequestDate FundRequestDate," +
			                   "dppr.DDPayrollPayRequestId PayRequestId, dppr.enteredDate PayRequestDate " +
			                   "from ddpayroll dp inner join employee e on dp.employeeId=e.id " +
			                   "left outer join ddpayrollfundrequest dpfr on dpfr.ddpayrollfundid=dp.payrollfundid " +
			                   "left outer join ddpayrollpay dpp on dp.DDPayrollId = dpp.DDPayrollId " +
			                   "left outer join DDPayrollPayRequest dppr on dppr.DDPayrollPayId=dpp.DDPayrollPayId " +
												 "where dp.PayDate between DateAdd(day, -7, getdate()) and DateAdd(day, 7, getdate())" +
			                   "union " +
			                   "select 0 as Id, p.Id PayCheckId, e.CompanyId, c.CompanyName, case when p.PEOASOCOCHECK=1 then (select CompanyId from host where id=c.hostId) else p.CompanyId end PayingCompanyId, " +
			                   "(select CompanyName from Company where Id=case when p.PEOASOCOCHECK=1 then (select CompanyId from host where id=c.hostId) else p.CompanyId end) PayingCompanyName, p.PEOASOCOCheck IsHostCheck, " +
			                   "p.EmployeeId, e.FirstName, e.LastName, e.MiddleInitial, p.PayDay, py.ConfirmedTime, null EnteredDate, 'Not Initiated'," +
			                   "cast((p.NetWage*eba.Percentage/100) as decimal(18,2)) Amount, 0, null, 0, null " +
			                   "from PayrollPayCheck p inner join employee e on p.employeeid=e.id inner join company c on e.companyid=c.id " +
			                   "inner join EmployeeBankAccount eba on eba.EmployeeId=p.EmployeeId " +
			                   "inner join BankAccount ba on eba.BankAccountId=ba.Id " +
			                   "inner join payroll py on p.PayrollId=py.Id " +
			                   "where p.payday between DateAdd(day, -7, getdate()) and DateAdd(day, 7, getdate())" +
			                   "and p.id not in (select distinct PayrollId from ddpayroll) and p.IsVoid=0 and (p.paymentmethod=3) and isnull(c.ProfitStarsPayer,0)=1 " +
			                   "for Xml path('ProfitStarsPayroll'), root('ProfitStarsPayrollList'), Elements, type";
			return _readRepository.GetQueryData<List<ProfitStarsPayroll>>(sql, new XmlRootAttribute("ProfitStarsPayrollList"));
		}
	}
}
