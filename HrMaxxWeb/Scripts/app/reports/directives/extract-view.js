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
					$scope.history = $scope.masterExtract.extract.data.history;
					$scope.report = $scope.masterExtract.extract.report;
					$scope.selectedHost = null;
					$scope.selectedCompany = null;
					$scope.showPayChecks = false;
					$scope.showVoidedChecks = false;
					$scope.selectedCompanyFilings = [];
					$scope.set = function(host) {
						$scope.selectedHost = host;
					}
					$scope.setCompany = function(comp) {
						$scope.selectedCompany = comp;
						$scope.showPayChecks = false;
						$scope.showVoidedChecks = false;
						$scope.showHistory = false;
						$scope.selectedCompanyFilings = [];
						$.each($scope.history, function(ind, h) {
							var host = $filter('filter')(h.extract.data.hosts, { host: { id: $scope.selectedHost.host.id } })[0];
							if (host) {
								var c = $filter('filter')(host.companies, { company: { id: $scope.selectedCompany.company.id } })[0];
								if (c && c.accumulation) {
									var filing = {
										depositDate: h.extract.report.depositDate,
										grossWage: c.accumulation.grossWage,
										wages: c.accumulation.applicableWages,
										taxes: c.accumulation.applicableAmounts
								};
									
									$scope.selectedCompanyFilings.push(filing);
								}
							}
						});

					}
					if ($scope.data && $scope.data.hosts.length > 0)
						$scope.set($scope.data.hosts[0]);
				}]
		}
	}
]);
