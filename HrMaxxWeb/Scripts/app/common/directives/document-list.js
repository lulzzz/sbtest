'use strict';

common.directive('documentList', ['zionAPI', '$timeout', '$window','version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData",
				heading: "=heading"
			},
			templateUrl: zionAPI.Web + 'Content/templates/document-list.html?v=' + version,

			controller: ['$scope', '$element', '$location', 'NgTableParams', '$filter', 'commonRepository', 'EntityTypes',
				function ($scope, $element, $location, ngTableParams, $filter, commonRepository, EntityTypes) {
					$scope.targetTypeId = EntityTypes.Document;
					$scope.sourceTypeId = $scope.mainData.userRole.employee ? EntityTypes.Employee : EntityTypes.Company;
					$scope.sourceId = $scope.mainData.selectedCompany.id;
					$scope.list = [];
					$scope.documentTypes = [];
					$scope.companyDocumentSubTypes = [];
					
					var dataSvc = {
						selectedType: null, selectedSubType: null
					}
					$scope.data = dataSvc;
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
							if (dataSvc.selectedType.id===1 && (!$file || !($file.name.toLowerCase().endsWith(".bmp") || $file.name.toLowerCase().endsWith(".png") || $file.name.toLowerCase().endsWith(".jpg") || $file.name.toLowerCase().endsWith(".jpeg") || $file.name.toLowerCase().endsWith(".tiff") || $file.name.toLowerCase().endsWith(".gif")))) {
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
													type: dataSvc.selectedType,
													documentType: dataSvc.selectedType.id,
													companyDocumentSubType: dataSvc.selectedSubType
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
								$scope.addAlert('error uploading file', 'danger');
							
							});

						}
					}
					$scope.deleteDocument = function(doc) {
						commonRepository.deleteDocument($scope.sourceTypeId, $scope.sourceId, doc.id).then(function () {
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

					$scope.addDocumentType = function () {
						var dt = {
							id: 0, name: '', category: null, isEmployeeRequired: false, trackAccess: false, companyId: $scope.mainData.selectedCompany.id
						};
						$scope.companyDocumentSubTypes.push(dt);
						$scope.selectedDocumentType = dt;
					}
					$scope.cancel = function (dt) {
						$scope.selectedDocumentType = null;
						$scope.companyDocumentSubTypes[dt] = angular.copy($scope.original);
						$scope.original = null;
						if (!$scope.companyDocumentSubTypes[dt]) {
							$scope.companyDocumentSubTypes.splice(dt, 1);
						}
					}
					$scope.setSelectedDocumentType = function (dt) {
						$scope.original = angular.copy($scope.companyDocumentSubTypes[dt]);
						$scope.selectedDocumentType = $scope.companyDocumentSubTypes[dt];
					}
					$scope.isDocumentTypeValid = function () {
						if ($scope.selectedDocumentType) {
							if (!$scope.selectedDocumentType.category || !$scope.selectedDocumentType.name)
								return false;
							else
								return true;
						} else {
							return true;
						}

					}
					$scope.saveDocumentType = function (dt) {
						if ($scope.selectedDocumentType) {
							
							commonRepository.saveDocumentType($scope.selectedDocumentType).then(function (data) {

								addAlert('Successfully saved document type ', 'success');
								$scope.companyDocumentSubTypes[dt] = angular.copy(data);
								$scope.selectedDocumentType = null;
								$scope.original = null;

							}, function (error) {
								addAlert('error in saving document type. ' + error.statusText, 'danger');
							});
						}
					}
				
					var init = function() {
						//commonRepository.getRelatedEntities($scope.sourceTypeId, $scope.targetTypeId, c$scope.sourceId).then(function(data) {
						//	$scope.list = data;
						//	$scope.tableParams.reload();
						//	$scope.fillTableData($scope.tableParams);
						//}, function(erorr) {

						//});
						commonRepository.getDocumentsMetaData($scope.sourceId).then(function (data) {
							$scope.list = data.documents;
							$scope.documentTypes = data.types;
							$scope.companyDocumentSubTypes = data.companyDocumentSubTypes;
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
