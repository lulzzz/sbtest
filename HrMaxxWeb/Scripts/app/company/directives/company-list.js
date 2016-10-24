'use strict';

common.directive('companyList', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
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
						$.each(dataSvc.companyMetaData.taxes, function (index, taxyearrate) {
							selectedCompany.companyTaxRates.push({
								id: 0,
								taxId: taxyearrate.tax.id,
								companyId: null,
								taxCode: taxyearrate.tax.code,
								taxYear: taxyearrate.taxYear,
								rate: taxyearrate.rate
							});
						});
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
							$scope.mainData.selectedCompany = item;
							$scope.mainData.selectedCompany1 = item;
						

							$scope.tab = tab;

						}, 1);


					}

					$scope.save = function (result) {
						
						var exists = $filter('filter')($scope.list, { id: result.id });
						if (exists.length === 0) {
							$scope.list.push(result);
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
