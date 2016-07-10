using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using HrMaxx.Infrastructure.Security;
using HrMaxxWeb.Controllers;

namespace HrMaxxWeb.Areas.Administration.Controllers
{
    public class HostController : BaseController
    {
        // GET: Administration/CPA
        public ActionResult Index()
        {
					if (!CurrentUser.IsInRole("Master"))
						return RedirectToAction("AccessDenied", "Home", new { area = "" });
          return View();
        }
    }
}