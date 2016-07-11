﻿'use strict';

hostmodule.directive('hostList', ['$modal', 'zionAPI', '$timeout', '$window',
	function ($modal, zionAPI, $timeout, $window) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				heading: "=heading",
				selected: "=?selected"
			},
			templateUrl: zionAPI.Web + 'Areas/Administration/templates/host-list.html',

			controller: ['$scope', '$element', '$location', '$filter', 'hostRepository', 'ngTableParams', 'EntityTypes',
				function ($scope, $element, $location, $filter, hostRepository, ngTableParams, EntityTypes) {
				$scope.sourceTypeId = EntityTypes.Host;
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
				$scope.selectedHost = null;
					$scope.isBodyOpen = true;
				$scope.addHost = function () {
					$scope.selectedHost = {
						statusId: 1
					};
				}

				$scope.tableData = [];
				$scope.tableParams = new ngTableParams({
					page: 1,            // show first page
					count: 10,

					filter: {
						firmName: '',       // initial filter
					},
					sorting: {
						firmName: 'asc'     // initial sorting
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
					$scope.selectedHost = null;
					$scope.isBodyOpen = true;
				}
				
				$scope.setSelectedHost = function (item) {
					$scope.selectedHost = null;
					$timeout(function () {
						$scope.selectedHost = angular.copy(item);
						$scope.selectedHost.sourceTypeId = $scope.sourceTypeId;
						$scope.isBodyOpen = false;
					}, 1);
					
					
				}
				$scope.getRowClass = function(item) {
					if ($scope.selectedHost && $scope.selectedHost.id === item.id)
						return 'success';
					else {
						return 'default';
					}
				}
			
				$scope.save = function () {
					hostRepository.saveHost($scope.selectedHost).then(function (result) {
						
						var exists = $filter('filter')($scope.list, { id:result.id });
						if (exists.length === 0) {
							$scope.list.push(result);
						} else {
							$scope.list.splice($scope.list.indexOf(exists[0]), 1);
							$scope.list.push(result);
						}
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						$scope.selectedHost = null;
						$scope.isBodyOpen = true;
						addAlert('successfully saved Host', 'success');
					}, function (error) {
						addAlert('error saving Host', 'danger');
					});
				}
				var init = function () {
					if (!$scope.selected) {
						var querystring = $location.search();
						hostRepository.getHostList().then(function (data) {
							$scope.list = data;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							if (querystring.host) {
								var selected = $filter('filter')($scope.list, { firmName: querystring.host });
								if (selected.length > 0) {
									$scope.setSelectedHost(selected[0]);
								}
							}
						}, function (erorr) {

						});
					} else {
						hostRepository.getMyHost().then(function(data) {
							$scope.setSelectedHost(data);
						}, function(error) {
							addAlert('Error getting the host', 'danger');
						});
					}
					
				}
				init();

			}]
		}
	}
]);
