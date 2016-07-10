'use strict';

common.directive('newsList', ['$modal', 'zionAPI', '$timeout', '$window',
	function ($modal, zionAPI, $timeout, $window) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				audienceTypeId: "=audienceTypeId",
				audienceId: "=audienceId",
				heading: "=heading",
				fetch: "=fetch"
			},
			templateUrl: zionAPI.Web + 'Content/templates/news-list.html',

			controller: ['$scope', '$element', '$location', '$filter', 'commonRepository', 'ngTableParams', 'EntityTypes', function ($scope, $element, $location, $filter, commonRepository, ngTableParams, EntityTypes) {
				$scope.list = [];
				$scope.targetAudience = [];
				$scope.selectedAudience = [];
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

				$scope.addNew = function () {
					$scope.selectedNewsItem = {
						title:'',
						newsContent: '',
						audienceScope: $scope.audienceTypeId,
						audience: []
					};
					if($scope.audienceId)
						$scope.selectedNewsItem.audience.push($scope.audienceId);
				}
				$scope.setTargetAudience = function () {
					$scope.targetAudience = [];
					$scope.selectedNewsItem.audience = [];
					if (parseInt($scope.selectedNewsItem.audienceScope) === 3) {
						$scope.targetAudience = angular.copy($scope.metadata.hosts);
					}
				}
			
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
				$scope.setSelectedNewsItem = function (item) {
					$scope.selectedNewsItem = item;
				}
				$scope.getRowClass = function(item) {
					if ($scope.selectedContact && $scope.selectedContact.id === item.id)
						return 'success';
					else {
						return 'default';
					}
				}

				$scope.audienceEvents = {
					onItemSelect: function (item) {
						$scope.selectedNewsItem.audience.push($filter('filter')($scope.targetAudience, { key: item.id })[0]);
					},
					onItemDeselect: function (item) {
						$scope.selectedNewsItem.audience.splice($scope.selectedNewsItem.audience.indexOf($filter('filter')($scope.targetAudience, { key: item.id })[0]), 1);
					}
				};
				
				$scope.save = function () {
					commonRepository.saveNews($scope.selectedNewsItem).then(function (result) {
						if ($scope.selectedNewsItem.id) {
							$scope.list.splice($scope.list.indexOf($scope.selectedNewsItem), 1);
						} 
						$scope.list.push(result);
						
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						$scope.selectedNewsItem = null;
						addAlert('successfully saved news', 'success');
					}, function (error) {
						addAlert('error saving news', 'danger');
					});
				}
				var init = function () {
					commonRepository.getNewsfeedMetaData().then(function (data) {
						$scope.metadata = data;
						
					}, function (erorr) {
						addAlert('failed to load meta data for news', 'danger');
					});
					if ($scope.fetch) {
						commonRepository.getNewsfeed($scope.audienceTypeId, $scope.audienceId).then(function (data) {
							$scope.list = data;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
						}, function (erorr) {

						});
					}
					
				}
				init();

			}]
		}
	}
]);
