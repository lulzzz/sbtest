'use strict';

var hostmodule = angular.module('host', ['common']);
common.factory('hostServer', [
	'Restangular', 'zionAPI', function (Restangular, zionAPI) {

		return Restangular.withConfig(function (RestangularConfigurer) {

			RestangularConfigurer.setBaseUrl(zionAPI.URL + 'Host');
			RestangularConfigurer.setRestangularFields({
				id: 'id'
			});
		});
	}
]);