'use strict';

common.directive('payrollList', ['zionAPI', '$timeout', '$window', 'version','$q',
	function (zionAPI, $timeout, $window, version, $q) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/payroll-list.html?v=' + version,

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


					$scope.addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					
					$scope.selected = null;
					var inLastPayroll = function(employeeId) {
						if ($scope.list.length === 0)
							return false;
						else {
							var lastPayroll = $filter('orderBy')($scope.list, 'payDay', true)[0];
							var exists = $filter('filter')(lastPayroll.payChecks, { employee: { id: employeeId } });
							return exists.length > 0;
						}

					}

					var addNew = function() {
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
								inLastPayroll: inLastPayroll(employee.id),
								hasWCWarning: $scope.mainData.selectedCompany.contract.invoiceSetup.invoiceType !== 3 && $scope.mainData.selectedCompany.workerCompensations.length > 0 && !employee.workerCompensation,
								paymentMethod: employee.paymentMethod
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
							selected.payChecks.push(paycheck);
						});
						if ($scope.list.length > 0) {
							var sorted = $filter('orderBy')($scope.list, 'endDate', true);
							selected.startDate = moment(sorted[0].endDate).add(1, 'day').toDate();

							if ($scope.mainData.selectedCompany.payrollSchedule === 1) {
								selected.endDate = moment(selected.startDate).add(1, 'week').add(-1, 'day').toDate();
								//selected.payDay = moment(sorted[0].payDay).add(1, 'week').toDate();
							}
							else if ($scope.mainData.selectedCompany.payrollSchedule === 2) {
								selected.endDate = moment(selected.startDate).add(2, 'week').add(-1, 'day').toDate();
								//selected.payDay = moment(sorted[0].payDay).add(2, 'week').toDate();
							}
							else if ($scope.mainData.selectedCompany.payrollSchedule === 3) {
								if (moment(selected.startDate).date() === 1) {
									selected.endDate = moment(selected.startDate).add(14, 'day').toDate();
									//selected.payDay = moment(sorted[0].payDay).add(15, 'day').toDate();
								} else {
									selected.endDate = moment(selected.startDate).endOf('month').toDate();
									//selected.payDay = moment(sorted[0].startDate).endOf('month').toDate();
								}
								
							} else {
								selected.endDate = moment(selected.startDate).endOf('month').toDate();
								//selected.payDay = moment(sorted[0].payDay).add(1, 'month').toDate();
							}
							

						}
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
						//getCompanyPayrollMetaData(companyId).then(function () {
						//	getEmployees(companyId).then(function () {
						//		deferred.resolve();
						//	}, function (error) {
						//		deferred.reject(error);
						//	});
						//}, function (error) {
						//	deferred.reject(error);
						//});
						

						return deferred.promise;
					}
					$scope.copyPayroll = function (event, payroll) {
						
						event.stopPropagation();
						confirmCopyDialog('Please select an option to continue', 'warning', function (option) {
							$scope.refresh(payroll, 0, option);
							


						});
					}
					var confirmCopyDialog = function (message, type, callback) {
						var modalInstance = $modal.open({
							templateUrl: 'popover/confirmcopy.html',
							controller: 'confirmCopyDialogCtrl',
							backdrop: true,
							keyboard: true,
							backdropClick: true,
							size: 'lg',
							resolve: {
								message: function () {
									return message;
								},
								type: function () {
									return type;
								}
							}
						});
						modalInstance.result.then(function (result) {
							callback(result);
						}, function () {
							return false;
						});
					}
					$scope.refresh = function (payroll, copydates, option) {
						load($scope.mainData.selectedCompany.id).then(function () {
							if ($scope.canRunPayroll2()) {
								
							
								var selected = {
									company: $scope.mainData.selectedCompany,
									startDate: copydates ? moment(payroll.startDate).toDate() : null,
									endDate: copydates ? moment(payroll.endDate).toDate() : null,
									payDay: copydates ? moment(payroll.payDay).toDate() : null,
									payChecks: [],
									startingCheckNumber: copydates ? payroll.startingCheckNumber : dataSvc.startingCheckNumber,
									status: 1,
									notes: payroll.notes
								};
								if (!selected.startDate && !selected.endDate && $scope.list.length > 0) {
									var sorted = $filter('orderBy')($scope.list, 'endDate', true);
									selected.startDate = moment(sorted[0].endDate).add(1, 'day').toDate();

									if ($scope.mainData.selectedCompany.payrollSchedule === 1) {
										selected.endDate = moment(selected.startDate).add(1, 'week').add(-1, 'day').toDate();
										//selected.payDay = moment(sorted[0].payDay).add(1, 'week').toDate();
									}
									else if ($scope.mainData.selectedCompany.payrollSchedule === 2) {
										selected.endDate = moment(selected.startDate).add(2, 'week').add(-1, 'day').toDate();
										//selected.payDay = moment(sorted[0].payDay).add(2, 'week').toDate();
									}
									else if ($scope.mainData.selectedCompany.payrollSchedule === 3) {
										if (moment(selected.startDate).date() === 1) {
											selected.endDate = moment(selected.startDate).add(14, 'day').toDate();
											//selected.payDay = moment(sorted[0].payDay).add(15, 'day').toDate();
										} else {
											selected.endDate = moment(selected.startDate).endOf('month').toDate();
											//selected.payDay = moment(sorted[0].startDate).endOf('month').toDate();
										}

									} else {
										selected.endDate = moment(selected.startDate).endOf('month').toDate();
										//selected.payDay = moment(sorted[0].payDay).add(1, 'month').toDate();
									}


								}
								$.each(dataSvc.employees, function (index, employee) {
									var matching = $filter('filter')(payroll.payChecks, { employee: { id: employee.id } })[0];
										var paycheck = {
											id: matching ? matching.id : 0,
											employeeNo: employee.employeeNo,
											companyEmployeeNo: employee.companyEmployeeNo,
											name: employee.name,
											payType: employee.payType,
											department: employee.department ? employee.department : '',
											employee: employee,
											payCodes: [],
											salary: employee.payType === 2 || employee.payType === 4 ? (matching && option === 2 ? matching.salary : employee.rate) : 0,
											compensations: [],
											deductions: [],
											isVoid: false,
											status: 1,
											memo: '',
											notes: matching ? matching.notes : '',
											included: matching ? matching.included : false,
											hasError: false,
											hasWarning: false,
											inLastPayroll: inLastPayroll(employee.id),
											hasWCWarning: $scope.mainData.selectedCompany.contract.invoiceSetup.invoiceType !== 3 && $scope.mainData.selectedCompany.workerCompensations.length > 0 && !employee.workerCompensation,
											paymentMethod: matching ? matching.paymentMethod : employee.paymentMethod
										};
										if (employee.payType < 4) {
											$.each(employee.payCodes, function(index1, paycode) {
												var pc = {
													payCode: angular.copy(paycode),
													screenHours: 0,
													screenOvertime: 0,
													hours: 0,
													overtimeHours: 0,
													pwAmount: 0
												};
												if (matching) {
													var matchingpc = $filter('filter')(matching.payCodes, { payCode: { id: paycode.id } })[0];
													if (matchingpc) {
														pc.screenHours = matchingpc.screenHours;
														pc.screenOvertime = matchingpc.screenOvertime ? matchingpc.screenOvertime : 0;
														pc.hours = matchingpc.hours;
														pc.overtimeHours = matchingpc.overtimeHours;
														pc.pwAmount = matchingpc.pwAmount;
														if (pc.payCode.id >= 0 && option === 2) {
															pc.payCode.hourlyRate = matchingpc.payCode.hourlyRate;

														} else {
															pc.payCode.hourlyRate = paycode.hourlyRate;
														}
													}
												}
												paycheck.payCodes.push(pc);
											});
											if (matching) {
												$.each(matching.payCodes, function(index4, paycode4) {
													var exists = $filter('filter')(paycheck.payCodes, { payCode: { id: paycode4.payCode.id } })[0];
													if (!exists) {
														var pc4 = {
															payCode: angular.copy(paycode4.payCode),
															screenHours: paycode4.screenHours,
															screenOvertime: paycode4.screenOvertime ? paycode4.screenOvertime : 0,
															hours: paycode4.hours,
															overtimeHours: paycode4.overtimeHours,
															pwAmount: paycode4.pwAmount
														};
														paycheck.payCodes.push(pc4);
													}
												});
											}
										}

										if (matching) {
											if (employee.payType === 4)
												paycheck.payCodes = angular.copy(matching.payCodes);
											paycheck.compensations = angular.copy(matching.compensations);
											paycheck.deductions = angular.copy(matching.deductions);
											$.each(paycheck.deductions, function(id, d) {
                                                var compDed = $filter('filter')($scope.mainData.selectedCompany.deductions, { id: d.deduction.id })[0];
                                                var empDed = $filter('filter')(employee.deductions, { id: d.employeeDeduction.id })[0];
												if (compDed) {
													d.deduction = compDed;
													d.employeeDeduction.deduction = compDed;
												}
												d.accountNo = d.employeeDeduction.accountNo;
												d.agencyId = d.employeeDeduction.agencyId;
												d.ceilingPerCheck = d.employeeDeduction.ceilingPerCheck;
												d.ceilingMethod = d.employeeDeduction.ceilingMethod;
												d.priority = d.employeeDeduction.priority;
                                                d.limit = d.employeeDeduction.limit;
                                                d.employerRate = d.employeeDeduction.employerRate;
                                                d.employeeWithheld = empDed.employeeWithheld;
                                                d.employerWithheld = empDed.employerWithheld;
                                            });
										} else {
											$.each(employee.compensations, function(index2, comp) {
												var pt = {
													payType: comp.payType,
													amount: comp.amount,
													ytd: 0
												}
												paycheck.compensations.push(pt);
											});
											$.each(employee.deductions, function(index3, ded) {
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
                                                    employeeWithheld : ded.employeeWithheld,
                                                    employerWithheld : ded.employerWithheld
												});
											});
										}

										selected.payChecks.push(paycheck);
									
								});
						
								$scope.set(selected);
							}
						
						});
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
						$scope.processed = null;
						$scope.committed = null;
						$scope.selectedInvoice = null;
						$scope.data.isBodyOpen = true;
					}
					$scope.updateListAndItem = function (selectedItemId) {
						//getPayrolls($scope.mainData.selectedCompany.id, null, null, selectedItemId);
						dataSvc.metaDataLoaded = false;
						$scope.getPayrollList(selectedItemId);
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
					$scope.process = function (item) {

						var payroll = angular.copy(item);
						$scope.cancel();
						payroll.startDate = moment(payroll.startDate).format("MM/DD/YYYY");
						payroll.endDate = moment(payroll.endDate).format("MM/DD/YYYY");
						payroll.payDay = moment(payroll.payDay).format("MM/DD/YYYY");
						payroll.taxPayDay = payroll.payDay;
						payrollRepository.processPayroll(payroll).then(function (data) {
							$timeout(function () {

								$scope.set(data);
							});


						}, function (error) {
							$scope.set(payroll);
							$scope.addAlert('Error processing payroll: ' + error.statusText, 'danger');
						});
					}
					$scope.save = function (item, checks) {
						$scope.cancel();
						$scope.$parent.$parent.confirmDialog('Are you sure you want to Confirm this Payroll? # of check=' + checks + '. Gross Wage=' + $filter('currency')(item.totalGrossWage, '$'), 'warning', function () {
							item.payChecks = $filter('filter')(item.payChecks, { included: true });

							payrollRepository.commitPayroll(item).then(function (data) {
								if (!$scope.mainData.selectedCompany.lastPayrollDate || moment($scope.mainData.selectedCompany.lastPayrollDate) < moment(item.payDay))
									$scope.mainData.selectedCompany.lastPayrollDate = moment(item.payDay).toDate();
								if (data.isQueued) {
									//$scope.updateListAndItem(item.id);
									var exists = $filter('filter')($scope.list, { id: data.id });
									if (exists.length > 0) {
										$scope.list.splice($scope.list.indexOf(exists[0]), 1);
									}
									$scope.list.push(data);
									$scope.tableParams.reload();
									$scope.fillTableData($scope.tableParams);
									$scope.addAlert('successfuly saved payroll', 'info');
									
								} else {
									$scope.updateListAndItem(item.id);
									$scope.addAlert('successfuly saved payroll', 'success');
								}
								
							}, function (error) {
								$scope.set(item);
								$scope.addAlert('error committing payroll', 'danger');
							});
						}, function() {
							$scope.set(item);
						});
					}

					$scope.set = function (item) {
						if (item && item.isQueued) {
							$scope.addAlert('This item is still queued for confirmation', 'danger');
						} else {
							$scope.selected = null;
							$scope.processed = null;
							$scope.committed = null;
							$scope.selectedPayCodes = [];
							if (item) {

								$timeout(function () {
									if (item.status === 1)
										$scope.selected = item;
									else if (item.status === 2 || item.status === 6)
										$scope.processed = angular.copy(item);
									else if (item.status > 2)
										$scope.committed = angular.copy(item);

								}, 1);
							}
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
								
								$scope.addAlert('error getting payroll meta data: ' + error, 'danger');
								deferred.reject(error);
							});
						} else {
							deferred.resolve();
						}
						return deferred.promise;
					}

					var getPayrolls = function (companyId, startDate, endDate, selectedItemId) {
						$scope.list = [];
						$scope.tableData = [];
						$scope.selected = null;
						$scope.committed = null;
						if ($scope.mainData.fromPayrollsWithoutInvoice) {
							dataSvc.loadedForPayrollsWithoutInvoice = true;
							payrollRepository.getPayrollList(companyId, null, null, true).then(function (data) {
								$scope.list = data;
								$scope.tableParams.reload();
								$scope.fillTableData($scope.tableParams);
								$scope.selected = null;
								$scope.mainData.fromPayrollsWithoutInvoice = false;
								
							}, function (error) {
								$scope.addAlert('error getting payrolls without invoice', 'danger');
							});
						} else {
							dataSvc.loadedForPayrollsWithoutInvoice = false;
							payrollRepository.getPayrollList(companyId, startDate, endDate).then(function (data) {
								$scope.list = data;
								$scope.tableParams.reload();
								$scope.fillTableData($scope.tableParams);
								$scope.selected = null;
								if (selectedItemId) {
									var match = $filter('filter')($scope.list, { id: selectedItemId })[0];
									if (match)
										$scope.set(match);
									else {
										$scope.set(null);
									}
								} else {
									$scope.set(null);
								}
								
							}, function (error) {
								$scope.addAlert('error getting payrolls', 'danger');
							});
						}

					}
					$scope.getMaxPayDay = function() {
						var sortedList = $filter('orderBy')($scope.list, 'payDay', true);
						if (sortedList.length > 0)
							$scope.maxPayDay = sortedList[0].payDay;
						return $scope.maxPayDay;
					}
					$scope.getPayrollList = function (selectedItemId) {
						getPayrolls($scope.mainData.selectedCompany.id, dataSvc.reportFilter.filterStartDate ? moment(dataSvc.reportFilter.filterStartDate).format('MM/DD/YYYY') : null, dataSvc.reportFilter.filterEndDate ? moment(dataSvc.reportFilter.filterEndDate).format('MM/DD/YYYY') : null, selectedItemId);
					}
					$scope.deleteDraftPayroll = function(event, payroll) {
						event.stopPropagation();
						$scope.cancel();
						$scope.$parent.$parent.confirmDialog('Are you sure you want to delete this Draft Payroll?', 'danger', function() {
								payrollRepository.deleteDraftPayroll(payroll).then(function(data) {
									if (data) {
										$scope.list.splice($scope.list.indexOf(payroll), 1);
										$scope.tableParams.reload();
										$scope.fillTableData($scope.tableParams);
										$scope.processed = null;
									}
								}, function(erorr) {
									$scope.addAlert('error: ' + erorr.statusText, 'danger');
								});
							}
						);

					};
					$scope.deletePayroll = function (event, payroll) {
						event.stopPropagation();
						$scope.cancel();
						$scope.$parent.$parent.confirmDialog('Please make sure the Positive Pay Report impact before deleting this payroll?', 'danger', function () {
							payrollRepository.deletePayroll(payroll).then(function (data) {
								if (data) {
									$scope.list.splice($scope.list.indexOf(payroll), 1);
									$scope.tableParams.reload();
									$scope.fillTableData($scope.tableParams);
									$scope.processed = null;
								}
							}, function (erorr) {
								$scope.addAlert('error: ' + erorr.statusText, 'danger');
							});
						}
						);

					}
					$scope.voidPayroll = function (event, payroll) {
						event.stopPropagation();
						$scope.cancel();
						$scope.$parent.$parent.confirmDialog('Are you sure you want to Void all checks in this Payroll?', 'danger', function () {
							payrollRepository.voidPayroll(payroll).then(function (data) {
								if (data) {
									$scope.list.splice($scope.list.indexOf(payroll), 1);
									$scope.list.push(data);
									$scope.tableParams.reload();
									$scope.fillTableData($scope.tableParams);
									$scope.processed = null;
								}
							}, function (erorr) {
								$scope.addAlert('error: ' + erorr.statusText, 'danger');
							});
						}
						);

					}
					$scope.unVoidPayroll = function (event, payroll) {
						event.stopPropagation();
						$scope.cancel();
						$scope.$parent.$parent.confirmDialog('Are you sure you want to Un Void all checks in this Payroll?', 'danger', function () {
							payrollRepository.UnVoidPayroll(payroll).then(function (data) {
								if (data) {
									$scope.list.splice($scope.list.indexOf(payroll), 1);
									$scope.list.push(data);
									$scope.tableParams.reload();
									$scope.fillTableData($scope.tableParams);
									$scope.processed = null;
								}
							}, function (erorr) {
								$scope.addAlert('error: ' + erorr.statusText, 'danger');
							});
						}
						);

					}
					$scope.reProcessReConfirmPayroll = function (event, payroll) {
						event.stopPropagation();
						$scope.cancel();
						$scope.$parent.$parent.confirmDialog('Are you sure you want to ReProcess and ReConfirm this Payroll?', 'danger', function () {
							payrollRepository.reProcessReConfirmPayroll(payroll).then(function (data) {
								if (data) {
									$scope.list.splice($scope.list.indexOf(payroll), 1);
									$scope.list.push(data);
									$scope.tableParams.reload();
									$scope.fillTableData($scope.tableParams);
									$scope.processed = null;
								}
							}, function (erorr) {
								$scope.addAlert('error: ' + erorr.statusText, 'danger');
							});
						}
						);

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
								$scope.addAlert('error getting employee list', 'danger');
								deferred.reject(error);
							});
						} else {
							deferred.resolve();
						}
						return deferred.promise;
					}
					$scope.$watch('mainData.selectedCompany.id',
						 function (newValue, oldValue) {
						 	if (newValue !== oldValue && $scope.mainData.selectedCompany) {
						 		//getCompanyPayrollMetaData($scope.mainData.selectedCompany.id);
						 		//getEmployees($scope.mainData.selectedCompany.id);
						 		//getPayrolls($scope.mainData.selectedCompany.id);
						 		// $scope.getPayrollList();
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
					
					$scope.viewInvoice = function($event, payroll) {
						$event.stopPropagation();
						$scope.selectedInvoice = null;
						payrollRepository.getInvoiceById(payroll.invoiceId).then(function (invoice) {
							$scope.selectedInvoice = invoice;
							//$location.hash("invoice");
							anchorSmoothScroll.scrollToElement(document.getElementById('invoice'));
						}, function (error) {
							$scope.addAlert('error getting invoices', 'danger');

						});
						
					}
					$scope.updateSelectedInvoice = function (invoice) {
						var match = $filter('filter')($scope.list, { invoiceId: invoice.id })[0];
						if (match) {
							match.invoiceStatusText = invoice.statusText;
							match.invoiceStatus = invoice.status;
							match.invoiceNumber = invoice.invoiceNumber;
							match.total = invoice.total;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
						}
						
					}
					$scope.deleteInvoice = function (invoice) {
						var match = $filter('filter')($scope.list, { invoiceId: invoice.id  })[0];
						if (match) {
							match.invoiceId = null;
							match.invoiceNumber = null;
							match.invoiceStatusText = '';
							match.total = 0;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
						}
						$scope.cancel();
					}
					$scope.createInvoice = function ($event, payroll) {
						$event.stopPropagation();
						var match = $filter('filter')($scope.list, { id: payroll.id })[0];
						match.invoiceNumber = 0;
						match.company = $scope.mainData.selectedCompany;
						payrollRepository.createPayrollInvoice(match, $scope.mainData.selectedCompany).then(function (data) {
							payroll.invoiceId = data.id;
							payroll.invoiceNumber = data.invoiceNumber;
							payroll.invoiceStatusText = data.statusText;
							payroll.total = data.total;
							
							$scope.addAlert('successfully created invoice', 'success');
						}, function (error) {
							$scope.addAlert('error generating invoice', 'danger');
						});
					}
					$scope.updateEmployeeList = function (emp) {
						if (emp) {
							var match = $filter('filter')(dataSvc.employees, { id: emp.id })[0];
							if (match) {
								match = angular.copy(emp);
							}
						} else {
							getEmployees($scope.mainData.selectedCompany.id);
						}
						getEmployees($scope.mainData.selectedCompany.id);
					}
					$scope.minPayDate = null;
					$scope.getClass = function (item) {
						if (item && item.isQueued) {
							return 'danger';
						}
						else if ($scope.committed && $scope.committed.id === item.id)
							return 'success';
						else if (item.status === 6) {
							if (moment(item.payDay).toDate() < $scope.minPayDate)
								return 'danger';
							else {
								return 'warning';
							}
						} else {
							return 'default';
						}
					}
					$scope.reQueuePayroll = function() {
						payrollRepository.reQueuePayroll(dataSvc.queuedPayroll).then(function(data) {
							$scope.addAlert('Error in Payroll Confirmation. Re-Queued - ' + moment(dataSvc.queuedPayroll.payDay).format("MM/DD/YYYY"), 'warning');
							var tableItem = $filter('filter')($scope.tableData, { id: dataSvc.queuedPayroll.id })[0];
							if (tableItem) {
								tableItem.queuePosition = data.queuePosition;
							}
						}, function(erorr) {

						});
					}
					$scope.checkQueued = function () {
						if (dataSvc.queuedPayroll) {
							payrollRepository.isPayrollConfirmed(dataSvc.queuedPayroll).then(function (data) {
								if (data && !data.isQueued && data.confirmedTime) {
									$scope.list.splice($scope.list.indexOf($filter('filter')($scope.list, { id: dataSvc.queuedPayroll.id })[0]), 1);
									$scope.list.push(data);
									$scope.tableParams.reload();
									$scope.fillTableData($scope.tableParams);
									$scope.processed = null;
									dataSvc.queuedPayroll = null;
									dataSvc.queuedConfirmFailed = false;
									$scope.addAlert('Payroll Confirmation finished. Ready for printing - ' + moment(data.payDay).format("MM/DD/YYYY"), 'success');
											
								} else if (data && data.isQueued && (data.isConfirmFailed || data.queuePosition===0)) {

									$scope.reQueuePayroll();

								} else {
									var tableItem = $filter('filter')($scope.tableData, { id: dataSvc.queuedPayroll.id })[0];
									if (tableItem &&  tableItem.queuePosition !== data.queuePosition) {
										tableItem.queuePosition = data.queuePosition;
									}
								}
							}, function (erorr) {
								
							});
						}
					};
					var init = function () {
						
						if ($scope.mainData.selectedCompany) {
							
							$scope.minPayDate = moment().startOf('day');
							if ($scope.mainData.selectedCompany.payrollDaysInPast > 0) {
								$scope.minPayDate = moment().add($scope.mainData.selectedCompany.payrollDaysInPast * -1, 'day').startOf('day').toDate();
							}
						}
						

					}
					
					init();
					$interval($scope.checkQueued, 30000);
					

				}]
		}
	}
]);
common.controller('confirmCopyDialogCtrl', function ($scope, $uibModalInstance, message, type) {
	$scope.message = message;
	$scope.type = type ? type : 'info';
	$scope.cancel = function () {
		$uibModalInstance.dismiss();
	};

	$scope.ok = function (option) {
		$uibModalInstance.close(option);
	};


});