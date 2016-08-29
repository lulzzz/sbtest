'use strict';

common.directive('payrollList', ['$modal', 'zionAPI', '$timeout', '$window',
	function ($modal, zionAPI, $timeout, $window) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/payroll-list.html',

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'ngTableParams', 'EntityTypes', 'payrollRepository',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, payrollRepository) {
					var dataSvc = {
						sourceTypeId: EntityTypes.Employee,
						isBodyOpen: true,
						opened: false,
						opened1: false,
						opened2: false,
						payTypes: [],
						payrollAccount: null,
						employees: [],
						startingCheckNumber: 0
					}
					$scope.list = [];
					$scope.dateOptions = {
						format: 'dd/MMyyyy',
						startingDay: 1
					};

					$scope.today = function () {
						$scope.dt = new Date();
					};
					$scope.today();

					$scope.clear = function () {
						$scope.dt = null;
					};
					$scope.open = function ($event) {
						$event.preventDefault();
						$event.stopPropagation();
						$scope.data.opened = true;
					};
					
					$scope.open1 = function ($event) {
						$event.preventDefault();
						$event.stopPropagation();
						$scope.data.opened1 = true;
					};

					$scope.open2 = function ($event) {
						$event.preventDefault();
						$event.stopPropagation();
						$scope.data.opened2 = true;
					};

					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;


					$scope.addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					
					$scope.selected = null;


					$scope.add = function () {
						var selected = {
							company: $scope.mainData.selectedCompany,
							startDate: null,
							endDate: null,
							payDay: null,
							payChecks: [],
							startingCheckNumber: dataSvc.startingCheckNumber,
							status: 1
						};
						$.each(dataSvc.employees, function (index, employee) {
							var paycheck = {
								id: 0,
								employeeNo: employee.employeeNo,
								name: employee.name,
								department: employee.department,
								employee: employee,
								payCodes: [],
								salary: employee.payType===2 ? employee.rate : 0,
								compensations: [],
								deductions: [],
								isVoid: false,
								status: 1,
								memo:''
							};
							$.each(employee.payCodes, function(index1, paycode) {
								var pc = {
									payCode: paycode,
									hours: 0,
									overtimeHours: 0
								};
								paycheck.payCodes.push(pc);
							});
							$.each(employee.compensations, function (index2, comp) {
								var pt = {
									payType: comp.payType,
									amount: comp.amount,
									ytd: 0
								}
								paycheck.compensations.push(pt);
							});
							$.each(employee.deductions, function (index3, ded) {
								paycheck.deductions.push({
									deduction: ded.deduction,
									rate: ded.rate,
									annualMax: ded.annualMax,
									method: ded.method,

									amount: 0,
									ytd: 0
								});
							});
							selected.payChecks.push(paycheck);
						});
						if ($scope.list.length > 0) {
							var sorted = $filter('orderBy')($scope.list, 'endDate', true);
							selected.startDate = moment(sorted[0].endDate).add(1, 'day');

							if ($scope.mainData.selectedCompany.payrollSchedule === 1) {
								selected.endDate = moment(selected.startDate).add(1, 'week');
								selected.payDay = moment(sorted[0].payDay).add(1, 'week');
							}
							else if ($scope.mainData.selectedCompany.payrollSchedule === 2) {
								selected.endDate = moment(selected.startDate).add(2, 'week');
								selected.payDay = moment(sorted[0].payDay).add(2, 'week');
							}
							else if ($scope.mainData.selectedCompany.payrollSchedule === 3) {
								if (moment(selected.startDate).date() === 1) {
									selected.endDate = moment(selected.startDate).add(14, 'day');
									selected.payDay = moment(sorted[0].payDay).add(15, 'day');
								} else {
									selected.endDate = moment(selected.startDate).endOf('month');
									selected.payDay = moment(sorted[0].startDate).endOf('month');
								}
								
							} else {
								selected.endDate = moment(selected.startDate).add(1, 'month');
								selected.payDay = moment(sorted[0].payDay).add(1, 'month');
							}
								

						}
						$scope.set(selected);
					}
				
					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						sorting: {
							payDay: 'desc'     // initial sorting
						}
					}, {
						total: $scope.list ? $scope.list.length : 0, // length of data
						getData: function ($defer, params) {
							$scope.fillTableData(params);
							$defer.resolve($scope.tableData);
						}
					});

					$scope.fillTableData = function (params) {
						// use build-in angular filter
						if ($scope.list && $scope.list.length > 0) {
							var orderedData = params.filter() ?
																$filter('filter')($scope.list, params.filter()) :
																$scope.list;

							orderedData = params.sorting() ?
														$filter('orderBy')(orderedData, params.orderBy()) :
														orderedData;

							$scope.tableParams = params;
							$scope.tableData = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count());

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					$scope.cancel = function () {
						$scope.selected = null;
						$scope.data.isBodyOpen = true;
					}
					$scope.updateListAndItem = function (selectedItemId) {
						getPayrolls($scope.mainData.selectedCompany.id, null, null, selectedItemId);
						getCompanyPayrollMetaData($scope.mainData.selectedCompany.id);
					}
				

					$scope.set = function (item) {
						$scope.selected = null;
						$scope.processed = null;
						$scope.committed = null;
						$scope.selectedPayCodes = [];
						$timeout(function () {
							if(item.status===1)
								$scope.selected = item;
							else if (item.status === 2)
								$scope.processed = angular.copy(item);
							else if (item.status === 3 || item.status === 4)
								$scope.committed = angular.copy(item);
							
						}, 1);

					}
					
					$scope.save = function () {
						
					}
					$scope.canRunPayroll = function() {
						if ($scope.selected || $scope.processed || $scope.committed || !dataSvc.payrollAccount || dataSvc.employees.length == 0)
							return false;
						else {
							return true;
						}
					}
					var getCompanyPayrollMetaData = function(companyId) {
						companyRepository.getPayrollMetaData(companyId).then(function (data) {
							dataSvc.payTypes = data.payTypes;
							dataSvc.payrollAccount = data.payrollAccount;
							dataSvc.startingCheckNumber = data.startingCheckNumber;
						}, function (error) {
							$scope.addAlert('error getting payroll meta data', 'danger');
						});
					}

					var getPayrolls = function (companyId, startDate, endDate, selectedItemId) {
						payrollRepository.getPayrollList(companyId, startDate, endDate).then(function (data) {
							$scope.list = data;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							$scope.selected = null;
							if (selectedItemId) {
								var match = $filter('filter')($scope.list, { id: selectedItemId })[0];
								if (match)
									$scope.set(match);
							}
						}, function (error) {
							$scope.addAlert('error getting payrolls', 'danger');
						});
					}
					var getEmployees = function (companyId) {
						companyRepository.getEmployees(companyId).then(function (data) {
							dataSvc.employees = data;
						}, function (erorr) {
							$scope.addAlert('error getting employee list', 'danger');
						});
					}
					$scope.$watch('mainData.selectedCompany',
						 function (newValue, oldValue) {
						 	if (newValue !== oldValue) {
						 		getCompanyPayrollMetaData($scope.mainData.selectedCompany.id);
						 		getEmployees($scope.mainData.selectedCompany.id);
						 		getPayrolls($scope.mainData.selectedCompany.id);
						 	}

						 }, true
				 );
					
					var init = function () {
						
						if ($scope.mainData.selectedCompany) {
							getCompanyPayrollMetaData($scope.mainData.selectedCompany.id);
							getEmployees($scope.mainData.selectedCompany.id);
							getPayrolls($scope.mainData.selectedCompany.id, null, null);

						}
						

					}
					init();


				}]
		}
	}
]);
