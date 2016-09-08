'use strict';

common.directive('host', ['zionAPI','localStorageService','version',
	function (zionAPI, localStorageService, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				host: "=data",
				sourceTypeId: "=sourceTypeId",
				sourceId: "=sourceId"
			},
			templateUrl: zionAPI.Web + 'Areas/Administration/templates/host.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'hostRepository', 'EntityTypes', function ($scope, $element, $location, $filter, hostRepository, EntityTypes) {
				$scope.data1 = {
					
				};
				$scope.dt = new Date();
				$scope.host.effectiveDate = moment($scope.host.effectiveDate).toDate();
				if ($scope.host.terminationDate)
					$scope.host.terminationDate = moment($scope.host.terminationDate).toDate();

				$scope.addAlert = function (error, type) {
					$scope.alerts = [];
					$scope.alerts.push({
						msg: error,
						type: type
					});
				};
				$scope.closeAlert = function (index) {
					$scope.alerts.splice(index, 1);
				};
				

			}]
		}
	}
]);
