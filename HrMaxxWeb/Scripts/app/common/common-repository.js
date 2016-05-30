common.factory('commonRepository', [
	'$http', 'zionAPI', 'zionPaths', '$q',
	function($http, zionAPI, zionPaths, $q) {
		return {
			token: function(loginData) {
				var data = "grant_type=password&username=" + loginData.username + "&password=" + loginData.password;

				var deferred = $q.defer();

				$http.post(zionAPI.URL + zionPaths.Token, data, { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } }).success(function (response) {
					
						deferred.resolve(response);
					
				}).error(function(err) {
					deferred.reject(err);
				});
				return deferred.promise;
			},
			postLogin: function(loginData) {
				var deferred = $q.defer();
				$http.post(zionAPI.Web + zionPaths.Login, JSON.stringify(loginData)).success(function(response) {
					deferred.resolve(response);
				}).error(function(err) {
					deferred.reject(err);
				});
				return deferred.promise;
			},
			logout: function() {
				var deferred = $q.defer();
				$http.get(zionAPI.Web + zionPaths.Logout).success(function(response) {
					deferred.resolve(response);
				}).error(function(err) {
					deferred.reject(err);
				});
				return deferred.promise;
			}
		};
	}
]);