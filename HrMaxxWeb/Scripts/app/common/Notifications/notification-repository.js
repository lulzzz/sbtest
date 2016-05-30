notification.factory('notificationRepository', [
	'$http', '$q', 'zionAPI',
	function($http, $q, zionAPI) {
		return {
			getNotifications: function() {
				var deferred = $q.defer();
				$http.get(zionAPI.URL + 'GetNotifications').
					success(function(data, status, headers, config) {
						deferred.resolve(data);
					}).
					error(function(data, status, headers, config) {
						deferred.reject(data);
					});
				return deferred.promise;
			},
			notificationRead: function(notificationId) {
				var deferred = $q.defer();
				$http.get(zionAPI.URL + 'NotificationRead/' + notificationId).
					success(function(data, status, headers, config) {
						deferred.resolve(data);
					}).
					error(function(data, status, headers, config) {
						deferred.reject(data);
					});
				return deferred.promise;
			}

		};
	}
]);