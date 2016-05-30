using System;
using System.Web.Mvc;

namespace HrMaxx.Web.Code.Helpers
{
	public static class HtmlHelpers
	{
		public static string IsSelected(this HtmlHelper html, string controller = null, string action = null)
		{
			string cssClass = "active";
			var currentAction = (string) html.ViewContext.RouteData.Values["action"];
			var currentController = (string) html.ViewContext.RouteData.Values["controller"];

			if (String.IsNullOrEmpty(controller))
				controller = currentController;

			if (String.IsNullOrEmpty(action))
				action = currentAction;

			return controller == currentController && action == currentAction
				? cssClass
				: String.Empty;
		}

		public static string PageClass(this HtmlHelper html)
		{
			var currentAction = (string) html.ViewContext.RouteData.Values["action"];
			return currentAction;
		}
	}
}