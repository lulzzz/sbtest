﻿'use strict';

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
			var exists = $filter('filter')(item.accumulation.deductions, { deduction: { id: input } });
			if(exists.length>0)
				filtered.push(item);
		}
		return filtered;
	};
});
common.filter('workercompensation', function ($filter) {
	return function (items, input) {
		var filtered = [];
		for (var i = 0; i < items.length; i++) {
			var item = items[i];
			var exists = $filter('filter')(item.accumulation.workerCompensations, { workerCompensation: { id: input } });
			if (exists.length > 0)
				filtered.push(item);
		}
		return filtered;
	};
});