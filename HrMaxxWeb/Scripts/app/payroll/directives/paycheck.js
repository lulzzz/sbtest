'use strict';

common.directive('paycheck', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				check: "=?check",
				checkId: "=?checkId",
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/paycheck.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'EntityTypes', 'payrollRepository',
				function ($scope, $element, $location, $filter, companyRepository, EntityTypes, payrollRepository) {
					
					$scope.selected = null;
					$scope.setSelected = function (index) {

						$scope.original = angular.copy($scope.check.accumulations[index]);
						$scope.selected = $scope.check.accumulations[index];
						$scope.selected.fiscalStart = moment($scope.selected.fiscalStart).toDate();
						$scope.selected.fiscalEnd = moment($scope.selected.fiscalEnd).toDate();
					}
					$scope.cancel = function(index) {
						$scope.selected = null;
						$scope.check.accumulations[index] = angular.copy($scope.original);
					}
					$scope.saveAccumulation = function (index) {
						$scope.selected.fiscalStart = moment($scope.selected.fiscalStart).format("MM/DD/YYYY");
						$scope.selected.fiscalEnd = moment($scope.selected.fiscalEnd).format("MM/DD/YYYY");
						$scope.selected.available = +($scope.selected.carryOver + $scope.selected.ytdFiscal - $scope.selected.ytdUsed).toFixed();
						payrollRepository.updatePayCheckAccumulation($scope.check.id, $scope.selected).then(function () {
							$scope.check.accumulations[index] = angular.copy($scope.selected);
							$scope.selected = null;
							$scope.original = null;
						}, function (error) {
							addAlert('error updating pay check accumulation', 'danger');
						});
						//$scope.$parent.$parent.$parent.$parent.confirmDialog('Are you sure you want to change thIS accumulation?', 'warning', function () {
							
						//});
					}
					$scope.isItemValid = function(pt) {
						if (pt.used >= 0 && pt.ytdUsed >= 0 && pt.accumulatedValue >= 0 && pt.ytdFiscal >= 0 && pt.carryOver >= 0 && pt.fiscalStart && pt.fiscalEnd && pt.fiscalEnd >= pt.fiscalStart)
							return true;
						else {

							return false;
						}
					}
					$scope.showNonTaxable = function () {
						if ($scope.check) {
							var exists = $filter('filter')($scope.check.compensations, { payType: { isTaxable: false } });
							if (exists.length > 0)
								return true;
							else {
								return false;
							}
						} else {
							return false;
						}
						
					}
					
					var _init = function() {
						if (!$scope.check && $scope.checkId) {
							payrollRepository.getPayCheckById($scope.checkId).then(function(data) {
								$scope.check = data;
								$scope.showControls = $scope.mainData.userRole === 'Master' && $scope.check.status > 2;
							}, function(erorr) {
								$scope.$parent.$parent.addAlert('error getting paycheck by id', 'danger');
							});
						} else {
							$scope.showControls = $scope.mainData.userRole === 'Master' && $scope.check.status > 2;
						}
					}
					_init();

				}]
		}
	}
]);
