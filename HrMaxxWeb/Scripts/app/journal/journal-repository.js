common.factory('journalRepository', [
	'$http', 'zionAPI', 'zionPaths', '$q', 'journalServer', 
	function ($http, zionAPI, zionPaths, $q, journalServer) {
		return {
			getJournalMetaData: function (companyId, companyIntId) {
				var deferred = $q.defer();
				journalServer.one('MetaData').one(companyId, companyIntId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getJournalList: function (companyId, accountId, startDate, endDate, includePayChecks) {
				var deferred = $q.defer();
				journalServer.all('AccountJournals').post({
					companyId: companyId,
					accountId: accountId,
					startDate: startDate,
					endDate: endDate,
					includePayrolls: includePayChecks
				}).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getVendorInvoiceMetaData: function (companyId, companyIntId) {
				var deferred = $q.defer();
				journalServer.one('VendorInvoiceMetaData').one(companyId, companyIntId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getVendorInvoiceList: function (companyId, startDate, endDate) {
				var deferred = $q.defer();
				journalServer.all('VendorInvoices').post({
					companyId: companyId,
					
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
			markJournalCleared: function (journal) {
				var deferred = $q.defer();
				journalServer.all('MarkJournalCleared').post(journal).then(function (data) {
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
			saveVendorInvoice: function (check) {
				var deferred = $q.defer();
				journalServer.all('SaveVendorInvoice').post(check).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			voidVendorInvoice: function (check) {
				var deferred = $q.defer();
				journalServer.all('VoidInvoice').post(check).then(function (data) {
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

					}).error(function (data) {
						var arr = new Uint8Array(data.data);
						var str = String.fromCharCode.apply(String, arr);
						deferred.reject(str);
					});

				return deferred.promise;
			},

		};
	}
]);