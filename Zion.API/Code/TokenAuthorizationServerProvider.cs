using System;
using System.Security.Claims;
using System.Security.Principal;
using System.Threading.Tasks;
using System.Web;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Infrastructure.Security;
using Microsoft.Owin.Security.OAuth;

namespace HrMaxx.API.Code
{
	public class TokenAuthorizationServerProvider : OAuthAuthorizationServerProvider
	{
		private readonly IAuthenticationService _authenticationService;

		public TokenAuthorizationServerProvider(IAuthenticationService authenticationService)
		{
			_authenticationService = authenticationService;
		}

		public IBus Bus { get; set; }

		public override async Task ValidateClientAuthentication(OAuthValidateClientAuthenticationContext context)
		{
			context.Validated();
		}

		public override async Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
		{
			context.OwinContext.Response.Headers.Add("Access-Control-Allow-Origin", new[] {"*"});
			try
			{
				IPrincipal user = _authenticationService.Authenticate(context.UserName, context.Password);
				if (user == null)
				{
					context.SetError("invalid_grant", "The user name or password is incorrect.");
					return;
				}
				if ((user as ClaimsPrincipal).HasClaim(c => c.Type.Equals(HrMaxxClaimTypes.LoginError)))
				{
					context.SetError("invalid_user",
						(user as ClaimsPrincipal).FindFirst(c => c.Type.Equals(HrMaxxClaimTypes.LoginError)).Value);
					return;
				}

				HttpContext.Current.User = user;
				context.Validated(user.Identity as ClaimsIdentity);
			}
			catch (Exception e)
			{
				context.SetError("invalid_grant", e.Message);
			}
		}
	}
}