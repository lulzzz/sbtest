'use strict';

common.directive('documentList', ['zionAPI', '$timeout', '$window','version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData",
				heading: "=heading",
				mode: "=mode",
				companyId: "=companyId",
				employeeId: "=?employeeId"
			},
			templateUrl: zionAPI.Web + 'Content/templates/document-list.html?v=' + version,

			controller: ['$scope', '$element', '$location', 'NgTableParams', '$filter', 'commonRepository', 'EntityTypes',
				function ($scope, $element, $location, ngTableParams, $filter, commonRepository, EntityTypes) {
					$scope.targetTypeId = EntityTypes.Document;
					$scope.sourceTypeId = $scope.mainData.userRole.employee ? EntityTypes.Employee : EntityTypes.Company;
					$scope.sourceId = $scope.companyId;
					$scope.list = [];
					$scope.listEmployeeAccess = [];
					$scope.listEmployeeDocuments = [];
					$scope.documentTypes = [];
					$scope.companyDocumentSubTypes = [];
					
					var dataSvc = {
						selectedType: null, selectedSubType: null,
						isCustomerTypeOpen: false, isDocsOpen: true
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
					$scope.tableDataEmployeeView = [];
					$scope.tableParamsEmployeeView = new ngTableParams({
						page: 1,            // show first page
						count: 10
					}, {
						total: $scope.listEmployeeAccess ? $scope.listEmployeeAccess.length : 0, // length of data
						getData: function (params) {
							$scope.fillTableDataEmployeeView(params);
							return $scope.tableDataEmployeeView;
						}
					});

					$scope.fillTableDataEmployeeView = function (params) {
						// use build-in angular filter
						if ($scope.listEmployeeAccess && $scope.listEmployeeAccess.length > 0) {
							var orderedData = params.filter() ?
																$filter('filter')($scope.listEmployeeAccess, params.filter()) :
																$scope.listEmployeeAccess;

							orderedData = params.sorting() ?
														$filter('orderBy')(orderedData, params.orderBy()) :
														orderedData;

							$scope.tableParamsEmployeeView = params;
							$scope.tableDataEmployeeView = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count());

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					$scope.tableDataEmployeeRequired = [];
					$scope.tableParamsEmployeeRequired = new ngTableParams({
						page: 1,            // show first page
						count: 10
					}, {
						total: $scope.listEmployeeDocuments ? $scope.listEmployeeDocuments.length : 0, // length of data
						getData: function (params) {
							$scope.fillTableDataEmployeeRequired(params);
							return $scope.tableDataEmployeeRequired;
						}
					});

					$scope.fillTableDataEmployeeRequired = function (params) {
						// use build-in angular filter
						if ($scope.listEmployeeDocuments && $scope.listEmployeeDocuments.length > 0) {
							var orderedData = params.filter() ?
																$filter('filter')($scope.listEmployeeDocuments, params.filter()) :
																$scope.listEmployeeDocuments;

							orderedData = params.sorting() ?
														$filter('orderBy')(orderedData, params.orderBy()) :
														orderedData;

							$scope.tableDataEmployeeRequired = params;
							$scope.tableDataEmployeeRequired = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count());

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

					$scope.onFileSelectEmployee = function ($files, item) {
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
													entityTypeId: EntityTypes.Employee,
													entityId: item.employeeId,
													mimeType: $files[index].type,
													type: item.companyDocumentSubType.documentType,
													documentType: item.companyDocumentSubType.documentType.id,
													companyDocumentSubType: item.companyDocumentSubType,
													companyId: $scope.companyId
												}),
												currentProgress: 0,
												completed: false
											});
											item.fileIndex = $scope.files.length;
										});
									}
								}(fileReader, i);
							
						}
					};
					$scope.clearSelections = function() {
						$.each($scope.tableDataEmployeeRequired, function(i, e) {
							$scope.tableDataEmployeeRequired[i].fileIndex = null;
						});
					}
					$scope.uploadAll = function() {
						$.each($scope.files, function (index, file) {
							$scope.uploadDocument(index);
						});
					};

					$scope.uploadDocument = function (index) {
						if (!$scope.files[index].uploaded) {
						
							commonRepository.uploadDocument($scope.files[index]).then(function (doc) {
								$scope.list.push(doc);
								refillTables();
							}, function() {
								$scope.files[index].doc.uploaded = false;
								$scope.files[index].currentProgress = 0;
								$scope.mainData.showMessage('error uploading file', 'danger');
							
							});

						}
					}
					$scope.uploadAllEmployeeDocuments = function () {
						$.each($scope.files, function (index, file) {
							$scope.uploadEmployeeDocument(index);
						});
						$scope.files = [];
					};
					$scope.uploadEmployeeDocument = function (index) {
						var empItem = $filter('filter')($scope.tableDataEmployeeRequired, { fileIndex: index+1 })[0];
						var listitem = $filter('filter')($scope.listEmployeeDocuments, { companyDocumentSubType: {id: empItem.companyDocumentSubType.id} })[0];
						if (!$scope.files[index].uploaded) {

							commonRepository.uploadDocument($scope.files[index]).then(function (doc) {
								//$scope.list.push(doc);
								listitem.document = doc;
								listitem.dateUploaded = doc.uploaded;
								listitem.uploadedBy = doc.uploadedBy;
								empItem.fileIndex = null;
								refillTables();
							}, function () {
								$scope.files[index].doc.uploaded = false;
								$scope.files[index].currentProgress = 0;
								$scope.mainData.showMessage('error uploading file', 'danger');

							});

						}
					}
					$scope.deleteDocument = function(doc) {
						$scope.$parent.$parent.confirmDialog('Are you sure you want to delete this document?', 'danger', function() {
							commonRepository.deleteDocument($scope.sourceTypeId, $scope.sourceId, doc.targetEntityId).then(function() {
								$scope.list.splice($scope.list.indexOf(doc), 1);
								refillTables();
								$scope.mainData.showMessage('successfully removed file', 'success');
							}, function() {
								$scope.mainData.showMessage('error deleting document', 'danger');

							});
						});
                    }
                    $scope.deleteEmployeeDocument = function (doc) {
                        $scope.mainData.confirmDialog('Are you sure you want to delete this employee compliance document?', 'danger', function () {
                            commonRepository.deleteEmployeeDocument(doc.document.targetEntityId, doc.employeeId).then(function () {
                                $scope.listEmployeeDocuments.splice($scope.listEmployeeDocuments.indexOf(doc), 1);
                                refillTables();
                                $scope.mainData.showMessage('successfully removed employee document', 'success');
                            }, function () {
                                $scope.mainData.showMessage('error deleting employee document', 'danger');

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
					$scope.getEmployeeDocumentUrl = function (document) {
						if ($scope.mainData.userEmployee && $scope.mainData.userEmployee === $scope.employeeId)
							return zionAPI.URL + 'EmployeeDocument/' + document.document.targetEntityId + '/' + $scope.employeeId;
						else {
							return zionAPI.URL + 'Document/' + document.document.targetEntityId;
						}
					};
					$scope.updateEmployeeDocumentAccess = function (item) {
						if ($scope.mainData.userEmployee && $scope.mainData.userEmployee === $scope.employeeId) {
							var l = $filter('filter')($scope.listEmployeeAccess, { document: { id: item.document.id } })[0];
							l.firstAccessed = l.firstAccessed ? l.firstAccessed : new Date();
							l.lastAccessed = new Date();
							refillTables();
						}
						
					}
					$scope.addDocumentType = function () {
						var dt = {
							id: 0, name: '', documentType: null, isEmployeeRequired: false, trackAccess: false, companyId: $scope.mainData.selectedCompany.id
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
							if (!$scope.selectedDocumentType.documentType || !$scope.selectedDocumentType.name)
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

								$scope.mainData.showMessage('Successfully saved document type ', 'success');
								$scope.companyDocumentSubTypes[dt] = angular.copy(data);
								$scope.selectedDocumentType = null;
								$scope.original = null;

							}, function (error) {
								$scope.mainData.handleError('error in saving document type. ' , error, 'danger');
							});
						}
					}
					var refillTables = function() {
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						
						
						$scope.tableParamsEmployeeView.reload();
						$scope.fillTableDataEmployeeView($scope.tableParamsEmployeeView);

						$scope.tableParamsEmployeeRequired.reload();
						$scope.fillTableDataEmployeeRequired($scope.tableParamsEmployeeRequired);
						
                    }
                    $scope.$watch('companyId',
                        function (newValue, oldValue) {
                            if (newValue !== oldValue && $scope.mainData.selectedCompany) {
                                commonRepository.getDocumentsMetaData($scope.companyId).then(function (data) {
                                    $scope.list = data.documents;
                                    $scope.documentTypes = data.types;
                                    $scope.companyDocumentSubTypes = data.companyDocumentSubTypes;
                                    refillTables();
                                }, function (erorr) {

                                });
                            }

                        }, true
                    );
					var init = function() {
						
						if ($scope.mode===1) {
							commonRepository.getDocumentsMetaData($scope.companyId).then(function(data) {
								$scope.list = data.documents;
								$scope.documentTypes = data.types;
								$scope.companyDocumentSubTypes = data.companyDocumentSubTypes;
								refillTables();
							}, function(erorr) {

							});
						} else {
							commonRepository.getEmployeeDocumentsMetaData($scope.companyId, $scope.employeeId).then(function (data) {
								$scope.listEmployeeAccess = data.employeeDocumentAccesses;
								$scope.listEmployeeDocuments = data.employeeDocumentRequirements;
								refillTables();
							}, function (erorr) {

							});
						}
						
						
					}
					init();

				}]
		}
	}
]);
