using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using HrMaxx.Infrastructure.Attributes;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Security;
using HrMaxx.OnlinePayroll.Models.Enum;
using Newtonsoft.Json.Serialization;

namespace HrMaxx.OnlinePayroll.Models
{
	public enum ProfitStarsPaymentType
	{
		[HrMaxxSecurity(HrMaxxName = "PaxolFund", DbName = "Funding")]
		Fund=1,
		[HrMaxxSecurity(HrMaxxName = "PaxolPay", DbName = "Payment")]
		Pay=2,
		[HrMaxxSecurity(HrMaxxName = "PaxolReFund", DbName = "Refund")]
		Refund=3
	}

	public class ProfitStarsPayment
	{
		public int Id { get; set; }
		public ProfitStarsPaymentType Type { get; set; }
		public Guid CompanyId { get; set; }
		public Guid EmployeeId { get; set; }
		public decimal Amount { get; set; }
		public DateTime EnteredDate { get; set; }
		public BankAccountType AccountType { get; set; }
		public string AccountNumber { get; set; }
		public string RoutingNumber { get; set; }
		public string requestID { get; set; }
		public string transactionID { get; set; }
		public string TypeName { get { return Type.GetHrMaxxName(); } }
		public ProfitStarsPayResponse PayResponse { get; set; }
	}
	public class ProfitStarsPayResponse
	{
		[XmlAttribute]
		public string refNum { get; set; }
		[XmlAttribute]
		public string requestID { get; set; }
		[XmlAttribute]
		public string success { get; set; }
		[XmlAttribute]
		public string error { get; set; }
		[XmlAttribute]
		public string resultCode { get; set; }

		public string actualDate { get; set; }
		public string responseMessage { get; set; }
		public string originatedAs { get; set; }

		public DateTime ActualDateTime { get { return Convert.ToDateTime(actualDate); } }
		public bool IsSuccess { get { return string.Equals(success, "true"); } }
		public bool HasError { get { return string.Equals(error, "true"); } }

		public ProfitStarsPaymentType Type { get
		{
			return requestID.StartsWith(ProfitStarsPaymentType.Fund.GetHrMaxxName())
				? ProfitStarsPaymentType.Fund
				: requestID.StartsWith(ProfitStarsPaymentType.Pay.GetHrMaxxName())
					? ProfitStarsPaymentType.Pay
					: ProfitStarsPaymentType.Refund;
		} }

		public bool IsPaxolTransaction{get { return requestID.StartsWith("Paxol"); }}
		public int Id { get { return Convert.ToInt32(requestID.Replace(Type.GetHrMaxxName(), string.Empty)); } }

		public string EmailEntry
		{
			get
			{
				return string.Format("<b>{0}</b>: Id: {1}, Result: {2}, RefNum: {3}<br/>", Type.GetDbName(), Id.ToString(), success,
					refNum);
			}
		}
	}
	[XmlRoot("responses")]
	public class ProfitStarsPayResponses
	{
		[XmlAttribute]
		public string error { get; set; }
		[XmlAttribute]
		public string resultCode { get; set; }
		[XmlAttribute]
		public string responseMessage { get; set; }
		[XmlElement(ElementName = "response")]
		public List<ProfitStarsPayResponse> Responses { get; set; }

		public bool HasError { get { return string.Equals(error, "true"); } }
		public bool IsSuccessful { get { return string.Equals("Success", resultCode); } }

		public string Email
		{
			get
			{
				var str = new StringBuilder();
				Responses.Where(e => e.IsPaxolTransaction).OrderBy(e => e.Type).ToList().ForEach(e => str.Append(e.EmailEntry));
				return str.ToString();
			}
		}
		public string ErrorEmail
		{
			get
			{
				var str = new StringBuilder();
				str.AppendLine(string.Format("ResultCode: {0}", resultCode));
				str.AppendLine(string.Format("Error: {0}", responseMessage));
				return str.ToString();
			}
		}
	}

	[XmlRoot("events")]
	public class ProfitStarsReportResponse
	{
		[XmlAttribute]
		public string error { get; set; }
		[XmlAttribute]
		public string resultCode { get; set; }
		[XmlAttribute]
		public string responseMessage { get; set; }
		[XmlElement(ElementName = "event")]
		public List<ProfitStarsReportEvent> Events { get; set; }

		public bool HasError { get { return string.Equals(error, "true"); } }
		public bool IsSuccessful { get { return string.Equals("Success", resultCode); } }
		public string Email
		{
			get
			{
				var str = new StringBuilder();
				Events.Where(e=>e.Transaction.IsPaxolTransaction).OrderBy( e=>e.Transaction.Type).ToList().ForEach(e=>str.Append(e.Transaction.EmailEntry));
				return str.ToString();
			}
		}
	}

	public class ProfitStarsReportEvent
	{
		[XmlAttribute]
		public string eventDateTime { get; set; }
		[XmlAttribute]
		public string eventType { get; set; }
		[XmlAttribute]
		public string application { get; set; }
		[XmlAttribute]
		public string userName { get; set; }
		[XmlAttribute]
		public string sequenceNumber { get; set; }
		[XmlElement(ElementName = "transaction")]
		public ProfitStarsReportTransaction Transaction { get; set; }

		public DateTime EventTime { get { return Convert.ToDateTime(eventDateTime); } }

		
	}
	public class ProfitStarsReportTransaction
	{
		[XmlAttribute("transactionNumber")]
		public string TransactionId { get; set; }
		[XmlAttribute("settlementStatus")]
		public string SettlementStatus { get; set; }
		[XmlAttribute("transactionStatus")]
		public string TransactionStatus { get; set; }
		[XmlAttribute("refNumber")]
		public string RefNum { get; set; }
		[XmlAttribute("operationType")]
		public string OperationType { get; set; }
		[XmlAttribute("sequenceID")]
		public string SequenceNumber { get; set; }
		[XmlAttribute("transactionDateTime")]
		public string transactionDateTime { get; set; }

		public DateTime TransactionTime { get { return Convert.ToDateTime(transactionDateTime); }  }

		public ProfitStarsPaymentType Type { get
		{
			return TransactionId.StartsWith(ProfitStarsPaymentType.Fund.GetHrMaxxName())
				? ProfitStarsPaymentType.Fund
				: TransactionId.StartsWith(ProfitStarsPaymentType.Pay.GetHrMaxxName())
					? ProfitStarsPaymentType.Pay
					: ProfitStarsPaymentType.Refund;
		} }

		public bool IsPaxolTransaction{get { return TransactionId.StartsWith("Paxol"); }}
		public int Id { get { return Convert.ToInt32(TransactionId.Replace(Type.GetHrMaxxName(), string.Empty)); } }
		public string TypeName { get { return Type.GetHrMaxxName(); } }
		public string EmailEntry { get
		{
			return string.Format("<b>{0}</b>: Id: {1}, TransactionStatus: {2}, SettlementStatus: {3}, RefNum: {4}<br/>", Type.GetDbName(), Id.ToString(), TransactionStatus, SettlementStatus, RefNum );
		} }
	}

	[XmlRoot("ProfitStarsPayrollList")]
    public class ProfitStarsPayroll
	{
		public int Id { get; set; }
		public int PayCheckId { get; set; }
		public Guid CompanyId { get; set; }
		public string CompanyName { get; set; }
		public Guid PayingCompanyId { get; set; }
		public string PayingCompanyName { get; set; }
		public Guid EmployeeId { get; set; }
		public string FirstName { get; set; }
		public string LastName { get; set; }
		public string MiddleInitial { get; set; }
		
		public bool IsHostCheck { get; set; }
		public string Status { get; set; }
		public DateTime PayDate { get; set; }
		public DateTime ConfirmedTime { get; set; }
		public DateTime ProjectedFundingDate { get { return FundRequestDate.HasValue ? FundRequestDate.Value : PayDate.AddDays(-3); } }
		public DateTime ProjectedPayDate { get { return PayRequestDate.HasValue ? PayRequestDate.Value : PayDate.AddDays(-1); } }
		public decimal Amount { get; set; }
		public int? FundRequestId { get; set; }
		public int? PayRequestId { get; set; }
		public DateTime? FundRequestDate { get; set; }
		public DateTime? PayRequestDate { get; set; }

        public int AccountType { get; set; }
        public string AccountNumber { get; set; }
        public string RoutingNumber { get; set; }

		public string EmployeeName => string.Format("{0}{2}{1}", FirstName, LastName, string.Format(" {0}", !string.IsNullOrWhiteSpace(MiddleInitial) ? MiddleInitial.Substring(0, 1) + " " : string.Empty));
        public string AccountTypeStr => ((BankAccountType) AccountType) == BankAccountType.Checking ? "Checking" : "Savings";
        public string AccountNumberStr => Crypto.Decrypt(AccountNumber);

        public string RoutingNumberStr => Crypto.Decrypt(RoutingNumber);
    }

	
	
}
