'use strict';
common.factory('authInterceptorService', [
	'$q', '$window', 'localStorageService', 'zionAPI', 'zionPaths',
	function($q, $window, localStorageService, zionAPI, zionPaths) {

		var authInterceptorServiceFactory = {};

		var _request = function(config) {

			config.headers = config.headers || {};

			var authData = localStorageService.get('authorizationData');
			if (authData) {
				config.headers.Authorization = 'Bearer ' + authData.token;
			}

			return config;
		};
		var _responseError = function(rejection) {
			if (rejection.status === 401) {
				localStorageService.remove('authorizationData');
				$window.location.href = zionAPI.Web + zionPaths.Logout;
			}
			return $q.reject(rejection);
		};
		authInterceptorServiceFactory.request = _request;
		authInterceptorServiceFactory.responseError = _responseError;

		return authInterceptorServiceFactory;
	}
]);