'use strict';

common.directive('config', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Administration/templates/config.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'commonRepository', function ($scope, $element, $location, $filter, commonRepository) {
				var dataSvc = {
					configs: null,
					tags: [],
					rootHost: null,
					isBodyOpen: true,
					insuranceGroups: [],
					minYear: 2017
					
			}

				$scope.data = dataSvc;
				var addAlert = function (error, type) {
					$scope.$parent.$parent.addAlert(error, type);
				};
				if ($scope.mainData)
					$scope.mainData.showFilterPanel = false;

				$scope.addTaxPanelty = function() {
					dataSvc.configs.invoiceLateFeeConfigs.push({
						daysFrom: null,
						daysTo: null,
						rate: 0
					});
				}
				$scope.save = function () {

					if (dataSvc.tags.length > 0) {
						dataSvc.configs.couriers = [];
						$.each(dataSvc.tags, function (i, t) {
							dataSvc.configs.couriers.push(t.text);
						
						});
					}
					commonRepository.saveConfigData(dataSvc.configs).then(function (result) {
						addAlert('successfully saved configurations', 'success');
					}, function (error) {
						addAlert(error.statusText, 'danger');
					});
				}
				
				var init = function () {
					dataSvc.maxYear = new Date().getFullYear();
					
					commonRepository.getConfigData().then(function (result) {
						dataSvc.configs = angular.copy(result);
						if (result.rootHostId) {
							dataSvc.rootHost = $filter('filter')($scope.mainData.hosts, { id: result.rootHostId })[0];
						}
						
						if (dataSvc.configs.couriers.length > 0) {
							$.each(dataSvc.configs.couriers, function(i, c) {
								dataSvc.tags.push({
									text: c
								});
							});
						}
						if (!dataSvc.configs.c1095Limits)
							dataSvc.configs.c1095Limits = [];
						for (var i = dataSvc.minYear; i <= dataSvc.maxYear; i++) {
							var exists = $filter('filter')(dataSvc.configs.c1095Limits, { key: i });
							if (exists.length === 0) {
								dataSvc.configs.c1095Limits.push({ key: i, value: 0 });
							}
						}

					}, function (error) {
						addAlert('error occurred in getting configuration data ' + error.statusText, 'danger');
					});

					

				}
				init();

			}]
		}
	}
]);