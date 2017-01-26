using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Web.Http;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Security;
using HrMaxx.Infrastructure.Tracing;
using HrMaxxAPI.Code.Filters;
using log4net;

namespace HrMaxxAPI.Controllers
{
	[Authorize]
	public class BaseApiController : ApiController
	{
		public IMapper Mapper { get; set; }
		public ILog Logger { get; set; }
		public IBus Bus { get; set; }

		public HrMaxxUser CurrentUser
		{
			get { return new HrMaxxUser(User as ClaimsPrincipal); }
		}

		protected void AccessDenied()
		{
			throw new HttpResponseException(new HttpResponseMessage
			{
				StatusCode = HttpStatusCode.Forbidden,
				ReasonPhrase = "Access Denied"
			});
		}

		/// This function exists so that the noise of catching and handling exceptions is not present in every RESTful operation.
		protected T MakeServiceCall<T>(Func<T> callToMake, string traceMessage = "", bool handleNullAsNotFound = false)
			where T : class
		{
			T result = null;
			if (Request.Headers.Authorization != null)
			{
				if (!CurrentUser.HasClaim(HrMaxxClaimTypes.Version, ConfigurationManager.AppSettings["TokenVersion"]))
				{
					Claim tokenVersion = CurrentUser.Claims.FirstOrDefault(c => c.Type == HrMaxxClaimTypes.Version);
					string tokenVersionstr = "No Token Vesion";
					if (tokenVersion != null)
						tokenVersionstr = tokenVersion.Value;
					HrMaxxTrace.LogRequest(PerfTraceType.BusinessLayerCall, GetType(), traceMessage,
						(CurrentUser == null || !CurrentUser.Claims.Any()) ? string.Empty : CurrentUser.FullName,
						"Invalid token version" + tokenVersionstr);
					throw new HttpResponseException(new HttpResponseMessage
					{
						StatusCode = HttpStatusCode.Unauthorized
					});
				}
			}

			if (Request.Headers != null && Request.Headers.UserAgent != null &&
			    Request.Headers.UserAgent.Any(s => s.Product != null && s.Product.Name == "Z"))
			{
				ProductInfoHeaderValue product = Request.Headers.UserAgent.First(s => s.Product.Name == "Z");
				string[] appVersion = ConfigurationManager.AppSettings["AppVersion"].Split(',');
				if (product != null && !appVersion.Contains(product.Product.Version))
				{
					HrMaxxTrace.LogRequest(PerfTraceType.BusinessLayerCall, GetType(), traceMessage,
						(CurrentUser == null || !CurrentUser.Claims.Any()) ? string.Empty : CurrentUser.FullName, product.Product.Version,
						"Invalid app version" + product.Product.Version);
					throw new HttpResponseException(new HttpResponseMessage
					{
						StatusCode = HttpStatusCode.BadRequest,
						ReasonPhrase = "Please update your app/iOS version"
					});
				}
			}
			try
			{
				//HrMaxxTrace.LogRequest(PerfTraceType.BusinessLayerCall, GetType(), traceMessage,
				//	(CurrentUser == null || !CurrentUser.Claims.Any()) ? string.Empty : CurrentUser.FullName, Request.Headers.Host,
				//	(Request.Headers.Referrer == null || string.IsNullOrWhiteSpace(Request.Headers.Referrer.AbsoluteUri))
				//		? "Mobile"
				//		: Request.Headers.Referrer.AbsoluteUri);
				if (!traceMessage.Equals(string.Empty))
					HrMaxxTrace.PerfTrace(() => result = callToMake(), PerfTraceType.BusinessLayerCall, GetType(), traceMessage);

				else
					result = callToMake();
			}
			catch (Exception e)
			{
				HrMaxxTrace.LogRequest(PerfTraceType.BusinessLayerCall, GetType(), traceMessage,
					(CurrentUser == null || !CurrentUser.Claims.Any()) ? string.Empty : CurrentUser.FullName,
					Request.Headers.UserAgent.ToString());
				Logger.Error(!traceMessage.Equals(string.Empty) ? traceMessage : "Make Business Layer Call", e);

				throw new HttpResponseException(new HttpResponseMessage
				{
					StatusCode = HttpStatusCode.InternalServerError,
					ReasonPhrase = e.Message
				});
			}

			if (handleNullAsNotFound && result == null)
			{
				throw new HttpResponseException(new HttpResponseMessage
				{
					StatusCode = HttpStatusCode.NotFound,
					ReasonPhrase = CommonStringResources.ERROR_No_Resource_Found
				});
			}

			return result;
		}

		/// This function exists so that the noise of catching and handling exceptions is not present in every RESTful operation.
		protected IHttpActionResult MakeServiceCall(Action callToMake, string traceMessage = "")
		{
			if (Request.Headers.Authorization != null)
			{
				if (!CurrentUser.HasClaim(HrMaxxClaimTypes.Version, ConfigurationManager.AppSettings["TokenVersion"]))
				{
					Claim tokenVersion = CurrentUser.Claims.FirstOrDefault(c => c.Type == HrMaxxClaimTypes.Version);
					string tokenVersionstr = "No Token Vesion";
					if (tokenVersion != null)
						tokenVersionstr = tokenVersion.Value;
					HrMaxxTrace.LogRequest(PerfTraceType.BusinessLayerCall, GetType(), traceMessage,
						(CurrentUser == null || !CurrentUser.Claims.Any()) ? string.Empty : CurrentUser.FullName,
						"Invalid token version" + tokenVersionstr);
					throw new HttpResponseException(new HttpResponseMessage
					{
						StatusCode = HttpStatusCode.Unauthorized
					});
				}
			}
			if (Request.Headers != null && Request.Headers.UserAgent != null &&
			    Request.Headers.UserAgent.Any(s => s.Product != null && s.Product.Name == "Z"))
			{
				ProductInfoHeaderValue product = Request.Headers.UserAgent.First(s => s.Product.Name == "Z");
				string[] appVersion = ConfigurationManager.AppSettings["AppVersion"].Split(',');
				if (product != null && !appVersion.Contains(product.Product.Version))
				{
					HrMaxxTrace.LogRequest(PerfTraceType.BusinessLayerCall, GetType(), traceMessage,
						(CurrentUser == null || !CurrentUser.Claims.Any()) ? string.Empty : CurrentUser.FullName, product.Product.Version,
						"Invalid app version");
					throw new HttpResponseException(new HttpResponseMessage
					{
						StatusCode = HttpStatusCode.BadRequest,
						ReasonPhrase = "Please update your app/iOS version"
					});
				}
			}
			try
			{
				//HrMaxxTrace.LogRequest(PerfTraceType.BusinessLayerCall, GetType(), traceMessage,
				//	(CurrentUser == null || !CurrentUser.Claims.Any()) ? string.Empty : CurrentUser.FullName, Request.Headers.Host,
				//	(Request.Headers.Referrer == null || string.IsNullOrWhiteSpace(Request.Headers.Referrer.AbsoluteUri))
				//		? "Mobile"
				//		: Request.Headers.Referrer.AbsoluteUri);
				if (!traceMessage.Equals(string.Empty))
					HrMaxxTrace.PerfTrace(callToMake, PerfTraceType.BusinessLayerCall, GetType(), traceMessage);
				else
					callToMake();

				return Ok();
			}
			catch (Exception e)
			{
				HrMaxxTrace.LogRequest(PerfTraceType.BusinessLayerCall, GetType(), traceMessage,
					(CurrentUser == null || !CurrentUser.Claims.Any()) ? string.Empty : CurrentUser.FullName,
					Request.Headers.UserAgent.ToString());
				Logger.Error(!traceMessage.Equals(string.Empty) ? traceMessage : "Make Business Layer Call", e);

				throw new HttpResponseException(new HttpResponseMessage
				{
					StatusCode = HttpStatusCode.InternalServerError,
					ReasonPhrase = e.Message
				});
			}
		}

		protected List<Claim> GetUserClaimsByType(string claimType)
		{
			return ((ClaimsPrincipal) User).FindAll(claimType).ToList();
		}
	}
}