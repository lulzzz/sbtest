
using System;
using System.Drawing.Imaging;
using System.IO;
using System.Net;
using System.Net.Http.Formatting;
using System.Threading.Tasks;
using System.Web.Http;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxxAPI.Resources;

namespace HrMaxxAPI.Controllers
{
	public class TestController : BaseApiController
	{
		private readonly IScheduledJobService _scheduledJobService;
		
		public TestController(IScheduledJobService scheduledJobService)
		{
			_scheduledJobService = scheduledJobService;
			
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
		[System.Web.Http.Route("Scheduled/UpdateDBStats")]
		public void UpdateDBStats()
		{
			if (DateTime.Now.ToString("tt") == "AM")
			{
				MakeServiceCall(() => _scheduledJobService.UpdateDBStats(), "Update DB Stats");
			}

		}

		[HttpPost]
		[AllowAnonymous]
		[Route("PSReportRequest")]
		public async Task<string> ProfitStarReportRequest(FormDataCollection request)
		{
			try
			{
				var ps = new ProfitStarsRequest {Url = request["Url"], Data = request["Data"]};
				var webReq = (HttpWebRequest) WebRequest.Create(ps.Url);
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
				Logger.Error("Error in Profit Stars Report Request " , e);
				throw;
			}


		}
		
	}
}
