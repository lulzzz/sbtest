'use strict';
common.factory('authService', [
	'$http', '$q', 'localStorageService', 'commonRepository',
	function($http, $q, localStorageService, commonRepository) {

		var authServiceFactory = {};

		var _authentication = {
			isAuth: false,
			userName: ""
		};

		var _clearToken = function() {
			localStorageService.remove('authorizationData');
			_authentication.isAuth = false;
			_authentication.userName = "";
		};
		var _login = function(loginData) {

			var deferred = $q.defer();
			commonRepository.token(loginData).then(function(response) {
				localStorageService.set('authorizationData', { token: response.access_token, userName: loginData.username });

				_authentication.isAuth = true;
				_authentication.userName = loginData.username;
				
				deferred.resolve(response);

			}, function(err, status) {
				_logOut();
				deferred.reject(err);
			});

			return deferred.promise;
		};

		var _logOut = function() {

			_clearToken();
			return commonRepository.logout();
		};

		var _fillAuthData = function() {

			var authData = localStorageService.get('authorizationData');
			if (authData) {
				_authentication.isAuth = true;
				_authentication.userName = authData.userName;
				commonRepository.getCountries().then(function (data) {
					localStorageService.set('countries', data);
				});
			}

		};
		authServiceFactory.login = _login;
		authServiceFactory.logOut = _logOut;
		authServiceFactory.fillAuthData = _fillAuthData;
		authServiceFactory.authentication = _authentication;
		authServiceFactory.clearToken = _clearToken;

		return authServiceFactory;
	}
]);