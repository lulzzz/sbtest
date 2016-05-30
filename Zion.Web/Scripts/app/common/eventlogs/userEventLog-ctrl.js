'use strict';

userEventLog.controller('userEventLogCtrl', [
	'$scope', '$element', '$anchorScroll', '$location', 'userEventLogRepository', '$modal', 'zionAPI', '$window', '$filter', 'ngTableParams',
	function($scope, $element, $anchorScroll, $location, userEventLogRepository, $modal, zionAPI, $window, $filter, ngTableParams) {
		$scope.data = {
			userList: [],
			userEventLogList: [],
			startDate: null,
			endDate: null,
			selectedUser: null,
			selectedUserId: null,
			openedStartDate: false,
			openedEndDate: false
		};

		$scope.isFilterOpen = true;
		$scope.alerts = [];

		$scope.addAlert = function(error, type) {
			$scope.alerts = [];
			$scope.alerts.push({
				msg: error,
				type: type
			});
		};

		$scope.dateOptions = {
			format: 'dd/MMyyyy',
			startingDay: 1
		};
		$scope.today = function() {
			$scope.dt = new Date();
		};
		$scope.today();

		$scope.clear = function() {
			$scope.dt = null;
		};
		$scope.openStartDate = function($event) {

			$event.preventDefault();
			$event.stopPropagation();
			$scope.data.openedStartDate = true;
		};
		$scope.openEndDate = function($event) {
			$event.preventDefault();
			$event.stopPropagation();
			$scope.data.openedEndDate = true;
		};


		$scope.closeAlert = function(index) {
			$scope.alerts.splice(index, 1);
		};

		$scope.tableData = [];

		$scope.tableParams = new ngTableParams({
			page: 1, // show first page
			count: 10, // count per page
			filter: {
				userId: '' // initial filter
			},
			sorting: {
				userId: 'asc' // initial sorting
			}
		}, {
			total: $scope.data.userEventLogList.length, // length of data
			getData: function($defer, params) {
				$scope.fillTableData(params);
				$defer.resolve($scope.tableData);
			}
		});

		$scope.fillTableData = function(params) {
			// use build-in angular filter
			var orderedData = params.filter() ?
				$filter('filter')($scope.data.userEventLogList, params.filter()) :
				$scope.data.userEventLogList;
			orderedData = params.sorting() ?
				$filter('orderBy')(orderedData, params.orderBy()) :
				orderedData;

			$scope.tableData = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count());

			params.total(orderedData.length); // set total for recalc pagination
		};

		$scope.getData = function() {
			if ($scope.data.selectedUser) {
				$scope.data.selectedUserId = $scope.data.selectedUser.userId;
			} else {
				$scope.data.selectedUserId = null;
			}
			userEventLogRepository.getUserEventLog($scope.data.selectedUserId, $scope.data.startDate, $scope.data.endDate).then(function(result) {
				$scope.data.userEventLogList = result;
				$scope.tableParams.reload();
				$scope.fillTableData($scope.tableParams);
			}, function(error) {
				$scope.addAlert('Unable to get user event log data.', 'danger');
			});
		};
		$scope.exportUserEventLog = function() {
			if ($scope.data.selectedUser) {
				$scope.data.selectedUserId = $scope.data.selectedUser.userId;
			} else {
				$scope.data.selectedUserId = null;
			}
			userEventLogRepository.exportUserEventLog($scope.data.selectedUserId, $scope.data.startDate, $scope.data.endDate).then(function(result) {
				var a = document.createElement('a');
				a.href = result.file;
				a.target = '_blank';
				a.download = result.name;
				document.body.appendChild(a);
				a.click();
			}, function(error) {
				$scope.addAlert('Unable to export user event log data.', 'danger');
			});
		};

		function init() {
			userEventLogRepository.getUserList().then(function(list) {
				$scope.data.userList = list;
			});
		}

		init();

	}
]);