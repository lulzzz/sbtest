'use strict';

common.directive('commentList', ['$modal', 'zionAPI', '$timeout', '$window',
	function ($modal, zionAPI, $timeout, $window) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				list: "=list",
				sourceTypeId: "=sourceTypeId",
				sourceId: "=sourceId",
				heading: "=heading"
			},
			templateUrl: zionAPI.Web + 'Content/templates/comment-list.html',

			controller: ['$scope', '$element', '$location', '$filter', 'commonRepository', 'EntityTypes', function ($scope, $element, $location, $filter, commonRepository, EntityTypes) {
				$scope.targetTypeId = EntityTypes.Comment;
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

			}]
		}
	}
]);
