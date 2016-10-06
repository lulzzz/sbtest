common.factory('notificationRepository', [
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

				commonServer.one('NotificationRead').one(notificationId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});
				return deferred.promise;
				
			},
			clearAllNotifications: function () {
				var deferred = $q.defer();

				commonServer.one('ClearAllNotifications').get().then(function () {
					deferred.resolve();
				}, function (error) {
					deferred.reject(error);
				});
				return deferred.promise;

			}

		};
	}
]);