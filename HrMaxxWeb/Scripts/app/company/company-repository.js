companymodule.factory('companyRepository', [
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
			}
		};
	}
]);