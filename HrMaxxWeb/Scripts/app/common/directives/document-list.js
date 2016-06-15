'use strict';

common.directive('documentList', ['$modal', 'zionAPI', '$timeout', '$window',
	function ($modal, zionAPI, $timeout, $window) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				list: "=list",
				entityTypeId: "=entityTypeId",
				entityId: "=entityId",
				heading: "=heading"
			},
			templateUrl: zionAPI.Web + 'Content/templates/document-list.html',

			controller: ['$scope', '$element', '$location', 'ngTableParams', '$filter', 'commonRepository', function ($scope, $element, $location, ngTableParams, $filter, commonRepository) {

				$scope.addAlert = function (error, type) {
					$scope.alerts = [];
					$scope.alerts.push({
						msg: error,
						type: type
					});
				};
				$scope.closeAlert = function (index) {
					$scope.alerts.splice(index, 1);
				};

				$scope.files = [];

				
				///paging

				$scope.tableData = [];
				$scope.tableParams = new ngTableParams({
					page: 1,            // show first page
					count: 10,

					filter: {
						documentName: '',       // initial filter
					},
					sorting: {
						documentName: 'asc'     // initial sorting
					}
				}, {
					total: $scope.list ? $scope.list.length : 0, // length of data
					getData: function ($defer, params) {
						$scope.fillTableData(params);
						$defer.resolve($scope.tableData);
					}
				});

				$scope.fillTableData = function (params) {
					// use build-in angular filter
					if ($scope.list) {
						var orderedData = params.filter() ?
		$filter('filter')($scope.list, params.filter()) :
		$scope.list;
						
						orderedData = params.sorting() ?
		$filter('orderBy')(orderedData, params.orderBy()) :
		orderedData;
						
						$scope.tableParams = params;
						$scope.tableData = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count());

						params.total(orderedData.length); // set total for recalc pagination
					}
				};

				$scope.onFileSelect = function ($files) {
					for (var i = 0; i < $files.length; i++) {
						var $file = $files[i];

						var fileReader = new FileReader();
						fileReader.readAsDataURL($files[i]);
						var loadFile = function (fileReader, index) {
							fileReader.onload = function (e) {
								$timeout(function () {
									$scope.files.push({
										doc: {
											file: $files[index],
											file_data: e.target.result,
											uploaded: false
										},
										data: JSON.stringify({
											entityTypeId: $scope.entityTypeId,
											entityId: $scope.entityId,
											mimeType: $files[index].type
										}),
										currentProgress: 0,
										completed: false
									});
								});
							}
						}(fileReader, i);
					}
				};

				$scope.uploadAll = function() {
					$.each($scope.files, function (index, file) {
						$scope.uploadDocument(index);
					});
				};

				$scope.uploadDocument = function (index) {
					if (!$scope.files[index].uploaded) {
						
						commonRepository.uploadDocument($scope.files[index]).then(function (doc) {
							$scope.list.push(doc);
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
						}, function() {
							$scope.files[index].doc.uploaded = false;
							$scope.files[index].currentProgress = 0;
							$scope.addAlert('error uploading file', 'danger');
							
						});

					}
				}
				$scope.deleteDocument = function(doc) {
					commonRepository.deleteDocument($scope.entityTypeId, $scope.entityId, doc.id).then(function () {
						$scope.list.splice($scope.list.indexOf(doc), 1);
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						$scope.addAlert('successfully removed file', 'success');
					}, function () {
						$scope.addAlert('error deleting document', 'danger');

					});
				}
				$scope.removeFile = function(index) {

					$scope.files.splice(index, 1);
				}
				$scope.getDocumentUrl = function (document) {

					return zionAPI.URL + 'Document/' + document.id;
				};
				
				
			}]
		}
	}
]);
