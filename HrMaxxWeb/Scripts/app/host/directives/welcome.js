'use strict';

hostmodule.directive('welcome', ['$modal', 'zionAPI', '$location','localStorageService',
	function ($modal, zionAPI, $locaation, localStorageService) {
		return {
			restrict: 'E',

			scope: {
				
			},
			templateUrl: zionAPI.Web + 'Areas/Administration/templates/hostwelcome.html',

			controller: ['$scope', '$element', '$location', '$filter', 'hostRepository', 'commonRepository', '$q', 'EntityTypes', function ($scope, $element, $location, $filter, hostRepository, commonRepository, $q, EntityTypes) {
				$scope.hostId = null;
				$scope.data = null;
				$scope.hostaddress = {};
				$scope.newsfeed = [];
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

				$scope.getDocumentUrl = function (photo) {
					if (photo) {
						if (photo.id)
							return zionAPI.URL + 'DocumentById/' + photo.id + '/' + photo.documentExtension + '/' + photo.documentName;
					}


				};
				$scope.getStateCode = function() {
					var countries = localStorageService.get('countries');
					var country = $filter('filter')(countries, { countryId: $scope.hostaddress.countryId })[0];
					if (country) {
						var state = $filter('filter')(country.states, { stateId: $scope.hostaddress.stateId })[0];
						if (state)
							return state.abbreviation;
					}
					return '';
				}
				var init = function () {
					var querystring = $location.search();
					if (querystring.host) {
						var hostname = host.split(".")[0];
						hostRepository.getHostWelcomePageByFirmName(hostname).then(function (data) {
							$scope.data = angular.copy(data.homePage);
							$scope.hostaddress = data.address;
							$scope.hostId = data.hostId;
							$scope.newsfeed = data.newsfeed;
							localStorageService.set('hostId', $scope.hostId);
							if ($scope.data) {
								localStorageService.set('hostlogo', $scope.data.logo);
							}
						}, function (erorr) {
							addAlert('error getting host home page details', 'danger');
						});

					} else {
						hostRepository.getHostWelcomePage($location.$$host).then(function (data) {
							$scope.data = angular.copy(data.homePage);
							$scope.hostaddress = data.address;
							$scope.hostId = data.hostId;
							$scope.newsfeed = data.newsfeed;
							localStorageService.set('hostId', $scope.hostId);
							if ($scope.data) {
								localStorageService.set('hostlogo', $scope.data.logo);
							}
						}, function (erorr) {
							addAlert('error getting host home page details', 'danger');
						});
					}
					
					
				}
				init();

			}]
		}
	}
]);
