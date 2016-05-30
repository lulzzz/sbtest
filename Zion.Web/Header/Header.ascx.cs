using System;
using System.Web.Mvc;

namespace HrMaxx.Web.Header
{
	public partial class Header : ViewUserControl
	{
		# region Page Load

		protected void Page_Load(object sender, EventArgs e)
		{
			//try
			//{
			//		lblUserName.Text = HttpContext.Current.User.Identity.Name;
			//		lblCurrentDate.Text = DateTime.Today.ToString("dd-MMM-yyyy");
			//		if (!IsPostBack)
			//		{
			//				string deployTest = "Test";

			//				CIDetailsMenuSet(deployTest);
			//				RadMenu1.Items[4].CssClass = "TemplateMenuItemSelected";

			//				//AccessLevels();
			//				//UserEventLog(PageModuleID);


			//		}


			//		//if (Request.QueryString[Constant.ID] != null)
			//		if (HttpContext.Current.Session["WorkID"] != null)
			//		{

			//				if (HttpContext.Current.Session["WorkID"].ToString() != "0")
			//				{
			//						RadMenu1.Items[9].Items[4].Enabled = true;
			//						RadMenu1.Items[9].Items[4].HoveredImageUrl = "../Images/PureImageMenuIcons/ModuleEventLog_Selected.png";
			//				}
			//				else
			//				{
			//						RadMenu1.Items[9].Items[4].Enabled = false;
			//						RadMenu1.Items[9].Items[4].HoveredImageUrl = "../Images/PureImageMenuIcons/ModuleEventLog.png";
			//				}

			//		}
			//		else
			//		{

			//				RadMenu1.Items[9].Items[4].Enabled = false;
			//				RadMenu1.Items[9].Items[4].HoveredImageUrl = "../Images/PureImageMenuIcons/ModuleEventLog.png";
			//		}


			//}
			//catch (Exception)
			//{
			//		//Utility.ShowErrorMessage(this.Page, exception.ToString());
			//}
		}

		protected void ddlCurrentState_SelectedIndexChanged(object sender, EventArgs e) //aa
		{
		}

		protected void lnkLogout_Click(object sender, EventArgs e)
		{
			//Session.Abandon();
			//if (HttpContext.Current.User.Identity.IsAuthenticated)
			//{

			//    WSFederationAuthenticationModule instance = FederatedAuthentication.WSFederationAuthenticationModule;

			//    instance.SignOut(false);

			//    SignOutRequestMessage request = new SignOutRequestMessage(new Uri(instance.Issuer), instance.Realm);

			//    Response.Redirect(request.WriteQueryString());


			//}

			//return RedirectToAction("Index", "Home");
			// Response.Redirect(NavigateURL.LOGIN, false);
		}

		#endregion

		#region Private Methods

		/// <summary>
		///   Highlighting the Menu Item based on URL
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void CIDetailsMenuSet(string deployTest = null)
		{
			//// at the moment the new CI Detail is just should be applied for FSD.Later it can be used for other work types as well
			////if ((deployTest != null && deployTest.Equals("Test")) && (Session[SessionItemKey.WORKTYPEID] != null && Session[SessionItemKey.WORKTYPEID].ToString()!=Constant.FSD))
			////{
			////    RadMenu1.Items[1].Visible = true;
			////    // NBN
			////    RadMenu1.Items[1].Items[0].Visible = true;
			////    // CarrierNetwork
			////    ////RadMenu1.Items[1].Items[1].Visible = true;

			////    // Ericsson
			////    ////RadMenu1.Items[1].Items[2].Visible = true;

			////    RadMenu1.Items[0].Visible = false;

			////    return;
			////}
			////// end of new CI Detail

			//if (Request.Url.AbsolutePath.Contains(Constant.MSTONES) || Request.Url.AbsolutePath.Contains(Constant.PC))
			//{
			//    RadMenu1.Items[1].Visible = true;
			//    // NBN
			//    RadMenu1.Items[1].Items[0].Visible = true;
			//    // Carrier Network
			//    ////RadMenu1.Items[1].Items[1].Visible = true;
			//    // Ericsson
			//    ////RadMenu1.Items[1].Items[2].Visible = true;

			//    RadMenu1.Items[0].Visible = false;

			//    return;
			//}

			//RadMenu1.Items[1].Visible = false;
			//RadMenu1.Items[0].Visible = true;
			//// for other work type at the moment the old version of left hand side menu is being used , until it confirm by business Manager (Usman , Azam)
			//if (Session[SessionItemKey.WORKTYPEID] != null && Session[SessionItemKey.WORKTYPEID].ToString().Equals(Constant.FSD))
			//{
			//    switch (Session[SessionItemKey.WORKTYPEID].ToString())
			//    {
			//        case Constant.LNDN:
			//            {
			//                // CEO
			//                RadMenu1.Items[0].Items[0].Visible = true;
			//                // BOQ
			//                RadMenu1.Items[0].Items[1].Visible = true;
			//                // Task
			//                RadMenu1.Items[0].Items[2].Visible = true;
			//                // Subby Locations
			//                RadMenu1.Items[0].Items[3].Visible = true;
			//                // Variation
			//                RadMenu1.Items[0].Items[4].Visible = true;

			//                // As-Built
			//                RadMenu1.Items[0].Items[5].Visible = true;
			//                // As-Built for As-Built 
			//                RadMenu1.Items[0].Items[5].Items[0].Visible = true;
			//                // PCP for As-Built
			//                RadMenu1.Items[0].Items[5].Items[1].Visible = true;
			//                // PC for As-Built
			//                RadMenu1.Items[0].Items[5].Items[2].Visible = true;


			//                //Mstones
			//                RadMenu1.Items[0].Items[6].Visible = true;
			//                // Mstones for Mstones
			//                RadMenu1.Items[0].Items[6].Items[0].Visible = true;
			//                // Status for Mtones
			//                RadMenu1.Items[0].Items[6].Items[1].Visible = true;

			//                // Status
			//                //RadMenu1.Items[0].Items[7].Visible = true;
			//                // PCP
			//                //RadMenu1.Items[0].Items[8].Visible = true;
			//                // PC
			//                //RadMenu1.Items[0].Items[9].Visible = true;


			//                break;
			//            }
			//        case Constant.BUILDDROP:
			//            {

			//                //foreach (RadMenuItem item in RadMenu1.Items[0].Items)
			//                //{
			//                //    item.Visible = false;
			//                //}
			//                // CEO
			//                RadMenu1.Items[0].Items[0].Visible = true;
			//                // BOQ
			//                RadMenu1.Items[0].Items[1].Visible = true;
			//                // Task
			//                RadMenu1.Items[0].Items[2].Visible = true;
			//                // Variation
			//                RadMenu1.Items[0].Items[4].Visible = true;
			//                //Mstones
			//                RadMenu1.Items[0].Items[6].Visible = true;

			//                // PCP
			//                RadMenu1.Items[0].Items[8].Visible = true;
			//                // PC
			//                RadMenu1.Items[0].Items[9].Visible = true;

			//                break;
			//            }
			//        case Constant.NEWDEV:
			//            {

			//                // CEO
			//                RadMenu1.Items[0].Items[0].Visible = true;
			//                // BOQ
			//                RadMenu1.Items[0].Items[1].Visible = true;
			//                // Task
			//                RadMenu1.Items[0].Items[2].Visible = true;
			//                // Subby Locations
			//                RadMenu1.Items[0].Items[3].Visible = true;
			//                // Variation
			//                RadMenu1.Items[0].Items[4].Visible = true;

			//                // As-Built
			//                RadMenu1.Items[0].Items[5].Visible = true;
			//                // As-Built for As-Built 
			//                RadMenu1.Items[0].Items[5].Items[0].Visible = true;
			//                // PCP for As-Built
			//                RadMenu1.Items[0].Items[5].Items[1].Visible = true;
			//                // PC for As-Built
			//                RadMenu1.Items[0].Items[5].Items[2].Visible = true;

			//                //Mstones
			//                RadMenu1.Items[0].Items[6].Visible = true;
			//                // Mstones for Mstones
			//                RadMenu1.Items[0].Items[6].Items[0].Visible = true;
			//                // Status for Mtones
			//                RadMenu1.Items[0].Items[6].Items[1].Visible = true;


			//                // Status
			//                //RadMenu1.Items[0].Items[7].Visible = true;
			//                // PCP
			//                //RadMenu1.Items[0].Items[8].Visible = true;
			//                // PC
			//                //RadMenu1.Items[0].Items[9].Visible = true;
			//                // DEP
			//                RadMenu1.Items[0].Items[10].Visible = true;

			//                break;

			//            }

			//        case Constant.FSD:
			//            {
			//                // Task
			//                //RadMenu1.Items[0].Items[2].Visible = true;

			//                RadMenu1.Items[3].Visible = true;
			//                RadMenu1.Items[2].Visible = false;

			//                //Mstones
			//                //RadMenu1.Items[0].Items[6].Visible = true;

			//                // PC - Practical Completion
			//                //RadMenu1.Items[0].Items[9].Visible = true;

			//                //foreach (RadMenuItem item in RadMenu1.Items[0].Items)
			//                //{
			//                //    item.Visible = false;
			//                //}


			//                break;

			//            }
			//        default:
			//            {
			//                break;
			//            }

			//    }

			//}
		}

		#endregion

		//public event SendWorkIDToThePageHandler sendWorkIDToThePage;

		//protected void RadMenu1_ItemClick(object sender, Telerik.Web.UI.RadMenuEventArgs e)
		//{
		//		string zUrl = ConfigurationManager.AppSettings["ZUrl"];
		//		switch (e.Item.Value)
		//		{

		//				case "LNDN":
		//						{
		//								Response.Redirect(zUrl + NavigateURL.WORKORDERDETAILS + "?WorkTypeID=1", false);
		//								break;
		//						}
		//				case "BuildDrop":
		//						{
		//								Response.Redirect(zUrl + NavigateURL.WORKORDERDETAILS + "?WorkTypeID=2", false);
		//								break;

		//						}
		//				case "FSD":
		//						{
		//								Response.Redirect(zUrl + NavigateURL.WORKORDERDETAILSFSD + "?WorkTypeID=3", false);
		//								break;

		//						}

		//				case "NewDev":
		//						{
		//								Response.Redirect(zUrl + NavigateURL.WORKORDERDETAILSNED + "?WorkTypeID=4", false);
		//								break;

		//						}

		//				case "Search":
		//				case "SearchWorkID":
		//				case "AdvanceSearch":
		//						{
		//								Response.Redirect(zUrl + NavigateURL.SEARCHWORKORDER, false);
		//								break;
		//						}

		//				case "QualityControl":
		//				case "QualityField":
		//						{
		//								Response.Redirect(zUrl + NavigateURL.QFICHOME, false);
		//								break;

		//						}


		//				case "NonConformance":
		//						{
		//								Response.Redirect(zUrl + NavigateURL.NCRSUMMARY, false);
		//								break;

		//						}

		//				case "AddRaiseDefect":
		//						{
		//								Response.Redirect(zUrl + "/NCQFIC/TaskAddNC.aspx", false);
		//								break;

		//						}

		//				case "Payments":
		//						{
		//								Response.Redirect(zUrl + NavigateURL.Invoice.INVOICESUMMARY, false);
		//								break;
		//						}
		//				case "POInvoice":
		//						{
		//								//Session["PaymentCurrentTab"] = null;
		//								Response.Redirect(zUrl + NavigateURL.Invoice.POINVOICESUMMARY, false);
		//								break;
		//						}
		//				case "NewInvoice":
		//						{
		//								//Session["PaymentCurrentTab"] = null;
		//								Response.Redirect(zUrl + NavigateURL.Invoice.INVOICESUMMARY, false);
		//								break;
		//						}


		//				case "ApprovedInvoice":
		//						{
		//								//Session["PaymentCurrentTab"] = null;
		//								Response.Redirect(zUrl + NavigateURL.Invoice.APPROVEDINVOICESUMMARY, false);
		//								break;

		//						}

		//				case "Retention":
		//						{
		//								//Session["PaymentCurrentTab"] = null;
		//								Response.Redirect(zUrl + "/Work/RetentionInvoiceSummary.aspx", false);
		//								break;

		//						}
		//				case "OracleInvoices":
		//						{
		//								//Session["PaymentCurrentTab"] = null;
		//								Response.Redirect(zUrl + "~/Work/OracleInvoiceSummary.aspx", false);
		//								break;

		//						}
		//				case "DisputedInvoice":
		//						{
		//								//Session["PaymentCurrentTab"] = null;
		//								Response.Redirect(zUrl + NavigateURL.Invoice.DISPUTEDINVOICESUMMARY, false);
		//								break;
		//						}

		//				case "ResolvedInvoice":
		//						{
		//								//Session["PaymentCurrentTab"] = null;
		//								Response.Redirect(zUrl + NavigateURL.Invoice.RESOLVEDINVOICESUMMARY, false);
		//								break;
		//						}

		//				case "Claims":
		//				case "SearchClaim":
		//				case "CreateClaim":
		//				case "Variations":
		//						{
		//								Response.Redirect(zUrl + "/Work/Claims.aspx", false);
		//								break;

		//						}

		//				case "Reports":
		//				case "ProjectReports":
		//						{
		//								Response.Redirect(zUrl + "/Work/Reports.aspx?reportType=1", false);
		//								break;
		//						}
		//				case "BusinessIntelligence":
		//						{
		//								Response.Redirect(zUrl + "/Work/ReportsBusinessIntelligence.aspx?reportType=2", false);
		//								break;
		//						}
		//				case "NonTaskForms":
		//						{
		//								//Response.Redirect("~/Work/Reports.aspx", false);
		//								Response.Redirect(zUrl + "/Work/NonTaskForms.aspx?reportType=3", false);
		//								break;

		//						}

		//				case "Maintenance":
		//						{
		//								Response.Redirect(zUrl + "/Maintenance/ProjectCode.aspx", false);
		//								break;

		//						}

		//				case "Security":
		//						{
		//								//Response.Redirect("~/Home/Dashboard.aspx", false);
		//								Response.Redirect(zUrl + "/MyAccount/ChangePassword.aspx", false);
		//								break;

		//						}

		//				case "AddUser":
		//						{
		//								Response.Redirect(zUrl + "/Security/UserSummary.aspx", false);
		//								break;

		//						}

		//				case "ChangePassword":
		//						{
		//								Response.Redirect(zUrl + "/MyAccount/ChangePassword.aspx", false);
		//								break;

		//						}

		//				case "VersionHistory":
		//						{
		//								Response.Redirect(zUrl + "/VersionHistory/VersionHistory.aspx", false);
		//								break;

		//						}


		//				case "UserEventLog":
		//						{
		//								Response.Redirect(zUrl + "/Security/UserEventLog.aspx", false);
		//								break;

		//						}

		//				case "ModuleEventLog":
		//						{
		//								Response.Redirect(zUrl + "/Work/EventLog.aspx", false);
		//								break;
		//						}

		//				case "Help":
		//				case "Help_LNDN":
		//				case "Help_BD":
		//				case "Help_NewDev":
		//				case "Help_FSD":
		//				case "Help_QFIC":
		//						{
		//								Response.Redirect(zUrl + "/Work/Help.aspx", false);
		//								break;

		//						}
		//				case "Help_NonTaskForm":
		//						{
		//								Response.Redirect(zUrl + "/Work/NonTaskForms.aspx", false);
		//								break;
		//						}

		//				case "CEO":
		//						{
		//								Response.Redirect(zUrl + "/Work/CED.aspx", false);
		//								break;
		//						}
		//				case "BOQ":
		//						{
		//								Response.Redirect(zUrl + "/Work/BOQ.aspx", false);
		//								break;
		//						}
		//				case "Task":
		//						{
		//								SetTaskURL();
		//								break;
		//						}
		//				case "CIDetails":
		//						{
		//								//SetCIDetailURL();
		//								break;
		//						}
		//				case "SubbyLocations":
		//						{
		//								Response.Redirect(zUrl + "/Work/SubbyLocations.aspx", false);
		//								break;
		//						}
		//				case "Variation":
		//						{
		//								Response.Redirect(zUrl + "/Work/Variation.aspx", false);
		//								break;
		//						}
		//				case "As-Built":
		//						{
		//								Response.Redirect(zUrl + "/Work/AsBuilt.aspx", false);
		//								break;
		//						}
		//				case "MStones":
		//						{
		//								Response.Redirect(zUrl + "/Work/MStones.aspx", false);
		//								break;
		//						}
		//				case "Status":
		//						{
		//								Response.Redirect(zUrl + "/Work/Milestones.aspx", false);
		//								break;
		//						}
		//				case "PCP":
		//						{
		//								Response.Redirect(zUrl + "/Work/PCP.aspx", false);
		//								break;
		//						}
		//				case "PC":
		//						{
		//								Response.Redirect(zUrl + "/Work/PC.aspx", false);
		//								break;
		//						}

		//				case "DEP":
		//						{
		//								Response.Redirect(zUrl + "/Work/Dependencies.aspx", false);
		//								break;
		//						}


		//		}

		//}
		//private void SetTaskURL()
		//{

		//		//if (Session[SessionItemKey.WORKTYPEID] != null && Session[SessionItemKey.WORKTYPEID].ToString() == "2")   //for build drop 
		//		//{
		//		//    //Response.Redirect("~/Work/WorkQuintiq.aspx");
		//		//    Response.Redirect(ConfigurationManager.AppSettings["ZUrl"] + NavigateURL.TASKBUILDDROPQUINTIQ);

		//		//}
		//		//else if (Session[SessionItemKey.WORKTYPEID] != null && Session[SessionItemKey.WORKTYPEID].ToString() == "3")   //for fsd 
		//		//{
		//		//    Response.Redirect(ConfigurationManager.AppSettings["ZUrl"] + NavigateURL.TASKFSDQUINTIQ);

		//		//}
		//		//if (Session[SessionItemKey.WORKTYPEID].ToString() == "1")   //for build drop 
		//		//{
		//		//    Response.Redirect("~/Work/WorkQuintiq.aspx");
		//		//    //Response.Redirect(NavigateURL.TASKBUILDDROP);

		//		//}
		//		//else
		//		//{
		//		//    Response.Redirect(ConfigurationManager.AppSettings["ZUrl"] + NavigateURL.TASKS, false);
		//		//}

		//}

		//private void SetCIDetailURL()
		//{

		//		//if (Session[SessionItemKey.WORKTYPEID] != null && Session[SessionItemKey.WORKTYPEID].ToString() == Constant.BUILDDROP)   //for build drop 
		//		//{
		//		//    if (HttpContext.Current.Session["WorkID"] != null)
		//		//    {
		//		//        Response.Redirect(NavigateURL.WORKORDERDETAILS + "?ID=" + HttpContext.Current.Session["WorkID"] + "&WorkTypeID=2", false);
		//		//    }
		//		//    else
		//		//        Response.Redirect(NavigateURL.WORKORDERDETAILS + "?WorkTypeID=2", false);

		//		//}
		//		//else if (Session[SessionItemKey.WORKTYPEID] != null && Session[SessionItemKey.WORKTYPEID].ToString() == Constant.FSD)   //for fsd 
		//		//{
		//		//    if (HttpContext.Current.Session["WorkID"] != null)
		//		//    {
		//		//        Response.Redirect(NavigateURL.WORKORDERDETAILSFSD + "?ID=" + HttpContext.Current.Session["WorkID"] + "&WorkTypeID=3", false);
		//		//    }
		//		//    else
		//		//    {
		//		//        Response.Redirect(NavigateURL.WORKORDERDETAILSFSD + "?WorkTypeID=3", false);
		//		//    }

		//		//}
		//		//else if (Session[SessionItemKey.WORKTYPEID] != null && Session[SessionItemKey.WORKTYPEID].ToString() == Constant.NEWDEV)   //for fsd 
		//		//{
		//		//    if (HttpContext.Current.Session["WorkID"] != null)
		//		//    {
		//		//        Response.Redirect(NavigateURL.WORKORDERDETAILSNED + "?ID=" + HttpContext.Current.Session["WorkID"] + "&WorkTypeID=4", false);
		//		//    }
		//		//    else
		//		//    {
		//		//        Response.Redirect(NavigateURL.WORKORDERDETAILSNED + "?WorkTypeID=4", false);
		//		//    }
		//		//}

		//		////if (Session[SessionItemKey.WORKTYPEID].ToString() == "1")   //for build drop 
		//		////{
		//		////    Response.Redirect("~/Work/WorkQuintiq.aspx");
		//		////    //Response.Redirect(NavigateURL.TASKBUILDDROP);

		//		////}
		//		//else
		//		//{
		//		//    if (HttpContext.Current.Session["WorkID"] != null)
		//		//    {
		//		//        Response.Redirect(NavigateURL.WORKORDERDETAILS + "?WorkTypeID=1", false);
		//		//    }
		//		//    else
		//		//    {
		//		//        Response.Redirect(NavigateURL.WORKORDERDETAILS + "?ID=" + HttpContext.Current.Session["WorkID"] + "&WorkTypeID=1", false);
		//		//    }
		//		//}

		//}

		//protected void txtNewSearch_TextChanged(object sender, EventArgs e)
		//{
		//		//TextBox txtNewSearch = (TextBox)((TextBox)sender).NamingContainer.FindControl("txtNewSearch");
		//		//if (txtNewSearch.Text != null)
		//		//{
		//		//    Session["WorkIDByHeaderMenu"] = txtNewSearch.Text;
		//		//    Response.Redirect(NavigateURL.SEARCHWORKORDER, false);
		//		//}


		//}
	}
}