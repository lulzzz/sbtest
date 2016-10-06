common.factory('companyRepository', [
	'$http', 'zionAPI', 'zionPaths', '$q', '$upload', 'companyServer', '$filter', 'Entities',
	function ($http, zionAPI, zionPaths, $q, upload, companyServer, $filter, Entities) {
		return {
			getCompanyMetaData: function () {
				var deferred = $q.defer();
				companyServer.one('MetaData').get().then(function (data) {
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

			getPayrollMetaData: function (companyId) {
				var deferred = $q.defer();
				companyServer.one('PayrollMetaData').one(companyId).get().then(function (data) {
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
			saveCompany: function (company) {
				var deferred = $q.defer();
				companyServer.all('Save').post(company).then(function (data) {
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
			getVendorCustomers: function (companyId, isVendor) {
				var deferred = $q.defer();
				companyServer.one('Vendors').one(companyId, isVendor).getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

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
			getEmployees: function (companyId) {
				var deferred = $q.defer();
				companyServer.one('Employees').one(companyId).getList().then(function (data) {
					deferred.resolve(data);
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

					}).error(function (data, status) {
						var e = /* error */
						deferred.reject(e);
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
					deferred.reject(statusText);
				});
				return deferred.promise;
			}

		};
	}
]);