'use strict';

common.directive('companyDashboard', ['zionAPI', '$timeout', '$window', 'version', '$sce',
	function (zionAPI, $timeout, $window, version, $sce) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: $sce.trustAsResourceUrl(zionAPI.Web + 'Areas/Reports/templates/company-dashboard.html?v=' + version),

            controller: ['$scope', '$element', '$location', '$filter', 'reportRepository', '$anchorScroll', 'ClaimTypes', 'NgTableParams', 'anchorSmoothScroll',
                function ($scope, $element, $location, $filter, reportRepository, $anchorScroll, ClaimTypes, ngTableParams, anchorSmoothScroll) {
					var dataSvc = {
						dashboard: null,
						showChart: false,
						chartTitle: '',
						donutChartTotal: 0,
						donutPaid:0,
						donutPending:0,
						donutPaidPercentage: 0,
						donutPendingPercentage: 0,
						tab: 0,
						filteredExtracts: [],
						filteredPendingExtracts: [],
						loaded:false

				}
					$scope.tabChanged = function(tab) {
						dataSvc.tab = tab;
						if (tab === 2) {
							$timeout(function () {
								var payrolls = $filter('orderBy')(dataSvc.dashboard.payrollHistory, 'dRank', true);
								handlePayrollChart(payrolls, 'payrolls');
							});
						}
						else if (tab === 3) {

						}
						else if (tab === 4) {
							$timeout(function () {
								handleDonutChart(dataSvc.dashboard.invoiceDueByCustomers.items, 'invoice-customers-donut');
								handleDonutChart(dataSvc.dashboard.productRevenueShare.items, 'product-revenue-donut');
								handleDonutChart(dataSvc.dashboard.vendorExpenses.items, 'expense-vendor-donut');
								handleDonutChart(dataSvc.dashboard.expenseTypes.items, 'expense-type-donut');
							},1);
							
                        }
						
					}
					$scope.zionAPI = zionAPI; 
					$scope.data = dataSvc;
					var blue = '#348fe2',
						blueLight = '#5da5e8',
						blueDark = '#1993E4',
						aqua = '#49b6d6',
						aquaLight = '#6dc5de',
						aquaDark = '#3a92ab',
						green = '#00acac',
						greenLight = '#33bdbd',
						greenDark = '#008a8a',
						orange = '#f59c1a',
						orangeLight = '#f7b048',
						orangeDark = '#c47d15',
						dark = '#2d353c',
						grey = '#b6c2c9',
						purple = '#727cb6',
						purpleLight = '#8e96c5',
						purpleDark = '#5b6392',
						red = '#ff5b57',
						redLight = '#ff5b57', blackLight = '#2d353c', black = '#000';

					dataSvc.colors = [green, blue, purple, dark, aqua, grey, greenLight, greenDark, blueLight, blueDark, purpleLight, purpleDark, redLight, black, blackLight];

					var getMonthName = function (x) {
						var month = [];
						month[0] = "Jan";
						month[1] = "Feb";
						month[2] = "Mar";
						month[3] = "Apr";
						month[4] = "May";
						month[5] = "Jun";
						month[6] = "Jul";
						month[7] = "Aug";
						month[8] = "Sep";
						month[9] = "Oct";
						month[10] = "Nov";
						month[11] = "Dec";

						return month[x.getMonth()] + '-' + x.getFullYear().toString().substr(2, 2);
					};

					var handleDonutChart = function (chartData, element) {
						$("#" + element).empty();
						
						Morris.Donut({
							element: element,
							data: chartData,
							colors: dataSvc.colors,
							labelFamily: 'Open Sans',
							labelColor: 'rgba(255,255,255,0.4)',
							labelTextSize: '12px',
							backgroundColor: '#242a30'
						});
					};

					//var handleDashboardSparkline = function () {
					//	"use strict";
					//	var options = {
					//		height: '50px',
					//		width: '100%',
					//		fillColor: 'transparent',
					//		lineWidth: 2,
					//		spotRadius: '4',
					//		highlightLineColor: blue,
					//		highlightSpotColor: blue,
					//		spotColor: false,
					//		minSpotColor: false,
					//		maxSpotColor: false
					//	};
					//	function renderDashboardSparkline() {
					//		var value = [50, 30, 45, 40, 50, 20, 35, 40, 50, 70, 90, 40];
					//		options.type = 'line';
					//		options.height = '23px';
					//		options.lineColor = red;
					//		options.highlightLineColor = red;
					//		options.highlightSpotColor = red;

					//		var countWidth = $('#sparkline-unique-visitor').width();
					//		if (countWidth >= 200) {
					//			options.width = '200px';
					//		} else {
					//			options.width = '100%';
					//		}

					//		$('#sparkline-unique-visitor').sparkline(value, options);
					//		options.lineColor = orange;
					//		options.highlightLineColor = orange;
					//		options.highlightSpotColor = orange;
					//		$('#sparkline-bounce-rate').sparkline(value, options);
					//		options.lineColor = green;
					//		options.highlightLineColor = green;
					//		options.highlightSpotColor = green;
					//		$('#sparkline-total-page-views').sparkline(value, options);
					//		options.lineColor = blue;
					//		options.highlightLineColor = blue;
					//		options.highlightSpotColor = blue;
					//		$('#sparkline-avg-time-on-site').sparkline(value, options);
					//		options.lineColor = grey;
					//		options.highlightLineColor = grey;
					//		options.highlightSpotColor = grey;
					//		$('#sparkline-new-visits').sparkline(value, options);
					//		options.lineColor = dark;
					//		options.highlightLineColor = dark;
					//		options.highlightSpotColor = grey;
					//		$('#sparkline-return-visitors').sparkline(value, options);
					//	}

					//	renderDashboardSparkline();

					//	$(window).on('resize', function () {
					//		$('#sparkline-unique-visitor').empty();
					//		$('#sparkline-bounce-rate').empty();
					//		$('#sparkline-total-page-views').empty();
					//		$('#sparkline-avg-time-on-site').empty();
					//		$('#sparkline-new-visits').empty();
					//		$('#sparkline-return-visitors').empty();
					//		renderDashboardSparkline();
					//	});
					//};

					var handleExtractChart = function (data, element) {
						$("#" + element).empty();
						var green = '#0D888B';
						var greenLight = '#00ACAC';
						var blue = '#3273B1';
						var blueLight = '#348FE2';
						var blackTransparent = 'rgba(0,0,0,0.6)';
						var whiteTransparent = 'rgba(255,255,255,0.4)';

						Morris.Line({
							element: element,
							data: data,
							xkey: 'depositDate',
							ykeys: ['amount'],
							xLabelFormat: function (x) {
								x = getMonthName(x);
								return x.toString();
							},
							labels: ['Tax Paid'],
							lineColors: [green],
							pointFillColors: [greenLight],
							lineWidth: '2px',
							pointStrokeColors: [blackTransparent, blackTransparent],
							resize: true,
							gridTextFamily: 'Open Sans',
							gridTextColor: whiteTransparent,
							gridTextWeight: 'normal',
							gridTextSize: '11px',
							gridLineColor: 'rgba(0,0,0,0.5)',
							hideHover: 'auto',
						});
					};

					var handlePayrollChart = function (data, element) {
						$("#" + element).empty();
						
						var blackTransparent = 'rgba(0,0,0,0.6)';
						var whiteTransparent = 'rgba(255,255,255,0.4)';

						Morris.Line({
							element: element,
							data: data,
							xkey: 'payDay',
							ykeys: ['grossWage', 'netWage', 'employeeTaxes', 'employerTaxes', 'deductions'],
							xLabelFormat: function (x) {
								x = getMonthName(x);
								return x.toString();
							},
							labels: ['Gross Wage', 'Net Wage', 'Employee Taxes', 'Employer Taxes', 'Deductions'],
							lineColors: [green, blue, purple, red, black],
							pointFillColors: [greenLight, blueLight, purpleLight, redLight, blackLight],
							lineWidth: '2px',
							pointStrokeColors: [whiteTransparent, blackTransparent],
							resize: true,
							gridTextFamily: 'Open Sans',
							gridTextColor: whiteTransparent,
							gridTextWeight: 'normal',
							gridTextSize: '11px',
							gridLineColor: 'rgba(0,0,0,0.5)',
							hideHover: 'auto',
						});
					};

					var handleExtractDonutChart = function () {
						$("#extract-donut").empty();
						var green = '#00acac';
						var blue = '#348fe2';
						Morris.Donut({
							element: 'extract-donut',
							data: [
									{ label: "Paid", value: dataSvc.donutPaid },
									{ label: "Pending", value: dataSvc.donutPending }
							],
							colors: [green, blue],
							labelFamily: 'Open Sans',
							labelColor: 'rgba(255,255,255,0.4)',
							labelTextSize: '12px',
							backgroundColor: '#242a30'
						});
					};
					$scope.showChart = function (extract) {
						dataSvc.showChart = true;
						dataSvc.extractType = extract;
						$timeout(function () {
							
							var color = 'black';
							if (extract === 1) {
								dataSvc.filteredExtracts = $filter('filter')(dataSvc.dashboard.extractHistory, { extractName: 'Federal941' });
								dataSvc.filteredPendingExtracts = $filter('filter')(dataSvc.dashboard.pendingExtracts, { extractName: 'Federal941' });
								color = '0D888B';
								dataSvc.chartTitle = 'Federal 941 Extract History';
								dataSvc.donutPaid = dataSvc.dashboard.ytd941Extract;
								dataSvc.donutPending = dataSvc.dashboard.pending941Amount;

							}
							else if (extract === 2) {
								dataSvc.chartTitle = 'Federal 940 Extract History';
								dataSvc.filteredExtracts = $filter('filter')(dataSvc.dashboard.extractHistory, { extractName: 'Federal940' });
								dataSvc.filteredPendingExtracts = $filter('filter')(dataSvc.dashboard.pendingExtracts, { extractName: 'Federal940' });
								dataSvc.donutPaid = dataSvc.dashboard.ytd940Extract;
								dataSvc.donutPending = dataSvc.dashboard.pending940Amount;
							}
							else if (extract === 3) {
								dataSvc.chartTitle = 'CA PIT & DI Extract History';
								dataSvc.filteredExtracts = $filter('filter')(dataSvc.dashboard.extractHistory, { extractName: 'StateCAPIT' });
								dataSvc.filteredPendingExtracts = $filter('filter')(dataSvc.dashboard.pendingExtracts, { extractName: 'StateCAPIT' });
								dataSvc.donutPaid = dataSvc.dashboard.ytdCAPITExtract;
								dataSvc.donutPending = dataSvc.dashboard.pendingPitAmount;
							}
							else {
								dataSvc.chartTitle = 'CA UI & ETT Extract History';
								dataSvc.filteredExtracts = $filter('filter')(dataSvc.dashboard.extractHistory, { extractName: 'StateCAUI' });
								dataSvc.filteredPendingExtracts = $filter('filter')(dataSvc.dashboard.pendingExtracts, { extractName: 'StateCAUI' });
								dataSvc.donutPaid = dataSvc.dashboard.ytdCAUIETTExtract;
								dataSvc.donutPending = dataSvc.dashboard.pendingUiEttAmount;
							}
							dataSvc.donutChartTotal = dataSvc.donutPaid + dataSvc.donutPending;
							dataSvc.donutPaidPercentage = (dataSvc.donutPaid / dataSvc.donutChartTotal) * 100;
							dataSvc.donutPendingPercentage = (dataSvc.donutPending / dataSvc.donutChartTotal) * 100;
							dataSvc.filteredExtracts = $filter('orderBy')(dataSvc.filteredExtracts, 'dRank', true);
							dataSvc.filteredPendingExtracts = $filter('orderBy')(dataSvc.filteredPendingExtracts, 'depositDate', true);
							handleExtractChart(dataSvc.filteredExtracts, 'extract-paid');
							handleExtractChart(dataSvc.filteredPendingExtracts, 'extract-pending');
                            handleExtractDonutChart();
                            
						});
						
						
					}
                    $scope.scrollToSummary = function() {
                        $timeout(function () {
                            var e = document.getElementById('payrollsummary');
                            anchorSmoothScroll.scrollToElement(e);
                        }, 0);
                    }
					$scope.listEmployeeAccess = [];
					$scope.listEmployeeDocuments = [];
					$scope.tableDataEmployeeView = [];
					$scope.tableParamsEmployeeView = new ngTableParams({
						page: 1,            // show first page
						count: 10
					}, {
						total: $scope.listEmployeeAccess ? $scope.listEmployeeAccess.length : 0, // length of data
						getData: function (params) {
							$scope.fillTableDataEmployeeView(params);
							return $scope.tableDataEmployeeView;
						}
					});

					$scope.fillTableDataEmployeeView = function (params) {
						// use build-in angular filter
						if ($scope.listEmployeeAccess && $scope.listEmployeeAccess.length > 0) {
							var orderedData = params.filter() ?
																$filter('filter')($scope.listEmployeeAccess, params.filter()) :
																$scope.listEmployeeAccess;

							orderedData = params.sorting() ?
														$filter('orderBy')(orderedData, params.orderBy()) :
														orderedData;

							$scope.tableParamsEmployeeView = params;
							$scope.tableDataEmployeeView = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count());

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					$scope.tableDataEmployeeRequired = [];
					$scope.tableParamsEmployeeRequired = new ngTableParams({
						page: 1,            // show first page
						count: 10
					}, {
						total: $scope.listEmployeeDocuments ? $scope.listEmployeeDocuments.length : 0, // length of data
						getData: function (params) {
							$scope.fillTableDataEmployeeRequired(params);
							return $scope.tableDataEmployeeRequired;
						}
					});

					$scope.fillTableDataEmployeeRequired = function (params) {
						// use build-in angular filter
						if ($scope.listEmployeeDocuments && $scope.listEmployeeDocuments.length > 0) {
							var orderedData = params.filter() ?
																$filter('filter')($scope.listEmployeeDocuments, params.filter()) :
																$scope.listEmployeeDocuments;

							orderedData = params.sorting() ?
														$filter('orderBy')(orderedData, params.orderBy()) :
														orderedData;

							$scope.tableDataEmployeeRequired = params;
							$scope.tableDataEmployeeRequired = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count());

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					var refillTables = function () {
						
						$scope.tableParamsEmployeeView.reload();
						$scope.fillTableDataEmployeeView($scope.tableParamsEmployeeView);

						$scope.tableParamsEmployeeRequired.reload();
						$scope.fillTableDataEmployeeRequired($scope.tableParamsEmployeeRequired);

					}
					$scope.getDocumentUrl = function (document) {
						if (!document)
							return '';
						return zionAPI.URL + 'Document/' + document.targetEntityId;
					};
					$scope.getEmployeeDocumentUrl = function (document) {
						if ($scope.mainData.userEmployee && $scope.mainData.userEmployee === $scope.employeeId)
							return zionAPI.URL + 'EmployeeDocument/' + document.document.targetEntityId + '/' + $scope.employeeId;
						else {
							return zionAPI.URL + 'Document/' + document.document.targetEntityId;
						}
					};
					function _init() {
						
						//handleInteractiveChart();
						//handleDashboardSparkline();
						//handleDonutChart();
						
						
							reportRepository.getCompanyDashboard($scope.mainData.selectedCompany.id).then(function (data) {
								dataSvc.dashboard = data;
								$scope.listEmployeeAccess = dataSvc.dashboard.employeeDocumentMetaData.employeeDocumentAccesses;
								$scope.listEmployeeDocuments = dataSvc.dashboard.employeeDocumentMetaData.employeeDocumentRequirements;
								refillTables();
								$scope.tabChanged($scope.mainData.selectedCompany.contract.invoicing ? 4 : ($scope.mainData.selectedCompany.contract.payrolls ? 2 : ($scope.mainData.selectedCompany.contract.taxation && $scope.mainData.selectedCompany.allowTaxPayments ? 1 : 3)));
								dataSvc.loaded = true;
								dataSvc.paymentDue = 55;
								//
							}, function (erorr) {

							});


					};
					$scope.getPaymentProgressBarValue = function () {
						
						return (dataSvc.dashboard.invoiceOverDueAmount/(dataSvc.dashboard.invoiceOverDueAmount + dataSvc.dashboard.invoiceNotOverDueAmount))*100;
					}

					_init();
					

				}]
		}
	}
]);
