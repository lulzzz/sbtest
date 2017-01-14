common.factory('payrollRepository', [
	'$http', 'zionAPI', 'zionPaths', '$q', 'payrollServer', '$upload',
	function ($http, zionAPI, zionPaths, $q, payrollServer, upload) {
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
			savePayrollToStaging: function (payroll) {
				var deferred = $q.defer();
				payrollServer.all('SaveProcessedPayroll').post(payroll).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			deletePayroll: function (payroll) {
				var deferred = $q.defer();
				payrollServer.all('DeletePayroll').post(payroll).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			voidPayroll: function (payroll) {
				var deferred = $q.defer();
				payrollServer.all('VoidPayroll').post(payroll).then(function (data) {
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
			getUnPrintedPayrollList: function () {
				var deferred = $q.defer();
				payrollServer.one('UnPrintedPayrolls').getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},

			getPaycheckList: function (companyId, employeeId, startDate, endDate) {
				var deferred = $q.defer();
				payrollServer.one('EmployeeChecks').one(companyId, employeeId).getList().then(function (data) {
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
			getInvoicesForHost: function () {
				var deferred = $q.defer();
				payrollServer.one('HostInvoices').getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getApprovedInvoicesForHost: function () {
				var deferred = $q.defer();
				payrollServer.one('ApprovedInvoices').getList().then(function (data) {
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
			recreateInvoice: function (invoice) {
				var deferred = $q.defer();
				payrollServer.one('RecreateInvoice').one(invoice.id).get().then(function (result) {
					deferred.resolve(result);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			delayTaxes: function (invoice) {
				var deferred = $q.defer();
				payrollServer.one('DelayTaxes').one(invoice.id).get().then(function (result) {
					deferred.resolve(result);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			redateInvoiceAndPayroll: function (invoice, redate) {
				var deferred = $q.defer();
				invoice.invoiceDate = redate;
				payrollServer.all('RedateInvoice').post(invoice).then(function (result) {
					deferred.resolve(result);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getInvoiceById: function (invoiceId) {
				var deferred = $q.defer();
				payrollServer.one('PayrollInvoice').one(invoiceId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			claimInvoiceDelivery: function (invoiceIds) {
				var deferred = $q.defer();
				payrollServer.all('ClaimDelivery').post(invoiceIds).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getInvoiceDeliveryClaims: function () {
				var deferred = $q.defer();
				payrollServer.one('InvoiceDeliveryClaims').getList().then(function (list) {
					deferred.resolve(list);
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
			printPayrollReport: function (payroll) {
				var deferred = $q.defer();
				$http.post(zionAPI.URL + "Payroll/PrintPayrollReport", payroll, { responseType: "arraybuffer" }).success(
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
			printPayrollTimesheet: function (payroll) {
				var deferred = $q.defer();
				$http.post(zionAPI.URL + "Payroll/PrintPayrollTimesheet", payroll, { responseType: "arraybuffer" }).success(
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
			printPayrollChecks: function (payroll) {
				var deferred = $q.defer();
				$http.post(zionAPI.URL + "Payroll/PrintPayrollChecks", payroll, { responseType: "arraybuffer" }).success(
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
			getTimesheetImportTemplate: function (companyId, payTypes) {
				var deferred = $q.defer();
				$http.post(zionAPI.URL + "Payroll/TimesheetImportTemplate", {
					companyId: companyId,
					payTypes: payTypes
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
			importTimesheets: function (attachment) {
				var url = zionAPI.URL + 'Payroll/ImportTimesheets';
				var deferred = $q.defer();
				upload.upload({
					url: url,
					method: 'POST',
					data: {
						inspection: attachment.data
					},
					file: attachment.doc.file,
				}).success(function (data, status, headers, config) {
					attachment.doc.uploaded = true;
					attachment.completed = true;
					deferred.resolve(data);

				})
				.error(function (data, status, statusText, headers, config) {
					deferred.reject(statusText);
				});
				return deferred.promise;
			},
			importTimesheetsWithMap: function (attachment) {
				var url = zionAPI.URL + 'Payroll/ImportTimesheetsWithMap';
				var deferred = $q.defer();
				upload.upload({
					url: url,
					method: 'POST',
					data: {
						inspection: attachment.data
					},
					file: attachment.doc.file,
				}).success(function (data, status, headers, config) {
					attachment.doc.uploaded = true;
					attachment.completed = true;
					deferred.resolve(data);

				})
				.error(function (data, status, statusText, headers, config) {
					deferred.reject(statusText);
				});
				return deferred.promise;
			}
		};
	}
]);