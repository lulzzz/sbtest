'use strict';

common.directive('payrollRegister', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/payroll-register.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'payrollRepository', 'NgTableParams', 'EntityTypes', 'commonRepository', 'reportRepository',
				function ($scope, $element, $location, $filter, payrollRepository, ngTableParams, EntityTypes, commonRepository, reportRepository) {
					var dataSvc = {
						
						isBodyOpen: true,
						response: null,
						filtername:''
					}
				
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;


					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					
					$scope.selected = null;

					$scope.tableData = [];
					
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 50,

						filter: {
							isVoid: false,       // initial filter
						},
						sorting: {
							payDay: 'desc'     // initial sorting
						}
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
							var fil = params.filter();
							var checkvoids = false;
							if (fil.isVoid) {
								checkvoids = true;
								delete fil.isVoid;
							}
							var orderedData = params.filter() ?
																$filter('filter')($scope.list, params.filter()) :
																$scope.list;
							if (checkvoids) {
								fil.isVoid = true;
							}
							
							orderedData = params.sorting() ?
														$filter('orderBy')(orderedData, params.orderBy()) :
														orderedData;
							updateTotals(orderedData);
							
							$scope.tableParams = params;
							$scope.tableData = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count());

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					var updateTotals = function (list) {
						var totalGross = 0;
						var totalNet = 0;
						var totalTaxes = 0;
						var totalChecks = 0;
						$.each(list, function (index, item) {
							totalChecks += 1;
							totalGross += +item.grossWage.toFixed(2);
							totalNet += +item.netWage.toFixed(2);
							totalTaxes += +(item.employeeTaxes + item.employerTaxes).toFixed(2);
						});
						dataSvc.totalGross = totalGross;
						dataSvc.totalNet = totalNet;
						dataSvc.totalTaxes = totalTaxes;
						dataSvc.totalChecks = totalChecks;
					}
				
					$scope.getReport = function () {
						var m = $scope.mainData;
						var request = {
							reportName: 'PayrollRegister',
							hostId: m.selectedHost.id,
							companyId: m.selectedCompany.id,
							year: m.reportFilter.filter.year,
							quarter: m.reportFilter.filter.quarter,
							month: m.reportFilter.filter.month,
							startDate: m.reportFilter.filterStartDate,
							endDate: m.reportFilter.filterEndDate
						}
						reportRepository.getReport(request).then(function (data) {
							$scope.list = data.payChecks;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							
						}, function (error) {
							addAlert('error getting report ' + request.reportName + ': ' + error.statusText, 'danger');
						});
					}
					$scope.print = function (listitem) {
						payrollRepository.printPayCheck(listitem.documentId, listitem.id).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
							if (listitem.status === 3 || listitem.status === 5) {
								payrollRepository.markPayCheckPrinted(listitem.id).then(function () {
									listitem.status = listitem.status === 3 ? 4 : 6;
									listitem.statusText = listitem.status === 4 ? "Paid" : "Printed and Paid";
									

								}, function (error) {
									addAlert('error marking pay check as printed', 'danger');
								});
							}


						}, function (error) {
							addAlert('error printing pay check', 'danger');
						});
					}
					$scope.$watch('mainData.selectedCompany',
						 function (newValue, oldValue) {
						 	if (newValue !== oldValue) {
						 		if ($scope.mainData.reportFilter.filterStartDate)
						 			$scope.getReport();
							 }

						 }, true
				 );
				


				}]
		}
	}
]);
