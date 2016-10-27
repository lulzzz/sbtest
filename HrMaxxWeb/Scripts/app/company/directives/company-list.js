﻿'use strict';

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

			controller: ['$scope', '$rootScope', '$element', '$location', '$filter', 'companyRepository', 'ngTableParams', 'EntityTypes',
				function ($scope, $rootScope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes) {
					var dataSvc = {
						isBodyOpen: true
						
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
							isAddressSame: true,
							isVisibleToHost: true,
							fileUnderHost: true,
							allowTaxPayments: true,
							allowEFileFormFiling: true,
							isHostCompany: false,
							payrollDaysInPast: 0,
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
								invoiceSetup: null
							}
						};
						selectedCompany.businessAddress = selectedCompany.companyAddress;
						
						$scope.setCompany(selectedCompany, 1);
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
						$scope.selectedCompany = null;
						$timeout(function () {
							$scope.selectedCompany = angular.copy(item);
							
							$scope.data.isBodyOpen = false;
							if (item.id) {
								$scope.mainData.selectedCompany = item;
								$scope.mainData.selectedCompany1 = item;
							}
							
						

							$scope.tab = tab;

						}, 1);


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


					$scope.$watch('mainData.companies.length',
						 function (newValue, oldValue) {
						 	if (newValue !== oldValue) {
						 		$scope.list = $scope.mainData.companies;
						 		$scope.tableParams.reload();
						 		$scope.fillTableData($scope.tableParams);
						 	}

						 }, true
				 );
					$scope.copycompany = function (event, item) {
						event.stopPropagation();
						var modalInstance = $modal.open({
							templateUrl: 'popover/copycompany.html',
							controller: 'copyCompanyCtrl',
							size: 'lg',
							windowClass: 'my-modal-popup',
							backdrop: true,
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

						$scope.list = $scope.mainData.companies;
						var querystring = $location.search();
						if ($scope.mainData.userCompany !== '00000000-0000-0000-0000-000000000000') {
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
common.controller('copyCompanyCtrl', function ($scope, $uibModalInstance, $filter, company, mainData, companyRepository) {
	$scope.original = company;
	$scope.company = angular.copy(company);
	$scope.mainData = mainData;
	$scope.copyemployees = true;
	$scope.copypayrolls = false;
	$scope.startDate = null;
	$scope.endDate = null;
	$scope.selectedHost = null;

	$scope.cancel = function () {
		$uibModalInstance.close($scope);
	};
	$scope.save = function () {
		
		$uibModalInstance.close($scope);
	};
	$scope.isValid = function() {
		if (!$scope.selectedHost)
			return false;
		else
			return true;
	}
	
});

