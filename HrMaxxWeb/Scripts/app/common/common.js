var common = angular.module('common', ['ngAnimate', 'LocalStorageModule', 'ui.bootstrap', 'angular-loading-bar', 'mgcrea.ngStrap.popover']);

common.constant('zionPaths', {
	Login: 'Account/Login',
	Logout: 'Account/LogOff',
	Token: 'token'
});

common.config(function($httpProvider) {
	$httpProvider.interceptors.push('authInterceptorService');
});

common.run([
	'authService', function(authService) {
		authService.fillAuthData();
	}
]);

common.factory('commonServer', [
	'Restangular', 'zionAPI', function(Restangular, zionAPI) {

		return Restangular.withConfig(function(RestangularConfigurer) {

			RestangularConfigurer.setBaseUrl(zionAPI.URL);
			RestangularConfigurer.setRestangularFields({
				id: 'id'
			});
		});
	}
]);