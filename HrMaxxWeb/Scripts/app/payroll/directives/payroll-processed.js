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

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'NgTableParams', 'EntityTypes', 'payrollRepository',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, payrollRepository) {
					
					$scope.tableData = [];
					
					$scope.totalChecks = null;
					$scope.showTaxes = $scope.item.isHistory;
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,
						filter: {
							included: true
						},
						sorting: {
							checkNumber: 'asc'     // initial sorting
						}
					}, {
						total: $scope.list ? $scope.list.length : 0, // length of data
						getData: function (params) {
							if($scope.list && $scope.list.length>0)
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
								$scope.$parent.$parent.refresh($scope.item, true, 2);
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
								if (paycheck.grossWage > 0) {
									paycheck.included = true;
									paycheck.hasError = false;
									paycheck.hasWarning = false;
								}
								else {
									paycheck.included = false;
								}
								paycheck.userActioned = true;
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
						$scope.$parent.$parent.save($scope.item, $scope.totalChecks);
					}
					$scope.saveStaging = function () {
						$scope.$parent.$parent.$parent.$parent.confirmDialog('Are you sure you want to save this Payroll as Draft? Draft Payrolls are not included in reporting figures', 'danger', function() {
								$scope.item.payChecks = $filter('filter')($scope.item.payChecks, { included: true });
								payrollRepository.savePayrollToStaging($scope.item).then(function(data) {
									$scope.$parent.$parent.updateListAndItem($scope.item.id);
								}, function(error) {
									$scope.mainData.showMessage('error saving payroll as draft', 'danger');
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
									$scope.mainData.showMessage('error marking pay check as printed', 'danger');
								});
							}


						}, function(error) {
							$scope.mainData.showMessage('error printing pay check', 'danger');
						});
					}
					$scope.reIssueCheck = function (listitem) {
						payrollRepository.reIssueCheck(listitem.id).then(function () {
							$scope.mainData.showMessage('successfully re-issued pay check', 'success');
							$scope.$parent.$parent.updateListAndItem($scope.item.id);
						}, function (error) {
								$scope.mainData.showMessage('error printing pay check', 'danger');
						});
					}
					$scope.fixPayrollYTD = function () {
						payrollRepository.fixPayrollYTD($scope.item.id).then(function () {
							$scope.mainData.showMessage('successfully fixed payroll ytd', 'success');
							$scope.$parent.$parent.updateListAndItem($scope.item.id);
						}, function (error) {
								$scope.mainData.showMessage('error fixing payroll ytd', 'danger');
						});
					}
					
					$scope.printPayrollChecks = function (payroll, reprint) {
						payrollRepository.printPayrollChecks(payroll.id, reprint, $scope.company.companyCheckPrintOrder).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
							if (payroll.status > 2)
								$scope.$parent.$parent.updatePrintStatus();
						}, function (error) {
							$scope.mainData.handleError('Error: ' , error, 'danger');
						});
					}
					$scope.printPayrollPack = function (payroll) {
						payrollRepository.printPayrollPack(payroll).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
							
						}, function (error) {
							$scope.mainData.handleError('Error: ' , error, 'danger');
						});
					}
					$scope.eftChecks = function() {
						var fil = $filter('filter')($scope.item.payChecks, { paymentMethod: 2 });
						return fil;
					}
					$scope.emailPayrollPack = function (payroll) {
						var confirmMessage = "Are you sure you want to send emails to client Employees with ACH check? please verify below employees below <br/><br/> <ul>";
						$.each($scope.eftChecks(), function(i, pc) {
							if (pc.paymentMethod === 2) {
								if(pc.employee.contact.email)
									confirmMessage += "<li>" + pc.name + " (" + pc.employee.contact.email + " )" + "</li>";
								else
									confirmMessage += "<li>" + pc.name + " ( No Email Address Available )" + "</li>";
							}
						});
						confirmMessage += "</ul>";
						$scope.$parent.$parent.$parent.$parent.confirmDialog(confirmMessage, 'warning', function () {
							payrollRepository.emailPayrollPack(payroll).then(function (data) {
								
								$scope.$parent.$parent.$parent.$parent.addAlerts('', data, 'success');
								}, function (error) {
									$scope.mainData.handleError('Error: ' , error, 'danger');
								});
							}
						);


						
					}
					$scope.recalculateAccumulations = function (payroll) {
						var confirmMessage = "Are you sure you want to re-calculate accumulations? please confirm";
						
						$scope.mainData.confirmDialog(confirmMessage, 'warning', function () {
							payrollRepository.recalculateAccumulations(payroll).then(function (data) {
								$scope.item = data;
								
								$scope.mainData.showMessage('successfully re-calculated accumulations', 'success');
								init();
							}, function (error) {
								$scope.mainData.handleError('Error: ' , error, 'danger');
							});
						}
						);



					}
					
					$scope.printPayrollReport = function (payroll) {
						payroll.company.companyCheckPrintOrder = $scope.company.companyCheckPrintOrder;
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
								$scope.mainData.showMessage('error printing pay check', 'danger');
						});
					}
					$scope.printPayrollTimesheet = function (payroll) {
						payroll.company.companyCheckPrintOrder = $scope.company.companyCheckPrintOrder;
						payrollRepository.printPayrollTimesheet(payroll).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
						}, function (error) {
								$scope.mainData.showMessage('error printing pay check', 'danger');
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
					$scope.updatePayrollDates = function() {
						$scope.$parent.$parent.$parent.$parent.confirmDialog('Are you sure you want to change the payroll dates?', 'warning', function () {
							$scope.item.startDate = moment($scope.item.startDate).format("MM/DD/YYYY");
							$scope.item.endDate = moment($scope.item.endDate).format("MM/DD/YYYY");
							payrollRepository.updatePayrollDates($scope.item).then(function () {
								$scope.$parent.$parent.updateListAndItem($scope.item.id);
							}, function (error) {
									$scope.mainData.showMessage('error updating payroll dates', 'danger');
							});
						});
					}
					$scope.updateCheckNumbers = function () {
						$scope.$parent.$parent.$parent.$parent.confirmDialog('Are you sure you want to change check numbers for this payroll?', 'warning', function () {
							payrollRepository.updateCheckNumber($scope.item).then(function () {
								$scope.$parent.$parent.updateListAndItem($scope.item.id);
							}, function (error) {
								$scope.mainData.handleError('',error, 'danger');
							});
						});
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
											$scope.mainData.showMessage('error voiding pay check', 'danger');
									});
								});
							} else {
								payrollRepository.voidPayCheck($scope.item.id, listitem.id).then(function (data) {
									$scope.$parent.$parent.updateListAndItem($scope.item.id);
								}, function (error) {
										$scope.mainData.showMessage('error voiding pay check', 'danger');
								});
							}
							
						});
					}

					$scope.unvoidcheck = function (listitem) {
						$scope.$parent.$parent.$parent.$parent.confirmDialog('Are you sure you want to Un-Void? you will have adjust invoices and extracts yourself', 'info', function () {
							payrollRepository.unvoidPayCheck($scope.item.id, listitem.id).then(function (data) {
								$scope.$parent.$parent.updateListAndItem($scope.item.id);
							}, function (error) {
									$scope.mainData.showMessage('error voiding pay check', 'danger');
							});
							

						});
					}
					$scope.selectedTaxItem = null;
					$scope.setSelectedTaxItem = function(listitem) {
						$scope.originalTaxItem = angular.copy(listitem);
						$scope.selectedTaxItem = angular.copy(listitem);
					}
					$scope.saveSelectedTaxItem = function (listitem) {
						$.each(listitem.taxes, function(ind, t) {
							var ot = $filter('filter')($scope.originalTaxItem.taxes, { tax: { id: t.tax.id } })[0];
							t.ytdTax = ot.ytdTax - ot.amount + t.amount;
							if (t.tax.isEmployeeTax) {
								listitem.netWage = listitem.netWage + ot.amount - t.amount;
								listitem.ytdNetWage = listitem.ytdNetWage + ot.amount - t.amount;
							}
						});
						$scope.originalTaxItem = null;
						$scope.selectedTaxItem = null;
						return listitem;
					}
					$scope.cancelSelectedTaxItem = function (listitem) {
						listitem = angular.copy($scope.originalTaxItem);
						$scope.originalTaxItem = null;
						$scope.selectedTaxItem = null;
						return listitem;
					}
					$scope.viewcheck = function(listitem) {
						var modalInstance = $modal.open({
							templateUrl: 'popover/reviewpaycheck.html',
							controller: 'paycheckPopupCtrl',
							size: 'md',
							windowClass: 'my-modal-popup',
							resolve: {
								paycheck: function() {
									return listitem;
								},
								maindata: function() {
									return $scope.mainData;
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
						$scope.originalStartingCheckNumber = $scope.item.startingCheckNumber;
						if ($scope.item.status > 2 && $scope.item.status !== 6) {
							$scope.item.startDate = moment($scope.item.startDate).toDate();
							$scope.item.endDate = moment($scope.item.endDate).toDate();
						}
						
						$scope.datasvc.isBodyOpen = false;
						
						$scope.list = $scope.item.payChecks;
						$scope.totalChecks = $filter('filter')($scope.list, { included: true }, true).length;
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
common.controller('paycheckPopupCtrl', function ($scope, $uibModalInstance, $filter, paycheck, maindata) {
	$scope.check = paycheck;
	$scope.mainData = maindata;

});
