'use strict';

common.directive('paycheck', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				check: "=?check",
				checkId: "=?checkId"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/paycheck.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'ngTableParams', 'EntityTypes', 'payrollRepository',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, payrollRepository) {

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
							payrollRepository.getPayCheckById($scope.checkId).then(function (data) {
								$scope.check = data;
							}, function (erorr) {
								$scope.$parent.$parent.addAlert('error getting paycheck by id', 'danger');
							});
						}
					}
					_init();

				}]
		}
	}
]);
