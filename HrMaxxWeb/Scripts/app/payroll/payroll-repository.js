common.factory('payrollRepository', [
	'$http', 'zionAPI', 'zionPaths', '$q', 'payrollServer', 
	function ($http, zionAPI, zionPaths, $q, payrollServer) {
		return {
			
			savePayroll: function(payroll) {
				var deferred = $q.defer();
				payrollServer.all('Payroll').post(payroll).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			processPayroll: function (payroll) {
				var deferred = $q.defer();
				payrollServer.all('Process').post(payroll).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			commitPayroll: function (payroll) {
				var deferred = $q.defer();
				payrollServer.all('Commit').post(payroll).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			voidPayCheck: function (payrollId, payCheckId) {
				var deferred = $q.defer();
				payrollServer.one('VoidPayCheck').one(payrollId, payCheckId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getPayCheckById: function (checkId) {
				var deferred = $q.defer();
				payrollServer.one('PayCheck/' + checkId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getPayrollList: function (companyId, startDate, endDate) {
				var deferred = $q.defer();
				payrollServer.all('Payrolls').post({
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
			getPayrollsForInvoice: function (invoiceId) {
				var deferred = $q.defer();
					payrollServer.one('PayrollsForInvoice').one(invoiceId).getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getInvoicesForCompany: function (companyId) {
				var deferred = $q.defer();
				payrollServer.one('Invoices').one(companyId).getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveInvoice: function (invoice) {
				var deferred = $q.defer();
				payrollServer.all('Invoice').post(invoice).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			createPayrollInvoice: function (payroll) {
				var deferred = $q.defer();
				payrollServer.all('CreatePayrollInvoice').post(payroll).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getInvoicesForHost: function (hostId) {
				var deferred = $q.defer();
				payrollServer.one('HostInvoices').one(hostId).getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			savePayrollInvoice: function (invoice) {
				var deferred = $q.defer();
				payrollServer.all('PayrollInvoice').post(invoice).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			deletePayrollInvoice: function (invoice) {
				var deferred = $q.defer();
				payrollServer.one('DeletePayrollInvoice').one(invoice.id).get().then(function () {
					deferred.resolve();
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getInvoiceById: function (invoiceId) {
				var deferred = $q.defer();
				payrollServer.one('Invoice').one(invoiceId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			markPayCheckPrinted: function (payCheckId) {
				var deferred = $q.defer();
				payrollServer.one('MarkPrinted/' + payCheckId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			printPayCheck: function (documentId, payCheckId) {
				var deferred = $q.defer();
				$http.post(zionAPI.URL + "Payroll/Print", {
					documentId: documentId,
					payCheckId: payCheckId
				}, { responseType: "arraybuffer" }).success(
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
			printPayroll: function (payroll) {
				var deferred = $q.defer();
				$http.post(zionAPI.URL + "Payroll/PrintPayroll", payroll, { responseType: "arraybuffer" }).success(
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