﻿'use strict';

common.directive('hostList', ['zionAPI', '$timeout', '$window','version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				heading: "=heading",
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Administration/templates/host-list.html?v=' + version,

			controller: ['$scope', '$rootScope', '$element', '$location', '$filter', 'hostRepository', 'NgTableParams', 'EntityTypes',
				function ($scope, $rootScope, $element, $location, $filter, hostRepository, ngTableParams, EntityTypes) {
				$scope.sourceTypeId = EntityTypes.Host;
								
				$scope.selectedHost = null;
					$scope.isBodyOpen = true;
				$scope.addHost = function () {
					var newhost = {
						statusId: 1,
						isPeoHost: false,
						hostIntId: 0,
						firmName: ''
					};
					$scope.setSelectedHost(newhost);
				}
				
				$scope.mainData.showFilterPanel = false;
				$scope.mainData.showCompanies = false;

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
				$scope.refreshData = function (event) {
					event.stopPropagation();
					$scope.$parent.$parent.refreshHostAndCompanies();
				}
				$scope.setSelectedHost = function (item) {
					if (!item.id && !item.firmName) {
						$scope.selectedHost = item;
						$scope.isBodyOpen = false;

						$scope.tab = 1;
						//$rootScope.$broadcast('hostChanged', { host: $scope.selectedHost });
					} else {
						if (!$scope.selectedHost || $scope.selectedHost.id !== item.id) {
							$scope.selectedHost = null;
							hostRepository.getHost(item.id).then(function (data) {
								$scope.selectedHost = angular.copy(data);
								$scope.mainData.selectedHost = data;
								$scope.$parent.$parent.hostSelected();
								$scope.isBodyOpen = false;

								$scope.tab = 1;
								$rootScope.$broadcast('hostChanged', { host: $scope.selectedHost });
							}, function (erorr) {
								$scope.mainData.showMessage('error getting host details', 'danger');
							});
						}
					}
					
				}

				$scope.getRowClass = function(item) {
					if ($scope.selectedHost && $scope.selectedHost.id === item.id)
						return 'success';
					else {
						return 'default';
					}
				}
			
				$scope.save = function () {
					if (false === $('form[name="hostForm"]').parsley().validate())
						return false;
					if (!$scope.selectedHost.id) {
						var confirmMessage = "";
						if ($scope.selectedHost.isPeoHost) {
							confirmMessage = "This host will be saved as a PEO Host which cannot be changed later. Are you sure you want to proceed?";
						} else {
							confirmMessage = "This host will be saved as a Non-PEO Host which cannot be changed later. Are you sure you want to proceed?";
						}

						$scope.$parent.$parent.confirmDialog(confirmMessage, 'info', function () {
							saveHost();
						});
					} else {
						saveHost();
					}
					
					
				}
				var saveHost = function() {
					hostRepository.saveHost($scope.selectedHost).then(function (result) {

						var exists = $filter('filter')($scope.list, { id: result.id });
						if (exists.length === 0) {
							$scope.list.push(result);
						} else {
							$scope.list.splice($scope.list.indexOf(exists[0]), 1);
							$scope.list.push(result);
						}
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						$scope.selectedHost = null;
						$scope.mainData.selectedHost = null;
						$scope.isBodyOpen = true;
						$rootScope.$broadcast('hostUpdated', { host: result });
						$scope.mainData.showMessage('successfully saved Host', 'success');
					}, function (error) {
						$scope.mainData.showMessage('error saving Host', 'danger');
					});
				}
				var init = function () {
					if (!$scope.mainData.userHost) {
						var querystring = $location.search();
						$scope.list = $scope.mainData.hosts;
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						if ($scope.mainData.selectedHost) {
							var selected1 = $filter('filter')($scope.list, { id: $scope.mainData.selectedHost.id });
							if (selected1.length > 0) {
								$scope.setSelectedHost(selected1[0]);
							}
						}
						else if (querystring.host) {
							var selected = $filter('filter')($scope.list, { firmName: querystring.host });
							if (selected.length > 0) {
								$scope.setSelectedHost(selected[0]);
							}
						}
					} else {
						$scope.setSelectedHost($scope.mainData.selectedHost);
						
					}
					
				}
				init();

			}]
		}
	}
]);
