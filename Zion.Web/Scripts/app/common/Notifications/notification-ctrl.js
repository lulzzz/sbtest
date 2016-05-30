notification.controller('notificationCtrl', [
	'$scope', 'notificationRepository', 'authService', 'zionAPI', '$window',
	function($scope, notificationRepository, authService, zionAPI, $window) {
		$scope.zionAPI = zionAPI;
		$scope.authService = authService;
		$scope.myNotifications = [];
		$scope.unreadNotificationsCount = 0;
		$scope.getProjectId = function(notification) {
			return eval('(' + notification.metadata + ')').ProjectID;
		};
		$scope.getWorkSiteId = function(notification) {
			return eval('(' + notification.metadata + ')').WorkSiteId;
		};
		$scope.getInspectionId = function(notification) {
			return eval('(' + notification.metadata + ')').InspectionId;
		};
		$scope.getActionId = function(notification) {
			return eval('(' + notification.metadata + ')').ActionId;
		};
		$scope.notificationsCount = function() {
			if ($scope.myNotifications.length > 0)
				return true;
			else
				return false;

		};
		$scope.refreshNotifications = function() {
			$scope.myNotifications = [];
			$scope.getMyNotifications();
		};
		$scope.NotificationRead = function(notification) {
			notificationRepository.notificationRead(notification.notificationID).then(function(data) {
				if (notification.type === "Action Assigned") {
					$window.location.href = zionAPI.Web + 'SHEQ/Rectifications/MyActions#/?ActionId=' + $scope.getActionId(notification);
				} else {
					$window.location.href = zionAPI.Web + 'Ericsson/Worksite/Index#/?ProjectId=' + $scope.getProjectId(notification) + '&WorkSiteId=' + $scope.getWorkSiteId(notification) + '&InspectionId=' + $scope.getInspectionId(notification);
				}
				return false;
			}, function(error) {
				//$scope.addAlert('Unable to read the notification.', 'danger');
			});

		};

		$scope.getMyNotifications = function() {
			notificationRepository.getNotifications().then(function(data) {
				$scope.myNotifications = data;
				$scope.unreadNotificationsCount = 0;
				$.each(data, function(index, notificationItem) {
					var dt = new Date(notificationItem.createdOn);
					notificationItem.createdOn = dt.getDate() + '-' + (dt.getMonth() + 1) + '-' + dt.getFullYear() + ' ' + dt.getHours() + ':' + dt.getMinutes() + ':' + dt.getSeconds();
					if (!notificationItem.isRead) {
						$scope.unreadNotificationsCount += 1;
					}
				});
			}, function(error) {
				//$scope.addAlert('Unable to get list of notifications.', 'danger');
			});
		};

		function _init() {
			if ($scope.authService.authentication.isAuth)
				$scope.getMyNotifications();
		};

		_init();
	}
]);