'use strict';

common.directive('userDashboard', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/user-dashboard.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'reportRepository','$anchorScroll', '$window', 'commonRepository', 'NgTableParams',
				function ($scope, $element, $location, $filter, reportRepository, $anchorScroll, $window, commonRepository, ngTableParams) {
					var dataSvc = {
						isBodyOpen: true,
						response: null,
						approachingPayrolls: [],
						filteredApproachingPayrolls: [],
						payrollsWithoutInvoice: [],
						companiesWithoutPayroll: [],
						filterApproachingPayroll: '',
						sortApproachingPayrolls:1,
						myNews: [],
						reportData: [],
						tab:1
					}

					$scope.zionAPI = zionAPI; 
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = false;
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;

					$scope.chartData = [];
					$scope.selectedChart = null;
					$scope.print = function () {
						$window.print();
					}
					$scope.drawCharts = function () {

						$scope.data.criteria = '';
						$scope.selectedChart = null;
						var element = angular.element(document.querySelector('#ncDetailedCriteriaForProject'));
						element.html('');
						$scope.drawPayrollWithoutInvoiceChart();
						$scope.drawCompaniesWithApproachingPayrolls();
						$scope.drawCompaniesWithoutPayrollChart();
						//reportRepository.getDashboardData('GetUserDashboard', $scope.data.startDate, $scope.data.endDate, '').then(function (data) {
						//	dataSvc.reportData = data;
						//	$scope.chartData = [];

						//	$scope.drawCompaniesWithApproachingPayrolls();
						//	$scope.drawCompaniesWithoutPayrollChart();


						//}, function (error) {
						//	console.log(error);
						//});


					};
					var drawARCharts = function (startdate, enddate, onlyActive) {
						
						reportRepository.getDashboardData('GetInvoiceStatusChartData', startdate, enddate, '', onlyActive).then(function (data) {
							dataSvc.reportData = data;
							$scope.chartData = [];
							$scope.drawInvoiceStatusChart();


						}, function (error) {
							console.log(error);
						});
					}
					var drawPerformanceCharts = function (startdate, enddate, onlyActive) {
						$scope.drawCommissionPerformanceChart(startdate, enddate, onlyActive);
						$scope.drawProcessingPerformanceChart(startdate, enddate, onlyActive);
					}
					$scope.tabChanged = function (tab) {
						var m = $scope.mainData;
						dataSvc.tab = tab;
						if (tab === 4) {
							$scope.drawCharts();
						} else if (tab === 2) {
							drawARCharts(m.reportFilter.filterStartDate, m.reportFilter.filterEndDate, m.reportFilter.filter.onlyActive);
						}
						else if (tab === 3) {
							drawPerformanceCharts(m.reportFilter.filterStartDate, m.reportFilter.filterEndDate, m.reportFilter.filter.onlyActive);
						}
						
					}
					$scope.getReport = function () {
						var m = $scope.mainData;
						if (dataSvc.tab === 2) {
							drawARCharts(m.reportFilter.filterStartDate, m.reportFilter.filterEndDate, m.reportFilter.filter.onlyActive);
						}
						else if (dataSvc.tab === 3) {
							drawPerformanceCharts(m.reportFilter.filterStartDate, m.reportFilter.filterEndDate, m.reportFilter.filter.onlyActive);
						}
					}
					var mapListToDataTable = function (input) {
						return new google.visualization.arrayToDataTable(input.data);
					};

					var handleChart = function (chart, element, ws_data, data, options, addListener) {
						if (data.data.length > 1) {
							chart.draw(ws_data, options);
							if (addListener && data.data.length > 1) {
								google.visualization.events.addListener(chart, 'select', function () {
									var selection = chart.getSelection();
									var col = selection[0].column;
									var key = options.chartKey;
									var ctx = $filter('filter')($scope.chartData, { chartName: key }, true);
									$scope.mainData.invoiceCompany = ctx[0].chartData[0][col];
									var url = "#!/Admin/Invoices#invoice";
									$window.location.href = url;
								});
							}
						} else {
							element.html("<b>" + options.title + "</b><br/>No Data");
						}
					}

					$scope.drawCommissionPerformanceChart = function (startdate, enddate, onlyActive) {
						reportRepository.getDashboardData('GetCommissionPerformanceChart', startdate, enddate, null, onlyActive).then(function (data1) {
							var data = data1[0];
							if (data1.length > 0) {
								var ws_data = null;
								ws_data = mapListToDataTable(data);
								clearIfExists('CommissionPerformanceChartData', data.data, 'Commissions of Sales Reps by Month');

								var options = {
									title: 'Commissions of Sales Reps by Month',
									vAxis: {
										title: "Commission"
									},
									hAxis: {
										title: "Months"
									},
									curveType: 'function',
									legend: { position: 'none' },
									'width': '90%',
									'height': 500,
									'chartKey': 'CommissionPerformanceChartData'
								};

								var chart = new google.visualization.ComboChart($element.find('#commissionPerformanceChart')[0]);
								var element = angular.element(document.querySelector('#commissionPerformanceChart'));
								handleChart(chart, element, ws_data, data, options, false);
							}

						}, function (error) {
							console.log(error);
						});
						
					};
					$scope.drawProcessingPerformanceChart = function (startdate, enddate, onlyActive) {
						reportRepository.getDashboardData('GetPayrollProcessingPerformanceChart', startdate, enddate, null, onlyActive).then(function (data1) {
							var data = data1[0];
							if (data1.length > 0) {
								var ws_data = null;
								ws_data = mapListToDataTable(data);
								clearIfExists('PayrollProcessingPerformanceChartData', data.data, 'Payroll Processing of Users by Month');

								var options = {
									title: 'Payroll Processing of Users by Month',
									vAxis: {
										title: "No. of Payrolls"
									},
									hAxis: {
										title: "Months"
									},
									curveType: 'function',
									legend: { position: 'none' },
									'width': '90%',
									'height': 500,
									'chartKey': 'PayrollProcessingPerformanceChartData'
								};
								var chart = new google.visualization.ComboChart($element.find('#processingPerformanceChart')[0]);
								var element = angular.element(document.querySelector('#processingPerformanceChart'));
								handleChart(chart, element, ws_data, data, options, false);
							}

						}, function (error) {
							console.log(error);
						});
						

					};

					$scope.drawInvoiceChart = function () {
						var data = $filter('filter')(dataSvc.reportData, { result: 'GetInvoiceChartData' }, true)[0];
						if (data) {
							var ws_data = null;
							ws_data = mapListToDataTable(data);
							clearIfExists('InvoiceChartData', data.data, 'Companies with outstanding invoices by age');

							var options = {
								title: 'OS Invoice by age',
								vAxis: {
									title: "No. of Invoices"
								},
								hAxis: {
									title: "Age"
								},
								seriesType: "bars",
								isStacked: true,
								'width': '100%',
								'height': 400,
								'chartKey': 'InvoiceChartData'
							};

							var chart = new google.visualization.ComboChart($element.find('#invoiceChart')[0]);
							var element = angular.element(document.querySelector('#invoiceChart'));
							handleChart(chart, element, ws_data, data, options, true);
						}
						

					};
					$scope.drawPayrollChart = function () {
						var data = $filter('filter')(dataSvc.reportData, { result: 'GetPayrollChartData' }, true)[0];
						if (data) {
							var ws_data = null;
							ws_data = mapListToDataTable(data);
							clearIfExists('PayrollChartData', data.data, 'Companies with outstanding invoices with approaching payroll date');

							var options = {
								title: 'OS Invoice / Days to Next Payroll',
								vAxis: {
									title: "No. of Companies"
								},
								hAxis: {
									title: "Days to Next Payroll"
								},
								seriesType: "bars",
								isStacked: true,
								'width': '50%',
								'height': 400,
								'chartKey': 'PayrollChartData'
							};
							var chart = new google.visualization.ComboChart($element.find('#payrollChart')[0]);
							var element = angular.element(document.querySelector('#payrollChart'));
							handleChart(chart, element, ws_data, data, options, true);

						}
						

					};
					$scope.drawInvoiceStatusChart = function () {
						var data = $filter('filter')(dataSvc.reportData, { result: 'GetInvoiceStatusChartData' }, true)[0];
						if (data) {
							var ws_data = null;
							ws_data = mapListToDataTable(data);
							
							clearIfExists('InvoiceStatusChartData', data.data, 'Invoices by Statuses');

							var options = {
								title: 'Invoices by Status',
								vAxis: {
									title: "No. of Invoices"
								},
								hAxis: {
									title: "Status"
								},
								legend: { position: 'none' },
								bar: { groupWidth: "50%" },
								'width': '100%',
								'height': 400,
								'chartKey': 'InvoiceStatusChartData'
							};

							var chart = new google.visualization.ColumnChart($element.find('#invoiceststusChart')[0]);
							var element = angular.element(document.querySelector('#invoiceststusChart'));
							chart.draw(ws_data, options);
							google.visualization.events.addListener(chart, 'select', function () {
								var selection = chart.getSelection();
								var col = selection[0].column;
								var row = selection[0].row;
								var key = options.chartKey;
								var ctx = $filter('filter')($scope.chartData, { chartName: key }, true);
								var criteria = ctx[0].chartData[row+1][0];
								$scope.drawInvoiceStatusPastDueChart(criteria);
								$scope.drawInvoiceStatusDetailedChart(criteria);
							});
						}


					};
					$scope.drawInvoiceStatusDetailedChart = function (status) {
						reportRepository.getDashboardData('GetInvoiceStatusDetailedChartData', $scope.mainData.reportFilter.filterStartDate, $scope.mainData.reportFilter.filterEndDate, status, $scope.mainData.reportFilter.filter.onlyActive).then(function (data1) {
							var data = data1[0];
							if (data1.length>0) {
								var ws_data = null;
								ws_data = mapListToDataTable(data);
								clearIfExists('InvoiceStatusDetailedChartData', data.data, 'OS Invoice / Days to Next Payroll: Status = ' + status);

								var options = {
									title: 'OS Invoice / Days to Next Payroll: Status = ' + status,
									vAxis: {
										title: "No. of Invoices"
									},
									hAxis: {
										title: "Status"
									},
									seriesType: "bars",
									isStacked: false,
									'width': '100%',
									'height': 400,
									'chartKey': 'InvoiceStatusDetailedChartData'
								};

								var chart = new google.visualization.ComboChart($element.find('#invoicestatusdetailedChart')[0]);
								var element = angular.element(document.querySelector('#invoicestatusdetailedChart'));
								handleChart(chart, element, ws_data, data, options, true);

							}

						}, function (error) {
							console.log(error);
						});
						


					};
					$scope.drawInvoiceStatusPastDueChart = function (status) {
						reportRepository.getDashboardData('GetInvoiceStatusPastDueChartData', $scope.mainData.reportFilter.filterStartDate, $scope.mainData.reportFilter.filterEndDate, status, $scope.mainData.reportFilter.filter.onlyActive).then(function (data1) {
							var data = data1[0];
							if (data) {
								var ws_data = null;
								ws_data = mapListToDataTable(data);
								clearIfExists('InvoiceStatusPastDueChartData', data.data, 'OS Invoice by Age: Status = ' + status);

								var options = {
									title: 'OS Invoice by Age: Status = ' + status,
									vAxis: {
										title: "No. of Invoices"
									},
									hAxis: {
										title: "Age"
									},
									seriesType: "bars",
									isStacked: false,
									'width': '100%',
									'height': 400,
									'chartKey': 'InvoiceStatusPastDueChartData'
								};

								var chart = new google.visualization.ComboChart($element.find('#invoicestatuspastdueChart')[0]);
								var element = angular.element(document.querySelector('#invoicestatuspastdueChart'));
								handleChart(chart, element, ws_data, data, options, true);

							}

						}, function (error) {
							console.log(error);
						});
						


					};

					$scope.drawPayrollWithoutInvoiceChart = function () {
						reportRepository.getDashboardData('GetPayrollsWithoutInvoice', $scope.mainData.reportFilter.filterStartDate, $scope.mainData.reportFilter.filterEndDate, null, $scope.mainData.reportFilter.filter.onlyActive).then(function (data1) {
							var data = data1[0];
							if (data) {
								dataSvc.payrollsWithoutInvoice = data.data;
								
							}

						}, function (error) {
							console.log(error);
						});
					};
					$scope.drawCompaniesWithoutPayrollChart = function () {
						dataSvc.companiesWithoutPayroll = [];
						reportRepository.getDashboardData('GetCompaniesWithoutPayroll', $scope.mainData.reportFilter.filterStartDate, $scope.mainData.reportFilter.filterEndDate, null, $scope.mainData.reportFilter.filter.onlyActive).then(function (data1) {
							var data = data1[0];
							if (data) {
								var d = data.data;
								$.each(d, function (ind, ap) {
									if (ind > 0) {
										var salesRepJson = ap[4] ? JSON.parse(ap[4]) : '';
										dataSvc.companiesWithoutPayroll.push({
											hostId: ap[0],
											companyId: ap[1],
											host: ap[2],
											company: ap[3],
											salesRep: salesRepJson.SalesRep ? salesRepJson.SalesRep.User.FirstName + ' ' + salesRepJson.SalesRep.User.LastName : 'NA',
											due: ap[5]
										});
									}

								});

							}

						}, function (error) {
							console.log(error);
						});
						
					};
					$scope.drawCompaniesWithApproachingPayrolls = function () {
						reportRepository.getDashboardData('GetCompaniesNextPayrollChartData', $scope.mainData.reportFilter.filterStartDate, $scope.mainData.reportFilter.filterEndDate, null, $scope.mainData.reportFilter.filter.onlyActive).then(function (data1) {
							var data = data1[0];
							if (data) {
								dataSvc.approachingPayrolls = data.data;
								var filtered = [];
								$.each(dataSvc.approachingPayrolls, function (ind, ap) {
									if (ind > 0) {
										var salesRepJson = ap[4] ? JSON.parse(ap[4]) : '';
										filtered.push({
											hostId: ap[0],
											companyId: ap[1],
											host: ap[2],
											company: ap[3],
											salesRep: salesRepJson.SalesRep ? salesRepJson.SalesRep.User.FirstName + ' ' + salesRepJson.SalesRep.User.LastName : 'NA',
											due: ap[5]
										});
									}

								});
								dataSvc.filteredApproachingPayrolls = angular.copy(filtered);
								$scope.tableParams.reload();
								$scope.fillTableData($scope.tableParams);

							}

						}, function (error) {
							console.log(error);
						});
						
					};

					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						sorting: {
							due: 'asc'     // initial sorting
						}
					}, {
						total: $scope.filteredApproachingPayrolls ? $scope.filteredApproachingPayrolls.length : 0, // length of data
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
						if (dataSvc.filteredApproachingPayrolls && dataSvc.filteredApproachingPayrolls.length > 0) {
							var orderedData = params.filter() ?
																$filter('filter')(dataSvc.filteredApproachingPayrolls, params.filter()) :
																dataSvc.filteredApproachingPayrolls;

							orderedData = params.sorting() ?
														$filter('orderBy')(orderedData, params.orderBy()) :
														orderedData;

							$scope.tableParams = params;
							$scope.tableData = orderedData;

							params.total(orderedData.length); // set total for recalc pagination
						}
					};

					

					$scope.filterCompaniesApproachingPayroll = function() {
						if (dataSvc.filterApproachingPayroll) {
							var filtered = [];
							$.each(dataSvc.approachingPayrolls, function (ind, ap) {
								if (ind === 0) {
									filtered.push(ap);
								} else {
									if (ap[5] === dataSvc.filterApproachingPayroll) {
										filtered.push(ap);
									}
								}
								
							});
							dataSvc.filteredApproachingPayrolls = filtered;
						} else {
							dataSvc.filteredApproachingPayrolls = angular.copy(dataSvc.approachingPayrolls);
						}
					}
					

					var addAlert = function (error, type) {
						$sco$scope.audienceIpe.$parent.$parent.addAlert(error, type);
					};

					var clearIfExists = function (key, data, title) {
						var selected = $filter('filter')($scope.chartData, { chartName: key }, true);
						if (selected.length > 0) {
							$scope.chartData.splice($scope.chartData.indexOf(selected[0]), 1);
						}
						$scope.chartData.push({ 'chartName': key, 'chartData': data, 'title' : title });
					}
					$scope.viewChartData = function (key) {
						var selected = $filter('filter')($scope.chartData, { chartName: key }, true);
						$scope.selectedChart = selected[0];
						//$location.hash('chartTable');
						$anchorScroll();
					}
					$scope.chartExists = function (key) {
						if (!$scope.chartData)
							return false;
						var selected = $filter('filter')($scope.chartData, { chartName: key }, true);
						if (selected.length === 1 && selected[0].chartData.length > 1)
							return true;
						else
							return false;
					}

					$scope.viewPayrolls = function (host, company) {
						$scope.mainData.fromPayrollsWithoutInvoice = true;
						$scope.$parent.$parent.setHostandCompany(host, company, "#!/Client/Payrolls#invoice");
					}

					function _init() {
						
							var options = {
								packages: ['corechart', 'controls'],
								callback: $scope.drawCharts
							};

							//google.load('visualization', '1.0', options);
							
							commonRepository.getUserNews().then(function (data) {
								dataSvc.myNews = data;
								
							}, function (erorr) {

							});

							$scope.mainData.reportFilter.filterStartDate = null;
							$scope.mainData.reportFilter.filterEndDate = null;
							$scope.mainData.reportFilter.filter.startDate = null;
							$scope.mainData.reportFilter.filter.endDate = null;
							$scope.mainData.reportFilter.filter.onlyActive = false;
							$scope.mainData.reportFilter.filter.filterByDateRange = false;
							$scope.mainData.reportFilter.filter.filterByMonthYear = false;
							$scope.mainData.reportFilter.filter.month = 0;
							$scope.mainData.reportFilter.filter.quarter = 0;

					};

					_init();
					

				}]
		}
	}
]);
