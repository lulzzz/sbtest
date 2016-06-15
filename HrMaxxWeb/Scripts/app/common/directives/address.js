'use strict';

common.directive('address', ['$modal', 'zionAPI','localStorageService',
	function ($modal, zionAPI, localStorageService) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				data: "=data",
				sourceTypeId: "=sourceTypeId",
				sourceId: "=sourceId",
				type: "=type"
			},
			templateUrl: zionAPI.Web + 'Content/templates/address.html',

			controller: ['$scope', '$element', '$location', '$filter', 'commonRepository', 'EntityTypes', function ($scope, $element, $location, $filter, commonRepository, EntityTypes) {
				$scope.targetTypeId = EntityTypes.Address;
				$scope.countries = localStorageService.get('countries');
				
				if (!$scope.data) {
					$scope.data = {
						selectedCountry: null,
						selectState: null
					}
				}
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

				$scope.countrySelected = function() {
					$scope.data.countryId = $scope.data.selectedCountry.countryId;
				}
				$scope.stateSelected = function() {
					$scope.data.stateId = $scope.data.selectedState.stateId;
				}

				var defaultCountryState = function() {
					if ($scope.data && $scope.data.countryId) {
						$scope.data.selectedCountry = $filter('filter')($scope.countries, { countryId: $scope.data.countryId })[0];

					} else {
						if ($scope.countries.length === 1) {
							$scope.data.selectedCountry = $scope.countries[0];
							$scope.countrySelected();
						}
					}
					if ($scope.data && $scope.data.stateId) {
						$scope.data.selectedState = $filter('filter')($scope.data.selectedCountry.states, { stateId: $scope.data.stateId })[0];
					}
				}

				defaultCountryState();
				


			}]
		}
	}
]);
