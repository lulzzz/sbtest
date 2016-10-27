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
			getReportDocument: function (request) {
				var deferred = $q.defer();
				$http.post(zionAPI.URL + "Reports/ReportDocument", request, { responseType: "arraybuffer" }).then(
					function (response) {
						var type = response.headers('Content-Type');
						var disposition = response.headers('Content-Disposition');
						if (disposition) {
							var match = disposition.match(/.*filename=\"?([^;\"]+)\"?.*/);
							if (match[1])
								defaultFileName = match[1];
						}
						defaultFileName = defaultFileName.replace(/[<>:"\/\\|?*]+/g, '_');
						var blob = new Blob([response.data], { type: type });
						var fileURL = URL.createObjectURL(blob);
						deferred.resolve({
							file: fileURL,
							name: defaultFileName
						});

					}, function (data) {
					var e = data.statusText;
						deferred.reject(e);
					});

				return deferred.promise;
			},
			getExtractDocument: function (request) {
				var deferred = $q.defer();
				$http.post(zionAPI.URL + "Reports/ExtractDocument", request, { responseType: "arraybuffer" }).then(
					function (response) {
						var type = response.headers('Content-Type');
						var disposition = response.headers('Content-Disposition');
						if (disposition) {
							var match = disposition.match(/.*filename=\"?([^;\"]+)\"?.*/);
							if (match[1])
								defaultFileName = match[1];
						}
						defaultFileName = defaultFileName.replace(/[<>:"\/\\|?*]+/g, '_');
						var blob = new Blob([response.data], { type: type });
						var fileURL = URL.createObjectURL(blob);
						deferred.resolve({
							file: fileURL,
							name: defaultFileName
						});

					}, function (data) {
						var e = data.statusText;
						deferred.reject(e);
					});

				return deferred.promise;
			},
			getDashboardData: function (report, startdate, enddate, criteria) {
				var deferred = $q.defer();

				reportServer.all('DashboardReport').post({
					report: report,
					startDate: startdate,
					endDate: enddate,
					criteria: criteria
				}).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});
				return deferred.promise;
			}

		};
	}
]);