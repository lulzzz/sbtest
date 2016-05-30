using System.Web.Http;
using System.Collections.Generic;

namespace HRMAXX.Controllers.Api
{
	[Authorize]
	public class TestController : ApiController
	{
		public TestController()
		{
			
		}
		[Route("api/users")]
		
		public List<string> GetUsers()
		{
			return new List<string> { "one", "two" };
		}
	}
}
