common.controller('searchResult', [
	'$scope', 'localStorageService', 'zionAPI', 'reportRepository', '$q', '$rootScope',
	function ($scope, localStorageService, zionAPI, reportRepository, $q, $rootScope) {
		$scope.zionAPI = zionAPI;


		$scope.selectedResult = null;
		
		$scope.resultSelected = function ($item, $model, $label, $event) {
			if ($scope.selectedResult) {
				$rootScope.$broadcast('searchResultSelected', { result: $scope.selectedResult });
			}
		}

		$scope.getSearchResults = function (search) {
			var deferred = $q.defer();
			reportRepository.getSearchResults(search).then(function (data) {
				deferred.resolve(data);
			}, function (error) {
				deferred.reject(error);
			});
			return deferred.promise;
		}
	}
]);
