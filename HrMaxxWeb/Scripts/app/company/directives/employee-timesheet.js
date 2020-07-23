'use strict';

common.directive('employeeTimesheet', ['$uibModal', 'zionAPI', 'version', '$timeout',
	function ($modal, zionAPI, version, $timeout) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData",
				mode: "=mode"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/employee-timesheet.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'Colors', 'reportRepository', 'NgTableParams',
				function ($scope, $element, $location, $filter, companyRepository, colors, reportRepository, ngTableParams) {
					var dataSvc = {
						events: [],
						originalEvents: [],
						employees: [],
						selectedEmployee: $scope.mode ? $scope.mainData.selectedEmployee : null,
						currentDate: new Date(),
						statuses: [
							{ id: 1, title: 'Saved' }, { id: 2, title: 'Approved' }, { id: 3, title: 'Paid' }
						],
						openedRack: $scope.mode ? 1 : 2
					}					
					
					$scope.data = dataSvc;
					$scope.hasChanges = function () {
						return angular.equals(dataSvc.events, dataSvc.originalEvents);
					}
					var createEvent = function (start, end) {
						if (!dataSvc.selectedEmployee) {
							$scope.mainData.showMessage('Please select an employee', 'warning', false);
						}
						else {
							var newEntry = {
								id: 0, projectId: null, hours: 0, overtime: 0, entryDate: new Date(start), isApproved: false, approvedBy: '', approvedOn: null, employeeId: dataSvc.selectedEmployee.id, status: 1, name: dataSvc.selectedEmployee.name
							};

							showEvent(newEntry);
                        }
						
					}
					var showEvent = function (entry) {
						var modalInstance = $modal.open({
							templateUrl: 'popover/timesheetentry.html',
							controller: 'timesheetEntryCtrl',
							size: 'sm',
							windowClass: 'my-modal-popup',
							backdropClick: false,
							resolve: {
								entry: function () {
									return entry;
								},
								projects: function () {
									return $scope.mainData.selectedCompany.companyProjects;
								},
								repository: function () {
									return companyRepository;
								},
								employee: function () {
									return dataSvc.selectedEmployee
								},
								$filter: function () {
									return $filter;
								}
							}
						});
						modalInstance.result.then(function (scope) {
							if (scope.deleted) {
								var match = $filter('filter')(dataSvc.events, { id: scope.entry.id })[0];
								var ind = dataSvc.events.indexOf(match);
								dataSvc.events.splice(ind, 1);
								handleCalendarDemo();
								
								
							}
							else {
								scope.entry.color = colors.orange;
								scope.entry.status = 1;
								scope.entry.name = dataSvc.selectedEmployee.name;
								var match = $filter('filter')(dataSvc.events, { id: scope.entry.id })[0];
								if (match) {
									dataSvc.events[dataSvc.events.indexOf(match)] = angular.copy(scope.entry);
									$('#calendar').fullCalendar('removeEventSource', dataSvc.events);
									$('#calendar').fullCalendar('addEventSource', dataSvc.events);
								}
								else {
									dataSvc.events.push(scope.entry);
									$('#calendar').fullCalendar('renderEvent', scope.entry, true); // stick? = true
									
                                }
								$('#calendar').fullCalendar('unselect');
                            }
							//handleCalendarDemo();
						}, function (error) {

								//$scope.mainData.showMessage('error: ' + error, 'danger');
						});
                    }
					$scope.importTimesheet = function () {
						dataSvc.importInProgress = true;
						var modalInstance = $modal.open({
							templateUrl: 'popover/timesheetimport.html',
							controller: 'timesheetImportCtrl',
							size: 'lg',
							windowClass: 'my-modal-popup',
							backdrop: true,
							keyboard: true,
							backdropClick: false,
							resolve: {
								company: function () {
									return $scope.mainData.selectedCompany;
								},
								projects: function () {
									return $scope.mainData.selectedCompany.companyProjects;
								},
								employees: function () {
									return dataSvc.employees;
								},
								companyRepository: function () {
									return companyRepository
								},
								map: function () {
									return dataSvc.importMap;
								},
								mainData: function () {
									return $scope.mainData;
								},
								ngTableParams: function () {
									return ngTableParams;
								},
								$filter: function () {
									return $filter;
								}
							}
						});
						modalInstance.result.then(function (scope) {
							if (dataSvc.selectedEmployee)
								$scope.loadEmployeeTimesheet();
						}, function (error) {
							
						});
					}
					var handleCalendarDemo = function () {
						console.log('loading calendar');						
						
						$('#calendar').fullCalendar({
							header: {
								left: '',
								center: 'title',
								right: ''
							},
							
							droppable: false, // this allows things to be dropped onto the calendar
							
							selectable: true,
							selectHelper: true,
							select: function (start, end) {
								createEvent(start, end);
							},
							eventClick: function (event) {
								showEvent(event);
								
							},
							editable: true,
							eventLimit: true, // allow "more" link when too many events
							events: dataSvc.events
						});
						
						$('#calendar').fullCalendar('gotoDate', dataSvc.currentDate);
						
						
					};
					$scope.prev = function () {
						dataSvc.currentDate = new Date(dataSvc.currentDate.setMonth(dataSvc.currentDate.getMonth() - 1));
						$scope.loadEmployeeTimesheet();
					}
					$scope.next = function () {

						dataSvc.currentDate = new Date(dataSvc.currentDate.setMonth(dataSvc.currentDate.getMonth() + 1));
						$scope.loadEmployeeTimesheet();
					}
					$scope.changeView = function (view) {
						dataSvc.openedRack = view;
						if (view === 1)
							$timeout(function () {
								$('#calendar').fullCalendar('destroy');
								handleCalendarDemo();

							}, 1);
						else {
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
                        }
					}
					
					$scope.loadEmployeeTimesheet = function () {
						
						
							companyRepository.getEmployeeTimesheet($scope.mainData.selectedCompany.id, (dataSvc.selectedEmployee ? dataSvc.selectedEmployee.id : null), dataSvc.currentDate.getMonth() + 1, dataSvc.currentDate.getFullYear()).then(function (data1) {
								dataSvc.events = data1;
								$.each(dataSvc.events, function (i, e) {
									e.project = e.projectId ? $filter('filter')($scope.mainData.selectedCompany.companyProjects, { id: e.projectId })[0] : null;
									if (e.isPaid) {
										e.color = colors.green;
										e.status = 3;
									}
									else if (e.isApproved) {
										e.color = colors.blue;
										e.status = 2;
									}
									else if (e.id) {
										e.color = colors.orange;
										e.status = 1;
                                    }									

									e.name = $scope.mode ? dataSvc.selectedEmployee.name : $filter('filter')(dataSvc.employees, { id: e.employeeId })[0].name;
								});
																
								$scope.changeView(dataSvc.openedRack);

							}, function (erorr) {
								$scope.mainData.showMessage('error getting employee timesheets', 'danger');
							});
                        
						
                    }
					$scope.exportTimesheets = function () {
						var request = {
							reportName: 'TimesheetExport',
							hostId: $scope.mainData.selectedHost.id,
							companyId: $scope.mainData.selectedCompany.id,
							
							startDate : dataSvc.currentDate

						}
						if (dataSvc.selectedEmployee)
							request.employeeId = dataSvc.selectedEmployee.id;
						reportRepository.getReportDocument(request).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();

						}, function (error) {
							$scope.mainData.handleError('Error getting timesheet Export ', error, 'danger');
						});
					}
					$scope.$watch('mainData.selectedCompany',
						function (newValue, oldValue) {
							if (newValue !== oldValue && $scope.mainData.selectedCompany) {
								init();

							}

						}, true
					);
					$scope.tableData = [];

					$scope.tableParams = new ngTableParams({
						count: dataSvc.events ? dataSvc.events.length : 0,
						page: 1,            // show first page
						
						sorting: {
							name: 'asc'     // initial sorting
						}
					}, {
							total: dataSvc.events ? dataSvc.events.length : 0, // length of data
						getData: function (params) {
							$scope.fillTableData(params);
							return $scope.tableData;
						}
					});
					if ($scope.tableParams.settings().$scope == null) {
						$scope.tableParams.settings().$scope = $scope;
					}
					$scope.fillTableData = function (params) {
						// use build-in angular filter
						if (dataSvc.events) {

							var orderedData = params.filter() ?
								$filter('filter')(dataSvc.events, params.filter()) :
								$scope.list;

							orderedData = params.sorting() ?
								$filter('orderBy')(orderedData, params.orderBy()) :
								orderedData;

							$scope.tableParams = params;
							$scope.tableData = orderedData;

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					$scope.setselected = function (listitem) {
						if (!listitem.isPaid && !listitem.isApproved) {
							listitem.selected = !listitem.selected;
                        }
					}
					$scope.selectedCount = function () {
						return $filter('filter')($scope.tableData, { selected: true }).length;
                    }
					var init = function () {
						
							companyRepository.getTimesheetMetaData($scope.mainData.selectedCompany.id).then(function (data) {

								dataSvc.importMap = data.importMap;

							}, function (erorr) {
								$scope.mainData.showMessage('error getting time sheet meta data', 'danger');
							});
							companyRepository.getEmployees($scope.mainData.selectedCompany.id, 1).then(function (data) {
								dataSvc.employees = data;
								if ($scope.mode) {
									dataSvc.selectedEmployee = $filter('filter')(dataSvc.employees, { id: $scope.mainData.userEmployee })[0];
                                }
								$scope.loadEmployeeTimesheet();

							}, function (erorr) {
								$scope.mainData.showMessage('error getting employee list', 'danger');
							});
							

						
						
						
					}
					init();


				}]
		}
	}
]);
common.controller('timesheetEntryCtrl', function ($scope, $uibModalInstance, projects, repository, entry, employee, $filter) {
	$scope.original = entry;
	$scope.entry = angular.copy(entry);
	$scope.repository = repository;
	$scope.projects = projects;
	$scope.employee = employee;
	$scope.changesMade = false;
	$scope.deleted = false;
	$scope.selectedProject = $scope.entry.projectId ? $filter('filter')($scope.projects, { id: $scope.entry.pojectId })[0] : null;
	$scope.isEntryValid = function () {
		var item = $scope.entry;
		if (!item.employeeId || (item.hours+item.overtime)<=0 )
			return false;
		else
			return true;
	}
	$scope.save = function () {
		$scope.entry.projectId = $scope.selectedProject ? $scope.selectedProject.id : null;
		$scope.entry.projectName = $scope.selectedProject ? $scope.selectedProject.projectName : null;
		
		delete $scope.entry.source;
		$scope.repository.saveEmployeeTimesheet($scope.entry).then(function (data) {
			$scope.entry = angular.copy(data);
			$scope.selectedProject = null;
			$uibModalInstance.close($scope);


		}, function (error) {

		});
	}
	$scope.delete = function () {
		$scope.repository.deleteEmployeeTimesheet($scope.entry.id).then(function (data) {
			$scope.deleted = true;
			$scope.selectedProject = null;
			$scope.entry = angular.copy($scope.original);
			$uibModalInstance.close($scope);


		}, function (error) {

		});
    }
	$scope.cancel = function () {
		$scope.selectedProject = null;
		$uibModalInstance.dismiss();
	}




});
common.controller('timesheetImportCtrl', function ($scope, $uibModalInstance, $filter, company, employees, projects, companyRepository, $timeout, map, mainData, ngTableParams) {
	$scope.company = company;
	$scope.employees = employees;
	$scope.projects = projects;
	$scope.companyRepository = companyRepository;
	$scope.alerts = [];
	$scope.messages = [];
	$scope.timesheets = [];
	if (map) {
		$scope.importMap = angular.copy(map);
		$scope.importMap.lastRow = null;
		
	} else {
		$scope.importMap = {
			startingRow: 1,
			columnCount: 1,
			lastRow: null,
			columnMap: [],
			
		};
	}
	
	var requiredColumns = ['Employee No', 'SSN', 'Hours', 'Overtime', 'Description'];
	$scope.selected = null;
	$scope.files = [];
	$scope.onFileSelect = function ($files) {
		$scope.files = [];
		if (!$files[0] || !($files[0].name.toLowerCase().endsWith(".xlsx") || $files[0].name.toLowerCase().endsWith(".csv") || $files[0].name.toLowerCase().endsWith(".txt"))) {
			$scope.alerts.push({
				message: 'Please select an excel, csv or txt (comma separated file) file '
			});
			return false;
		} else {
			$scope.alerts = [];
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
									companyId: $scope.company.id,									
									importMap: $scope.importMap
								}),
								currentProgress: 0,
								completed: false
							});
							//uploadDocument();
						});
					}
				}(fileReader, i);
			}
		}


	};

	$scope.uploadDocument = function () {
		$scope.alerts = [];
		var importMap = angular.copy($scope.importMap);
		importMap.columnMap = [];
		$.each($scope.importMap.columnMap, function (i3, cm) {
			if (cm.value !== 0)
				importMap.columnMap.push(cm);
		});
		//importMap.columnMap = $filter('filter')($scope.importMap.columnMap, { value: '!' + 0 });
		$scope.files[0].data = JSON.stringify({
			companyId: $scope.company.id,
			importMap: importMap
		});
		mainData.confirmDialog('this will try and import ' + ($scope.importMap.lastRow ? ($scope.importMap.lastRow - $scope.importMap.startingRow + 1) : 'maximum') + ' timesheet entries? do you want to proceed ?', 'warning', function () {
			companyRepository.importTimesheetsWithMap($scope.files[0]).then(function (timesheets) {
				var counter = 0;
				var messages = [];
				$scope.timesheets = timesheets;
				$scope.tableParams.reload();
				$scope.fillTableData($scope.tableParams);
				$scope.messages = messages;
				


			}, function (error) {
				$scope.alerts.push({ message: error });

			});
		});

	}
	$scope.tableData = [];
	
	$scope.tableParams = new ngTableParams({
		count: $scope.timesheets ? $scope.timesheets.length : 0,
		page: 1,            // show first page
		
		sorting: {
			name: 'asc'     // initial sorting
		}
	}, {
			total: $scope.timesheets ? $scope.timesheets.length : 0, // length of data
		getData: function (params) {
			$scope.fillTableData(params);
			return $scope.tableData;
		}
	});
	if ($scope.tableParams.settings().$scope == null) {
		$scope.tableParams.settings().$scope = $scope;
	}
	$scope.fillTableData = function (params) {
		// use build-in angular filter
		if ($scope.timesheets && $scope.timesheets.length > 0) {
			
			var orderedData = params.filter() ?
				$filter('filter')($scope.timesheets, params.filter()) :
				$scope.list;

			orderedData = params.sorting() ?
				$filter('orderBy')(orderedData, params.orderBy()) :
				orderedData;

			$scope.tableParams = params;
			$scope.tableData = orderedData;

			params.total(orderedData.length); // set total for recalc pagination
		}
	};
	$scope.cancel = function () {

		$uibModalInstance.dismiss();
	};
	$scope.showTable = function () {
		return $scope.importMap.startingRow && $scope.importMap.columnCount;
	}
	$scope.ready = function () {

		if (!$scope.showTable())
			return false;
		else if (!$scope.files || $scope.files.length !== 1 || $scope.importMap.columnMap.length === 0)
			return false;
		else {
			return true;

		}
	}
	
	$scope.availableColumns = function (index) {
		var returnList = [];
		$.each(requiredColumns, function (ind, r) {

			var exists = $filter('filter')($scope.importMap.columnMap, { key: r })[0];
			if (!exists || $scope.importMap.columnMap.indexOf(exists) === index)
				returnList.push(r);


		});
		return returnList;
	}

	$scope.setSelected = function (index) {
		$scope.selected = $scope.importMap.columnMap[index];
	}
	$scope.isItemValid = function (field) {
		if (!field.key || !field.value)
			return false;
		else {
			var matches = $filter('filter')($scope.importMap.columnMap, { value: field.value }, true);
			if (matches.length > 1)
				return false;
			else {
				return true;
			}
		}
	}
	$scope.add = function () {
		var f = {
			key: '',
			value: ''
		};

		$scope.importMap.columnMap.push(f);
		$scope.setSelected($scope.importMap.columnMap.length - 1);
	}
	$scope.saveSelected = function (field) {
		$scope.selected = null;
	}
	$scope.cancelSelected = function (field, index) {
		if (!field.key || !field.value)
			$scope.importMap.columnMap.splice(index, 1);
		$scope.selected = null;
	}
	$scope.delete = function (index) {
		$scope.importMap.columnMap.splice(index, 1);
	}

	$scope.saveImportedTimesheets = function () {
		companyRepository.saveTimesheets($scope.timesheets).then(function (timesheets) {
			$scope.timesheets = timesheets;
			$uibModalInstance.close();
		}, function (error) {
			$scope.alerts.push({ message: error });

		});

    }
	$scope.cancel = function () {
		$scope.selectedProject = null;
		$uibModalInstance.dismiss();
	}
	var init = function () {

		requiredColumns.push('Project Id');
		requiredColumns.push('Entry Date');
	}
	init();
});