using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Security.Claims;
using System.Web;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Hosting;
using System.Web.Http.Routing;
using Moq;

namespace HrMaxx.TestSupport.UnitTestHelpers
{
	public static class HttpApiMockHelper
	{
		public static Dictionary<string, object> CurrentSession = new Dictionary<string, object>();
		public static Mock<HttpSessionStateBase> ControllerSessionStateMock = new Mock<HttpSessionStateBase>();

		public static void GiveControllerContext(this ApiController controller, IEnumerable<Claim> claims)
		{
			var config = new HttpConfiguration();
			IHttpRoute route = config.Routes.MapHttpRoute("DefaultApi", "api/{controller}/{id}");
			var routeData = new HttpRouteData(route, new HttpRouteValueDictionary {{"controller", "products"}});
			var request = new HttpRequestMessage(HttpMethod.Post, "http://localhost/api/products");
			request.Headers.Host = "test";
			request.Headers.Referrer = new Uri("http://SUT");
			var rc = new HttpRequestContext();
			rc.Principal = new ClaimsPrincipal(new ClaimsIdentity(claims));
			rc.RouteData = routeData;
			controller.ControllerContext = new HttpControllerContext(rc, request, new HttpControllerDescriptor(), controller);
			controller.ControllerContext.RouteData.Values["action"] = "TEST_ACTION";
			controller.Request = request;
			controller.Request.Properties[HttpPropertyKeys.HttpConfigurationKey] = config;
		}
	}
}