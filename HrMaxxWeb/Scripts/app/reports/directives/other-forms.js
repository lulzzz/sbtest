'use strict';

common.directive('otherForms', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/other-forms.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'payrollRepository', 'reportRepository',
				function ($scope, $element, $location, $filter, payrollRepository, reportRepository) {
					var dataSvc = {

						isBodyOpen: true,
						response: null,
						filter: {
							years: []
						},
						filterQA: {
							year : 0
						},
						filterMQA: {
							year : 0
						},
						responseEmployeeTaxJournal: null,
						responseEmployeeHourJournal: null,
						payrollSummary: null,
						currentView: null
						
					}
					var currentYear = new Date().getFullYear();
					for (var i = currentYear - 4; i <= currentYear; i++) {
						if(i>=2017)
						dataSvc.filter.years.push(i);
					}
					

					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;


					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};

					$scope.getReportQA = function() {
						getReport('QuarterAnnualReport', 'Quarter Annual Payroll Tax Report', dataSvc.filterQA.year, null);
					}
					$scope.getReportMQA = function () {
						getReport('MonthlyQuarterAnnualReport', 'Monthly Quarter Annual Payroll Tax Report', dataSvc.filterMQA.year,null);
					}
					$scope.getReportEmployeeJournalByCheck = function () {
						dataSvc.currentView = 1;
						$scope.mainData.reportFilter.filter.quarter = 0;
						$scope.mainData.reportFilter.filter.month = 0;
						$scope.getReportDisplay();
						
					}
					$scope.getReportEmployeeHourJournalByCheck = function () {
						
						dataSvc.currentView = 2;
						$scope.getReportDisplay();
						
					}
					
					var getReport = function(reportName, desc, year, quarter) {
						var m = $scope.mainData;
						var request = {
							reportName: reportName,
							hostId: m.selectedHost.id,
							companyId: m.selectedCompany.id,
							year: year,
							quarter: quarter,
							month: null,
							startDate:null,
							endDate: null
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
					$scope.getReportDisplay = function () {
						dataSvc.responseEmployeeTaxJournal = null;
						dataSvc.responseEmployeeHourJournal = null;
						var m = $scope.mainData;
						var request = {
							reportName: 'PayrollSummary',
							hostId: m.selectedHost.id,
							companyId: m.selectedCompany.id,
							year: m.reportFilter.filter.year,
							quarter: m.reportFilter.filter.quarter,
							month: m.reportFilter.filter.month,
							startDate: m.reportFilter.filterStartDate,
							endDate: m.reportFilter.filterEndDate
						}
						reportRepository.getReport(request).then(function (data) {
							dataSvc.payrollSummary = data;
							
							if (dataSvc.currentView === 1) {
								dataSvc.responseEmployeeTaxJournal = angular.copy(dataSvc.payrollSummary);
							}
							if (dataSvc.currentView === 2) {
								dataSvc.responseEmployeeHourJournal = angular.copy(dataSvc.payrollSummary);
							}

						}, function (erorr) {
							addAlert('Error getting report journals per employee : ' + erorr.statusText, 'danger');
						});
					}

					$scope.getTaxValue = function(pc, taxId) {
						var match = $filter('filter')(pc.taxes, { tax: { id: taxId } })[0];
						if (match)
							return match.amount;
						else {
							return 0;
						}
					}
					

			}]
		}
	}
]);
