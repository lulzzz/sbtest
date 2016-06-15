usermodule.controller('userCtrl', [
	'$scope', '$element', 'userRepository',
	function ($scope, $element, userRepository) {
		$scope.user = null;
		$scope.user1 = null;
		$scope.isChangePassword = false;
		var localUser = null;
		var dataSvc = {
			userId: null
		};
		$scope.FullName = function() {
			if ($scope.user) {
				return $scope.user.firstName + ' ' + $scope.user.lastName;
			}
			
		};
		var getUserProfile = function() {
			userRepository.getUserProfile(dataSvc.userId).then(function (data) {
				data.sourceTypeId = 12;
				data.type = 0;
				$scope.user = data;
				localUser = angular.copy(data);
			});
		}
		function _init() {
			var dataInput = $element.data();
			dataSvc.userId = dataInput.userid;
			getUserProfile();
		};
		
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