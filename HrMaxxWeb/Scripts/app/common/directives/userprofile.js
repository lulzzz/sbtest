'use strict';

common.directive('userProfile', ['zionAPI','version',
	function (zionAPI, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Content/templates/userprofile.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'userRepository', function ($scope, $element, $location, $filter, userRepository) {
				$scope.mainData.showFilterPanel = false;

				$scope.user = null;
				$scope.user1 = null;
				$scope.isChangePassword = false;
				$scope.zionAPI = zionAPI;
				var localUser = null;
				var dataSvc = {
					userId: null,
					oldPassword: null,
					newPassword: null,
					confirmPassword: null
				};
				$scope.data = dataSvc;
				$scope.FullName = function () {
					if ($scope.user) {
						return $scope.user.firstName + ' ' + $scope.user.lastName;
					}

				};
				var getUserProfile = function () {
					userRepository.getUserProfile().then(function (data) {
						data.sourceTypeId = 12;
						data.type = 0;
						$scope.user = data;
						localUser = angular.copy(data);
					});
				}
				function _init() {
					getUserProfile();
				};

				$scope.save = function () {
					userRepository.saveUserProfile($scope.user).then(function (data) {
						$scope.mainData.showMessage('successfully saved user profile', 'success');
					}, function (error) {
						$scope.mainData.showMessage('Error saving user profile', 'danger');
					});
				}
				$scope.changePassword = function () {
					userRepository.changePassword(dataSvc.oldPassword, dataSvc.newPassword, dataSvc.confirmPassword).then(function (data) {
						$scope.mainData.showMessage('successfully changed password', 'success');
						dataSvc.oldPassword = null;
						dataSvc.newPassword = null;
						dataSvc.confirmPassword = null;
					}, function (error) {
						$scope.mainData.showMessage('Error changing user password', 'danger');
					});
				}
				$scope.cancel = function () {
					$scope.user = angular.copy(localUser);
					$scope.$broadcast('refreshuserprofile');
				}
				
				_init();
				
			}]
		}
	}
]);
