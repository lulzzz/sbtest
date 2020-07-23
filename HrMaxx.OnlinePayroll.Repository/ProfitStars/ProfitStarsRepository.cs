﻿using System;
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
			string sql = "usp_RefreshProfitStarsData";

			using (var con = new SqlConnection(_sqlCon))
			{
				using (var cmd = new SqlCommand(sql))
				{
					cmd.CommandTimeout = 0;
					cmd.CommandType = CommandType.StoredProcedure;
					cmd.Connection = con;
					cmd.Parameters.AddWithValue("payDate", payDay.ToString("MM/dd/yyyy"));
					con.Open();
					cmd.ExecuteNonQuery();
					con.Close();
				}
			}
		}

		public string MoveRequestsToReports()
		{
			string sql = "usp_MoveProfitStarsRequestsToReports";

			using (var con = new SqlConnection(_sqlCon))
			{
				using (var cmd = new SqlCommand(sql))
				{
					cmd.CommandTimeout = 0;
					cmd.CommandType = CommandType.StoredProcedure;
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
		public void MarkFundingSuccessful(int fundRequestId)
		{
			const string sql = "update ddpayrollfundreport set manualUpdate=1, transactionstatus='Processed', settlementstatus='Settled'  where ddpayrollfundrequestid=@FundRequestId; update ddpayroll set Status='Funding Succeeded' where payrollfundid=@FundRequestId";
			using (var con = GetConnection())
			{
				var counts = con.Execute(sql, new { FundRequestId = fundRequestId });
			}
		}
		public List<ProfitStarsPayrollFund> GetProfitStarsPayrollList()
		{
			return _readRepository.GetDataFromStoredProc1<List<ProfitStarsPayrollFund>>("usp_GetProfitStarsPayrollList", new List<FilterParam>(), new XmlRootAttribute("ProfitStarsPayrollList"));
		}
	}
}
