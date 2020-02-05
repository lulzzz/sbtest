'use strict';

common.directive('payCodeList', ['zionAPI','version',
	function (zionAPI, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				companyId: "=companyId",
				list: "=list",
				mainData: "=mainData",
				showControls: "=showControls"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/pay-code-list.html?v=' + version,

			controller: ['$scope', '$rootScope', '$filter', 'companyRepository',
				function ($scope, $rootScope, $filter, companyRepository) {
					
				$scope.selected = null;
					$scope.rateTypes = [{ id: 1, name: 'Flat Rate' }, {id:2, name: 'Times Base Rate'}];
				var addAlert = function (error, type) {
					$scope.mainData.showMessage(error, type);
				};
				$scope.closeAlert = function (index) {
					
					};
					$scope.getMinRate = function (item) {
						return item.rateType === 1 ? 0.0001 : 1;
					}
				$scope.add = function () {
					$scope.selected = {
						id: 0,
						companyId: $scope.companyId,
						code: '',
						hourlyRate: 0,
						description: '',
						rateType: 1
					};
					$scope.list.push($scope.selected);
				},
				
				$scope.save = function(item) {
					companyRepository.savePayCode(item).then(function(data) {
						item.id = data.id;
						$scope.selected = null;
						$rootScope.$broadcast('companyPayCodeUpdated', { pc: data });
						addAlert('successfully saved pay rate', 'success');
					}, function(error) {
						addAlert('error in saving pay rate', 'danger');
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
					if (!item.code || !item.description || !item.hourlyRate)
						return false;
					else
						return true;
				}
				
				
				

			}]
		}
	}
]);
