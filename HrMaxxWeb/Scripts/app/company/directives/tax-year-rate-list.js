'use strict';

common.directive('taxYearRateList', ['zionAPI', 'version',
	function (zionAPI, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				company: "=company",
				list: "=list",
				metaData: "=metaData",
				showControls: "=showControls"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/tax-year-rate-list.html?v=' + version,

			controller: ['$scope', '$rootScope', '$filter', 'companyRepository',
				function ($scope, $rootScope, $filter, companyRepository) {
					
				$scope.selected = null;
				
				var addAlert = function (error, type) {
					$scope.$parent.$parent.addAlert(error, type);
				};
				
				$scope.save = function(item) {
					companyRepository.saveTaxYearRate(item).then(function(data) {
						item.id = data.id;
						item.taxCode = data.taxCode;
						$scope.selected = null;
						$rootScope.$broadcast('companyTaxUpdated', { tax: data });
						addAlert('successfully saved tax rate', 'success');
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
					var matching = $filter('filter')($scope.metaData? $scope.metaData : [], { tax:{id:item.taxId}, taxYear: item.taxYear })[0];
					if (item.rate===null || item.rate===undefined || !matching || (matching.taxRateLimit && item.rate>matching.taxRateLimit))
						return false;
					else
						return true;
				}
				
				$scope.showAdd = function() {
					var currentYear = new Date().getFullYear();
					var currentYearTaxes = $filter('filter')($scope.list, { taxYear: currentYear });
					return currentYearTaxes.length === 0;
				}
				$scope.add = function () {
					var currentYear = new Date().getFullYear();
					var currentYearTaxes = $filter('filter')($scope.metaData, { tax: { stateId: $scope.company.states[0].state.stateId } });
					$.each(currentYearTaxes, function (i, t) {
						var exists = $filter('filter')($scope.list, { taxYear: t.taxYear, tax: { id: t.tax.id } })[0];
						if (!exists) {
							var t1 = angular.copy(t);
							t1.id = 0;
							t1.companyId = $scope.company.id;
							t1.taxId = t1.tax.id;
							t1.taxCode = t1.tax.code;
							t1.taxYear = t1.taxYear;
							companyRepository.saveTaxYearRate(t1).then(function (data) {
								t1.id = data.id;
								t1.taxCode = data.taxCode;
								$scope.list.push(t1);
								$rootScope.$broadcast('companyTaxUpdated', { tax: data });

							}, function (error) {
								addAlert('erorr adding tax rate for year ' + (currentYear), 'danger');
							});
						}
						
					});
				}
				

			}]
		}
	}
]);
