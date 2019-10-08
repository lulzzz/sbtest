﻿'use strict';

common.directive('employeeDashboard', ['zionAPI', '$timeout', '$window', 'version', '$sce',
	function (zionAPI, $timeout, $window, version, $sce) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: $sce.trustAsResourceUrl(zionAPI.Web + 'Areas/Reports/templates/employee-dashboard.html?v=' + version),

			controller: ['$scope', '$element', '$location', '$filter', 'reportRepository','$anchorScroll', 'ClaimTypes',
				function ($scope, $element, $location, $filter, reportRepository, $anchorScroll, ClaimTypes) {
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
						filteredPendingExtracts: []

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
    	redLight = '#ff5b57', blackLight = '#2d353c', black='#000';

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

					var handlePayrollDonutChart = function () {
						$("#extract-donut").empty();
						
						Morris.Donut({
							element: 'payroll-donut',
							data: [
									{ label: "Net Wage", value: dataSvc.dashboard.ytdPayroll.netWage },
									{ label: "Taxes", value: dataSvc.dashboard.ytdPayroll.employeeTaxes },
									{ label: "Deductions", value: dataSvc.dashboard.ytdPayroll.deductions }
							],
							colors: [blue, purple, red],
							labelFamily: 'Open Sans',
							labelColor: 'rgba(255,255,255,0.4)',
							labelTextSize: '12px',
							backgroundColor: '#242a30'
						});
					};
					

					function _init() {
						
						//handleInteractiveChart();
						//handleDashboardSparkline();
						//handleDonutChart();
						
						
						reportRepository.getEmployeeDashboard($scope.mainData.userCompany, $scope.mainData.userEmployee).then(function (data) {
								dataSvc.dashboard = data;
								$timeout(function () {
									var payrolls = $filter('orderBy')(dataSvc.dashboard.payrollHistory, 'dRank', true);
									handlePayrollChart(payrolls, 'payrolls');
									handlePayrollDonutChart();
								});
								//
							}, function (erorr) {

							});


					};

					_init();
					

				}]
		}
	}
]);