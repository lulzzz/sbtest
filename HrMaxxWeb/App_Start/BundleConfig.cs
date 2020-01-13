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
				"~/Scripts/bootstrap/bootstrap-theme/plugins/wysiwyg/wysihtml5-0.3.0.min.js",
				"~/Scripts/bootstrap/bootstrap-theme/plugins/wysiwyg/bootstrap-wysihtml5-0.0.2.js",
                "~/Scripts/bootstrap/parsley.js",
				"~/Scripts/bootstrap/wizard/bwizard.js",
				"~/Scripts/jquery.plugin.js",
				"~/Scripts/jquery.countdown.js",
				"~/Scripts/coming-soon.demo.js"


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
			//bundles.Add(new ScriptBundle("~/bundles/skinConfig").Include(
			//	"~/Scripts/bootstrap/bootstrap-theme/skin.config.min.js"));

			Bundle angular = new Bundle("~/bundles/angular").Include(
				"~/Scripts/angular1.5/angular-file-upload/angular-file-upload-shim.js",
				"~/Scripts/moment.js",
				"~/Scripts/flot/jquery.flot.min.js",
				"~/Scripts/flot/jquery.flot.time.min.js",
				"~/Scripts/flot/jquery.flot.pie.min.js",
				"~/Scripts/flot/jquery.flot.resize.min.js",
				"~/Scripts/flot/morris.min.js",
				"~/Scripts/flot/raphael.min.js",
				"~/Scripts/jstree.min.js",
				"~/Scripts/sparkline/jquery.sparkline.min.js",
				"~/Scripts/angular1.5/angular.min.js",
				"~/Scripts/angular1.5/i18n/angular-locale_en-us.js",
				"~/Scripts/angular1.5/angular-animate.min.js",
				"~/Scripts/angular1.5/angular-route.min.js",
				"~/Scripts/angular1.5/angular-resource.min.js",
				"~/Scripts/angular1.5/angular-loader.min.js",
				"~/Scripts/angular1.5/angular-ui/ui-bootstrap-tpls-2.1.3.min.js",
				"~/Scripts/angular1.5/angular-file-upload/angular-file-upload.js",
				"~/Scripts/angular1.5/restangular/restangular.js",
				"~/Scripts/angular1.5/angular-sanitize.min.js",
				"~/Scripts/angular1.5/angular-ui-tree/angular-ui-tree.js",
				"~/Scripts/angular1.5/angular-loading-bar/loading-bar.js",
				
				"~/Scripts/angular1.5/angular-local-storage/angular-local-storage.min.js",
				"~/Scripts/angular1.5/angular-google-maps.js",
				"~/Scripts/angular1.5/ng-google-chart.js",
				"~/Scripts/ng-table.js",
				"~/Scripts/angular1.5/angular-bootstrap-datepicker/angular-bootstrap-datepicker.js",
				"~/Scripts/angular1.5/multipleDatePicker.min.js",
				"~/Scripts/angular1.5/xeditable.js",
				"~/Scripts/angular1.5/xeditable.min.js",
				"~/Scripts/angular1.5/angular-strap/angular-strap.js",
				"~/Scripts/angular1.5/angular-strap/angular-strap.tpl.js",
				"~/Scripts/angularjs-dropdown-multiselect.min.js",
				"~/Scripts/angular1.5/angular-scrollable-table.js",
				"~/Scripts/angular1.5/mask.min.js",
				"~/Scripts/angular1.5/ng-tags-input.js",
				
				"~/Scripts/app/common/common.js",
				"~/Scripts/app/common/directives/date-ctrl.js",
				"~/Scripts/app/host/host-app.js",
				"~/Scripts/app/company/company-app.js",
				"~/Scripts/app/payroll/payroll-app.js",
				"~/Scripts/app/journal/journal-app.js",
				"~/Scripts/app/common/common-config.js",
				"~/Scripts/app/common/common-routing.js",
				"~/Scripts/app/common/common-repository.js",
				"~/Scripts/app/company/company-repository.js",
				"~/Scripts/app/payroll/payroll-repository.js",
				"~/Scripts/app/journal/journal-repository.js",
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
				"~/Scripts/app/common/directives/report-filter.js",
				"~/Scripts/app/common/directives/memento-list.js",
				"~/Scripts/app/common/directives/log-viewer.js",

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
				"~/Scripts/app/company/directives/company-locations.js",
				"~/Scripts/app/company/directives/company-list.js",
				"~/Scripts/app/company/directives/company.js",
				"~/Scripts/app/common/main-ctrl.js",
				"~/Scripts/app/company/directives/vendor-customer-list.js",
				"~/Scripts/app/company/directives/vendor-customer.js",
				"~/Scripts/app/company/directives/account-list.js",
				"~/Scripts/app/company/directives/employee-list.js",
				"~/Scripts/app/company/directives/employee.js",
				"~/Scripts/app/company/directives/employee-deduction-list.js",

				"~/Scripts/app/payroll/directives/payroll-list.js", 
				"~/Scripts/app/payroll/directives/payroll.js",
				"~/Scripts/app/payroll/directives/payroll-processed.js",
				"~/Scripts/app/payroll/directives/paycheck.js",
				"~/Scripts/app/journal/directives/regular-check.js",
				"~/Scripts/app/journal/directives/deposit-ticket.js",
				"~/Scripts/app/journal/directives/account-adjustment.js",
				"~/Scripts/app/journal/directives/tax-payment.js",
				"~/Scripts/app/journal/directives/journal-list.js",
				"~/Scripts/app/payroll/directives/invoice-list.js", 
				"~/Scripts/app/payroll/directives/invoice.js",
				"~/Scripts/app/reports/report-app.js",
				"~/Scripts/app/reports/report-repository.js",
				"~/Scripts/app/reports/directives/payroll-register.js",
				"~/Scripts/app/reports/directives/payroll-summary.js",
				"~/Scripts/app/reports/directives/deduction-report.js",
				"~/Scripts/app/reports/directives/worker-compensation-report.js",
				"~/Scripts/app/reports/directives/income-statement.js",
				"~/Scripts/app/reports/directives/balance-sheet.js",
				"~/Scripts/app/reports/directives/govt-forms.js",
				"~/Scripts/app/reports/directives/other-forms.js",
				"~/Scripts/app/reports/directives/employer-forms.js",
				"~/Scripts/app/reports/directives/deposit-coupons.js",
				"~/Scripts/app/reports/directives/blank-forms.js",
				"~/Scripts/app/payroll/directives/payroll-invoice-list.js",
				"~/Scripts/app/payroll/directives/invoice-delivery-list.js",
				"~/Scripts/app/payroll/directives/payroll-invoice.js",
				"~/Scripts/app/common/directives/config.js", 
				"~/Scripts/app/reports/directives/user-dashboard.js",
				"~/Scripts/app/reports/directives/staff-dashboard.js",
				"~/Scripts/app/reports/directives/company-dashboard.js",
				"~/Scripts/app/reports/directives/employee-dashboard.js",
				"~/Scripts/app/reports/directives/extract-dashboard.js",
				"~/Scripts/app/reports/directives/data-extracts.js",
				"~/Scripts/app/reports/directives/extract-view.js",
				"~/Scripts/app/reports/directives/news-ticker.js",
				"~/Scripts/app/reports/directives/extract-view-list.js",
				"~/Scripts/app/common/directives/insurance-group-list.js",
                "~/Scripts/app/common/directives/pay-type-list.js",
                "~/Scripts/app/common/directives/company-tax-rates.js",
				"~/Scripts/app/common/directives/tax-rates.js",
				"~/Scripts/app/common/search-ctrl.js",
				"~/Scripts/app/payroll/directives/awaiting-print-payrolls.js",
				"~/Scripts/app/payroll/directives/paycheck-list.js",
				"~/Scripts/app/reports/directives/ach-report.js",
				"~/Scripts/app/reports/directives/profit-stars-report.js",
				"~/Scripts/app/reports/directives/commissions-view.js",
				"~/Scripts/app/reports/directives/cpa-report.js"

				

				);
			jquery.Builder = nullBuilder;
			jquery.Transforms.Add(scriptTransformer);
			jquery.Orderer = nullOrderer;
			bundles.Add(angular);
		}
	}
}
