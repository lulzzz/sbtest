using System.Security.Principal;

namespace HrMaxx.Common.Contracts.Services
{
	public interface IAuthenticationService
	{
		IPrincipal Authenticate(string username, string password);
	}
}