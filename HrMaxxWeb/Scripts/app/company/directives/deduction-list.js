'use strict';

common.directive('deductionList', ['zionAPI', 'version',
	function (zionAPI, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				companyId: "=companyId",
				list: "=list",
				types: "=types",
				showControls: "=showControls"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/deduction-list.html?nd=' + version,

			controller: ['$scope', '$rootScope', '$filter', 'companyRepository',
				function ($scope,$rootScope, $filter, companyRepository) {
					
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
						isNew:true
					};
					$scope.list.push($scope.selected);
				},
				
				$scope.showDeductionType = function (item) {
					var selected = [];
					if (item.type) {
						selected = $filter('filter')($scope.types, { id: item.type.id }, true);
					}
					return selected && selected.length ? selected[0].categoryText + ' - ' + selected[0].name : 'Not set';
				},
				$scope.save = function(item) {
					companyRepository.saveCompanyDeduction(item).then(function(deduction) {
						item.id = deduction.id;
						$scope.selected = null;
						$rootScope.$broadcast('companyDeductionUpdated', { ded: deduction });
					}, function(error) {
						addAlert('error in saving deduction', 'danger');
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
					if (!item.type || !item.deductionName)
						return false;
					else
						return true;
				}
				
				
				

			}]
		}
	}
]);
