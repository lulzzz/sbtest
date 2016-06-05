notification.factory('notificationRepository', [
	'$q', 'commonServer',
	function($q, commonServer) {
		return {
			getNotifications: function () {
				var deferred = $q.defer();

				commonServer.one('GetNotifications').getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});
				return deferred.promise;
			},
			notificationRead: function (notificationId) {
				var deferred = $q.defer();

				commonServer.one('NotificationRead').one(notificationId).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});
				return deferred.promise;
				
			}

		};
	}
]);