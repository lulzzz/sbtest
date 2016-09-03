'use strict';

common.directive('payroll', ['$modal', 'zionAPI', '$timeout', '$window',
	function ($modal, zionAPI, $timeout, $window) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				item: "=item",
				datasvc: "=datasvc",
				company: "=company"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/payroll.html',

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'ngTableParams', 'EntityTypes', 'payrollRepository','$modal',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, payrollRepository, $modal) {
					var dataSvc = {
						opened: false,
						opened1: false,
						opened2: false,
						payTypes: $scope.datasvc.payTypes,
						employees: $scope.datasvc.employees,
						payTypeFilter: 0
						
					}
					
					$scope.list = [];
					$scope.dateOptions = {
						format: 'MM/dd/yyyy',
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
								dataSvc.payTypeFilter = filterbypaytype;
								orderedData = $filter('filter')(orderedData, { employee: { payType: filterbypaytype } });
							} else {
								filterbypaytype = dataSvc.payTypeFilter;
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
					
					
					$scope.process = function () {
						if (false === $('form[name="payrollstep1"]').parsley().validate()) {
							var errors = $('.parsley-error');
							return false;
						}
						
						payrollRepository.processPayroll($scope.item).then(function (data) {
							$timeout(function () {
								$scope.cancel();
								$scope.$parent.$parent.set(data);
							});
							
							
						}, function (error) {
							addAlert('error processing payroll', 'danger');
						});
					}
					$scope.showList = function() {
						if ($scope.list.length > 0 && $scope.item.startDate && $scope.item.endDate && $scope.item.payDay && $scope.item.startingCheckNumber)
							return true;
						else
							return false;
					}
					$scope.isPayrollInvalid = function () {
						var returnVal = false;
						$.each($scope.item.payChecks, function (index1, paycheck) {
							if ($scope.isPayCheckInvalid(paycheck)) {
								returnVal = true;
								return returnVal;
							}
						});
						return returnVal;
					}
					$scope.isPayCheckInvalid = function(pc) {
						var returnVal = false;
						var salary = pc.salary;
						var payCodeSum = 0;
						var comps = 0;
						$.each(pc.payCodes, function (index1, paycode) {
							payCodeSum += (paycode.hours + paycode.overtimeHours);
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
							templateUrl: 'popover/updatecomps.html',
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
								}
							}
						});
					}
					var init = function () {
						$scope.list = $scope.item.payChecks;
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						$scope.datasvc.isBodyOpen = false;
						$scope.minPayDate = new Date();
						if ($scope.company.payrollDaysInPast > 0) {
							$scope.minPayDate.setDate($scope.minPayDate.getDate() - $scope.company.payrollDaysInPast);
						}
					}
					init();


				}]
		}
	}
]);
common.controller('updateCompsCtrl', function ($scope, $modalInstance, $filter, paycheck, paytypes) {
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
		$modalInstance.close($scope);
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
		$modalInstance.close($scope);
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

common.controller('updateDedsCtrl', function ($scope, $modalInstance, $filter, paycheck, companydeductions) {
	$scope.original = paycheck;
	$scope.paycheck = angular.copy(paycheck);
	$scope.dedList = angular.copy(paycheck.deductions);
	$scope.deductionList = companydeductions;
	


	$scope.cancel = function () {
		$modalInstance.close($scope);
	};
	$scope.empty = function() {
		$scope.original.deductions = [];
		$modalInstance.close($scope);
	}
	$scope.permanentSave = function () {
		$scope.original.deductions = [];
		$.each($scope.dedList, function (index, dd) {
			dd.updateEmployee = true;
			$scope.original.deductions.push(dd);
		});
		$modalInstance.close($scope);
	};
	$scope.save = function () {
		$scope.original.deductions = [];
		$.each($scope.dedList, function (index, dd) {
			$scope.original.deductions.push(dd);
		});
		$modalInstance.close($scope);
	};

	
});