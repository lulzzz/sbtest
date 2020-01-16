'use strict';

common.directive('scheduledPayrollList', ['zionAPI', '$timeout', '$window', 'version','$q',
	function (zionAPI, $timeout, $window, version, $q) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/scheduled-payroll-list.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'NgTableParams', 'EntityTypes', 'payrollRepository', '$anchorScroll', '$uibModal','anchorSmoothScroll', '$interval', 'ClaimTypes',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, payrollRepository, $anchorScroll, $modal, anchorSmoothScroll, $interval, ClaimTypes) {
					var dataSvc = {
						sourceTypeId: EntityTypes.Employee,
						isBodyOpen: true,
						metaDataLoaded: false,
						employeesLoaded: false,
						payTypes: [],
						payrollAccount: null,
						hostPayrollAccount: null,
						employees: [],
						agencies: [],
						startingCheckNumber: 0,
						importMap: null,
						queuedPayroll: null,
						queuedInterval: null,
						reportFilter: {
							filterStartDate: moment().add(-2, 'week').toDate(),
							filterEndDate: null,
							filter: {
								startDate: moment().add(-2, 'week').toDate(),
								endDate: null,
								years: [],
								month: 0,
								year: 0,
								quarter: 0
							}
						},
						showInvoice: $scope.mainData.hasClaim(ClaimTypes.InvoiceList, 1),
						showVoidPayroll: $scope.mainData.hasClaim(ClaimTypes.PayrollVoid, 1),
						showVoidPaycheck: $scope.mainData.hasClaim(ClaimTypes.PayrollVoidPayCheck, 1),
						showUnVoidPaycheck: $scope.mainData.hasClaim(ClaimTypes.PayrollUnVoidCheck, 1),
						showChangePayrollDates: $scope.mainData.hasClaim(ClaimTypes.PayrollUpdatePayCycleDates, 1),
						showChangeCheckNumbers: $scope.mainData.hasClaim(ClaimTypes.PayrollChangeCheckNumberseries, 1),
						showFixYTD: $scope.mainData.hasClaim(ClaimTypes.PayrollFixYTDs, 1),
						showEditableTaxes: $scope.mainData.hasClaim(ClaimTypes.PayrollEditableTaxes, 1),
						showDeletePayroll: $scope.mainData.hasClaim(ClaimTypes.PayrollDelete, 1),
						canRunHistoryPayroll: $scope.mainData.hasClaim(ClaimTypes.PayrollHistoryPayroll, 1),
						canConfirm: $scope.mainData.hasClaim(ClaimTypes.PayrollConfirm, 1),
						canReProcessReConfirm: $scope.mainData.hasClaim(ClaimTypes.PayrollReProcessReConfirm, 1),
						canACHEmail: $scope.mainData.hasClaim(ClaimTypes.PayrollACHPackEmail, 1)
				}
					$scope.list = [];
					$scope.maxPayDay = null;
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;


					$scope.selected = null;
					

					var addNew = function() {
						var selected = {
							id: 0,
							scheduleStartDate: null,
							payDateStart: null,
							lastPayrollDate: null,
							status: 1,
							companyId: $scope.mainData.selectedCompany.id,
							paySchedule: null,
							lastModified: null,
							lastModifiedBy: null,
							data: {
								company: $scope.mainData.selectedCompany,
								startDate: null,
								endDate: null,
								payDay: null,
								payChecks: [],
								startingCheckNumber: dataSvc.startingCheckNumber,
								status: 1
							}
						};
						$.each(dataSvc.employees, function (index, employee) {
							var paycheck = {
								id: 0,
								employeeNo: employee.employeeNo ? parseInt(employee.employeeNo) : employee.employeeNo,
								companyEmployeeNo: employee.companyEmployeeNo,
								name: employee.name,
								payType: employee.payType,
								department: employee.department ? employee.department : '',
								employee: employee,
								payCodes: [],
								salary: employee.payType === 2 || employee.payType === 4 ? employee.rate : 0,
								compensations: [],
								deductions: [],
								isVoid: false,
								status: 1,
								memo: '',
								notes: '',
								included: false,
								hasError: false,
								hasWarning: false,
								
								hasWCWarning: $scope.mainData.selectedCompany.contract.invoiceSetup.invoiceType !== 3 && $scope.mainData.selectedCompany.workerCompensations.length > 0 && !employee.workerCompensation,
								paymentMethod: employee.paymentMethod,
								forcePayCheck: false
							};
							$.each(employee.payCodes, function(index1, paycode) {
								var pc = {
									payCode: paycode,
									screenHours: 0,
									screenOvertime:0,
									hours: 0,
									overtimeHours: 0,
									pwAmount: 0
								};
								pc.payCode.hourlyRate = +paycode.hourlyRate.toFixed(2);
								
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
								ded.employeeId = employee.id;
								paycheck.deductions.push({
									deduction: ded.deduction,
									employeeDeduction: ded,
                                    rate: ded.rate,
                                    employerRate: ded.employerRate,
									annualMax: ded.annualMax,
									method: ded.method,
									amount: 0,
									ytd: 0,
									ceilingPerCheck: ded.ceilingPerCheck,
									ceilingMethod: ded.ceilingMethod,
									accountNo: ded.accountNo,
									agencyId: ded.agencyId,
									limit: ded.limit,
                                    priority: ded.priority,
                                    employeeWithheld: ded.employeeWithheld,
                                    employerWithheld: ded.employerWithheld
								});
							});
							selected.data.payChecks.push(paycheck);
						});
						
						return selected;
					}

					$scope.add = function () {
						load($scope.mainData.selectedCompany.id).then(function () {
							if ($scope.canRunPayroll2()) {
								$timeout(function() {
									var selected = addNew();
									$scope.set(selected);

								}, 1);
							} else {
								$scope.cancel();
							}
							
								
							
						});

					}
					var load = function(companyId) {
						var deferred = $q.defer();
						var promises = [];
						promises.push(getCompanyPayrollMetaData(companyId));
						promises.push(getEmployees(companyId));
						
						$q.all(promises).then(function () {
							deferred.resolve();
						}, function (error) {
							deferred.reject(error);
						});
						

						return deferred.promise;
					}
					
					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						sorting: {
							lastPayrollDate: 'desc'     // initial sorting
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
					
					$scope.save = function (item, checks) {
						$scope.selected.data = item;
						$scope.selected.scheduleStartDate = item.startDate;
						$scope.selected.payDateStart = item.payDay;
						$scope.selected.paySchedule = item.paySchedule;
						$scope.selected.lastModified = moment().format("MM/DD/YYYY");
						$scope.selected.status = item.isActive ? 1 : 2;
						$scope.$parent.$parent.confirmDialog('This payroll will automatically run by Schedule starting from the Payroll Start Date? # of check=' + checks, 'warning', function () {
							item.payChecks = $filter('filter')($scope.selected.data.payChecks, { included: true });

							payrollRepository.saveScheduledPayroll($scope.selected).then(function (data) {
								$scope.cancel();
									$scope.list = data;
									$scope.tableParams.reload();
									$scope.fillTableData($scope.tableParams);
									$scope.mainData.showMessage('successfuly saved scheduled payroll', 'success');
									
								
							}, function (error) {
								$scope.set($scope.selected);
								$scope.mainData.showMessage('error saving scheduled payroll', 'danger');
							});
						}, function () {
							$scope.set(item);
						});
					}

					$scope.set = function (item) {
						
							$scope.selected = null;
							
							if (item) {

								$timeout(function () {
									item.data.startDate = moment(item.scheduleStartDate).toDate();
									item.data.endDate = moment(item.scheduleStartDate).toDate();
									item.data.payDay = moment(item.payDateStart).toDate();
									item.data.paySchedule = item.paySchedule;
									item.data.isActive = item.status === 1;
									$.each(item.data.payChecks, function (ind, pc) {
										pc.name = pc.employee.name;
									});
										$scope.selected = item;
									

								}, 1);
							}
						
					

					}
					
					
					$scope.canRunPayroll = function () {
						var c = $scope.mainData.selectedCompany;
						
						var draftPayroll = $filter('filter')($scope.list, { statusText: 'Draft' });
						var queuedPayroll = $filter('filter')($scope.list, { isQueued: true });
						if (queuedPayroll.length > 0) {
							dataSvc.queuedPayroll = queuedPayroll[0];
							
						} 
						
						if (draftPayroll.length > 0 || queuedPayroll.length > 0)
							return false;
						if (dataSvc.metaDataLoaded || !dataSvc.employeesLoaded)
							return true;
						
						else if ($scope.selected || $scope.processed || $scope.committed || !dataSvc.payrollAccount || dataSvc.employees.length == 0 || (c.contract.billingOption === 3 && !c.contract.invoiceSetup) || (c.contract.billingOption === 3 && c.contract.invoiceSetup && c.contract.invoiceSetup.invoiceType === 1 && !dataSvc.hostPayrollAccount))
							return false;
						else {
							return true;
						}
						

					}
					$scope.canRunPayroll2 = function () {
						var c = $scope.mainData.selectedCompany;

						
						if (dataSvc.employees.length == 0)
							return false;
						else if ($scope.requiresCompanyPayrollAccount())
							return false;
						else if (c.contract.billingOption === 3 && c.contract.invoiceSetup && c.contract.invoiceSetup.invoiceType === 1 && !dataSvc.hostPayrollAccount)
							return false;
						else if (c.contract.billingOption === 3 && !c.contract.invoiceSetup)
							return false;
						else {
							return true;
						}


					}

					$scope.requiresHostPayrollAccount = function () {
						var c = $scope.mainData.selectedCompany;

						if (c.contract.billingOption === 3 && c.contract.invoiceSetup && c.contract.invoiceSetup.invoiceType === 1 && !dataSvc.hostPayrollAccount)
							return true;
						else {
							return false;
						}
					}
					$scope.requiresCompanyPayrollAccount = function () {
						var c = $scope.mainData.selectedCompany;
						if (!dataSvc.payrollAccount)
							return true;
						else {
							return false;
						}
					}
					var getCompanyPayrollMetaData = function (companyId) {
						var deferred = $q.defer();
						if (!dataSvc.metaDataLoaded) {
							var request = {
								companyId: $scope.mainData.selectedCompany.id,
								hostId: $scope.mainData.selectedHost.id,
								invoiceSetup: $scope.mainData.selectedCompany.invoiceSetup ? $scope.mainData.selectedCompany.invoiceSetup : $scope.mainData.selectedCompany.contract.invoiceSetup,
								hostCompanyId: $scope.mainData.selectedHost.companyId,
								companyIntId: $scope.mainData.selectedCompany.companyIntId,
								hostCompanyIntId: $scope.mainData.selectedHost.companyIntId
							}
							companyRepository.getPayrollMetaData(request).then(function(data) {
								dataSvc.payTypes = data.payTypes;
								dataSvc.payrollAccount = data.payrollAccount;
								dataSvc.hostPayrollAccount = data.hostPayrollAccount;
								dataSvc.startingCheckNumber = data.startingCheckNumber;
								dataSvc.importMap = data.importMap;
								dataSvc.agencies = data.agencies;
								dataSvc.metaDataLoaded = true;
								if ($scope.selected && !$scope.selected.startingCheckNumber) {
									$scope.selected.startingCheckNumber = dataSvc.startingCheckNumber;
								}
								
								console.log("loaded meta data");
								deferred.resolve();
							}, function(error) {
								
								$scope.mainData.handleError('error getting payroll meta data: ' , error, 'danger');
								deferred.reject(error);
							});
						} else {
							deferred.resolve();
						}
						return deferred.promise;
					}

					
					var getEmployees = function (companyId) {
						var deferred = $q.defer();
						if (!dataSvc.employeesLoaded) {
							companyRepository.getEmployees(companyId, 1).then(function(data) {
								dataSvc.employees = data;
								dataSvc.employeesLoaded = true;
								deferred.resolve();
								console.log("loaded employees");
							}, function(erorr) {
								$scope.mainData.showMessage('error getting employee list', 'danger');
								deferred.reject(error);
							});
						} else {
							deferred.resolve();
						}
						return deferred.promise;
					}
					var getPayrolls = function (companyId) {
						$scope.list = [];
						$scope.tableData = [];
						$scope.selected = null;
						
						
							dataSvc.loadedForPayrollsWithoutInvoice = false;
						payrollRepository.getSchedulePayrollList(companyId).then(function (data) {
								$scope.list = data;
								$scope.tableParams.reload();
								$scope.fillTableData($scope.tableParams);
								$scope.selected = null;
								
							}, function (error) {
								$scope.mainData.showMessage('error getting scheduled payrolls', 'danger');
							});
						

					}
					$scope.$watch('mainData.selectedCompany.id',
						 function (newValue, oldValue) {
						 	if (newValue !== oldValue && $scope.mainData.selectedCompany) {
						 		
						 		dataSvc.employeesLoaded = false;
						 		dataSvc.metaDataLoaded = false;
								 data.isBodyOpen = true;
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
					
					
					$scope.minPayDate = null;
					
					
					var init = function () {
						
						if ($scope.mainData.selectedCompany) {
							
							$scope.minPayDate = moment().startOf('day');
							if ($scope.mainData.selectedCompany.payrollDaysInPast > 0) {
								$scope.minPayDate = moment().add($scope.mainData.selectedCompany.payrollDaysInPast * -1, 'day').startOf('day').toDate();
							}
							getPayrolls($scope.mainData.selectedCompany.id);
						}
						

					}
					
					init();
					
					

				}]
		}
	}
]);
