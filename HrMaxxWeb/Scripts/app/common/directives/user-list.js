'use strict';

common.directive('userList', ['$uibModal', 'zionAPI', '$timeout', '$window','version',
	function ($modal, zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				hostId: "=hostId",
				companyId: "=?companyId",
				employeeId: "=?employeeId",
				heading: "=heading",
				showResetPassword: "=?showResetPassword",
				parentTypeId: "=?parentTypeId",
				mainData: "=?mainData"
			},
			templateUrl: zionAPI.Web + 'Content/templates/user-list.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'commonRepository', 'NgTableParams', 'EntityTypes', function ($scope, $element, $location, $filter, commonRepository, ngTableParams, EntityTypes) {
				$scope.targetTypeId = EntityTypes.Contact;
				$scope.list = [];

				var dataSvc = {
					companies: [],
					hosts: [],
					employees: [],
					filteredCompanies: [],
					filteredEmployees:[],
					selectedHost: null,
					selectedCompany: null,
					accessList: [],
					viewAccess: false,
					roles: [
						{
							roleId: 100,
							roleName: 'Super User',
							show: true
						},
						{
						roleId: 90,
						roleName: 'Master',
						show: true
			}, {
						roleId: 70,
						roleName: 'CorpStaff',
						show: true
					}, {
						roleId: 50,
						roleName: 'Host',
						show: true
					}, {
						roleId: 40,
						roleName: 'HostStaff',
						show: true
					}, {
						roleId: 30,
						roleName: 'Company',
						show: true
					},
					{
						roleId: 10,
						roleName: 'CompanyManager',
						show: true
					},
					{
						roleId: 0,
						roleName: 'Employee',
						show: true
					}]
				}
				$scope.showuser = function () {
					var modalInstance = $modal.open({
						templateUrl: 'popover/user.html',
						controller: 'userCtrl',
						size: 'lg',
						windowClass: 'my-modal-popup',
						resolve: {
							user: function () {
								return $scope.selectedUser;
							},
							datasvc: function () {
								return dataSvc;
							},
							commonRepository: function () {
								return commonRepository;
							},
							mainData: function () {
								return $scope.mainData;
							},
							showResetPassword: function () {
								return $scope.showResetPassword;
							}
						}
					});
					modalInstance.result.then(function (userscope) {
						var result = userscope.selectedUser;
						var exists = $filter('filter')($scope.list, { userId: result.subjectUserId });
						if (exists.length === 0) {
							$scope.list.push(result);
						} else {
							$scope.list.splice($scope.list.indexOf(exists[0]), 1);
							$scope.list.push(result);
						}
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						if ($scope.selectedUser.subjectUserId)
							$scope.mainData.showMessage('successfully saved user', 'success');
						else
							$scope.mainData.showMessage('successfully created a new user with default password. email has been sent to the user to confirm', 'success');

					}, function () {
						return false;
					});
				}

				
				$scope.data = dataSvc;
				
				if ($scope.mainData)
					$scope.mainData.showFilterPanel = false;
				$scope.selectedUser = null;

				$scope.addNewUser = function ($event) {
					
					$scope.selectedUser = {
						firstName: '',
						lastName: '',
						email: '',
						roleId: null,
						phone: '',
						active: false,
						sourceTypeId: $scope.parentTypeId,
						hostId: $scope.hostId,
						companyId: $scope.companyId,
						employeeId: $scope.employeeId,
						claims:[]
						
					};
					if ($scope.employeeId) {
                        $scope.selectedUser.role = $filter('filter')(dataSvc.roles, { roleId: 0 })[0];
                        $scope.selectedUser.host = $scope.hostId;
                        $scope.selectedUser.company = $scope.companyId;
                        $scope.selectedUser.employee = $scope.employeeId;
					}
					else if ($scope.companyId) {
                        $scope.selectedUser.role = $filter('filter')(dataSvc.roles, { roleId: 30 })[0];
                        $scope.selectedUser.host = $scope.hostId;
                        $scope.selectedUser.company = $scope.companyId;
                    }
					else if ($scope.hostId) {
                        $scope.selectedUser.role = $filter('filter')(dataSvc.roles, { roleId: 50 })[0];
                        $scope.selectedUser.host = $scope.hostId;
                        
					}
					//if ($scope.selectedUser.role)
					//	$scope.roleChanged();
					$scope.setSelectedUser($scope.selectedUser, $event);
				}

				$scope.tableData = [];
				$scope.tableParams = new ngTableParams({
					page: 1,            // show first page
					count: 10,

					filter: {
						email: '',       // initial filter
					},
					sorting: {
						email: 'asc'     // initial sorting
					}
				}, {
					total: $scope.list ? $scope.list.length : 0, // length of data
					getData: function(params) {
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
				$scope.cancel=function() {
					$scope.selectedUser = null;
					dataSvc.selectedCompany = null;
					dataSvc.selectedHost = null;
					dataSvc.selectedEmployee = null;
					dataSvc.viewAccess = false;
				}
				$scope.setSelectedUser = function (item, $event) {
					$event.stopPropagation();
					$scope.selectedUser = null;
					$timeout(function() {
						$scope.originalUser = item;
						$scope.selectedUser = angular.copy(item);
						
						$scope.showuser();
					});
				}
				$scope.roleChanged = function () {
					var item = $scope.selectedUser;
					//if ($scope.originalUser) {
					if (item.role.roleId === 0) {
						item.host = $scope.originalUser ? $scope.originalUser.host : item.host;
						item.company = $scope.originalUser ? $scope.originalUser.company : item.company;
						item.employee = $scope.originalUser ? $scope.originalUser.employee : item.employee;
						dataSvc.selectedHost = item.host ? $filter('filter')(dataSvc.hosts, { id: item.host })[0] : null;
						if (dataSvc.selectedHost)
							$scope.hostSelected();
						dataSvc.selectedCompany = item.company ? $filter('filter')(dataSvc.companies, { id: item.company })[0] : null;
						if (dataSvc.selectedCompany)
							$scope.companySelected();
						dataSvc.selectedEmployee = item.employee ? $filter('filter')(dataSvc.employees, { id: item.employee })[0] : null;
					}
					else if (item.role.roleId > 0 && item.role.roleId < 31) {
						item.host = $scope.originalUser ? $scope.originalUser.host : item.host;
						item.company = $scope.originalUser ? $scope.originalUser.company : item.company;
						dataSvc.selectedHost = item.host ? $filter('filter')(dataSvc.hosts, { id: item.host })[0] : null;
						dataSvc.selectedCompany = item.company ? $filter('filter')(dataSvc.companies, { id: item.company })[0] : null;
						dataSvc.selectedEmployee = null;
						item.employee = null;
					}
					else if (item.role.roleId < 51 && item.role.roleId > 30) {
						item.host = $scope.originalUser ? $scope.originalUser.host : item.host;
						item.company = null;
						item.employee = null;
						dataSvc.selectedCompany = null;
						dataSvc.selectedEmployee = null;
						dataSvc.selectedHost = item.host ? $filter('filter')(dataSvc.hosts, { id: item.host })[0] : null;
					}
					else if (item.role.roleId > 50) {
						item.host = null;
						item.company = null;
						item.employee = null;
						dataSvc.selectedHost = null;
						dataSvc.selectedCompany = null;
						dataSvc.selectedEmployee = null;
					}



					//	}
					$scope.buildAccesses();
				}
				$scope.hostSelected = function () {
					if ($scope.selectedUser) {
						$scope.selectedUser.host = dataSvc.selectedHost.id;
						$scope.selectedUser.company = null;
						$scope.selectedUser.companyId = null;
						$scope.selectedUser.employee = null;
						$scope.selectedUser.employeeId = null;
					}

					dataSvc.filteredCompanies = angular.copy($filter('filter')(dataSvc.companies, { host: dataSvc.selectedHost.id }));
					if ($scope.companyId) {
						dataSvc.selectedCompany = $filter('filter')(dataSvc.filteredCompanies, { id: $scope.companyId })[0];
						$scope.companySelected();
					}
				}
				$scope.companySelected = function () {
					if ($scope.selectedUser) {
						$scope.selectedUser.company = dataSvc.selectedCompany.id;
						$scope.selectedUser.employee = null;
						$scope.selectedUser.employeeId = null;
					}

					dataSvc.filteredEmployees = angular.copy($filter('filter')(dataSvc.employees, { company: dataSvc.selectedCompany.id }));
					if ($scope.employeeId) {
						dataSvc.selectedEmployee = $filter('filter')(dataSvc.filteredEmployees, { id: $scope.employeeId })[0];
						$scope.employeeSelected();
					}
				}
				$scope.employeeSelected = function () {
					if ($scope.selectedUser)
						$scope.selectedUser.employee = dataSvc.selectedEmployee.id;

				}
				var init = function () {
					
					commonRepository.getUsersMetaData().then(function (result) {
						dataSvc.hosts = angular.copy(result.hosts);
						dataSvc.companies = angular.copy(result.companies);
						dataSvc.employees = angular.copy(result.employees);
						if ($scope.hostId) {
							dataSvc.selectedHost = $filter('filter')(dataSvc.hosts, { id: $scope.hostId })[0];
							$scope.hostSelected();
						}
						
					}, function (erorr) {

					});
					commonRepository.getAccessMetaData().then(function (result) {
						dataSvc.accessList = angular.copy(result);
						

					}, function (erorr) {

					});
					commonRepository.getUsers($scope.hostId, $scope.companyId).then(function (data) {
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
common.controller('userCtrl', function ($scope, $uibModalInstance, $filter, user, datasvc, commonRepository, mainData, showResetPassword) {
	$scope.original = user;
	$scope.selectedUser = angular.copy(user);
	var dataSvc = datasvc;
	$scope.mainData = mainData;
	$scope.showResetPassword = showResetPassword;
	$scope.changesMade = false;
	$scope.roleChanged = function () {
		var item = $scope.selectedUser;
		//if ($scope.originalUser) {
		if (item.role.roleId === 0) {
			item.host = $scope.originalUser ? $scope.originalUser.host : item.host;
			item.company = $scope.originalUser ? $scope.originalUser.company : item.company;
			item.employee = $scope.originalUser ? $scope.originalUser.employee : item.employee;
			dataSvc.selectedHost = item.host ? $filter('filter')(dataSvc.hosts, { id: item.host })[0] : null;
			if (dataSvc.selectedHost)
				$scope.hostSelected();
			dataSvc.selectedCompany = item.company ? $filter('filter')(dataSvc.companies, { id: item.company })[0] : null;
			if (dataSvc.selectedCompany)
				$scope.companySelected();
			dataSvc.selectedEmployee = item.employee ? $filter('filter')(dataSvc.employees, { id: item.employee })[0] : null;
		}
		else if (item.role.roleId > 0 && item.role.roleId < 31) {
			item.host = $scope.originalUser ? $scope.originalUser.host : item.host;
			item.company = $scope.originalUser ? $scope.originalUser.company : item.company;
			dataSvc.selectedHost = item.host ? $filter('filter')(dataSvc.hosts, { id: item.host })[0] : null;
			dataSvc.selectedCompany = item.company ? $filter('filter')(dataSvc.companies, { id: item.company })[0] : null;
			dataSvc.selectedEmployee = null;
			item.employee = null;
		}
		else if (item.role.roleId < 51 && item.role.roleId > 30) {
			item.host = $scope.originalUser ? $scope.originalUser.host : item.host;
			item.company = null;
			item.employee = null;
			dataSvc.selectedCompany = null;
			dataSvc.selectedEmployee = null;
			dataSvc.selectedHost = item.host ? $filter('filter')(dataSvc.hosts, { id: item.host })[0] : null;
		}
		else if (item.role.roleId > 50) {
			item.host = null;
			item.company = null;
			item.employee = null;
			dataSvc.selectedHost = null;
			dataSvc.selectedCompany = null;
			dataSvc.selectedEmployee = null;
		}



		//	}
		$scope.buildAccesses();
	}

	$scope.hostSelected = function () {
		if ($scope.selectedUser) {
			$scope.selectedUser.host = dataSvc.selectedHost.id;
			$scope.selectedUser.company = null;
			$scope.selectedUser.companyId = null;
			$scope.selectedUser.employee = null;
			$scope.selectedUser.employeeId = null;
		}

		dataSvc.filteredCompanies = angular.copy($filter('filter')(dataSvc.companies, { host: dataSvc.selectedHost.id }));
		if ($scope.companyId) {
			dataSvc.selectedCompany = $filter('filter')(dataSvc.filteredCompanies, { id: $scope.companyId })[0];
			$scope.companySelected();
		}
	}
	$scope.companySelected = function () {
		if ($scope.selectedUser) {
			$scope.selectedUser.company = dataSvc.selectedCompany.id;
			$scope.selectedUser.employee = null;
			$scope.selectedUser.employeeId = null;
		}

		dataSvc.filteredEmployees = angular.copy($filter('filter')(dataSvc.employees, { company: dataSvc.selectedCompany.id }));
		if ($scope.employeeId) {
			dataSvc.selectedEmployee = $filter('filter')(dataSvc.filteredEmployees, { id: $scope.employeeId })[0];
			$scope.employeeSelected();
		}
	}
	$scope.employeeSelected = function () {
		if ($scope.selectedUser)
			$scope.selectedUser.employee = dataSvc.selectedEmployee.id;

	}
	var setRoleList = function () {
		var currentUserAccessLevel = 100;
		var contextLevel = 100;
		if ($scope.employeeId)
			contextLevel = 0;
		else if ($scope.companyId)
			contextLevel = 30;
		else if ($scope.hostId)
			contextLevel = 50;

		if ($scope.mainData.userRole === 'SuperUser') {
			currentUserAccessLevel = 100;
		} else if ($scope.mainData.userRole === 'Master') {
			currentUserAccessLevel = 90;
		} else if ($scope.mainData.userRole === 'CorpStaff') {
			currentUserAccessLevel = 70;

		} else if ($scope.mainData.userRole === 'Host' || $scope.mainData.userRole === 'HostStaff') {
			currentUserAccessLevel = 50;

		} else if ($scope.mainData.userRole === 'Company') {
			currentUserAccessLevel = 30;
		} else {
			currentUserAccessLevel = 0;
		}
		$.each(dataSvc.roles, function (index, role) {
			if (role.roleId > currentUserAccessLevel || role.roleId > contextLevel)
				role.show = false;
		});
	}
	$scope.validateUser = function () {
		var u = $scope.selectedUser;
		if (u) {
			if (!u.firstName || !u.lastName || !u.email || !u.subjectUserName)
				return false;
			else if ((u.role.roleId < 31) && (!u.company))
				return false;
			else if ((u.role.roleId < 51) && (!u.host))
				return false;
			else
				return true;
		} else
			return false;
	}
	$scope.buildAccesses = function () {

		dataSvc.userAccessList = angular.copy(dataSvc.accessList);
		$.each(dataSvc.userAccessList, function (index, i) {
			i.hasAccess = $scope.userHasAccess(i.claimType);

		});
	}
	$scope.userHasAccess = function (claimType) {
		var match = $filter('filter')($scope.selectedUser.claims, { claimType: claimType });
		return match.length > 0 ? true : false;
	}
	$scope.includeAll = function () {
		$.each(dataSvc.userAccessList, function (index, i) {
			if (i.featureName === dataSvc.openedRack) {
				if (i.accessLevel <= $scope.selectedUser.role.roleId)
					i.hasAccess = true;
				else {
					i.hasAccess = false;
				}
			}
			
		});
	}

	$scope.save = function () {
		$.each(dataSvc.userAccessList, function (index, i) {
			var match = $filter('filter')($scope.selectedUser.claims, { claimType: i.claimType });
			if (i.hasAccess && i.accessLevel <= $scope.selectedUser.role.roleId) {
				if (match.length === 0) {
					$scope.selectedUser.claims.push({ id: 0, claimType: i.claimType, claimValue: 1 });
				}

			}
			else {
				if (match.length > 0) {
					$scope.selectedUser.claims.splice($scope.selectedUser.claims.indexOf(match[0]), 1);
				}
			}
		});
		commonRepository.saveUser($scope.selectedUser).then(function (result) {

			$scope.selectedUser = result;
			$uibModalInstance.close($scope);
		}, function (error) {
			$scope.mainData.handleError('Error: ', error, 'danger');
		});
	}
	$scope.cancel = function () {
		$uibModalInstance.dismiss();
	};

	$scope.data = dataSvc;
	$scope.resetPassword = function () {
		commonRepository.resetPassword($scope.selectedUser).then(function (result) {
			$scope.mainData.showMessage('successfully sent a password reset email to the user', 'success');
		}, function (error) {
			$scope.mainData.handleError('Error: ', error, 'danger');
		});
	}
	$scope.resetPasswordDefault = function () {
		commonRepository.resetPasswordDefault($scope.selectedUser).then(function (result) {
			$scope.mainData.showMessage('successfully reset the password to default password', 'success');
		}, function (error) {
			$scope.mainData.handleError('Error: ', error, 'danger');
		});
	}
	var _init = function () {
		setRoleList();
		
		
		dataSvc.selectedHost = user.host ? $filter('filter')(dataSvc.hosts, { id: user.host })[0] : null;
		if (dataSvc.selectedHost)
			$scope.hostSelected();
		dataSvc.selectedCompany = user.company ? $filter('filter')(dataSvc.companies, { id: user.company })[0] : null;
		if (dataSvc.selectedCompany)
			$scope.companySelected();
		dataSvc.selectedEmployee = user.employee ? $filter('filter')(dataSvc.employees, { id: user.employee })[0] : null;
		$scope.buildAccesses();
		dataSvc.featureNames = $filter('unique')(dataSvc.userAccessList, 'featureName');
		dataSvc.openedRack = dataSvc.featureNames[0].title;
	}
	_init();

});
