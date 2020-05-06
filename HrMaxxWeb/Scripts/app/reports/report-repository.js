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
			getProfitStarsPayroll: function () {
				var deferred = $q.defer();
				reportServer.one('ProfitStarsPayrollList').getList().then(function (response) {
					deferred.resolve(response);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			markSettled: function (fundRequestId) {
				var deferred = $q.defer();
				reportServer.one('MarkFundingSuccessful/' + fundRequestId).getList().then(function (response) {
					deferred.resolve(response);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			run1pm: function () {
				var deferred = $q.defer();
				reportServer.one('ProfitStars1pm').get().then(function (response) {
					deferred.resolve(response);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			run9am: function () {
				var deferred = $q.defer();
				reportServer.one('ProfitStars9am').get().then(function (response) {
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
			getStaffDashboard: function (hostId) {
				var deferred = $q.defer();
				var url = "StaffDashboard";
				if (hostId)
					url += "/" + hostId;
				reportServer.one(url).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getStaffDashboardDocuments: function (hostId) {
				var deferred = $q.defer();
				var url = "StaffDashboardDocuments";
				if (hostId)
					url += "/" + hostId;
				reportServer.one(url).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getCompanyDashboard: function (companyId) {
				var deferred = $q.defer();
				reportServer.one('CompanyDashboard/' + companyId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getEmployeeDashboard: function (companyId, employeeId) {
				var deferred = $q.defer();
				reportServer.one('EmployeeDashboard').one(companyId, employeeId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getExtractDashboard: function () {
				var deferred = $q.defer();
				reportServer.one('ExtractDashboard/').get().then(function (data) {
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
			getDocument: function (url, request) {
				var deferred = $q.defer();
				$http.post(url, request, { responseType: "arraybuffer" }).then(
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
						var arr = new Uint8Array(data.data);
						var str = String.fromCharCode.apply(String, arr);
						deferred.reject(str);
					});

				return deferred.promise;
			},
			getReportDocument: function (request) {
				return this.getDocument(zionAPI.URL + "Reports/ReportDocument", request);
				
			},
			getACHDocumentAndFile: function (data) {
				return this.getDocument(zionAPI.URL + "Reports/ACHFileAndExtract", data);
				
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
			getMinWageEligibilityReport: function (request) {
				var deferred = $q.defer();
				reportServer.all('MinWageEligibilityReport').post(request).then(function (response) {
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
				return this.getDocument(zionAPI.URL + "Reports/DownloadReport", file);
				
			},
			downloadExtractFile: function (file) {
				return this.getDocument(zionAPI.URL + "Reports/DownloadExtract", file);
				
			},
			printExtractBatch: function (file) {
				return this.getDocument(zionAPI.URL + "Reports/PrintExtractBatch", file);
				
			},
			printExtractBatchAll: function (file) {
				return this.getDocument(zionAPI.URL + "Reports/PrintExtractBatchAll", file);
				
			},
			getExtractDocument: function (request) {
				return this.getDocument(zionAPI.URL + "Reports/ExtractDocumentReport", request);
				
			},
			printExtract: function (journals, report) {
				return this.getDocument(zionAPI.URL + "Reports/PrintExtractChecks", {
					journals: journals,
					report: report
				});
				
			},
			emailExtractClients: function (journals, report) {
				var deferred = $q.defer();
				reportServer.all('EmailExtractClients').post({
					journals: journals,
					report: report
				}).then(function (response) {
					deferred.resolve(response);
				}, function (error) {
					deferred.reject(error);
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
			},
			getInvoiceStatusList: function (report, startdate, enddate, criteria, onlyActive) {
				var deferred = $q.defer();

				reportServer.all('InvoiceStatusList').post({
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