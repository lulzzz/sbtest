'use strict';

common.directive('taxRates', ['zionAPI', 'version', '$timeout',
	function (zionAPI, version, $timeout) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData:"=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Administration/templates/tax-rates.html?v=' + version,

			controller: ['$scope', '$rootScope', '$filter', 'commonRepository',
				function ($scope, $rootScope, $filter, commonRepository) {
					
					$scope.alerts = [];
					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					var dataSvc = {
						taxTables: null,
						originalTaxTables: null,
						selectedYear: null,
						selectedTab: null,
						payrollSchedules: [{ key: 1, value: 'Weekly' }, { key: 2, value: 'Bi-Weekly' }, { key: 3, value: 'Semi-Monthly' }, { key: 4, value: 'Monthly' }],
						federalFilingStatuses: [{ key: 1, value: 'Single' }, { key: 2, value: 'Married' }, { key: 3, value: 'HeadofHousehold' }],
						californiaFilingStatuses: [{ key: 1, value: 'Single' }, { key: 2, value: 'Married' }, { key: 3, value: 'Headofhousehold' }],
						californiaLowIncomeFilingStatuses: [{ key: 1, value: 'Single' }, { key: 2, value: 'DualIncomeMarried' }, { key: 3, value: 'MarriedWithMultipleEmployers' }, { key: 4, value: 'Married' }, { key: 5, value: 'Headofhousehold' }]
					}
					$scope.data = dataSvc;
					$scope.selectedTR = null;
					
					$scope.closeAlert = function (index) {
						$scope.alerts.splice(index, 1);
					};

					$scope.save = function () {
						$scope.$parent.$parent.confirmDialog('Are you sure you want to save the imported rates? this will overwrite the existing ones', 'danger', function () {
							commonRepository.saveTaxTables(dataSvc.selectedYear, dataSvc.taxTables).then(function (data) {
								dataSvc.originalTaxTables = data;
								dataSvc.taxTables = angular.copy(data);
								dataSvc.selectedYear = null;
								addAlert('Successfully saved tax rates for year' + dataSvc.selectedYear, 'success');
							}, function (error) {
								addAlert('error in saving tax rates for year= ' + dataSvc.selectedYear, 'danger');
							});
						}
						);
						
					}
					
					var getTaxTables = function() {
						commonRepository.getTaxTables().then(function (data) {
							dataSvc.originalTaxTables = data;
							dataSvc.taxTables = angular.copy(data);
							
						}, function (error) {
							$scope.list = [];
							addAlert('error in getting tax rates ', 'danger');
						});
					}
					$scope.cancel = function () {
						dataSvc.taxTables = angular.copy(dataSvc.originalTaxTables);
						dataSvc.selectedYear = null;
						dataSvc.selectedTab = null;
					}
					$scope.addNewYear = function () {
						var maxYear = $filter('orderBy')(dataSvc.taxTables.years, '', true)[0];

						$scope.$parent.$parent.confirmDialog('This will copy the tax tables for ' + maxYear + ' into ' + (maxYear+1) + '. Do you want to proceed?', 'warning', function () {
							commonRepository.createTaxTables(maxYear + 1).then(function (data) {
								dataSvc.originalTaxTables = data;
								dataSvc.taxTables = angular.copy(data);
								addAlert('successfully created entries in tax tables for ' + (maxYear+1), 'success');
							}, function (error) {
								$scope.list = [];
								addAlert('error in creating tax tables for year ' + (maxYear + 1), 'danger');
							});
						});

						
					}
					
					$scope.hasChanges = function() {
						return !angular.equals(dataSvc.originalTaxTables, dataSvc.taxTables);
					}

					$scope.setSelectedTR = function(tr) {
						$scope.originalSelectedTR = angular.copy(tr);
					}
					$scope.cancelTR = function (tr) {
						var ind = dataSvc.taxTables.taxes.indexOf(tr);
						dataSvc.taxTables.taxes[ind] = angular.copy($scope.originalSelectedTR);
						$scope.originalSelectedTR = null;
					}
					$scope.saveTR = function (tr) {
						if (!angular.equals(tr, $scope.originalSelectedTR)) {
							tr.hasChanged = true;
						}
						$scope.originalSelectedTR = null;
					}
					$scope.setSelectedFIT = function (tr) {
						$scope.selectedFIT = tr;
						$scope.originalSelectedFIT = angular.copy(tr);
					}
					$scope.cancelFIT = function (tr) {
						var ind = dataSvc.taxTables.fitTaxTable.indexOf(tr);
						dataSvc.taxTables.fitTaxTable[ind] = angular.copy($scope.originalSelectedFIT);
						$scope.originalSelectedFIT = null;
						$scope.selectedFIT = null;
						
					}
					$scope.saveFIT = function (tr) {
						if (!angular.equals(tr, $scope.originalSelectedFIT)) {
							tr.hasChanged = true;
						}
						$scope.originalSelectedFIT = null;
						$scope.selectedFIT = null;
						return tr;
					}
					$scope.removeFIT = function (tr) {
						dataSvc.taxTables.fitTaxTable.splice(dataSvc.taxTables.fitTaxTable.indexOf(tr), 1);
						
					}
					$scope.addFIT = function () {
						var max = $filter('orderBy')(dataSvc.taxTables.fitTaxTable, 'id', true)[0];
						var newfit = {
							isNew: true,
							hasChanged: true,
							id: max ? max.id + 1 : 1,
							year: dataSvc.selectedYear,
							payrollSchedule: null,
							filingStatus: null,
							rangeStart: null,
							rangeEnd: null,
							flatRate: null,
							additionalPercentage: null,
							excessOverAmount: null
						};
						dataSvc.taxTables.fitTaxTable.push(newfit);
						
					}

					$scope.setSelectedSIT = function (tr) {
						$scope.selectedSIT = tr;
						$scope.originalSelectedSIT = angular.copy(tr);
					}
					$scope.cancelSIT = function (tr) {
						var ind = dataSvc.taxTables.casitTaxTable.indexOf(tr);
						dataSvc.taxTables.casitTaxTable[ind] = angular.copy($scope.originalSelectedSIT);
						$scope.originalSelectedSIT = null;
						$scope.selectedSIT = null;
						
					}
					$scope.saveSIT = function (tr) {
						if (!angular.equals(tr, $scope.originalSelectedSIT)) {
							tr.hasChanged = true;
						}
						$scope.originalSelectedSIT = null;
						$scope.selectedSIT = null;
						return tr;
					}
					$scope.removeSIT = function (tr) {
						dataSvc.taxTables.casitTaxTable.splice(dataSvc.taxTables.casitTaxTable.indexOf(tr), 1);

					}
					$scope.addSIT = function () {
						var max = $filter('orderBy')(dataSvc.taxTables.casitTaxTable, 'id', true)[0];
						var newfit = {
							isNew: true,
							hasChanged: true,
							id: max ? max.id + 1 : 1,
							year: dataSvc.selectedYear,
							payrollSchedule: null,
							filingStatus: null,
							rangeStart: null,
							rangeEnd: null,
							flatRate: null,
							additionalPercentage: null,
							excessOverAmount: null
						};
						dataSvc.taxTables.casitTaxTable.push(newfit);

					}

					$scope.setSelectedFITW = function (tr) {
						$scope.selectedFITW = tr;
						$scope.originalSelectedFITW = angular.copy(tr);
					}
					$scope.cancelFITW = function (tr) {
						var ind = dataSvc.taxTables.fitWithholdingAllowanceTable.indexOf(tr);
						dataSvc.taxTables.fitWithholdingAllowanceTable[ind] = angular.copy($scope.originalSelectedFITW);
						$scope.originalSelectedFITW = null;
						$scope.selectedFITW = null;
						
					}
					$scope.saveFITW = function (tr) {
						if (!angular.equals(tr, $scope.originalSelectedFITW)) {
							tr.hasChanged = true;
						}
						$scope.originalSelectedFITW = null;
						$scope.selectedFITW = null;
						return tr;
					}

					$scope.setSelectedSITLow = function (tr) {
						$scope.selectedSITLow = tr;
						$scope.originalSelectedSITLow = angular.copy(tr);
					}
					$scope.cancelSITLow = function (tr) {
						var ind = dataSvc.taxTables.casitLowIncomeTaxTable.indexOf(tr);
						dataSvc.taxTables.casitLowIncomeTaxTable[ind] = angular.copy($scope.originalSelectedSITLow);
						$scope.originalSelectedSITLow = null;
						$scope.selectedSITLow = null;
						
					}
					$scope.saveSITLow = function (tr) {
						if (!angular.equals(tr, $scope.originalSelectedSITLow)) {
							tr.hasChanged = true;
						}
						$scope.originalSelectedSITLow = null;
						$scope.selectedSITLow = null;
						return tr;
					}

					$scope.setSelectedStdDed = function (tr) {
						$scope.selectedStdDed = tr;
						$scope.originalSelectedStdDed = angular.copy(tr);
					}
					$scope.cancelStdDed = function (tr) {
						var ind = dataSvc.taxTables.caStandardDeductionTable.indexOf(tr);
						dataSvc.taxTables.caStandardDeductionTable[ind] = angular.copy($scope.originalSelectedStdDed);
						$scope.originalSelectedStdDed = null;
						$scope.selectedStdDed = null;
						
					}
					$scope.saveStdDed = function (tr) {
						if (!angular.equals(tr, $scope.originalSelectedStdDed)) {
							tr.hasChanged = true;
						}
						$scope.originalSelectedStdDed = null;
						$scope.selectedStdDed = null;
						return tr;
					}

					$scope.setSelectedEstDed = function (tr) {
						$scope.selectedEstDed = tr;
						$scope.originalSelectedEstDed = angular.copy(tr);
					}
					$scope.cancelEstDed = function (tr) {
						var ind = dataSvc.taxTables.estimatedDeductionTable.indexOf(tr);
						dataSvc.taxTables.estimatedDeductionTable[ind] = angular.copy($scope.originalSelectedEstDed);
						$scope.originalSelectedEstDed = null;
						$scope.selectedEstDed = null;
						
					}
					$scope.saveEstDed = function (tr) {
						if (!angular.equals(tr, $scope.originalSelectedEstDed)) {
							tr.hasChanged = true;
						}
						$scope.originalSelectedEstDed = null;
						$scope.selectedEstDed = null;
						return tr;
					}

					$scope.setSelectedExmpAllow = function (tr) {
						$scope.selectedExmpAllow = tr;
						$scope.originalSelectedExmpAllow = angular.copy(tr);
					}
					$scope.cancelExmpAllow = function (tr) {
						var ind = dataSvc.taxTables.exemptionAllowanceTable.indexOf(tr);
						dataSvc.taxTables.exemptionAllowanceTable[ind] = angular.copy($scope.originalSelectedExmpAllow);
						$scope.originalSelectedExmpAllow = null;
						$scope.selectedExmpAllow = null;
						
					}
					$scope.saveExmpAllow = function (tr) {
						if (!angular.equals(tr, $scope.originalSelectedExmpAllow)) {
							tr.hasChanged = true;
						}
						$scope.originalSelectedExmpAllow = null;
						$scope.selectedExmpAllow = null;
						return tr;
					}
					var _init = function () {
						$scope.mainData.showFilterPanel = false;
						getTaxTables();

					}
					_init();


				}]
		}
	}
]);
