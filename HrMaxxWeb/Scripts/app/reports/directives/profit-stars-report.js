'use strict';
common.directive('profitStarsReport', ['zionAPI', '$timeout', '$window', 'version', '$uibModal',
	function (zionAPI, $timeout, $window, version, $modal) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/profit-stars-report.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'reportRepository', 'NgTableParams',
				function ($scope, $element, $location, $filter, reportRepository, ngTableParams) {
					var dataSvc = {
						startDate: null,
						endDate: null,
						postingDate: moment().toDate(),
						extract: null,
						extractFiled: false,
						isBodyOpen: true,
						showPayrolls: false,
						show1pm: false,
						show9am: false,
						onePmResult: null,
						nineAmResult: null
				}
					
					$scope.list = [];
					$scope.selected = null;
					$scope.toggleAll = function() {
						$.each($scope.selectedHost.achTransactions, function(i, t) {
							t.included = $scope.selectedHost.toggleState;
						});
					}
					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						sorting: {
							lastModified: 'desc'     // initial sortingf.
						}
					}, {
						total: $scope.list ? $scope.list.length : 0, // length of data
						getData: function ( params) {
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
							$scope.tableData = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count());

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					
					$scope.downloadFile = function () {
						reportRepository.downloadExtract(dataSvc.extract.file).then(function (data) {

							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
						}, function (erorr) {
							addAlert('Failed to download report ' + $scope.masterExtract.extract.report.description + ': ' + erorr, 'danger');
						});
					};
					$scope.selectedHost = null;
					$scope.set = function (host) {
						
						$scope.selectedHost = host;
						
					}
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = false;
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;

					
					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
				
					$scope.getReport = function (event) {
						event.stopPropagation();
						reportRepository.getProfitStarsPayroll().then(function (data) {
							$scope.list = data;
							$scope.tableParams.reload();
							
							$scope.fillTableData($scope.tableParams);
							dataSvc.showPayrolls = true;

						}, function (erorr) {
							dataSvc.extract = null;
							addAlert('Error getting Profit Stars Payroll List: ' + erorr.statusText, 'danger');
						});
					}
					$scope.run1pm = function () {
						dataSvc.show9am = false;
						reportRepository.run1pm().then(function (data) {
							if (data.length > 0) {
								dataSvc.show1pm = true;
								dataSvc.onePmResult = data;
							} else {
								dataSvc.show1pm = false;
								addAlert('No funding or payment requests found to be sent to ProfitStars', 'warning');
							}
							
						}, function (erorr) {
							dataSvc.extract = null;
							addAlert('Error running 1 pm service: ' + erorr.statusText, 'danger');
						});
					}
					$scope.run9am = function () {
						dataSvc.show1pm = false;
						reportRepository.run9am().then(function (data) {
							if (data.resultCode!=='') {
								dataSvc.show9am = true;
								dataSvc.nineAmResult = data;
							} else {
								dataSvc.show9am = false;
								addAlert('No data found. please check email for any errors', 'warning');
							}
						}, function (erorr) {
							dataSvc.extract = null;
							addAlert('Error running 9 am service: ' + erorr.statusText, 'danger');
						});
					}
					
					
					var _init = function () {
						
					}
					_init();
					
				}]
		}
	}
]);
