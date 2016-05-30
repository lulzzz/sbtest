using System;
using System.Security.Claims;
using System.Security.Principal;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Security;
using HrMaxx.Infrastructure.Services;

namespace HrMaxx.Common.Services.Security
{
	public class AuthenticationService : BaseService, IAuthenticationService
	{
		private readonly string _tokenVersion;

		public AuthenticationService(string tokenVersion)
		{
			_tokenVersion = tokenVersion;
		}

		public IPrincipal Authenticate(string username, string password)
		{
			try
			{
				var claimsPrincipal = new ClaimsPrincipal();

				var claimsIdentity = new ClaimsIdentity(AuthenticationTypes.Federation) {Label = "UAM"};
				claimsIdentity.AddClaim(new Claim(HrMaxxClaimTypes.Name, "Sherjeel Bedaar"));
					claimsIdentity.AddClaim(new Claim(HrMaxxClaimTypes.UserID, "1234;"));
					claimsIdentity.AddClaim(new Claim(HrMaxxClaimTypes.Version, _tokenVersion));
				claimsPrincipal.AddIdentity(claimsIdentity);

				return claimsPrincipal;
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_UnexpectedError, " Invalid User Access details");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private void AddClaim(ClaimsIdentity identity, string claimType, string value)
		{
			if (!identity.HasClaim(c => c.Type.Equals(claimType) && c.Value.Equals(value)))
				identity.AddClaim(new Claim(claimType, value));
		}
	}
}