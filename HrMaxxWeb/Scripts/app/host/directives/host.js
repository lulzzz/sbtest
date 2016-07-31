'use strict';

common.directive('host', ['$modal', 'zionAPI','localStorageService',
	function ($modal, zionAPI, localStorageService) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				host: "=data",
				sourceTypeId: "=sourceTypeId",
				sourceId: "=sourceId"
			},
			templateUrl: zionAPI.Web + 'Areas/Administration/templates/host.html',

			controller: ['$scope', '$element', '$location', '$filter', 'hostRepository', 'EntityTypes', function ($scope, $element, $location, $filter, hostRepository, EntityTypes) {
				$scope.data1 = {
					opened: false,
					opened1:false
				};
				$scope.dateOptions = {
					format: 'dd/MMyyyy',
					startingDay: 1,
					daysOfWeekDisabled: [0, 6]
				};
				
				$scope.today = function () {
					$scope.dt = new Date();
				};
				$scope.today();

				$scope.clear = function () {
					$scope.dt = null;
				};
				$scope.open = function ($event) {
					$event.preventDefault();
					$event.stopPropagation();
					$scope.data1.opened = true;
				};
				$scope.open1 = function ($event) {
					$event.preventDefault();
					$event.stopPropagation();
					$scope.data1.opened1 = true;
				};

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
