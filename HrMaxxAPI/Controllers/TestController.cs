using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Web.Http;
using HrMaxx.Infrastructure.Tracing;

namespace HrMaxxAPI.Controllers
{
	[Authorize]
	public class TestController : BaseApiController
	{
		public TestController()
		{
			
		}
		[Route("api/users")]
		public List<string> GetUsers()
		{
			Logger.Info("test Get Users");
			var user = (User as ClaimsPrincipal);
			HrMaxxTrace.LogRequest(PerfTraceType.BusinessLayerCall, GetType(), "Get users",
					CurrentUser.FullName);
			return new List<string> { "one", "two" };
		
		}
	}
}
