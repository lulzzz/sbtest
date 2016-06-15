var common = angular.module('common', ['ngAnimate', 'LocalStorageModule', 'ui.bootstrap', 'angular-loading-bar', 'mgcrea.ngStrap.popover', 'xeditable', 'ngTable', 'angularFileUpload', 'restangular']);

common.constant('zionPaths', {
	Login: 'Account/Login',
	Logout: 'Account/LogOff',
	Token: 'token'
});

common.constant('EntityTypes', {
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
	Comment: 14
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

common.config(function($httpProvider) {
	$httpProvider.interceptors.push('authInterceptorService');
});

common.run([
	'authService', function(authService) {
		authService.fillAuthData();
	}
]);


common.run(function (editableOptions) {
	editableOptions.theme = 'bs3';
});

common.controller('documentModal', function ($scope, $modalInstance, doc, zionAPI) {
	$scope.modaldoc = doc;

	$scope.getDocumentUrl = function () {
		
		return zionAPI.URL + 'Document/' + $scope.modaldoc.documentId;
	};

});