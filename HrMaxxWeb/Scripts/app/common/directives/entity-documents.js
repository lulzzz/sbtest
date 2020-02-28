'use strict';

common.directive('entityDocuments', ['zionAPI', '$timeout', '$window','version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData",
				heading: "=heading",
				sourceTypeId: "=sourceTypeId",
				sourceId: "=sourceId"
			},
			templateUrl: zionAPI.Web + 'Content/templates/entity-documents.html?v=' + version,

			controller: ['$scope', '$element', '$location', 'NgTableParams', '$filter', 'commonRepository', 'EntityTypes',
				function ($scope, $element, $location, ngTableParams, $filter, commonRepository, EntityTypes) {
					$scope.targetTypeId = EntityTypes.Document;
					
					$scope.list = [];
					
					$scope.documentTypes = [];
										
					var dataSvc = {
						selectedType: 6,
						docType: {
							id:6, name: 'Entity Document', category: 4
						}
					}
					$scope.data = dataSvc;
					
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
						getData: function (params) {
							$scope.fillTableData(params);
							return $scope.tableData;
						}
					});

					$scope.fillTableData = function (params) {
						// use build-in angular filter
						if ($scope.list && $scope.list.length>0) {
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
							if (!$file || !($file.name.toLowerCase().endsWith(".bmp") || $file.name.toLowerCase().endsWith(".png") || $file.name.toLowerCase().endsWith(".jpg") || $file.name.toLowerCase().endsWith(".jpeg") || $file.name.toLowerCase().endsWith(".tiff") || $file.name.toLowerCase().endsWith(".gif"))) {
								$scope.alerts.push({
									message: 'Please select an image (png, tiff, jpg, jpeg, bmp) file '
								});
								return false;
							} else {
								var fileReader = new FileReader();
								fileReader.readAsDataURL($files[i]);
								var loadFile = function(fileReader, index) {
									fileReader.onload = function(e) {
										$timeout(function() {
											$scope.files.push({
												doc: {
													file: $files[index],
													file_data: e.target.result,
													uploaded: false
												},
												data: JSON.stringify({
													entityTypeId: $scope.sourceTypeId,
													entityId: $scope.sourceId,
													mimeType: $files[index].type,
													documentType: dataSvc.selectedType,
													type: dataSvc.docType
												}),
												currentProgress: 0,
												completed: false
											});
										});
									}
								}(fileReader, i);
							}
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
								$scope.mainData.showMessage('error uploading file', 'danger');
							
							});

						}
					}
					
					$scope.deleteDocument = function(doc) {
						$scope.mainData.confirmDialog('Are you sure you want to delete this document?', 'danger', function() {
							commonRepository.deleteDocument($scope.sourceTypeId, $scope.sourceId, doc.targetEntityId).then(function() {
								$scope.list.splice($scope.list.indexOf(doc), 1);
								$scope.tableParams.reload();
								$scope.fillTableData($scope.tableParams);
								$scope.mainData.showMessage('successfully removed file', 'success');
							}, function() {
								$scope.mainData.showMessage('error deleting document', 'danger');

							});
						});
                    }
                    
					$scope.removeFile = function(index) {

						$scope.files.splice(index, 1);
					}
					$scope.getDocumentUrl = function (document) {
						if (!document)
							return '';
						return zionAPI.URL + 'Document/' + document.targetEntityId;
					};
					
					
					
					var init = function() {
						commonRepository.getDocuments($scope.sourceTypeId, $scope.sourceId).then(function (data) {
							$scope.list = data;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
						}, function (erorr) {

						});
						
					}
					init();

				}]
		}
	}
]);
