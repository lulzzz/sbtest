using System;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;
using HrMaxx.Infrastructure.Security;
using HrMaxxAPI.Resources;

namespace HrMaxxAPI.Code.Filters
{
	public class ValidateModelAttribute : ActionFilterAttribute
	{
		public HrMaxxUser CurrentUser
		{
			get { return new HrMaxxUser(HttpContext.Current.User as ClaimsPrincipal); }
		}
		public override void OnActionExecuting(HttpActionContext actionContext)
		{
			if (actionContext.ModelState.IsValid == false)
			{
				actionContext.Response = actionContext.Request.CreateErrorResponse(
					HttpStatusCode.BadRequest, actionContext.ModelState);
			}
			if (actionContext.Request.Method == HttpMethod.Post)
			{
				if (actionContext.ActionArguments.All(arg => typeof (BaseRestResource).IsAssignableFrom(arg.Value.GetType())))
				{
					foreach (var arg in actionContext.ActionArguments)
					{
						var t = arg.Value as BaseRestResource;
						t.UserId = new Guid(CurrentUser.UserId);
						t.UserName = CurrentUser.FullName;
					}
				}
			}

		}
	}
}