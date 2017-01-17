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
			getACHReport: function (request) {
				var deferred = $q.defer();
				reportServer.all('ACHReport').post(request).then(function (response) {
					deferred.resolve(response);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			
			getSearchResults: function (search) {
				var deferred = $q.defer();
				reportServer.one('SearchResults/' + search).getList().then(function (response) {
					deferred.resolve(response);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			fileTaxes: function (extract) {
				var deferred = $q.defer();
				reportServer.all('FileTaxes').post(extract).then(function (result) {
					deferred.resolve(result);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getExtractList: function (report) {
				var deferred = $q.defer();
				reportServer.one('ExtractList').one(report).getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getACHExtractList: function () {
				var deferred = $q.defer();
				reportServer.one('ACHExtractList').getList().then(function (data) {
					deferred.resolve(data);
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
			getACHDocumentAndFile: function (data) {
				var deferred = $q.defer();
				$http.post(zionAPI.URL + "Reports/ACHFileAndExtract", data, { responseType: "arraybuffer" }).then(
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
			getExtract: function (request) {
				var deferred = $q.defer();
				reportServer.all('ExtractDocument').post(request).then(function (response) {
					deferred.resolve(response);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			downloadExtract: function (file) {
				var deferred = $q.defer();
				$http.post(zionAPI.URL + "Reports/DownloadReport", file, { responseType: "arraybuffer" }).then(
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
			downloadExtractFile: function (file) {
				var deferred = $q.defer();
				$http.post(zionAPI.URL + "Reports/DownloadExtract", file, { responseType: "arraybuffer" }).then(
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