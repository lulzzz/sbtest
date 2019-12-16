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

			controller: ['$scope', '$rootScope', '$filter', 'companyRepository', 'ClaimTypes',
				function ($scope, $rootScope, $filter, companyRepository, ClaimTypes) {
					
					$scope.selected = null;
					$scope.mainData = $scope.$parent.$parent.mainData;
					$scope.enableIsCompanyManaged = $scope.mainData.hasClaim(ClaimTypes.CompanyAcumulatedPaytypesCompanyManaged, 1);
					$scope.enableIsLumpSum = $scope.mainData.hasClaim(ClaimTypes.CompanyAccumulatedPayTypesLumpSum, 1);

					$scope.leaveOptions = [
						{
							id: 0,
							text: 'Default (per hour worked)'
						},
						{
							id: 1,
							text: 'Per Day By Pay Period'
						}
					];
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
                        globalLimit: null,
						isNew: true,
						companyManaged: false,
						isLumpSum: false,
						isEmployeeSpecific: false
                    };
                    $scope.original = angular.copy($scope.selected);
					$scope.list.push($scope.selected);
				},
				
				$scope.save = function(item) {
					companyRepository.saveAccumulatedPayType(item).then(function(data) {
						item.id = data.id;
                        $scope.selected = null;
                        $scope.original = null;
						$rootScope.$broadcast('companyPayTypeUpdated', { pt: data });
						addAlert('successfully saved accumulated pay type', 'success');
					}, function(error) {
						addAlert('error in saving accumulated work type', 'danger');
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
					if (!item.payType || !item.ratePerHour)
						return false;
					else
						return true;
				}
                $scope.getWidgetClass = function (item) {
                    if (item && item.id) {
                        return 'bg-black';
                    }
                    else
                        return 'bg-red-darker';
                }
                $scope.getWidgetSubClass = function (item) {
                    if (item && item.id) {
                       return 'border-black';
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
				
				var init = function() {
					if ($scope.metaData) {
						$.each($scope.metaData, function (index, type) {
							var exists = $filter('filter')($scope.list, { payType: { id: type.id } })[0];
							if (!exists)
								type.available = true;
						});
                    }
                    
				}
					init();

				}]
		}
	}
]);
