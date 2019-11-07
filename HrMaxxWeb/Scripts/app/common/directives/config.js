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
					minYear: 2017,
					holidays: [],
					newHoliday: null,
					selectedHoliday: null
					
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
				$scope.addHoliday = function () {
					if ($scope.holidayExists(dataSvc.newHoliday)) {
						addAlert('This holiday is already in the system ', 'warning');
					} else {
						commonRepository.saveHoliday(moment(dataSvc.newHoliday).format("DDMMYYYY"), true).then(function (res) {
							dataSvc.holidays.push(res);
							
						}, function (error) {
							addAlert('error occurred in saving bank holidays ' + error.statusText, 'danger');
						});
					}
					dataSvc.newHoliday = null;
				}
				$scope.removeHoliday = function () {
					commonRepository.saveHoliday(moment(dataSvc.seleectedHoliday).format("DDMMYYYY"), false).then(function (res) {
						dataSvc.holidays.splice(dataSvc.holidays.indexOf(res), 1);
					}, function (error) {
						addAlert('error occurred in removing bank holidays ' + error.statusText, 'danger');
					});
				}
				$scope.holidayExists = function (d) {
					if (!d)
						return true;
					var dt = moment(d).format('YYYY-MM-DDT00:00:00');
					return $filter('filter')(dataSvc.holidays, { value: dt }).length > 0;
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
						commonRepository.getBankHolidays().then(function (hols) {
							dataSvc.holidays = hols;
						}, function (error) {
							addAlert('error occurred in bank holidays ' + error.statusText, 'danger');
						});
					}, function (error) {
						addAlert('error occurred in getting configuration data ' + error.statusText, 'danger');
					});

					

				}
				init();

			}]
		}
	}
]);