'use strict';

common.directive('payroll', ['$uibModal', 'zionAPI', '$timeout', '$window', 'version',
	function ($modal, zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				item: "=item",
				datasvc: "=datasvc",
				company: "=company"

			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/payroll.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'ngTableParams', 'EntityTypes', 'payrollRepository',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, payrollRepository) {
					var dataSvc = {
						payTypes: $scope.datasvc.payTypes,
						employees: $scope.datasvc.employees,
						payTypeFilter: 0,
						toggleState: true,
						tabindex:1
					}
					
					$scope.list = [];
					
					$scope.data = dataSvc;
					$scope.cancel = function() {
						$scope.$parent.$parent.selected = null;
						$scope.datasvc.isBodyOpen = true;
					}

					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					
					
					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						count: $scope.list ? $scope.list.length : 0,
						filter: {
							name: '',       // initial filter
						},
						sorting: {
							name: 'desc'     // initial sorting
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
							var filterbypaytype = params.$params.filter.paytype;
							delete params.$params.filter.paytype;
							var orderedData = params.filter() ?
																$filter('filter')($scope.list, params.filter()) :
																$scope.list;
							if (filterbypaytype) {
								//dataSvc.payTypeFilter = filterbypaytype;
								orderedData = $filter('filter')(orderedData, { employee: { payType: filterbypaytype } });
							} 

							orderedData = params.sorting() ?
														$filter('orderBy')(orderedData, params.orderBy()) :
														orderedData;
							params.$params.filter.paytype = filterbypaytype;
							$scope.tableParams = params;
							//$scope.tableData = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count());
							$scope.tableData = orderedData;

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					
					$scope.removePayCheck = function(listitem) {
						var pc = $filter('filter')($scope.list, { employee: { id: listitem.employee.id } })[0];
						if (pc) {
							$scope.list.splice($scope.list.indexOf(pc), 1);
						}
						$scope.tableData.splice($scope.tableData.indexOf(listitem), 1);
					}
					$scope.includeAll = function () {
						dataSvc.toggleState = !dataSvc.toggleState;
						$.each($scope.tableData, function (index, p) {
							var li = $filter('filter')($scope.list, { employee: { id: p.employee.id } })[0];
							if (li) {

								li.included = dataSvc.toggleState;
								p.included = dataSvc.toggleState;
							}
							
						});
					}
					$scope.itemIncluded = function(pc) {
						if (!pc.included) {
							pc.status = 1;
							pc.paymentMethod = 1;
						}

					}
					
					
					$scope.process = function () {
						if (false === $('form[name="payrollstep1"]').parsley().validate()) {
							var errors = $('.parsley-error');
							return false;
						}
						var payroll = angular.copy($scope.item);
						payroll.startDate = moment(payroll.startDate).format("MM/DD/YYYY");
						payroll.endDate = moment(payroll.endDate).format("MM/DD/YYYY");
						payroll.payDay = moment(payroll.payDay).format("MM/DD/YYYY");

						payrollRepository.processPayroll(payroll).then(function (data) {
							$timeout(function () {
								$scope.cancel();
								$scope.$parent.$parent.set(data);
							});
							
							
						}, function (error) {
							addAlert('Error processing payroll: ' + error.statusText, 'danger');
						});
					}
					$scope.showList = function() {
						if (moment($scope.item.endDate) < moment($scope.item.startDate) || moment($scope.item.payDay) < $scope.minPayDate)
							return false;
						else if ($scope.list.length > 0 && $scope.item.startDate && $scope.item.endDate && $scope.item.payDay && $scope.item.startingCheckNumber)
							return true;
						
						else
							return false;
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
					$scope.isPayCheckInvalid = function(pc) {
						var returnVal = false;
						var salary = pc.salary;
						var payCodeSum = 0;
						var comps = 0;
						if (!pc.included)
							return false;
						$.each(pc.payCodes, function (index1, paycode) {
							paycode.hours = calculateHours(paycode.screenHours);
							paycode.overtimeHours = calculateHours(paycode.screenOvertime);
							payCodeSum += (paycode.hours + paycode.overtimeHours);
							if (paycode.payCode.id === -1 && paycode.pwAmount <= 0) {
								payCodeSum = 0;
								return;
							}
						});
						$.each(pc.compensations, function (index1, comp) {
							comps += comp.amount;
						});
						var gross = salary + payCodeSum + comps;
						if (!gross || gross <= 0)
							returnVal = true;
						else {
							returnVal = false;
						}
						return returnVal;
					}
					$scope.showcomps = function(listitem) {
						var modalInstance = $modal.open({
							templateUrl: 'popover/updatecomps1.html',
							controller: 'updateCompsCtrl',
							size: 'md',
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
								}
							}
						});
						modalInstance.result.then(function (pcs) {
							
								$scope.item.payChecks = angular.copy(pcs);
								$scope.list = $scope.item.payChecks;
								$scope.tableParams.reload();
								$scope.fillTableData($scope.tableParams);
						}, function () {
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
							addAlert('error getting timesheet import template', 'danger');
						});
					}
					var uploadDocument = function () {
						payrollRepository.importTimesheets($scope.files[0]).then(function (timesheets) {
							var counter = 0;
							$.each(timesheets, function (ind, t) {
								var pc = null;
								if (t.ssn)
									pc = $filter('filter')($scope.list, { employee: { ssn: t.ssn } })[0];
								else if (t.employeeNo) {
									pc = $filter('filter')($scope.list, { employee: { employeeNo: t.employeeNo } })[0];
								}
								
								if (pc) {
									counter++;
									if (pc.employee.payType === 2)
										pc.salary = t.salary;
									else if (pc.employee.payType === 1) {
										$.each(t.payCodes, function(pcind, paycode) {
											var ec = $filter('filter')(pc.employee.payCodes, { id: paycode.payCode.id });
											if (ec) {
												var exists = $filter('filter')(pc.payCodes, { payCode: { id: paycode.payCode.id } });
												if (exists.length > 0) {
													exists[0].screenHours = paycode.screenHours;
													exists[0].screenOvertime = paycode.screenOvertime;
													exists[0].hours = paycode.hours;
													exists[0].overtimeHours = paycode.overtimeHours;
													if (paycode.payCode.id === 0 && paycode.payCode.hourlyRate) {
														exists[0].payCode.hourlyRate = paycode.payCode.hourlyRate;
													}
												} else
													pc.payCodes.push(paycode);
											}
										});
									} else {
										var pw = $filter('filter')(t.payCodes, { payCode: { id: 0 } });
										if (pw.length > 0 && pc.payCodes.length===1) {
											pc.payCodes[0].pwAmount = pw[0].payCode.hourlyRate;
											pc.payCodes[0].hours = pw[0].hours;
											pc.payCodes[0].overtimeHours = pw[0].overtimeHours;
										}
									}
									$.each(t.compensations, function (cind, comp) {
											var exists = $filter('filter')(pc.compensations, { payType: { id: comp.payType.id } });
											if (exists.length > 0)
												exists[0].amount = comp.amount;
											else
												pc.compensations.push(comp);
										});
								}
								
							});
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							
							addAlert('successfully imported ' + counter + " rows from "+ timesheets.length + ' rows of timesheet', 'success');
						}, function (error) {
							addAlert('error in importing timesheets: ' + error, 'danger');

						});


					}



					var init = function () {
						$scope.list = $scope.item.payChecks;
						//$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						$scope.datasvc.isBodyOpen = false;
						$scope.minPayDate = moment().startOf('day');
						if ($scope.company.payrollDaysInPast > 0) {
							$scope.minPayDate = moment().add($scope.company.payrollDaysInPast * -1, 'day').startOf('day').toDate();
						}
						
					}
					init();


				}]
		}
	}
]);
common.controller('updateCompsCtrl', function ($scope, $uibModalInstance, $filter, paycheck, paytypes) {
	$scope.original = paycheck;
	$scope.paycheck = angular.copy(paycheck);
	$scope.paytypes = paytypes;
	$scope.newPayTypes = [];
	$scope.changesMade = false;
	$scope.remove = function (index) {
		$scope.paycheck.compensations.splice(index, 1);
		markUsed();
		$scope.changesMade = true;
	}
	$scope.cancel = function () {
		$uibModalInstance.close($scope);
	};
	$scope.save = function () {
		if (false === $('form[name="compform"]').parsley().validate()) {
			var errors = $('.parsley-error');
			return false;
		}

		$scope.original.compensations = [];
		$.each($scope.paycheck.compensations, function(index, pt) {
			$scope.original.compensations.push($scope.paycheck.compensations[index]);
		});
		$.each($scope.newPayTypes, function (index1, pt) {
			if($scope.newPayTypes[index1].amount>0)
			$scope.original.compensations.push($scope.newPayTypes[index1]);
		});
		$uibModalInstance.close($scope);
	};
	$scope.addPayType = function() {
		$scope.newPayTypes.push({
			payType: null,
			amount: 0
		});
		$scope.changesMade = true;
	}
	$scope.availablePayTypes = function () {
		return $filter('filter')($scope.paytypes, { used: 0 });
	}
	$scope.payTypeList = function (item) {
		var returnList = $scope.availablePayTypes();
		if (item && item.payType)
			returnList.push(item.payType);
		return returnList;
	}
	$scope.updatePayTypeUsed = function (item) {
		if (item.payType) {
			markUsed();
			$.each($scope.newPayTypes, function (index, comp) {
				var exists = $filter('filter')($scope.paytypes, { id: comp.payType.id })[0];
				if (exists)
					exists.used = 1;
			});
		}

	}
	$scope.removeFromNew = function (index) {
		$scope.newPayTypes.splice(index, 1);
		markUsed();
	}
	var markUsed = function() {
		$.each($scope.paytypes, function (index, pt) {
			var exists = $filter('filter')($scope.paycheck.compensations, { payType: { id: pt.id } })[0];
			var existsInNew = $filter('filter')($scope.newPayTypes, { payType: { id: pt.id } })[0];
			if (exists || existsInNew)
				pt.used = 1;
			else
				pt.used = 0;
		});
	}
	var _init = function() {
		markUsed();
	}
	_init();
});

common.controller('updateDedsCtrl', function ($scope, $uibModalInstance, $filter, paycheck, companydeductions, agencies, companyRepository) {
	$scope.original = paycheck;
	$scope.paycheck = angular.copy(paycheck);
	$scope.dedList = angular.copy(paycheck.deductions);
	$scope.deductionList = companydeductions;
	$scope.agencies = agencies;


	$scope.cancel = function () {
		$uibModalInstance.close($scope);
	};
	$scope.empty = function() {
		$scope.original.deductions = [];
		$uibModalInstance.close($scope);
	}
	$scope.permanentSave = function () {
		$scope.original.deductions = [];
		$.each($scope.dedList, function (index, dd) {
			companyRepository.saveEmployeeDeduction(dd);
			$scope.original.deductions.push(dd);
		});
		$uibModalInstance.close($scope);
	};
	$scope.save = function () {
		$scope.original.deductions = [];
		$.each($scope.dedList, function (index, dd) {
			if (!dd.employeeDeduction) {
				dd.employeeDeduction = {
					id: 0,
					employeeId: $scope.original.employee.id,
					deduction: dd.deduction
				}
			}

			dd.employeeDeduction.method = dd.method;
			dd.employeeDeduction.rate = dd.rate;
			dd.employeeDeduction.annualMax = dd.annualMax;
			dd.employeeDeduction.ceilingPerCheck = dd.ceilingPerCheck;
			dd.employeeDeduction.limit = dd.limit;
			dd.employeeDeduction.accountNo = dd.accountNo;
			dd.employeeDeduction.agencyId = dd.agencyId;
			dd.employeeDeduction.priority = dd.priority;
			
			$scope.original.deductions.push(dd);
		});
		$uibModalInstance.close($scope);
	};

	
});
common.controller('employeeCtrl', function ($scope, $uibModalInstance, $filter, paycheck, mainData) {
	$scope.original = paycheck.employee;
	$scope.employee = angular.copy(paycheck.employee);
	$scope.paycheck = paycheck;
	$scope.mainData = mainData;
	

	$scope.cancel = function () {
		$uibModalInstance.close($scope);
	};
	
	$scope.save = function (result) {
		$scope.paycheck.employee = result;
		$scope.paycheck.employeeNo = result.employeeNo;
		$scope.paycheck.name = result.name;
		$scope.paycheck.department = result.department;
		$scope.paycheck.salary = result.payType === 2 ? result.rate : 0;
		$scope.paycheck.payCodes = [];
		$scope.paycheck.compensations = [];
		$scope.paycheck.deductions = [];
		$.each(result.payCodes, function (index1, paycode) {
			var pc = {
				payCode: paycode,
				hours: 0,
				overtimeHours: 0,
				screenHours: 0,
				screenOvertime: 0,
				pwAmount: 0
			};
			$scope.paycheck.payCodes.push(pc);
		});
		$.each(result.compensations, function (index2, comp) {
			var pt = {
				payType: comp.payType,
				amount: comp.amount,
				ytd: 0
			}
			$scope.paycheck.compensations.push(pt);
		});
		
		$uibModalInstance.close($scope.paycheck, result);
	};


});

common.controller('importTimesheetCtrl', function ($scope, $uibModalInstance, $filter, company, payChecks, payTypes, payrollRepository, $timeout, map) {
	$scope.company = company;
	$scope.payChecks = angular.copy(payChecks);
	$scope.payTypes = payTypes;
	$scope.alerts = [];
	if (map) {
		$scope.importMap = map;

	} else {
		$scope.importMap = {
			startingRow: 1,
			columnCount: 1,
			columnMap: []
		};
	}
	
	var requiredColumns = ['Employee No', 'Employee Name', 'SSN', 'Pay Rate/Salary'];
	$scope.selected = null;
	$scope.files = [];
	$scope.onFileSelect = function ($files) {
		$scope.files = [];
		if (!$files[0] || !($files[0].name.endsWith(".xlsx") || $files[0].name.endsWith(".csv"))) {
			$scope.alerts.push({
				message: 'Please select an excel or csv file '
			});
			return false;
		} else {
			$scope.alerts = [];
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
									companyId: $scope.company.id,
									payTypes: $scope.payTypes,
									importMap: $scope.importMap
								}),
								currentProgress: 0,
								completed: false
							});
							//uploadDocument();
						});
					}
				}(fileReader, i);
			}
		}
		

	};

	$scope.uploadDocument = function () {
		var importMap = angular.copy($scope.importMap);
		importMap.columnMap = $filter('filter')($scope.importMap.columnMap, { value: '!' + 0 });
		$scope.files[0].data = JSON.stringify({
			companyId: $scope.company.id,
			payTypes: $scope.payTypes,
			importMap: importMap
		});
		payrollRepository.importTimesheetsWithMap($scope.files[0]).then(function (timesheets) {
			var counter = 0;
			$.each(timesheets, function (ind, t) {
				var pc = null;
				if (t.ssn)
					pc = $filter('filter')($scope.payChecks, { employee: { ssn: t.ssn } })[0];
				else if (t.employeeNo) {
					pc = $filter('filter')($scope.payChecks, { employee: { employeeNo: t.employeeNo } })[0];
				}
				else if (t.name) {
					pc = $filter('filter')($scope.payChecks, { name: t.name })[0];
				}

				if (pc) {
					counter++;
					if (pc.employee.payType === 2)
						pc.salary = t.salary;
					else if (pc.employee.payType === 1) {
						$.each(t.payCodes, function (pcind, paycode) {
							var ec = $filter('filter')(pc.employee.payCodes, { id: paycode.payCode.id });
							if (ec) {
								var exists = $filter('filter')(pc.payCodes, { payCode: { id: paycode.payCode.id } });
								if (exists.length > 0) {
									exists[0].screenHours = paycode.screenHours;
									exists[0].screenOvertime = paycode.screenOvertime;
									exists[0].hours = paycode.hours;
									exists[0].overtimeHours = paycode.overtimeHours;
									if (paycode.payCode.id === 0 && paycode.payCode.hourlyRate) {
										exists[0].payCode.hourlyRate = paycode.payCode.hourlyRate;
									}
								} else
									pc.payCodes.push(paycode);
							}
						});
					} else {
						var pw = $filter('filter')(t.payCodes, { payCode: { id: 0 } });
						if (pw.length > 0 && pc.payCodes.length === 1) {
							pc.payCodes[0].pwAmount = pw[0].payCode.hourlyRate;
							pc.payCodes[0].hours = pw[0].hours;
							pc.payCodes[0].overtimeHours = pw[0].overtimeHours;
							pc.payCodes[0].screenHours = pw[0].screenHours;
							pc.payCodes[0].screenOvertime = pw[0].screenOvertime;
						}
					}
					$.each(t.compensations, function (cind, comp) {
						var exists = $filter('filter')(pc.compensations, { payType: { id: comp.payType.id } });
						if (exists.length > 0)
							exists[0].amount = comp.amount;
						else
							pc.compensations.push(comp);
					});
					pc.notes = t.notes;
				}

			});
			$uibModalInstance.close($scope.payChecks);

			
		}, function (error) {
			$scope.alerts.push({ message: 'error in importing timesheets: ' + error });

		});


	}
	$scope.cancel = function () {
		$uibModalInstance.close($scope);
	};
	$scope.showTable = function() {
		return $scope.importMap.startingRow && $scope.importMap.columnCount;
	}
	$scope.ready = function () {
		
		if (!$scope.showTable())
			return false;
		else if (!$scope.files && $scope.files.length!==1 && $scope.importMap.columnMap.length !== $scope.importMap.columnCount)
			return false;
		else {
			return true;
			
		}
	}
	
	$scope.availableColumns = function(index) {
		var returnList = [];
		$.each(requiredColumns, function (ind, r) {
			
				var exists = $filter('filter')($scope.importMap.columnMap, { key: r })[0];
				if (!exists || $scope.importMap.columnMap.indexOf(exists)===index)
					returnList.push(r);
				
			
		});
		return returnList;
	}

	$scope.setSelected = function(index) {
		$scope.selected = $scope.importMap.columnMap[index];
	}
	$scope.isItemValid = function(field) {
		if (!field.key || !field.value)
			return false;
		else {
			var matches = $filter('filter')($scope.importMap.columnMap, { value: field.value });
			if (matches.length > 1)
				return false;
			else {
				return true;
			}
		}
	}
	$scope.add = function () {
		var f = {
			key: '',
			value: ''
		};
		
		$scope.importMap.columnMap.push(f);
		$scope.setSelected($scope.importMap.columnMap.length-1);
	}
	$scope.saveSelected = function(field) {
		$scope.selected = null;
	}
	$scope.cancelSelected = function(field, index) {
		if (!field.key || !field.value)
			$scope.importMap.columnMap.splice(index, 1);
		$scope.selected = null;
	}
	var init = function () {
		requiredColumns.push('Notes');
		requiredColumns.push('Base Rate Hours');
		requiredColumns.push('Base Rate Overtime');
		
		$.each(company.payCodes, function (i, pc) {
			requiredColumns.push(pc.code + ' Hours');
			requiredColumns.push(pc.code + ' Overtime');
			
		});
		$.each(payTypes, function (i1, pt) {
			requiredColumns.push(pt.name);
			
		});
		//$scope.importMap.columnMap.push({
		//	key: 'Base Rate',
		//	value: 0
		//});
		//$scope.importMap.columnMap.push({
		//	key: 'Base Rate Hours',
		//	value: 0
		//});
		//$scope.importMap.columnMap.push({
		//	key: 'Base Rate Overtime',
		//	value: 0
		//});
		//$.each(company.payCodes, function(i, pc) {
		//	$scope.importMap.columnMap.push({
		//		key: pc.code + ' Hours',
		//		value: 0
		//	});
		//	$scope.importMap.columnMap.push({
		//		key: pc.code + ' Overtime',
		//		value: 0
		//	});
		//});
		//$.each(payTypes, function(i1, pt) {
		//	$scope.importMap.columnMap.push({
		//		key: pt.name,
		//		value: 0
		//	});
		//});
	}
	init();
});