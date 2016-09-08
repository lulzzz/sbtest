'use strict';

common.directive('commentList', ['zionAPI', '$timeout', '$window','version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				sourceTypeId: "=sourceTypeId",
				sourceId: "=sourceId",
				heading: "=heading"
			},
			templateUrl: zionAPI.Web + 'Content/templates/comment-list.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'commonRepository', 'EntityTypes', function ($scope, $element, $location, $filter, commonRepository, EntityTypes) {
				$scope.targetTypeId = EntityTypes.Comment;
				$scope.list = [];
				var addAlert = function (error, type) {
					$scope.alerts = [];
					$scope.alerts.push({
						msg: error,
						type: type
					});
				};
				$scope.closeAlert = function (index) {
					$scope.alerts.splice(index, 1);
				};
				$scope.comment = {
					content:''
				};
				$scope.saveComment = function() {
					commonRepository.saveComment({
						sourceTypeId: $scope.sourceTypeId,
						targetTypeId: $scope.targetTypeId,
						sourceId: $scope.sourceId,
						content: $scope.comment.content
					}).then(function(comment) {
						$scope.list.push(comment);
						$scope.comment = { content: '' };   
					}, function(error) {
						addAlert('error saving comment', 'danger');
					});
				}
				var init = function () {
					commonRepository.getRelatedEntities($scope.sourceTypeId, $scope.targetTypeId, $scope.sourceId).then(function (data) {
						$scope.list = data;
						
					}, function (erorr) {

					});
				}
				init();

			}]
		}
	}
]);
