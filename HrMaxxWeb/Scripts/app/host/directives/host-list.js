'use strict';

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

			controller: ['$scope', '$rootScope', '$element', '$location', '$filter', 'hostRepository', 'ngTableParams', 'EntityTypes',
				function ($scope, $rootScope, $element, $location, $filter, hostRepository, ngTableParams, EntityTypes) {
				$scope.sourceTypeId = EntityTypes.Host;
				var addAlert = function (error, type) {
					$scope.$parent.$parent.addAlert(error, type);
				};
				$scope.addAlert = function (error, type) {
					$scope.$parent.$parent.addAlert(error, type);
				};
				
				$scope.selectedHost = null;
					$scope.isBodyOpen = true;
				$scope.addHost = function () {
					$scope.selectedHost = {
						statusId: 1,
						isPeoHost: true
					};
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
						$scope.mainData.selectedCompany = null;
						$scope.mainData.selectedCompany1 = null;
						if (!$scope.mainData.selectedHost || ($scope.mainData.selectedHost && $scope.mainData.selectedHost.id !== item.id)) {
							$scope.mainData.selectedHost = item;
							
							$scope.$parent.$parent.hostSelected();
						}
						$scope.tab = 1;
						$rootScope.$broadcast('hostChanged', { host: $scope.selectedHost });
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
						addAlert('successfully saved Host', 'success');
					}, function (error) {
						addAlert('error saving Host', 'danger');
					});
				}
				var init = function () {
					if (!$scope.mainData.userHost) {
						var querystring = $location.search();
						hostRepository.getHostList().then(function (data) {
							$scope.list = data;
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
