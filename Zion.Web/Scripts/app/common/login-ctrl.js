'use strict';

common.controller('loginCtrl', [
	'$scope', 'authService', 'commonRepository', '$window',
	function($scope, authService, commonRepository, $window) {
		$scope.username = "";
		$scope.password = "";
		$scope.rememberMe = true;
		$scope.returnUrl = "";
		$scope.alerts = [];

		$scope.addAlert = function(error, type) {
			$scope.alerts = [];
			$scope.alerts.push({
				msg: error,
				type: type
			});
		};

		$scope.closeAlert = function(index) {
			$scope.alerts.splice(index, 1);
		};

		$scope.unexpectedError = function() {
			$scope.addAlert('Unexpected error has occurred, please try again.', 'danger');
		};

		$scope.login = function(returnUrl) {
			//$($event.target).button('loading');
			var data = {
				username: $scope.username,
				password: $scope.password,
				rememberMe: $scope.rememberMe,
				returnUrl: returnUrl
			};

			var login = authService.login(data);
			login.then(function() {
				authService.fillAuthData();
				$('#loginFormSubmit').submit();

			}, function(error) {
				if (error) {
					$scope.addAlert(error, 'danger');
				} else
					$scope.unexpectedError();
				//$($event.target).button('reset');
			});
		};

		function _init() {
			authService.clearToken();
		};

		_init();
	}
]);