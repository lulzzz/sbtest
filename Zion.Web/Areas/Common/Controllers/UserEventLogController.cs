using System.Web.Mvc;
using HrMaxx.Web.Controllers;

namespace HrMaxx.Web.Areas.Common.Controllers
{
	public class UserEventLogController : BaseController
	{
		public ActionResult Index()
		{
			return View();
		}
	}
}