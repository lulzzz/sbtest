﻿common.controller('mainCtrl', [
	'$scope', '$element', 'hostRepository','zionAPI', 'companyRepository','localStorageService',
	function ($scope, $element, hostRepository, zionAPI, companyRepository, localStorageService) {
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
		$scope.zionAPI = zionAPI;
		
		var dataSvc = {
			hosts: [],
			companies: [],
			selectedHost: null,
			selectedCompany: null,
			isFilterOpen: true,
			showFilterPanel: true,
			showCompanies: true,
			userHost: null,
			userCompany: null,
			isReady:false
		};
		$scope.data = dataSvc;
		
		function _init() {
			var auth = localStorageService.get('authorizationData');
			if (auth) {
				hostRepository.getHostList().then(function (data) {
					dataSvc.hosts = data;
					if (dataSvc.hosts.length === 1) {
						dataSvc.selectedHost = dataSvc.hosts[0];
					}
					if (dataSvc.selectedHost) {
						$scope.hostSelected();
					}
				}, function (error) {
					$scope.addAlert('error getting list of hosts', 'danger');
				});
				var dataInput = $element.data();
				if (dataInput.host !== '00000000-0000-0000-0000-000000000000')
					dataSvc.userHost = dataInput.host;
				if (dataInput.company !== '00000000-0000-0000-0000-000000000000')
					dataSvc.userCompany = dataInput.company;

				dataSvc.showFilterPanel = !dataSvc.userHost;
				dataSvc.showCompanies = !dataSvc.userCompany;
				dataSvc.isReady = true;
			}
		};
		$scope.getCompanies = function () {
			companyRepository.getCompanyList(dataSvc.selectedHost.id).then(function (data) {
				dataSvc.companies = data;
				if (dataSvc.userCompany) {
					var selected = $filter('filter')(dataSvc.companies, {id: dataSvc.userCompany})[0];
					dataSvc.selectedCompany = selected;
				}
			}, function (erorr) {
				addAlert('error getting company list', 'danger');
			});
		}
		$scope.hostSelected = function () {
			dataSvc.selectedCompany = null;
			if (dataSvc.selectedHost)
				$scope.getCompanies();
		}
		
		_init();
	}
]);