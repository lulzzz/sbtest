common.factory('reportRepository', [
	'$http', 'zionAPI', 'zionPaths', '$q', 'reportServer', 
	function ($http, zionAPI, zionPaths, $q, reportServer) {
		return {
			getReport: function (request) {
				var deferred = $q.defer();
				reportServer.all('Report').post(request).then(function (response) {
					deferred.resolve(response);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			

		};
	}
]);