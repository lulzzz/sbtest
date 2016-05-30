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
				"~/Scripts/lodash/lodash.js",
				"~/Scripts/es5-shim.js",
				"~/Scripts/modernizr-{version}.js",
				"~/Scripts/bootstrap/bootstrap.js",
				"~/Scripts/bootstrap3-typeahead.js",
				"~/Scripts/bootstrap/bootstrap-theme/inspinia.min.js",
				"~/Scripts/bootstrap/bootstrap-theme/plugins/metisMenu/metisMenu.js",
				"~/Scripts/Toastr/toastr.min.js");
			jquery.Builder = nullBuilder;
			jquery.Transforms.Add(scriptTransformer);
			jquery.Orderer = nullOrderer;
			bundles.Add(jquery);

			// SlimScroll
			bundles.Add(new ScriptBundle("~/bundles/slimScroll").Include(
				"~/Scripts/bootstrap/bootstrap-theme/plugins/slimscroll/jquery.slimscroll.min.js"));

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
				"~/Scripts/app/common/common.js",
				"~/Scripts/app/common/common-config.js",
				"~/Scripts/app/common/common-repository.js",
				"~/Scripts/app/common/authInterceptorService.js",
				"~/Scripts/app/common/auth-svc.js",
				
				
				"~/Scripts/app/common/Notifications/notification.js",
				"~/Scripts/app/common/Notifications/notification-repository.js",
				"~/Scripts/app/common/Notifications/notification-ctrl.js",

				"~/Scripts/app/common/eventlogs/userEventLog.js",
				"~/Scripts/app/common/eventlogs/eventlog-repository.js",
				"~/Scripts/app/common/eventlogs/userEventLog-ctrl.js",
				"~/Scripts/app/common/login-ctrl.js"

				);
			jquery.Builder = nullBuilder;
			jquery.Transforms.Add(scriptTransformer);
			jquery.Orderer = nullOrderer;
			bundles.Add(angular);
		}
	}
}
