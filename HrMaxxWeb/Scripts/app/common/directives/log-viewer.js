'use strict';

common.directive('logViewer', ['zionAPI', '$timeout', '$window','version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				
			},
			templateUrl: zionAPI.Web + 'Content/templates/log-view.html?v=' + version,

			controller: ['$scope', '$element',  'commonRepository', function ($scope, $element, commonRepository) {
				$scope.logs = '';
				$scope.refresh = function () {
					commonRepository.getLog().then(function (data) {
						$scope.logs = data;

					}, function (erorr) {

					});	
				}
				$scope.refresh();

			}]
		}
	}
]);
