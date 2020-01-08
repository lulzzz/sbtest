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
							id: 'desc'     // initial sortingf.
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
								$scope.mainData.handleError('Failed to download report ' + $scope.masterExtract.extract.report.description + ': ' , erorr, 'danger');
						});
					};
					$scope.selectedHost = null;
					$scope.set = function (host) {
						
						$scope.selectedHost = host;
						
					}
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = false;
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;

				
					$scope.getReport = function (event) {
						event.stopPropagation();
						reportRepository.getProfitStarsPayroll().then(function (data) {
							$scope.list = data;
							$scope.tableParams.reload();
							
							$scope.fillTableData($scope.tableParams);
							dataSvc.showPayrolls = true;

						}, function (erorr) {
							dataSvc.extract = null;
								$scope.mainData.handleError('Error getting Profit Stars Payroll List: ' , erorr, 'danger');
						});
					}
					$scope.showBankDetails = function (listitem) {
						var modalInstance = $modal.open({
							templateUrl: 'popover/bankdetails.html',
							controller: 'bankDetailsCtrl',
							size: 'sm',
							windowClass: 'my-modal-popup',
							resolve: {
								bank: function () {
									return listitem;
								}
							}
						});
					}
					$scope.run1pm = function (event) {
						dataSvc.show9am = false;
						reportRepository.run1pm().then(function (data) {
							if (data.length > 0) {
								dataSvc.show1pm = true;
								dataSvc.onePmResult = data;
							} else {
								dataSvc.show1pm = false;
								$scope.mainData.showMessage('No funding or payment requests found to be sent to ProfitStars', 'warning');
                            }
                            $scope.getReport(event);

                        }, function (erorr) {
							dataSvc.extract = null;
								$scope.mainData.handleError('Error running 1 pm service: ' , erorr, 'danger');
						});
					}
					$scope.run9am = function (event) {
						dataSvc.show1pm = false;
						reportRepository.run9am().then(function (data) {
							if (data.resultCode!=='') {
								dataSvc.show9am = true;
								dataSvc.nineAmResult = data;
							} else {
								dataSvc.show9am = false;
								$scope.mainData.showMessage('No data found. please check email for any errors', 'warning');
                            }
                            $scope.getReport(event);
						}, function (erorr) {
							dataSvc.extract = null;
								$scope.mainData.handleError('Error running 9 am service: ' , erorr, 'danger');
						});
					}
					$scope.markSettled = function (item, event) {
						event.stopPropagation();
						reportRepository.markSettled(item.fundRequestId).then(function (data) {
							$scope.mainData.showMessage('manually marked funding successful: ', 'success');
							$scope.list = data;
							$scope.tableParams.reload();

							$scope.fillTableData($scope.tableParams);
							dataSvc.showPayrolls = true;
						}, function (erorr) {
								$scope.mainData.handleError('Error updating fund request to settled: ' , erorr, 'danger');
						});
					}
					
					
					var _init = function () {
						
					}
					_init();
					
				}]
		}
	}
]);
