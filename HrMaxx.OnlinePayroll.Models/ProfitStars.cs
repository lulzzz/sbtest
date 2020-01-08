using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using HrMaxx.Infrastructure.Attributes;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Security;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public enum ProfitStarsPaymentType
	{
		[HrMaxxSecurity(HrMaxxName = "PaxolFund", DbName = "ddPayrollFundRequestProduction")]
		Fund=1,
		[HrMaxxSecurity(HrMaxxName = "PaxolPay", DbName = "ddPayrollPayRequestProduction")]
		Pay=2,
		[HrMaxxSecurity(HrMaxxName = "PaxolReFund", DbName = "ddPayrollReFundRequestProduction")]
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
		public string TypeName => Type.GetHrMaxxName();
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

		public DateTime ActualDateTime => Convert.ToDateTime(actualDate);
        public bool IsSuccess => string.Equals(success, "true");
        public bool HasError => string.Equals(error, "true");

        public ProfitStarsPaymentType Type =>
            requestID.StartsWith(ProfitStarsPaymentType.Fund.GetHrMaxxName()) || requestID.StartsWith(ProfitStarsPaymentType.Fund.GetDbName())
				? ProfitStarsPaymentType.Fund
                : requestID.StartsWith(ProfitStarsPaymentType.Pay.GetHrMaxxName()) || requestID.StartsWith(ProfitStarsPaymentType.Pay.GetDbName())
					? ProfitStarsPaymentType.Pay
                    : ProfitStarsPaymentType.Refund;

        public bool IsPaxolTransaction => requestID.StartsWith("Paxol") || requestID.StartsWith("ddPayroll");
        public int Id => Convert.ToInt32(requestID.Replace(Type.GetHrMaxxName(), string.Empty).Replace(Type.GetDbName(), string.Empty));

        public string EmailEntry =>
            $"<b>{Type.GetHrMaxxName()}</b>: Id: {Id.ToString()}, Result: {success}, RefNum: {refNum}<br/>";
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

		public bool HasError => string.Equals(error, "true");
        public bool IsSuccessful => string.Equals("Success", resultCode);

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
				str.AppendLine($"ResultCode: {resultCode}");
				str.AppendLine($"Error: {responseMessage}");
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

		public bool HasError => string.Equals(error, "true");
        public bool IsSuccessful => string.Equals("Success", resultCode);

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

		public DateTime EventTime => Convert.ToDateTime(eventDateTime);
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

		public DateTime TransactionTime => Convert.ToDateTime(transactionDateTime);

        public ProfitStarsPaymentType Type =>
            TransactionId.StartsWith(ProfitStarsPaymentType.Fund.GetHrMaxxName()) || TransactionId.StartsWith(ProfitStarsPaymentType.Fund.GetDbName())
				? ProfitStarsPaymentType.Fund
                : TransactionId.StartsWith(ProfitStarsPaymentType.Pay.GetHrMaxxName()) || TransactionId.StartsWith(ProfitStarsPaymentType.Pay.GetDbName())
					? ProfitStarsPaymentType.Pay
                    : ProfitStarsPaymentType.Refund;

        public bool IsPaxolTransaction => TransactionId.StartsWith("Paxol") || TransactionId.StartsWith("ddPayroll");
        public int Id => Convert.ToInt32(TransactionId.Replace(Type.GetHrMaxxName(), string.Empty).Replace(Type.GetDbName(), string.Empty));
        public string TypeName => Type.GetHrMaxxName();

        public string EmailEntry =>
            $"<b>{Type.GetHrMaxxName()}</b>: Id: {Id.ToString()}, TransactionStatus: {TransactionStatus}, SettlementStatus: {SettlementStatus}, RefNum: {RefNum}<br/>";
    }

	
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
		public DateTime ProjectedFundingDate => FundRequestDate ?? PayDate.AddDays(-3);
        public DateTime ProjectedPayDate => PayRequestDate ?? PayDate.AddDays(-1);
        public decimal Amount { get; set; }
		public int? FundRequestId { get; set; }
		public int? PayRequestId { get; set; }
		public DateTime? FundRequestDate { get; set; }
		public DateTime? PayRequestDate { get; set; }

        public int AccountType { get; set; }
        public string AccountNumber { get; set; }
        public string RoutingNumber { get; set; }

		public string EmployeeName => string.Format("{0}{2}{1}", FirstName, LastName,
            $" {(!string.IsNullOrWhiteSpace(MiddleInitial) ? MiddleInitial.Substring(0, 1) + " " : string.Empty)}");
        public string AccountTypeStr => ((BankAccountType) AccountType) == BankAccountType.Checking ? "Checking" : "Savings";
        public string AccountNumberStr => Crypto.Decrypt(AccountNumber);

        public string RoutingNumberStr => Crypto.Decrypt(RoutingNumber);
    }

	[XmlRoot("ProfitStarsPayrollList")]
	public class ProfitStarsPayrollFund
	{
		public int? Id { get; set; }
		public string PayingCompanyName { get; set; }
		public decimal Amount { get; set; }
		public int AccountType { get; set; }
		public string AccountNumber { get; set; }
		public string RoutingNumber { get; set; }
		public DateTime? RequestDate { get; set; }
		public DateTime ProjectedFundRequestDate { get; set; }
		public string AccountTypeStr => ((BankAccountType)AccountType) == BankAccountType.Checking ? "Checking" : "Savings";
		public string AccountNumberStr => Crypto.Decrypt(AccountNumber);

		public string RoutingNumberStr => Crypto.Decrypt(RoutingNumber);
		public string CompanyName => Payrolls.FirstOrDefault().CompanyName;
		public string Status => Payrolls.FirstOrDefault().Status;
		public DateTime PayDay => Payrolls.FirstOrDefault().PayDate;
		public DateTime ProjectedPayRequestDate => Payrolls.FirstOrDefault().ProjectedPayRequestDate;
		public List<ProfitStarsPayrollPay> Payrolls { get; set; }
	}
	public class ProfitStarsPayrollPay
	{
		public int? Id { get; set; }
		public int PayCheckId { get; set; }
		public Guid EmployeeId { get; set; }
		public string FirstName { get; set; }
		public string LastName { get; set; }
		public string MiddleInitial { get; set; }
		public string Status { get; set; }
		public string CompanyName { get; set; }
		public DateTime PayDate { get; set; }
		public DateTime? ConfirmedTime { get; set; }
		public DateTime? EnteredDate { get; set; }
		public DateTime? PayRequestDate { get; set; }
		public DateTime ProjectedPayRequestDate { get; set; }
		public int? PayRequestId { get; set; }
		public decimal Amount { get; set; }
		public int AccountType { get; set; }
		public string AccountNumber { get; set; }
		public string RoutingNumber { get; set; }

		public string EmployeeName => string.Format("{0}{2}{1}", FirstName, LastName,
			$" {(!string.IsNullOrWhiteSpace(MiddleInitial) ? MiddleInitial.Substring(0, 1) + " " : string.Empty)}");
		public string AccountTypeStr => ((BankAccountType)AccountType) == BankAccountType.Checking ? "Checking" : "Savings";
		public string AccountNumberStr => Crypto.Decrypt(AccountNumber);

		public string RoutingNumberStr => Crypto.Decrypt(RoutingNumber);
	}
	
}
