'use strict';

common.factory('reportServer', [
	'Restangular', 'zionAPI', function (Restangular, zionAPI) {

		return Restangular.withConfig(function (RestangularConfigurer) {

			RestangularConfigurer.setBaseUrl(zionAPI.URL + 'Reports');
			RestangularConfigurer.setRestangularFields({
				id: 'id'
			});
		});
	}
]);
common.filter('employeename', function () {
	return function (items, input) {
		var filtered = [];
		for (var i = 0; i < items.length; i++) {
			var item = items[i];
			if ( (item.employee.name && item.employee.name.toLowerCase().indexOf(input) >= 0) || (item.employee.fullName && item.employee.fullName.toLowerCase().indexOf(input) >= 0))
				filtered.push(item);
		}
		return filtered;
	};
});
common.filter('department', function () {
	return function (items, input) {
		var filtered = [];
		for (var i = 0; i < items.length; i++) {
			var item = items[i];
			if (item.employee.department.toLowerCase().indexOf(input) >= 0)
				filtered.push(item);
		}
		return filtered;
	};
});
common.filter('deduction', function ($filter) {
	return function (items, input) {
		var filtered = [];
		for (var i = 0; i < items.length; i++) {
			var item = items[i];
			var exists = $filter('filter')(item.deductions, { companyDeductionId: input });
            if (exists.length > 0) {
                item.employeeDeductions = 0;
                item.employerDeductions = 0;
                for (var j = 0; j < exists.length; j++) {
                    item.employeeDeductions += exists[j].ytd;
                    item.employerDeductions += exists[j].ytdEmployer;
                }
                
                filtered.push(item);
            }
				
		}
		return filtered;
	};
});
common.filter('workercompensation', function ($filter) {
	return function (items, input) {
		var filtered = [];
		for (var i = 0; i < items.length; i++) {
			var item = items[i];
			var exists = $filter('filter')(item.workerCompensations, { workerCompensationId: input });
			if (exists.length > 0)
				filtered.push(item);
		}
		return filtered;
	};
});