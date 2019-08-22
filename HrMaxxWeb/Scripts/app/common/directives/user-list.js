'use strict';

common.directive('userList', ['zionAPI', '$timeout', '$window','version',
	function (zionAPI, $timeout, $window, version) {
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
				$scope.data = dataSvc;
				var addAlert = function (error, type) {
					$scope.$parent.$parent.addAlert(error, type);
				};
				if ($scope.mainData)
					$scope.mainData.showFilterPanel = false;
				$scope.selectedUser = null;

				$scope.addNewUser = function () {
					
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
					}
					else if ($scope.companyId) {
						$scope.selectedUser.role = $filter('filter')(dataSvc.roles, { roleId: 30 })[0];
					}
					else if ($scope.hostId) {
						$scope.selectedUser.role = $filter('filter')(dataSvc.roles, { roleId: 50 })[0];
					}
					if ($scope.selectedUser.role)
						$scope.roleChanged();
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
					dataSvc.viewAccess = false;
				}
				$scope.setSelectedUser = function(item) {
					$scope.selectedUser = null;
					$timeout(function() {
						$scope.originalUser = item;
						$scope.selectedUser = angular.copy(item);
						dataSvc.selectedHost = item.host ? $filter('filter')(dataSvc.hosts, { id: item.host })[0] : null;
						if (dataSvc.selectedHost)
							$scope.hostSelected();
						dataSvc.selectedCompany = item.company ? $filter('filter')(dataSvc.companies, { id: item.company })[0] : null;
						if (dataSvc.selectedCompany)
							$scope.companySelected();
						dataSvc.selectedEmployee = item.employee ? $filter('filter')(dataSvc.employees, { id: item.employee })[0] : null;
						$scope.buildAccesses();
					});
				}
				$scope.roleChanged = function () {
					var item = $scope.selectedUser;
					if ($scope.originalUser) {
						if (item.role.roleId === 0) {
							item.host = $scope.originalUser.host;
							item.company = $scope.originalUser.company;
							item.employee = $scope.originalUser.employee;
							dataSvc.selectedHost = item.host ? $filter('filter')(dataSvc.hosts, { id: item.host })[0] : null;
							if (dataSvc.selectedHost)
								$scope.hostSelected();
							dataSvc.selectedCompany = item.company ? $filter('filter')(dataSvc.companies, { id: item.company })[0] : null;
							if (dataSvc.selectedCompany)
								$scope.companySelected();
							dataSvc.selectedEmployee = item.employee ? $filter('filter')(dataSvc.employees, { id: item.employee })[0] : null;
						}
						else if (item.role.roleId >0 && item.role.roleId <31) {
							item.host = $scope.originalUser.host;
							item.company = $scope.originalUser.company;
							dataSvc.selectedHost = item.host ? $filter('filter')(dataSvc.hosts, { id: item.host })[0] : null;
							dataSvc.selectedCompany = item.company ? $filter('filter')(dataSvc.companies, { id: item.company })[0] : null;
						}
						else if (item.role.roleId < 51 && item.role.roleId > 30) {
							item.host = $scope.originalUser.host;
							item.company = null;
							dataSvc.selectedHost = item.host ? $filter('filter')(dataSvc.hosts, { id: item.host })[0] : null;
						}
						else if (item.role.roleId >50) {
							item.host = null;
							item.company = null;
						}
						
						
						
					}
					$scope.buildAccesses();
				}
				
				$scope.hostSelected = function () {
					if($scope.selectedUser)
						$scope.selectedUser.host = dataSvc.selectedHost.id;
					dataSvc.filteredCompanies = angular.copy($filter('filter')(dataSvc.companies, { host: dataSvc.selectedHost.id }));
					if ($scope.companyId) {
						dataSvc.selectedCompany = $filter('filter')(dataSvc.filteredCompanies, { id: $scope.companyId })[0];
						$scope.companySelected();
					}
				}
				$scope.companySelected = function () {
					if ($scope.selectedUser)
						$scope.selectedUser.company = dataSvc.selectedCompany.id;
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
				$scope.validateUser = function() {
					var u = $scope.selectedUser;
					if (u) {
						if (!u.firstName || !u.lastName || !u.email  || !u.subjectUserName)
							return false;
						else if ((u.role.roleId < 31) && (!u.company))
							return false;
						else if ((u.role.roleId <51) && (!u.host))
							return false;
						else
							return true;
					} else
						return false;
				}
				$scope.buildAccesses = function() {
					
					dataSvc.userAccessList = angular.copy(dataSvc.accessList);
					$.each(dataSvc.userAccessList, function(index, i) {
						i.hasAccess = $scope.userHasAccess(i.claimType);
						
					});
				}
				$scope.userHasAccess = function(claimType) {
					var match = $filter('filter')($scope.selectedUser.claims, { claimType: claimType });
					return match.length > 0 ? true : false;
				}
				$scope.includeAll = function() {
					$.each(dataSvc.userAccessList, function (index, i) {
						if(i.accessLevel<=$scope.selectedUser.role.roleId)
							i.hasAccess = true;
						else {
							i.hasAccess = false;
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
						else
						{
							if (match.length > 0) {
								$scope.selectedUser.claims.splice($scope.selectedUser.claims.indexOf(match[0]), 1);
							}
						}
					});
					commonRepository.saveUser($scope.selectedUser).then(function (result) {
						
						var exists = $filter('filter')($scope.list, { userId:result.subjectUserId });
						if (exists.length === 0) {
							$scope.list.push(result);
						} else {
							$scope.list.splice($scope.list.indexOf(exists[0]), 1);
							$scope.list.push(result);
						}
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						if ($scope.selectedUser.subjectUserId)
							addAlert('successfully saved user', 'success');
						else
							addAlert('successfully created a new user with default password. email has been sent to the user to confirm', 'success');
						$scope.cancel();
					}, function (error) {
						addAlert('Error: ' + error.statusText, 'danger');
					});
				}
				
				$scope.resetPassword = function() {
					commonRepository.resetPassword($scope.selectedUser).then(function (result) {
						addAlert('successfully sent a password reset email to the user', 'success');
					}, function (error) {
						addAlert('Error: ' + error.statusText, 'danger');
					});
				}
				var init = function () {
					setRoleList();
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
