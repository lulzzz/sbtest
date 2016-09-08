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
				saveToServer: "=saveToServer"
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
								value: 'Fixed Rate'
							}
						]
					};

					$scope.data = dataSvc;

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
					$scope.selected = null;
				}
				$scope.setSelected = function(index) {
					$scope.selected = $scope.list[index];
				}

				$scope.isItemValid = function(item) {
					if (!item.deduction || !item.method || !item.rate)
						return false;
					else
						return true;
				}
				
				
				

			}]
		}
	}
]);
