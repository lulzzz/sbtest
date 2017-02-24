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

			controller: ['$scope', '$element', '$location', '$filter', 'reportRepository','$anchorScroll', '$window', 'commonRepository',
				function ($scope, $element, $location, $filter, reportRepository, $anchorScroll, $window, commonRepository) {
					var dataSvc = {
						isBodyOpen: true,
						response: null,
						approachingPayrolls: [],
						filteredApproachingPayrolls: [],
						payrollsWithoutInvoice: [],
						companiesWithoutPayroll: [],
						filterApproachingPayroll: '',
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
						reportRepository.getDashboardData('GetUserDashboard', $scope.data.startDate, $scope.data.endDate, '').then(function (data) {
							dataSvc.reportData = data;
							$scope.chartData = [];
							$scope.drawPayrollWithoutInvoiceChart();
							$scope.drawCompaniesWithApproachingPayrolls();
							$scope.drawCompaniesWithoutPayrollChart();
							$scope.drawPayrollChart();
							$scope.drawInvoiceChart();
							
						}, function (error) {
							console.log(error);
						});
						
						
					};
					var drawARCharts = function() {
						reportRepository.getDashboardData('GetInvoiceStatusChartData', $scope.data.startDate, $scope.data.endDate, '').then(function (data) {
							dataSvc.reportData = data;
							$scope.chartData = [];
							$scope.drawInvoiceStatusChart();


						}, function (error) {
							console.log(error);
						});
					}
					$scope.tabChanged = function (tab) {
						dataSvc.tab = tab;
						if (tab === 1) {
							$scope.drawCharts();
						} else {
							drawARCharts();
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
								seriesType: "bars",
								isStacked: false,
								'width': '100%',
								'height': 400,
								'chartKey': 'InvoiceStatusChartData'
							};

							var chart = new google.visualization.ComboChart($element.find('#invoiceststusChart')[0]);
							var element = angular.element(document.querySelector('#invoiceststusChart'));
							chart.draw(ws_data, options);
							google.visualization.events.addListener(chart, 'select', function () {
								var selection = chart.getSelection();
								var col = selection[0].column;
								var key = options.chartKey;
								var ctx = $filter('filter')($scope.chartData, { chartName: key }, true);
								var criteria = ctx[0].chartData[0][col];
								$scope.drawInvoiceStatusPastDueChart(criteria);
								$scope.drawInvoiceStatusDetailedChart(criteria);
							});
						}


					};
					$scope.drawInvoiceStatusDetailedChart = function (status) {
						reportRepository.getDashboardData('GetInvoiceStatusDetailedChartData', $scope.data.startDate, $scope.data.endDate, status).then(function (data1) {
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
						reportRepository.getDashboardData('GetInvoiceStatusPastDueChartData', $scope.data.startDate, $scope.data.endDate, status).then(function (data1) {
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
						var data = $filter('filter')(dataSvc.reportData, { result: 'GetPayrollsWithoutInvoice' })[0];
						if (data) {
							dataSvc.payrollsWithoutInvoice = data.data;
						}
					};
					$scope.drawCompaniesWithoutPayrollChart = function () {
						var data = $filter('filter')(dataSvc.reportData, { result: 'GetCompaniesWithoutPayroll' })[0];
						if (data) {
							dataSvc.companiesWithoutPayroll = data.data;
						}
					};

					$scope.drawCompaniesWithApproachingPayrolls = function () {
						var data = $filter('filter')(dataSvc.reportData, { result: 'GetCompaniesNextPayrollChartData' })[0];
						if (data) {
							dataSvc.approachingPayrolls = data.data;
							dataSvc.filteredApproachingPayrolls = angular.copy(data.data);
						}
					};

					$scope.filterCompaniesApproachingPayroll = function() {
						if (dataSvc.filterApproachingPayroll) {
							var filtered = [];
							$.each(dataSvc.approachingPayrolls, function (ind, ap) {
								if (ind === 0) {
									filtered.push(ap);
								} else {
									if (ap[4] === dataSvc.filterApproachingPayroll) {
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

					$scope.viewPayrolls = function(d) {
						$scope.$parent.$parent.setHostandCompany(d[0], d[1], "#!/Client/Payrolls#invoice");
					}

					function _init() {
						
							var options = {
								packages: ['corechart', 'controls'],
								callback: $scope.drawCharts
							};

							//google.load('visualization', '1.0', options);
							$scope.drawCharts();
							commonRepository.getUserNews().then(function (data) {
								dataSvc.myNews = data;
								
							}, function (erorr) {

							});
						
						

					};

					_init();
					

				}]
		}
	}
]);
