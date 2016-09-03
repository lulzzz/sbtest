'use strict';

common.directive('userNews', ['zionAPI', '$timeout', '$window',
	function (zionAPI, $timeout, $window) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				heading: "=heading",
				fetch: "=fetch"
			},
			templateUrl: zionAPI.Web + 'Content/templates/usernews.html',

			controller: ['$scope', '$element', '$location', '$filter', 'commonRepository', 'ngTableParams', 'EntityTypes', function ($scope, $element, $location, $filter, commonRepository, ngTableParams, EntityTypes) {
				$scope.list = [];
				
				var addAlert = function (error, type) {
					$scope.alerts = [];
					$scope.alerts.push({
						msg: error,
						type: type
					});
				};
				$scope.closeAlert = function (index) {
					$scope.alerts.splice(index, 1);
				};
				$scope.selectedNewsItem = null;

				$scope.tableData = [];
				$scope.tableParams = new ngTableParams({
					page: 1,            // show first page
					count: 10,

					sorting: {
						timeStamp: 'desc'     // initial sorting
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
					if ($scope.list && $scope.list.length>0) {
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
				$scope.cancel=function() {
					$scope.selectedNewsItem = null;
				}
				$scope.setSelectedNewsItem = function(item) {
					$scope.selectedNewsItem = item;
				}
				
				var init = function () {
					commonRepository.getUserNews().then(function (data) {
							$scope.list = data;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
						}, function (erorr) {

						});
					}
				init();

			}]
		}
	}
]);
