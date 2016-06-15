'use strict';

common.directive('contactList', ['$modal', 'zionAPI', '$timeout', '$window',
	function ($modal, zionAPI, $timeout, $window) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				list: "=list",
				sourceTypeId: "=sourceTypeId",
				sourceId: "=sourceId",
				heading: "=heading"
			},
			templateUrl: zionAPI.Web + 'Content/templates/contact-list.html',

			controller: ['$scope', '$element', '$location', '$filter', 'commonRepository', 'ngTableParams', 'EntityTypes', function ($scope, $element, $location, $filter, commonRepository, ngTableParams, EntityTypes) {
				$scope.targetTypeId = EntityTypes.Contact;
				
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
				$scope.selectedContact = null;

				$scope.addNewContact = function () {
					$scope.selectedContact = {
						sourceTypeId: $scope.sourceTypeId,
						sourceId: $scope.sourceId,
						targetTypeId: $scope.targetTypeId,
						fistName: '',
						lastName: '',
						middleInitial: '',
						email: '',
						phone: '',

					};
				}

				$scope.tableData = [];
				$scope.tableParams = new ngTableParams({
					page: 1,            // show first page
					count: 10,

					filter: {
						fullName: '',       // initial filter
					},
					sorting: {
						fullName: 'asc'     // initial sorting
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
					if ($scope.list) {
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
					$scope.selectedContact = null;
				}
				$scope.setSelectedContact = function(item) {
					$scope.selectedContact = item;
					$scope.selectedContact.sourceTypeId = $scope.sourceTypeId;
					$scope.selectedContact.sourceId = $scope.sourceId;
				}
				$scope.getRowClass = function(item) {
					if ($scope.selectedContact && $scope.selectedContact.id === item.id)
						return 'success';
					else {
						return 'default';
					}
				}
				$scope.delete = function(item) {
					commonRepository.deleteRelationship($scope.sourceTypeId, $scope.targetTypeId, $scope.sourceId, item.id).then(function () {
						$scope.list.splice($scope.list.indexOf(item), 1);
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						$scope.selectedContact = null;
					}, function () {
						addAlert('successfully deleted contact', 'success');
					}, function (error) {
						addAlert('error deleting contact', 'danger');
					});
				}
				$scope.save = function () {
					commonRepository.saveContact($scope.selectedContact).then(function (result) {
						
						var exists = $filter('filter')($scope.list, { id:result.id });
						if (exists.length === 0) {
							$scope.list.push(result);
						} else {
							$scope.list.splice($scope.list.indexOf(exists[0]), 1);
							$scope.list.push(result);
						}
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						$scope.selectedContact = null;
					}, function () {
						addAlert('successfully saved contact', 'success');
					}, function (error) {
						addAlert('error saving contact', 'danger');
					});
				}

			}]
		}
	}
]);
