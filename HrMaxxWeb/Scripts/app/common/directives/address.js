﻿'use strict';

common.directive('address', ['zionAPI','localStorageService','version',
	function (zionAPI, localStorageService, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				data: "=data",
				sourceTypeId: "=sourceTypeId",
				sourceId: "=sourceId",
				type: "=type",
				showDisabled: "=?showDisabled",
				valGroup: "=?valGroup"
			},
			templateUrl: zionAPI.Web + 'Content/templates/address.html?v=1.24' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'commonRepository', 'EntityTypes', function ($scope, $element, $location, $filter, commonRepository, EntityTypes) {
				$scope.targetTypeId = EntityTypes.Address;
				$scope.countries = localStorageService.get('countries');
				if (!$scope.valGroup)
					$scope.valGroup = "address";
				if (!$scope.showDisabled)
					$scope.showDisabled = false;
				//$scope.data = angular.copy($scope.data1);
				var localAddress = null;
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
					if ($scope.data.stateId) {
						$scope.data.selectedState = $filter('filter')($scope.data.selectedCountry.states, { stateId: $scope.data.stateId })[0];
					} else {
						if ($scope.data.selectedCountry.states.length === 1) {
							$scope.data.selectedState = $scope.data.selectedCountry.states[0];
							$scope.stateSelected();
						}
					}
					
				}
				$scope.stateSelected = function() {
					$scope.data.stateId = $scope.data.selectedState.stateId;
				}

				var defaultCountryState = function () {
					if (!$scope.data)
						$scope.data = {};
					if ($scope.data.countryId) {
						$scope.data.selectedCountry = $filter('filter')($scope.countries, { countryId: $scope.data.countryId })[0];
						$scope.countrySelected();
						
					}
					else {
						if ($scope.countries.length === 1) {
							$scope.data.selectedCountry = $scope.countries[0];
							$scope.countrySelected();
						}

					}
					
				}
				if ($scope.type === 1) {
					$scope.$on('refreshuserprofile', function() {
						$scope.data = angular.copy(localAddress);
						defaultCountryState();
					});
				}
				var init = function () {
					if ($scope.type === 1) {
						commonRepository.getFirstRelatedEntity($scope.sourceTypeId, $scope.targetTypeId, $scope.sourceId).then(function(data) {
							localAddress = data;
							$scope.data = angular.copy(localAddress);
							defaultCountryState();
						}, function(erorr) {

						});
					} else {
						defaultCountryState();
					}
					
				}
				init();


			}]
		}
	}
]);
