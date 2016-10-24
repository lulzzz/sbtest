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
						payTypeFilter: 0
						
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
					$scope.includeAll = function() {
						$.each($scope.list, function(index, p) {
							p.included = true;
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
							addAlert('error processing payroll', 'danger');
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
					$scope.isPayCheckInvalid = function(pc) {
						var returnVal = false;
						var salary = pc.salary;
						var payCodeSum = 0;
						var comps = 0;
						if (!pc.included)
							return false;
						$.each(pc.payCodes, function (index1, paycode) {
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
							resolve: {
								paycheck: function () {
									return listitem;
								},
								companydeductions: function () {
									return $scope.company.deductions;
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
					}
					$scope.showcompany = function () {
						var modalInstance = $modal.open({
							templateUrl: 'popover/company.html',
							controller: 'companyCtrl',
							size: 'lg',
							windowClass: 'my-modal-popup',
							backdrop: true,
							keyboard: true,
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
						modalInstance.result.then(function (companyUpdated, result) {
							if (result) {
								$scope.$parent.$parent.mainData.selectedCompany = result;
								$scope.item.company = result;
							}
						}, function () {
							return false;
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

common.controller('updateDedsCtrl', function ($scope, $uibModalInstance, $filter, paycheck, companydeductions, companyRepository) {
	$scope.original = paycheck;
	$scope.paycheck = angular.copy(paycheck);
	$scope.dedList = angular.copy(paycheck.deductions);
	$scope.deductionList = companydeductions;
	


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
		$.each(result.payCodes, function (index1, paycode) {
			var pc = {
				payCode: paycode,
				hours: 0,
				overtimeHours: 0,
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
		$uibModalInstance.close($scope);
	};


});