'use strict';

common.controller('loginCtrl', [
	'$scope', 'authService', 'commonRepository', '$window', 'localStorageService',
	function ($scope, authService, commonRepository, $window, localStorageService) {
		$scope.username = localStorageService.get('username');
		$scope.password = localStorageService.get('password');
		$scope.rememberMe = true;
		$scope.returnUrl = "";
		$scope.alerts = [];

		$scope.addAlert = function (error, type) {
			$scope.alerts = [];
			$scope.alerts.push({
				msg: error,
				type: type
			});
		};

		$scope.closeAlert = function (index) {
			$scope.alerts.splice(index, 1);
		};

		$scope.unexpectedError = function () {
			$scope.addAlert('Unexpected error has occurred, please try again.', 'danger');
		};

		$scope.login = function ($event, returnUrl) {
			$($event.target).button('loading');
			var data = {
				username: $scope.username,
				password: $scope.password,
				rememberMe: $scope.rememberMe,
				returnUrl: returnUrl
			};

			var login = authService.login(data);
			login.then(function () {
				authService.fillAuthData();
				$('#loginFormSubmit').submit();
				if ($scope.rememberMe) {
					localStorageService.set('username', $scope.username);
					localStorageService.set('password', $scope.password);
				}
			}, function (error) {
				if (error) {
					$scope.addAlert(error.error_description, 'danger');
				} else
					$scope.unexpectedError();
				$($event.target).button('reset');
			});
		};
		$scope.logout = function ($event) {
			$event.stopPropagation();
			authService.clearToken();
			$('#logoutForm').submit();
		}
		function _init() {
			
		};

		_init();
	}
]);