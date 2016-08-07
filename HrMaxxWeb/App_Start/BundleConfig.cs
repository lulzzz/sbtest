using System.Web;
using System.Web.Optimization;
using BundleTransformer.Core.Builders;
using BundleTransformer.Core.Orderers;
using BundleTransformer.Core.Transformers;

namespace HrMaxxWeb
{
	public class BundleConfig
	{
		// For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
		public static void RegisterBundles(BundleCollection bundles)
		{
			var nullBuilder = new NullBuilder();
			var styleTransformer = new StyleTransformer();
			;
			var scriptTransformer = new ScriptTransformer();
			var nullOrderer = new NullOrderer();

			Bundle lessBundle = new Bundle("~/bundles/site-less").Include("~/Content/site.less");
			lessBundle.Transforms.Add(styleTransformer);
			lessBundle.Builder = nullBuilder;
			lessBundle.Orderer = nullOrderer;
			bundles.Add(lessBundle);

			Bundle html5 = new Bundle("~/bundles/html5").Include(
				"~/Scripts/html5shiv/html5shiv.js",
				"~/Scripts/respond/respond.js");
			html5.Builder = nullBuilder;
			html5.Builder = nullBuilder;
			html5.Transforms.Add(scriptTransformer);
			html5.Orderer = nullOrderer;
			bundles.Add(html5);

			Bundle jquery = new Bundle("~/bundles/bootstrapjquery").Include(
				"~/Scripts/jquery-2.1.1.js",
				"~/Scripts/jquery/jquery-{version}.min.map",
				"~/Scripts/jquery-ui.custom.js",
				"~/Scripts/jquery/jquery.cookie.min.js",
				"~/Scripts/jquery/jquery.ui.widget.min.js",
				"~/Scripts/lodash/lodash.js",
				"~/Scripts/es5-shim.js",
				"~/Scripts/modernizr-{version}.js",
				"~/Scripts/bootstrap/bootstrap.js",
				"~/Scripts/bootstrap3-typeahead.js",
				"~/Scripts/bootstrap/bootstrap-theme/coloradmin.min.js",
				"~/Scripts/bootstrap/bootstrap-theme/plugins/metisMenu/metisMenu.js",
				"~/Scripts/Toastr/toastr.min.js",
				"~/Scripts/bootstrap-switch.min.js",
				"~/Scripts/bootstrap/bootstrap-theme/plugins/wysiwyg/wysihtml5-0.3.0.min.js",
				"~/Scripts/bootstrap/bootstrap-theme/plugins/wysiwyg/bootstrap-wysihtml5-0.0.2.js",
				"~/Scripts/bootstrap/parsley.js",
				"~/Scripts/bootstrap/wizard/bwizard.js"

				
				);
			jquery.Builder = nullBuilder;
			jquery.Transforms.Add(scriptTransformer);
			jquery.Orderer = nullOrderer;
			bundles.Add(jquery);

			// SlimScroll
			bundles.Add(new ScriptBundle("~/bundles/slimScroll").Include(
				"~/Scripts/bootstrap/bootstrap-theme/plugins/slimscroll/jquery.slimscroll.min.js",
				"~/Scripts/bootstrap/bootstrap-theme/plugins/parsley/parsley.min.js"
				));


			// Inspinia skin config script
			bundles.Add(new ScriptBundle("~/bundles/skinConfig").Include(
				"~/Scripts/bootstrap/bootstrap-theme/skin.config.min.js"));

			Bundle angular = new Bundle("~/bundles/angular").Include(
				"~/Scripts/angular/angular-file-upload/angular-file-upload-shim.js",
				"~/Scripts/moment.js",
				"~/Scripts/angular/angular.min.js",
				"~/Scripts/angular/angular-animate.min.js",
				"~/Scripts/angular/angular-route.min.js",
				"~/Scripts/angular/angular-loader.min.js",
				"~/Scripts/angular/angular-ui/ui-bootstrap-custom-tpls-0.12.0.js",
				"~/Scripts/angular/angular-file-upload/angular-file-upload.js",
				"~/Scripts/angular/restangular/restangular.js",
				"~/Scripts/angular/angular-sanitize.min.js",
				"~/Scripts/angular/angular-ui-tree/angular-ui-tree.js",
				"~/Scripts/angular/angular-loading-bar/loading-bar.js",
				"~/Scripts/angular/angular-local-storage/angular-local-storage.min.js",
				"~/Scripts/angular/angular-google-maps.js",
				"~/Scripts/angular/ng-google-chart.js",
				"~/Scripts/angular/ng-table.js",
				"~/Scripts/angular/angular-bootstrap-datepicker/angular-bootstrap-datepicker.js",
				"~/Scripts/angular/multipleDatePicker.min.js",
				"~/Scripts/angular/xeditable.js",
				"~/Scripts/angular/xeditable.min.js",
				"~/Scripts/angular/angular-strap/angular-strap.js",
				"~/Scripts/angular/angular-strap/angular-strap.tpl.js",
				"~/Scripts/angularjs-dropdown-multiselect.min.js",
				"~/Scripts/angular/angular-scrollable-table.js",
				"~/Scripts/angular/mask.min.js",
				"~/Scripts/app/common/common.js",
				"~/Scripts/app/host/host-app.js",
				"~/Scripts/app/company/company-app.js",
				"~/Scripts/app/common/common-config.js",
				"~/Scripts/app/common/common-routing.js",
				"~/Scripts/app/common/common-repository.js",
				"~/Scripts/app/company/company-repository.js",
				"~/Scripts/app/host/host-repository.js",
				"~/Scripts/app/common/authInterceptorService.js",
				"~/Scripts/app/common/auth-svc.js",
				
				
				"~/Scripts/app/common/Notifications/notification.js",
				"~/Scripts/app/common/Notifications/notification-repository.js",
				"~/Scripts/app/common/Notifications/notification-ctrl.js",

				"~/Scripts/app/common/eventlogs/userEventLog.js",
				"~/Scripts/app/common/eventlogs/eventlog-repository.js",
				"~/Scripts/app/common/eventlogs/userEventLog-ctrl.js",
				"~/Scripts/app/common/login-ctrl.js",
				"~/Scripts/app/common/users/user-app.js",
				"~/Scripts/app/common/users/user-repository.js",
				"~/Scripts/app/common/directives/document-list.js",
				"~/Scripts/app/common/directives/address.js",
				"~/Scripts/app/common/directives/comment-list.js",
				"~/Scripts/app/common/directives/contact-list.js",
				"~/Scripts/app/common/directives/contact.js",
				"~/Scripts/app/Common/directives/news-list.js",
				"~/Scripts/app/common/directives/userprofile.js",
				
				
				"~/Scripts/app/host/directives/host-list.js",
				"~/Scripts/app/host/directives/host.js",
				"~/Scripts/app/host/controllers/hostlogo-ctrl.js",
				"~/Scripts/app/host/directives/homepage.js",
				"~/Scripts/app/host/directives/welcome.js",
				"~/Scripts/app/common/directives/usernews.js",
				"~/Scripts/app/common/directives/user-list.js",
				
				
				"~/Scripts/app/company/directives/deduction-list.js",
				"~/Scripts/app/company/directives/worker-compensation-list.js",
				"~/Scripts/app/company/directives/tax-year-rate-list.js",
				"~/Scripts/app/company/directives/accumulated-pay-type-list.js",
				"~/Scripts/app/company/directives/pay-code-list.js",
				"~/Scripts/app/company/directives/company-list.js",
				"~/Scripts/app/common/main-ctrl.js",
				"~/Scripts/app/company/directives/vendor-customer-list.js",
				"~/Scripts/app/company/directives/account-list.js",
				"~/Scripts/app/company/directives/employee-list.js",
				"~/Scripts/app/company/directives/employee-deduction-list.js"
				

				);
			jquery.Builder = nullBuilder;
			jquery.Transforms.Add(scriptTransformer);
			jquery.Orderer = nullOrderer;
			bundles.Add(angular);
		}
	}
}
