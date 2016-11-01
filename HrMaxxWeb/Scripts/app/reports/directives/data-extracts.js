'use strict';
common.directive('extractReports', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/data-extracts.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'payrollRepository', 'reportRepository',
				function ($scope, $element, $location, $filter, payrollRepository, reportRepository) {
					var dataSvc = {

						isBodyOpen: true,
						response: null,
						minYear: 2016,
						filter: {
							years: []
						},
						filter940: {
							year : 0
						},
						
						filterW2: {
							year : 0
						},
						filter940Q: {
							year: 0,
							quarter: 0,
							depositDate: moment().startOf('day').toDate()
						},
						filter941S: {
							year: 0,
							payPeriods: [],
							payPeriod: null,
							depositDate: moment().startOf('day').toDate()
						},
						filter941M: {
							year: 0,
							month: 0,
							depositDate: moment().startOf('day').toDate()
						},
						filter941Q: {
							year: 0,
							quarter: 0,
							depositDate: moment().startOf('day').toDate()
						},
						filter1099: {
							year : 0
						},
						filter941: {
							year: 0,
							quarter: 0
						},
						filterde7: {
							year: 0,
							quarter: 0
						},
						filterde6: {
							year: 0,
							quarter: 0
						},
						filterde9: {
							year: 0,
							quarter: 0
						}
					}
					$scope.minDepositDate = moment().startOf('day').toDate();
					var currentYear = new Date().getFullYear();
					for (var i = currentYear - 4; i <= currentYear; i++) {
						if(i >= dataSvc.minYear)
							dataSvc.filter.years.push(i);
					}
					

					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = false;
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;

					$scope.fill941PayPeriods = function () {
						dataSvc.filter941S.payPeriods = [];
						var startDate = moment("01-01-" + dataSvc.filter941S.year, "MM-DD-YYYY");
						var endDate = moment("12-31-" + dataSvc.filter941S.year, "MM-DD-YYYY");
						var currDate = startDate.clone().startOf('day');
						var lastDate = endDate.clone().startOf('day');
						var startingQuarter = 0;
						var dayofquarter = 0;
						if (!dataSvc.filter941S.year)
							return;

						while (currDate.diff(lastDate) <= 0) {
							var quarter = Math.floor((currDate.month() + 3) / 3);
							if (quarter !== startingQuarter) {
								dayofquarter = 1;
								startingQuarter = quarter;
							}
							if (currDate.format("dddd") === 'Wednesday' || currDate.format("dddd") === 'Friday') {
								
								if (dayofquarter === 2) {
									if (quarter === 1) {
										dataSvc.filter941S.payPeriods.push({
											key: currDate.format("MM/DD/YYYY"),
											val: currDate.format("ddd, MMMM DD, YY") + "-4th Q"
										});
										dataSvc.filter941S.payPeriods.push({
											key: currDate.format("MM/DD/YYYY"),
											val: currDate.format("ddd, MMMM DD, YY") + "-1st Q"
										});


									} else if (quarter === 2) {
										dataSvc.filter941S.payPeriods.push({
											key: currDate.format("MM/DD/YYYY"),
											val: currDate.format("ddd, MMMM DD, YY") + "-1st Q"
										});
										dataSvc.filter941S.payPeriods.push({
											key: currDate.format("MM/DD/YYYY"),
											val: currDate.format("ddd, MMMM DD, YY") + "-2nd Q"
										});
									} else if (quarter === 3) {
										dataSvc.filter941S.payPeriods.push({
											key: currDate.format("MM/DD/YYYY"),
											val: currDate.format("ddd, MMMM DD, YY") + "-2nd Q"
										});
										dataSvc.filter941S.payPeriods.push({
											key: currDate.format("MM/DD/YYYY"),
											val: currDate.format("ddd, MMMM DD, YY") + "-3rd Q"
										});
									} else if (quarter === 4) {
										dataSvc.filter941S.payPeriods.push({
											key: currDate.format("MM/DD/YYYY"),
											val: currDate.format("ddd, MMMM DD, YY") + "-3rd Q"
										});
										dataSvc.filter941S.payPeriods.push({
											key: currDate.format("MM/DD/YYYY"),
											val: currDate.format("ddd, MMMM DD, YY") + "-4th Q"
										});
									}


								} else {
									dataSvc.filter941S.payPeriods.push({
										key: currDate.format("MM/DD/YYYY"),
										val: currDate.format("ddd, MMMM DD, YY")
									});
								}
								dayofquarter++;
								
							}
							
							currDate = currDate.add('days', 1);
						}
					}
					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};

					$scope.getReport940 = function() {
						getReport('Paperless940', 'Paperless 940', dataSvc.filter940.year, null, null, null, null);
					}
					$scope.getReport941 = function () {
						getReport('Paperless941', 'Paperless 941', dataSvc.filter941.year, dataSvc.filter941.quarter, null, null, null);
					}
					
					$scope.getReportW2Employee = function () {
						getReport('SSAW2Magnetic', 'Federal SSA W2 Magnetic File', dataSvc.filterW2.year, null, null, null, null);
					}
					
					$scope.getReport940Q = function () {
						getReport('FederalQuarterly940', 'Federal Quarterly 940 EFTPS File', dataSvc.filter940Q.year, dataSvc.filter940Q.quarter, null, dataSvc.filter940Q.depositDate, null);
					}
					$scope.getReport941S = function () {
						getReport('Federal941', 'Federal Semi-Weekly 941 EFTPS File', dataSvc.filter941S.year, null, 1, dataSvc.filter941S.depositDate, null);
					}
					$scope.getReport941M = function () {
						getReport('Federal941', 'Federal Monthly 941 EFTPS File', dataSvc.filter941M.year, null, 2, dataSvc.filter941M.depositDate, dataSvc.filter941M.month);
					}
					$scope.getReport941Q = function () {
						getReport('Federal941', 'Federal Quarterly 941 EFTPS File', dataSvc.filter941Q.year, dataSvc.filter941Q.quarter, 3, dataSvc.filter941Q.depositDate, null);
					}
					$scope.getReport1099 = function () {
						getReport('Report1099', '1099', dataSvc.filter1099.year, null);
					}
					$scope.getReportDE6 = function () {
						getReport('CaliforniaDE6', 'California DE 6', dataSvc.filterde6.year, dataSvc.filterde6.quarter);
					}
					$scope.getReportDE7 = function () {
						getReport('CaliforniaDE7', 'California DE 7', dataSvc.filterde7.year, null);
					}
					$scope.getReportDE9 = function () {
						getReport('CaliforniaDE9', 'California DE 9', dataSvc.filterde9.year, dataSvc.filterde9.quarter);
						getReport('CaliforniaDE9C', 'California DE 9C', dataSvc.filterde9.year, dataSvc.filterde9.quarter);
					}

					var getReport = function(reportName, desc, year, quarter, depositSchedule, depositDate, month) {
						var m = $scope.mainData;
						var request = {
							reportName: reportName,
							year: year,
							quarter: quarter,
							month: month,
							startDate:null,
							endDate: null,
							depositSchedule: depositSchedule,
							depositDate: depositDate ? moment(depositDate).format("MM/DD/YYYY") : null
						}
						reportRepository.getExtractDocument(request).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();

						}, function (erorr) {
							addAlert('Error getting report ' + desc + ': ' + erorr, 'danger');
						});
					}
					$scope.hasCalifornia = function() {
						var comp = $scope.mainData.selectedCompany;
						if (comp) {
							var cal = $filter('filter')(comp.states, { state : { stateId: 1 } })[0];
							if (cal)
								return true;
							else
								return false;
						} else {
							return false;
						}
					}
					

			}]
		}
	}
]);
