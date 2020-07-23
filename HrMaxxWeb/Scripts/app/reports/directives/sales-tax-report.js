'use strict';

common.directive('salesTaxReport', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/sales-tax-report.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'payrollRepository', 'reportRepository', 'NgTableParams',
				function ($scope, $element, $location, $filter, payrollRepository, reportRepository, ngTableParams) {
					var dataSvc = {

						isBodyOpen: true,
						response: null,
						startDate: moment().subtract(1, 'month').startOf('month').toDate() ,
						endDate: moment().subtract(1, 'month').endOf('month').toDate(),
						hostHomePage: null
						
					}
					
					$scope.mainData.reportFilter.filterStartDate = dataSvc.startDate;
					$scope.mainData.reportFilter.filterEndDate = dataSvc.endDate;
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;
					dataSvc.hostHomePage = $scope.mainData.selectedHost.homePage;

					
					$scope.getHostLogo = function () {
						if (dataSvc.hostHomePage && dataSvc.hostHomePage.logo) {
							var photo = dataSvc.hostHomePage.logo;
							return zionAPI.URL + 'DocumentById/' + photo.id + '/' + photo.documentExtension + '/' + photo.documentName;
						} else {
							return "https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg";
						}
					}
					$scope.showResponse = function() {
						if (dataSvc.response && dataSvc.response.companyId === $scope.mainData.selectedCompany.id && moment(dataSvc.startDate).format("MM/DD/YYYY") === moment(dataSvc.response.startDate).format("MM/DD/YYYY") && moment(dataSvc.endDate).format("MM/DD/YYYY") === moment(dataSvc.response.endDate).format("MM/DD/YYYY"))
							return true;
						else {
							return false;
						}
					}
					$scope.print1 = function () {
						$.each($scope.list, function (i, inv) {
							inv.isOpen = false;
						});
						$window.print();
					}
					
					$scope.tableData = [];

					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 50,

						filter: {
							isVoid: false,       // initial filter
						},
						sorting: {
							invoiceDate: 'desc'     // initial sorting
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
					$scope.getReport = function () {
						var m = $scope.mainData;
						var request = {
							reportName: 'SalesTaxReport',
							hostId: m.selectedHost.id,
							companyId: m.selectedCompany.id,
							year: m.reportFilter.filter.year,
							quarter: m.reportFilter.filter.quarter,
							month: m.reportFilter.filter.month,
							startDate: m.reportFilter.filterStartDate,
							endDate: m.reportFilter.filterEndDate,
							includeHistory: m.reportFilter.filter.includeHistory,
							includeClients: m.reportFilter.filter.includeClients
						}
						reportRepository.getReport(request).then(function (data) {
							$scope.list = data.companyInvoices;
							var am = 0;
							$.each($scope.list, function (i, inv) {
								am += inv.salesTax;
							});
							$scope.totalTax = am;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);

						}, function (error) {
							$scope.mainData.handleError('error getting report ' + request.reportName + ': ', error, 'danger');
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
