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
						filterde7: {
							year: 0,
							quarter: 0,
							includeHistory: true,
							includeClients: false
						},
						filterde6: {
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
						}
					}
					$scope.showincludeclients = (!$scope.mainData.selectedCompany.fileUnderHost && $scope.mainData.selectedCompany.hasLocations) || ($scope.mainData.selectedCompany.fileUnderHost && $scope.mainData.selectedHost.isPeoHost) ? true : false;
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
					$scope.getReport1099 = function () {
						getReport('Report1099', '1099', dataSvc.filter1099.year, null, dataSvc.filter1099.includeHistory);
					}
					$scope.getReportDE6 = function () {
						getReport('CaliforniaDE6', 'California DE 6', dataSvc.filterde6.year, dataSvc.filterde6.quarter, dataSvc.filterde6.includeHistory, dataSvc.filterde6.includeClients);
					}
					$scope.getReportDE7 = function () {
						getReport('CaliforniaDE7', 'California DE 7', dataSvc.filterde7.year, null, dataSvc.filterde7.includeHistory, dataSvc.filterde7.includeClients);
					}
					$scope.getReportDE9 = function () {
						getReport('CaliforniaDE9', 'California DE 9', dataSvc.filterde9.year, dataSvc.filterde9.quarter, dataSvc.filterde9.includeHistory, dataSvc.filterde9.includeClients);
						getReport('CaliforniaDE9C', 'California DE 9C', dataSvc.filterde9.year, dataSvc.filterde9.quarter, dataSvc.filterde9.includeHistory, dataSvc.filterde9.includeClients);
					}
					$scope.getReportC1095 = function () {
						getReport('C1095', 'Federal 1095-C', dataSvc.filterC1095.year, null, dataSvc.filterC1095.includeHistory, dataSvc.filterC1095.includeClients);
					}

					var getReport = function(reportName, desc, year, quarter, includeHistory, includeClients) {
						var m = $scope.mainData;
						var request = {
							reportName: reportName,
							hostId: m.selectedHost.id,
							companyId: m.selectedCompany.id,
							year: year,
							quarter: quarter,
							month: null,
							startDate:null,
							endDate: null,
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
					$scope.hasCalifornia = function() {
						var comp = $scope.mainData.selectedCompany;
						if (comp) {
							var cal = $filter('filter')(comp.states, { state : { stateId: 1 } });
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
