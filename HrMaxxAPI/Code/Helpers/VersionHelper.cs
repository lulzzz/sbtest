using System.Reflection;
using System.Web;
using HrMaxx.Infrastructure;

namespace HrMaxxAPI.Code.Helpers
{
	public static class VersionHelper
	{
		private static string _versionInfo;

		public static HtmlString GetVersionInformation()
		{
			if (!string.IsNullOrEmpty(_versionInfo))
			{
				return new HtmlString(_versionInfo);
			}
			Assembly assembly = Assembly.Load("HrMaxx.Infrastructure");
			var helper = new AssemblyInfoHelper(assembly);
			_versionInfo = string.Format("{0}  |  Version {1}  |  {2}", helper.Product, helper.ProductVersion, helper.Copyright);

			return new HtmlString(_versionInfo);
		}
	}
}