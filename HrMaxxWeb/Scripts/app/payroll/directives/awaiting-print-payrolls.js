'use strict';

common.directive('awaitingPrintPayrollList', ['$uibModal', 'zionAPI', '$timeout', '$window', 'version',
	function ($modal, zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/awaiting-print-payroll-list.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'NgTableParams', 'EntityTypes', 'payrollRepository',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, payrollRepository) {
					var dataSvc = {
						isBodyOpen: true,

						
					}
					$scope.list = [];


					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = false;
					

					$scope.addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};

					$scope.selected = null;


					
					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						sorting: {
							payDay: 'desc'     // initial sorting
						}
					}, {
						total: $scope.list ? $scope.list.length : 0, // length of data
						getData: function (params) {
							$scope.fillTableData(params);
							return $scope.tableData;
						}
					});
					if ($scope.tableParams.settings().$scope == null) {
						$scope.tableParams.settings().$scope = $scope;
					}
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
					
					
					var getPayrolls = function () {
						payrollRepository.getUnPrintedPayrollList().then(function (data) {
							$scope.list = data;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							
						}, function (error) {
							$scope.addAlert('error getting un printed payrolls', 'danger');
						});
					}
					
					
					$scope.printPayroll = function (payroll) {
						payrollRepository.printPayrollChecks(payroll).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
							payroll.status = 5;
							payroll.statusText = 'Printed';
							var listItem = $filter('filter')($scope.list, { id: payroll.id })[0];
							if (listItem) {
								listItem.status = 5;
								listItem.statusText = 'Printed';
							}
						}, function (error) {
							$scope.addAlert('error printing pay check', 'danger');
						});
					}
					$scope.isPrintable = function (payroll) {
						var nonVoids = $filter('filter')(payroll.payChecks, { isVoid: false });
						if (nonVoids.length > 0)
							return true;
						else {
							return false;
						}
					}
					$scope.refreshData = function(event) {
						event.stopPropagation();
						getPayrolls();
					}
					var init = function () {

						getPayrolls();


					}
					init();


				}]
		}
	}
]);
