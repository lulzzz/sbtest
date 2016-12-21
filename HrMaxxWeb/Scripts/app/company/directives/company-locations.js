'use strict';

common.directive('companyLocations', ['zionAPI','version',
	function (zionAPI, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				companyId: "=companyId",
				list: "=list",
				showControls: "=showControls"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/company-locations.html?v=' + version,

			controller: ['$scope', '$rootScope', '$filter', 'companyRepository',
				function ($scope, $rootScope, $filter, companyRepository) {
					
				$scope.selected = null;
					$scope.parent = $scope.$parent.$parent.mainData.selectedCompany;
				var addAlert = function (error, type) {
					$scope.$parent.$parent.addAlert(error, type);
				};
				$scope.closeAlert = function (index) {
					
				};
				$scope.add = function () {
					var new1 = {
						parentId: $scope.companyId,
						name: $scope.parent.name + ' - Loc ' + ($scope.list.length + 1),
						address: {}
					};
						$scope.selected = new1;
					$scope.list.push($scope.selected);
				},
				
				$scope.save = function(item) {
					companyRepository.saveLocation(item).then(function (data) {

						item.id = data.id;
						item.address = data.companyAddress;
						$scope.parent.locations.push(item);
						$scope.selected = null;
						$rootScope.$broadcast('companyLocationUpdated', { location: data });
						addAlert('successfully saved location', 'success');
					}, function(error) {
						addAlert('error in saving location', 'danger');
					});
				}
				$scope.jump = function (item) {
					$rootScope.$broadcast('switchCompany', { newcomp: item.id });
				}
				$scope.cancel = function (index) {
					if (!$scope.selected.id) {
						$scope.list.splice(index, 1);
					}
					$scope.selected = null;
				}
				$scope.setSelected = function(index) {
					$scope.selected = $scope.list[index];
				}

				$scope.isItemValid = function(item) {
					if (!item.parentId || !item.name || !item.address)
						return false;
					else
						return true;
				}
				
				
				

			}]
		}
	}
]);
