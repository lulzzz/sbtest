common.factory('myHttpInterceptor', ['$q', '$rootScope', function ($q, $rootScope) {
	var xhrCreations = 0;
	var xhrResolutions = 0;

	function isLoading() {
		return xhrResolutions < xhrCreations;
	}

	function updateStatus() {
		$rootScope.loading = isLoading();
	}

	return {
		request: function (config) {
			xhrCreations++;
			updateStatus();
			return config;
		},
		requestError: function (rejection) {
			xhrResolutions++;
			updateStatus();
			//$log.error('Request error:', rejection);
			return $q.reject(rejection);
		},
		response: function (response) {
			xhrResolutions++;
			updateStatus();
			return response;
		},
		responseError: function (rejection) {
			xhrResolutions++;
			updateStatus();
			//$log.error('Response error:', rejection);
			return $q.reject(rejection);
		}
	};
}]);
common.config(['$httpProvider', '$routeProvider', '$locationProvider', 'zionAPI', function ($httpProvider, $routeProvider, $locationProvider, zionAPI) {
	$httpProvider.interceptors.push('authInterceptorService');
	$httpProvider.interceptors.push('myHttpInterceptor');
	
	$routeProvider.when('/', {
		templateUrl: zionAPI.Web + '/Areas/Reports/templates/Dashboard.html'
	});
	$routeProvider.when('/welcome', {
		templateUrl: zionAPI.Web + '/Areas/Administration/templates/welcome.html'
	});
	$routeProvider.when('/Admin/HostList', {
		templateUrl: zionAPI.Web + '/Areas/Administration/templates/HostList.html'
	});
	$routeProvider.when('/Admin/Invoices', {
		templateUrl: zionAPI.Web + '/Areas/Administration/templates/InvoiceList.html'
	});
	$routeProvider.when('/Admin/Config', {
		templateUrl: zionAPI.Web + '/Areas/Administration/templates/Configurations.html'
	});
	$routeProvider.when('/Admin/Host', {
		templateUrl: zionAPI.Web + '/Areas/Administration/templates/hostprofile.html'
	});
	$routeProvider.when('/Admin/NewsList', {
		templateUrl: zionAPI.Web + '/Areas/Administration/templates/news-list.html'
	});
	$routeProvider.when('/Admin/UserList', {
		templateUrl: zionAPI.Web + '/Areas/Administration/templates/user-list.html'
	});
	$routeProvider.when('/Client/Company/:time', {
		templateUrl: zionAPI.Web + '/Areas/Client/templates/companies.html'
	});
	$routeProvider.when('/My/News', {
		templateUrl: zionAPI.Web + '/Content/templates/mynews.html'
	});
	$routeProvider.when('/My/Profile', {
		templateUrl: zionAPI.Web + '/Content/templates/myprofile.html'
	});
	$routeProvider.when('/Client/Vendors', {
		templateUrl: zionAPI.Web + '/Areas/Client/templates/vendors.html'
	});
	$routeProvider.when('/Client/Customers', {
		templateUrl: zionAPI.Web + '/Areas/Client/templates/customers.html'
	});
	$routeProvider.when('/Client/Accounts', {
		templateUrl: zionAPI.Web + '/Areas/Client/templates/accounts.html'
	});
	$routeProvider.when('/Client/Employees/:time', {
		templateUrl: zionAPI.Web + '/Areas/Client/templates/employees.html'
	});
	$routeProvider.when('/Client/Employees', {
		templateUrl: zionAPI.Web + '/Areas/Client/templates/employees.html'
	});
	$routeProvider.when('/Client/Payrolls', {
		templateUrl: zionAPI.Web + '/Areas/Client/templates/payrolls.html'
	});
	$routeProvider.when('/Client/Payrolls/:time', {
		templateUrl: zionAPI.Web + '/Areas/Client/templates/payrolls.html'
	});
	$routeProvider.when('/Client/Checkbook', {
		templateUrl: zionAPI.Web + '/Areas/Client/templates/checkbook.html'
	});
	$routeProvider.when('/Client/Invoices', {
		templateUrl: zionAPI.Web + '/Areas/Client/templates/invoices.html'
	});
	$routeProvider.when('/Reports/:reportName', {
		templateUrl: zionAPI.Web + '/Areas/Reports/templates/reports.html'
	});
	$routeProvider.when('/Admin/Dashboard', {
		templateUrl: zionAPI.Web + '/Areas/Reports/templates/Dashboard.html'
	});
	$routeProvider.when('/Admin/Extracts', {
		templateUrl: zionAPI.Web + '/Areas/Reports/templates/Extracts.html'
	});
	$routeProvider.when('/Admin/InvoiceDelivery', {
		templateUrl: zionAPI.Web + '/Areas/Client/templates/invoicedelivery.html'
	});
	
	// Specify HTML5 mode (using the History APIs) or HashBang syntax.
	$locationProvider.hashPrefix('!');
}]);
