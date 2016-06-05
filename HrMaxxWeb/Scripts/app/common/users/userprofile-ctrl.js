usermodule.controller('userCtrl', [
	'$scope', '$element', 'userRepository',
	function ($scope, $element, userRepository) {
		$scope.user = null;
		$scope.isChangePassword = false;
		$scope.localUser = null;
		var dataSvc = {
			userId: null,
		};
		$scope.FullName = function() {
			if ($scope.user) {
				return $scope.user.firstName + ' ' + $scope.user.lastName;
			}
			
		};
		
		function _init() {
			var dataInput = $element.data();
			dataSvc.userId = dataInput.userid;
			userRepository.getUserProfile(dataSvc.userId).then(function(data) {
				$scope.user = data;
				$scope.localUser = angular.copy($scope.user);
			});
		};
		$scope.cancel = function() {
			$scope.user = angular.copy($scope.localUser);
		}
		$scope.save = function () {
			userRepository.saveUserProfile($scope.user).then(function(data) {
				$scope.addAlert('successfully saved user profile', 'success');
			}, function(error) {
				$scope.addAlert('Error saving user profile', 'danger');
			});
		}
		$scope.alerts = [];
		
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
		_init();
	}
]);