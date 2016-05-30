common.factory('commonRepository', [
	'$http', 'zionAPI', 'zionPaths', '$q',
	function($http, zionAPI, zionPaths, $q) {
		return {
			token: function(loginData) {
				var data = {
					'username': loginData.username,
					'password': loginData.password
				};

				var deferred = $q.defer();

				$http.post(zionAPI.Web + zionPaths.Token, data).success(function(response) {
					if (response.success === true)
						deferred.resolve(response.successMessage);
					else
						deferred.reject(response.message);
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