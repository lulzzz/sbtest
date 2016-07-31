common.factory('userRepository', [
	'$q', 'commonServer',
	function($q, commonServer) {
		return {

			getUserProfile: function () {
				var deferred = $q.defer();

				commonServer.one('User').get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});
				return deferred.promise;
			},
			changePassword: function (old, new1, confirm) {
				var deferred = $q.defer();

				commonServer.all('UserPasswordChange').post({
					oldPassword: old,
					newPassword: new1,
					confirmPassword: confirm
				}).then(function (data) {
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