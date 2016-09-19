var common = angular.module('common', ['ngAnimate', 'LocalStorageModule', 'ui.bootstrap', 'angular-loading-bar', 'mgcrea.ngStrap.popover', 'xeditable', 'ngTable', 'angularFileUpload', 'restangular', 'ui.mask', 'ngSanitize', 'angularjs-dropdown-multiselect', 'ngRoute']);

common.constant('zionPaths', {
	Login: 'Account/Login',
	Logout: 'Account/LogOff',
	Token: 'token'
});
common.constant('version', '1.0.0.4');
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
	Comment: 14,
	Vendor: 15,
	Customer: 16
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

