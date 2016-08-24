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
			}

		};
	}
]);