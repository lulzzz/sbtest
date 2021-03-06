common.factory('companyRepository', [
	'$http', 'zionAPI', 'zionPaths', '$q', '$upload', 'companyServer', '$filter', 'Entities',
	function ($http, zionAPI, zionPaths, $q, upload, companyServer, $filter, Entities) {
		return {
			getAllCompanies: function (year) {
				var deferred = $q.defer();
				companyServer.one('AllCompanies/' + year).getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getCompanyMetaData: function () {
				var deferred = $q.defer();
				companyServer.one('MetaData').get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getTimesheetMetaData: function (company) {
				var deferred = $q.defer();
				companyServer.one('TimesheetMetaData').one(company).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getEmployeeMetaData: function () {
				var deferred = $q.defer();
				companyServer.one('EmployeeMetaData').get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},

			getPayrollMetaData: function (request) {
				var deferred = $q.defer();
				companyServer.all('PayrollMetaData').post(request).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			raiseMinWage: function (request) {
				var deferred = $q.defer();
				companyServer.all('RaiseMinWage').post(request).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getInvoiceMetaData: function (companyId) {
				var deferred = $q.defer();
				companyServer.one('InvoiceMetaData').one(companyId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getCompanyList: function (hostId) {
				var deferred = $q.defer();
				companyServer.one('Companies', hostId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getCompanyListAll: function () {
				var deferred = $q.defer();
				companyServer.one('Companies').get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getEmployeeTimesheet: function (companyId, employeeId, month, year) {
				var deferred = $q.defer();
				var data = {
					companyId: companyId,
					month: month,
					year: year
				};
				if (employeeId)
					data.employeeId = employeeId;
				companyServer.all('GetEmployeeTimesheet').post(data).then(function (data) {
					deferred.resolve(data.plain());
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getCompany: function (id) {
				var deferred = $q.defer();
				companyServer.one('Company', id).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveCompany: function (company) {
				var deferred = $q.defer();
				companyServer.all('Save').post(company).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveLocation: function (company) {
				var deferred = $q.defer();
				companyServer.all('SaveLocation').post(company).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			copyCompany: function (company) {
				var deferred = $q.defer();
				companyServer.all('Copy').post(company).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			copyEmployees: function (sourceCompanyId, targetCompanyId, employees, keepEmployeeNumbers) {
				var deferred = $q.defer();
				companyServer.all('CopyEmployees').post({ sourceCompanyId: sourceCompanyId, targetCompanyId: targetCompanyId, employeeIds: employees, keepEmployeeNumbers: keepEmployeeNumbers }).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveCompanyDeduction: function (deduction) {
				var deferred = $q.defer();
				companyServer.all('Deduction').post(deduction).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;

			},
			saveWorkerCompensation: function (input) {
				var deferred = $q.defer();
				companyServer.all('WorkerCompensation').post(input).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveTaxYearRate: function (input) {
				var deferred = $q.defer();
				companyServer.all('TaxYearRate').post(input).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveAccumulatedPayType: function (input) {
				var deferred = $q.defer();
				companyServer.all('AccumulatedPayType').post(input).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			savePayCode: function (input) {
				var deferred = $q.defer();
				companyServer.all('PayCode').post(input).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveRenewalDate: function (input) {
				var deferred = $q.defer();
				companyServer.all('Renewal').post(input).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveProject: function (input) {
				var deferred = $q.defer();
				companyServer.all('Projects').post(input).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getProducts: function (companyId) {
				var deferred = $q.defer();
				companyServer.one('Products').one(companyId).getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveProduct: function (input) {
				var deferred = $q.defer();
				companyServer.all('Products').post(input).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getVendorCustomers: function (companyId, isVendor) {
				var deferred = $q.defer();
				if (companyId) {
					companyServer.one('Vendors').one(isVendor, companyId).getList().then(function (data) {
						deferred.resolve(data);
					}, function(error) {
						deferred.reject(error);
					});
				} else {
					companyServer.one('GlobalVendors').getList().then(function (data) {
						deferred.resolve(data);
					}, function (error) {
						deferred.reject(error);
					});
				}
				

				return deferred.promise;
			},
			saveVendorCustomer: function (vendor) {
				var deferred = $q.defer();
				companyServer.all('VendorCustomer').post(vendor).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getCompanyAccounts: function (companyId) {
				var deferred = $q.defer();
				companyServer.one('Accounts').one(companyId).getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveCompanyAccount: function (account) {
				var deferred = $q.defer();
				companyServer.all('Accounts').post(account).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getEmployees: function (companyId, status) {
				var deferred = $q.defer();
				companyServer.one('Employees').one(companyId, status).getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			bulkTerminateEmployees: function (companyId, employees) {
				var deferred = $q.defer();
				companyServer.all('BulkTerminateEmployees').post({companyId:companyId, employeeList: employees}).then(function () {
					deferred.resolve();
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveEmployee: function (employee) {
				var deferred = $q.defer();
				companyServer.all('Employee').post(employee).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveEmployeeTimesheet: function (timesheet) {
				var deferred = $q.defer();
				companyServer.all('EmployeeTimesheet').post(timesheet).then(function (data) {
					deferred.resolve(data.plain());
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveTimesheets: function (timesheets) {
				var deferred = $q.defer();
				companyServer.all('EmployeeTimesheets').post(timesheets).then(function (data) {
					deferred.resolve(data.plain());
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			deleteEmployeeTimesheet: function (id) {
				var deferred = $q.defer();
				companyServer.one('DeleteEmployeeTimesheet/' + id).get().then(function (data) {
					deferred.resolve(data.plain());
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveEmployeeACA: function (deduction) {
				var deferred = $q.defer();
				companyServer.all('EmployeeACA').post(deduction).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveEmployeeDeduction: function(deduction) {
				var deferred = $q.defer();
				companyServer.all('EmployeeDeduction').post(deduction).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			deleteEmployeeDeduction: function (deductionId) {
				var deferred = $q.defer();
				companyServer.one('DeleteEmployeeDeduction', deductionId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveTaxRates: function (rates) {
				var deferred = $q.defer();
				companyServer.all('SaveTaxRates').post(rates).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveRenewalDone: function (companyId, renewalId) {
				var deferred = $q.defer();
				companyServer.one('SaveRenewalDate').one(companyId, renewalId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getEmployeeImportTemplate: function (companyId) {
				var deferred = $q.defer();
				$http.get(zionAPI.URL + "Company/EmployeeImport/" + companyId, { responseType: "arraybuffer" }).success(
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
			importTimesheetsWithMap: function (attachment) {
				var url = zionAPI.URL + 'Company/ImportTimesheetsWithMap';
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
					.error(function (data) {
						if (data) {
							if (data.data) {
								var arr = new Uint8Array(data.data);
								var str = String.fromCharCode.apply(String, arr);
								deferred.reject(str);
							}
							else {
								deferred.reject(data);
							}
						}
						else {
							deferred.reject('');
						}


					});
				return deferred.promise;
			},

			importEmployees: function (attachment) {
				var url = zionAPI.URL + 'Company/ImportEmployees';
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
					deferred.reject(data.exceptionMessage);
				});
				return deferred.promise;
			},
			importTaxRates: function (attachment) {
				var url = zionAPI.URL + 'Company/ImportTaxRates';
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
				.error(function (data) {
					deferred.reject(data);
				});
				return deferred.promise;
			},
			importWCRates: function (attachment) {
				var url = zionAPI.URL + 'Company/ImportWCRates';
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
				.error(function (data) {
					deferred.reject(data);
				});
				return deferred.promise;
			},
			uploadWCRates: function(list, option) {
				var deferred = $q.defer();
				companyServer.all('UpdateWCRates').post({ rates: list , wcImportOption: option}).then(function () {
					deferred.resolve();
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getCaliforniaEDDExport: function () {
				var deferred = $q.defer();
				$http.get(zionAPI.URL + "Company/CaliforniaEDD", { responseType: "arraybuffer" }).success(
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
			checkSSN: function (ssn) {
				var deferred = $q.defer();
				companyServer.one('SSNCheck/' + ssn).getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},


		};
	}
]);