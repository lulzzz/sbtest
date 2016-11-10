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

			controller: ['$scope', '$element', '$location', '$filter', 'reportRepository','$anchorScroll', '$window',
				function ($scope, $element, $location, $filter, reportRepository, $anchorScroll, $window) {
					var dataSvc = {
						isBodyOpen: true,
						response: null,
						approachingPayrolls: [],
						filteredApproachingPayrolls: [],
						payrollsWithoutInvoice: [],
						filterApproachingPayroll: ''
					}


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
						
						$scope.chartData = [];
						$scope.drawPayrollChart();
						$scope.drawInvoiceChart();
						$scope.drawPayrollWithoutInvoiceChart();
						$scope.drawCompaniesWithApproachingPayrolls();

					};
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
									var url = "#!/Admin/Invoices?company=" + ctx[0].chartData[0][col];
									$window.location.href = url;
								});
							}
						} else {
							element.html("<b>" + options.title + "</b><br/>No Data");
						}
					}

					$scope.drawInvoiceChart = function () {
						reportRepository.getDashboardData('GetInvoiceChartData', $scope.data.startDate, $scope.data.endDate, '').then(function (data) {
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

						}, function (error) {
							console.log(error);
						});

					};
					$scope.drawPayrollChart = function () {
						reportRepository.getDashboardData('GetPayrollChartData', $scope.data.startDate, $scope.data.endDate,  '').then(function (data) {
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

						}, function (error) {
							console.log(error);
						});

					};

					$scope.drawPayrollWithoutInvoiceChart = function () {
						reportRepository.getDashboardData('GetPayrollsWithoutInvoice', $scope.data.startDate, $scope.data.endDate, '').then(function (data) {
							dataSvc.payrollsWithoutInvoice = data.data;

						}, function (error) {
							console.log(error);
						});

					};

					$scope.drawCompaniesWithApproachingPayrolls = function () {
						reportRepository.getDashboardData('GetCompaniesNextPayrollChartData', $scope.data.startDate, $scope.data.endDate, '').then(function (data) {
							dataSvc.approachingPayrolls = data.data;
							dataSvc.filteredApproachingPayrolls = angular.copy(data.data);
						}, function (error) {
							console.log(error);
						});

					};

					$scope.filterCompaniesApproachingPayroll = function() {
						if (dataSvc.filterApproachingPayroll) {
							var filtered = [];
							$.each(dataSvc.approachingPayrolls, function(ind, ap) {
								if (ap[4] === dataSvc.filterApproachingPayroll) {
									filtered.push(ap);
								}
							});
							dataSvc.filteredApproachingPayrolls = filtered;
						} else {
							dataSvc.filteredApproachingPayrolls = angular.copy(dataSvc.approachingPayrolls);
						}
					}

					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
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
						
						

					};

					_init();
					

				}]
		}
	}
]);
