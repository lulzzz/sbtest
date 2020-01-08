'use strict';

common.directive('payrollSummary', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/payroll-summary.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'payrollRepository', 'reportRepository',
				function ($scope, $element, $location, $filter, payrollRepository, reportRepository) {
					var dataSvc = {

						isBodyOpen: true,
						response: null

					}


					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;
					$scope.showincludeclients = (!$scope.mainData.selectedCompany.fileUnderHost && $scope.mainData.selectedCompany.hasLocations) || ($scope.mainData.selectedCompany.fileUnderHost && $scope.mainData.selectedCompany.isHostCompany && $scope.mainData.selectedCompany.id === $scope.mainData.selectedHost.companyId && $scope.mainData.selectedHost.isPeoHost) ? true : false;
					$scope.showIncludeTaxDelayed = $scope.mainData.selectedCompany.contract.contractOption === 2 && $scope.mainData.selectedCompany.contract.billingOption === 3;

					$scope.selected = null;
					$scope.print = function () {
						$window.print();
					}
					$scope.getReport = function () {
						var m = $scope.mainData;
						var request = {
							reportName: 'PayrollSummary',
							hostId: m.selectedHost.id,
							companyId: m.selectedCompany.id,
							year: m.reportFilter.filter.year,
							quarter: m.reportFilter.filter.quarter,
							month: m.reportFilter.filter.month,
							startDate: m.reportFilter.filterStartDate,
							endDate: m.reportFilter.filterEndDate,
							includeHistory: m.reportFilter.filter.includeHistory,
							includeClients: m.reportFilter.filter.includeClients,
							includeClientEmployees: m.reportFilter.filter.includeClientEmployees,
							includeTaxDelayed: m.reportFilter.filter.includeTaxDelayed
						}
						reportRepository.getReport(request).then(function (data) {
							dataSvc.response = data;
							
						}, function (error) {
							dataSvc.response = null;
								$scope.mainData.handleError('error getting report ' + request.reportName + ': ' , error , 'danger');
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
