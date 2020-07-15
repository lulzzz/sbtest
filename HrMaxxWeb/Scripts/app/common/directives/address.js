﻿'use strict';

common.directive('addressPaxol', ['zionAPI','localStorageService','version',
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
				valGroup: "=?valGroup",
				showTaxable: "=?showTaxable",
				showContent: "=?showContent",
				legend: "=?legend"
			},
			templateUrl: zionAPI.Web + 'Content/templates/address.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'commonRepository', 'EntityTypes', function ($scope, $element, $location, $filter, commonRepository, EntityTypes) {
				$scope.targetTypeId = EntityTypes.Address;
				$scope.legend = $scope.legend ? $scope.legend : 'Address';
				$scope.countries = localStorageService.get('countries');
				$scope.availableStates = [];
				if (!$scope.valGroup)
					$scope.valGroup = "address";
				if (!$scope.showDisabled)
					$scope.showDisabled = false;
				
				//$scope.data = angular.copy($scope.data1);
				var localAddress = null;
				
				$scope.countrySelected = function() {
					$scope.data.countryId = $scope.data.selectedCountry.countryId;
					$scope.availableStates = angular.copy($scope.data.selectedCountry.states);
					if ($scope.showTaxable) {
						$scope.availableStates = $filter('filter')($scope.availableState, { taxesEnabled: true });
					} 
					if ($scope.data.stateId) {
						$scope.data.selectedState = $filter('filter')($scope.data.selectedCountry.states, { stateId: $scope.data.stateId })[0];
					} else {
						
							$scope.data.selectedState = $scope.data.selectedCountry.states[0];
							$scope.stateSelected();
						
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
