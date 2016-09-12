'use strict';

common.directive('incomeStatement', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/income-statement.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'payrollRepository', 'reportRepository', 
				function ($scope, $element, $location, $filter, payrollRepository, reportRepository) {
					var dataSvc = {

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
							reportName: 'IncomeStatement',
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
							
						}, function (erorr) {
							addAlert('error getting report ' + request.reportName, 'danger');
						});
					}
					$scope.netIncome = function() {
						if (dataSvc.response && dataSvc.response.accountDetails.length > 0) {
							var income = $filter('filter')(dataSvc.response.accountDetails, { type: 4 })[0];
							var expense = $filter('filter')(dataSvc.response.accountDetails, { type: 3 })[0];
							return +(income.balance - expense.balance).toFixed(2);
						} else {
							return 0;
						}
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
