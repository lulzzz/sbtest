using System.Security.Claims;
using System.Web.Mvc;
using HrMaxx.Infrastructure.Security;

namespace HrMaxxWeb.Code.Security
{
	public abstract class HrMaxxViewPage<TModel> : WebViewPage<TModel>
	{
		protected HrMaxxUser CurrentUser
		{
			get { return new HrMaxxUser(User as ClaimsPrincipal); }
		}
	}

	public abstract class HrMaxxViewPage : HrMaxxViewPage<dynamic>
	{
	}
}