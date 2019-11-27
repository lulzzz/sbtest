'use strict';

common.directive('payTypeList', ['zionAPI','version',
	function (zionAPI, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/pay-type-list.html?v=' + version,

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
                    $scope.$parent.$parent.$parent.$parent.alerts = [];
                    $scope.$parent.$parent.$parent.$parent.alerts.push({
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
						name: '',
                        description: '',
                        isTaxable: true,
                        isAccumulable: false
					};
					$scope.list.push($scope.selected);
				},
				
				$scope.save = function(item) {
					commonRepository.savePayType(item).then(function (data) {
						item.id = data.id;
						$scope.selected = null;
						
					}, function(error) {
						addAlert('error in saving pay type', 'danger');
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
					if (!item.name || !item.description)
						return false;
					else
						return true;
				}
					$scope.list = null;
				var init = function() {
					commonRepository.getPayTypes().then(function (result) {
						$scope.list = angular.copy(result);

					}, function (error) {
						addAlert('error occurred in getting Pay types ' + error.statusText, 'danger');
					});
				}
					init();

				}]
		}
	}
]);
