'use strict';

common.directive('employeeList', ['$uibModal','zionAPI', '$timeout', '$window', 'version',
	function ($modal, zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData",
				isVendor: "=isVendor"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/employee-list.html?v='+version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'NgTableParams', 'EntityTypes', 'reportRepository', 'ClaimTypes',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, reportRepository, ClaimTypes) {
					var dataSvc = {
						sourceTypeId: EntityTypes.Employee,
						isBodyOpen: true,
						employeesLoadedFor: null,
						includeAll: $scope.mainData.terminatedSearch
						
					}
                    $scope.mainData.terminatedSearch = false;
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;
					$scope.showBulkTerminate = $scope.mainData.hasClaim(ClaimTypes.EmployeeBulkTerminate, 1);
					$scope.showSickLeaveExport = $scope.mainData.hasClaim(ClaimTypes.EmployeeSickLeaveExport,1);
					$scope.showImportExport = $scope.mainData.hasClaim(ClaimTypes.EmployeeImportExport, 1);
					$scope.showCopyEmployees = $scope.mainData.hasClaim(ClaimTypes.EmployeeCopy, 1);
					$scope.showPayChecks = $scope.mainData.hasClaim(ClaimTypes.EmployeePayChecks, 1);

					
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
												companyId: $scope.mainData.selectedCompany.id
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
					var uploadDocument = function () {
						companyRepository.importEmployees($scope.files[0]).then(function (employees) {
							$scope.selected = null;
							$scope.mainData.showMessage('successfully imported ' + employees.length + 'employees', 'success');
							dataSvc.employeesLoadedFor = null;
							$scope.getEmployees($scope.mainData.selectedCompany.id);
						}, function (error) {
							$scope.mainData.handleError('error in importing employees: ' , error, 'danger');

							});

						
					}
					
					$scope.selected = null;
					
					$scope.getEmployeeImportTemplate = function() {
						companyRepository.getEmployeeImportTemplate($scope.mainData.selectedCompany.id).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
							
						}, function (error) {
							$scope.mainData.showMessage('error getting employee import template', 'danger');
						});
					}

					$scope.add = function () {
						var selected = {
							companyId: $scope.mainData.selectedCompany.id,
							statusId: 1,
							contact: {
								isPrimary: true,
								address: {
									countryId: 1,
									stateId:1
								}
							},
							gender: 0,
							rate:0,
							payCodes:[],
							compensations: [],
							payTypeAccruals:[],
							federalAdditionalAmount: 0,
							federalExemptions: 0,
							federalStatus:1,
							state: {
								state: $scope.mainData.selectedCompany.states[0].state,
								exemptions: 0,
								additionalAmount: 0,
								taxStatus:1
							},
							workerCompensation: $scope.mainData.selectedCompany.workerCompensations.length>0? $filter('orderBy')($scope.mainData.selectedCompany.workerCompensations,'rate',true)[0] : null,
							taxCategory: 1,
							payrollSchedule: $scope.mainData.selectedCompany.payrollSchedule,
							paymentMethod: 1,
							bankAccounts:[],
							companyEmployeeNo: null,
							carryOver: 0,
							sickLeaveCashPaidHours: 0,
							workClassification: null
						};
						
						$scope.set(selected);
					}
				
					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						filter: {
							name: '',       // initial filter
						},
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
					$scope.showFilter = true;
					$scope.cols = [
						{ field: "companyEmployeeNo", title: "Company Emp#", show: true, filter: { companyEmployeeNo: "text" }, sortable:"companyEmployeeNo" },
						{ field: "employeeNo", title: "No", show: true, filter: { employeeNo: "text" }, sortable: "employeeNo" },
						{ field: "name", title: "Name", show: true, filter: { name: "text" }, sortable: "name" },
						{ field: "ssnText", title: "SSN", show: true, filter: { ssnText: "text" }, sortable: "ssnText" },
						{ field: "department", title: "Department", show: true, filter: { department: "text" }, sortable: "department" },
						{ field: "hireDate", title: "Hire Date", show: true, isdate: true, sortable: "hireDate" },
						{ field: "lastPayrollDate", title: "Last Payroll", show: false, isdate: true, sortable: "lastPayrollDate" },
						{ field: "statusText", title: "Status", show: true, filter: { statusText: "text" }, sortable: "statusText" },
						{ field: "rate", title: "Rate", show: false, filter: { rate: "number" }, sortable: "rate", ismoney: true },
						{ field: "address", title: "Address", show: false },
						{ field: "wcCode", title: "WC", show: true, filter: { wcCode: 'text' }, sortable: "wcCode" },
						{ field: "payTypeText", title: "Pay Type", show: false, filter: { payTypeText: 'text' }, sortable: "payTypeText" },
						{ field: "federalStatusText", title: "Federal Status", show: false, filter: { federalStatusText: 'text' }, sortable: "federalStatusText" },
						{ field: "federalExemptions", title: "Federal Exemptions", show: false, filter: { federalExemptions: 'text' }, sortable: "federalExemptions" },

						{ field: "slDates", title: "SL Period", show: false, sortable: "slDates" },
						{ field: "slUsed", title: "SL Used", show: false, sortable: "slUsed" },
						{ field: "slAccumulated", title: "SL YTD", show: false, sortable: "slAccumulated" },
						{ field: "slCarryOver", title: "SL Carry over", show: false, sortable: "slCarryOver" },
						{ field: "slAvailable", title: "SL Available", show: false, sortable: "slAvailable" },
						{ field: "isTerminate", title: "Terminate?", show: false, sortable: "isTerminate" },
						{ field: "controls", title: "", show: true }
					];
					
					$scope.selectedHeaders = [
						{ id: 'companyEmployeeNo' },
						{ id: 'employeeNo' },
						{ id: 'name' },
						{ id: 'ssnText' },
						{ id: 'department' },
						{ id: 'hireDate' },
						{ id: 'wcCode' },
						{ id: 'statusText' }
					];
					$scope.empTerminate = function (employee, event) {
						event.stopPropagation();
					}
					$scope.bulkTerminateEmployees = function () {
						$scope.mainData.confirmDialog('Are you sure you want to terminate ' + $scope.bulkTerminateAvailable() + ' employees?', 'danger', function () {
							var employees = [];
							var list = $filter('filter')($scope.tableData, { isTerminated: true });
							$.each(list, function(i, e) {
								employees.push(e.id);
							});

							companyRepository.bulkTerminateEmployees($scope.mainData.selectedCompany.id, employees).then(function () {
								dataSvc.employeesLoadedFor = null;
								$scope.getEmployees($scope.mainData.selectedCompany.id);
							}, function (error) {
								$scope.mainData.showMessage('error in bulk terminating employees', 'danger');
							});
							
						});
					}

					$scope.bulkTerminateAvailable = function () {
						return $filter('filter')($scope.tableData, { isTerminated: true }).length;
					}
					$scope.refreshTable = function() {
						$.each($scope.cols, function(ind, c) {
							c.show = $filter('filter')($scope.selectedHeaders, { id: c.field }, true).length > 0 ? true : (c.field === 'controls' ? true : false);
						});
					}
					$scope.print = function() {
						$window.print();
					}
					

					$scope.tableParamsNew = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						filter: {
							name: '',       // initial filter
						},
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
					$scope.updateDeductionList = function (list) {
						
						if ($scope.selected) {
							
							var exists = $filter('filter')($scope.list, { id: $scope.selected.id });
							exists[0].deductions = list;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							
						}
						
					};
					$scope.set = function (item) {
						$scope.selected = null;
						$scope.selectedPayCodes = [];
						$timeout(function () {
							$scope.selected = angular.copy(item);
							if ($scope.selected.birthDate)
								$scope.selected.birthDate = moment($scope.selected.birthDate).toDate();
							if ($scope.selected.hireDate)
								$scope.selected.hireDate = moment($scope.selected.hireDate).toDate();

							$.each($scope.selected.payCodes, function (index, pc) {
								if(pc.id>0)
								$scope.selectedPayCodes.push({id:pc.id});
							});
							//$scope.selectedstate = $scope.selected.state.state;
							dataSvc.isBodyOpen = false;
							
						}, 1);

					}
					$scope.save = function(result) {
						var exists = $filter('filter')($scope.list, { id: result.id });
						if (exists.length === 0) {
							$scope.list.push(result);
						} else {
							$scope.list.splice($scope.list.indexOf(exists[0]), 1);
							$scope.list.push(result);
						}
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						$scope.set(result);
						$scope.mainData.showMessage('successfully saved employee', 'success');
					}
					
					$scope.viewPayCheckList = function (employee, event) {
						event.stopPropagation();
						var modalInstance = $modal.open({
							templateUrl: 'popover/payCheckListView.html',
							controller: 'payCheckListViewCtrl',
							size: 'lg',
							windowClass: 'my-modal-popup',
							backdrop: true,
							keyboard: true,
							backdropClick: true,
							resolve: {
								employee: function () {
									return employee;
								},
								mainData: function () {
									return $scope.mainData;
								}
							}
						});
					}
					$scope.getCompanyLeaveExport = function(mode, payTypeId, payTypeName) {
						var request = {
							reportName: 'CompanyLeaveExport',
							hostId: $scope.mainData.selectedHost.id,
                            companyId: $scope.mainData.selectedCompany.id,
                            state: payTypeId,
                            description: payTypeName
							
						}
						if (mode === 1) {
							request.employeeId = $scope.selected.id;
						}
						reportRepository.getReportDocument(request).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();

						}, function (error) {
							$scope.mainData.handleError('Error getting Company Leave Export for ' + payTypeName + '. ' , error, 'danger');
						});
					}
					$scope.getEmployees = function (companyId) {
						if (!dataSvc.employeesLoadedFor || dataSvc.employeesLoadedFor !== companyId || dataSvc.employeesLoadedForStatus !== dataSvc.includeAll) {
							dataSvc.employeesLoadedFor = companyId;
							dataSvc.employeesLoadedForStatus = dataSvc.includeAll;
							companyRepository.getEmployees(companyId, dataSvc.includeAll ? 0 : 1).then(function (data) {
								
								$scope.list = data;
								$scope.tableParams.reload();
								$scope.tableParamsNew.reload();
								$scope.fillTableData($scope.tableParams);

								if ($scope.mainData.fromSearch && $scope.mainData.showemployee) {
									var exists = $filter('filter')($scope.list, { id: $scope.mainData.showemployee })[0];
									if (exists) {
										$scope.set(exists);
									}
									$scope.mainData.fromSearch = false;
									$scope.mainData.showemployee = null;
								}
								else if ($scope.mainData.userEmployee) {
									var exists1 = $filter('filter')($scope.list, { id: $scope.mainData.userEmployee })[0];
									if (exists1) {
										$scope.mainData.selectedEmployee = exists1;
										$scope.set(exists1);
									}
								}
							}, function (erorr) {
								$scope.mainData.showMessage('error getting employee list', 'danger');
							});
						}
						
					}

					$scope.$watch('mainData.selectedCompany',
						 function (newValue, oldValue) {
						 	if (newValue !== oldValue && $scope.mainData.selectedCompany) {
						 		$scope.getEmployees($scope.mainData.selectedCompany.id);
						 		dataSvc.isBodyOpen = true;
								
							 }

						 }, true
				 );
					
					var init = function () {
						if ($scope.mainData.selectedCompany) {
							
							$scope.getEmployees($scope.mainData.selectedCompany.id);
							
						}
						

					}
					init();
					$scope.copyemployees = function (event) {
						event.stopPropagation();
						var modalInstance = $modal.open({
							templateUrl: 'popover/copyemployees.html',
							controller: 'copyEmployeesCtrl',
							size: 'sm',
							windowClass: 'my-modal-popup',
							backdrop: true,
							keyboard: true,
							backdropClick: true,
							resolve: {
								company: function () {
									return $scope.mainData.selectedCompany;
								},
								mainData: function () {
									return $scope.mainData;
								},
								companyRepository: function () {
									return companyRepository;
								},
								main: function() {
									return $scope.$parent.$parent;
								},
								employees: function() {
									return $filter('orderBy')($filter('filter')($scope.list, {statusId:1}), 'name');
								}
							}
						});
						modalInstance.result.then(function (scope) {
							if (scope) {
								$scope.mainData.showMessage('successfully copied employees to the new company: ' + scope.selectedCompany.name, 'success');
							}
						}, function () {
							return false;
						});
					}

				}]
		}
	}
]);
common.controller('payCheckListViewCtrl', function ($scope, $uibModalInstance, employee, mainData) {
	$scope.employee = employee;
	$scope.mainData = mainData;


	$scope.cancel = function () {
		$uibModalInstance.close($scope);
	};
	

});

common.controller('copyEmployeesCtrl', function ($scope, $uibModalInstance, $filter, company, mainData, companyRepository, main, employees) {
	$scope.original = company;
	$scope.selectedCompany = null;
	$scope.keepEmployeeNumbers = true;
	$scope.mainData = mainData;
	$scope.selectedEmployees = [];
	$scope.employeeList = angular.copy(employees);
	$scope.error = null;
	$scope.cancel = function () {
		$uibModalInstance.dismiss();
	};
	$scope.save = function () {
		$scope.error = null;
		main.confirmDialog('Are you sure you want to Copy employees? this action is not reversible', 'danger', function () {
			var selected = [];
			$.each($scope.selectedEmployees, function (i, st) {
				if (st.id)
					selected.push(st.id);
			});
			companyRepository.copyEmployees($scope.original.id, $scope.selectedCompany.id, selected, $scope.keepEmployeeNumbers).then(function(result) {
				$uibModalInstance.close($scope);


			}, function(error) {
				$scope.error = error.statusText;
			});
		});
	};
	

});
