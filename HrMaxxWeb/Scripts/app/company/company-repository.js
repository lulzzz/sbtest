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

		};
	}
]);