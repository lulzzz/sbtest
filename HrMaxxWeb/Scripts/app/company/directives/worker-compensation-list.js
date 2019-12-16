'use strict';

common.directive('workerCompensationList', ['zionAPI', 'version',
	function (zionAPI, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				companyId: "=companyId",
				list: "=list",
				showControls: "=showControls"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/worker-compensation-list.html?v=' + version,

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
						code: 0,
						rate:0,
						isNew:true
                    };
                    $scope.original = angular.copy($scope.selected);
					$scope.list.push($scope.selected);
				},
				
				$scope.save = function(item) {
					companyRepository.saveWorkerCompensation(item).then(function(data) {
						item.id = data.id;
						$scope.selected = null;
						$rootScope.$broadcast('companyWCUpdated', { wc: data });
						addAlert('successfully saved worker compensation', 'success');
					}, function(error) {
						addAlert('error in saving worker compensation', 'danger');
					});
				}
				$scope.cancel = function (index) {
					if ($scope.selected.id === 0) {
                        $scope.list.splice($scope.list.indexOf($scope.selected), 1);
					} 
                    $scope.selected = null;
                    $scope.original = null;
				}
				$scope.setSelected = function(index) {
					$scope.selected = $scope.list[index];
					if (!$scope.selected.code)
                        $scope.selected.code = '0000';
                    $scope.original = angular.copy($scope.selected);
                }

				$scope.isItemValid = function(item) {
					if (!item.code || !item.description || item.rate<0)
						return false;
					else
						return true;
                    }
                $scope.getWidgetClass = function (item) {
                    if (item && item.code && item.rate) {
                       return 'bg-black-lighter';
                    }

                    else
                        return 'bg-red-darker';
                }
                $scope.getWidgetSubClass = function (item) {
                    if (item && item.code && item.rate) {
                            return 'border-black-lighter';
                    }

                    else
                        return 'border-red';
                }
                $scope.hasItemChanged = function () {
                    if (!$scope.selected)
                        return false;
                    else {
                        if (angular.equals($scope.selected, $scope.original))
                            return false;
                        else
                            return true;
                    }
                }
				
				
				

			}]
		}
	}
]);
