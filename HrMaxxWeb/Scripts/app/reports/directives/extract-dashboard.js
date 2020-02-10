'use strict';

common.directive('extractDashboard', ['zionAPI', '$timeout', '$window', 'version', '$sce',
	function (zionAPI, $timeout, $window, version, $sce) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: $sce.trustAsResourceUrl(zionAPI.Web + 'Areas/Reports/templates/extract-dashboard.html?v=' + version),

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
						filteredPendingExtracts: [],
						filteredPendingExtractsByDate: [],
						filteredPendingExtractsByCompany: [],
						filteredPendingExtractsBySchedule: [],
						filteredDelayedExtractsBySchedule: [],
						isDataLoaded: false

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

						return month[x.getMonth()] + '-' + x.getFullYear().toString().substr(2, 2);
					};

					
				
					var handleExtractChart = function (data, element, label, lineColor, lineColorLigth) {
						$("#" + element).empty();
						
						var blackTransparent = 'rgba(0,0,0,0.6)';
						var whiteTransparent = 'rgba(255,255,255,0.4)';
						if (data.length > 0) {
							Morris.Line({
								element: element,
								data: data,
								xkey: 'depositDate',
								ykeys: ['amount'],
								xLabelFormat: function (x) {
									x = getMonthName(x);
									return x.toString();
								},
								labels: [label],
								lineColors: [lineColor],
								pointFillColors: [lineColorLigth],
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
						}
						
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
					$scope.changePanel = function (panel) {
						if (dataSvc.viewpanel !== panel) {
							dataSvc.viewpanel = panel;
							$timeout(function () {
								if (panel === 2) {
									
								}
								if (panel === 3) {
									
								}
								
								
								
							});
						}
						
					}
					$scope.showChart = function (extract) {
						dataSvc.showChart = true;
						dataSvc.chartShown = 0;
						dataSvc.viewpanel = 0;
						dataSvc.extractType = extract;
						
						$timeout(function () {
							
							var color = 'black';
							if (extract === 1) {
								dataSvc.filteredExtracts = $filter('filter')(dataSvc.dashboard.extractHistory, { extractName: 'Federal941' });
								dataSvc.filteredPendingExtracts = $filter('filter')(dataSvc.dashboard.pendingExtracts, { extractName: 'Federal941' });
								//dataSvc.filteredPendingExtractsByDate = $filter('filter')(dataSvc.dashboard.pendingExtractsByDates, { extractName: 'Federal941' });
								//dataSvc.filteredPendingExtractsByCompany = $filter('filter')(dataSvc.dashboard.pendingExtractsByCompany, { extractName: 'Federal941' });
								dataSvc.filteredPendingExtractsBySchedule = $filter('filter')(dataSvc.dashboard.pendingExtractsBySchedule, { extractName: 'Federal941' });
								dataSvc.filteredDelayedExtractsBySchedule = $filter('filter')(dataSvc.dashboard.delayedExtractsBySchedule, { extractName: 'Federal941' });
								//$.each(dataSvc.dashboard.pendingExtractsByScheduleCopy, function (i, pe) {
								//	pe.details = $filter('filter')(pe.details, { extractName: 'Federal941' });
								//	if (pe.details.length > 0)
								//		dataSvc.filteredPendingExtractsBySchedule.push(pe);
								//});

								color = '0D888B';
								dataSvc.chartTitle = 'Federal 941 Extract History';
								dataSvc.donutPaid = dataSvc.dashboard.ytd941Extract;
								dataSvc.donutPending = dataSvc.dashboard.pending941Amount;

							}
							else if (extract === 2) {
								dataSvc.chartTitle = 'Federal 940 Extract History';
								dataSvc.filteredExtracts = $filter('filter')(dataSvc.dashboard.extractHistory, { extractName: 'Federal940' });
								dataSvc.filteredPendingExtracts = $filter('filter')(dataSvc.dashboard.pendingExtracts, { extractName: 'Federal940' });
								//dataSvc.filteredPendingExtractsByDate = $filter('filter')(dataSvc.dashboard.pendingExtractsByDates, { extractName: 'Federal940' });
								//dataSvc.filteredPendingExtractsByCompany = $filter('filter')(dataSvc.dashboard.pendingExtractsByCompany, { extractName: 'Federal940' });
								dataSvc.filteredPendingExtractsBySchedule = $filter('filter')(dataSvc.dashboard.pendingExtractsBySchedule, { extractName: 'Federal940' });
								dataSvc.filteredDelayedExtractsBySchedule = $filter('filter')(dataSvc.dashboard.delayedExtractsBySchedule, { extractName: 'Federal940' });
								//$.each(dataSvc.dashboard.pendingExtractsBySchedule, function (i, pe) {
								//	pe.details = $filter('filter')(pe.details, { extractName: 'Federal940' });
								//	if (pe.details.length > 0)
								//		dataSvc.filteredPendingExtractsBySchedule.push(pe);
								//});
								dataSvc.donutPaid = dataSvc.dashboard.ytd940Extract;
								dataSvc.donutPending = dataSvc.dashboard.pending940Amount;
							}
							else if (extract === 3) {
								dataSvc.chartTitle = 'CA PIT & DI Extract History';
								dataSvc.filteredExtracts = $filter('filter')(dataSvc.dashboard.extractHistory, { extractName: 'StateCAPIT' });
								dataSvc.filteredPendingExtracts = $filter('filter')(dataSvc.dashboard.pendingExtracts, { extractName: 'StateCAPIT' });
								//dataSvc.filteredPendingExtractsByDate = $filter('filter')(dataSvc.dashboard.pendingExtractsByDates, { extractName: 'StateCAPIT' });
								//dataSvc.filteredPendingExtractsByCompany = $filter('filter')(dataSvc.dashboard.pendingExtractsByCompany, { extractName: 'StateCAPIT' });
								dataSvc.filteredPendingExtractsBySchedule = $filter('filter')(dataSvc.dashboard.pendingExtractsBySchedule, { extractName: 'StateCAPIT' });
								dataSvc.filteredDelayedExtractsBySchedule = $filter('filter')(dataSvc.dashboard.delayedExtractsBySchedule, { extractName: 'StateCAPIT' });
								//$.each(dataSvc.dashboard.pendingExtractsBySchedule, function (i, pe) {
								//	pe.details = $filter('filter')(pe.details, { extractName: 'StateCAPIT' });
								//	if (pe.details.length > 0)
								//		dataSvc.filteredPendingExtractsBySchedule.push(pe);
								//});
								dataSvc.donutPaid = dataSvc.dashboard.ytdCAPITExtract;
								dataSvc.donutPending = dataSvc.dashboard.pendingPitAmount;
							}
							else {
								dataSvc.chartTitle = 'CA UI & ETT Extract History';
								dataSvc.filteredExtracts = $filter('filter')(dataSvc.dashboard.extractHistory, { extractName: 'StateCAUI' });
								dataSvc.filteredPendingExtracts = $filter('filter')(dataSvc.dashboard.pendingExtracts, { extractName: 'StateCAUI' });
								//dataSvc.filteredPendingExtractsByDate = $filter('filter')(dataSvc.dashboard.pendingExtractsByDates, { extractName: 'StateCAUI' });
								//dataSvc.filteredPendingExtractsByCompany = $filter('filter')(dataSvc.dashboard.pendingExtractsByCompany, { extractName: 'StateCAUI' });
								dataSvc.filteredPendingExtractsBySchedule = $filter('filter')(dataSvc.dashboard.pendingExtractsBySchedule, { extractName: 'StateCAUI' });
								dataSvc.filteredDelayedExtractsBySchedule = $filter('filter')(dataSvc.dashboard.delayedExtractsBySchedule, { extractName: 'StateCAUI' });
								//$.each(dataSvc.dashboard.pendingExtractsBySchedule, function (i, pe) {
								//	pe.details = $filter('filter')(pe.details, { extractName: 'StateCAUI' });
								//	if (pe.details.length > 0)
								//		dataSvc.filteredPendingExtractsBySchedule.push(pe);
								//});
								dataSvc.donutPaid = dataSvc.dashboard.ytdCAUIETTExtract;
								dataSvc.donutPending = dataSvc.dashboard.pendingUiEttAmount;
							}
							dataSvc.donutChartTotal = dataSvc.donutPaid + dataSvc.donutPending;
							dataSvc.donutPaidPercentage = (dataSvc.donutPaid / dataSvc.donutChartTotal) * 100;
							dataSvc.donutPendingPercentage = (dataSvc.donutPending / dataSvc.donutChartTotal) * 100;
							dataSvc.filteredExtracts = $filter('orderBy')(dataSvc.filteredExtracts, 'dRank', true);
							dataSvc.filteredPendingExtracts = $filter('orderBy')(dataSvc.filteredPendingExtracts, 'depositDate', true);
							dataSvc.filteredPendingExtractsByDate = $filter('orderBy')(dataSvc.filteredPendingExtractsByDate, 'depositDate', false);
							handleExtractChart(dataSvc.filteredExtracts, 'extract-paid', 'Tax Paid',green, greenLight);
							handleExtractChart(dataSvc.filteredPendingExtracts, 'extract-pending', 'Tax Pending', redLight, red);
							handleExtractDonutChart();
							dataSvc.chartShown = extract;
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
								$('#jstree-default2').on('select_node.jstree', function (e, data) {
									var link = $('#' + data.selected).find('a');
									if (link.attr("href") != "#" && link.attr("href") != "javascript:;" && link.attr("href") != "") {
										if (link.attr("target") == "_blank") {
											link.attr("href").target = "_blank";
										}
										document.location.href = link.attr("href");
										return false;
									}
								});
								$('#jstree-default2').jstree('refresh');
								$('#jstree-default').jstree({
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
								$('#jstree-default').on('select_node.jstree', function (e, data) {
									var link = $('#' + data.selected).find('a');
									if (link.attr("href") != "#" && link.attr("href") != "javascript:;" && link.attr("href") != "") {
										if (link.attr("target") == "_blank") {
											link.attr("href").target = "_blank";
										}
										document.location.href = link.attr("href");
										return false;
									}
								});
								$('#jstree-default').jstree('refresh');
							});
						});
						


					}
					
					$scope.loadData = function() {
						reportRepository.getExtractDashboard().then(function (data) {
							dataSvc.dashboard = data;
							dataSvc.isDataLoaded = true;
						}, function (erorr) {

						});
					}

					function _init() {
					
						
						


					};

					_init();
					

				}]
		}
	}
]);
