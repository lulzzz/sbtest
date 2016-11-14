'use strict';

common.directive('mementoList', ['$uibModal', 'zionAPI', '$timeout', '$window', 'version',
	function ($modal, zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData",
				sourceTypeId: "=sourceTypeId",
				mementoId: "=mementoId",
				heading: "=heading",
				data: "=data"
			},
			templateUrl: zionAPI.Web + 'Content/templates/memento-list.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'commonRepository', 'EntityTypes', function ($scope, $element, $location, $filter, commonRepository, EntityTypes) {
				$scope.targetTypeId = EntityTypes.Comment;
				$scope.list = [];
				$scope.selected = null;
				$scope.EntityTypes = EntityTypes;
				$scope.set = function(m) {
					$scope.selected = null;
					$timeout(function () {
						$scope.selected = angular.copy(m.object);

					}, 1);
				}
				
				
				var init = function () {
					commonRepository.getMementos($scope.sourceTypeId, $scope.mementoId).then(function (data) {
						$scope.list = data;

					}, function (erorr) {

					});
				}
				$scope.showmemento = function (memento) {
					$scope.selected = memento.object;
					var modalInstance = $modal.open({
						templateUrl: 'popover/memento.html',
						controller: 'mementoCtrl',
						size: 'lg',
						windowClass: 'my-modal-popup',
						backdrop: true,
						keyboard: true,
						backdropClick: true,
						resolve: {
							memento: function () {
								return memento;
							},
							mainData: function () {
								return $scope.mainData;
							},
							sourceTypeId: function() {
								return $scope.sourceTypeId;
							},
							dataSvc: function() {
								return $scope.data;
							}
						}
					});
					modalInstance.result.then(function (result) {
						$scope.selected = null;
					}, function () {
						$scope.selected = null;
					});
				}
				init();

			}]
		}
	}
]);
common.controller('mementoCtrl', function ($scope, $uibModalInstance, sourceTypeId, mainData, memento, dataSvc) {
	$scope.mainData = mainData;
	$scope.memento = angular.copy(memento);
	$scope.sourceTypeId = sourceTypeId;
	$scope.dataSvc = dataSvc;
	

	$scope.cancel = function () {
		$uibModalInstance.close($scope);
	};

	
});