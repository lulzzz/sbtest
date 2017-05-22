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
					roles: [
					{
						roleId: 1,
						roleName: 'Master',
						show: true
			}, {
						roleId: 2,
						roleName: 'CorpStaff',
						show: true
					}, {
						roleId: 3,
						roleName: 'Host',
						show: true
					}, {
						roleId: 6,
						roleName: 'HostStaff',
						show: true
					}, {
						roleId: 4,
						roleName: 'Company',
						show: true
					}, {
						roleId: 5,
						roleName: 'Employee',
						show: true
					}]
				}
				

				var setRoleList = function () {
					if ($scope.mainData.userRole === 'Master') {
					} else if ($scope.mainData.userRole === 'CorpStaff') {
						$.each(dataSvc.roles, function(index, role) {
							if (role.roleId === 1)
								role.show = false;
						});
					} else if ($scope.mainData.userRole === 'Host' || $scope.mainData.userRole === 'HostStaff') {
						$.each(dataSvc.roles, function (index, role) {
							if (role.roleId === 1 || role.roleId === 2)
								role.show = false;
						});
					} else if ($scope.mainData.userRole === 'Company') {
						$.each(dataSvc.roles, function (index, role) {
							if (role.roleId === 1 || role.roleId === 2 || role.roleId === 3 || role.roleId === 6)
								role.show = false;
						});
					} 
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
						userId: null,
						firstName: '',
						lastName: '',
						email: '',
						roleId: null,
						phone: '',
						active: false,
						sourceTypeId: $scope.parentTypeId,
						hostId: $scope.hostId,
						companyId: $scope.companyId,
						employeeId: $scope.employeeId
						
					};
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
				}
				$scope.setSelectedUser = function(item) {
					$scope.originalUser = item;
					$scope.selectedUser = angular.copy(item);
					dataSvc.selectedHost = item.host ? $filter('filter')(dataSvc.hosts, { id: item.host })[0] : null;
					if (dataSvc.selectedHost)
						$scope.hostSelected();
					dataSvc.selectedCompany = item.company ? $filter('filter')(dataSvc.companies, { id: item.company })[0] : null;
					if (dataSvc.selectedCompany)
						$scope.companySelected();
					dataSvc.selectedEmployee = item.employee ? $filter('filter')(dataSvc.employees, { id: item.employee })[0] : null;
				}
				$scope.roleChanged = function () {
					var item = $scope.selectedUser;
					if ($scope.originalUser) {
						if (item.role.roleId === 1 || item.role.roleId === 2) {
							item.host = null;
							item.company = null;
						}
						if (item.role.roleId === 3 || item.role.roleId === 6) {
							item.host = $scope.originalUser.host;
							item.company = null;
							dataSvc.selectedHost = item.host ? $filter('filter')(dataSvc.hosts, { id: item.host })[0] : null;
						}
						if (item.role.roleId === 4) {
							item.host = $scope.originalUser.host;
							item.company = $scope.originalUser.company;
							dataSvc.selectedHost = item.host ? $filter('filter')(dataSvc.hosts, { id: item.host })[0] : null;
							dataSvc.selectedCompany = item.company ? $filter('filter')(dataSvc.companies, { id: item.company })[0] : null;
						}
						if (item.role.roleId === 5) {
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
					}
					
				}
				
				$scope.hostSelected = function() {
					$scope.selectedUser.host = dataSvc.selectedHost.id;
					dataSvc.filteredCompanies = angular.copy($filter('filter')(dataSvc.companies, { host: dataSvc.selectedHost.id }));
				}
				$scope.companySelected = function () {
					$scope.selectedUser.company = dataSvc.selectedCompany.id;
					dataSvc.filteredEmployees = angular.copy($filter('filter')(dataSvc.employees, { company: dataSvc.selectedCompany.id }));
				}
				$scope.employeeSelected = function () {
					$scope.selectedUser.employee = dataSvc.selectedEmployee.id;
					
				}
				$scope.validateUser = function() {
					var u = $scope.selectedUser;
					if (u) {
						if (!u.firstName || !u.lastName || !u.email || !u.phone || !u.userName)
							return false;
						else if ((u.role.roleId >2) && (!u.host))
							return false;
						else if ((u.role.roleId === 4 || u.role.roleId === 5) && (!u.company))
							return false;
						else
							return true;
					} else
						return false;
				}
				
				$scope.save = function () {
					commonRepository.saveUser($scope.selectedUser).then(function (result) {
						
						var exists = $filter('filter')($scope.list, { userId:result.userId });
						if (exists.length === 0) {
							$scope.list.push(result);
						} else {
							$scope.list.splice($scope.list.indexOf(exists[0]), 1);
							$scope.list.push(result);
						}
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						if($scope.selectedUser.userId)
							addAlert('successfully saved user', 'success');
						else
							addAlert('successfully created a new user with default password. email has been sent to the user to confirm', 'success');
						$scope.selectedUser = null;
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
