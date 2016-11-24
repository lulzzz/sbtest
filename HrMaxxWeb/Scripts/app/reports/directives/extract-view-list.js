'use strict';

common.directive('extractViewList', ['zionAPI', '$timeout', '$window', 'version', '$uibModal',
	function (zionAPI, $timeout, $window, version, $modal) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				report: "=?report",
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/extract-view-list.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'reportRepository', 'ngTableParams',
				function ($scope, $element, $location, $filter, reportRepository, ngTableParams) {
					var dataSvc = {
						reports:[
						{
							name: 'Federal940',
							desc: 'Federal 940'
						},
						{
							name: 'Federal941',
							desc: 'Federal 941'
						},
						{
							name: 'StateCAPIT',
							desc: 'California State PIT & SDI'
						},
						{
							name: 'StateCAUI',
							desc: 'California State UI & ETT'
						}],
						isBodyOpen: true
					}
					$scope.selectedReport = null;
					$scope.list = [];
					
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = false;
					$scope.mainData.showCompanies = false;


					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};

					$scope.selected = null;

					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						sorting: {
							lastModified: 'desc'     // initial sorting
						}
					}, {
						total: $scope.list ? $scope.list.length : 0, // length of data
						getData: function ($defer, params) {
							$scope.fillTableData(params);
							$defer.resolve($scope.tableData);
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
						
					}

					$scope.set = function (item) {
						$scope.selected = null;
						$timeout(function () {
							var history = [];
							$.each($scope.list, function(i, it) {
								if (it.extract.report.depositDate < item.extract.report.depositDate) {
									history.push(it);
								}
							});
							item.extract.data.history = history;
							//$scope.selected = angular.copy(item);
							var modalInstance = $modal.open({
								templateUrl: 'popover/extractView.html',
								controller: 'extractViewCtrl',
								size: 'lg',
								windowClass: 'my-modal-popup',
								backdrop: true,
								keyboard: true,
								backdropClick: true,
								resolve: {
									extract: function () {
										return item.extract;
									},
									item: function () {
										return item;
									},
									reportRepository: function () {
										return reportRepository;
									}
								}
							});
							
						}, 1);
						
						
						
					}
				
					var getExtracts = function (report) {
						reportRepository.getExtractList(report.name).then(function (data) {
							$scope.list = data;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);

						}, function (error) {
							$scope.addAlert('error getting extract list for report: ' + report.desc, 'danger');
						});
					}
				
					$scope.reportChanged = function() {
						if ($scope.selectedReport) {
							getExtracts($scope.selectedReport);
						}
					}
					$scope.downloadFile = function () {
						reportRepository.downloadExtract($scope.selected.extract.file).then(function (data) {

							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
						}, function (erorr) {
							addAlert('Failed to download report ' + $scope.selected.extract.report.description + ': ' + erorr, 'danger');
						});
					};
					var init = function () {
						var querystring = $location.search();
						if (querystring.report) {
							var r = $filter('filter')(dataSvc.reports, { name: querystring.report })[0];
							if (r) {
								$scope.selectedReport = r;
								$scope.reportChanged();
							}
						} else {
							if ($scope.report) {
								var r = $filter('filter')(dataSvc.reports, { name: $scope.report })[0];
								if (r) {
									$scope.selectedReport = r;
									$scope.reportChanged();
								}
							}
						}


					}
					init();


				}]
		}
	}
]);
