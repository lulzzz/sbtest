'use strict';

common.directive('balanceSheet', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/balance-sheet.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'payrollRepository', 'reportRepository', 
				function ($scope, $element, $location, $filter, payrollRepository, reportRepository) {
					var dataSvc = {
						assets: null,
						liabilities: null,
						equity: null,
						isBodyOpen: true,
						response: null

					}


					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;
					

					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};

					$scope.getReport = function () {
						var m = $scope.mainData;
						var request = {
							reportName: 'BalanceSheet',
							hostId: m.selectedHost.id,
							companyId: m.selectedCompany.id,
							year: m.reportFilter.filter.year,
							quarter: m.reportFilter.filter.quarter,
							month: m.reportFilter.filter.month,
							startDate: m.reportFilter.filterStartDate,
							endDate: m.reportFilter.filterEndDate
						}
						reportRepository.getReport(request).then(function (data) {
							dataSvc.response = data;
							dataSvc.assets = $filter('filter')(data.accountDetails, { type: 1 })[0];
							dataSvc.liabilities = $filter('filter')(data.accountDetails, { type: 5 })[0];
							dataSvc.equity = $filter('filter')(data.accountDetails, { type: 2 })[0];
						}, function (error) {
							addAlert('error getting report ' + request.reportName + ': ' + error.statusText, 'danger');
						});
					}
				
					$scope.$watch('mainData.selectedCompany',
						 function (newValue, oldValue) {
						 	if (newValue !== oldValue) {
								if($scope.mainData.reportFilter.filterStartDate)
						 			$scope.getReport();
						 	}

						 }, true
				 );
			
			}]
		}
	}
]);
