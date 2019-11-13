'use strict';

common.directive('userDashboard', ['zionAPI', '$timeout', '$window', 'version', '$sce',
	function (zionAPI, $timeout, $window, version, $sce) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: $sce.trustAsResourceUrl(zionAPI.Web + 'Areas/Reports/templates/user-dashboard.html?v=' + version),

			controller: ['$scope', '$element', '$location', '$filter', 'reportRepository', '$anchorScroll', 'commonRepository', 'NgTableParams', 'ClaimTypes', 'payrollRepository', 'anchorSmoothScroll',
				function ($scope, $element, $location, $filter, reportRepository, $anchorScroll, commonRepository, ngTableParams, ClaimTypes, payrollRepository, anchorSmoothScroll) {
					var dataSvc = {
						isBodyOpen: true,
						response: null,
						
						approachingPayrolls: [],
						filteredApproachingPayrolls: [],
						payrollsWithoutInvoice: [],
						payrollsWithDraftInvoice: [],
						companiesWithoutPayroll: [],
						filterApproachingPayroll: '',
						clearanceData: [],
						filteredClearanceData: [],
						sortApproachingPayrolls: 1,
						viewingChart: 0,
						myNews: [],
						reportData: [],
						tab: 1,
						printOption: 0,
						viewCompanyList: $scope.mainData.hasClaim(ClaimTypes.DashboardCompanyLists, 1),
						viewAccountReceivables: $scope.mainData.hasClaim(ClaimTypes.DashboardAccountReceivable,1),
						viewPerformance: $scope.mainData.hasClaim(ClaimTypes.DashboardPerformance, 1),
						viewClearance: $scope.mainData.hasClaim(ClaimTypes.DashboardAccountReceivable,1),
					}
					$scope.invoiceStatusList = [];
					$scope.selectedInvoice = null;
					$scope.set = function (item) {
						$scope.selectedInvoice = null;
						if (item && item.id) {
							payrollRepository.getInvoiceById(item.id).then(function (invoice) {
								$scope.selectedInvoice = invoice;
								$scope.$parent.$parent.setHostandCompanyFromInvoice(invoice.company.hostId, invoice.company.id);
								$location.hash("invoice");
								anchorSmoothScroll.scrollTo('invoice');
							}, function (error) {
								$scope.addAlert('error getting invoices', 'danger');

							});
						}
					}
					$scope.tableData1 = [];
					$scope.tableParams1 = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						sorting: {
							invoiceNumber: 'desc'     // initial sorting
						}
					}, {
						total: $scope.invoiceStatusList ? $scope.invoiceStatusList.length : 0, // length of data
						getData: function (params) {
							$scope.fillTableData1(params);
							return $scope.tableData1;
						}
					});
					if ($scope.tableParams1.settings().$scope == null) {
						$scope.tableParams1.settings().$scope = $scope;
					}
					$scope.fillTableData1 = function (params) {
						// use build-in angular filter
						if ($scope.invoiceStatusList && $scope.invoiceStatusList.length > 0) {

							var orderedData = params.filter() ?
																$filter('filter')($scope.invoiceStatusList, params.filter()) :
																$scope.invoiceStatusList;

							orderedData = params.sorting() ?
														$filter('orderBy')(orderedData, params.orderBy()) :
														orderedData;

							$scope.tableParams1 = params;
							$scope.tableData1 = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count());

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					$scope.print = function(option) {
						dataSvc.printOption = option;
						$timeout(function() {
							$window.print();
						}, 1);
						
					}
					$scope.payrollScheduleSubTypes = [
						{ id: 0, title: 'Not Selected' }, { id: 1, title: 'Weekly-Monday' }, { id: 2, title: 'Weekly-Tuesday' }, { id: 3, title: 'Weekly-Wednesday' }, { id: 4, title: 'Weekly-Thursday' }, { id: 5, title: 'Weekly-Friday' }, { id: 6, title: 'Weekly-Saturday' }, { id: 7, title: 'Weekly-Sunday' }, { id: 8, title: 'Bi-Weekly (1)-Monday' }, { id: 9, title: 'Bi-Weekly (1)-Tuesday' }, { id: 10, title: 'Bi-Weekly (1)-Wednesday' }, { id: 11, title: 'Bi-Weekly (1)-Thursday' }, { id: 12, title: 'Bi-Weekly (1)-Friday' }, { id: 13, title: 'Bi-Weekly (1)-Saturday' }, { id: 14, title: 'Bi-Weekly (1)-Sunday' }, { id: 15, title: 'Bi-Weekly (2)-Monday' }, { id: 16, title: 'Bi-Weekly (2)-Tuesday' }, { id: 17, title: 'Bi-Weekly (2)-Wednesday' }, { id: 18, title: 'Bi-Weekly (2)-Thursday' }, { id: 19, title: 'Bi-Weekly (2)-Friday' }, { id: 20, title: 'Bi-Weekly (2)-Saturday' }, { id: 21, title: 'Bi-Weekly (2)-Sunday' }, { id: 22, title: 'Semi-Monthly' }, { id: 23, title: 'Monthly' },



					];
					$scope.zionAPI = zionAPI; 
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = false;
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;

					$scope.chartData = [];
					$scope.selectedChart = null;
					
					$scope.drawCharts = function () {

						$scope.data.criteria = '';
						$scope.selectedChart = null;
						var element = angular.element(document.querySelector('#ncDetailedCriteriaForProject'));
						element.html('');
						

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
						else if (tab === 5) {
							$scope.drawClearanceChart();
						}
						else if (tab === 6) {
							loadDocumentsData();
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

					$scope.drawClearanceChart = function () {
						var m = $scope.mainData;
						reportRepository.getDashboardData('GetCheckbookClearanceChartData', m.reportFilter.filterStartDate, m.reportFilter.filterEndDate, null, m.reportFilter.filter.onlyActive).then(function (data1) {
							dataSvc.clearanceData = data1[0];
							dataSvc.filteredClearanceData = [];
							dataSvc.filteredClearanceData.data = [];
							dataSvc.filteredClearanceData.result = dataSvc.clearanceData.result;
							$.each(dataSvc.clearanceData.data, function (ind, cd) {
								var item = [];
								item.push(cd[0]);
								item.push(cd[1]);
								dataSvc.filteredClearanceData.data.push(item);
							});
							if (dataSvc.filteredClearanceData.data.length > 0) {
								var ws_data = null;
								ws_data = mapListToDataTable(dataSvc.filteredClearanceData);
								clearIfExists('CheckbookClearanceChartData', dataSvc.filteredClearanceData.data, 'UnCleared Check counts by Company');

								var options = {
									title: 'UnCleared Checks by Company',
									vAxis: {
										title: "Company"
									},
									hAxis: {
										title: "Checks"
									},
									legend: { position: 'none' },
									
									'width': '100%',
									'height': 600,
									'chartKey': 'CheckbookClearanceChartData'
								};

								var chart = new google.visualization.ColumnChart($element.find('#clearanceChart')[0]);
								var element = angular.element(document.querySelector('#clearanceChart'));
								chart.draw(ws_data, options);
								google.visualization.events.addListener(chart, 'select', function () {
									var selection = chart.getSelection();
									var col = selection[0].column;
									var row = selection[0].row;
									var key = options.chartKey;
									var ctx = $filter('filter')($scope.chartData, { chartName: key }, true);
									var criteriatmp = dataSvc.filteredClearanceData.data[row + 1];
									var match = dataSvc.clearanceData.data[row + 1];

								});
							}

						}, function (error) {
							console.log(error);
						});

					};

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
								var criteria = ctx[0].chartData[row + 1][0];
								dataSvc.selectedStatus = criteria;
								$scope.drawInvoiceStatusPastDueChart(criteria);
								$scope.drawInvoiceStatusDetailedChart(criteria);
								$scope.getInvoiceStatusList(criteria);
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
					$scope.getInvoiceStatusList = function (status) {
						reportRepository.getInvoiceStatusList('GetInvoiceStatusList', $scope.mainData.reportFilter.filterStartDate, $scope.mainData.reportFilter.filterEndDate, status, $scope.mainData.reportFilter.filter.onlyActive).then(function (data1) {
							$scope.invoiceStatusList = data1;
							
							$scope.tableParams1.reload();
							$scope.fillTableData1($scope.tableParams1);
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
								dataSvc.viewingChart = 3;
							}

						}, function (error) {
							console.log(error);
						});
					};
					$scope.drawPayrollWithDraftInvoiceChart = function () {
						reportRepository.getDashboardData('GetPayrollsWithDraftInvoice', $scope.mainData.reportFilter.filterStartDate, $scope.mainData.reportFilter.filterEndDate, null, $scope.mainData.reportFilter.filter.onlyActive).then(function (data1) {
							var data = data1[0];
							if (data) {
								dataSvc.payrollsWithDraftInvoice = data.data;
								dataSvc.viewingChart = 4;
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
								dataSvc.viewingChart = 1;
								var d = data.data;
								$.each(d, function(ind, ap) {
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

								dataSvc.viewingChart = 1;

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

								dataSvc.viewingChart = 2;
								dataSvc.filteredApproachingPayrolls = angular.copy(filtered);
								$scope.tableParams.reload();
								$scope.fillTableData($scope.tableParams);

							}

						}, function (error) {
							console.log(error);
						});
						
					};
					$scope.selectedSchedules = [];
				
					$scope.drawCompanyScheduleChart = function () {
						var result = [];
						var criteria = null;
						if ($scope.selectedSchedules.length > 0) {
							criteria = '';
							$.each($scope.selectedSchedules, function(index, i) {
								criteria += i.id;
								result.push({
									schedule: i.id,
									scheduleText: getReportingDayText(i.id),
									minimized: false,
									data: []
								});
								if (index < $scope.selectedSchedules.length - 1)
									criteria += ',';
							});
						} 
						
						
						reportRepository.getDashboardData('GetCompanyPayrollSchedules', null, null, criteria, $scope.mainData.reportFilter.filter.onlyActive).then(function (data1) {
							var data = data1[0];
							if (data) {
								dataSvc.approachingPayrolls = data.data;
								
								$.each(data.data, function (ind, ap) {
									if (ind > 0) {
										var contactJson = ap[6] ? JSON.parse(ap[6]) : '';
										var item = {
											hostId: ap[0],
											companyId: ap[1],
											host: ap[2],
											company: ap[3],
											reportingDay: ap[4],
											reportingDayText: getReportingDayText(ap[4]),
											dashboardNotes: ap[5],
											contactName: contactJson ? contactJson.FirstName + ' ' + contactJson.LastName : '',
											contactNumber: contactJson ? (contactJson.Phone ? $scope.getPhone(contactJson.Phone) : $scope.getPhone(contactJson.Mobile)) : ''
										};
										var resultset = $filter('filter')(result, { schedule: ap[4] })[0];
										if(resultset)
											resultset.data.push(item);
										else {
											var j = {
												schedule: ap[4],
												scheduleText: getReportingDayText(ap[4]),
												minimized: false,
												data: []
											};
											j.data.push(item);
											result.push(j);
										}
									}

								});

								dataSvc.viewingChart = 5;
								dataSvc.companySchedules = angular.copy(result);
								

							}

						}, function (error) {
							console.log(error);
						});

					};
					var getScheduleText = function(schedule) {
						if (schedule === 1)
							return 'Weekly';
						else
							return 'Bi-Weekly';
					}
					var getReportingDayText = function (day) {
						return $filter('filter')($scope.payrollScheduleSubTypes, { id: day })[0].title;
						
					}
					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						sorting: {
							due: 'asc'     // initial sorting
						}
					},
						
						{
							
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

					$scope.tableDataCompanySchedule = [];
					$scope.tableParamsCompanySchedules = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						sorting: {
							due: 'asc'     // initial sorting
						}
					}, {
						total: dataSvc.companySchedules ? data.companySchedules.length : 0, // length of data
						getData: function (params) {
							$scope.fillTableDataSchedules(params);
							return $scope.tableDataCompanySchedule;
						}
					});
					if ($scope.tableParamsCompanySchedules.settings().$scope == null) {
						$scope.tableParamsCompanySchedules.settings().$scope = $scope;
					}
					$scope.fillTableDataSchedules = function (params) {

						// use build-in angular filter
						if (dataSvc.companySchedules && dataSvc.companySchedules.length > 0) {
							var orderedData = params.filter() ?
																$filter('filter')(dataSvc.companySchedules, params.filter()) :
																dataSvc.companySchedules;

							orderedData = params.sorting() ?
														$filter('orderBy')(orderedData, params.orderBy()) :
														orderedData;

							$scope.tableParamsCompanySchedules = params;
							$scope.tableDataCompanySchedule = orderedData;

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					$scope.getPhone = function (p) {
						
						if (p)
							return '(' + p.substring(0, 3) + ') ' + p.substring(3, 6) + '-' + p.substring(6, 12);
						else {
							return '';
						}
					}
					

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
					var loadDocumentsData = function () {
						reportRepository.getStaffDashboardDocuments($scope.mainData.userRole === 'Host' || $scope.mainData.userRole === 'HostStaff' ? $scope.mainData.userHost : null).then(function (data) {
							
							$scope.listEmployeeAccess = data.employeeDocumentAccesses;
							$scope.listEmployeeDocuments = data.employeeDocumentRequirements;
							refillTables();
						}, function (erorr) {

						});
						
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
