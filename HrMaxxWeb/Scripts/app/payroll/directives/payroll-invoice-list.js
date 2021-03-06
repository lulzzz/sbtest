﻿'use strict';

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
						selectedCompany: null,
						includeDelayedTaxes: false,
						includeRedated: false

					}
					var handleDateRangeFilter = function () {
						$('#daterange-filter span').html(moment(dataSvc.startDate).format('MMMM D, YYYY') + ' - ' + moment(dataSvc.endDate).format('MMMM D, YYYY'));

						$('#daterange-filter').daterangepicker({
							format: 'MM/DD/YYYY',
							startDate: dataSvc.startDate,
							endDate: dataSvc.endDate,
							maxDate: moment().endOf('year'),
							showDropdowns: true,
							showWeekNumbers: true,
							timePicker: false,
							timePickerIncrement: 1,
							timePicker12Hour: true,
							ranges: {
								'Today': [moment(), moment()],
								'Last 14 Days': [moment().subtract(13, 'days'), moment()],
								'Last 30 Days': [moment().subtract(29, 'days'), moment()],
								'This Month': [moment().startOf('month'), moment().endOf('month')],
								'This Quarter': [moment().quarter(moment().quarter()).startOf('quarter'), moment().quarter(moment().quarter()).endOf('quarter')],
								'This Year': [moment().startOf('year'), moment().endOf('year')],
								'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
								'Last Quarter': [moment().subtract(1, 'quarter').startOf('quarter'), moment().subtract(1, 'quarter').endOf('quarter')],
								'Last Year': [moment().subtract(1, 'year').startOf('year'), moment().subtract(1, 'year').endOf('year')]
							},
							opens: 'right',
							drops: 'down',
							buttonClasses: ['btn', 'btn-sm'],
							applyClass: 'btn-primary',
							cancelClass: 'btn-default',
							separator: ' to ',
							locale: {
								applyLabel: 'Submit',
								cancelLabel: 'Cancel',
								fromLabel: 'From',
								toLabel: 'To',
								customRangeLabel: 'Custom',
								daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
								monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
								firstDay: 1
							}
						}, function (start, end, label) {
								$('#daterange-filter span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
							dataSvc.startDate = start;
							dataSvc.endDate = end;
						});
					};
					$scope.printList = function (event) {
						$scope.selectedInvoice = null;
						event.stopPropagation();
						$timeout(function () {
						 	
						 	$window.print();
						}, 1);
						
					}
					$scope.list = [];
					$scope.statuses = [
					{title:'All'},
					{ id: 1, title: 'Draft' }
					, { id: 2, title: 'Approved' }
					, { id: 3, title: 'Delivered' }
					, { id: 4, title: 'Closed' }
					, { id: 6, title: 'Bounced' }
					, { id: 7, title: 'Partial Payment' }
					, { id: 8, title: 'Deposited' }
					, { id: 9, title: 'Not Deposited' }
					, { id: 10, title: 'ACH Pending' }
					];
					$scope.paymentstatuses = [
					{ title: 'All' },
					{ id: 1, title: 'Draft' }
					, { id: 2, title: 'Submitted' }
					, { id: 3, title: 'Paid' }
					, { id: 4, title: 'Bounced' }
					, { id: 5, title: 'Deposited' }
					];

					$scope.paymentmethods = [
					{ title: 'All' },
					{ id: 1, title: 'Check' }
					, { id: 2, title: 'Cash' }
					, { id: 3, title: 'Cert Fund' }
					, { id: 4, title: 'Corp Check' }
					, { id: 5, title: 'ACH' }
					
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

					$scope.selectedPaymentStatuses = [];
					$scope.selectedPaymentStatus = [];
					$scope.paymentstatusEvents = {
						onItemSelect: function (item) {
							$scope.selectedPaymentStatuses.push($filter('filter')($scope.paymentstatuses, { key: item.id })[0]);

						},
						onItemDeselect: function (item) {
							$scope.selectedPaymentStatuses.splice($scope.selectedPaymentStatuses.indexOf($filter('filter')($scope.paymentstatuses, { key: item.id })[0]), 1);

						}
					};
					$scope.selectedPaymentMethods = [];
					$scope.selectedPaymentMethod = [];
					$scope.paymentmethodEvents = {
						onItemSelect: function (item) {
							$scope.selectedPaymentMethods.push($filter('filter')($scope.paymentmethods, { key: item.id })[0]);

						},
						onItemDeselect: function (item) {
							$scope.selectedPaymentMethods.splice($scope.selectedPaymentMethods.indexOf($filter('filter')($scope.paymentmethods, { key: item.id })[0]), 1);

						}
					};

					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = false;
					$scope.mainData.showCompanies = false;

					$scope.selected = null;


					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,
						
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
							$scope.tableData = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count());

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					$scope.updateSelectedInvoice = function (invoice) {
						//getInvoices(invoice.id);
						//var updatedItem = {
						//	id: invoice.id, companyId: invoice.company.id, companyName: invoice.company.name, isHostCompany: invoice.company.isHostCompany,
						//	isVisibleToHost: invoice.company.isVisibleToHost, hostId: invoice.company.hostId, invoiceNumber: invoice.invoiceNumber, invoiceDate: invoice.invoiceDate,
						//	total: invoice.total, balance: invoice.balance, status: invoice.status, processedOn: invoice.processedOn, processedBy: invoice.processedBy,
						//	deliveredOn: invoice.deliveredOn, courier: invoice.courier, checkNumbers: invoice.checkNumbers, employeeTaxes: invoice.employeeTaxes, employerTaxes: invoice.employerTaxes,
						//	lastPayment: invoice.lastPayment, taxPenaltyConfig: invoice.taxPenaltyConfig, statusText: invoice.statusText, daysOverdue: invoice.daysOverdue, lateTaxPenalty: invoice.lateTaxPenalty
						//};
						var match = $filter('filter')($scope.list, { id: invoice.id })[0];
						if (match) {
							$scope.list.splice($scope.list.indexOf(match), 1);
						}
						$scope.list.push(invoice);
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						
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
						if (item && item.id) {
							payrollRepository.getInvoiceById(item.id).then(function (invoice) {
								$scope.selectedInvoice = invoice;
								$scope.$parent.$parent.setHostandCompanyFromInvoice(invoice.company.hostId, invoice.company.id);
								
								anchorSmoothScroll.scrollToElement(document.getElementById('invoice'));
							}, function (error) {
								$scope.mainData.showMessage('error getting invoices', 'danger');

							});
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
							if(st.id)
								$scope.selectedStatus.push(st.id);
						});
						$scope.selectedPaymentStatus = [];
						$.each($scope.selectedPaymentStatuses, function (i, st) {
							if (st.id)
								$scope.selectedPaymentStatus.push(st.id);
						});
						$scope.selectedPaymentMethod = [];
						$.each($scope.selectedPaymentMethod, function (i, st) {
							if (st.id)
								$scope.selectedPaymentMethod.push(st.id);
						});
						var comp = dataSvc.selectedCompany ? dataSvc.selectedCompany.id : null;
						payrollRepository.getInvoicesForHost(comp, dataSvc.startDate ? moment(dataSvc.startDate).format("MM/DD/YYYY") : null,
																									dataSvc.endDate ? moment(dataSvc.endDate).format("MM/DD/YYYY") : null, $scope.selectedStatus, $scope.selectedPaymentStatus,
																									$scope.selectedPaymentMethod, dataSvc.includeDelayedTaxes, dataSvc.includeRedated
																									).then(function (data) {
							$scope.list = data;
							//$scope.processors = $filter('unique')($scope.list, 'processedBy');
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
							$scope.mainData.showMessage('error getting invoices', 'danger');
							
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
						else if ($scope.mainData.invoiceCompany) {
							//$scope.tableParams.filter.companyName = querystring.company;
							dataSvc.selectedCompany = $filter('filter')($scope.mainData.companies, { name: $scope.mainData.invoiceCompany }, true)[0];
							$scope.selectedStatuses = [];
							$scope.selectedPaymentStatuses = [];
							$scope.selectedPaymentMethods = [];
							dataSvc.startDate = null;
							dataSvc.endDate = null;
							$scope.mainData.invoiceCompany = null;
						} else {
							if (!dataSvc.startDate)
								dataSvc.startDate = moment().add(-1, 'week').toDate();
							if (!dataSvc.endDate)
								dataSvc.endDate = moment().endOf('year').toDate();
							$scope.selectedStatuses.push({ id: 1 });
							$scope.selectedStatuses.push({ id: 3 });
							$scope.selectedStatuses.push({ id: 6 });
							$scope.selectedStatuses.push({ id: 7 });
							$scope.selectedStatuses.push({ id: 8 });
							$scope.selectedStatuses.push({ id: 9 });
						}
							

						handleDateRangeFilter();
						getInvoices(invoice);
						
					}
					init();


				}]
		}
	}
]);
