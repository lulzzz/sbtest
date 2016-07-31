'use strict';

common.directive('workerCompensationList', ['$modal', 'zionAPI',
	function ($modal, zionAPI) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				companyId: "=companyId",
				list: "=list"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/worker-compensation-list.html',

			controller: ['$scope', '$filter', 'companyRepository',
				function ($scope, $filter, companyRepository) {
					
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
						companyId: $scope.companyId,
						code: 0,
						rate:0,
						isNew:true
					};
					$scope.list.push($scope.selected);
				},
				
				$scope.save = function(item) {
					companyRepository.saveWorkerCompensation(item).then(function(data) {
						item.id = data.id;
						$scope.selected = null;
					}, function(error) {
						addAlert('error in saving worker compensation', 'danger');
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
					if (!item.code || !item.description || !item.rate)
						return false;
					else
						return true;
				}
				
				
				

			}]
		}
	}
]);
