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
						filter: {
							years: []
						},
						filter940: {
							year : 0
						},
						filter944: {
							year : 0
						},
						filterW2: {
							year : 0
						},
						filterW3: {
							year : 0
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
					var currentYear = new Date().getFullYear();
					for (var i = currentYear - 4; i <= currentYear; i++) {
						dataSvc.filter.years.push(i);
					}
					

					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = false;
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;


					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};

					$scope.getReport940 = function() {
						getReport('Paperless940', 'Paperless 940', dataSvc.filter940.year, null);
					}
					$scope.getReport941 = function () {
						getReport('Paperless941', 'Paperless 941', dataSvc.filter941.year, dataSvc.filter941.quarter);
					}
					$scope.getReport944 = function () {
						getReport('Federal944', 'Federal 944', dataSvc.filter944.year, null);
					}
					$scope.getReportW2Employee = function () {
						getReport('W2Employee', 'Federal W2 (Employee version)', dataSvc.filterW2.year, null);
					}
					$scope.getReportW2Employer = function () {
						getReport('W2Employer', 'Federal W2 (Employer version)', dataSvc.filterW2.year, null);
					}
					$scope.getReportW3 = function () {
						getReport('W3', 'Federal W3', dataSvc.filterW3.year, null);
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

					var getReport = function(reportName, desc, year, quarter) {
						var m = $scope.mainData;
						var request = {
							reportName: reportName,
							year: year,
							quarter: quarter,
							month: null,
							startDate:null,
							endDate: null
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
