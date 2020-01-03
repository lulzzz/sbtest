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
					var _init = function() {
						$scope.callback();
					}
					if (!$scope.defaultsProvided) {
						dataSvc.filterStartDate = moment('01/01/' + dataSvc.filter.year).format('MM/DD/YYYY');
						dataSvc.filterEndDate = moment(dataSvc.filterStartDate).endOf('year').format('MM/DD/YYYY');
					}
					dataSvc.filter.includeHistory = false;
					dataSvc.filter.includeClients = false;
					dataSvc.filter.includeClientEmployees = false;
					dataSvc.filter.includeTaxDelayed = false;
					_init();
				}]
		}
	}
]);
