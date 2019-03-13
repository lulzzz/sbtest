﻿'use strict';

common.directive('workerCompensationReport', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/worker-compensation-report.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'payrollRepository', 'reportRepository', 'NgTableParams',
				function ($scope, $element, $location, $filter, payrollRepository, reportRepository, ngTableParams) {
					var dataSvc = {

						isBodyOpen: true,
						response: null

					}


					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;
					$scope.showincludeclients = (!$scope.mainData.selectedCompany.fileUnderHost && $scope.mainData.selectedCompany.hasLocations) || ($scope.mainData.selectedCompany.fileUnderHost && $scope.mainData.selectedCompany.isHostCompany && $scope.mainData.selectedCompany.id === $scope.mainData.selectedHost.companyId && $scope.mainData.selectedHost.isPeoHost) ? true : false;
					$scope.showIncludeTaxDelayed = $scope.mainData.selectedCompany.contract.contractOption === 2 && $scope.mainData.selectedCompany.contract.billingOption === 3;

					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};

					$scope.getReport = function () {
						var m = $scope.mainData;
						var request = {
							reportName: 'WorkerCompensations',
							hostId: m.selectedHost.id,
							companyId: m.selectedCompany.id,
							year: m.reportFilter.filter.year,
							quarter: m.reportFilter.filter.quarter,
							month: m.reportFilter.filter.month,
							startDate: m.reportFilter.filterStartDate,
							endDate: m.reportFilter.filterEndDate,
							includeHistory: m.reportFilter.filter.includeHistory,
							includeClients: m.reportFilter.filter.includeClients,
							includeTaxDelayed: m.reportFilter.filter.includeTaxDelayed
						}
						reportRepository.getReport(request).then(function (data) {
							dataSvc.response = data;
							
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
					$scope.set  = function(wc) {
						$scope.selected = wc;
						$scope.selectedemployee = null;
						$scope.employeepaychecks = [];
						$scope.list = $filter('workercompensation')(dataSvc.response.employeeAccumulationList, wc.workerCompensationId);
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
					}
					$scope.viewDetails = function(wc) {
						$scope.selectedemployee = wc;
						$scope.employeepaychecks = $filter('filter')(wc.payChecks, { workerCompensation: { workerCompensation: { id: $scope.selected.workerCompensation.id } } });
					}
					$scope.selected = null;
					$scope.selectedemployee = null;
					$scope.employeepaychecks = [];
					$scope.list = [];
					$scope.tableData = [];

					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 50,
						
					}, {
						total: $scope.list ? $scope.list.length : 0, // length of data
						getData: function (params) {
							$scope.fillTableData(params);
							return ($scope.tableData);
						}
					});

					$scope.fillTableData = function (params) {
						// use build-in angular filter
						if ($scope.list && $scope.list.length > 0) {
							
							var orderedData = params.filter() ?
																$filter('filter')($scope.list, params.filter()) :
																$scope.list;
							
							orderedData = params.sorting() ?
														$filter('orderBy')(orderedData, params.orderBy()) :
														orderedData;
							
							
							$scope.tableParams = params;
							$scope.tableData = orderedData;

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					


			}]
		}
	}
]);
