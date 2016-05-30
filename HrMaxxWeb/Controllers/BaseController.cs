using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Security.Claims;
using System.Text;
using System.Web.Mvc;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Security;
using HrMaxx.Infrastructure.Tracing;
using HrMaxx.Infrastructure.Validation;
using HrMaxxWeb.Code.ActionResult;
using log4net;
using MassTransit;
using StackExchange.Profiling;


namespace HrMaxxWeb.Controllers
{
	[Authorize]
	public class BaseController : Controller
	{
		private bool? _showDiagnosticErrors;
		public IBus Bus { get; set; }
		public ILog Logger { get; set; }
		protected MiniProfiler Profiler { get; set; }
		protected IMapper Mapper { get; set; }

		protected bool? ShowDiagnosticErrors
		{
			get
			{
				if (_showDiagnosticErrors.HasValue) return _showDiagnosticErrors;

				try
				{
					_showDiagnosticErrors = bool.Parse(ConfigurationManager.AppSettings["ShowDiagnosticErrors"]);
				}
				catch
				{
					_showDiagnosticErrors = false;
				}

				return _showDiagnosticErrors;
			}
		}

		public HrMaxxUser CurrentUser
		{
			get { return new HrMaxxUser(User as ClaimsPrincipal); }
		}

		protected override void OnActionExecuting(ActionExecutingContext filterContext)
		{
			HrMaxxTrace.TraceInformation("Controller Action: {0}", filterContext.ActionDescriptor.ActionName);
			Profiler = MiniProfiler.Current;

			base.OnActionExecuting(filterContext);
		}

		protected override void OnActionExecuted(ActionExecutedContext filterContext)
		{
			base.OnActionExecuted(filterContext);

			if (ModelState.IsValid == false && ModelState.Any(e => String.IsNullOrEmpty(e.Key)) == false)
			{
				ModelState.AddModelError(String.Empty, "Errors");
			}
		}

		protected void AddTempData(string key, object data)
		{
			if (TempData.ContainsKey(key)) TempData.Remove(key);
			TempData.Add(key, data);
		}

		protected void AddSessionData(string key, object data)
		{
			if (Session[key] != null) Session.Remove(key);
			Session.Add(key, data);
		}

		protected T GetSessionData<T>(string key)
		{
			if (Session[key] == null) return default(T);
			return (T) Session[key];
		}

		// ReSharper disable InconsistentNaming
		protected virtual ActionResult _View(string viewName, object model = null)
			// ReSharper restore InconsistentNaming
		{
			if (Request == null || Request.IsAjaxRequest() == false) return View(viewName, model);

			return PartialView(GetPartialViewName(viewName), model);
		}

		protected string GetPartialViewName(string viewName)
		{
			if (viewName.StartsWith("~"))
			{
				string last = viewName.Split('/').Last();
				string partialViewName = string.Format("P_{0}", last);

				return viewName.Replace(last, partialViewName);
			}

			return string.Format("P_{0}", viewName);
		}

		// ReSharper disable InconsistentNaming
		protected ActionResult _View()
			// ReSharper restore InconsistentNaming
		{
			return _View(GetActionName());
		}

		// ReSharper disable InconsistentNaming
		protected ActionResult _View(object model)
			// ReSharper restore InconsistentNaming
		{
			return _View(GetActionName(), model);
		}

		protected string GetActionName()
		{
			object actionName = ControllerContext.RouteData.Values["action"];

			return actionName.ToString();
		}

		protected void ProcessHrMaxxException(HrMaxxApplicationException exception)
		{
			ModelState.AddModelError(string.Empty, exception.Message);
			ShowDiagnosticErrorDetails(exception);
		}

		protected string GetExceptionMessage(Exception ex)
		{
			return CommonStringResources.ERROR_UnexpectedError +
			       ((ShowDiagnosticErrors.HasValue && ShowDiagnosticErrors.Value)
				       ? String.Format("Details: {0}", ex)
				       : "");
		}

		protected string GetExceptionMessage(HrMaxxApplicationException ex)
		{
			return CommonStringResources.ERROR_UnexpectedError +
			       ((ShowDiagnosticErrors.HasValue && ShowDiagnosticErrors.Value)
				       ? String.Format("Details: {0}", ex)
				       : "");
		}

		protected void ProcessUnexpectedException(Exception exception)
		{
			ModelState.AddModelError(string.Empty, CommonStringResources.ERROR_UnexpectedError);
			ShowDiagnosticErrorDetails(exception);
			Logger.Error(CommonStringResources.ERROR_UnhandledErrorReturnedToController, exception);
		}

		private void ShowDiagnosticErrorDetails(Exception exception)
		{
			if (ShowDiagnosticErrors.HasValue && ShowDiagnosticErrors.Value)
				ModelState.AddModelError(string.Empty, String.Format("Details: {0}", exception));
		}

		protected void ProcessBusFault<T>(Fault<T> fault) where T : class
		{
			foreach (string error in fault.Messages)
			{
				ModelState.AddModelError(string.Empty, error);
			}
		}

		protected void ProcessBusTimeout<T>(T message)
		{
			ModelState.AddModelError(string.Empty, "A timeout occurred");

			throw new HrMaxxApplicationException();
		}

		protected ActionResult ProcessCommandFailure(Exception ex, string viewName, object model)
		{
			ProcessValidationException(ex);

			ModelState.AddModelError(string.Empty, ex.Message);

			return View(viewName, model);
		}

		private void ProcessValidationException(Exception exception)
		{
			if (exception is ValidationException == false) return;

			var validationException = exception as ValidationException;

			foreach (string validationError in validationException.ValidationErrors)
				ModelState.AddModelError(string.Empty, validationError);
		}

		// ReSharper disable InconsistentNaming
		protected ActionResult _RedirectToAction(string actionName, string controllerName = null)
			// ReSharper restore InconsistentNaming
		{
			if (Request.IsAjaxRequest()) return Json(new {redirectUrl = Url.Action(actionName, controllerName, null)});

			return RedirectToAction(actionName);
		}

		protected void ProcessException(Exception exception)
		{
			if (exception is HrMaxxApplicationException) ProcessHrMaxxException(exception as HrMaxxApplicationException);
			else ProcessUnexpectedException(exception);
		}

		protected JsonNetResult ProcessJsonExceptionMessages(params string[] errors)
		{
			Response.StatusCode = (int) HttpStatusCode.InternalServerError;
			Response.TrySkipIisCustomErrors = true;

			return Json(new {success = false, message = errors}, JsonRequestBehavior.AllowGet);
		}

		protected JsonNetResult JsonSuccess(string successMessage)
		{
			return Json(new {successMessage, success = true});
		}

		protected JsonNetResult JsonException(Exception exception, object payload = null)
		{
			Response.StatusCode = (int) HttpStatusCode.InternalServerError;
			Response.TrySkipIisCustomErrors = true;

			List<string> errors;

			if (exception is HrMaxxApplicationException)
			{
				var lappsException = (HrMaxxApplicationException) exception;
				errors = lappsException.Errors;
			}
			else
			{
				Logger.Error(CommonStringResources.ERROR_UnhandledErrorReturnedToController, exception);
				errors = new List<string> {CommonStringResources.ERROR_UnexpectedError};
			}

			var sb = new StringBuilder();
			errors.ForEach(error => sb.AppendLine(error));
			HrMaxxTrace.TraceError("Errors: {0}", sb.ToString());

			return AjaxJson(false, errors, payload);
		}

		protected JsonNetResult ReturnModelStateErrorsAsJson()
		{
			Response.StatusCode = (int) HttpStatusCode.BadRequest;
			Response.TrySkipIisCustomErrors = true;

			List<string> errorList = ModelState.Values.SelectMany(m => m.Errors)
				.Select(e => e.ErrorMessage)
				.ToList();

			var sb = new StringBuilder();
			errorList.ForEach(error => sb.AppendLine(error));
			HrMaxxTrace.TraceError("Errors: {0}", sb.ToString());

			return Json(new {success = false, message = errorList});
		}

		protected bool IsJsonRequest()
		{
			return Request.ContentType.Split(';').Any(t => t.Equals("application/json", StringComparison.OrdinalIgnoreCase));
		}

		protected JsonNetResult AjaxJson(bool success, string message, object payload = null)
		{
			return Json(new
			{
				success,
				message,
				payload
			}, JsonRequestBehavior.AllowGet);
		}

		protected JsonNetResult AjaxJson(bool success, IEnumerable<string> messages, object payload = null)
		{
			return Json(new
			{
				success,
				message = messages,
				payload
			}, JsonRequestBehavior.AllowGet);
		}

		protected new JsonNetResult Json(object data, JsonRequestBehavior requestBehaviour = JsonRequestBehavior.AllowGet)
		{
			return new JsonNetResult {Data = data, JsonRequestBehavior = requestBehaviour};
		}
	}
}