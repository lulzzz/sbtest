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
						filterCAUIQ: {
							year: 0,
							quarter: 0,
							depositDate: moment().startOf('day').toDate()
						},
						filter941: {
							year: 0,
							payPeriods: [],
							payPeriod: null,
							depositSchedule: null,
							month: null,
							quarter: null,
							depositDate: moment().startOf('day').toDate()
						},
						filterCAPIT: {
							year: 0,
							payPeriods: [],
							payPeriod: null,
							depositSchedule: null,
							month: null,
							quarter: null,
							depositDate: moment().startOf('day').toDate()
						},
						filter1099: {
							year : 0
						},
						
						filterDE6Q: {
							year: 0,
							quarter: 0
						}
					}
					$scope.is941Valid = function() {
						if (!dataSvc.filter941.year || !dataSvc.filter941.depositSchedule || !dataSvc.filter941.depositDate)
							return false;
						else {
							if (dataSvc.filter941.depositSchedule === 1) {
								dataSvc.filter941.month = null;
								dataSvc.filter941.quarter = null;
								if (!dataSvc.filter941.payPeriod)
									return false;
								else
									return true;
							}
							else if (dataSvc.filter941.depositSchedule === 2) {
								dataSvc.filter941.payPeriod = null;
								dataSvc.filter941.quarter = null;
								if (!dataSvc.filter941.month)
									return false;
								else {
									return true;
								}
							} else {
								dataSvc.filter941.month = null;
								dataSvc.filter941.payPeriod = null;
								if (!dataSvc.filter941.quarter)
									return false;
								else
									return true;
							}

						}
					}

					$scope.isCAPITValid = function () {
						if (!dataSvc.filterCAPIT.year || !dataSvc.filterCAPIT.depositSchedule || !dataSvc.filterCAPIT.depositDate)
							return false;
						else {
							if (dataSvc.filterCAPIT.depositSchedule === 1) {
								dataSvc.filterCAPIT.month = null;
								dataSvc.filterCAPIT.quarter = null;
								if (!dataSvc.filterCAPIT.payPeriod)
									return false;
								else
									return true;
							}
							else if (dataSvc.filterCAPIT.depositSchedule === 2) {
								dataSvc.filterCAPIT.payPeriod = null;
								dataSvc.filterCAPIT.quarter = null;
								if (!dataSvc.filterCAPIT.month)
									return false;
								else {
									return true;
								}
							} else {
								dataSvc.filterCAPIT.month = null;
								dataSvc.filterCAPIT.payPeriod = null;
								if (!dataSvc.filterCAPIT.quarter)
									return false;
								else
									return true;
							}

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
						if (dataSvc.filter941.depositSchedule === 1) {
							dataSvc.filter941.payPeriods = fillPayPeriods(dataSvc.filter941.year);
						}
					}
					$scope.fillCAPITPayPeriods = function () {
						dataSvc.filterCAPIT.payPeriods = fillPayPeriods(dataSvc.filterCAPIT.year);
					}

					var fillPayPeriods = function (year) {
						var payPeriods = [];
						var startDate = moment("01-01-" + year, "MM-DD-YYYY");
						var endDate = moment("12-31-" + year, "MM-DD-YYYY");
						var currDate = startDate.clone().startOf('day');
						var lastDate = endDate.clone().startOf('day');
						var startingQuarter = 0;
						var dayofquarter = 0;
						if (!year)
							return;

						while (currDate.diff(lastDate) <= 0) {
							var quarter = Math.floor((currDate.month() + 3) / 3);
							if (quarter !== startingQuarter) {
								dayofquarter = 1;
								startingQuarter = quarter;
							}
							if (currDate.format("dddd") === 'Wednesday' || currDate.format("dddd") === 'Friday') {
								var startDate1 = null;
								var endDate1 = null;
								if (currDate.format("ddd") === 'Wed') {
									startDate1 = moment(currDate).add('days', -7);
									endDate1 = moment(currDate).add('days', -5);
								}
								else  {
									startDate1 = moment(currDate).add('days', -6);
									endDate1 = moment(currDate).add('days', -3);
								}

								if (dayofquarter === 2) {
									if (quarter === 1) {
										payPeriods.push({
											key: currDate.format("MM/DD/YYYY"),
											val: currDate.format("ddd, MMMM DD, YY") + "-4th Q",
											startDate: startDate1.format("MM/DD/YYYY"),
											endDate: moment(startDate1.format("MM") + "-" + startDate1.daysInMonth() + "-" + startDate1.year(), "MM-DD-YYYY").format("MM/DD/YYYY")
										});
										payPeriods.push({
											key: currDate.format("MM/DD/YYYY"),
											val: currDate.format("ddd, MMMM DD, YY") + "-1st Q",
											startDate: moment(endDate1.format("MM") + "-01-" + endDate1.year(), "MM-DD-YYYY").format("MM/DD/YYYY"),
											endDate: endDate1.format("MM/DD/YYYY")
										});


									} else if (quarter === 2) {
										payPeriods.push({
											key: currDate.format("MM/DD/YYYY"),
											val: currDate.format("ddd, MMMM DD, YY") + "-1st Q",
											startDate: startDate1.format("MM/DD/YYYY"),
											endDate: moment(startDate1.format("MM") + "-" + startDate1.daysInMonth() + "-" + startDate1.year(), "MM-DD-YYYY").format("MM/DD/YYYY")
										});
										payPeriods.push({
											key: currDate.format("MM/DD/YYYY"),
											val: currDate.format("ddd, MMMM DD, YY") + "-2nd Q",
											startDate: moment(endDate1.format("MM") + "-01-" + endDate1.year(), "MM-DD-YYYY").format("MM/DD/YYYY"),
											endDate: endDate1.format("MM/DD/YYYY")
										});
									} else if (quarter === 3) {
										payPeriods.push({
											key: currDate.format("MM/DD/YYYY"),
											val: currDate.format("ddd, MMMM DD, YY") + "-2nd Q",
											startDate: startDate1.format("MM/DD/YYYY"),
											endDate: moment(startDate1.format("MM") + "-" + startDate1.daysInMonth() + "-" + startDate1.year(), "MM-DD-YYYY").format("MM/DD/YYYY")
										});
										payPeriods.push({
											key: currDate.format("MM/DD/YYYY"),
											val: currDate.format("ddd, MMMM DD, YY") + "-3rd Q",
											startDate: moment(endDate1.format("MM") + "-01-" + endDate1.year(), "MM-DD-YYYY").format("MM/DD/YYYY"),
											endDate: endDate1.format("MM/DD/YYYY")
										});
									} else if (quarter === 4) {
										payPeriods.push({
											key: currDate.format("MM/DD/YYYY"),
											val: currDate.format("ddd, MMMM DD, YY") + "-3rd Q",
											startDate: startDate1.format("MM/DD/YYYY"),
											endDate: moment(startDate1.format("MM") + "-" + startDate1.daysInMonth() + "-" + startDate1.year(), "MM-DD-YYYY").format("MM/DD/YYYY")
										});
										payPeriods.push({
											key: currDate.format("MM/DD/YYYY"),
											val: currDate.format("ddd, MMMM DD, YY") + "-4th Q",
											startDate: moment(endDate1.format("MM") + "-01-" + endDate1.year(), "MM-DD-YYYY").format("MM/DD/YYYY"),
											endDate: endDate1.format("MM/DD/YYYY")
										});
									}


								} else {
									payPeriods.push({
										key: currDate.format("MM/DD/YYYY"),
										val: currDate.format("ddd, MMMM DD, YY"),
										startDate: startDate1.format("MM/DD/YYYY"),
										endDate: endDate1.format("MM/DD/YYYY")
									});
								}


								dayofquarter++;
								
							}
							
							currDate = currDate.add('days', 1);
						}
						return payPeriods;
					}
					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};

					$scope.getReport940 = function() {
						getReport('Paperless940', 'Paperless 940', dataSvc.filter940.year, null, null, null, null, null, null);
					}
					$scope.getReport941 = function () {
						getReport('Paperless941', 'Paperless 941', dataSvc.filter941.year, dataSvc.filter941.quarter, null, null, null, null, null);
					}
					
					$scope.getReportW2Employee = function () {
						getReport('SSAW2Magnetic', 'Federal SSA W2 Magnetic File', dataSvc.filterW2.year, null, null, null, null, null, null);
					}
					
					$scope.getReport940Q = function () {
						getReport('FederalQuarterly940', 'Federal Quarterly 940 EFTPS File', dataSvc.filter940Q.year, dataSvc.filter940Q.quarter, null, dataSvc.filter940Q.depositDate, null, null, null);
					}
					$scope.getReportFederal941 = function () {
						if(dataSvc.filter941.depositSchedule===1)
							getReport('Federal941', 'Federal 941 EFTPS File', dataSvc.filter941.year, null, 1, dataSvc.filter941.depositDate, null, dataSvc.filter941.payPeriod.startDate, dataSvc.filter941.payPeriod.endDate);
						else if(dataSvc.filter941.depositSchedule===2)
							getReport('Federal941', 'Federal 941 EFTPS File', dataSvc.filter941.year, null, 2, dataSvc.filter941.depositDate, dataSvc.filter941.month, null, null);
						else {
							getReport('Federal941', 'Federal 941 EFTPS File', dataSvc.filter941.year, dataSvc.filter941.quarter, 3, dataSvc.filter941.depositDate, null, null, null);
						}
					}
					$scope.getReportCAPIT = function () {
						if (dataSvc.filterCAPIT.depositSchedule === 1)
							getReport('StateCAPIT', 'California PIT & DI GovOne File', dataSvc.filterCAPIT.year, null, 1, dataSvc.filterCAPIT.depositDate, null, dataSvc.filterCAPIT.payPeriod.startDate, dataSvc.filterCAPIT.payPeriod.endDate);
						else if (dataSvc.filterCAPIT.depositSchedule === 2)
							getReport('StateCAPIT', 'California PIT & DI GovOne File', dataSvc.filterCAPIT.year, null, 2, dataSvc.filterCAPIT.depositDate, dataSvc.filterCAPIT.month, null, null);
						else {
							getReport('StateCAPIT', 'California PIT & DI GovOne File', dataSvc.filterCAPIT.year, dataSvc.filterCAPIT.quarter, 3, dataSvc.filterCAPIT.depositDate, null, null, null);
						}
					}
					$scope.getReportCAUIQ = function () {
						getReport('StateCAUI', 'California Quarterly UI & ETT GovOne File', dataSvc.filterCAUIQ.year, dataSvc.filterCAUIQ.quarter, null, dataSvc.filterCAUIQ.depositDate, null, null, null);
					}

					$scope.getReport1099 = function () {
						getReport('Report1099', '1099', dataSvc.filter1099.year, null);
					}
					$scope.getReportDE6 = function () {
						getReport('StateCADE6', 'California Quarterly DE6 Reporting File', dataSvc.filterDE6Q.year, dataSvc.filterDE6Q.quarter, null, null, null, null, null);
					}
					
					var getReport = function(reportName, desc, year, quarter, depositSchedule, depositDate, month, start, end) {
						var m = $scope.mainData;
						var request = {
							reportName: reportName,
							year: year,
							quarter: quarter,
							month: month,
							startDate:start,
							endDate: end,
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
