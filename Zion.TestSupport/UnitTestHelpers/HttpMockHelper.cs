using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Reflection;
using System.Security.Claims;
using System.Web;
using System.Web.Caching;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.SessionState;
using Moq;

namespace HrMaxx.TestSupport.UnitTestHelpers
{
	public static class HttpMockHelper
	{
		public static Dictionary<string, object> CurrentSession = new Dictionary<string, object>();
		public static Mock<HttpSessionStateBase> ControllerSessionStateMock = new Mock<HttpSessionStateBase>();

		public static HttpContextBase GiveControllerContext(this Controller controller, IEnumerable<Claim> claims)
		{
			HttpContextBase context = FakeHttpContext(claims);

			var rc = new RequestContext(context, new RouteData());
			controller.ControllerContext = new ControllerContext(rc, controller);
			controller.ControllerContext.RouteData.Values["action"] = "TEST_ACTION";
			controller.Url = new UrlHelper(rc);
			return context;
		}

		public static HttpContextBase GiveControllerContext(this Controller controller)
		{
			HttpContextBase context = FakeHttpContext();

			var rc = new RequestContext(context, new RouteData());
			controller.ControllerContext = new ControllerContext(rc, controller);
			controller.ControllerContext.RouteData.Values["action"] = "TEST_ACTION";
			controller.Url = new UrlHelper(rc);
			return context;
		}

		public static void MakeGlobalContext()
		{
			var httpRequest = new HttpRequest("", "http://mySomething/", "");
			var stringWriter = new StringWriter();
			var httpResponce = new HttpResponse(stringWriter);
			var httpContext = new HttpContext(httpRequest, httpResponce);

			var sessionContainer = new HttpSessionStateContainer("id",
				new SessionStateItemCollection(),
				new HttpStaticObjectsCollection(),
				10,
				true,
				HttpCookieMode.AutoDetect,
				SessionStateMode.InProc,
				false);

			httpContext.Items["AspSession"] = typeof (HttpSessionState).GetConstructor(
				BindingFlags.NonPublic | BindingFlags.Instance,
				null,
				CallingConventions.Standard,
				new[] {typeof (HttpSessionStateContainer)},
				null)
				.Invoke(new object[] {sessionContainer});

			HttpContext.Current = httpContext;
		}

		public static HttpContextBase FakeHttpContext(IEnumerable<Claim> claims = null)
		{
			Mock<HttpResponseBase> response;
			Mock<HttpRequestBase> request;

			Mock<HttpContextBase> baseContext = GetBaseContext(out response, out request, claims);

			var form = new NameValueCollection();
			var querystring = new NameValueCollection();
			var cookies = new HttpCookieCollection();
			var headers = new NameValueCollection();

			request.Setup(r => r.Cookies).Returns(cookies);
			request.Setup(r => r.Form).Returns(form);
			request.Setup(r => r.QueryString).Returns(querystring);
			request.Setup(r => r.Headers).Returns(headers);
			response.Setup(r => r.Cookies).Returns(cookies);

			return baseContext.Object;
		}

		private static Mock<HttpContextBase> GetBaseContext(out Mock<HttpResponseBase> response,
			out Mock<HttpRequestBase> request, IEnumerable<Claim> claims = null)
		{
			MakeGlobalContext();

			var context = new Mock<HttpContextBase> {DefaultValue = DefaultValue.Mock};
			request = new Mock<HttpRequestBase> {DefaultValue = DefaultValue.Mock};
			response = new Mock<HttpResponseBase> {DefaultValue = DefaultValue.Mock};
			var server = new Mock<HttpServerUtilityBase> {DefaultValue = DefaultValue.Mock};
			Cache cache = HttpRuntime.Cache;
			var user = new Mock<ClaimsPrincipal>();

			ControllerSessionStateMock.Setup(a => a.Add(It.IsAny<string>(), It.IsAny<object>()))
				.Callback<string, object>((s, o) => CurrentSession.Add(s, o));

			if (claims == null)
			{
				var identity = new Mock<ClaimsIdentity> {DefaultValue = DefaultValue.Mock};
				user.Setup(u => u.Identity).Returns(identity.Object);
				identity.Setup(u => u.IsAuthenticated).Returns(false);
				user.Object.AddIdentity(identity.Object);
				context.Setup(c => c.User).Returns(user.Object);
			}
			else
			{
				context.Setup(c => c.User).Returns(new ClaimsPrincipal(new ClaimsIdentity(claims)));
			}

			context.Setup(c => c.Request).Returns(request.Object);
			context.Setup(c => c.Response).Returns(response.Object);
			context.Setup(c => c.Session).Returns(ControllerSessionStateMock.Object);
			context.Setup(c => c.Server).Returns(server.Object);
			context.Setup(c => c.Cache).Returns(cache);

			return context;
		}

		public static HttpContextBase FakeHttpContextWithNoFormAndQueryStringAndCookies()
		{
			Mock<HttpResponseBase> response;
			Mock<HttpRequestBase> request;

			Mock<HttpContextBase> context = GetBaseContext(out response, out request);
			return context.Object;
		}

		public static string GetUrlFileName(string url)
		{
			return url.Contains("?") ? url.Substring(0, url.IndexOf("?")) : url;
		}

		public static NameValueCollection GetQueryStringParameters(string url)
		{
			if (url.Contains("?"))
			{
				var parameters = new NameValueCollection();

				string[] parts = url.Split("?".ToCharArray());
				string[] keys = parts[1].Split("&".ToCharArray());

				foreach (string key in keys)
				{
					string[] part = key.Split("=".ToCharArray());
					parameters.Add(part[0], part[1]);
				}

				return parameters;
			}

			return null;
		}

		public static void SetupRequestUrl(this Mock<HttpRequestBase> mockRequest, string url)
		{
			if (url == null)
				throw new ArgumentNullException("url");

			if (!url.StartsWith("~/"))
				throw new ArgumentException("Sorry, we expect a virtual url starting with \"~/\".");

			NameValueCollection qs = GetQueryStringParameters(url);
			string fn = GetUrlFileName(url);
			mockRequest.Setup(r => r.QueryString).Returns(qs);
			mockRequest.Setup(r => r.AppRelativeCurrentExecutionFilePath).Returns(fn);
			mockRequest.Setup(r => r.PathInfo).Returns(string.Empty);
		}

		public static void MakeRequestAjax(this HttpRequestBase request)
		{
			request.Headers.Add("X-Requested-With", "XMLHttpRequest");
		}
	}
}