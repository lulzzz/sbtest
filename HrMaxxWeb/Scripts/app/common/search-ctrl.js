common.controller('searchResult', [
	'$scope', 'localStorageService', 'zionAPI', 'reportRepository', '$q', '$rootScope',
	function ($scope, localStorageService, zionAPI, reportRepository, $q, $rootScope) {
		$scope.zionAPI = zionAPI;
		$scope.loading = false;
		$scope.results = [];
		$scope.selectedResult = null;
		
		$scope.resultSelected = function ($item, $model, $label, $event) {
			if ($scope.selectedResult) {
				$scope.results = [];
				$rootScope.$broadcast('searchResultSelected', { result: $scope.selectedResult });
			}
		}

		$scope.reset = function() {
			$scope.selectedResult = null;
			$scope.results = [];
		}
		$scope.removeTagOnBackspace = function (event, viewvalue) {
			if (event.keyCode === 8 && (!viewvalue || viewvalue.length===0)) {
				$scope.reset();
			}
		};
		$scope.getSearchResults = function (search) {
			
				var deferred = $q.defer();
				$scope.loading = true;
				reportRepository.getSearchResults(search).then(function (data) {
					deferred.resolve(data);
					$scope.results = data;
					$scope.loading = false;
				}, function (error) {
					$scope.loading = false;
					deferred.reject(error);
				});


				return deferred.promise;
			
			
		}
	}
]);
