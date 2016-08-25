'use strict';

common.directive('taxYearRateList', ['$modal', 'zionAPI',
	function ($modal, zionAPI) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				companyId: "=companyId",
				list: "=list",
				metaData: "=metaData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/tax-year-rate-list.html',

			controller: ['$scope', '$filter', 'companyRepository',
				function ($scope, $filter, companyRepository) {
					
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
				
				$scope.save = function(item) {
					companyRepository.saveTaxYearRate(item).then(function(data) {
						item.id = data.id;
						$scope.selected = null;
					}, function(error) {
						addAlert('error in saving tax year rate ', 'danger');
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

				$scope.isItemValid = function (item) {
					var matching = $filter('filter')($scope.metaData, { id: item.taxId, taxYear: item.taxYear })[0];
					if (!item.id || !item.rate || !matching || (matching.taxRateLimit && item.rate>matching.taxRateLimit))
						return false;
					else
						return true;
				}
				
				
				

			}]
		}
	}
]);
