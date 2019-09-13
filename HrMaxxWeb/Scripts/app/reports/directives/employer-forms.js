'use strict';

common.directive('employerForms', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/employer-forms.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'payrollRepository', 'reportRepository',
				function ($scope, $element, $location, $filter, payrollRepository, reportRepository) {
					var dataSvc = {

						isBodyOpen: true,
						response: null,
						filterW4: {
							reportType:1
						},
						filterI9: {
							reportType:1
						},
						filterDE34: {
							hireDate: null,
							startDate: null,
							endDate: null
						}
					}
					
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;


					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};

					$scope.getReportW4 = function() {
						getReport('W4_'+dataSvc.filterW4.reportType, 'W4', 0, null, null, null);
					}
					$scope.getReportI9 = function () {
						getReport('I9_'+dataSvc.filterI9.reportType, 'I9', 0, null, null, null);
					}
					$scope.getReportDE34 = function () {
						getReport('CaliforniaDE34', 'California DE 34', 0, null, dataSvc.filterDE34.startDate, dataSvc.filterDE34.endDate);
					}
					
					var getReport = function(reportName, desc, year, quarter, date, enddate) {
						var m = $scope.mainData;
						var request = {
							reportName: reportName,
							hostId: m.selectedHost.id,
							companyId: m.selectedCompany.id,
							year: year,
							quarter: quarter,
							month: null,
							startDate:date,
							endDate: enddate
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
