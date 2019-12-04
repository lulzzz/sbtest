'use strict';

common.directive('govtForms', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/govt-forms.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'payrollRepository', 'reportRepository',
				function ($scope, $element, $location, $filter, payrollRepository, reportRepository) {
					var dataSvc = {

						isBodyOpen: true,
						response: null,
						filter: {
							years: []
						},
						filter940: {
							year: 0,
							includeHistory: true,
							includeClients: false
						},
						filter944: {
							year: 0,
							includeHistory: true,
							includeClients: false
						},
						filterW2: {
							year: 0,
							includeHistory: true,
							includeClients: false
						},
						filterC1095: {
							year: 0,
							includeHistory: true,
							includeClients: false
						},
						filterW3: {
							year: 0,
							includeHistory: true,
							includeClients: false
                        },
                        filterHW3: {
                            year: 0,
                            includeHistory: true,
                            includeClients: false
                        },
						filter1099: {
							year: 0,
							includeHistory: true,
							includeClients: false
						},
						filter941: {
							year: 0,
							quarter: 0,
							includeHistory: true,
							includeClients: false
						},
						
						filterde9: {
							year: 0,
							quarter: 0,
							includeHistory: true,
							includeClients: false
                        },
                        filterhi14: {
                            year: 0,
                            quarter: 0,
                            includeHistory: true,
                            includeClients: false
                        },
                        filterhiui: {
                            year: 0,
                            quarter: 0,
                            includeHistory: true,
                            includeClients: false
                        },
                        filterHIPIT: {
                            year: 0,
                            payPeriods: [],
                            payPeriod: null,
                            depositSchedule: $scope.mainData.selectedCompany.depositSchedule,
                            month: null,
                            quarter: null,
                            depositDate: moment().startOf('day').toDate(),
                            includeHistory: true,
                            includeClients: false
                        },
						filterTxSuta: {
							year: 0,
							quarter: 0,
							includeHistory: true,
							includeClients: false
						}
					}
					$scope.showincludeclients = (!$scope.mainData.selectedCompany.fileUnderHost && ($scope.mainData.selectedCompany.hasLocations || $scope.mainData.selectedCompany.isLocation)) || ($scope.mainData.selectedCompany.fileUnderHost && $scope.mainData.selectedHost.isPeoHost) ? true : false;
					var currentYear = new Date().getFullYear();
					for (var i = currentYear; i >= currentYear-4; i--) {
						if(i>=2015)
							dataSvc.filter.years.push(i);
					}
					

					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;


					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
                    };
                    $scope.isHIPITValid = function () {
                        if (!dataSvc.filterHIPIT.year || !dataSvc.filterHIPIT.depositSchedule || !dataSvc.filterHIPIT.depositDate)
                            return false;
                        else {
                            if (dataSvc.filterHIPIT.depositSchedule === 1) {
                                dataSvc.filterHIPIT.month = null;
                                dataSvc.filterHIPIT.quarter = null;
                                if (!dataSvc.filterHIPIT.payPeriod)
                                    return false;
                                else
                                    return true;
                            }
                            else if (dataSvc.filterHIPIT.depositSchedule === 2) {
                                dataSvc.filterHIPIT.payPeriod = null;
                                dataSvc.filterHIPIT.quarter = null;
                                if (!dataSvc.filterHIPIT.month)
                                    return false;
                                else {
                                    return true;
                                }
                            } else {
                                dataSvc.filterHIPIT.month = null;
                                dataSvc.filterHIPIT.payPeriod = null;
                                if (!dataSvc.filterHIPIT.quarter)
                                    return false;
                                else
                                    return true;
                            }

                        }
                    }
                    $scope.fillHIPITPayPeriods = function () {
                        dataSvc.filterHIPIT.payPeriods = fillPayPeriods(dataSvc.filterHIPIT.year);
                    }
                    var isQuarterDifferent = function (start, end) {
                        var stqtr = Math.floor((start.month() + 3) / 3);
                        var endqytr = Math.floor((end.month() + 3) / 3);
                        return stqtr !== endqytr;
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
                                else {
                                    startDate1 = moment(currDate).add('days', -6);
                                    endDate1 = moment(currDate).add('days', -3);
                                }



                                if (isQuarterDifferent(startDate1, endDate1)) {
                                    if (quarter === 1) {
                                        payPeriods.push({
                                            key: currDate.format("MM/DD/YYYY"),
                                            val: moment(currDate.format("MM") + "/" + currDate.format("DD") + "/" + (currDate.year() - 1), "MM-DD-YYYY").format("ddd, MMMM DD, YYYY") + "-4th Q",
                                            startDate: startDate1.format("MM/DD/YYYY"),
                                            endDate: moment(startDate1.format("MM") + "-" + startDate1.daysInMonth() + "-" + startDate1.year(), "MM-DD-YYYY").format("MM/DD/YYYY")
                                        });
                                        payPeriods.push({
                                            key: currDate.format("MM/DD/YYYY"),
                                            val: currDate.format("ddd, MMMM DD, YYYY") + "-1st Q",
                                            startDate: moment(endDate1.format("MM") + "-01-" + endDate1.year(), "MM-DD-YYYY").format("MM/DD/YYYY"),
                                            endDate: endDate1.format("MM/DD/YYYY")
                                        });


                                    } else if (quarter === 2) {
                                        payPeriods.push({
                                            key: currDate.format("MM/DD/YYYY"),
                                            val: currDate.format("ddd, MMMM DD, YYYY") + "-1st Q",
                                            startDate: startDate1.format("MM/DD/YYYY"),
                                            endDate: moment(startDate1.format("MM") + "-" + startDate1.daysInMonth() + "-" + startDate1.year(), "MM-DD-YYYY").format("MM/DD/YYYY")
                                        });
                                        payPeriods.push({
                                            key: currDate.format("MM/DD/YYYY"),
                                            val: currDate.format("ddd, MMMM DD, YYYY") + "-2nd Q",
                                            startDate: moment(endDate1.format("MM") + "-01-" + endDate1.year(), "MM-DD-YYYY").format("MM/DD/YYYY"),
                                            endDate: endDate1.format("MM/DD/YYYY")
                                        });
                                    } else if (quarter === 3) {
                                        payPeriods.push({
                                            key: currDate.format("MM/DD/YYYY"),
                                            val: currDate.format("ddd, MMMM DD, YYYY") + "-2nd Q",
                                            startDate: startDate1.format("MM/DD/YYYY"),
                                            endDate: moment(startDate1.format("MM") + "-" + startDate1.daysInMonth() + "-" + startDate1.year(), "MM-DD-YYYY").format("MM/DD/YYYY")
                                        });
                                        payPeriods.push({
                                            key: currDate.format("MM/DD/YYYY"),
                                            val: currDate.format("ddd, MMMM DD, YYYY") + "-3rd Q",
                                            startDate: moment(endDate1.format("MM") + "-01-" + endDate1.year(), "MM-DD-YYYY").format("MM/DD/YYYY"),
                                            endDate: endDate1.format("MM/DD/YYYY")
                                        });
                                    } else if (quarter === 4) {
                                        payPeriods.push({
                                            key: currDate.format("MM/DD/YYYY"),
                                            val: currDate.format("ddd, MMMM DD, YYYY") + "-3rd Q",
                                            startDate: startDate1.format("MM/DD/YYYY"),
                                            endDate: moment(startDate1.format("MM") + "-" + startDate1.daysInMonth() + "-" + startDate1.year(), "MM-DD-YYYY").format("MM/DD/YYYY")
                                        });
                                        payPeriods.push({
                                            key: currDate.format("MM/DD/YYYY"),
                                            val: currDate.format("ddd, MMMM DD, YYYY") + "-4th Q",
                                            startDate: moment(endDate1.format("MM") + "-01-" + endDate1.year(), "MM-DD-YYYY").format("MM/DD/YYYY"),
                                            endDate: endDate1.format("MM/DD/YYYY")
                                        });
                                    }


                                } else {
                                    payPeriods.push({
                                        key: currDate.format("MM/DD/YYYY"),
                                        val: currDate.format("ddd, MMMM DD, YYYY"),
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
                    $scope.getReportHIPIT = function () {
                        if (dataSvc.filterHIPIT.depositSchedule === 1)
                            getReport('StateHIPIT', 'Hawaii PIT GovOne File', dataSvc.filterHIPIT.year, null, dataSvc.filterHIPIT.includeClients, dataSvc.filterHIPIT.includeHistory, dataSvc.filterHIPIT.payPeriod.startDate, dataSvc.filterHIPIT.payPeriod.endDate, null);
                        else if (dataSvc.filterHIPIT.depositSchedule === 2)
                            getReport('StateHIPIT', 'Hawaii PIT GovOne File', dataSvc.filterHIPIT.year, null, dataSvc.filterHIPIT.includeClients, dataSvc.filterHIPIT.includeHistory, null, null, dataSvc.filterHIPIT.month);
                        else {
                            getReport('StateHIPIT', 'Hawaii PIT GovOne File', dataSvc.filterHIPIT.year, dataSvc.filterHIPIT.quarter, dataSvc.filterHIPIT.includeClients, dataSvc.filterHIPIT.includeHistory);
                        }
                    }
                    $scope.getReportHWUI = function () {
                        getReport('StateHIUIForm', 'Hawaii State Unemployment Insurance', dataSvc.filterhiui.year, dataSvc.filterhiui.quarter, dataSvc.filterhiui.includeHistory, dataSvc.filterhiui.includeClients);
                    }
					$scope.getReport940 = function() {
						getReport('Federal940', 'Federal 940', dataSvc.filter940.year, null, dataSvc.filter940.includeHistory, dataSvc.filter940.includeClients);
					}
					$scope.getReport941 = function () {
						getReport('Federal941', 'Federal 941', dataSvc.filter941.year, dataSvc.filter941.quarter, dataSvc.filter941.includeHistory, dataSvc.filter941.includeClients);
					}
					$scope.getReport944 = function () {
						getReport('Federal944', 'Federal 944', dataSvc.filter944.year, null, dataSvc.filter944.includeHistory, dataSvc.filter944.includeClients);
					}
					$scope.getReportW2Employee = function () {
						getReport('W2Employee', 'Federal W2 (Employee version)', dataSvc.filterW2.year, null, dataSvc.filterW2.includeHistory, dataSvc.filterW2.includeClients);
					}
					$scope.getReportW2Employer = function () {
						getReport('W2Employer', 'Federal W2 (Employer version)', dataSvc.filterW2.year, null, dataSvc.filterW2.includeHistory, dataSvc.filterW2.includeClients);
					}
					$scope.getReportW3 = function () {
						getReport('W3', 'Federal W3', dataSvc.filterW3.year, null, dataSvc.filterW3.includeHistory, dataSvc.filterW3.includeClients);
                    }
                    $scope.getReportHW3 = function () {
                        getReport('HW3', 'Hawaii HW3', dataSvc.filterHW3.year, null, dataSvc.filterHW3.includeHistory, dataSvc.filterHW3.includeClients);
                    }
					$scope.getReport1099 = function () {
						getReport('Report1099', '1099', dataSvc.filter1099.year, null, dataSvc.filter1099.includeHistory);
					}
					
					$scope.getReportDE9 = function () {
						getReport('CaliforniaDE9', 'California DE 9', dataSvc.filterde9.year, dataSvc.filterde9.quarter, dataSvc.filterde9.includeHistory, dataSvc.filterde9.includeClients);
						getReport('CaliforniaDE9C', 'California DE 9C', dataSvc.filterde9.year, dataSvc.filterde9.quarter, dataSvc.filterde9.includeHistory, dataSvc.filterde9.includeClients);
                    }
                    $scope.getReportHW14 = function () {
                        getReport('StateHIHW14', 'Hawaii HW 14', dataSvc.filterhi14.year, dataSvc.filterhi14.quarter, dataSvc.filterhi14.includeHistory, dataSvc.filterhi14.includeClients);
                        
                    }
					$scope.getReportC1095 = function () {
						getReport('C1095', 'Federal 1095-C', dataSvc.filterC1095.year, null, dataSvc.filterC1095.includeHistory, dataSvc.filterC1095.includeClients);
					}
					$scope.getReportTXSuta = function () {
						getReport('TXSuta', 'Texas Unemployement', dataSvc.filterTxSuta.year, dataSvc.filterTxSuta.quarter, dataSvc.filterTxSuta.includeHistory, dataSvc.filterTxSuta.includeClients);
					}

					var getReport = function(reportName, desc, year, quarter, includeHistory, includeClients, startdate, enddate, month) {
						var m = $scope.mainData;
						var request = {
							reportName: reportName,
							hostId: m.selectedHost.id,
							companyId: m.selectedCompany.id,
							year: year,
							quarter: quarter,
							month: month,
							startDate:startdate,
							endDate: enddate,
							includeHistory: includeHistory,
							includeClients: includeClients
						}
						reportRepository.getReportDocument(request).then(function (data) {
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
					$scope.hasState = function(stateId) {
						var comp = $scope.mainData.selectedCompany;
						if (comp) {
							var cal = $filter('filter')(comp.states, { state : { stateId: stateId } });
							if (cal.length>0)
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
