'use strict';

common.directive('accumulatedPayTypeList', ['zionAPI', 'version',
	function (zionAPI, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				companyId: "=companyId",
				list: "=list",
				metaData: "=metaData",
				showControls: "=showControls"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/accumulated-pay-type-list.html?v=' + version,

			controller: ['$scope', '$rootScope', '$filter', 'companyRepository',
				function ($scope, $rootScope, $filter, companyRepository) {
					
				$scope.selected = null;
				
				var addAlert = function (error, type) {
					$scope.$parent.$parent.addAlert(error, type);
				};
				
				$scope.add = function () {
					$scope.selected = {
						id: 0,
						companyId: $scope.companyId,
						payType: null,
						ratePerHour: 0,
						annualLimit: 0,
						isNew:true
					};
					$scope.list.push($scope.selected);
				},
				
				$scope.save = function(item) {
					companyRepository.saveAccumulatedPayType(item).then(function(data) {
						item.id = data.id;
						$scope.selected = null;
						$rootScope.$broadcast('companyPayTypeUpdated', { pt: data });
						addAlert('successfully saved accumulated pay type', 'success');
					}, function(error) {
						addAlert('error in saving accumulated work type', 'danger');
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
				$scope.availablePayTypes = function() {
					var _available = [];
					if ($scope.metaData) {
						$.each($scope.metaData, function (index, type) {
							var exists = $filter('filter')($scope.list, { payType: { id: type.id } })[0];
							if (!exists)
								_available.push(type);
						});
					}
					
					return _available;
				}

				$scope.isItemValid = function(item) {
					if (!item.payType || !item.ratePerHour || !item.annualLimit)
						return false;
					else
						return true;
				}
				
				
				

			}]
		}
	}
]);
