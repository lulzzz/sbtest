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
			getCPAReport: function (request) {
				var deferred = $q.defer();
				reportServer.all('CPAReport').post(request).then(function (response) {
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
				
				reportServer.all('SearchResults').post({criteria: search}).then(function (response) {
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
			payCommissions: function (extract) {
				var deferred = $q.defer();
				reportServer.all('PayCommissions').post(extract).then(function (result) {
					deferred.resolve(result);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			createDepositTickets: function (extract) {
				var deferred = $q.defer();
				reportServer.all('CreateDepositTickets').post(extract).then(function () {
					deferred.resolve();
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
			deleteExtract: function (extractId) {
				var deferred = $q.defer();
				reportServer.one('DeleteExtract/' + extractId).get().then(function () {
					deferred.resolve();
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			confirmExtract: function (extract) {
				var deferred = $q.defer();
				reportServer.all('confirmExtract').post(extract).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getMasterExtract: function (report) {
				var deferred = $q.defer();
				reportServer.one('Extract/' + report).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getCommissionsExtract: function (report) {
				var deferred = $q.defer();
				reportServer.one('CommissionExtract/' + report).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getACHExtractById: function (report) {
				var deferred = $q.defer();
				reportServer.one('ACHExtract/' + report).get().then(function (data) {
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
			getCommissionsReport: function (request) {
				var deferred = $q.defer();
				reportServer.all('CommissionsReport').post(request).then(function (response) {
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
							name: defaultFileName,
							data : response.data
						});

					}, function (data) {
						var e = data.statusText;
						deferred.reject(e);
					});

				return deferred.promise;
			},
			printExtractBatch: function (file) {
				var deferred = $q.defer();
				$http.post(zionAPI.URL + "Reports/PrintExtractBatch", file, { responseType: "arraybuffer" }).then(
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
							name: defaultFileName,
							data: response.data
						});

					}, function (data) {
						var e = data.statusText;
						deferred.reject(e);
					});

				return deferred.promise;
			},
			getExtractDocument: function (request) {
				var deferred = $q.defer();
				$http.post(zionAPI.URL + "Reports/ExtractDocumentReport", request, { responseType: "arraybuffer" }).then(
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
			printExtract: function (journals, report) {
				var deferred = $q.defer();
				$http.post(zionAPI.URL + "Reports/PrintExtractChecks", {
					journals: journals,
					report: report
				}, { responseType: "arraybuffer" }).then(
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
			getDashboardData: function (report, startdate, enddate, criteria, onlyActive) {
				var deferred = $q.defer();

				reportServer.all('DashboardReport').post({
					report: report,
					startDate: startdate,
					endDate: enddate,
					criteria: criteria,
					onlyActive: onlyActive
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