'use strict';

var notification = angular.module('notification', ['restangular', 'common']);

angular.element(document).ready(function() {
	angular.bootstrap(document.getElementById('dvNotifications'), ['notification']);
});