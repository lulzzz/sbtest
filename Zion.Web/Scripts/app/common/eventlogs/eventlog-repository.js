userEventLog.factory('userEventLogRepository', [
	'$q', 'commonServer', 'zionAPI', '$http',
	function($q, commonServer, zionAPI, $http) {
		return {
			getUserEventLog: function(userId, startdate, enddate) {
				var deferred = $q.defer();
				commonServer.all('GetUserEventLog').post({
					userId: userId,
					startDate: startdate,
					endDate: enddate
				}).then(function(data) {
					deferred.resolve(data);
				}, function(error) {
					alert(error);
					deferred.reject(error);
				});

				return deferred.promise;
			},

			getUserList: function() {
				var deferred = $q.defer();
				commonServer.one('GetUserList').getList().then(function(data) {
					deferred.resolve(data);
				}, function(error) {
					alert(error);
					deferred.reject(error);
				});

				return deferred.promise;
			},
			exportUserEventLog: function(userId, startdate, enddate) {

				var deferred = $q.defer();
				$http.post(zionAPI.URL + "ExportUserEventLog", {
					userId: userId,
					startDate: startdate,
					endDate: enddate
				}, { responseType: "arraybuffer" }).success(
					function(data, status, headers) {
						var type = headers('Content-Type');
						var disposition = headers('Content-Disposition');
						if (disposition) {
							var match = disposition.match(/.*filename=\"?([^;\"]+)\"?.*/);
							if (match[1])
								defaultFileName = match[1];
						}
						defaultFileName = defaultFileName.replace(/[<>:"\/\\|?*]+/g, '_');
						var blob = new Blob([data], { type: type });
						var fileURL = URL.createObjectURL(blob);
						deferred.resolve({
							file: fileURL,
							name: defaultFileName
						});

					}).error(function(data, status) {
					var e = /* error */
						deferred.reject(e);
				});

				return deferred.promise;
			}

		};

	}
]);