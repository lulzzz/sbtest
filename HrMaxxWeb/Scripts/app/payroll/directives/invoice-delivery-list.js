'use strict';

common.directive('invoiceDeliveryList', ['zionAPI', '$timeout', '$window', 'version', '$uibModal',
	function (zionAPI, $timeout, $window, version, $modal) {
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
						isBodyOpenHistory: true

				}
					$scope.list = [];
					$scope.history = [];
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
						count: $scope.list ? $scope.list.length : 0,
						
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
							$scope.tableData = orderedData;

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
					var getInvoiceDeliveryClaims = function() {
						payrollRepository.getInvoiceDeliveryClaims().then(function (data) {
							$scope.history = data;
							
						}, function (error) {
							$scope.addAlert('error getting history of invoice deliveries', 'danger');

						});
					}
					
					$scope.print = function () {
						var invoices = [];
						$.each($scope.tableData, function(i, inv) {
							if (inv.selected) {
								invoices.push(inv.id);
							}
						});
						payrollRepository.claimInvoiceDelivery(invoices).then(function (data) {
							$.each($scope.tableData, function (i, inv) {
								if (inv.selected) {
									inv.deliveryClaimedBy = $scope.mainData.myName;
									inv.deliveryClaimedOn = new Date();
								}
							});
							$scope.history.push(data);

						}, function (error) {
							$scope.addAlert('error printing invoice delivery list', 'danger');

						});
						$window.print();
					}
					var init = function () {
						
						getInvoices();
						getInvoiceDeliveryClaims();
					}
					init();
					$scope.viewHistoryItem = function (listitem) {
						var modalInstance = $modal.open({
							templateUrl: 'popover/delivery.html',
							controller: 'invoiceDeliveryListCtrl',
							size: 'lg',
							windowClass: 'my-modal-popup',
							backdrop: true,
							keyboard: true,
							backdropClick: true,
							resolve: {
								item: function () {
									return listitem;
								}
							}
						});
					}


				}]
		}
	}
]);
common.controller('invoiceDeliveryListCtrl', function ($scope, $uibModalInstance, $filter, item) {
	$scope.item = item;
	
	
	
});
