'use strict';

common.directive('payCheckList', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData",
				employee: "=employee"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/paycheck-list.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'NgTableParams', 'EntityTypes', 'payrollRepository', '$anchorScroll', 'anchorSmoothScroll',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, payrollRepository, $anchorScroll, anchorSmoothScroll) {
					var dataSvc = {
						sourceTypeId: EntityTypes.Employee,
						isBodyOpen: true
					}
					$scope.list = [];

					$scope.alerts = [];
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;


					$scope.addAlert = function (error, type) {
						$scope.alerts = [];

						$scope.alerts.push({message: error, type: type});
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
							$scope.tableData = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count());

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					$scope.cancel = function () {
						$scope.selected = null;
						dataSvc.isBodyOpen = true;
					}
					
					$scope.set = function (item) {
						$scope.selected = null;
						if (item) {
							$timeout(function () {
								$scope.selected = item;
								dataSvc.isBodyOpen = false;
							}, 1);
						}

					}
					$scope.markPrinted = function () {
						payrollRepository.printPayCheck($scope.selected.documentId, $scope.selected.id).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();

							
						}, function (error) {
							addAlert('error printing pay check', 'danger');
						});
					}
					var getPaychecks = function (companyId, employeeId) {
						payrollRepository.getPaycheckList(companyId, employeeId).then(function (data) {
							$scope.list = data;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							$scope.selected = null;
							
							
						}, function (error) {
							$scope.addAlert('error getting pay checks', 'danger');
						});
					}
					

					var init = function () {

						if ($scope.mainData.selectedCompany) {
							getPaychecks($scope.mainData.selectedCompany.id, $scope.employee.id, null, null);

						}


					}
					init();


				}]
		}
	}
]);
