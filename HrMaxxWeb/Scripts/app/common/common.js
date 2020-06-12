var common = angular.module('common', ['ngAnimate', 'LocalStorageModule', 'ui.bootstrap', 'angular-loading-bar', 'mgcrea.ngStrap.popover', 'xeditable', 'ngTable', 'angularFileUpload', 'restangular', 'ui.mask', 'ngSanitize', 'angularjs-dropdown-multiselect', 'ngRoute', 'ngTagsInput', 'googlechart', 'ngResource']);

common.service('anchorSmoothScroll', function () {

	this.scrollTo = function (eID) {

		// This scrolling function 
		// is from http://www.itnewb.com/tutorial/Creating-the-Smooth-Scroll-Effect-with-JavaScript

		var startY = currentYPosition();
		var stopY = elmYPosition(eID);
		var distance = stopY > startY ? stopY - startY : startY - stopY;
		if (distance < 100) {
			scrollTo(0, stopY); return;
		}
		var speed = Math.round(distance / 100);
		if (speed >= 20) speed = 20;
		var step = Math.round(distance / 25);
		var leapY = stopY > startY ? startY + step : startY - step;
		var timer = 0;
		if (stopY > startY) {
			for (var i = startY; i < stopY; i += step) {
				setTimeout("window.scrollTo(0, " + leapY + ")", timer * speed);
				leapY += step; if (leapY > stopY) leapY = stopY; timer++;
			} return;
		}
		for (var i = startY; i > stopY; i -= step) {
			setTimeout("window.scrollTo(0, " + leapY + ")", timer * speed);
			leapY -= step; if (leapY < stopY) leapY = stopY; timer++;
		}

		function currentYPosition() {
			// Firefox, Chrome, Opera, Safari
			if (self.pageYOffset) return self.pageYOffset;
			// Internet Explorer 6 - standards mode
			if (document.documentElement && document.documentElement.scrollTop)
				return document.documentElement.scrollTop;
			// Internet Explorer 6, 7 and 8
			if (document.body.scrollTop) return document.body.scrollTop;
			return 0;
		}

		function elmYPosition(eID) {
           // var elm = document.getElementById(eID);
           var elm = angular.element(eID);
            var y = elm.getBoundingClientRect().top;
			var node = elm;
			while (node.offsetParent && node.offsetParent != document.body) {
				node = node.offsetParent;
				y += node.offsetTop;
			} return y;
		}

    };

    this.scrollToElement = function (e) {

        // This scrolling function 
        // is from http://www.itnewb.com/tutorial/Creating-the-Smooth-Scroll-Effect-with-JavaScript

        var startY = currentYPosition();
        var stopY = elmYPosition(e);
        var distance = stopY > startY ? stopY - startY : startY - stopY;
        if (distance < 100) {
            scrollTo(0, stopY); return;
        }
        var speed = Math.round(distance / 100);
        if (speed >= 20) speed = 20;
        var step = Math.round(distance / 25);
        var leapY = stopY > startY ? startY + step : startY - step;
        var timer = 0;
        if (stopY > startY) {
            for (var i = startY; i < stopY; i += step) {
                setTimeout("window.scrollTo(0, " + leapY + ")", timer * speed);
                leapY += step; if (leapY > stopY) leapY = stopY; timer++;
            } return;
        }
        for (var i = startY; i > stopY; i -= step) {
            setTimeout("window.scrollTo(0, " + leapY + ")", timer * speed);
            leapY -= step; if (leapY < stopY) leapY = stopY; timer++;
        }

        function currentYPosition() {
            // Firefox, Chrome, Opera, Safari
            if (self.pageYOffset) return self.pageYOffset;
            // Internet Explorer 6 - standards mode
            if (document.documentElement && document.documentElement.scrollTop)
                return document.documentElement.scrollTop;
            // Internet Explorer 6, 7 and 8
            if (document.body.scrollTop) return document.body.scrollTop;
            return 0;
        }

        function elmYPosition(elm) {
            // var elm = document.getElementById(eID);
            
            var y = elm.offsetTop - 80;
            var node = elm;
            while (node.offsetParent && node.offsetParent != document.body) {
                node = node.offsetParent;
                y += node.offsetTop;
            } return y;
        }

    };

});


common.constant('zionPaths', {
	Login: 'Account/Login',
	Logout: 'Account/LogOff',
	Token: 'token'
});
common.constant('version', '1.0.3.85.25');
common.constant('EntityTypes', {
	General:0,
	Host:1,
	Company:2,
	Employee:3,
	Contact:4,
	Address:5,
	COA:6,
	PayCheck:7,
	RegularCheck:8,
	EFT:9,
	Deposit:10,
	Invoice:11,
	User :12,
	Document: 13,
	Comment: 14,
	Vendor: 15,
	Customer: 16,
	HostHomePage: 17,
	Adjustment: 18,
	TaxPayment: 19,
	CustomerInvoice:23
});
common.constant('ClaimTypes', {
	ManageConfiguration: 'http://Paxol/ManageConfiguration',
	ManageProfitStars: 'http://Paxol/ProfitStars',
	DataExtracts : 'http://Paxol/DataExtracts',
	MiscExtracts : 'http://Paxol/MiscExtracts',
	ManageHost: 'http://Paxol/Host/Manage',
	HostContract: 'http://Paxol/Host/Contract',
	HostPEOFlag: 'http://Paxol/Host/PEOFlag',
	HostProfile: 'http://Paxol/Host/HostProfile',
	CompanyProfile: 'http://Paxol/Company/Profile',
	CompanyVersions: 'http://Paxol/Company/Versions',
	CompanyContract: 'http://Paxol/Company/Contract',
	CompanyPayrollDaysinPast: 'http://Paxol/Company/PayrollDaysinPast',
	CompanyAcumulatedPaytypesCompanyManaged: 'http://Paxol/Company/AcumulatedPaytypesCompanyManaged',
	CompanyAccumulatedPayTypesLumpSum: 'http://Paxol/Company/AccumulatedPayTypesLumpSum',
	CompanyCopy: 'http://Paxol/Company/Copy',
	CompanyCopyPayrolls: 'http://Paxol/Company/CopyPayrolls',
	CompanyDeductionDates: 'http://Paxol/Company/DeductionDates',
	EmployeeManageEmployees: 'http://Paxol/Employee/ManageEmployees',
	EmployeeBulkTerminate: 'http://Paxol/Employee/BulkTerminate',
	EmployeeSickLeaveExport: 'http://Paxol/Employee/SickLeaveExport',
	RecalculateSickLeave: 'http://Paxol/Employee/RecalculateSickLeave',
	EmployeeCopy: 'http://Paxol/Employee/Copy',
	EmployeeImportExport: 'http://Paxol/Employee/ImportExport',
	EmployeeVersions: 'http://Paxol/Employee/Versions',
	EmployeeEditableAccumulatatedPayTypes: 'http://Paxol/Employee/EditableAccumulatatedPayTypes',
	EmployeeProfile: 'http://Paxol/Employee/Profile',
	EmployeePayChecks: 'http://Paxol/Employee/PayChecks',
	EmployeeReports: 'http://Paxol/Employee/Reports',
	EmployeeDeductions: 'http://Paxol/Employee/Deductions',
	EmployeeDeductionDates: 'http://Paxol/Employee/DeductionDates',
	PayrollProcess: 'http://Paxol/Payroll/Process',
	PayrollConfirm: 'http://Paxol/Payroll/Confirm',
	PayrollVoid: 'http://Paxol/Payroll/Void',
	PayrollDelete: 'http://Paxol/Payroll/Delete',
	PayrollReProcessReConfirm: 'http://Paxol/Payroll/ReProcessReConfirm',
	PayrollVoidPayCheck: 'http://Paxol/Payroll/VoidPayCheck',
	PayrollUpdatePayCycleDates: 'http://Paxol/Payroll/UpdatePayCycleDates',
	PayrollChangeCheckNumberseries: 'http://Paxol/Payroll/ChangeCheckNumberseries',
	PayrollFixYTDs: 'http://Paxol/Payroll/FixYTDs',
	PayrollEditableTaxes: 'http://Paxol/Payroll/EditableTaxes',
	PayrollUnVoidCheck: 'http://Paxol/Payroll/UnVoidCheck',
	PayrollHistoryPayroll: 'http://Paxol/Payroll/HistoryPayroll',
	PayrollDelivery: 'http://Paxol/Payroll/Delivery',
	PayrollACHPackEmail: 'http://Paxol/Payroll/ACHPackEmail',
	PayrollAwaitingPrint: 'http://Paxol/Payroll/AwaitingPrint',
	PayrollSchedule: 'http://Paxol/Payroll/SchedulePayroll',
	InvoiceList: 'http://Paxol/Invoice/List',
	InvoiceCommissions: 'http://Paxol/Invoice/Commissions',
	InvoiceDelete: 'http://Paxol/Invoice/Delete',
	InvoiceVersions: 'http://Paxol/Invoice/Versions',
	InvoiceEditable: 'http://Paxol/Invoice/Editable',
	InvoicePayments: 'http://Paxol/Invoice/Payments',
	CheckbookManage: 'http://Paxol/Checkbook/Manage',
	COAManage: 'http://Paxol/COA/Manage',
	VendorsManage: 'http://Paxol/Vendors/Manage',
	CustomersManage: 'http://Paxol/Customers/Manage',
	ReportsManage: 'http://Paxol/Reports/Manage',
	ReportsCPAReport: 'http://Paxol/Reports/CPAReport',
	DashboardCompanyLists: 'http://Paxol/Dashboard/CompanyLists',
	DashboardAccountReceivable: 'http://Paxol/Dashboard/AccountReceivable',
	DashboardPerformance: 'http://Paxol/Dashboard/Performance'

});
common.constant('AccountType', {
	Assets: 1,
	Equity: 2,
	Expense: 3,
	Income: 4,
	Liability: 5
});
common.constant('Entities', [
	{
		entityTypeId: 13,
		name: 'Document',
		getList: 'Common/Documents'
	},
	{
		entityTypeId: 5,
		name: 'Address',
		getList: 'Common/Addresses',
		first: 'Common/FirstAddress'
	},
	{
		entityTypeId: 4,
		name: 'Contact',
		getList: 'Common/Contacts'
	},
	{
		entityTypeId: 14,
		name: 'Comment',
		getList: 'Common/Comments'
	}
]);

common.constant('Colors', {
	aqua: "#00ffff",
	black: "#000000",
	blue: "#3788d8",
	fuchsia: "#ff00ff",
	gray: "#808080",
	green: "#00acac",
	lime: "#00ff00",
	maroon: "#800000",
	navy: "#000080",
	olive: "#808000",
	purple: "#800080",
	red: "#ff0000",
	silver: "#c0c0c0",
	teal: "#008080",
	white: "#ffffff",
	yellow: "#ffff00",
	orange: "#f59c1a",
	transparent: [null, null, null, 0],
	_default: "#ffffff"
});
common.factory('commonServer', [
	'Restangular', 'zionAPI', function (Restangular, zionAPI) {

		return Restangular.withConfig(function (RestangularConfigurer) {

			RestangularConfigurer.setBaseUrl(zionAPI.URL);
			RestangularConfigurer.setRestangularFields({
				id: 'id'
			});
		});
	}
]);


common.run([
	'authService', function(authService) {
		authService.fillAuthData();
	}
]);

common.run(function (editableOptions) {
	editableOptions.theme = 'bs3';
});

common.config(setConfigPhaseSettings);


setConfigPhaseSettings.$inject = ["ngTableFilterConfigProvider"];

function setConfigPhaseSettings(ngTableFilterConfigProvider) {
	var filterAliasUrls = {
		"voids": "voids.html",
		
	};
	ngTableFilterConfigProvider.setConfig({
		aliasUrls: filterAliasUrls
	});

	// optionally set a default url to resolve alias names that have not been explicitly registered
	// if you don't set one, then 'ng-table/filters/' will be used by default
	ngTableFilterConfigProvider.setConfig({
		defaultBaseUrl: "ng-table/filters/"
	});

}

common.controller('documentModal', function ($scope, $modalInstance, doc, zionAPI) {
	$scope.modaldoc = doc;

	$scope.getDocumentUrl = function () {
		
		return zionAPI.URL + 'Document/' + $scope.modaldoc.documentId;
	};

});
common.filter('tel', function () {
	return function (tel) {
		if (!tel) { return ''; }

		var value = tel.toString().trim().replace(/^\+/, '');

		if (value.match(/[^0-9]/)) {
			return tel;
		}

		var country, city, number;

		switch (value.length) {
			case 10: // +1PPP####### -> C (PPP) ###-####
				country = 1;
				city = value.slice(0, 3);
				number = value.slice(3);
				break;

			case 11: // +CPPP####### -> CCC (PP) ###-####
				country = value[0];
				city = value.slice(1, 4);
				number = value.slice(4);
				break;

			case 12: // +CCCPP####### -> CCC (PP) ###-####
				country = value.slice(0, 3);
				city = value.slice(3, 5);
				number = value.slice(5);
				break;

			default:
				return tel;
		}

		if (country == 1) {
			country = "";
		}

		number = number.slice(0, 3) + '-' + number.slice(3);

		return (country + " (" + city + ") " + number).trim();
	};
});
common.filter('unique', function () {

	return function (items, filterOn) {

		if (filterOn === false) {
			return items;
		}

		if ((filterOn || angular.isUndefined(filterOn)) && angular.isArray(items)) {
			var hashCheck = {}, newItems = [];

			var extractValueToCompare = function (item) {
				if (angular.isObject(item) && angular.isString(filterOn)) {
					return item[filterOn];
				} else {
					return item;
				}
			};

			angular.forEach(items, function (item) {
				var valueToCheck, isDuplicate = false;

				for (var i = 0; i < newItems.length; i++) {
					if (angular.equals(newItems[i].title, extractValueToCompare(item))) {
						isDuplicate = true;
						break;
					}
				}
				if (!isDuplicate) {
					newItems.push({ title: extractValueToCompare(item), id: extractValueToCompare(item) });
				}

			});
			items = newItems;
		}
		return items;
	};
});
common.directive('fixedHeader', fixedHeader);

fixedHeader.$inject = ['$timeout'];

function fixedHeader($timeout) {
	return {
		restrict: 'A',
		link: link
	};

	function link($scope, $elem, $attrs, $ctrl) {
		var elem = $elem[0];

		// wait for data to load and then transform the table
		$scope.$watch(tableDataLoaded, function (isTableDataLoaded) {
			if (isTableDataLoaded) {
				transformTable();
			}
		});

		function tableDataLoaded() {
			// first cell in the tbody exists when data is loaded but doesn't have a width
			// until after the table is transformed
			var firstCell = elem.querySelector('tbody tr:first-child td:first-child');
			return firstCell && !firstCell.style.width;
		}

		function transformTable() {
			// reset display styles so column widths are correct when measured below
			angular.element(elem.querySelectorAll('thead, tbody, tfoot')).css('display', '');

			// wrap in $timeout to give table a chance to finish rendering
			$timeout(function () {
				// set widths of columns
				angular.forEach(elem.querySelectorAll('tr:first-child th'), function (thElem, i) {

					var tdElems = elem.querySelector('tbody tr:first-child td:nth-child(' + (i + 1) + ')');
					var tfElems = elem.querySelector('tfoot tr:first-child td:nth-child(' + (i + 1) + ')');

					var columnWidth = tdElems ? tdElems.offsetWidth : thElem.offsetWidth;
					if (tdElems) {
						tdElems.style.width = columnWidth + 'px';
					}
					if (thElem) {
						thElem.style.width = columnWidth + 'px';
					}
					if (tfElems) {
						tfElems.style.width = columnWidth + 'px';
					}
				});

				// set css styles on thead and tbody
				angular.element(elem.querySelectorAll('thead, tfoot')).css('display', 'block');

				angular.element(elem.querySelectorAll('tbody')).css({
					'display': 'block',
					'height': $attrs.tableHeight || 'inherit',
					'overflow': 'auto'
				});

				// reduce width of last column by width of scrollbar
				var tbody = elem.querySelector('tbody');
				var scrollBarWidth = tbody.offsetWidth - tbody.clientWidth;
				if (scrollBarWidth > 0) {
					// for some reason trimming the width by 2px lines everything up better
					scrollBarWidth -= 2;
					var lastColumn = elem.querySelector('tbody tr:first-child td:last-child');
					lastColumn.style.width = (lastColumn.offsetWidth - scrollBarWidth) + 'px';
				}
			});
		}
	}
}
