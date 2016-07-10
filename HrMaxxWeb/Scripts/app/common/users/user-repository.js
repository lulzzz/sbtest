usermodule.factory('userRepository', [
	'$q', 'commonServer',
	function($q, commonServer) {
		return {

			getUserProfile: function (userId) {
				var deferred = $q.defer();

				commonServer.one('User').one(userId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});
				return deferred.promise;
			},
			saveUserProfile: function (user) {
				return commonServer.all('User').post(user);
				
			},

		};
	}
]);