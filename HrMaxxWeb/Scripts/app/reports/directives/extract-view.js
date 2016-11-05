'use strict';

common.directive('extractView', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				masterExtract: "=masterExtract"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/extract-view.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter',
				function ($scope, $element, $location, $filter) {
					$scope.data = $scope.masterExtract.extract.data;
					$scope.report = $scope.masterExtract.extract.report;
					$scope.selectedHost = null;
					$scope.selectedCompany = null;
					$scope.showPayChecks = false;
					$scope.showVoidedChecks = false;
					$scope.set = function(host) {
						$scope.selectedHost = host;
					}
					$scope.setCompany = function(comp) {
						$scope.selectedCompany = comp;
						$scope.showPayChecks = false;
						$scope.showVoidedChecks = false;

					}
					if ($scope.data && $scope.data.hosts.length > 0)
						$scope.set($scope.data.hosts[0]);
				}]
		}
	}
]);
