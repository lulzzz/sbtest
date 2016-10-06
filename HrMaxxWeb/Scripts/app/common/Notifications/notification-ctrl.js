common.controller('notificationCtrl', [
	'$scope', 'notificationRepository','authService', 'zionAPI', '$window','$interval',
	function($scope, notificationRepository, authService, zionAPI, $window, $interval) {
		$scope.zionAPI = zionAPI;
		$scope.authService = authService;
		$scope.myNotifications = [];
		$scope.unreadNotificationsCount = 0;
		
		$scope.notificationsCount = function() {
			if ($scope.myNotifications.length > 0)
				return true;
			else
				return false;

		};
		$scope.getEventClass = function(event) {
			if (event.type === 'Created') {
				return "fa-plus-circle";
			} else if (event.type === 'Updated') {
				return "fa-wrench";
			}
			else if (event.type === 'Info') {
				return "fa-info-circle";
			} else {
				return "fa-comment-o";
			}
		}
		$scope.refreshNotifications = function() {
			$scope.myNotifications = [];
			$scope.getMyNotifications();
		};
		$scope.clear = function() {
			notificationRepository.clearAllNotifications().then(function (data) {
				$scope.myNotifications = [];
				$scope.unreadNotificationsCount = 0;
			}, function (error) {
				//$scope.addAlert('Unable to read the notification.', 'danger');
			});
		}
		$scope.NotificationRead = function(notification) {
			notificationRepository.notificationRead(notification.notificationID).then(function (data) {
				if (notification.metadata) {
					$window.location.href = notification.metadata;
				} else {
					$scope.refreshNotifications();
				}
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
		//$interval($scope.refreshNotifications, 60000);
	}
]);