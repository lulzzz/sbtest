'use strict';

common.factory('payrollServer', [
	'Restangular', 'zionAPI', function (Restangular, zionAPI) {

		return Restangular.withConfig(function (RestangularConfigurer) {

			RestangularConfigurer.setBaseUrl(zionAPI.URL + 'Payroll');
			RestangularConfigurer.setRestangularFields({
				id: 'id'
			});
		});
	}
]);