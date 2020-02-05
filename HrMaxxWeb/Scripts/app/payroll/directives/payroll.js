'use strict';

common.directive('payroll', ['$uibModal', 'zionAPI', '$timeout', '$window', 'version',
	function ($modal, zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				item: "=item",
				datasvc: "=datasvc",
				company: "=company",
				minPayDay: "=minPayDay",
				mainData: "=mainData"

			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/payroll.html?v=' + version,

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
						$scope.$parent.$parent.process($scope.item);
						
					}
					$scope.showList = function () {
						var returnVal = false;
						if (moment($scope.item.endDate) < moment($scope.item.startDate) || moment($scope.item.payDay) < $scope.minPayDate)
							returnVal= false;
						else if ($scope.list.length > 0 && $scope.item.startDate && $scope.item.endDate && $scope.item.payDay && $scope.item.startingCheckNumber && !dataSvc.importInProgress)
							returnVal = true;
						
						else
							returnVal = false;
						
						return returnVal;
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
					var getApplicableMinimumWage = function (companyMinWage, employeeState) {
						
						var federal = $filter('filter')($scope.datasvc.minWages, { stateId: null, year: moment($scope.item.payDay).year() })[0];
						$.each($scope.datasvc.minWages, function (i, st) {
							var matching = $filter('filter')($scope.datasvc.minWages, { stateId: employeeState.state.stateId, year: moment($scope.item.payDay).year() })[0];
							if (matching && matching.minWage > federal.minWage)
								federal = matching;
						});
						if (companyMinWage)
							federal.minWage = companyMinWage;
						return federal;
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
						var minWageRow = getApplicableMinimumWage($scope.company.minWage, pc.employee.state);
						$.each(pc.payCodes, function (index1, paycode) {
							paycode.hours = calculateHours(paycode.screenHours);
							paycode.overtimeHours = calculateHours(paycode.screenOvertime);
							payCodeSum += (paycode.hours + paycode.overtimeHours);
							if (paycode.payCode.id >= 0 && (paycode.hours > 0 || paycode.overtimeHours > 0)) {
								if ((!pc.employee.isTipped && (paycode.payCode.rateType < 2 && paycode.payCode.hourlyRate < minWageRow.minWage) || ((paycode.payCode.rateType === 2 && (pc.employee.rate * paycode.payCode.hourlyRate < minWageRow.minWage))))
									|| (pc.employee.isTipped && (paycode.payCode.rateType < 2 && paycode.payCode.hourlyRate < minWageRow.tippedMinWage) || ((paycode.payCode.rateType === 2 && (pc.employee.rate * paycode.payCode.hourlyRate < minWageRow.tippedMinWage))))
									) {
									if (paycode.payCode.hourlyRate <= 0) {
										pwAmount = 0;
										return;
									}
									pc.hasWarning = true;
								}
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
								},
								payday: function () {
									return $scope.item.payDay;
								},
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
					$scope.$watch('item.payDay',
						function (newValue, oldValue) {
							if (newValue !== oldValue ) {
								$scope.list = $scope.list.filter(function (pc) {
									if (!pc.employee.terminationDate) return true;
									else if (moment(pc.employee.terminationDate).startOf('day').toDate() < moment(newValue).startOf('day').toDate())
										return false;
									else
										return true;
								});
								$scope.fillTableData($scope.tableParams);
							}

						}, true
					);
					var init = function () {
						$scope.originals = angular.copy($scope.item.payChecks);
						$scope.list = $scope.item.payChecks;
						//$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						$scope.datasvc.isBodyOpen = false;
						$scope.minPayDate = moment().startOf('day');
						if ($scope.company.payrollDaysInPast > 0) {
							$scope.minPayDate = moment().add($scope.company.payrollDaysInPast * -1, 'day').startOf('day').toDate();
						}
						//if (moment($scope.minPayDay) > $scope.minPayDate && $scope.mainData.userRole !== 'SuperUser' && $scope.mainData.userRole !== 'Master') {
						//	$scope.minPayDate = moment($scope.minPayDay).startOf('day');
						//}
						
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
		$scope.original.included = true;
		$uibModalInstance.close($scope);
	};
	$scope.calculateWage = function (paytype) {
		if (paytype) {
			var accPayType = $filter('filter')($scope.original.employee.accumulations, { payTypeId: paytype.id });


			if (accPayType.length === 0) {
				if (paytype.id === 6 && $scope.original.employee.carryOver>0) {
					var hrs = $scope.original.employee.carryOver;
					if ($scope.original.employee.payType === 1 || $scope.original.employee.payType === 3) {
						accumulated = hrs * $scope.original.employee.rate;
					}
					if ($scope.original.employee.payType === 4) {
						accumulated = hrs * $scope.original.salary;
					}
					else if ($scope.original.employee.payType === 2) {
						var rate = $scope.original.employee.rate;
						var schedule = $scope.original.employee.payrollSchedule;
						var quotient = schedule === 1 ? 52 : schedule === 2 ? 26 : schedule === 3 ? 24 : 12;
						accumulated = hrs * rate * (quotient / (40 * 52));
					}
					return 'Available: ' + hrs + 'hrs (' + $filter('currency')(accumulated, '$') + ')';
				}
				else
					return '';
			}
				
			else {
				var accumulated = 0;
				var sorted = $filter('orderBy')(accPayType, 'fiscalEnd', true);
				var hrs = sorted[0].available;
				if ($scope.original.employee.payType === 1 || $scope.original.employee.payType === 3) {
					accumulated = hrs * $scope.original.employee.rate;
				}
				else if ($scope.original.employee.payType === 4) {
					var rate = $scope.original.salary;
					var schedule = $scope.original.employee.payrollSchedule;
					var quotient = schedule === 1 ? 52 : schedule === 2 ? 26 : schedule === 3 ? 24 : 12;
					accumulated = hrs * rate * (quotient / (40 * 52));
					
				} else if ($scope.original.employee.payType === 2) {
					var rate = $scope.original.employee.rate;
					var schedule = $scope.original.employee.payrollSchedule;
					var quotient = schedule === 1 ? 52 : schedule === 2 ? 26 : schedule === 3 ? 24 : 12;
					accumulated = hrs * rate * (quotient / (40 * 52));
				}
				return 'Available: ' + hrs + 'hrs (' + $filter('currency')(accumulated, '$') + ')';
			}
		}
		
		
	}
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

common.controller('updateJobCostCtrl', function ($scope, $uibModalInstance, $filter, paycheck) {
	$scope.original = paycheck;
	$scope.paycheck = angular.copy(paycheck);
	
	$scope.changesMade = false;
	
	$scope.cancel = function () {
		$uibModalInstance.close($scope);
	};
	$scope.save = function () {
		if (false === $('form[name="jobcostform"]').parsley().validate()) {
			var errors = $('.parsley-error');
			return false;
		}
		$scope.original.payCodes = [];
		$.each($scope.paycheck.payCodes, function (index, pt) {
			$scope.original.payCodes.push($scope.paycheck.payCodes[index]);
		});
		$scope.original.included = true;
		$uibModalInstance.close($scope);
	};
	
	
	var _init = function () {
		
	}
	_init();
});

common.controller('updateDedsCtrl', function ($scope, $uibModalInstance, $filter, paycheck, companydeductions, agencies, companyRepository, payday) {
	$scope.original = paycheck;
	$scope.paycheck = angular.copy(paycheck);
	$scope.dedList = angular.copy(paycheck.deductions);
	$scope.deductionList = companydeductions;
	$scope.agencies = agencies;
	$scope.payDay = moment(payday).startOf('day').toDate();

	$scope.isValid = function () {
		var returnVal = true;
		$.each($scope.dedList, function(i,d)
		{
			if (d.rate!==0 && !isDeductionValid(d)) {
				returnVal = false;
				return false;
			}
		});
		return returnVal;
	}
	var isDeductionValid = function (item) {
        if (!item.deduction || !item.method || !item.rate || (item.ceilingMethod === 1 && (item.ceilingPerCheck < 0 || item.ceilingPerCheck > 100)))
			return false;
		else if (item.deduction.type.id === 3) {
			if (!item.accountNo || !item.agencyId)
				return false;
			

		}
		else
			return true;
	}
	$scope.cancel = function () {
		$uibModalInstance.dismiss();
	};
	$scope.empty = function() {
		$scope.original.deductions = [];
		$uibModalInstance.close($scope);
	}
	$scope.permanentSave = function () {
		$scope.original.deductions = [];
		$.each($scope.dedList, function (index, dd) {
			if (!dd.employeeDeduction) {
				dd.employeeDeduction = {
					id: 0,
					employeeId: $scope.original.employee.id,
					deduction: dd.deduction
				}
			}
			dd.employeeDeduction.employeeId = $scope.original.employee.id;
			dd.employeeDeduction.method = dd.method;
			dd.employeeDeduction.rate = dd.rate;
			dd.employeeDeduction.annualMax = dd.annualMax;
            dd.employeeDeduction.ceilingPerCheck = dd.ceilingPerCheck;
            dd.employeeDeduction.ceilingPerCheck1 = dd.employeeDeduction.ceilingPerCheck;
            dd.employeeDeduction.ceilingMethod = dd.ceilingMethod;
            dd.employeeDeduction.employerRate = dd.employerRate;
			dd.employeeDeduction.limit = dd.limit;
			dd.employeeDeduction.accountNo = dd.accountNo;
			dd.employeeDeduction.agencyId = dd.agencyId;
			dd.employeeDeduction.priority = dd.priority;
			dd.employeeDeduction.startDate = dd.startDate;
			dd.employeeDeduction.endDate = dd.endDate;
            companyRepository.saveEmployeeDeduction(dd.employeeDeduction).then(function (deduction) {
                dd.employeeDeduction.id = deduction.id;
                
            }, function (error) {
                
            });
			
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
			dd.employeeDeduction.employeeId = $scope.original.employee.id;
			dd.employeeDeduction.method = dd.method;
			dd.employeeDeduction.rate = dd.rate;
			dd.employeeDeduction.annualMax = dd.annualMax;
            dd.employeeDeduction.ceilingPerCheck = dd.ceilingPerCheck;
            dd.employeeDeduction.ceilingPerCheck1 = dd.employeeDeduction.ceilingPerCheck;
            dd.employeeDeduction.ceilingMethod = dd.ceilingMethod;
            dd.employeeDeduction.employerRate = dd.employerRate;
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
		$scope.paycheck.companyEmployeeNo = result.companyEmployeeNo;
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
			pc.payCode.hourlyRate = 0;
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

common.controller('importTimesheetCtrl', function ($scope, $uibModalInstance, $filter, company, payChecks, payTypes, payrollRepository, $timeout, map, main, mainData) {
	$scope.company = company;
	$scope.payChecks = angular.copy(payChecks);
	$scope.payTypes = payTypes;
	$scope.alerts = [];
	$scope.messages = [];
	if (map) {
		$scope.importMap = angular.copy(map);
		$scope.importMap.lastRow = null;
		if (!$scope.importMap.selfManagedPayTypes) {
			$scope.importMap.selfManagedPayTypes = [];
		}

	} else {
		$scope.importMap = {
			startingRow: 1,
			columnCount: 1,
			lastRow: null,
			columnMap: [],
			hasJobCost: false,
			jobCostStartingColumn: 0,
			jobCostColumnCount: 4,
			jobCostMap: [],
			selfManagedPayTypes: []
		};
	}
	var jobCostColumns = ['Amount', 'Rate', 'Pieces'];
	var requiredColumns = ['Employee No', 'Employee Name', 'SSN', 'Pay Rate/Salary', 'Clock Id'];
	$scope.selected = null;
	$scope.files = [];
	$scope.onFileSelect = function ($files) {
		$scope.files = [];
		if (!$files[0] || !($files[0].name.toLowerCase().endsWith(".xlsx") || $files[0].name.toLowerCase().endsWith(".csv") || $files[0].name.toLowerCase().endsWith(".txt"))) {
			$scope.alerts.push({
				message: 'Please select an excel, csv or txt (comma separated file) file '
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
		//if (false === $('form[name="timesheetform"]').parsley().validate()) {
		//	var errors = $('.parsley-error');
		//	return false;
		//}
		$scope.alerts = [];
		var importMap = angular.copy($scope.importMap);
		importMap.columnMap = [];
		$.each($scope.importMap.columnMap, function(i3, cm) {
			if (cm.value !== 0)
				importMap.columnMap.push(cm);
		});
		//importMap.columnMap = $filter('filter')($scope.importMap.columnMap, { value: '!' + 0 });
		$scope.files[0].data = JSON.stringify({
			companyId: $scope.company.id,
			payTypes: $scope.payTypes,
			importMap: importMap
		});
		mainData.confirmDialog('this will try and import ' + ($scope.importMap.lastRow ? ($scope.importMap.lastRow - $scope.importMap.startingRow + 1) : 'maximum') + ' checks? do you want to proceed ?', 'warning', function () {
			payrollRepository.importTimesheetsWithMap($scope.files[0]).then(function(timesheets) {
				var counter = 0;
				var messages = [];
				$.each(timesheets, function(ind, t) {
					var pc = null;
					if (t.ssn)
						pc = $filter('filter')($scope.payChecks, { employee: { ssn: t.ssn } })[0];
					else if (t.employeeNo) {
						pc = $filter('filter')($scope.payChecks, { employee: { companyEmployeeNo: parseInt(t.employeeNo) } }, true)[0];
					}
					else if (t.clockId) {
						pc = $filter('filter')($scope.payChecks, { employee: { clockId: t.clockId } }, true)[0];
					} else if (t.name) {
						pc = $filter('filter')($scope.payChecks, { name: t.name })[0];
					}

					if (pc) {
						pc.included = true;
						counter++;
						if (pc.employee.payType === 2) {
							pc.salary = t.gross ? t.gross : t.salary;
						} else if (pc.employee.payType === 4) {
							pc.salary = t.gross ? t.gross : t.salary;
							pc.payCodes = [];
							var basePC = $filter('filter')(t.payCodes, { payCode: { id: 0 } })[0];
							if (basePC) {
								if (t.salary) {
									basePC.payCode.hourlyRate = t.salary;
								}
								pc.payCodes.push(basePC);
							}
							$.each(t.jobCostCodes, function(pcind, paycode) {
								var payc = {
									payCode: paycode.payCode,
									screenHours: paycode.hours ? paycode.hours : 0,
									screenOvertime: 0,
									hours: 0,
									overtimeHours: 0,
									amount: paycode.amount ? paycode.amount : 0
								};
								pc.payCodes.push(payc);
							});
						} else if (pc.employee.payType === 1) {
							$.each(t.payCodes, function(pcind, paycode) {
								if (paycode.payCode.id >= 0) {
									var ec = $filter('filter')(pc.employee.payCodes, { id: paycode.payCode.id });
									if (ec) {
										var exists = $filter('filter')(pc.payCodes, { payCode: { id: paycode.payCode.id } });
										if (exists.length > 0) {
											exists[0].screenHours = paycode.screenHours ? paycode.screenHours : 0;
											exists[0].screenOvertime = paycode.screenOvertime ? paycode.screenOvertime : 0;
											exists[0].hours = paycode.hours ? paycode.hours : 0;
											exists[0].overtimeHours = paycode.overtimeHours ? paycode.hours : 0;
											if (paycode.payCode.id === 0 && t.salary) {
												exists[0].payCode.hourlyRate = t.salary;
											}
										} else
											pc.payCodes.push(paycode);
									}
								}
							});
						} else {
							var pw = $filter('filter')(t.payCodes, { payCode: { id: -1 } });
							var ppw = $filter('filter')(pc.payCodes, { payCode: { id: -1 } });
							if (pw.length > 0 && ppw.length > 0) {

								ppw[0].pwAmount = t.gross ? t.gross : pw[0].payCode.hourlyRate;
								ppw[0].hours = pw[0].hours ? pw[0].hours : 0;
								ppw[0].overtimeHours = pw[0].overtimeHours ? pw[0].overtimeHours : 0;
								ppw[0].screenHours = pw[0].screenHours ? pw[0].screenHours : 0;
								ppw[0].screenOvertime = pw[0].screenOvertime ? pw[0].screenOvertime : 0;
								ppw[0].breakTime = t.prBreakTime ? t.prBreakTime : 0;
								ppw[0].sickLeaveTime = t.sickLeaveTime ? t.sickLeaveTime : 0;
							}
							var br = $filter('filter')(t.payCodes, { payCode: { id: 0 } });
							var pbr = $filter('filter')(pc.payCodes, { payCode: { id: 0 } });
							if (br.length > 0 && pbr.length > 0) {

								pbr[0].hours = br[0].hours ? br[0].hours : 0;
								pbr[0].overtimeHours = br[0].overtimeHours ? br[0].overtimeHours : 0;
								pbr[0].screenHours = br[0].screenHours ? br[0].screenHours : 0;
								pbr[0].screenOvertime = br[0].screenOvertime ? br[0].screenOvertime : 0;
								pbr[0].breakTime = t.breakTime ? t.breakTime : 0;
								if (pbr[0].payCode.id === 0 && t.salary) {
									pbr[0].payCode.hourlyRate = t.salary;
								}
							}
						}
						pc.compensations = [];
						$.each(t.compensations, function(cind, comp) {
							pc.compensations.push(comp);
						});
						
						$.each(t.deductions, function (dind, dd) {
							var edd = $filter('filter')(pc.deductions, { deduction: { id: dd.deduction.id } })[0];
							if (edd) {
								edd.rate = dd.rate;
								edd.method = dd.method;
								edd.employeeDeduction.method = dd.method;
								edd.employeeDeduction.rate = dd.rate;
								dd.employeeDeduction = edd;
							} else {
								var selectedded = {
									id: 0,
									employeeId: pc.employee.id,
									deduction: dd.deduction,
									method: dd.method,
									rate: dd.rate,
									annualMax: null,
									limit: null,
									ceilingPerCheck: null,
									ceilingMethod: {
										key: 1,
										value: 'Percentage'
									}

								};
								dd.employeeDeduction = selectedded;
								pc.deductions.push(dd);
							}
							
							
						});
						pc.notes = t.notes ? t.notes : '';
						if (t.accumulations.length > 0)
							pc.accumulations = t.accumulations;
					} else {
						if (t.ssn)
							messages.push(t.ssn);
						else if (t.employeeNo) {
							messages.push(t.employeeNo);
						}
						else if (t.clcckId) {
							messages.push(t.clockId);
						} else if (t.name) {
							messages.push(t.name);
						}
					}

				});
				$scope.messages = messages;
				$uibModalInstance.close($scope);


			}, function (error) {
				$scope.alerts.push({ message: error });

			});
		});

	}
	$scope.cancel = function () {
		
		$uibModalInstance.dismiss();
	};
	$scope.showTable = function() {
		return $scope.importMap.startingRow && $scope.importMap.columnCount;
	}
	$scope.ready = function () {
		
		if (!$scope.showTable())
			return false;
		else if (!$scope.files || $scope.files.length!==1 || $scope.importMap.columnMap.length===0)
			return false;
		else {
			return true;
			
		}
	}
	$scope.selfManagedAccumulations = [];
		
	
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
			var matches = $filter('filter')($scope.importMap.columnMap, { value: field.value }, true);
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
	$scope.delete = function(index) {
		$scope.importMap.columnMap.splice(index, 1);
	}
	$scope.changeHasJobCost = function() {
		if ($scope.importMap.hasJobCost) {
			$.each(jobCostColumns, function (i2, jc) {
				$scope.importMap.jobCostMap.push({
					key: jc,
					value: i2 + 1
				});
			});
			$scope.importMap.jobCostMap.push({
				key: 'Description',
				value: 4
			});

		} else {
			$scope.jobCostMap = [];
			$scope.importMap.jobCostColumnCount = 4;
			$scope.importMap.jobCostStartingColumn = 0;

		}
	}
	$scope.setJobCost = function () {
		if ($scope.importMap.jobCostColumnCount === 3) {
			var desc = $filter('filter')($scope.importMap.jobCostMap, { key: 'Description' })[0];
			if (desc) {
				$scope.importMap.jobCostMap.splice($scope.importMap.jobCostMap.indexOf(desc),1);
			}
		}
		if ($scope.importMap.jobCostColumnCount === 4) {
			var desc = $filter('filter')($scope.importMap.jobCostMap, { key: 'Description' })[0];
			if (!desc) {
				var max = $filter('orderBy')($scope.importMap.jobCostMap, 'value', true);
				$scope.importMap.jobCostMap.push({
					key: 'Description',
					value: max
				});
			}
			
		}
	}
	var init = function () {
		var selfManagedAccumulations = $filter('filter')($scope.company.accumulatedPayTypes, { companyManaged: true });
		requiredColumns.push('Notes');
		
		requiredColumns.push('Base Rate Hours');
		requiredColumns.push('Base Rate Overtime');
		requiredColumns.push('Base Rate Amount');
		requiredColumns.push('Base Rate Overtime Amount');
		requiredColumns.push('Break Time');
		
		$.each(company.payCodes, function (i, pc) {
			requiredColumns.push(pc.code + ' Hours');
			requiredColumns.push(pc.code + ' Overtime');
			
		});
		$.each(payTypes, function (i1, pt) {
			requiredColumns.push(pt.name);
			
		});
		requiredColumns.push('Gross Wage/PieceRate Amount');
		requiredColumns.push('PieceRate Hours');
		requiredColumns.push('PieceRate Overtime');
		requiredColumns.push('PieceRate Break Hours');
		requiredColumns.push('PieceRate Sick Leave Hours');

		$.each(selfManagedAccumulations, function (i2, apt) {
			var exists = $filter('filter')($scope.importMap.selfManagedPayTypes, { payTypeId: apt.id })[0];
			if (exists) {
				exists.payType = apt.payType;
			} else {
				var apt1 = {
					payType: apt.payType,
					payTypeId: apt.id,
					importMap: []
				}
				apt1.importMap.push({
					key: 'Used', value: 0
				});
				apt1.importMap.push({
					key: 'Accumulated', value: 0
				});
				apt1.importMap.push({
					key: 'YTD Accumulated', value: 0
				});
				apt1.importMap.push({
					key: 'YTD Used', value: 0
				});
				$scope.importMap.selfManagedPayTypes.push(apt1);
			}
			

		});

		$.each(company.deductions, function (i, d) {
			var dedname = d.type.categoryText + ' - ' + d.type.name + ': ' + d.deductionName;
			requiredColumns.push(dedname + ' Amount');
			requiredColumns.push(dedname + ' Percentage');

		});
		
	}
	init();
});