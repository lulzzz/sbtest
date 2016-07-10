using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace HrMaxxWeb.Areas.Administration.Controllers
{
    public class NewsController : Controller
    {
        // GET: Administration/News
        public ActionResult Index()
        {
            return View();
        }
    }
}