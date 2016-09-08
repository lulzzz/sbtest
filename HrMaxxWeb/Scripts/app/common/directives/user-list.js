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

			controller: ['$scope', '$element', '$location', '$filter', 'commonRepository', 'ngTableParams', 'EntityTypes', function ($scope, $element, $location, $filter, commpnRepository, ngTableParams, EntityTypes) {
				$scope.targetTypeId = EntityTypes.Contact;
				$scope.list = [];
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
					getData: function ($defer, params) {
						$scope.fillTableData(params);
						$defer.resolve($scope.tableData);
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
					$scope.selectedUser = angular.copy(item);
					$scope.selectedUser.hostId = $scope.hostId;
					$scope.selectedUser.companyId = $scope.companyId;
				}
				$scope.validateUser = function() {
					if ($scope.selectedUser) {
						if ($scope.selectedUser.firstName && $scope.selectedUser.lastName && $scope.selectedUser.email && $scope.selectedUser.phone && $scope.selectedUser.userName)
							return true;
						else
							return false;
					} else
						return false;
				}
				
				$scope.save = function () {
					commpnRepository.saveUser($scope.selectedUser).then(function (result) {
						
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
					commpnRepository.resetPassword($scope.selectedUser).then(function (result) {
						addAlert('successfully sent a password reset email to the user', 'success');
					}, function (error) {
						addAlert('Error: ' + error.statusText, 'danger');
					});
				}
				var init = function () {
					commpnRepository.getUsers($scope.hostId, $scope.companyId).then(function (data) {
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
