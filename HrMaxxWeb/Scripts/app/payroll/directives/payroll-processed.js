'use strict';

common.directive('payrollProcessed', ['$uibModal', 'zionAPI', '$timeout', '$window', 'version',
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
			templateUrl: zionAPI.Web + 'Areas/Client/templates/payroll-processed.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'ngTableParams', 'EntityTypes', 'payrollRepository',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, payrollRepository) {
					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,
						filter: {
							included: true
						},
						sorting: {
							companyEmployeeNo: 'asc'     // initial sorting
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
							$scope.tableData = orderedData;
							$scope.tableParams = params;
							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					$scope.cancel = function () {
						if ($scope.item.status > 2 && $scope.item.status!==6) {
							$scope.$parent.$parent.committed = null;
						}
						else if ($scope.item.status === 6) {
							$scope.$parent.$parent.$parent.$parent.confirmDialog('This action will ONLY retain the matching timesheets from the draft. Are you sure you want to proceed? You may cancel at Step 1 to retain the draft', 'info', function() {
								$scope.$parent.$parent.refresh($scope.item);
								$scope.datasvc.isBodyOpen = true;
							});
						}
						else {
							$.each($scope.item.payChecks, function (index1, paycheck) {
								paycheck.employeeNo = paycheck.employee.employeeNo;
								paycheck.companyEmployeeNo = paycheck.employee.companyEmployeeNo;
								paycheck.name = paycheck.employee.name;
								paycheck.department = paycheck.employee.department;
								paycheck.status = 1;
								$.each(paycheck.deductions, function (ind2, d) {
									if (d.employeeDeduction) {
										d.ceilingPerCheck = d.employeeDeduction.ceilingPerCheck;
										d.limit = d.employeeDeduction.limit;
										d.accountNo = d.employeeDeduction.accountNo;
										d.agencyId = d.employeeDeduction.agencyId;
										d.priority = d.employeeDeduction.priority;
									}
								});
							});
							$scope.item.startDate = moment($scope.item.startDate).toDate();
							$scope.item.endDate = moment($scope.item.endDate).toDate();
							$scope.item.payDay = moment($scope.item.payDay).toDate();
							$scope.item.status = 1;
							var copyitem = angular.copy($scope.item);
							$scope.item = null;
							$scope.$parent.$parent.set(copyitem);
						}
						
						$scope.datasvc.isBodyOpen = true;
					}
					
					$scope.getDocumentUrl = function (check) {
						return zionAPI.URL + 'Payroll/Print/'  + check.documentId + '/' + check.payrollId + '/' + check.id ;
					};
					$scope.save = function () {
						$scope.item.payChecks = $filter('filter')($scope.item.payChecks, {included:true});
						payrollRepository.commitPayroll($scope.item).then(function (data) {
							if (!$scope.mainData.selectedCompany.lastPayrollDate || moment($scope.mainData.selectedCompany.lastPayrollDate) < moment($scope.item.payDay))
								$scope.mainData.selectedCompany.lastPayrollDate = moment($scope.item.payDay).toDate();
							$scope.$parent.$parent.updateListAndItem($scope.item.id);
							
						}, function (error) {
							addAlert('error committing payroll', 'danger');
						});
					}
					$scope.saveStaging = function () {
						$scope.$parent.$parent.$parent.$parent.confirmDialog('Are you sure you want to save this Payroll as Draft? Draft Payrolls are not included in reporting figures', 'danger', function() {
								$scope.item.payChecks = $filter('filter')($scope.item.payChecks, { included: true });
								payrollRepository.savePayrollToStaging($scope.item).then(function(data) {
									$scope.$parent.$parent.updateListAndItem($scope.item.id);
								}, function(error) {
									addAlert('error saving payroll as draft', 'danger');
								});
							}
						);
					}

					$scope.markPrinted = function(listitem) {
						payrollRepository.printPayCheck(listitem.documentId, listitem.id).then(function(data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
							if (listitem.status === 3 || listitem.status === 5) {
								payrollRepository.markPayCheckPrinted(listitem.id).then(function() {
									var status = listitem.status === 3 ? 4 : 6;
									var statusText = listitem.status === 3 ? "Printed" : "Printed and Paid";
									$scope.$parent.$parent.updateStatus(listitem.id, status, statusText);

								}, function(error) {
									addAlert('error marking pay check as printed', 'danger');
								});
							}


						}, function(error) {
							addAlert('error printing pay check', 'danger');
						});
					}
					$scope.printPayrollChecks = function (payroll) {
						payrollRepository.printPayrollChecks(payroll).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
							if(payroll.status>2)
								$scope.$parent.$parent.updatePrintStatus();
						}, function (error) {
							addAlert('error printing pay check', 'danger');
						});
					}
					$scope.printPayrollReport = function (payroll) {
						payrollRepository.printPayrollReport(payroll).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
							if (payroll.status > 2)
								$scope.$parent.$parent.updatePrintStatus();
						}, function (error) {
							addAlert('error printing pay check', 'danger');
						});
					}
					$scope.isPrintable = function(payroll) {
						var nonVoids = $filter('filter')(payroll.payChecks, { isVoid: false });
						if (nonVoids.length > 0)
							return true;
						else {
							return false;
						}
					}
					var getQuarter = function(month) {
						if (month < 4)
							return 1;
						if (month < 7)
							return 2;
						if (month < 10)
							return 3;
						return 4;
					}
					$scope.voidcheck = function (listitem) {
						$scope.$parent.$parent.$parent.$parent.confirmDialog('Are you sure you want to mark this check Void?', 'info', function () {
							var checkQuarter = getQuarter(moment(listitem.payDay).format("MM"));
							var thisQuarter = getQuarter(moment().format("MM"));
							var checkYear = moment(listitem.payDay).format("YYYY");
							var thisYear = moment().format("YYYY");
							if (checkYear <= thisYear && checkQuarter < thisQuarter) {
								$scope.$parent.$parent.$parent.$parent.confirmDialog('This check was issued in a previous quarter. are you sure you want to mark this check Void?', 'danger', function() {
									payrollRepository.voidPayCheck($scope.item.id, listitem.id).then(function(data) {
										$scope.$parent.$parent.updateListAndItem($scope.item.id);
									}, function(error) {
										addAlert('error voiding pay check', 'danger');
									});
								});
							} else {
								payrollRepository.voidPayCheck($scope.item.id, listitem.id).then(function (data) {
									$scope.$parent.$parent.updateListAndItem($scope.item.id);
								}, function (error) {
									addAlert('error voiding pay check', 'danger');
								});
							}
							
						});
					}
					$scope.viewcheck = function(listitem) {
						var modalInstance = $modal.open({
							templateUrl: 'popover/reviewpaycheck.html',
							controller: 'paycheckPopupCtrl',
							size: 'lg',
							resolve: {
								paycheck: function() {
									return listitem;
								}
							}
						});
					}
					$scope.canConfirm = function() {
						$scope.minPayDate = moment().startOf('day');
						if ($scope.mainData.selectedCompany.payrollDaysInPast > 0) {
							$scope.minPayDate = moment().add($scope.mainData.selectedCompany.payrollDaysInPast * -1, 'day').startOf('day').toDate();
						}
						if (($scope.item.status === 2 || $scope.item.status === 6) && (moment($scope.item.payDay)<$scope.minPayDate))
							return false;
						else if ($scope.item.status === 2) {
							var inValidChecks = 0;
							$.each($scope.item.payChecks, function(ind, pc) {
								if (pc.included && (pc.netWage < 0 || pc.netWage===0)) {
									inValidChecks++;
								}
							});
							return inValidChecks === 0;
						}
						else
							return true;
					}
					var init = function () {
						if($scope.item.status===2)
							$scope.datasvc.isBodyOpen = false;
						else
							$scope.datasvc.isBodyOpen = true;
						$scope.list = $scope.item.payChecks;
						$.each($scope.list, function(i, p) {
							p.name = p.employee.name;
							p.companyEmployeeNo = p.employee.companyEmployeeNo;
							p.employeeNo = p.employee.employeeNo;
						});
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
					}
					init();


				}]
		}
	}
]);
common.controller('paycheckPopupCtrl', function ($scope, $uibModalInstance, $filter, paycheck) {
	$scope.check = paycheck;
	

});
