'use strict';

common.directive('depositCoupons', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/deposit-coupons.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'payrollRepository', 'reportRepository',
				function ($scope, $element, $location, $filter, payrollRepository, reportRepository) {
					var dataSvc = {

						isBodyOpen: true,
						response: null,
						filter1: {
							reportType: 0,
							startDate: null,
							endDate: null,
							includeHistory: false
						},
						filter2: {
							reportType: 1,
							startDate: null,
							endDate: null,
							includeHistory: false
						}
					}
					
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;


					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};

					$scope.getReport1 = function() {
						getReport('Federal8109B_'+dataSvc.filter1.reportType, 'Federal Deposit Coupon', dataSvc.filter1.startDate, dataSvc.filter1.endDate, dataSvc.filter1.includeHistory);
					}
					$scope.getReport2 = function () {
						getReport('CaliforniaDE88_' + dataSvc.filter2.reportType, 'California Deposit Coupon', dataSvc.filter2.startDate, dataSvc.filter2.endDate, dataSvc.filter2.includeHistory);
					}
					
					var getReport = function(reportName, desc, startDate, endDate, includeHistory) {
						var m = $scope.mainData;
						var request = {
							reportName: reportName,
							hostId: m.selectedHost.id,
							companyId: m.selectedCompany.id,
							year: 0,
							quarter: null,
							month: null,
							startDate:startDate,
							endDate: endDate,
							includeHistory: includeHistory
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
