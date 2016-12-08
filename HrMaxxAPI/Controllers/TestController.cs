
using System.Web.Http;
using HrMaxx.OnlinePayroll.Contracts.Services;

namespace HrMaxxAPI.Controllers
{
	public class TestController : BaseApiController
	{
		private readonly IScheduledJobService _scheduledJobService;
		
		public TestController(IScheduledJobService scheduledJobService)
		{
			_scheduledJobService = scheduledJobService;
			
		}
		[HttpGet]
		[AllowAnonymous]
		[Route("Scheduled/UpdateInvoicePayments")]
		public void UpdateInvoicePayments()
		{
			MakeServiceCall(() => _scheduledJobService.UpdateInvoicePayments(), "Update Invoice Payments for deposited checks");
			
		}
		[HttpGet]
		[AllowAnonymous]
		[Route("ACH/FillACHData")]
		public void FillACHData()
		{
			MakeServiceCall(() => _scheduledJobService.FillACHData(), "Update ACH Data");

		}
	}
}
