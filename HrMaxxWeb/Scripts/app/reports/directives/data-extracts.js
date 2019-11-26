'use strict';
common.directive('extractReports', ['zionAPI', '$timeout', '$window', 'version','$uibModal',
	function (zionAPI, $timeout, $window, version, $modal) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/data-extracts.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'payrollRepository', 'reportRepository', 'hostRepository', 'commonRepository', 'ClaimTypes',
				function ($scope, $element, $location, $filter, payrollRepository, reportRepository, hostRepository, commonRepository, ClaimTypes) {
					var dataSvc = {
						isBodyOpen: false,
						isBodyOpenExtract: false,
						isBodyOpenWC: false,
						isBodyOpenPP: false,
						openedRack:2,
						response: null,
						minYear: 2015,
						hosts: [],
						selectedHost: null,
						selectedSalesRep: null,
						viewMisc: $scope.mainData.hasClaim(ClaimTypes.MiscExtracts, 1),
						viewAll: $scope.mainData.hasClaim(ClaimTypes.DataExtracts, 1),
						filterPP: {
							payDay: moment().startOf('day').toDate()
						},
						filterDD: {
							startDate: moment().startOf('day').toDate(),
							endDate: moment().startOf('day').toDate()
						},
						filterWC: {
							startDate: moment().add(-1, 'month').startOf('month').toDate(),
							endDate: moment().add(-1, 'month').endOf('month').toDate(),
							includeHistory: false
						},
						filterDE34: {
							startDate: moment().add(-1, 'month').startOf('month').toDate(),
							endDate: moment().add(-1, 'month').endOf('month').toDate(),
							includeHistory: false
						},
						filterG: {
							startDate: moment().add(-1, 'month').startOf('month').toDate(),
							endDate: moment().add(-1, 'month').endOf('month').toDate()
						},
						filter: {
							years: []
						},
						filter940: {
							year: 0,
							includeHistory: true
						},
						paperless941: {
							year: 0,
							quarter: 0,
							includeHistory: true
						},
						txsuta: {
							year: 0,
							quarter: 0,
							includeHistory: true
						},
						
						filterW2: {
							year: 0,
							includeHistory: true
						},
						filterC1095: {
							year: 0,
							includeHistory: true
						},
						filter940Q: {
							year: 0,
							payPeriods: [],
							payPeriod: null,
							depositSchedule: 0,
							month: null,
							quarter: null,
							depositDate: moment().startOf('day').toDate(),
							includeHistory: false
						},
						filterCAUIQ: {
							year: 0,
							payPeriods: [],
							payPeriod: null,
							depositSchedule: 0,
							month: null,
							quarter: null,
							depositDate: moment().startOf('day').toDate(),
							includeHistory: false
						},
						filter941: {
							year: 0,
							payPeriods: [],
							payPeriod: null,
							depositSchedule: 0,
							month: null,
							quarter: null,
							depositDate: moment().startOf('day').toDate(),
							includeHistory: false
						},
						filterCAPIT: {
							year: 0,
							payPeriods: [],
							payPeriod: null,
							depositSchedule: 0,
							month: null,
							quarter: null,
							depositDate: moment().startOf('day').toDate(),
							includeHistory: false
                        },
                        
						filter1099: {
							year: 0,
							includeHistory: false
						},
						
						filterDE6Q: {
							year: 0,
							quarter: 0,
							includeHistory: true
						},
						filterDE9Q: {
							year: 0,
							quarter: 0,
							includeHistory: true
						},
						taxreport: {
							year: 0,
							month: null,
							quarter: null,
							includeHistory: true
						},
						filterCommissions: {
							startDate: null,
							endDate: null,
							includeHistory: false,
							includeInactive: true
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
					$scope.is940Valid = function () {
						if (!dataSvc.filter940Q.year || !dataSvc.filter940Q.depositSchedule || !dataSvc.filter940Q.depositDate)
							return false;
						else {
							if (dataSvc.filter940Q.depositSchedule === 1) {
								dataSvc.filter940Q.month = null;
								dataSvc.filter940Q.quarter = null;
								if (!dataSvc.filter940Q.payPeriod)
									return false;
								else
									return true;
							}
							else if (dataSvc.filter940Q.depositSchedule === 2) {
								dataSvc.filter940Q.payPeriod = null;
								dataSvc.filter940Q.quarter = null;
								if (!dataSvc.filter940Q.month)
									return false;
								else {
									return true;
								}
							} else {
								dataSvc.filter940Q.month = null;
								dataSvc.filter940Q.payPeriod = null;
								if (!dataSvc.filter940Q.quarter)
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
					$scope.isCAUIValid = function () {
						if (!dataSvc.filterCAUIQ.year || !dataSvc.filterCAUIQ.depositSchedule || !dataSvc.filterCAUIQ.depositDate)
							return false;
						else {
							if (dataSvc.filterCAUIQ.depositSchedule === 1) {
								dataSvc.filterCAUIQ.month = null;
								dataSvc.filterCAUIQ.quarter = null;
								if (!dataSvc.filterCAUIQ.payPeriod)
									return false;
								else
									return true;
							}
							else if (dataSvc.filterCAUIQ.depositSchedule === 2) {
								dataSvc.filterCAUIQ.payPeriod = null;
								dataSvc.filterCAUIQ.quarter = null;
								if (!dataSvc.filterCAUIQ.month)
									return false;
								else {
									return true;
								}
							} else {
								dataSvc.filterCAUIQ.month = null;
								dataSvc.filterCAUIQ.payPeriod = null;
								if (!dataSvc.filterCAUIQ.quarter)
									return false;
								else
									return true;
							}

						}
                    }

                    

					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = false;
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;

					$scope.fill941PayPeriods = function () {
						if (dataSvc.filter941.depositSchedule === 1) {
							dataSvc.filter941.payPeriods = fillPayPeriods(dataSvc.filter941.year);
						}
					}
					$scope.fill940PayPeriods = function () {
						if (dataSvc.filter940Q.depositSchedule === 1) {
							dataSvc.filter940Q.payPeriods = fillPayPeriods(dataSvc.filter940Q.year);
						}
                    }
                    
					$scope.fillCAPITPayPeriods = function () {
						dataSvc.filterCAPIT.payPeriods = fillPayPeriods(dataSvc.filterCAPIT.year);
					}
					$scope.fillCAUIPayPeriods = function () {
						dataSvc.filterCAUIQ.payPeriods = fillPayPeriods(dataSvc.filterCAUIQ.year);
					}
					
					var isQuarterDifferent = function(start, end) {
						var stqtr = Math.floor((start.month() + 3) / 3);
						var endqytr = Math.floor((end.month() + 3) / 3);
						return stqtr !== endqytr;
					}
					$scope.showpayperiod = function() {
						$scope.$parent.$parent.addAlert('Start Date: ' + dataSvc.filter941.payPeriod.startDate + ' , End Date: ' + dataSvc.filter941.payPeriod.endDate, 'info'); 
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
					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};

					$scope.getReport940 = function() {
						getReport('Paperless940', 'Paperless 940', dataSvc.filter940.year, null, null, null, null, null, null, true, dataSvc.filter940.includeHistory);
					}
					$scope.getReport941 = function () {
						getReport('Paperless941', 'Paperless 941', dataSvc.paperless941.year, dataSvc.paperless941.quarter, null, null, null, null, null, true, dataSvc.paperless941.includeHistory);
					}
					$scope.getReportTXSuta = function () {
						getReport('TXSuta', 'Texas UmEmployment', dataSvc.txsuta.year, dataSvc.txsuta.quarter, null, null, null, null, null, true, dataSvc.txsuta.includeHistory);
					}
					$scope.getReportHostClientSummary = function () {
						getReport('HostClientSummary', 'Host Client Summary', dataSvc.paperless941.year, dataSvc.paperless941.quarter, null, null, null, null, null, false, dataSvc.paperless941.includeHistory);
					}
					
					$scope.getReportW2Employee = function () {
						getReport('SSAW2Magnetic', 'Federal SSA W2 Magnetic File', dataSvc.filterW2.year, null, null, null, null, null, null, false, dataSvc.filterW2.includeHistory);
					}
					$scope.getReportW2EmployeeReport = function () {
						getReport('SSAW2MagneticReport', 'Federal W2 Employee Report', dataSvc.filterW2.year, null, null, null, null, null, null, true, dataSvc.filterW2.includeHistory);
					}
					$scope.getReportW2EmployerReport = function () {
						getReport('SSAW2MagneticEmployerReport', 'Federal W2 Employer Report', dataSvc.filterW2.year, null, null, null, null, null, null, true, dataSvc.filterW2.includeHistory);
					}

					$scope.getReportC1095 = function () {
						getReport('C1095', 'Federal 1095-C File', dataSvc.filterC1095.year, null, null, null, null, null, null, false, dataSvc.filterC1095.includeHistory);
					}
					$scope.getReportC1095Report = function () {
						getReport('C1095Report', 'Federal 1095-C File Report', dataSvc.filterC1095.year, null, null, null, null, null, null, true, dataSvc.filterC1095.includeHistory);
					}
					
					$scope.getReport940Q = function () {
						if (dataSvc.filter940Q.depositSchedule === 1)
							getReport('Federal940', 'Federal 940 EFTPS File', dataSvc.filter940Q.year, null, 1, dataSvc.filter940Q.depositDate, null, dataSvc.filter940Q.payPeriod.startDate, dataSvc.filter940Q.payPeriod.endDate, true, dataSvc.filter940Q.includeHistory);
						else if (dataSvc.filter940Q.depositSchedule === 2)
							getReport('Federal940', 'Federal 940 EFTPS File', dataSvc.filter940Q.year, null, 2, dataSvc.filter940Q.depositDate, dataSvc.filter940Q.month, null, null, true, dataSvc.filter940Q.includeHistory);
						else {
							getReport('Federal940', 'Federal 940 EFTPS File', dataSvc.filter940Q.year, dataSvc.filter940Q.quarter, 3, dataSvc.filter940Q.depositDate, null, null, null, true, dataSvc.filter940Q.includeHistory);
						}
					}
					$scope.getReport940QExcel = function () {
						if (dataSvc.filter940Q.depositSchedule === 1)
							getReport('Federal940Excel', 'Federal 940 EFTPS Excel File', dataSvc.filter940Q.year, null, 1, dataSvc.filter940Q.depositDate, null, dataSvc.filter940Q.payPeriod.startDate, dataSvc.filter940Q.payPeriod.endDate, false, dataSvc.filter940Q.includeHistory);
						else if (dataSvc.filter940Q.depositSchedule === 2)
							getReport('Federal940Excel', 'Federal 940 EFTPS Excel File', dataSvc.filter940Q.year, null, 2, dataSvc.filter940Q.depositDate, dataSvc.filter940Q.month, null, null, false, dataSvc.filter940Q.includeHistory);
						else {
							getReport('Federal940Excel', 'Federal 940 EFTPS Excel File', dataSvc.filter940Q.year, dataSvc.filter940Q.quarter, 3, dataSvc.filter940Q.depositDate, null, null, null, false, dataSvc.filter940Q.includeHistory);
						}
					}
					$scope.getReportFederal941 = function () {
						if(dataSvc.filter941.depositSchedule===1)
							getReport('Federal941', 'Federal 941 EFTPS File', dataSvc.filter941.year, null, 1, dataSvc.filter941.depositDate, null, dataSvc.filter941.payPeriod.startDate, dataSvc.filter941.payPeriod.endDate, true, dataSvc.filter941.includeHistory);
						else if(dataSvc.filter941.depositSchedule===2)
							getReport('Federal941', 'Federal 941 EFTPS File', dataSvc.filter941.year, null, 2, dataSvc.filter941.depositDate, dataSvc.filter941.month, null, null, true, dataSvc.filter941.includeHistory);
						else {
							getReport('Federal941', 'Federal 941 EFTPS File', dataSvc.filter941.year, dataSvc.filter941.quarter, 3, dataSvc.filter941.depositDate, null, null, null, true, dataSvc.filter941.includeHistory);
						}
					}
					$scope.getTaxReport = function () {
						getReport('TaxReport', 'Tax Report File', dataSvc.taxreport.year, dataSvc.taxreport.quarter, null, null, dataSvc.taxreport.month, null, null, false, dataSvc.taxreport.includeHistory);
						
					}
					$scope.getReportFederal941Excel = function () {
						if (dataSvc.filter941.depositSchedule === 1)
							getReport('Federal941Excel', 'Federal 941 EFTPS Excel File', dataSvc.filter941.year, null, 1, dataSvc.filter941.depositDate, null, dataSvc.filter941.payPeriod.startDate, dataSvc.filter941.payPeriod.endDate, false, dataSvc.filter941.includeHistory);
						else if (dataSvc.filter941.depositSchedule === 2)
							getReport('Federal941Excel', 'Federal 941 EFTPS Excel File', dataSvc.filter941.year, null, 2, dataSvc.filter941.depositDate, dataSvc.filter941.month, null, null, false, dataSvc.filter941.includeHistory);
						else {
							getReport('Federal941Excel', 'Federal 941 EFTPS Excel File', dataSvc.filter941.year, dataSvc.filter941.quarter, 3, dataSvc.filter941.depositDate, null, null, null, false, dataSvc.filter941.includeHistory);
						}
					}
					$scope.getReportCAPIT = function () {
						if (dataSvc.filterCAPIT.depositSchedule === 1)
							getReport('StateCAPIT', 'California PIT & DI GovOne File', dataSvc.filterCAPIT.year, null, 1, dataSvc.filterCAPIT.depositDate, null, dataSvc.filterCAPIT.payPeriod.startDate, dataSvc.filterCAPIT.payPeriod.endDate, true, dataSvc.filterCAPIT.includeHistory);
						else if (dataSvc.filterCAPIT.depositSchedule === 2)
							getReport('StateCAPIT', 'California PIT & DI GovOne File', dataSvc.filterCAPIT.year, null, 2, dataSvc.filterCAPIT.depositDate, dataSvc.filterCAPIT.month, null, null, true, dataSvc.filterCAPIT.includeHistory);
						else {
							getReport('StateCAPIT', 'California PIT & DI GovOne File', dataSvc.filterCAPIT.year, dataSvc.filterCAPIT.quarter, 3, dataSvc.filterCAPIT.depositDate, null, null, null, true, dataSvc.filterCAPIT.includeHistory);
						}
					}
					$scope.getReportCAPITExcel = function () {
						if (dataSvc.filterCAPIT.depositSchedule === 1)
							getReport('StateCAPITExcel', 'California PIT & DI Excel File', dataSvc.filterCAPIT.year, null, 1, dataSvc.filterCAPIT.depositDate, null, dataSvc.filterCAPIT.payPeriod.startDate, dataSvc.filterCAPIT.payPeriod.endDate, false, dataSvc.filterCAPIT.includeHistory);
						else if (dataSvc.filterCAPIT.depositSchedule === 2)
							getReport('StateCAPITExcel', 'California PIT & DI Excel File', dataSvc.filterCAPIT.year, null, 2, dataSvc.filterCAPIT.depositDate, dataSvc.filterCAPIT.month, null, null, false, dataSvc.filterCAPIT.includeHistory);
						else {
							getReport('StateCAPITExcel', 'California PIT & DI Excel File', dataSvc.filterCAPIT.year, dataSvc.filterCAPIT.quarter, 3, dataSvc.filterCAPIT.depositDate, null, null, null, false, dataSvc.filterCAPIT.includeHistory);
						}
                    }
                    $scope.getReportCAUIQ = function () {
						if (dataSvc.filterCAUIQ.depositSchedule === 1)
							getReport('StateCAUI', 'California UI & ETT GovOne File', dataSvc.filterCAUIQ.year, null, 1, dataSvc.filterCAUIQ.depositDate, null, dataSvc.filterCAUIQ.payPeriod.startDate, dataSvc.filterCAUIQ.payPeriod.endDate, true, dataSvc.filterCAUIQ.includeHistory);
						else if (dataSvc.filterCAUIQ.depositSchedule === 2)
							getReport('StateCAUI', 'California UI & ETT GovOne File', dataSvc.filterCAUIQ.year, null, 2, dataSvc.filterCAUIQ.depositDate, dataSvc.filterCAUIQ.month, null, null, true, dataSvc.filterCAUIQ.includeHistory);
						else {
							getReport('StateCAUI', 'California UI & ETT GovOne File', dataSvc.filterCAUIQ.year, dataSvc.filterCAUIQ.quarter, 3, dataSvc.filterCAUIQ.depositDate, null, null, null, true, dataSvc.filterCAUIQ.includeHistory);
						}
					}
					$scope.getReportCAUIQExcel = function () {
						if (dataSvc.filterCAUIQ.depositSchedule === 1)
							getReport('StateCAUIExcel', 'California UI & ETT Excel File', dataSvc.filterCAUIQ.year, null, 1, dataSvc.filterCAUIQ.depositDate, null, dataSvc.filterCAUIQ.payPeriod.startDate, dataSvc.filterCAUIQ.payPeriod.endDate, false, dataSvc.filterCAUIQ.includeHistory);
						else if (dataSvc.filterCAUIQ.depositSchedule === 2)
							getReport('StateCAUIExcel', 'California UI & ETT Excel File', dataSvc.filterCAUIQ.year, null, 2, dataSvc.filterCAUIQ.depositDate, dataSvc.filterCAUIQ.month, null, null, false, dataSvc.filterCAUIQ.includeHistory);
						else {
							getReport('StateCAUIExcel', 'California UI & ETT Excel File', dataSvc.filterCAUIQ.year, dataSvc.filterCAUIQ.quarter, 3, dataSvc.filterCAUIQ.depositDate, null, null, null, false, dataSvc.filterCAUIQ.includeHistory);
						}
					}

					$scope.getReport1099 = function () {
						getReport('Report1099', '1099', dataSvc.filter1099.year, null, null, null, null, null, null, true, dataSvc.filter1099.includeHistory);
					}
					$scope.getReportDE6 = function () {
						getReport('StateCADE6', 'California Quarterly DE6 Reporting File', dataSvc.filterDE6Q.year, dataSvc.filterDE6Q.quarter, null, null, null, null, null, true, dataSvc.filterDE6Q.includeHistory);
					}
					$scope.getReportDE9 = function () {
						getReport('StateCADE9', 'California Quarterly DE9 Reporting File', dataSvc.filterDE9Q.year, dataSvc.filterDE9Q.quarter, null, null, null, null, null, true, dataSvc.filterDE9Q.includeHistory);
                    }
                    
					var showReview = function (report, extract) {
						var modalInstance = $modal.open({
							templateUrl: 'popover/extractView.html',
							controller: 'extractViewCtrl',
							size: 'lg',
							windowClass: 'my-modal-popup',
							backdrop: 'static',
							keyboard: false,
							backdropClick: false,
							resolve: {
								extract: function () {
									return extract;
								},
								mainData: function() {
									return $scope.mainData;
								},
								item: function () {
									return {
										id: 0,
										lastModified: new Date(),
										lastModifiedBy: '',
										extract: extract,
										journals: []
									};
								},
								reportRepository: function () {
									return reportRepository;
								},
								$window: function() {
									return $window;
								}
							}
						});

					}
					var getReport = function(reportName, desc, year, quarter, depositSchedule, depositDate, month, start, end, review, includeHistory) {
						var m = $scope.mainData;
						var request = {
							reportName: reportName,
							year: year,
							quarter: quarter,
							month: month,
							startDate:start,
							endDate: end,
							depositSchedule: depositSchedule,
							depositDate: depositDate ? moment(depositDate).format("MM/DD/YYYY") : null,
							includeHistory: includeHistory
						}
						if (!review) {
							reportRepository.getExtractDocument(request).then(function (data) {

								var a = document.createElement('a');
								a.href = data.file;
								a.target = '_blank';
								a.download = data.name;
								document.body.appendChild(a);
								a.click();
							}, function (erorr) {
								addAlert('Failed to download report ' + desc + ': ' + erorr, 'danger');
							});
						} else {
							reportRepository.getExtract(request).then(function (extract) {
								showReview(request, extract);
								

							}, function (erorr) {
								addAlert('Error generating extract ' + desc + ': ' + erorr.statusText, 'danger');
							});
						}
						
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

					$scope.getHostWCReport = function () {
						var request = {
							reportName: 'HostWCReport',
							year: moment().year(),
							quarter: 0,
							month:0,
							startDate: moment(dataSvc.filterWC.startDate).format("MM/DD/YYYY"),
							endDate: moment(dataSvc.filterWC.endDate).format("MM/DD/YYYY"),
							depositSchedule: null,
							depositDate: null,
							includeHistory: dataSvc.filterWC.includeHistory
						}
						if (dataSvc.selectedHost) {
							request.hostId = dataSvc.selectedHost.id;
						}
						reportRepository.getExtract(request).then(function (extract) {
							showReview(request, extract);


						}, function (erorr) {
							addAlert('Error generating Host WC extract: ' + erorr.statusText, 'danger');
						});
						
					}
					$scope.getHostDE34Report = function () {
						var request = {
							reportName: 'HostDE34Report',
							year: moment().year(),
							quarter: 0,
							month: 0,
							startDate: moment(dataSvc.filterDE34.startDate).format("MM/DD/YYYY"),
							endDate: moment(dataSvc.filterDE34.endDate).format("MM/DD/YYYY"),
							depositSchedule: null,
							depositDate: null,
							includeHistory: false
						}
						if (dataSvc.selectedHost) {
							request.hostId = dataSvc.selectedHost.id;
						}
						reportRepository.getReportDocument(request).then(function (data) {

							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
						}, function (erorr) {
							addAlert('Error generating Host WC extract: ' + erorr, 'danger');
						});
						

					}

					$scope.getHostWCReportSpecial = function () {
						var request = {
							reportName: 'HostWCReportRedated',
							year: moment().year(),
							quarter: 0,
							month: 0,
							
							depositSchedule: null,
							depositDate: null,
							includeHistory: dataSvc.filterWC.includeHistory
						}
						if (dataSvc.selectedHost) {
							request.hostId = dataSvc.selectedHost.id;
						}
						reportRepository.getExtract(request).then(function (extract) {
							showReview(request, extract);


						}, function (erorr) {
							addAlert('Error generating Host WC extract: ' + erorr.statusText, 'danger');
						});

					}

					$scope.getGarnishmentReport = function () {
						getReport('GarnishmentReport', 'Garnishment Report', moment(dataSvc.filterG.startDate).year, null, null, moment().format("MM/DD/YYYY"), null, moment(dataSvc.filterG.startDate).format("MM/DD/YYYY"), moment(dataSvc.filterG.endDate).format("MM/DD/YYYY"), true);
						
					}

					$scope.getDailyDepositReport = function () {
						var request = {
							reportName: 'DailyDepositReport',
							year: moment().year(),
							quarter: 0,
							month: 0,
							startDate: moment(dataSvc.filterDD.startDate).format("MM/DD/YYYY"),
							endDate: moment(dataSvc.filterDD.startDate).format("MM/DD/YYYY"),
							depositSchedule: null,
							depositDate: null
						}
						reportRepository.getExtractDocument(request).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
							
						}, function (erorr) {
							addAlert('Error generating Daily Deposit report: ' + erorr.statusText, 'danger');
						});

					}

					$scope.createDepositTickets = function () {
						var request = {
							reportName: 'DailyDepositReport',
							year: moment().year(),
							quarter: 0,
							month: 0,
							startDate: moment(dataSvc.filterDD.startDate).format("MM/DD/YYYY"),
							endDate: moment(dataSvc.filterDD.startDate).format("MM/DD/YYYY"),
							depositSchedule: null,
							depositDate: null
						}
						reportRepository.createDepositTickets(request).then(function () {
							addAlert('successfully generated deposit ticket', 'success');

						}, function (erorr) {
							addAlert('Error generating Daily Deposit tickets: ' + erorr.statusText, 'danger');
						});

					}

					$scope.getPositivePayReport = function() {
						var request = {
							reportName: 'PositivePayReport',
							hostId: dataSvc.selectedHost.id,
							year: moment().year(),
							quarter: 0,
							month: 0,
							startDate: moment(dataSvc.filterPP.payDay).format("MM/DD/YYYY"),
							endDate: moment(dataSvc.filterPP.payDay).format("MM/DD/YYYY"),
							depositSchedule: null,
							depositDate: null
						}
						reportRepository.getExtractDocument(request).then(function(data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
							
						}, function(erorr) {
							addAlert('Error generating positive pay report: ' + erorr.statusText, 'danger');
						});

					};
					$scope.getInternalPositivePayReport = function () {
						var request = {
							reportName: 'InternalPositivePayReport',
							hostId: dataSvc.selectedHost.id,
							year: moment().year(),
							quarter: 0,
							month: 0,
							startDate: moment(dataSvc.filterPP.payDay).format("MM/DD/YYYY"),
							endDate: moment(dataSvc.filterPP.payDay).format("MM/DD/YYYY"),
							depositSchedule: null,
							depositDate: null
						}
						reportRepository.getExtractDocument(request).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
							
						}, function (erorr) {
							addAlert('Error generating host WC report: ' + erorr.statusText, 'danger');
						});

					}

					$scope.getCommissionsReport = function () {
						var request = {
							reportName: 'CommissionsReport',
							userId: dataSvc.selectedSalesRep ? dataSvc.selectedSalesRep.userId : null,
							startDate: dataSvc.filterCommissions.startDate ? moment(dataSvc.filterCommissions.startDate).format("MM/DD/YYYY") : moment("01-01-2017", "MM-DD-YYYY").format("MM/DD/YYYY"),
							endDate: dataSvc.filterCommissions.endDate ? moment(dataSvc.filterCommissions.endDate).format("MM/DD/YYYY") : moment().format("MM/DD/YYYY"),
							includeInactive: dataSvc.filterCommissions.includeInactive
						}
						reportRepository.getCommissionsReport(request).then(function (extract) {
							showReview(request, extract);


						}, function (erorr) {
							addAlert('Error generating commissions report: ' + erorr.statusText, 'danger');
						});
						
					}

					var _init = function () {
						$scope.minDepositDate = moment().startOf('day').toDate();
						var currentYear = new Date().getFullYear();
						var currentMonth = new Date().getMonth();
						var currentDay = new Date().getDate();
						if (currentMonth === 11 && currentDay>20) {
							currentYear += 1;
						}
						for (var i = currentYear - 4; i <= currentYear; i++) {
							if (i >= dataSvc.minYear)
								dataSvc.filter.years.push(i);
						}
						hostRepository.getHostList().then(function (data) {
							dataSvc.hosts = data;
						}, function (erorr) {
							addAlert('Error getting Host List : ' + erorr.statusText, 'danger');
						});
					}
					_init();


				}]
		}
	}
]);
common.controller('extractViewCtrl', function ($scope, $uibModalInstance, extract, mainData, reportRepository, item, $window) {
	$scope.mainData = mainData;
	$scope.alerts = [];
	var addAlert = function(message, status) {
		$scope.alerts = [];
		$scope.alerts.push({
			message: message,
			status: status
		});
	}
	$scope.masterExtract = item;
	
	$scope.dismiss = function() {
		$uibModalInstance.dismiss();
	}
	$scope.cancel = function () {
		$uibModalInstance.close(false);
	};

	$scope.fileTaxes = function () {
		reportRepository.fileTaxes($scope.masterExtract.extract).then(function (result) {
			$scope.masterExtract.id = result.id;
			$scope.masterExtract.journals = result.journals;
			
			addAlert('successfully filed taxes for report: ' + $scope.masterExtract.extract.report.description, 'success');
		}, function (erorr) {
			addAlert(erorr.statusText, 'danger');
		});
		
	};
	$scope.payCommissions = function () {
		reportRepository.payCommissions($scope.masterExtract.extract).then(function (result) {
			$scope.masterExtract.id = result.id;
			
			addAlert('successfully marked invoices as commissions paid: ' + $scope.masterExtract.extract.report.description, 'success');
		}, function (erorr) {
			addAlert(erorr.statusText, 'danger');
		});

	};
	$scope.print = function () {
		$scope.viewMode = 'Print';
		$window.print();
	}
	$scope.printExtract = function () {
		reportRepository.printExtract($scope.masterExtract.journals, $scope.masterExtract.extract.report).then(function (data) {
			var a = document.createElement('a');
			a.href = data.file;
			a.target = '_blank';
			a.download = data.name;
			document.body.appendChild(a);
			a.click();
		}, function (erorr) {
			addAlert(erorr.statusText, 'danger');
		});

	};
	$scope.regenerateFile = function() {
		reportRepository.downloadExtractFile($scope.masterExtract.extract).then(function (data) {
			var a = document.createElement('a');
			a.href = data.file;
			a.target = '_blank';
			a.download = data.name;
			document.body.appendChild(a);
			a.click();
		}, function (erorr) {
			addAlert('Failed to download report ' + $scope.masterExtract.extract.report.description + ': ' + erorr, 'danger');
		});
	}
	$scope.downloadFile = function () {
		if (($scope.masterExtract.extract.report.allowExclude && !$scope.masterExtract.id) || (!$scope.masterExtract.extract.file)) {
			reportRepository.downloadExtractFile($scope.masterExtract.extract).then(function(data) {
				
				var a = document.createElement('a');
				a.href = data.file;
				a.target = '_blank';
				a.download = data.name;
				document.body.appendChild(a);
				a.click();
			}, function(erorr) {
				addAlert('Failed to download report ' + $scope.masterExtract.extract.report.description + ': ' + erorr, 'danger');
			});
		} else {
			reportRepository.downloadExtract($scope.masterExtract.extract.file).then(function (data) {

				var a = document.createElement('a');
				a.href = data.file;
				a.target = '_blank';
				a.download = data.name;
				document.body.appendChild(a);
				a.click();
			}, function (erorr) {
				addAlert('Failed to download report ' + $scope.masterExtract.extract.report.description + ': ' + erorr, 'danger');
			});
		}
		
	};


});
