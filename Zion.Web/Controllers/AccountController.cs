using System;
using System.Configuration;
using System.IdentityModel.Services;
using System.IdentityModel.Tokens;
using System.Linq;
using System.Net;
using System.Security.Claims;
using System.Security.Principal;
using System.Threading.Tasks;
using System.Web.Mvc;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Messages.Events;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Security;
using HrMaxx.Web.Code.ActionResult;
using HrMaxx.Web.ViewModels;
using RestSharp;

namespace HrMaxx.Web.Controllers
{
	public class AccountController : BaseController
	{
		public const string Action = "wa";
		public const string SignIn = "wsignin1.0";
		public const string SignOut = "wsignout1.0";
		private readonly IAuthenticationService _authenticationService;
		private readonly IDocumentService _documentService;

		public AccountController(IAuthenticationService authenticationService, IDocumentService documentService)
		{
			_authenticationService = authenticationService;
			_documentService = documentService;
		}

		public IBus Bus { get; set; }

		[AllowAnonymous]
		public ActionResult Login(string returnUrl)
		{
			if (HttpContext.User.Identity.IsAuthenticated || string.IsNullOrWhiteSpace(returnUrl))
				return RedirectToAction("Index", "Home");
			return _View(new AccountViewModel {ReturnUrl = returnUrl});
		}

		[HttpPost]
		[AllowAnonymous]
		[Route("token1")]
		public JsonNetResult LogOutUser(string username, string password)
		{
			string thisUser = string.Empty;
			if (HttpContext.User.Identity.IsAuthenticated)
			{
				thisUser = ((ClaimsPrincipal) HttpContext.User).Claims.First(c => c.Type.Equals(HrMaxxClaimTypes.UserID)).Value;
				FederatedAuthentication.SessionAuthenticationModule.SignOut();
			}
			if (thisUser != username)
			{
				IPrincipal principal = _authenticationService.Authenticate(username, password);
				var token = new SessionSecurityToken((ClaimsPrincipal) principal, TimeSpan.FromDays(1));
				SessionAuthenticationModule sam = FederatedAuthentication.SessionAuthenticationModule;

				token.IsPersistent = true;
				sam.WriteSessionTokenToCookie(token);
				HttpContext.User = principal;
				FederatedAuthentication.SessionAuthenticationModule.SignOut();
			}

			return Json(new {success = true});
		}

		[HttpPost]
		[AllowAnonymous]
		[Route("token")]
		public async Task<JsonNetResult> Token(TokenViewModel viewModel)
		{
			try
			{
				var client = new RestClient(ConfigurationManager.AppSettings["HrMaxxAPIUrl"] + "token");
				var request = new RestRequest {UseDefaultCredentials = true, Method = Method.POST};
				request.AddParameter("grant_type", "password", ParameterType.GetOrPost);
				request.AddParameter("username", viewModel.username, ParameterType.GetOrPost);
				request.AddParameter("password", viewModel.password, ParameterType.GetOrPost);
				IRestResponse response = client.Execute(request);

				string result = response.Content;
				if (response.StatusCode == HttpStatusCode.NotFound)
				{
					Logger.Error("API connection error");
					return Json(new {message = "Unable to connect to the API for Authentication.", success = false});
				}

				if (response.StatusCode == HttpStatusCode.BadRequest)
				{
					dynamic error = System.Web.Helpers.Json.Decode(result);
					Logger.Error("Unexpected error while retrieving token from API." + response.StatusCode + "--" + error.error + "--" +
					             error.error_description);
					return Json(new {message = error.error_description, success = false});
				}
				try
				{
					dynamic token = System.Web.Helpers.Json.Decode(result);

					return JsonSuccess(token.access_token);
				}
				catch (Exception ex)
				{
					Logger.Error("Error decoding token", ex);
					return Json(new {message = "Unexpected error: Invalid token.", success = false});
				}
			}
			catch (Exception e)
			{
				Logger.Error("Token Error", e);
				return Json(new {message = "Unexpected erorr. please try again later", success = false});
			}
		}

		[HttpPost]
		[AllowAnonymous]
		public ActionResult Login(AccountViewModel model)
		{
			try
			{
				if (!ModelState.IsValid)
					return ReturnModelStateErrorsAsJson();

				IPrincipal principal = _authenticationService.Authenticate(model.UserName, model.Password);
				if (principal == null)
				{
					return AjaxJson(false, "The user name or password is incorrect.");
				}

				WSFederationAuthenticationModule instance = FederatedAuthentication.WSFederationAuthenticationModule;

				var token = new SessionSecurityToken((ClaimsPrincipal) principal,
					instance.FederationConfiguration.CookieHandler.PersistentSessionLifetime.HasValue
						? instance.FederationConfiguration.CookieHandler.PersistentSessionLifetime.Value
						: TimeSpan.FromDays(30));

				SessionAuthenticationModule sam = FederatedAuthentication.SessionAuthenticationModule;
				token.IsPersistent = true;
				sam.WriteSessionTokenToCookie(token);
				HttpContext.User = principal;

				return Redirect(model.ReturnUrl);

				//return AjaxJson(true, "Success", new {returnUrl = model.ReturnUrl});
			}
			catch (Exception e)
			{
				Logger.Error("Error logging in", e);
				return ProcessJsonExceptionMessages("Error logging in.");
			}
		}

		[HttpGet]
		public ActionResult LogOff()
		{
			try
			{
				WSFederationAuthenticationModule instance = FederatedAuthentication.WSFederationAuthenticationModule;
				if (User.Identity.IsAuthenticated)
				{
					instance.SignOut();
					Bus.Publish(new UserEventLogEntry
					{
						UserId = CurrentUser.UserId,
						UserName = CurrentUser.FullName,
						Event = UserEventEnum.Logout,
						EventObject = string.Empty,
						EventObjectName = CurrentUser.GetType().ToString(),
						Module = "HrMaxx"
					});
				}

				return Redirect(instance.Issuer);
			}
			catch (Exception e)
			{
				Logger.Error("Error logging out", e);
				throw;
			}
		}
	}

	public class TokenViewModel
	{
		public string username { get; set; }
		public string password { get; set; }
	}
}