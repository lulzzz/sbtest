common.controller('hostlogo', [
	'$scope', 'localStorageService', 'zionAPI', 'hostRepository',
	function ($scope, localStorageService, zionAPI, hostRepository) {
		$scope.zionAPI = zionAPI;
		$scope.logo = null;
		$scope.getPaxolLogo = function() {
			return zionAPI.Web + "/Content/images/logo.png";
		}
		$scope.getDocumentUrl = function (photo) {
			if (photo) {
				if (photo.id)
					return zionAPI.URL + 'DocumentById/' + photo.id + '/' + photo.documentExtension + '/' + photo.documentName;
			}
			return '';

		};
		$scope.$on('hostChanged', function(event, args) {
			var host = args.host;
			$scope.logo = host.homePage.logo;
			
		});
		$scope.$on('welcomeChanged', function (event, args) {
			$scope.logo = args.logo;

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