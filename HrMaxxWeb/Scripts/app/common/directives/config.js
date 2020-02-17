'use strict';

common.directive('config', ['zionAPI', '$timeout', '$window', 'version', 'localStorageService',
	function (zionAPI, $timeout, $window, version, localStorageService) {
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
					selectedHoliday: null,
					openedRack: 2,
					originalCountries: localStorageService.get('countries'),
					states: angular.copy(localStorageService.get('countries')[0].states),
					deductionCategories: [{ key: 1, value: 'Post Tax Deduction' }, { key: 2, value: 'Partial Pre Tax Deduction' }, { key: 3, value: 'Total Pre Tax Deduction' }, { key: 4, value: 'Other' }]
					
			}
				$scope.deductionTypes = [];
				$scope.data = dataSvc;
				
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
						$scope.mainData.showMessage('This holiday is already in the system ', 'warning');
					} else {
						commonRepository.saveHoliday(moment(dataSvc.newHoliday).format("DDMMYYYY"), true).then(function (res) {
							dataSvc.holidays.push(res);
							
						}, function (error) {
							$scope.mainData.handleError('error occurred in saving bank holidays ' , error, 'danger');
						});
					}
					dataSvc.newHoliday = null;
				}
				$scope.removeHoliday = function () {
					commonRepository.saveHoliday(moment(dataSvc.seleectedHoliday).format("DDMMYYYY"), false).then(function (res) {
						dataSvc.holidays.splice(dataSvc.holidays.indexOf(res), 1);
					}, function (error) {
							$scope.mainData.handleError('error occurred in removing bank holidays ' , error, 'danger');
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
						$scope.mainData.showMessage('successfully saved configurations', 'success');
					}, function (error) {
							$scope.mainData.handleError('', error, 'danger');
					});
				}
				$scope.addDeductionType = function () {
					var dt = {
						id: 0, name: '', w2_12: '', r940_R: '', w2_13rVal: false, w2_13R: '', category: 0, categoryOption: null
					};
					$scope.deductionTypes.push(dt);
					$scope.selectedType = dt;
				}
				$scope.cancelDeduction = function (dt) {
					$scope.selectedType = null;
					$scope.deductionTypes[dt] = angular.copy($scope.original);
					$scope.original = null;
					if (!$scope.deductionTypes[dt]) {
						$scope.deductionTypes.splice(dt, 1);
					}
				}
				$scope.setSelectedType = function (dt) {
					$scope.original = angular.copy($scope.deductionTypes[dt]);
					$scope.selectedType = $scope.deductionTypes[dt];
				}
				$scope.isDeductionTypeValid = function () {
					if ($scope.selectedType) {
						if (!$scope.selectedType.categoryOption || !$scope.selectedType.name)
							return false;
						else
							return true;
					} else {
						return true;
					}

				}
				$scope.saveDeductionType = function (dt) {
					if ($scope.selectedType) {
						$scope.selectedType.category = $scope.selectedType.categoryOption.key;
						commonRepository.saveDeductionType($scope.selectedType).then(function (data) {

							$scope.mainData.showMessage('Successfully saved deduction type ', 'success');
							$scope.deductionTypes[dt] = angular.copy(data);
							$scope.selectedType = null;
							$scope.original = null;

						}, function (error) {
							$scope.mainData.handleError('error in saving deductin type. ', error, 'danger');
						});
					}
				}
				$scope.hasStatesChanged = function () {
					return (!angular.equals(dataSvc.states, dataSvc.originalCountries[0].states)) ? true : false;
				}
				$scope.cancelStates = function () {
					dataSvc.originalCountries = localStorageService.get('countries');
					dataSvc.states = angular.copy(dataSvc.originalCountries[0].states);
				}
				$scope.saveStates = function () {
					dataSvc.originalCountries[0].states = dataSvc.states;
					commonRepository.saveCountries(dataSvc.originalCountries[0]).then(function (data) {

						$scope.mainData.showMessage('Successfully saved states ', 'success');
						localStorageService.set('countries', data);
						dataSvc.states = angular.copy(data[0].states);
						dataSvc.originalCountries = data;
					}, function (error) {
							$scope.mainData.handleError('error in saving countries. ', error, 'danger');
							$scope.cancelStates();
					});
				}
				$scope.saveState = function (dt) {
					dataSvc.states[dt] = angular.copy($scope.selectedState);
					$scope.selectedState = null;
					$scope.originalState = null;
				}
				$scope.cancelState = function (dt) {
					$scope.selectedState = null;
					dataSvc.states[dt] = angular.copy($scope.originalState);
					$scope.originalState = null;
					
				}
				$scope.setSelectedState = function (dt) {
					$scope.originalState = angular.copy(dataSvc.states[dt]);
					$scope.selectedState = dataSvc.states[dt];
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
								$scope.mainData.handleError('error occurred in bank holidays ' , error, 'danger');
						});
						commonRepository.getDeductionTypes().then(function (types) {
							$scope.deductionTypes = angular.copy(types);
						}, function (error) {
							$scope.mainData.handleError('error occurred in getting deduction types ', error, 'danger');
						});
					}, function (error) {
							$scope.mainData.handleError('error occurred in getting configuration data ' , error, 'danger');
					});

					

				}
				init();

			}]
		}
	}
]);