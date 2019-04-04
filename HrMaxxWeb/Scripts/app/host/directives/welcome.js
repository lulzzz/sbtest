'use strict';

common.directive('welcome', ['zionAPI', '$location','localStorageService','version',
	function (zionAPI, $locaation, localStorageService, version) {
		return {
			restrict: 'E',

			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Administration/templates/hostwelcome.html?v=' + version,

			controller: ['$scope', '$rootScope', '$element', '$location', '$filter', 'hostRepository', 'commonRepository', '$q', 'EntityTypes', 'authService',
				function ($scope, $rootScope, $element, $location, $filter, hostRepository, commonRepository, $q, EntityTypes, authService) {
				$scope.mainData.showFilterPanel = false;
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
				$scope.getContentImage = function(path) {
					return zionAPI.Web + path;
				}
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
					if (querystring.hostid) {
						var hostId = querystring.hostid;
						hostRepository.getHostWelcomePageByFirmId(hostId).then(function (data) {
							$scope.data = angular.copy(data.homePage);
							$scope.hostaddress = data.address;
							$scope.hostId = data.hostId;
							if (!authService.isLoggedIn())
								$scope.newsfeed = data.newsfeed;
							localStorageService.set('hostId', $scope.hostId);
							if ($scope.data) {
								localStorageService.set('hostlogo', $scope.data.logo);
								$rootScope.$broadcast('welcomeChanged', { logo: $scope.data.logo });
							}
						}, function (erorr) {
							addAlert('error getting host home page details', 'danger');
						});

					} else if (querystring.host) {
						var hostname = querystring.host.split(".")[0];
						hostRepository.getHostWelcomePageByFirmName(hostname).then(function (data) {
							$scope.data = angular.copy(data.homePage);
							$scope.hostaddress = data.address;
							$scope.hostId = data.hostId;
							if (!authService.isLoggedIn())
								$scope.newsfeed = data.newsfeed;
							localStorageService.set('hostId', $scope.hostId);
							if ($scope.data) {
								localStorageService.set('hostlogo', $scope.data.logo);
								$rootScope.$broadcast('welcomeChanged', { logo: $scope.data.logo });
							}
						}, function (erorr) {
							addAlert('error getting host home page details', 'danger');
						});

					} else {
						hostRepository.getHostWelcomePage($location.$$host.split(".")[0]).then(function (data) {
							$scope.data = angular.copy(data.homePage);
							$scope.hostaddress = data.address;
							$scope.hostId = data.hostId;
							if (!authService.isLoggedIn())
								$scope.newsfeed = data.newsfeed;
							localStorageService.set('hostId', $scope.hostId);
							if ($scope.data) {
								localStorageService.set('hostlogo', $scope.data.logo);
								$rootScope.$broadcast('welcomeChanged', { logo: $scope.data.logo });
							}
						}, function (erorr) {
							addAlert('error getting host home page details', 'danger');
						});
					}
					if (authService.isLoggedIn()) {
						commonRepository.getUserNews().then(function(data) {
							$scope.newsfeed = data;

						}, function(erorr) {

						});
					} 
					
				}
				init();

			}]
		}
	}
]);
