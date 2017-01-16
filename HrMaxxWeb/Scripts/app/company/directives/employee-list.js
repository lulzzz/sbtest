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

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'ngTableParams', 'EntityTypes',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes) {
					var dataSvc = {
						sourceTypeId: EntityTypes.Employee,
						isBodyOpen: true
						
					}
					
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;


					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};

					$scope.addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
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
							$.each(employees, function(ind, emp) {
								$scope.list.push(emp);
							});
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							$scope.selected = null;
							addAlert('successfully imported ' + employees.length + 'employees', 'success');
						}, function (error) {
							addAlert('error in importing employees: ' + error, 'danger');

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
							addAlert('error getting employee import template', 'danger');
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
							companyEmployeeNo:null
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
						getData: function ($defer, params) {
							$scope.fillTableData(params);
							$defer.resolve($scope.tableData);
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
						addAlert('successfully saved employee', 'success');
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
					
					$scope.getEmployees = function(companyId) {
						companyRepository.getEmployees(companyId).then(function (data) {
							$scope.list = data;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							$scope.selected = null;
							if ($scope.mainData.fromSearch && $scope.mainData.showemployee) {
								var exists = $filter('filter')($scope.list, { id: $scope.mainData.showemployee })[0];
								if (exists) {
									$scope.set(exists);
								}
								$scope.mainData.fromSearch = false;
								$scope.mainData.showemployee = null;
							}
						}, function (erorr) {
							addAlert('error getting employee list', 'danger');
						});
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
