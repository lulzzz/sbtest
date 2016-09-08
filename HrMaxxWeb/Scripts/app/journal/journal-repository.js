common.factory('journalRepository', [
	'$http', 'zionAPI', 'zionPaths', '$q', 'journalServer', 
	function ($http, zionAPI, zionPaths, $q, journalServer) {
		return {
			getJournalMetaData: function (companyId) {
				var deferred = $q.defer();
				journalServer.one('MetaData').one(companyId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getJournalList: function (companyId, accountId, startDate, endDate) {
				var deferred = $q.defer();
				journalServer.all('AccountJournals').post({
					companyId: companyId,
					accountId: accountId,
					startDate: startDate,
					endDate: endDate
				}).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getAccountJournalList: function (companyId, startDate, endDate) {
				var deferred = $q.defer();
				journalServer.all('Accounts').post({
					companyId: companyId,
					accountId: -1,
					startDate: startDate,
					endDate: endDate
				}).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveCheck: function (check) {
				var deferred = $q.defer();
				journalServer.all('Journal').post(check).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			voidCheck: function (check) {
				var deferred = $q.defer();
				journalServer.all('Void').post(check).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},

			printCheck: function (journal) {
				var deferred = $q.defer();
				$http.post(zionAPI.URL + "Journal/Print", journal, { responseType: "arraybuffer" }).success(
					function (data, status, headers) {
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

					}).error(function (data, status) {
						var e = /* error */
						deferred.reject(e);
					});

				return deferred.promise;
			},

		};
	}
]);