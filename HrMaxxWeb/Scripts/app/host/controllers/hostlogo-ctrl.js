common.controller('hostlogo', [
	'$scope', 'localStorageService', 'zionAPI',
	function ($scope, localStorageService, zionAPI) {
		$scope.zionAPI = zionAPI;
		$scope.logo = null;
		$scope.getDocumentUrl = function (photo) {
			if (photo) {
				if (photo.id)
					return zionAPI.URL + 'DocumentById/' + photo.id + '/' + photo.documentExtension + '/' + photo.documentName;
			}
			return zionAPI.Web + "/Content/images/logo.png";

		};
		
		function _init() {
			var homepage = localStorageService.get('hostlogo');
			if (homepage) {
				$scope.logo = homepage;
			}
		};

		_init();
		
	}
]);