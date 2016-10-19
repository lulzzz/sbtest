'use strict';

common.directive('payrollList', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/payroll-list.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'ngTableParams', 'EntityTypes', 'payrollRepository', '$anchorScroll','anchorSmoothScroll',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, payrollRepository, $anchorScroll, anchorSmoothScroll) {
					var dataSvc = {
						sourceTypeId: EntityTypes.Employee,
						isBodyOpen: true,
						
						payTypes: [],
						payrollAccount: null,
						hostPayrollAccount: null,
						employees: [],
						startingCheckNumber: 0
					}
					$scope.list = [];
					

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
									overtimeHours: 0,
									pwAmount: 0
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
							selected.startDate = moment(sorted[0].endDate).add(1, 'day').toDate();

							if ($scope.mainData.selectedCompany.payrollSchedule === 1) {
								selected.endDate = moment(selected.startDate).add(1, 'week').toDate();
								selected.payDay = moment(sorted[0].payDay).add(1, 'week').toDate();
							}
							else if ($scope.mainData.selectedCompany.payrollSchedule === 2) {
								selected.endDate = moment(selected.startDate).add(2, 'week').toDate();
								selected.payDay = moment(sorted[0].payDay).add(2, 'week').toDate();
							}
							else if ($scope.mainData.selectedCompany.payrollSchedule === 3) {
								if (moment(selected.startDate).date() === 1) {
									selected.endDate = moment(selected.startDate).add(14, 'day').toDate();
									selected.payDay = moment(sorted[0].payDay).add(15, 'day').toDate();
								} else {
									selected.endDate = moment(selected.startDate).endOf('month').toDate();
									selected.payDay = moment(sorted[0].startDate).endOf('month').toDate();
								}
								
							} else {
								selected.endDate = moment(selected.startDate).add(1, 'month').toDate();
								selected.payDay = moment(sorted[0].payDay).add(1, 'month').toDate();
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
						$scope.selectedInvoice = null;
						$scope.data.isBodyOpen = true;
					}
					$scope.updateListAndItem = function (selectedItemId) {
						getPayrolls($scope.mainData.selectedCompany.id, null, null, selectedItemId);
						getCompanyPayrollMetaData($scope.mainData.selectedCompany.id);
					}
					$scope.updateStatus = function(checkid, status, statusText) {
						var item = $filter('filter')($scope.committed.payChecks, { id: checkid })[0];
						if (item) {
							item.status = status;
							item.statusText = statusText;
						}
						var payrollInList = $filter('filter')($scope.list, { id: $scope.committed.id })[0];
						var pc = $filter('filter')(payrollInList.payChecks, { id: checkid })[0];
						if (pc) {
							item.status = status;
							item.statusText = statusText;
						}
					}
					$scope.updatePrintStatus = function () {
						var item = $filter('filter')($scope.list, { id: $scope.committed.id })[0];
						item.status = item.status === 3 ? 5 : item.status;
						item.statusText = item.status === 5 ? "Printed" : item.statusText;
						$.each(item.payChecks, function (index, p) {
							if (p.status === 3 || p.status === 5) {
								var status = p.status === 3 ? 4 : 6;
								var statusText = p.status === 4 ? "Paid" : "Printed and Paid";
								$scope.updateStatus(p.id, status, statusText);
							}
							
						});
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
					}

					$scope.set = function (item) {
						$scope.selected = null;
						$scope.processed = null;
						$scope.committed = null;
						$scope.selectedPayCodes = [];
						if(item){
							$timeout(function () {
								if(item.status===1)
									$scope.selected = item;
								else if (item.status === 2)
									$scope.processed = angular.copy(item);
								else if (item.status > 2)
									$scope.committed = angular.copy(item);
							
							}, 1);
						}

					}
					
					
					$scope.canRunPayroll = function() {
						var c = $scope.mainData.selectedCompany;
						var hostcomp = $scope.mainData.selectedHost.company;
						if ($scope.selected || $scope.processed || $scope.committed || !dataSvc.payrollAccount || dataSvc.employees.length == 0 || (c.contract.billingOption===3 && !c.contract.invoiceSetup) || (c.contract.billingOption===3 && c.contract.invoiceSetup && c.contract.invoiceSetup.invoiceType === 1 && !dataSvc.hostPayrollAccount))
							return false;
						else {
							return true;
						}
					}
					$scope.requiresHostPayrollAccount = function() {
						var c = $scope.mainData.selectedCompany;
						
						if (c.contract.billingOption===3 && c.contract.invoiceSetup && c.contract.invoiceSetup.invoiceType===1 && !dataSvc.hostPayrollAccount)
							return true;
						else {
							return false;
						}
					}
					$scope.requiresCompanyPayrollAccount = function() {
						var c = $scope.mainData.selectedCompany;
						if (!dataSvc.payrollAccount)
							return true;
						else {
							return false;
						}
					}
					var getCompanyPayrollMetaData = function(companyId) {
						companyRepository.getPayrollMetaData(companyId).then(function (data) {
							dataSvc.payTypes = data.payTypes;
							dataSvc.payrollAccount = data.payrollAccount;
							dataSvc.hostPayrollAccount = data.hostPayrollAccount;
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
							} else {
								$scope.set(null);
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
					$scope.showInvoices = function() {
						var comp = $scope.mainData.selectedCompany;
						if (comp && comp.contract.contractOption === 2 && comp.contract.billingOption === 3 && comp.contract.invoiceSetup) {
							return true;
						} else {
							return false;
						}
					}
					
					$scope.viewInvoice = function($event, payroll) {
						$event.stopPropagation();
						$scope.selectedInvoice = payroll.invoice;
						$timeout(function () {
							$location.hash("invoice");
							anchorSmoothScroll.scrollTo('invoice');
						});
					}
					$scope.updateSelectedInvoice = function (invoice) {
						var match = $filter('filter')($scope.list, { invoice: { id: invoice.id } })[0];
						if (match) {
							match.invoice = invoice;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
						}
						
					}
					$scope.deleteInvoice = function (invoice) {
						var match = $filter('filter')($scope.list, { invoice: { id: invoice.id } })[0];
						if (match) {
							match.invoice = null;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
						}
						$scope.cancel();
					}
					$scope.createInvoice = function ($event, payroll) {
						$event.stopPropagation();
						var match = $filter('filter')($scope.list, { id: payroll.id })[0];
						match.company = $scope.mainData.selectedCompany;
						payrollRepository.createPayrollInvoice(match, $scope.mainData.selectedCompany).then(function (data) {
							payroll.invoice = data;
							$scope.addAlert('successfully created invoice', 'success');
						}, function (error) {
							$scope.addAlert('error generating invoice', 'danger');
						});
					}

					
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
