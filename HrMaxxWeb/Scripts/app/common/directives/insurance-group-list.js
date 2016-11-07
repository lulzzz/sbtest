'use strict';

common.directive('insuranceGroupList', ['zionAPI','version',
	function (zionAPI, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/insurance-group-list.html?v=' + version,

			controller: ['$scope', '$rootScope', '$filter', 'commonRepository',
				function($scope, $rootScope, $filter, commonRepository) {
					var dataSvc =
					{
						isBodyOpen: true
					};
					$scope.data = dataSvc;
				$scope.selected = null;
				$scope.alerts = [];
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
				$scope.add = function () {
					$scope.selected = {
						id: 0,
						groupNo: '',
						groupName: ''
					};
					$scope.list.push($scope.selected);
				},
				
				$scope.save = function(item) {
					commonRepository.saveInsuranceGroup(item).then(function (data) {
						item.id = data.id;
						$scope.selected = null;
						
					}, function(error) {
						addAlert('error in saving insurance group', 'danger');
					});
				}
				$scope.cancel = function (index) {
					if ($scope.selected.id === 0) {
						$scope.list.splice(index, 1);
					}
					$scope.selected = null;
				}
				$scope.setSelected = function(index) {
					$scope.selected = $scope.list[index];
				}

				$scope.isItemValid = function(item) {
					if (!item.groupNo || !item.groupName)
						return false;
					else
						return true;
				}
					$scope.list = null;
				var init = function() {
					commonRepository.getInsuranceGroups().then(function (result) {
						$scope.list = angular.copy(result);

					}, function (error) {
						addAlert('error occurred in getting insurance groups ' + error.statusText, 'danger');
					});
				}
					init();

				}]
		}
	}
]);
