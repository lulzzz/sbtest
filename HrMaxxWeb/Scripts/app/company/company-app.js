'use strict';

common.factory('companyServer', [
	'Restangular', 'zionAPI', function (Restangular, zionAPI) {

		return Restangular.withConfig(function (RestangularConfigurer) {

			RestangularConfigurer.setBaseUrl(zionAPI.URL + 'Company');
			RestangularConfigurer.setRestangularFields({
				id: 'id'
			});
		});
	}
]);