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

			controller: ['$scope', '$element', '$location', '$filter', 'NgTableParams', 'payrollRepository',
				function ($scope, $element, $location, $filter, ngTableParams, payrollRepository) {
					var dataSvc = {
						isBodyOpen: true,
						isBodyOpenHistory: true,
						startDate: moment().add(-1, 'week').toDate(),
						endDate: null

				}
					$scope.list = [];
					$scope.history = [];
					$scope.today = new Date();

					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = false;
					$scope.mainData.showCompanies = false;

					
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
						getData: function (params) {
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
							$scope.mainData.showMessage('error getting invoices', 'danger');
							
						});
					}
					$scope.getInvoiceDeliveryClaims = function() {
						payrollRepository.getInvoiceDeliveryClaims(dataSvc.startDate, dataSvc.endDate).then(function (data) {
							$scope.history = data;
							
						}, function (error) {
							$scope.mainData.showMessage('error getting history of invoice deliveries', 'danger');

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
							$scope.mainData.showMessage('error printing invoice delivery list', 'danger');

						});
						$window.print();
					}
					$scope.refreshData = function(event) {
						event.stopPropagation();
						init();
					}
					var init = function () {
						
						getInvoices();
						$scope.getInvoiceDeliveryClaims();
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
								},
								payrollRepository: function() {
									return payrollRepository;
								}
							}
						});
					}


				}]
		}
	}
]);
common.controller('invoiceDeliveryListCtrl', function ($scope, $uibModalInstance, $filter, item, payrollRepository) {
	$scope.item = item;
	$scope.originalCount = item.invoiceSummaries.length;
	$scope.alerts = [];
	$scope.add = function() {
		$scope.item.invoiceSummaries.push({
			clientName:'', clientCity:'', total:0, notes:'', isPayrollDelivery:false, isEditable:true
		});
		
	}
	$scope.hasChanges=function() {
		return $scope.item.invoiceSummaries.length !== $scope.originalCount;
	}
	$scope.isValid = function() {
		var returnVal = true;
		$.each($scope.item.invoiceSummaries, function(ind, i) {
			if (!i.isPayrollDelivery && (!i.clientCity || !i.clientName || !i.notes)) {
				returnVal = false;
				return;
			}
		});
		return returnVal;
	}
	var addAlert = function(m, t) {
		$scope.alerts = [];
		$scope.alerts.push({ msg: m, type: t });
	}
	$scope.update = function() {
		payrollRepository.updateInvoiceDelivery($scope.item).then(function () {
			addAlert('successfully updated delivery list', 'success');
			$.each($scope.item.invoiceSummaries, function (ind, i) {
				i.isEditable = false;
			});
			$scope.originalCount = $scope.item.invoiceSummaries.length;
		}, function (error) {
			addAlert('error printing invoice delivery list', 'danger');

		});
	}
});
