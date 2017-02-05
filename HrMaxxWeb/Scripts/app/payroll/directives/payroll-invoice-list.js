'use strict';

common.directive('payrollInvoiceList', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/payroll-invoice-list.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'NgTableParams', 'EntityTypes', 'payrollRepository', '$anchorScroll','anchorSmoothScroll',
				function ($scope, $element, $location, $filter, ngTableParams, EntityTypes, payrollRepository, $anchorScroll, anchorSmoothScroll) {
					var dataSvc = {
						
						isBodyOpen: true,
						startDate: null,
						endDate: null,
					}
					$scope.list = [];
					$scope.statuses = [
					{ key: 1, value: 'Draft' }
					, { key: 2, value: 'Approved' }
					, { key: 3, value: 'Delivered' }
					, { key: 4, value: 'Closed' }
					, { key: 5, value: 'Taxes Delayed' }
					, { key: 6, value: 'Bounced' }
					, { key: 7, value: 'Partial Payment' }
					, { key: 8, value: 'Deposited' }
					, { key: 9, value: 'Not Deposited' }
					, { key: 10, value: 'ACH Pending' }
					];
					$scope.selectedStatuses = [];
					$scope.selectedStatus = [];
					$scope.statusEvents = {
						onItemSelect: function (item) {
							$scope.selectedStatuses.push($filter('filter')($scope.statuses, { key: item.id })[0]);
							
						},
						onItemDeselect: function (item) {
							$scope.selectedStatuses.splice($scope.selectedStatuses.indexOf($filter('filter')($scope.statuses, { key: item.id })[0]), 1);
							
						}
					};

					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = false;
					$scope.mainData.showCompanies = false;


					$scope.addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					
					$scope.selected = null;


					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,
						filter: {
							status1: 0,       // initial filter
						},
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
							var filterbystatus = params.$params.filter.status1;
							delete params.$params.filter.status1;
							var orderedData = params.filter() ?
																$filter('filter')($scope.list, params.filter()) :
																$scope.list;
							if (filterbystatus) {
								orderedData = $filter('filter')(orderedData, { status: filterbystatus });
							}
							orderedData = params.sorting() ?
														$filter('orderBy')(orderedData, params.orderBy()) :
														orderedData;
							params.$params.filter.status1 = filterbystatus;

							$scope.tableParams = params;
							$scope.tableData = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count());

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					$scope.updateSelectedInvoice = function (invoice) {
						getInvoices(invoice.id);
						//var match = $filter('filter')($scope.list, { id: invoice.id })[0];
						//if (match) {
						//	$scope.list.splice($scope.list.indexOf(match), 1);
						//}
						//$scope.list.push(invoice);
						//$scope.tableParams.reload();
						//$scope.fillTableData($scope.tableParams);
						
					}
					$scope.deleteInvoice = function(invoice) {
						var match = $filter('filter')($scope.list, { id: invoice.id })[0];
						if (match) {
							$scope.list.splice($scope.list.indexOf(match), 1);
						}
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						$scope.cancel();
					}
					$scope.cancel = function () {
						$scope.selectedInvoice = null;
						$scope.data.isBodyOpen = true;
					}
					

					$scope.set = function (item) {
						$scope.selectedInvoice = null;
						
						if(item){
							$timeout(function () {
								
								$scope.selectedInvoice = angular.copy(item);
								$scope.$parent.$parent.setHostandCompanyFromInvoice(item.company.hostId, item.company);
								$location.hash('invoice');

								// call $anchorScroll()
								anchorSmoothScroll.scrollTo('invoice');
							}, 1);
						}

					}
					
					$scope.save = function () {
						
					}
					$scope.companyUpdated = function(company) {
						var affectedInvoices = $filter('filter')($scope.list, { company: { id: company.id } });
						$.each(affectedInvoices, function(index, i) {
							i.company = angular.copy(company);
							i.companyName = company.name;
						});
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
					}
					$scope.updateData = function() {
						
						getInvoices();
					}
					var getInvoices = function (selectedInvoiceId) {
						$scope.selectedStatus = [];
						$.each($scope.selectedStatuses, function (i, st) {
							$scope.selectedStatus.push(st.id);
						});
						payrollRepository.getInvoicesForHost(null, dataSvc.startDate ? moment(dataSvc.startDate).format("MM/DD/YYYY") : null, dataSvc.endDate ? moment(dataSvc.endDate).format("MM/DD/YYYY") : null, $scope.selectedStatus).then(function (data) {
							$scope.list = data;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							$scope.selectedInvoice = null;
							if (selectedInvoiceId) {
								var match = $filter('filter')($scope.list, { id: selectedInvoiceId })[0];
								if (match)
									$scope.set(match);
							} else {
								$scope.set(null);
							}
							
						}, function (error) {
							$scope.addAlert('error getting invoices', 'danger');
							
						});
					}
					$scope.refreshData = function(event) {
						event.stopPropagation();
						getInvoices();
					}
					var init = function () {
						var invoice = null;
						var querystring = $location.search();
						if (querystring.invoice)
							invoice = querystring.invoice;
						else if (querystring.company)
							$scope.tableParams.$params.filter.companyName = querystring.company;

						if (!dataSvc.startDate)
							dataSvc.startDate = moment().add(-1, 'week').toDate();
						$scope.selectedStatuses.push({ id: 1 });
						$scope.selectedStatuses.push({ id: 3 });
						$scope.selectedStatuses.push({ id: 5 });
						$scope.selectedStatuses.push({ id: 6 });
						$scope.selectedStatuses.push({ id: 7 });
						$scope.selectedStatuses.push({ id: 8 });
						$scope.selectedStatuses.push({ id: 9 });
						getInvoices(invoice);
					}
					init();


				}]
		}
	}
]);
