
using System;
using System.Drawing.Imaging;
using System.IO;
using System.Net;
using System.Net.Http.Formatting;
using System.Threading.Tasks;
using System.Web.Http;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxxAPI.Resources;

namespace HrMaxxAPI.Controllers
{
	public class TestController : BaseApiController
	{
		private readonly IScheduledJobService _scheduledJobService;
        private readonly IDocumentService _documentService;
		private readonly IACHService _achService;
        public TestController(IScheduledJobService scheduledJobService, IDocumentService documentService, IACHService aCHService)
		{
			_scheduledJobService = scheduledJobService;
            _documentService = documentService;
			_achService = aCHService;
			
		}
		[System.Web.Http.HttpGet]
		[System.Web.Http.AllowAnonymous]
		[System.Web.Http.Route("Scheduled/UpdateInvoicePayments")]
		public void UpdateInvoicePayments()
		{
			MakeServiceCall(() => _scheduledJobService.UpdateInvoicePayments(), "Update Invoice Payments for deposited checks");
			
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.AllowAnonymous]
		[System.Web.Http.Route("Scheduled/UpdateLastPayrollDates")]
		public void UpdateLastPayrollDates()
		{
			MakeServiceCall(() => _scheduledJobService.UpdateLastPayrollDates(), "Update Last Payroll Dates");

		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.AllowAnonymous]
		[System.Web.Http.Route("Scheduled/UpdateDBStats")]
		public void UpdateDBStats()
		{
			if (DateTime.Now.ToString("tt") == "AM")
			{
				MakeServiceCall(() => _scheduledJobService.UpdateDBStats(), "Update DB Stats");
			}

		}
		[System.Web.Http.HttpGet]
		[System.Web.Http.AllowAnonymous]
		[System.Web.Http.Route("Scheduled/ProfitStarsNineAM")]
		public void ProfitStarsNine()
		{
			//if (DateTime.Now.ToString("tt") == "AM")
			{
				MakeServiceCall(() => _scheduledJobService.ProfitStarsNineAM(), "Profit Stars 9 AM Service");
			}

		}
		[System.Web.Http.HttpGet]
		[System.Web.Http.AllowAnonymous]
		[System.Web.Http.Route("Scheduled/ProfitStarsOnePM")]
		public void ProfitStarsOne()
		{
			MakeServiceCall(() => _scheduledJobService.ProfitStarsOnePM(), "Profit Stars 1 PM service");
			
		}
		
		[System.Web.Http.HttpGet]
        [System.Web.Http.AllowAnonymous]
        [System.Web.Http.Route("Scheduled/PurgePayrollDocuments")]
        public void PurgePayrollDocuments()
        {
            //if (DateTime.Now.ToString("tt") == "AM")
            {
                MakeServiceCall(() => _documentService.PurgeDocuments(7), "Purge documents");
            }

        }

		[HttpPost]
		[AllowAnonymous]
		[Route("PSReportRequest")]
		public string ProfitStarReportRequest(FormDataCollection request)
		{
			try
			{
				var ps = new ProfitStarsRequest { Url = request["Url"], Data = request["Data"] };
				var webReq = (HttpWebRequest)WebRequest.Create(ps.Url);
				webReq.Method = "POST";
				webReq.ContentType = "application/x-www-form-urlencoded";
				webReq.ContentLength = ps.DataBytes.Length;
				ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
				//var postData = webReq.GetRequestStream();
				//postData.Write(request.DataBytes, 0, request.DataBytes.Length);
				//postData.Close();
				//var webResp = (HttpWebResponse) webReq.GetResponse();
				//var answer = webResp.GetResponseStream();
				//var _answer = new StreamReader(answer);
				//return _answer.ReadToEnd();
				return System.Text.Encoding.ASCII.GetString(ps.DataBytes);
			}
			catch (Exception e)
			{
				Logger.Error("Error in Profit Stars Report Request ", e);
				throw;
			}


		}

	}
}
