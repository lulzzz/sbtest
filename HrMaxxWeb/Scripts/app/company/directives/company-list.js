'use strict';

common.directive('companyList', ['zionAPI', '$timeout', '$window', 'version', '$uibModal',
	function (zionAPI, $timeout, $window, version, $modal) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				heading: "=heading",
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/company-list.html?v=' + version,

			controller: ['$scope', '$rootScope', '$element', '$location', '$filter', 'companyRepository', 'NgTableParams', 'EntityTypes', 'payrollRepository',
				function ($scope, $rootScope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, payrollRepository) {
					var dataSvc = {
						isBodyOpen: true
						
					}
					$scope.cols = [
						{ field: "companyNumber", title: "No", show: true, filter: { companyIntId: "number" }, sortable: "companyIntId" },
						{ field: "name", title: "Name", show: true, filter: { name: "text" }, sortable: "name" },
						{ field: "companyNo", title: "Legacy No", show: true, filter: { companyNo: "text" }, sortable: "companyNo" },
						{ field: "lastPayrollDate", title: "Last Payroll", show: true, isdate: true, sortable: "lastPayrollDate" },
						{ field: "created", title: "Created", show: true, filter: { created: "text" }, sortable: "created", isdate:true },
						{ field: "fileUnderHost", title: "Leasing?", show: true, sortable: "fileUnderHost", ismoney: false },
						{ field: "contractType", title: "Contract Type", show: true },
						{ field: "getTextForStatus", title: "Status", show: true, filter: { getTextForStatus: 'text' }, sortable: "getTextForStatus" },
						{ field: "address", title: "Address", show: false, filter: { address: "text" } },
						{ field: "ein", title: "EIN", show: false },
						{ field: "insuranceInfo", title: "Insurance", show: false },
						{ field: "stateEIN", title: "State EIN", show: false },
						{ field: "salesRep", title: "Sales Rep", show: true, sortable: "salesRep", filter: { salesRep: "text" } },
						{ field: "commission", title: "Commission", show: true, sortable: "commission" },
						{ field: "contactName", title: "Contact", show: true, sortable: "contactName", filter: { contactName: "text" } },
						{ field: "phone", title: "Phone", show: true, sortable: "phone" },
						{ field: "controls", title: "", show: true }

					];

					$scope.selectedHeaders = [
						{ id: 'companyNumber' },
						{ id: 'name' },
						{ id: 'companyNo' },
						{ id: 'lastPayrollDate' },
						{ id: 'created' },
						{ id: 'fileUnderHost' },
						{ id: 'contractType' },
						{ id: 'getTextForStatus' },
						{ id: 'salesRep' },
						{ id: 'commission' },
						{ id: 'contactName' },
						{ id: 'phone' }
					];

					$scope.refreshTable = function () {
						$.each($scope.cols, function (ind, c) {
							
							c.show = $filter('filter')($scope.selectedHeaders, { id: c.field }, true).length > 0 ? true : (c.field==='controls'? true : false);
						});
					}
					$scope.print = function () {
						$window.print();
					}
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = false;

					
					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					$scope.addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};

					$scope.selectedCompany = null;


					$scope.addCompany = function () {
						var selectedCompany = {
							hostId: $scope.mainData.selectedHost.id,
							statusId: 1,
							companyIntId: 0,
							isAddressSame: true,
							isVisibleToHost: true,
							fileUnderHost: $scope.mainData.selectedHost.isPeoHost,
							allowTaxPayments: true,
							allowEFileFormFiling: true,
							isHostCompany: false,
							payrollDaysInPast: 0,
							payCheckStock: 3,
							companyAddress: {},
							states: [],
							companyTaxRates: [],
							contract: {
								contractOption: 2,
								prePaidSubscriptionOption: null,
								billingOption: 3,
								creditCardDetails: null,
								bankDetails: null,
								invoiceCharge: 0,
								invoiceSetup: {
									suiManagement: $scope.mainData.selectedHost.isPeoHost ? 1 : 0,
									applyEnvironmentalFee: $scope.mainData.selectedHost.isPeoHost,
									applyStatuaryLimits: $scope.mainData.selectedHost.isPeoHost,
									applyWCCharge: true,
									printClientName: false,
									recurringCharges:[]
								}
							}
						};
						if ($scope.mainData.selectedHost.isPeoHost) {
							var hostCompany = $filter('filter')($scope.mainData.hostCompanies, { isHostCompany: true })[0];
							selectedCompany.depositSchedule = hostCompany.depositSchedule;
						}
						selectedCompany.businessAddress = selectedCompany.companyAddress;
						
						$scope.selectedCompany = angular.copy(selectedCompany);
						$scope.data.isBodyOpen = false;

						$scope.tab = 1;
					}

					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						filter: {
							name: '',       // initial filter
						},
						sorting: {
							name: 'asc'     // initial sorting
						}
					}, {
						total: $scope.list ? $scope.list.length : 0, // length of data
						getData: function (params) {
							$scope.fillTableData(params);
							return $scope.tableData;
						}
					});
					//if ($scope.tableParams.settings().$scope == null) {
					//	$scope.tableParams.settings().$scope = $scope;
					//}
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
						$scope.selectedCompany = null;
						$scope.data.isBodyOpen = true;
					}
					
					$scope.setCompany = function (item, tab) {
						if (!$scope.selectedCompany || $scope.selectedCompany.id !== item.id) {
							$scope.selectedCompany = null;
							companyRepository.getCompany(item.id).then(function(comp) {
								$scope.selectedCompany = angular.copy(comp);
								$scope.data.isBodyOpen = false;

								$scope.mainData.selectedCompany = comp;
								$scope.mainData.selectedCompany1 = item;

								$scope.tab = tab;
							}, function(error) {
								addAlert('error getting company details', 'danger');
							});
						} else if($scope.selectedCompany){
							$scope.data.isBodyOpen = false;
						}
					}

					$scope.save = function (result) {
						
						var exists = $filter('filter')($scope.list, { id: result.id });
						if (exists.length === 0) {
							$scope.list.push(result);
							$scope.setCompany(result);
						} else {
							$scope.list.splice($scope.list.indexOf(exists[0]), 1);
							$scope.list.push(result);
						}
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						addAlert('successfully saved Company', 'success');
					}


					$scope.$watch('mainData.hostCompanies',
						 function (newValue, oldValue) {
						 	if (newValue !== oldValue) {
						 		$scope.list = $scope.mainData.hostCompanies;
						 		$scope.tableParams.reload();
						 		//$scope.tableParams.page = 1;
								$scope.fillTableData($scope.tableParams);
						 	}

						 }, true
				 );
				 // $scope.$watch('mainData.selectedCompany',
				 // 	 function (newValue, oldValue) {
				 // 	 	if (newValue !== oldValue && $scope.mainData.selectedCompany) {
				 // 	 		$scope.selectedCompany = null;
				 // 	 		$timeout(function () {
				 // 	 			$scope.selectedCompany = angular.copy($scope.mainData.selectedCompany);

				 // 	 			$scope.data.isBodyOpen = false;
				 // 	 			$scope.tab = 1;

				 // 	 		}, 1);

				 // 	 	}

				 // 	 }, true
				 //);
					$scope.$on('hostChanged', function() {
						$scope.selectedCompany = null;
						dataSvc.isBodyOpen = true;
						
					});
					$scope.copycompany = function (event, item) {
						event.stopPropagation();
						var modalInstance = $modal.open({
							templateUrl: 'popover/copycompany.html',
							controller: 'copyCompanyCtrl',
							size: 'lg',
							windowClass: 'my-modal-popup',
							backdrop: false,
							keyboard: true,
							backdropClick: true,
							resolve: {
								company: function () {
									return item;
								},
								mainData: function () {
									return $scope.mainData;
								},
								companyRepository : function() {
									return companyRepository;
								},
								payrollRepository : function() {
									return payrollRepository;
								}
							}
						});
						modalInstance.result.then(function (scope) {
							if (scope) {
								$scope.$parent.$parent.refreshHostAndCompanies();
								addAlert('successfully copied company to the new host: ' + scope.selectedHost.firmName, 'success');
							}
						}, function () {
							return false;
						});
					}
					$scope.refreshData = function (event) {
						event.stopPropagation();
						$scope.$parent.$parent.refreshHostAndCompanies();
					}
					var init = function () {

						$scope.list = $scope.mainData.hostCompanies;
						var querystring = $location.search();
						if ($scope.mainData.fromSearch) {
							$scope.mainData.fromSearch = false;
							if ($scope.mainData.selectedCompany && $scope.mainData.selectedCompany.contract) {
								$scope.selectedCompany = angular.copy($scope.mainData.selectedCompany);
								$scope.data.isBodyOpen = false;
							} else {
								var exists2 = $filter('filter')($scope.list, { id: $scope.mainData.selectedCompany.id }, true)[0];
								$scope.setCompany(exists2, 1);
							}
						}
						else if($scope.mainData.selectedCompany && $scope.mainData.selectedCompany.contract) {
							$scope.selectedCompany = angular.copy($scope.mainData.selectedCompany);
							$scope.data.isBodyOpen = false;
						}
						else if ($scope.mainData.userCompany !== '00000000-0000-0000-0000-000000000000') {
							var exists1 = $filter('filter')($scope.list, { id: $scope.mainData.userCompany }, true)[0];
							if (exists1) {
								$scope.setCompany(exists1, 1);
							}
						}
						else if (querystring.name) {
							var exists = $filter('filter')($scope.list, { name: querystring.name }, true)[0];
							if (exists) {
								$scope.setCompany(exists, 1);
							}
						}
						
					}
					init();


				}]
		}
	}
]);
common.controller('copyCompanyCtrl', function ($scope, $uibModalInstance, $filter, company, mainData, companyRepository, payrollRepository) {
	$scope.original = company;
	$scope.company = angular.copy(company);
	$scope.mainData = mainData;
	$scope.copyemployees = true;
	$scope.copypayrolls = false;
	$scope.keepEmployeeNumbers = true;
	$scope.startDate = null;
	$scope.endDate = null;
	$scope.selectedHost = null;
	$scope.error = null;

	$scope.selectedCompanySource = null;
	$scope.selectedCompanyTarget = null;
	$scope.selectedPayrollList = [];
	$scope.payrollsLoaded = false;
	$scope.mcPayrollsOption = 1;
	$scope.asPayrollsOption = 1;
	$scope.option = 0;
	$scope.ashistory = false;
	$scope.alerts = [];
	var addAlert = function(type, message) {
		$scope.alerts = [];
		$scope.alerts.push({ type: type, msg: message });
	}

	$scope.loadPayrolls = function() {
		if (!$scope.payrollsLoaded) {
			payrollRepository.getCompanyPayrollListForRelocation($scope.company.id).then(function (result) {
				$scope.payrollsLoaded = true;
				$scope.payrolls = result;

			}, function (error) {
				addAlert('danger', 'unable to load payroll list for selection');
			});
		}
	}

	$scope.cancel = function () {
		$uibModalInstance.dismiss();
	};
	$scope.save = function () {
		$scope.error = null;
		$scope.alerts = [];
		companyRepository.copyCompany({
			companyId: $scope.company.id,
			hostId: $scope.selectedHost.id,
			copyEmployees: $scope.copyemployees,
			copyPayrolls: $scope.copypayrolls,
			keepEmployeeNumbers: (!$scope.copyemployees? false : $scope.keepEmployeeNumbers),
			startDate: $scope.startDate,
			endDate: $scope.endDate
		}).then(function (result) {
			//$uibModalInstance.close($scope);
			addAlert('success', 'successfully copied company');

		}, function (error) {
			addAlert('danger', error.statusText);
		});
		
	};
	$scope.moveCopyPayrolls = function () {
		$scope.alerts = [];
		var payrollList = [];
		if ($scope.asPayrollsOption === 2) {
			$.each($scope.selectedPayrollList, function(i, p) {
				payrollList.push(p.id);
			});
		}
		payrollRepository.moveCopyPayrolls({
			source: $scope.company.id,
			target: $scope.selectedCompanyTarget.id,
			option: $scope.mcPayrollsOption,
			payrollOption: $scope.asPayrollsOption === 1,
			asHistory: $scope.ashistory,
			payrolls: payrollList
		}).then(function (result) {
			//$uibModalInstance.close($scope);
			addAlert('success', 'successfully ' + ($scope.mcPayrollsOption===1 ? 'moved' : 'copied') + ' payrolls');

		}, function (error) {
			addAlert('danger', error.statusText);
		});
	}
	$scope.isValid = function() {
		if (!$scope.selectedHost)
			return false;
		else
			return true;
	}
	
});
common.controller('companyCtrl', function ($scope, $uibModalInstance, $filter, invoice, mainData) {
	$scope.original = invoice.company;
	$scope.company = angular.copy(invoice.company);
	$scope.mainData = mainData;
	$scope.cancel = function () {
		$uibModalInstance.close($scope.company);
	};

	$scope.save = function (result) {
		$uibModalInstance.close(result);
	};


});

