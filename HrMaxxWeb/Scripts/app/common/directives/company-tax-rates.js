'use strict';

common.directive('companyTaxRates', ['zionAPI', 'version', '$timeout',
	function (zionAPI, version, $timeout) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData:"=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Administration/templates/company-tax-rates.html?v=' + version,

			controller: ['$scope', '$rootScope', '$filter', 'companyRepository', 'reportRepository', 'NgTableParams', '$window',
				function ($scope, $rootScope, $filter, companyRepository, reportRepository, ngTableParams, $window) {
					$scope.fullList = [];
					$scope.list = [];
					$scope.listWCRates = [];
					$scope.companyScheduleList = [];
					$scope.loadedScheudleList = false;

					$scope.loadedSemiWeeklyEligibility = false;
					$scope.semiWeeklyEligibilityReport = null;

					$scope.loadedMinWageEligibilityCriteria = null;
					$scope.minWageEligibilityReport = null;

					$scope.depositSchedule = 2;
					$scope.yearlyLimit = 50000;
					$scope.quarterlyLimit = 12500;


					$scope.alerts = [];
					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					var dataSvc = {
						openedRack: 0,
						minYear: 2016,
						selectedYear: null,
						years: [],
						companyMetaData: null,
						importInProcess: false,
						importInProcessWC: false,
						currentYear: new Date().getFullYear(),
						minWageCriteria: {
							contractType: 2, minEmployeeCount:null, maxEmployeeCount: null, minWage:null, statusId:0, city:'', payrollYear: (new Date().getFullYear() - 1)
						}
					}
					$scope.data = dataSvc;
					$scope.importMap = {
						startingRow: 2,
						columnCount: 5,
						lastRow: null,
						columnMap: [
						{
							key:"ClientNo", value:1
						},
						{
							key: "Code", value: 4
						}, {
							key: "Rate", value: 5
						}]
						
					};
					$scope.setSelected = function (index) {
						$scope.selected = $scope.importMap.columnMap[index];
					}
					$scope.isItemValid = function (field) {
						if (!field.key || !field.value)
							return false;
						else {
							var matches = $filter('filter')($scope.importMap.columnMap, { value: field.value }, true);
							if (matches.length > 1)
								return false;
							else {
								return true;
							}
						}
					}
					
					$scope.saveSelected = function (field) {
						$scope.selected = null;
					}
					$scope.cancelSelected = function (field, index) {
						if (!field.key || !field.value)
							$scope.importMap.columnMap.splice(index, 1);
						$scope.selected = null;
					}
					$scope.closeAlert = function (index) {
						$scope.alerts.splice(index, 1);
					};

					$scope.save = function () {
						$scope.$parent.$parent.confirmDialog('Are you sure you want to save the imported rates? this will overwrite the existing ones', 'danger', function () {
							companyRepository.saveTaxRates($scope.list).then(function (data) {
								$scope.list = [];
								dataSvc.selectedYear = null;
								addAlert('Successfully imported company tax rates for year' + dataSvc.selectedYear, 'success');
							}, function (error) {
								addAlert('error in saving tax rates for year= ' + dataSvc.selectedYear, 'danger');
							});
						}
						);
						
					}
					$scope.getCaliforniaEDDExport = function () {
						companyRepository.getCaliforniaEDDExport().then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();

						}, function (error) {
							addAlert('error getting california edd list', 'danger');
						});
					}

					$scope.rowColor = function (company) {
						if (company && dataSvc.importInProcess) {
							if (!company.stateEin && company.edd)
								return 'danger';
							else if ((!company.uiRate && company.defaultUiRate) || (!company.ettRate && company.defaultEttRate))
								return 'warning';
							else {
								return 'default';
							}
						} else
							return 'default';

					}

					$scope.cancel = function (index) {
						if ($scope.selected.id === 0) {
							$scope.list.splice(index, 1);
						}
						$scope.selected = null;
					}
					
					$scope.getCompanyTaxRates = function() {
						companyRepository.getAllCompanies(dataSvc.selectedYear).then(function (data) {
							$scope.list = angular.copy(data);
							dataSvc.importInProcess = false;
						}, function (error) {
							$scope.list = [];
							addAlert('error in getting company tax rates ', 'danger');
						});
					}
					$scope.files = [];
					$scope.filesWC = [];
					$scope.onFileSelect = function ($files) {
						$scope.files = [];
						for (var i = 0; i < $files.length; i++) {
							var $file = $files[i];

							var fileReader = new FileReader();
							fileReader.readAsDataURL($files[i]);
							var loadFile = function (fileReader, index) {
								fileReader.onload = function (e) {
									$timeout(function () {
										$scope.files.push({
											doc: {
												file: $files[index],
												file_data: e.target.result,
												uploaded: false
											},
											data: JSON.stringify({
												year: dataSvc.selectedYear
											}),
											currentProgress: 0,
											completed: false
										});
										uploadDocument();
									});
								}
							}(fileReader, i);
						}

					};

					$scope.onFileSelectWC = function ($files) {
						$scope.files = [];
						for (var i = 0; i < $files.length; i++) {
							var $file = $files[i];

							var fileReader = new FileReader();
							fileReader.readAsDataURL($files[i]);
							var loadFile = function (fileReader, index) {
								fileReader.onload = function (e) {
									$timeout(function () {
										$scope.files.push({
											doc: {
												file: $files[index],
												file_data: e.target.result,
												uploaded: false
											},
											data: JSON.stringify({
												importMap: $scope.importMap
											}),
											currentProgress: 0,
											completed: false
										});
										uploadDocumentWC();
									});
								}
							}(fileReader, i);
						}

					};
					$scope.companyMisMatch = function() {
						var counter = 0;
						$.each($scope.list, function(ind, c) {
							if (!c.stateEin && c.edd)
								counter++;
						});
						return counter;
					}
					$scope.defaultRateCount = function () {
						var counter = 0;
						$.each($scope.list, function (ind, c) {
							if ((!c.uiRate && c.defaultUiRate) || (!c.ettRate && c.defaultEttRate))
								counter++;
						});
						return counter;
					}
					var uploadDocument = function () {
						companyRepository.importTaxRates($scope.files[0]).then(function (taxRates) {
							$scope.list = angular.copy(taxRates);
							dataSvc.importInProcess = true;
						}, function (error) {
							addAlert('error in importing tax rates for companies: ' + error, 'danger');

						});


					}
					var uploadDocumentWC = function () {
						companyRepository.importWCRates($scope.files[0]).then(function (wcRates) {
							$scope.listWCRates = angular.copy(wcRates);
							dataSvc.importInProcessWC = true;
						}, function (error) {
							addAlert('error in importing wc rates for clients: ' + error, 'danger');

						});


					}
					$scope.removeWC = function(wc, index) {
						$scope.listWCRates.splice(index, 1);
					}
					$scope.uploadWCRates = function() {
						$scope.$parent.$parent.confirmDialog('this will update all matching valid WC rates, do you wish to continue?', 'danger', function () {
							companyRepository.uploadWCRates($scope.listWCRates).then(function (timesheets) {

								addAlert('successfully updated WC Rates in the system', 'success');

								$scope.listWCRates = [];
								dataSvc.importInProcessWC = false;
							}, function (error) {
								addAlert(error, 'danger');

							});
						});
					}
					var _init = function () {
						$scope.mainData.showFilterPanel = false;
						var currentYear = new Date().getFullYear();
						companyRepository.getCompanyMetaData().then(function (data) {
							dataSvc.companyMetaData = data;
							for (var i = currentYear - 4; i <= currentYear + 1; i++) {
								var taxes = $filter('filter')(dataSvc.companyMetaData.taxes, { taxYear: i });
								if (i >= dataSvc.minYear && taxes.length>0)
									dataSvc.years.push(i);
							}
						}, function (error) {
							addAlert('error getting meta data', 'danger');
						});
						
						
					}
					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						filter: {
							name: '',       // initial filter
						},
						sorting: {
							name: 'asc'     // initial sorting
						}
					}, {
						total: $scope.companyScheduleList ? $scope.companyScheduleList.length : 0, // length of data
						getData: function (params) {
							$scope.fillTableData(params);
							return $scope.tableData;
						}
					});
					//if ($scope.tableParams.settings().$scope == null) {
					//	$scope.tableParams.settings().$scope = $scope;
					//}
					$scope.fillTableData = function (params) {
						// use build-in angular filter
						if ($scope.companyScheduleList && $scope.companyScheduleList.length > 0) {
							var orderedData = params.filter() ?
																$filter('filter')($scope.companyScheduleList, params.filter()) :
																$scope.companyScheduleList;

							orderedData = params.sorting() ?
														$filter('orderBy')(orderedData, params.orderBy()) :
														orderedData;

							$scope.tableParams = params;
							$scope.tableData = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count());

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					$scope.loadCompaniesForSchedules = function() {
						companyRepository.getCompanyListAll().then(function (result) {
							$scope.companyScheduleList = result;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
						}, function (error) {
							addAlert('error in getting company list', 'danger');
						});
					}
					$scope.tableDataSWE = [];
					$scope.tableParamsSWE = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						
					}, {
						total: $scope.semiWeeklyEligibilityReport && $scope.semiWeeklyEligibilityReport.data ? $scope.semiWeeklyEligibilityReport.data.hosts.length : 0, // length of data
						getData: function (params) {
							$scope.fillTableDataSWE(params);
							return $scope.tableDataSWE;
						}
					});
					//if ($scope.tableParams.settings().$scope == null) {
					//	$scope.tableParams.settings().$scope = $scope;
					//}
					$scope.fillTableDataSWE = function (params) {
						// use build-in angular filter
						if ($scope.semiWeeklyEligibilityReport && $scope.semiWeeklyEligibilityReport.data.hosts.length > 0) {
							var orderedData = params.filter() ?
																$filter('filter')($scope.semiWeeklyEligibilityReport.data.hosts, params.filter()) :
																$scope.semiWeeklyEligibilityReport.data.hosts;

							orderedData = params.sorting() ?
														$filter('orderBy')(orderedData, params.orderBy()) :
														orderedData;

							$scope.tableParamsSWE = params;
							$scope.tableDataSWE = orderedData;

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					$scope.loadSemiWeeklyEligibilityReport = function () {
						reportRepository.getExtract({ reportName: 'SemiWeeklyEligibility', depositSchedule: $scope.depositSchedule, yearlyLimit: $scope.yearlyLimit, quarterlyLimit: $scope.quarterlyLimit }).then(function (result) {
							$scope.semiWeeklyEligibilityReport = result;
							$scope.tableParamsSWE.reload();
							$scope.fillTableDataSWE($scope.tableParamsSWE);
						}, function (error) {
							addAlert('error in getting semi weekly eligibility list', 'danger');
						});
					}
					$scope.loadMinWageEligibilityReport = function () {
						reportRepository.getMinWageEligibilityReport(dataSvc.minWageCriteria).then(function (result) {
							$scope.minWageEligibilityReport = result;
							dataSvc.loadedMinWageEligibilityCriteria = angular.copy(dataSvc.minWageCriteria);

						}, function (error) {
							addAlert('error in getting min Wage eligibility list', 'danger');
						});
					}
					$scope.showRaiseMinWage = function() {
						return angular.equals(dataSvc.minWageCriteria, dataSvc.loadedMinWageEligibilityCriteria);
					}
					$scope.print = function () {
						$window.print();
					}
					$scope.raiseMinWage = function () {
						var message = 'Min Wage to ' + dataSvc.minWageCriteria.minWage + " for all";
						message += (dataSvc.minWageCriteria.statusId === 1 ? " Active" : dataSvc.minWageCriteria.statusId === 2 ? " In Active" : dataSvc.minWageCriteria.statusId === 3 ? " Terminated" : "");
						message += (dataSvc.minWageCriteria.contractType === 0 ? " ASO" : dataSvc.minWageCriteria.contractType === 1 ? " PEO" : "") + " companies";
						if (dataSvc.minWageCriteria.city)
							message += " in the city of " + dataSvc.minWageCriteria.city;

						$scope.$parent.$parent.confirmDialog('This action will RAISE ' + message + '. Are you sure you want to continue?', 'info', function () {
							companyRepository.raiseMinWage(dataSvc.minWageCriteria).then(function () {

								addAlert('Successfully raised ' + message, 'success');
								$scope.loadMinWageEligibilityReport();

							}, function (error) {
								addAlert('error in raising min Wage. ' + error.statusText , 'danger');
							});
						});

						
					}
					_init();


				}]
		}
	}
]);
