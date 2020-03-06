'use strict';

common.directive('staffDashboard', ['zionAPI', '$timeout', '$window', 'version', '$sce',
	function (zionAPI, $timeout, $window, version, $sce) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: $sce.trustAsResourceUrl(zionAPI.Web + 'Areas/Reports/templates/staff-dashboard.html?v=' + version),

			controller: ['$scope', '$element', '$location', '$filter', 'reportRepository','$anchorScroll', 'ClaimTypes',
				function ($scope, $element, $location, $filter, reportRepository, $anchorScroll, ClaimTypes) {
					var dataSvc = {
						dashboard: null
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

						return month[x.getMonth()] + '-' + x.getYear();
					};

					$scope.getColor = function(ind) {
						return dataSvc.colors[ind];
					}

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

				
					$scope.loadData = function() {
						reportRepository.getStaffDashboard($scope.mainData.userRole==='Host' || $scope.mainData.userRole==='HostStaff'  ? $scope.mainData.userHost : null).then(function (data) {
							dataSvc.dashboard = data;
							dataSvc.isDataLoaded = true;
							$timeout(function() {
								handleDonutChart(dataSvc.dashboard.payrollsProcessedChart.items, 'processed-donut');
								handleDonutChart(dataSvc.dashboard.payrollsVoidedChart.items, 'voided-donut');
								//handleDonutChart(dataSvc.dashboard.invoicesCreatedChart.items, 'created-donut');
								handleDonutChart(dataSvc.dashboard.invoicesDeliveredChart.items, 'delivered-donut');
								handleDonutChart(dataSvc.dashboard.companiesUpdatedChart.items, 'companies-donut');
								$timeout(function () {
									$('#jstree-default2').jstree({
										"core": {
											"themes": {
												"responsive": false
											}
										},
										"types": {
											"default": {
												"icon": "fa fa-folder text-warning fa-lg"
											},
											"file": {
												"icon": "fa fa-file text-inverse fa-lg"
											}
										},
										"plugins": ["types"]
									});
								});
							});
						}, function (erorr) {

						});
					}

					function _init() {
						$scope.loadData();
					};

					_init();
					

				}]
		}
	}
]);
