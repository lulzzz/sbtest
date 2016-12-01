'use strict';

common.directive('employeeDeductionList', ['$uibModal', 'zionAPI', 'version',
	function ($modal, zionAPI, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				employeeId: "=employeeId",
				companyDeductions: "=companyDeductions",
				list: "=list",
				saveToServer: "=saveToServer",
				showControls: "=showControls",
				agencies:"=agencies"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/employee-deduction-list.html?v=' + version,

			controller: ['$scope', '$filter', 'companyRepository',
				function ($scope, $filter, companyRepository) {
					var dataSvc = {
						types: [{
								key: 1,
								value: 'Percentage'
							}, {
								key: 2,
								value: 'Amount'
							}
						],
						agencies: $scope.agencies? angular.copy($scope.agencies) : []
					};

					$scope.data = dataSvc;

				$scope.selected = null;
				$scope.getAgencyName = function(id) {
					if (!id) {
						var fil = $filter('filter')(dataSvc.agencies, { id: id })[0];
						if (fil)
							return fil.name;
					}
				}
				var addAlert = function (error, type) {
					$scope.$parent.$parent.addAlert(error, type);
				};
				
				$scope.add = function () {
					$scope.selected = {
						id: 0,
						employeeId: $scope.employeeId,
						deduction: null,
						method: null,
						rate: 0,
						annualMax: null
					};
					$scope.list.push($scope.selected);
				},
				
				$scope.save = function (item) {
					if ($scope.saveToServer) {
						companyRepository.saveEmployeeDeduction(item).then(function(deduction) {
							item.id = deduction.id;
							$scope.selected = null;
							addAlert('successfully saved employee deduction', 'success');
						}, function(error) {
							addAlert('error in saving deduction', 'danger');
						});
					} else {
						$scope.selected = null;
					}
					
				}
				$scope.delete = function (index) {
					var item = $scope.list[index];
					if ($scope.saveToServer) {
						companyRepository.deleteEmployeeDeduction(item.id).then(function(deduction) {
							$scope.list.splice(index, 1);
						}, function(error) {
							addAlert('error in saving deduction', 'danger');
						});
					} else {
						$scope.list.splice(index, 1);
					}
				}
				$scope.cancel = function (index) {
					if ($scope.selected.id === 0) {
						$scope.list.splice(index, 1);
					}
					else if ($scope.original && $scope.original.id === $scope.selected.id) {
						$scope.list[index] = angular.copy($scope.original);
					}
					$scope.selected = null;
				}
				$scope.setSelected = function(index) {
					$scope.selected = $scope.list[index];
					$scope.original = angular.copy($scope.selected);
				}

				$scope.isItemValid = function(item) {
					if (!item.deduction || !item.method || !item.rate)
						return false;
					else if (item.deduction.type.id === 3) {
						if (!item.accountNo || !item.agencyId)
							return false;
						else {
							return true;
						}

					}
					else
						return true;
				}
				
				
				

			}]
		}
	}
]);
