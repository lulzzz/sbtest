common.controller('hostlogo', [
	'$scope', 'localStorageService', 'zionAPI', 'hostRepository',
	function ($scope, localStorageService, zionAPI, hostRepository) {
		$scope.zionAPI = zionAPI;
		$scope.logo = null;
		$scope.getDocumentUrl = function (photo) {
			if (photo) {
				if (photo.id)
					return zionAPI.URL + 'DocumentById/' + photo.id + '/' + photo.documentExtension + '/' + photo.documentName;
			}
			return zionAPI.Web + "/Content/images/logo.png";

		};
		$scope.$on('hostChanged', function(event, args) {
			var host = args.host;
			hostRepository.getHomePage(host.id).then(function(homepage) {
					$scope.logo = homepage.logo;
				},
				function(error) {

				});
		});
		function _init() {
			var homepage = localStorageService.get('hostlogo');
			if (homepage) {
				$scope.logo = homepage;
			}
		};

		_init();
		
	}
]);
common.directive('errSrc', function () {
	return {
		link: function (scope, element, attrs) {
			element.bind('error', function () {
				if (attrs.src != attrs.errSrc) {
					attrs.$set('src', attrs.errSrc);
				}
			});
		}
	}
});