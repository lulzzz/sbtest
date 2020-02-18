'use strict';

common.directive('scheduledPayroll', ['$uibModal', 'zionAPI', '$timeout', '$window', 'version',
	function ($modal, zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				item: "=item",
				datasvc: "=datasvc",
				company: "=company",
				mainData: "=mainData"

			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/scheduled-payroll.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'NgTableParams', 'EntityTypes', 'payrollRepository',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, payrollRepository) {
					var dataSvc = {
						payTypes: $scope.datasvc.payTypes,
						employees: $scope.datasvc.employees,
						payTypeFilter: 0,
						toggleState: false,
						tabindex: 1,
						showingErrors: false,
						showingWarnings: false,
						showingSelected: false,
						showWCWarnings: false,
						importInProgress: false,
						showAllEmployees: false,
				}
					
					$scope.list = [];
					$scope.maindata = $scope.$parent.$parent.mainData;
					$scope.data = dataSvc;
					$scope.cancel = function() {
						$scope.$parent.$parent.selected = null;
						$scope.$parent.$parent.data.isBodyOpen = true;
					}


					$scope.host = $scope.$parent.$parent.mainData.selectedHost;
					$scope.paytypes = [
						{ id: 1, title: 'Hourly' }, { id: 2, title: 'Salary' }, { id: 3, title: 'Piece-work' }
					];
					$scope.tableData = [];
					var blank = '';
					$scope.tableParams = new ngTableParams({
						count: $scope.list ? $scope.list.length : 0,
						
						sorting: {
							companyEmployeeNo: 'asc'     // initial sorting
						}
					}, {
						total: $scope.list ? $scope.list.length : 0, // length of data
						getData: function (params) {
							$scope.fillTableData(params);
							return $scope.tableData;
						}
					});
					if ($scope.tableParams.settings().$scope == null) {
						$scope.tableParams.settings().$scope = $scope;
					}
					$scope.fillTableData = function (params) {
						// use build-in angular filter
						if ($scope.list && $scope.list.length > 0) {
							var fil = params.filter();
							if (params.filter.hasWCWarning)
								fil.hasWCWarning = true;
							else
								delete fil.hasWCWarning;
							if (params.filter.hasError)
								fil.hasError = true;
							else
								delete fil.hasError;
							if (params.filter.hasWarning)
								fil.hasWarning = true;
							else
								delete fil.hasWarning;

							var orderedData = fil ?
																$filter('filter')($scope.list, fil) :
																$scope.list;
							
							orderedData = params.sorting() ?
														$filter('orderBy')(orderedData, params.orderBy()) :
														orderedData;
							$scope.tableParams = params;
							
							//$scope.tableData = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count());
							$scope.tableData = orderedData;

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					$scope.showErrors =function() {
						if (dataSvc.showingErrors) {
							delete $scope.tableParams.filter.hasError;
						} else {
							$scope.tableParams.filter.hasError = true;
						}
						dataSvc.showingErrors = !dataSvc.showingErrors;
						$scope.fillTableData($scope.tableParams);
					}
					$scope.showWarnings = function () {
						if (dataSvc.showingWarnings) {
							delete $scope.tableParams.filter.hasWarning;
						} else {
							$scope.tableParams.filter.hasWarning = true;
						}
						dataSvc.showingWarnings = !dataSvc.showingWarnings;
						$scope.fillTableData($scope.tableParams);
					}
					$scope.showWCWarnings = function () {
						if (dataSvc.showingWCWarnings) {
							delete $scope.tableParams.filter.hasWCWarning;
						} else {
							$scope.tableParams.filter.hasWCWarning = true;
						}
						dataSvc.showingWCWarnings = !dataSvc.showingWCWarnings;
						$scope.fillTableData($scope.tableParams);
					}
					$scope.erroneousChecks = function() {
						var checks = $filter('filter')($scope.list, { included: true, hasError: true });
						return checks.length;
					}
					$scope.warningChecks = function () {
						var checks = $filter('filter')($scope.list, { included: true, hasWarning: true });
						return checks.length;
					}
					$scope.wcWarningChecks = function () {
						var checks = $filter('filter')($scope.list, { included: true, hasWCWarning: true });
						return checks.length;
					}
					
					$scope.correctChecks = function () {
						var checks = $filter('filter')($scope.list, { included: true });
						return checks.length;
					}
					$scope.removePayCheck = function(listitem) {
						var pc = $filter('filter')($scope.list, { employee: { id: listitem.employee.id } })[0];
						if (pc) {
							$scope.list.splice($scope.list.indexOf(pc), 1);
						}
						$scope.tableData.splice($scope.tableData.indexOf(listitem), 1);
					}
					$scope.includeAll = function () {
						
						$.each($scope.tableData, function (index, p) {
							var li = $filter('filter')($scope.list, { employee: { id: p.employee.id } })[0];
							if (li) {

								li.included = !dataSvc.toggleState;
								p.included = !dataSvc.toggleState;
								
							}
							
						});
						dataSvc.toggleState = !dataSvc.toggleState;
					}
					$scope.itemIncluded = function(pc) {
						pc.userActioned = true;

					}
					
					
					$scope.process = function () {
						$scope.item.startDate = moment($scope.item.startDate).format("MM/DD/YYYY");
						$scope.item.endDate = moment($scope.item.startDate).format("MM/DD/YYYY");
						$scope.item.payDay = moment($scope.item.payDay).format("MM/DD/YYYY");
						$scope.item.taxPayDay = $scope.item.payDay;
						$scope.$parent.$parent.save($scope.item, $filter('filter')($scope.item.payChecks, { included: true }, false).length);
						
					}
					
					$scope.isPayrollInvalid = function () {
						var returnVal = false;
						var includedChecks = 0;
						$.each($scope.item.payChecks, function (index1, paycheck) {
							if (paycheck.included) {
								includedChecks++;
								if ($scope.isPayCheckInvalid(paycheck)) {
									returnVal = true;
									return returnVal;
								}
							}
							
						});
						if (includedChecks === 0)
							returnVal = true;
						
						return returnVal;
					}
					var calculateHours = function (val) {
						if (!val)
							return 0;
						else if ($.isNumeric(val))
							return parseFloat(val);
						else {
							if (val && val.includes(":")) {
								var splits = val.split(':');
								if (!$.isNumeric(splits[0]) || !$.isNumeric(splits[1])) {
									return 0;
								} else {
									var h = parseInt(splits[0]);
									var m = parseInt(splits[1]);
									if (m > 59)
										return 0;
									return h + +(m / 60).toFixed(2);
								}
							}
						}
					}
					$scope.isPayCheckInvalid = function (pc) {
						var original = $filter('filter')($scope.originals, { employee: { id: pc.employee.id } })[0];
						var orignalcopy = angular.copy(original);
						orignalcopy.included = pc.included;
						orignalcopy.hasWCWarning = pc.hasWCWarning;
						orignalcopy.hasError = pc.hasError;
						orignalcopy.hasWarning = pc.hasWarning;
						if (!pc.included && !pc.userActioned && orignalcopy && !angular.equals(pc, orignalcopy)) {
							pc.included = true;
						}
						var pwAmount = -1;
						var returnVal = false;
						var salary = pc.salary;
						var payCodeSum = 0;
						var comps = 0;
						if (!pc.included) {
							pc.hasWarning = false;
							return pc.hasError = false ;
						}
						pc.hasWarning = false;
						$.each(pc.payCodes, function (index1, paycode) {
							paycode.hours = calculateHours(paycode.screenHours);
							paycode.overtimeHours = calculateHours(paycode.screenOvertime);
							payCodeSum += (paycode.hours + paycode.overtimeHours);
							if (paycode.payCode.id >= 0 && paycode.payCode.hourlyRate < $scope.company.minWage && (paycode.hours > 0 || paycode.overtimeHours > 0)) {
								if (paycode.payCode.hourlyRate <= 0) {
									pwAmount = 0;
									return;
								}
								pc.hasWarning = true;
							}
							if (paycode.payCode.id === -1 && ((paycode.pwAmount <= 0 && (paycode.hours > 0 || paycode.overtimeHours > 0)) || (paycode.pwAmount > 0 && paycode.hours <= 0 && paycode.overtimeHours <= 0))) {
								payCodeSum = pwAmount = 0;
								return;
							}
							
						});
						if (pwAmount === 0) {
							return pc.hasError = true;
						}
						$.each(pc.compensations, function (index1, comp) {
							comps += comp.amount;
						});
						var gross = salary + payCodeSum + comps;
						if (!gross || gross <= 0)
							returnVal = true;
						else {
							returnVal = false;
						}

						return pc.hasError=returnVal;
					}
					$scope.showList = function () {
						var returnVal = false;
						if ($scope.list.length > 0 && $scope.item.startDate && $scope.item.payDay && $scope.item.paySchedule )
							returnVal = true;

						else
							returnVal = false;

						return returnVal;
					}
					$scope.showcomps = function(listitem) {
						var modalInstance = $modal.open({
							templateUrl: 'popover/updatecomps1.html',
							controller: 'updateCompsCtrl',
							size: 'md',
							windowClass: 'my-modal-popup',
							resolve: {
								paycheck: function() {
									return listitem;
								},
								paytypes: function() {
									return dataSvc.payTypes;
								}
							}
						});
					}
					$scope.showjobcost = function (listitem) {
						var modalInstance = $modal.open({
							templateUrl: 'popover/updatejobcost.html',
							controller: 'updateJobCostCtrl',
							size: 'sm',
							resolve: {
								paycheck: function () {
									return listitem;
								}
							}
						});
					}
					$scope.showdeds = function (listitem) {
						var modalInstance = $modal.open({
							templateUrl: 'popover/updatededs.html',
							controller: 'updateDedsCtrl',
							size: 'lg',
							windowClass: 'my-modal-popup',
							resolve: {
								paycheck: function () {
									return listitem;
								},
								companydeductions: function () {
									return $scope.company.deductions;
								},
								agencies: function() {
									return $scope.datasvc.agencies;
								},
								companyRepository: function() {
									return companyRepository;
								}
							}
						});
						modalInstance.result.then(function (dedscope) {
							listitem.deductions = dedscope.original.deductions;

						}, function () {
							return false;
						});
					}

					$scope.showemployee = function (listitem) {
						var modalInstance = $modal.open({
							templateUrl: 'popover/employee.html',
							controller: 'employeeCtrl',
							size: 'lg',
							windowClass: 'my-modal-popup',
							backdrop: true,
							keyboard: true,
							backdropClick: true,
							resolve: {
								paycheck: function () {
									return listitem;
								},
								mainData: function() {
									return $scope.$parent.$parent.mainData;
								}
							}
						});
						modalInstance.result.then(function (paycheck, result) {
							$scope.$parent.$parent.updateEmployeeList(paycheck.employee);
							
						}, function () {
							return false;
						});
					}
					$scope.showcompany = function () {
						var modalInstance = $modal.open({
							templateUrl: 'popover/company.html',
							controller: 'companyCtrl',
							size: 'lg',
							windowClass: 'my-modal-popup',
							backdrop  : 'static',
							keyboard: false,
							backdropClick: true,
							resolve: {
								invoice: function () {
									return $scope.item;
								},
								mainData: function () {
									return $scope.$parent.$parent.mainData;
								}
							}
						});
						modalInstance.result.then(function (result) {
							$scope.item.company = $scope.$parent.$parent.mainData.selectedCompany;
							$.each($scope.item.company.payCodes, function(ind, pc) {
								$.each($scope.item.payChecks, function (ind1, check) {
									var empPayCode = $filter('filter')(check.employee.payCodes, { payCode: { id: pc.id } })[0];
									if (empPayCode) {
										check.employee.payCodes.splice(check.employee.payCodes.indexOf(empPayCode), 1);
										check.employee.payCodes.push(pc);
									}
									var pcPayCode = $filter('filter')(check.payCodes, { payCode: { id: pc.id } })[0];
									if (pcPayCode) {
										pcPayCode.payCode = pc;
									}
								});
							});
							$scope.list = $scope.item.payChecks;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							$scope.$parent.$parent.updateEmployeeList(null);
						}, function () {
							return false;
						});
						
					}

					$scope.importTimesheet = function () {
						dataSvc.importInProgress = true;
						var modalInstance = $modal.open({
							templateUrl: 'popover/importtimesheet.html',
							controller: 'importTimesheetCtrl',
							size: 'lg',
							windowClass: 'my-modal-popup',
							backdrop: true,
							keyboard: true,
							backdropClick: true,
							resolve: {
								company: function () {
									return $scope.company;
								},
								payTypes: function() {
									return dataSvc.payTypes;
								},
								payChecks: function() {
									return $scope.item.payChecks;
								},
								payrollRepository: function () {
									return payrollRepository;
								},
								map: function() {
									return $scope.datasvc.importMap;
								},
								main: function() {
									return $scope.$parent.$parent;
								},
								mainData: function () {
									return $scope.mainData;
								}
							}
						});
						modalInstance.result.then(function (scope) {
							dataSvc.toggleState = true;
							$scope.datasvc.importMap = scope.importMap;
							$scope.item.payChecks = angular.copy(scope.payChecks);
							$scope.list = $scope.item.payChecks;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							if (scope.messages.length > 0) {
								var warning = 'No Matching Employees found for # ';
								$.each(scope.messages, function(i, m) {
									warning += m + ', ';
								});
								$scope.mainData.showMessage(warning, 'warning');
							}
							dataSvc.importInProgress = false;
						}, function () {
							dataSvc.importInProgress = false;
							return false;
						});
					}

					$scope.files = [];
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
												companyId: $scope.item.company.id,
												payTypes: dataSvc.payTypes
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
					$scope.getTimesheetmportTemplate = function () {
						payrollRepository.getTimesheetImportTemplate($scope.item.company.id, dataSvc.payTypes).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();

						}, function (error) {
								$scope.mainData.showMessage('error getting timesheet import template', 'danger');
						});
					}
					
					var init = function () {
						$scope.originals = angular.copy($scope.item.payChecks);
						$scope.list = $scope.item.payChecks;
						//$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						$scope.datasvc.isBodyOpen = false;
						$scope.minPayDate = moment().add(1, 'days').startOf('day');
						
					}
					init();


				}]
		}
	}
]);
