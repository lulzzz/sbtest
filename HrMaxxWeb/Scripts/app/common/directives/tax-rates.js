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

			controller: ['$scope', '$rootScope', '$filter', 'commonRepository', 'localStorageService',
				function ($scope, $rootScope, $filter, commonRepository, localStorageService) {
					
					
					var dataSvc = {
						taxTableYears: [],
						currentYear: new Date().getFullYear(),
						taxTables: null,
						originalTaxTables: null,
						selectedYear: null,
						selectedTab: null,
						payrollSchedules: [{ key: 1, value: 'Weekly' }, { key: 2, value: 'Bi-Weekly' }, { key: 3, value: 'Semi-Monthly' }, { key: 4, value: 'Monthly' }, , { key: 5, value: 'Annually' }],
						federalFilingStatuses: [{ key: 1, value: 'Single' }, { key: 2, value: 'Married' }, { key: 3, value: 'HeadofHousehold' }],
						californiaFilingStatuses: [{ key: 1, value: 'Single' }, { key: 2, value: 'Married' }, { key: 3, value: 'Headofhousehold' }],
						californiaLowIncomeFilingStatuses: [{ key: 1, value: 'Single' }, { key: 2, value: 'DualIncomeMarried' }, { key: 3, value: 'MarriedWithMultipleEmployers' }, { key: 4, value: 'Married' }, { key: 5, value: 'Headofhousehold' }],
						states: localStorageService.get('countries')[0].states
					}
					$scope.showEdit = function () {
						return dataSvc.selectedYear >= dataSvc.currentYear;

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
								$scope.mainData.showMessage('Successfully saved tax rates for year' + dataSvc.selectedYear, 'success');
							}, function (error) {
								$scope.mainData.showMessage('error in saving tax rates for year= ' + dataSvc.selectedYear, 'danger');
							});
						}
						);
						
					}
					
					$scope.getTaxTables = function() {
						commonRepository.getTaxTables(dataSvc.selectedYear).then(function (data) {
							dataSvc.originalTaxTables = data;
							dataSvc.taxTables = angular.copy(data);
							
						}, function (error) {
							$scope.list = [];
							$scope.mainData.showMessage('error in getting tax rates ', 'danger');
						});
					}
					var getTaxTableYears = function () {
						commonRepository.getTaxTableYears().then(function (data) {
							dataSvc.taxTableYears = data;
							//dataSvc.taxTables = angular.copy(data);

						}, function (error) {
							$scope.list = [];
							$scope.mainData.showMessage('error in getting tax table years ', 'danger');
						});
					}
					$scope.cancel = function () {
						dataSvc.taxTables = angular.copy(dataSvc.originalTaxTables);
						dataSvc.selectedYear = null;
						dataSvc.selectedTab = null;
					}
					$scope.addNewYear = function () {
						var maxYear = $filter('orderBy')(dataSvc.taxTableYears, 'identity', true)[0];

						$scope.$parent.$parent.confirmDialog('This will copy the tax tables for ' + maxYear + ' into ' + (maxYear+1) + '. Do you want to proceed?', 'warning', function () {
							commonRepository.createTaxTables(maxYear + 1).then(function (data) {
								dataSvc.originalTaxTables = data;
                                dataSvc.taxTables = angular.copy(data);
                                dataSvc.taxTableYears.push(maxYear + 1);
								$scope.mainData.showMessage('successfully created entries in tax tables for ' + (maxYear+1), 'success');
							}, function (error) {
								$scope.list = [];
								$scope.mainData.showMessage('error in creating tax tables for year ' + (maxYear + 1), 'danger');
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
						$scope.setSelectedFIT(newfit);
					}
					$scope.setSelectedFITW4 = function (tr) {
						$scope.selectedFITW4 = tr;
						$scope.originalSelectedFITW4 = angular.copy(tr);
					}
					$scope.cancelFITW4 = function (tr) {
						var ind = dataSvc.taxTables.fitW4Table.indexOf(tr);
						dataSvc.taxTables.fitW4Table[ind] = angular.copy($scope.originalSelectedFITW4);
						$scope.originalSelectedFITW4 = null;
						$scope.selectedFITW4 = null;

					}
					$scope.saveFITW4 = function (tr) {
						if (!angular.equals(tr, $scope.originalSelectedFITW4)) {
							tr.hasChanged = true;
						}
						$scope.originalSelectedFITW4 = null;
						$scope.selectedFITW4 = null;
						return tr;
					}
					
					$scope.addFITW4 = function () {
						var max = $filter('orderBy')(dataSvc.taxTables.fitW4Table, 'id', true)[0];
						var newfit = {
							isNew: true,
							hasChanged: true,
							id: max ? max.id + 1 : 1,
							year: dataSvc.selectedYear,
							filingStatus: null,
							dependentWageLimit: null,
							dependentAllowance1: null,
							dependentAllowance2: null,
							additionalDeductionW4: null,
							deductionForExemption: null
						};
						dataSvc.taxTables.fitW4Table.push(newfit);
						$scope.setSelectedFITW4(newfit);
					}
					$scope.setSelectedFITAlien = function (tr) {
						$scope.selectedFITAlien = tr;
						$scope.originalSelectedFITAlien = angular.copy(tr);
					}
					$scope.cancelFITAlien = function (tr) {
						var ind = dataSvc.taxTables.fitAlienAdjustmentTable.indexOf(tr);
						dataSvc.taxTables.fitW4Table[ind] = angular.copy($scope.originalSelectedAlien);
						$scope.originalSelectedFITAlien = null;
						$scope.selectedFITAlien = null;

					}
					$scope.saveFITAlien = function (tr) {
						if (!angular.equals(tr, $scope.originalSelectedFITAlien)) {
							tr.hasChanged = true;
						}
						$scope.originalSelectedFITAlien = null;
						$scope.selectedFITAlien = null;
						return tr;
					}
					$scope.addFITAlien = function () {
						var max = $filter('orderBy')(dataSvc.taxTables.fitW4Table, 'id', true)[0];
						var newfit = {
							isNew: true,
							hasChanged: true,
							id: max ? max.id + 1 : 1,
							year: dataSvc.selectedYear,
							payrollPeriodId: null,
							amount: null,
							pre2020: null
						};
						dataSvc.taxTables.fitAlienAdjustmentTable.push(newfit);
						$scope.setSelectedFITAlien(newfit);
					}

					
                    $scope.setSelectedHISIT = function (tr) {
                        $scope.selectedHISIT = tr;
                        $scope.originalSelectedHISIT = angular.copy(tr);
                    }
                    $scope.cancelHISIT = function (tr) {
                        var ind = dataSvc.taxTables.hisitTaxTable.indexOf(tr);
                        dataSvc.taxTables.fitTaxTable[ind] = angular.copy($scope.originalSelectedHISIT);
                        $scope.originalSelectedHISIT = null;
                        $scope.selectedHISIT = null;

                    }
                    $scope.saveHISIT = function (tr) {
                        if (!angular.equals(tr, $scope.originalSelectedHISIT)) {
                            tr.hasChanged = true;
                        }
                        $scope.originalSelectedHISIT = null;
                        $scope.selectedHISIT = null;
                        return tr;
                    }
                    $scope.removeHISIT = function (tr) {
                        dataSvc.taxTables.hisitTaxTable.splice(dataSvc.taxTables.hisitTaxTable.indexOf(tr), 1);

                    }
                    $scope.addHISIT = function () {
                        var max = $filter('orderBy')(dataSvc.taxTables.hisitTaxTable, 'id', true)[0];
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
                        dataSvc.taxTables.hisitTaxTable.push(newfit);
						$scope.setSelectedHISIT(newfit);
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
						$scope.setSelectedSIT(newfit);
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
                    $scope.setSelectedHISITW = function (tr) {
                        $scope.selectedHISITW = tr;
                        $scope.originalSelectedHISITW = angular.copy(tr);
                    }
                    $scope.cancelHISITW = function (tr) {
                        var ind = dataSvc.taxTables.hiSitWithholdingAllowanceTable.indexOf(tr);
                        dataSvc.taxTables.hiSitWithholdingAllowanceTable[ind] = angular.copy($scope.originalSelectedHISITW);
                        $scope.originalSelectedHISITW = null;
                        $scope.selectedHISITW = null;

                    }
                    $scope.saveHISITW = function (tr) {
                        if (!angular.equals(tr, $scope.originalSelectedHISITW)) {
                            tr.hasChanged = true;
                        }
                        $scope.originalSelectedHISITW = null;
                        $scope.selectedHISITW = null;
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

					$scope.setSelectedMinWage = function (tr) {
						$scope.selectedMinWage = tr;
						$scope.originalSelectedMinWage = angular.copy(tr);
					}
					$scope.cancelMinWage = function (tr) {
						var ind = dataSvc.taxTables.minWageYearTable.indexOf(tr);
						dataSvc.taxTables.minWageYearTable[ind] = angular.copy($scope.originalSelectedMinWage);
						$scope.originalSelectedMinWage = null;
						$scope.selectedMinWage = null;

					}
					$scope.saveMinWage = function (tr) {
						if (!angular.equals(tr, $scope.originalSelectedMinWage)) {
							tr.hasChanged = true;
						}
						$scope.originalSelectedMinWage = null;
						$scope.selectedMinWage = null;
						return tr;
					}
					
					$scope.addMinWage = function () {
						var max = $filter('orderBy')(dataSvc.taxTables.minWageYearTable, 'id', true)[0];
						var newm = {
							isNew: true,
							hasChanged: true,
							id: max ? max.id + 1 : 1,
							year: dataSvc.selectedYear,
							stateId: null,
							state: null,
							city: null,
							minNoOfEmployees: null,
							maxNoOfEmployees: null,
							minWage: null,
							tippedMinWage: null
						};
						dataSvc.taxTables.minWageYearTable.push(newm);
						$scope.setSelectedMinWage(newm);
					}
					$scope.getStateName = function (id) {
						if (id) {
							var st = $filter('filter')(dataSvc.states, { stateId: id })[0];
							return st ? st.stateName : '';
						}
						else return 'Federal';
					}


					var _init = function () {
						$scope.mainData.showFilterPanel = false;
						//getTaxTables();
						getTaxTableYears();

					}
					_init();


				}]
		}
	}
]);
