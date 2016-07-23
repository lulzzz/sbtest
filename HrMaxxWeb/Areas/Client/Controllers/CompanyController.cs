using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using HrMaxxWeb.Controllers;

namespace HrMaxxWeb.Areas.Client.Controllers
{
    public class CompanyController : BaseController
    {
        // GET: Client/Company
        public ActionResult Index()
        {
            return View();
        }
    }
}