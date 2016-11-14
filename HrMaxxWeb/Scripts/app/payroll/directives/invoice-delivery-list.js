'use strict';

common.directive('invoiceDeliveryList', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/invoice-delivery-list.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'ngTableParams', 'payrollRepository',
				function ($scope, $element, $location, $filter, ngTableParams, payrollRepository) {
					var dataSvc = {
						
						isBodyOpen: true,
						
					}
					$scope.list = [];
					$scope.today = new Date();

					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = false;
					$scope.mainData.showCompanies = false;


					$scope.addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					
					
					$scope.showPrint = function() {
						var selected = $filter('filter')($scope.tableData, { selected: true });
						return selected.length > 0;
					}

					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,
						filter: {
							invoiceNumber: 0,       // initial filter
						},
						sorting: {
							invoiceNumber: 'desc'     // initial sorting
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
					
					var getInvoices = function () {
						payrollRepository.getApprovedInvoicesForHost().then(function (data) {
							$scope.list = data;
							
							$scope.fillTableData($scope.tableParams);
						
						}, function (error) {
							$scope.addAlert('error getting invoices', 'danger');
							
						});
					}
					
					
					$scope.print = function () {
						var invoices = "";
						$.each($scope.tableData, function(i, inv) {
							if (inv.selected) {
								if (invoices) {
									invoices += "," + inv.id;
								} else {
									invoices = inv.id;
								}
							}
						});
						payrollRepository.claimInvoiceDelivery(invoices).then(function (data) {
							$.each($scope.tableData, function (i, inv) {
								if (inv.selected) {
									inv.deliveryClaimedBy = $scope.mainData.myName;
									inv.deliveryClaimedOn = new Date();
								}
							});
							

						}, function (error) {
							$scope.addAlert('error printing invoice delivery list', 'danger');

						});
						$window.print();
					}
					var init = function () {
						
						getInvoices();
					}
					init();


				}]
		}
	}
]);
