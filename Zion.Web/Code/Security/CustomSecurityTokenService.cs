using System;
using System.Collections.Generic;
using System.Configuration;
using System.IdentityModel;
using System.IdentityModel.Configuration;
using System.IdentityModel.Protocols.WSTrust;
using System.IdentityModel.Tokens;
using System.Linq;
using System.Security.Claims;
using System.Security.Cryptography.X509Certificates;

namespace HrMaxx.Web.Code.Security
{
	public class CustomSecurityTokenService : SecurityTokenService
	{
		private static readonly string[] SupportedWebApps = {};

		public CustomSecurityTokenService(SecurityTokenServiceConfiguration securityTokenServiceConfiguration)
			: base(securityTokenServiceConfiguration)
		{
		}

		private static void ValidateAppliesTo(EndpointReference appliesTo)
		{
			if (SupportedWebApps == null || SupportedWebApps.Length == 0) return;

			bool validAppliesTo = SupportedWebApps.Any(x => appliesTo.Uri.Equals(x));

			if (!validAppliesTo)
			{
				throw new InvalidRequestException(String.Format("The 'appliesTo' address '{0}' is not valid.",
					appliesTo.Uri.OriginalString));
			}
		}

		protected override Scope GetScope(ClaimsPrincipal principal, RequestSecurityToken request)
		{
			ValidateAppliesTo(request.AppliesTo);

			var scope = new Scope(request.AppliesTo.Uri.OriginalString, SecurityTokenServiceConfiguration.SigningCredentials);

			if (!string.IsNullOrEmpty(ConfigurationManager.AppSettings["EncryptionCertificate"]))
			{
				// Important note on setting the encrypting credentials.
				// In a production deployment, you would need to select a certificate that is specific to the RP that is requesting the token.
				// You can examine the 'request' to obtain information to determine the certificate to use.

				X509Certificate2 encryptingCertificate = GetCertificate(ConfigurationManager.AppSettings["EncryptionCertificate"]);
				var encryptingCredentials = new X509EncryptingCredentials(encryptingCertificate);
				scope.EncryptingCredentials = encryptingCredentials;
			}
			else
			{
				// If there is no encryption certificate specified, the STS will not perform encryption.
				// This will succeed for tokens that are created without keys (BearerTokens) or asymmetric keys.  
				scope.TokenEncryptionRequired = false;
			}

			scope.ReplyToAddress = request.ReplyTo;

			return scope;
		}

		protected override ClaimsIdentity GetOutputClaimsIdentity(ClaimsPrincipal principal, RequestSecurityToken request,
			Scope scope)
		{
			return (ClaimsIdentity) principal.Identity;
		}

		public static X509Certificate2 GetCertificate(string subjectName)
		{
			var store = new X509Store(StoreName.My, StoreLocation.LocalMachine);
			X509Certificate2Collection certificates = null;
			store.Open(OpenFlags.ReadOnly);

			try
			{
				certificates = store.Certificates;
				List<X509Certificate2> certs =
					certificates.OfType<X509Certificate2>()
						.Where(x => x.SubjectName.Name.Equals(subjectName, StringComparison.OrdinalIgnoreCase))
						.ToList();

				if (certs.Count == 0)
					throw new ApplicationException(string.Format("No certificate was found for subject Name {0}", subjectName));
				else if (certs.Count > 1)
					throw new ApplicationException(string.Format("There are multiple certificates for subject Name {0}", subjectName));

				return new X509Certificate2(certs[0]);
			}
			finally
			{
				if (certificates != null)
				{
					for (int i = 0; i < certificates.Count; i++)
					{
						X509Certificate2 cert = certificates[i];
						cert.Reset();
					}
				}
				store.Close();
			}
		}
	}
}