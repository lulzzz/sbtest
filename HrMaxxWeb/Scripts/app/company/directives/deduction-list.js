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
				
				var addAlert = function (error, type) {
					$scope.$parent.$parent.addAlert(error, type);
				};
				
				$scope.add = function () {
					$scope.selected = {
						id: 0,
						companyId: $scope.companyId,
                        isNew: true,
                        applyInvoiceCredit: false,
                        annualMax: null,
                        floorPerCheck: null
                    };
                    $scope.original = angular.copy($scope.selected);
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
                        $scope.list = $filter('orderBy')($scope.list, 'type.category');
						$scope.selected = null;
						$rootScope.$broadcast('companyDeductionUpdated', { ded: deduction });
						addAlert('successfully saved deduction', 'success');
					}, function(error) {
						addAlert('error in saving deduction', 'danger');
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
                    $scope.original = angular.copy($scope.selected);
                }

				$scope.isItemValid = function(item) {
					if (!item.type || !item.deductionName)
						return false;
					else
						return true;
                    }
                $scope.getWidgetClass = function (item) {
                    if (item && item.type) {
                        if (item.type.category === 1)
                            return 'bg-green';
                        else if (item.type.category === 2)
                            return 'bg-blue';
                        else if (item.type.category === 3)
                            return 'bg-purple';
                        else if (item.type.category === 4)
                            return 'bg-black';
                    }

                    else
                        return 'bg-red-darker';
                }
                $scope.getWidgetSubClass = function (item) {
                    if (item && item.type) {
                        if (item.type.category === 1)
                            return 'border-green';
                        else if (item.type.category === 2)
                            return 'border-blue';
                        else if (item.type.category === 3)
                            return 'border-purple';
                        else if (item.type.category === 4)
                            return 'border-black';
                    }

                    else
                        return 'border-red';
                    }
                    $scope.hasItemChanged = function() {
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
