using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Serialization;
using System.Xml.Xsl;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Services;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Repository.Payroll;
using HrMaxx.OnlinePayroll.Repository.ProfitStars;
using Magnum.FileSystem;

namespace HrMaxx.OnlinePayroll.Services.ACH
{
	public class ACHService : BaseService, IACHService
	{
		private readonly IProfitStarsRepository _profitStarsRepository;
		private readonly IEmailService _emailService;
		private readonly IFileRepository _fileRepository;
		private readonly IMetaDataService _metaDataService;
		private const string StoreId = "86550";
		private const string StoreKey = "TWgL+HBc2jts9vefoen+uZdRcwu1";
		private const string MerchantId = "32493";
		private const string LocationId = "83328";
		private readonly string EmailTo = string.Empty;
		private readonly string EmailCC = string.Empty;
		
		private const string PaymentGateway = "https://ssl.selectpayment.com/rtg/XMLGateway.aspx";
		private const string ReportGateway = "https://ssl.selectpayment.com/rtg/XMLReports.aspx";
		
		private readonly string _filePath;
		private readonly string _templatePath;
		public ACHService(IProfitStarsRepository profitStarsRepository, IEmailService emailService, IFileRepository fileRepository, IMetaDataService metaDataService, string templatePath, string filePath, string psemailto, string psemailcc)
		{
			_profitStarsRepository = profitStarsRepository;
			_emailService = emailService;
			_fileRepository = fileRepository;
			_metaDataService = metaDataService;
			_templatePath = templatePath;
			_filePath = filePath;
			EmailTo = psemailto;
			EmailCC = psemailcc;
		}
		public void FillACH()
		{
			try
			{
				FillACHInvoices();
				FillACHPayChecks();
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Fill ACH table");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		/*
		 * Profit Stars 9AM Service 
		 */
		public ProfitStarsReportResponse ProfitStarsStatusUpdate()
		{
			try
			{
				var reportResponse = new ProfitStarsReportResponse();
				var emailSubject = "Paxol: ACH Service-9AM: Summary";
				var emailStr = new StringBuilder();
				var startdateStr = _profitStarsRepository.MoveRequestsToReports();
				var startdate = string.IsNullOrWhiteSpace(startdateStr)
					? DateTime.Today.AddDays(-1)
					: Convert.ToDateTime(startdateStr);
				var fileName = string.Format("ReportRequest-{0}-{1}", DateTime.Today.ToString("yyyy-MM-dd"), DateTime.Now.Millisecond);
				var requestFile = CreateRequestRTG(new List<ProfitStarsPayment>(), "transformers/ProfitStars/ReportRequest.xslt", fileName, startdate);
				var responseFile = string.Format("ReportResponse-{0}-{1}", DateTime.Today.ToString("yyyy-MM-dd"), DateTime.Now.Millisecond);
				var result = SendRTGRequest(requestFile, ReportGateway, responseFile);
				if (!result.StartsWith(OnlinePayrollStringResources.ERROR_FailedToRetrieveX))
				{
					emailStr.AppendLine(
						"Version 2: The following are the requests that have been updated today from data retrieved from <br/><br/>");
					reportResponse = Utilities.Deserialize<ProfitStarsReportResponse>(result);
					reportResponse.Events = reportResponse.Events.Where(e => e.Transaction.IsPaxolTransaction).ToList();
					if (reportResponse.Events.Any())
					{
						_profitStarsRepository.UpdatePaymentRequests(reportResponse, responseFile + ".xml");
						emailStr.AppendLine(reportResponse.Email);
					}
					else
					{
						emailStr.AppendLine("No Payment Requests found to be updated");
					}
				}
				else
				{
					emailSubject = "Paxol: Error in ProfitStars 9AM";
					emailStr.AppendLine("<b><u>There was an error in sending report reques to ProfitStars</u></b></br><br/>");
					emailStr.AppendLine(result);
					emailStr.AppendLine("<b><u>You may want to consider running the 9 AM service again manually.</u></b></br><br/>");
				}
				_emailService.SendEmail(EmailTo, emailSubject, emailStr.ToString(), EmailCC);
					
				return reportResponse;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Profit Stars - 9 AM ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<ProfitStarsPayroll> GetProfitStarsPayrollList()
		{
			try
			{
				var result =  _profitStarsRepository.GetProfitStarsPayrollList();
				if (result==null)
					result =  new List<ProfitStarsPayroll>();
				return result;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Fill ACH table");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		/*
		 * Profit Stars 1PM Service 
		 */
		public List<ProfitStarsPayment> ProfitStarsPayments()
		{
			try
			{
				var emailSubject = "Paxol: ACH Service-1 PM: Summary";
				var emailStr = new StringBuilder();
				var paymentRequests = GetProfitStarsPayments();

				if (paymentRequests.Any())
				{
					var fileName = string.Format("PaymentRequest-{0}-{1}", DateTime.Today.ToString("yyyy-MM-dd"),
						DateTime.Now.Millisecond);
					var requestFile = CreateRequestRTG(paymentRequests, "transformers/ProfitStars/PaymentRequest.xslt", fileName,
						DateTime.Today);
					var result = SendRTGRequest(requestFile, PaymentGateway,
						string.Format("PaymentResponse-{0}-{1}", DateTime.Today.ToString("yyyy-MM-dd"), DateTime.Now.Millisecond));
					if (!result.StartsWith(OnlinePayrollStringResources.ERROR_FailedToRetrieveX))
					{
						var paymentResponse = Utilities.Deserialize<ProfitStarsPayResponses>(result);
						paymentRequests.ForEach(
							pr => pr.PayResponse = paymentResponse.Responses.First(prr => prr.requestID.Equals(pr.requestID)));
						_profitStarsRepository.SavePaymentRequests(paymentRequests, requestFile);
						emailStr.AppendLine(
						"Version 2: The following are the funding/payment/refund requests that have been sent today <br/><br/>");
						emailStr.AppendLine(paymentResponse.Email);
					}
					else
					{
						emailSubject = "Paxol: Error in ProfitStars 1 PM";
						emailStr.AppendLine("<b><u>There was an error in sending payment requests to ProfitStars</u></b></br><br/>");
						emailStr.AppendLine(result);
						emailStr.AppendLine("<b><u>You may want to consider running the 1 PM service again manually.</u></b></br><br/>");
					}
				}
				else
				{
					emailStr.AppendLine("<b><u>No Funding/Payment/Refund requests found to be sent</u></b></br><br/>");
				}
				_emailService.SendEmail(EmailTo,  emailSubject, emailStr.ToString(), EmailCC);
				return paymentRequests;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Profit Stars - 1 PM");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		
		private string CreateRequestRTG(List<ProfitStarsPayment> data, string template, string fileName, DateTime startdate)
		{

			var xml = Utilities.GetXml(data);
			var argList = new XsltArgumentList();
			argList.AddParam("storeId", string.Empty, StoreId);
			argList.AddParam("storeKey", string.Empty, StoreKey);
			argList.AddParam("merchantId", string.Empty, MerchantId);
			argList.AddParam("locationId", string.Empty, LocationId);
			argList.AddParam("startdate", string.Empty, startdate.ToString("yyyy-MM-dd"));
			argList.AddParam("enddate", string.Empty, DateTime.Today.ToString("yyyy-MM-dd"));

			var transformed = Utilities.XmlTransform(xml, string.Format("{0}{1}", _templatePath, template), argList);
			transformed = transformed.Replace("xmlns=\"\"", string.Empty);
			return _fileRepository.SaveFile(_filePath, fileName, "xml", transformed);


		}

		private string SendRTGRequest(string file, string url, string filename)
		{
			try
			{
				var requestStr = _fileRepository.GetFileText(file);
				var requestBytes = Encoding.ASCII.GetBytes(requestStr);
				ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
				var webReq = (HttpWebRequest)WebRequest.Create(url);
				webReq.Method = "POST";
				webReq.ContentType = "application/x-www-form-urlencoded";
				webReq.ContentLength = requestBytes.Length;
				webReq.Timeout = 300000;
				
				var postData = webReq.GetRequestStream();
				postData.Write(requestBytes, 0, requestBytes.Length);
				postData.Close();

				var webResp = (HttpWebResponse)webReq.GetResponse();
				var answer = webResp.GetResponseStream();
				var _answer = new StreamReader(answer);
				var result = _answer.ReadToEnd();
				_fileRepository.SaveFile(_filePath, filename, ".xml", result);
				//var result = _fileRepository.GetFileText(string.Format("{0}{1}.xml", _filePath, url.Equals(ReportGateway) ? "samplereportresponse" : "samplepayresponse"));
				return result;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" ProfitStars RTG Request {0} - {1} ", url, file));
				Log.Error(message, e);
				return message;
			}
			
		}

		
		
		private List<ProfitStarsPayment> GetProfitStarsPayments()
		{
			try
			{
				var payDay = GetDDDayForToday();
				var returnList = new List<ProfitStarsPayment>();
				using (var txn = TransactionScopeHelper.Transaction())
				{
					_profitStarsRepository.RefreshProfitStarsData(payDay);
					returnList = _profitStarsRepository.GetProfitStarsData();
					txn.Complete();
				}

				return returnList;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Refresh and Get PS Requests ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
			
		}

		private DateTime GetDDDayForToday()
		{
			var threedaysafter = DateTime.Today.AddDays(3);
			var bankHolidays = _metaDataService.GetBankHolidays();
			while (threedaysafter.DayOfWeek == DayOfWeek.Saturday || threedaysafter.DayOfWeek == DayOfWeek.Sunday || bankHolidays.Any(b => b.Value.Equals(threedaysafter)))
			{
				threedaysafter = threedaysafter.AddDays(1);
			}
			return threedaysafter.Date;
		}

		

		private void FillACHPayChecks()
		{
			
		}

		private void FillACHInvoices()
		{
			
		}
	}
}
