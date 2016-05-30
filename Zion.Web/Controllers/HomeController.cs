using System;
using System.Configuration;
using System.IdentityModel.Configuration;
using System.IdentityModel.Services;
using System.IdentityModel.Tokens;
using System.Security.Claims;
using System.Web;
using System.Web.Mvc;
using HrMaxx.Web.Code.Security;

namespace HrMaxx.Web.Controllers
{
	public class HomeController : BaseController
	{
		public const string Action = "wa";
		public const string SignIn = "wsignin1.0";
		public const string SignOut = "wsignout1.0";

		public ActionResult Index()
		{
			if (User.Identity.IsAuthenticated)
			{
				string action = Request.QueryString[Action];

				if (action == SignIn)
				{
					string formData = ProcessSignIn(Request.Url, (ClaimsPrincipal) User);
					return new ContentResult {Content = formData, ContentType = "text/html"};
				}
				if (action == SignOut)
				{
					ProcessSignOff(Request.Url, (ClaimsPrincipal) User, (HttpResponse) HttpContext.Items["HttpResponse"]);
					var requestMessage = (SignOutRequestMessage) WSFederationMessage.CreateFromUri(Request.Url);
					return Redirect(requestMessage.Reply);
				}
			}
			return View();
		}

		public ActionResult AccessDenied()
		{
			return View();
		}

		public ActionResult AccessList()
		{
			return View();
		}

		private static string ProcessSignIn(Uri url, ClaimsPrincipal user)
		{
			var requestMessage = (SignInRequestMessage) WSFederationMessage.CreateFromUri(url);
			var signingCredentials =
				new X509SigningCredentials(
					CustomSecurityTokenService.GetCertificate(ConfigurationManager.AppSettings["SigningCertificateName"]));
			var config = new SecurityTokenServiceConfiguration(ConfigurationManager.AppSettings["IssuerName"], signingCredentials);

			var sts = new CustomSecurityTokenService(config);
			SignInResponseMessage responseMessage =
				FederatedPassiveSecurityTokenServiceOperations.ProcessSignInRequest(requestMessage, user, sts);
			return responseMessage.WriteFormPost();
		}

		private static void ProcessSignOff(Uri url, ClaimsPrincipal user, HttpResponse response)
		{
			var requestMessage = (SignOutRequestMessage) WSFederationMessage.CreateFromUri(url);
			FederatedPassiveSecurityTokenServiceOperations.ProcessSignOutRequest(requestMessage, user, null, response);
		}
	}
}