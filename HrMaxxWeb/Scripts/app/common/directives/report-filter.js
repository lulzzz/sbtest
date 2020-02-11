'use strict';

common.directive('reportFilter', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				filter: "=filter",
				callback: "&",
				showDates: "=?showDates",
				showPeriods: "=?showPeriods",
				defaultsProvided: "=?defaultsProvided",
				showHistory: "=?showHistory",
				showIncludeClients: "=?showIncludeClients",
				showIncludeClientEmployees: "=?showIncludeClientEmployees",
				showIncludeTaxDelayed: "=?showIncludeTaxDelayed",
				showActive: "=?showActive"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/report-filter.html?v=' + version,

			controller: ['$scope', 
				function ($scope) {
					var dataSvc = $scope.filter;
					var currentYear = new Date().getFullYear();
					dataSvc.filter.year = currentYear;
					if (dataSvc.filter.years.length === 0) {
						for (var i = currentYear; i >= currentYear - 4; i--) {
							dataSvc.filter.years.push(i);
						}
					}
					
					
					$scope.dt = new Date();

					$scope.data = dataSvc;
					//$scope.filter = $scope.data;

					$scope.applyFilter = function () {
						dataSvc.filterStartDate = dataSvc.filter.startDate ? moment(dataSvc.filter.startDate).format("MM/DD/YYYY") : moment('01/01/' + dataSvc.filter.year).format('MM/DD/YYYY');
						dataSvc.filterEndDate = dataSvc.filter.endDate ? moment(dataSvc.filter.endDate).format("MM/DD/YYYY") : moment().format("MM/DD/YYYY");
						dataSvc.filter.filterByMonthYear = false;
						dataSvc.filter.filterByPeriod = false;
						$scope.callback();
					}
					$scope.filterByDateRange = function () {
						dataSvc.filter.quarter = 0;
						dataSvc.filter.month = 0;
						dataSvc.filterStartDate = dataSvc.filter.startDate ? moment(dataSvc.filter.startDate).format("MM/DD/YYYY") : moment('01/01/' + dataSvc.filter.year).format('MM/DD/YYYY');
						dataSvc.filterEndDate = dataSvc.filter.endDate ? moment(dataSvc.filter.endDate).format("MM/DD/YYYY") : moment().format("MM/DD/YYYY");
						dataSvc.filter.filterByMonthYear = false;
						dataSvc.filter.filterByPeriod = false;
						_init();
					}
					$scope.filterByMonthYear = function () {
						
						if (!dataSvc.filter.month && !dataSvc.filter.quarter) {
							dataSvc.filterStartDate = moment('01/01/' + dataSvc.filter.year).format('MM/DD/YYYY');
							dataSvc.filterEndDate = moment(dataSvc.filterStartDate).endOf('year').format('MM/DD/YYYY');
						}
						else if (dataSvc.filter.quarter) {
							dataSvc.filterStartDate = moment(quarterStartMonth(dataSvc.filter.quarter) + '/01/' + dataSvc.filter.year).format('MM/DD/YYYY');
							var lastmonth = moment(dataSvc.filter.quarter*3 + '/01/' + dataSvc.filter.year).format('MM/DD/YYYY');
							dataSvc.filterEndDate = moment(lastmonth).endOf('month').format('MM/DD/YYYY');
						}
						else {
							dataSvc.filterStartDate = moment(dataSvc.filter.month + '/01/' + dataSvc.filter.year).format('MM/DD/YYYY');
							
							dataSvc.filterEndDate = moment(dataSvc.filterStartDate).endOf('month').format('MM/DD/YYYY');
						}

						dataSvc.filter.filterByDateRange = false;
						dataSvc.filter.filterByPeriod = false;
						_init();
					}
					var quarterStartMonth = function(quarter) {
						if (quarter === 1)
							return 1;
						else if (quarter === 2)
							return 4;
						else if (quarter === 3)
							return 7;
						else 
							return 10;
					}
					
					$scope.filterByPeriod = function () {
						dataSvc.filter.quarter = 0;
						dataSvc.filter.month = 0;
						if (dataSvc.filter.period === 1) {
							dataSvc.filterStartDate = null;
							dataSvc.filterEndDate = null;
						} else if (dataSvc.filter.period === 2) {
							dataSvc.filterEndDate = new Date();
							dataSvc.filterStartDate = moment(dataSvc.filterEndDate).add(-3, 'months').format('MM/DD/YYYY');
						} else if (dataSvc.filter.period === 3) {
							dataSvc.filterEndDate = new Date();
							dataSvc.filterStartDate = moment(dataSvc.filterEndDate).add(-6, 'months').format('MM/DD/YYYY');
						} else if (dataSvc.filter.period === 4) {
							dataSvc.filterEndDate = new Date();
							dataSvc.filterStartDate = moment(dataSvc.filterEndDate).add(-1, 'years').format('MM/DD/YYYY');
						}

						dataSvc.filter.filterByMonthYear = false;
						dataSvc.filter.filterByDateRange = false;
						_init();
					}
					var _init = function () {
						handleDateRangeFilter();
						$scope.callback();

					}
					if (!$scope.defaultsProvided) {
						dataSvc.filterStartDate = moment('01/01/' + dataSvc.filter.year).format('MM/DD/YYYY');
						dataSvc.filterEndDate = moment(dataSvc.filterStartDate).endOf('year').format('MM/DD/YYYY');
					}
					if (!dataSvc.filterEndDate) {
						dataSvc.filterEndDate = moment().format('MM/DD/YYYY');
					}
					dataSvc.filter.includeHistory = false;
					dataSvc.filter.includeClients = false;
					dataSvc.filter.includeClientEmployees = false;
					dataSvc.filter.includeTaxDelayed = false;
					var handleDateRangeFilter = function () {
						$('#daterange-filter span').html(moment(dataSvc.filterStartDate).format('D MMMM YYYY') + ' - ' + moment(dataSvc.filterEndDate).format('D MMMM YYYY'));
						
						$('#daterange-filter').daterangepicker({
							format: 'MM/DD/YYYY',
							startDate: dataSvc.filterStartDate,
							endDate: dataSvc.filterEndDate,
							maxDate: moment(),
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
							$('#daterange-filter span').html(start.format('D MMMM YYYY') + ' - ' + end.format('D MMMM YYYY'));
								dataSvc.filter.startDate = start;
								dataSvc.filter.endDate = end;
						});
					};
					_init();
				}]
		}
	}
]);
