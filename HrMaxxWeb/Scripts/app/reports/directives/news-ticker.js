'use strict';

common.directive('newsTicker', ['zionAPI', '$timeout', '$window', 'version', '$sce',
	function (zionAPI, $timeout, $window, version, $sce) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: $sce.trustAsResourceUrl(zionAPI.Web + 'Areas/Reports/templates/news-ticker.html?v=' + version),

			controller: ['$scope', '$element', '$location', '$filter', 'commonRepository', '$anchorScroll', 'ClaimTypes',
				function ($scope, $element, $location, $filter, commonRepository, $anchorScroll, ClaimTypes) {
					var dataSvc = {
						myNews: []
					}
					$scope.data = dataSvc;
					$scope.loadData = function () {
						commonRepository.getUserNews().then(function (data) {
							dataSvc.myNews = data;

						}, function (erorr) {

						});
					}

					function _init() {
						$scope.loadData();
					};

					_init();


				}]
		}
	}
]);
