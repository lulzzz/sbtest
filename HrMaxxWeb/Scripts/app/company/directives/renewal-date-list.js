'use strict';

common.directive('renewalDateList', ['zionAPI','version',
	function (zionAPI, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				companyId: "=companyId",
				list: "=list",
				mainData: "=mainData",
				showControls: "=showControls"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/renewal-date-list.html?v=' + version,

			controller: ['$scope', '$rootScope', '$filter', 'companyRepository',
				function ($scope, $rootScope, $filter, companyRepository) {
					var dataSvc = {
						months: [{ id: 1, name: 'January' }, { id: 2, name: 'February' }, { id: 3, name: 'March' }, { id: 4, name: 'April' },
							{ id: 5, name: 'May' }, { id: 6, name: 'June' }, { id: 7, name: 'July' }, { id: 8, name: 'August' },
							{ id: 9, name: 'September' }, { id: 10, name: 'October' }, { id: 11, name: 'November' }, { id: 12, name: 'December' }],
						
					}
					$scope.data = dataSvc;
				$scope.selected = null;
					$scope.rateTypes = [{ id: 1, name: 'Flat Rate' }, {id:2, name: 'Times Base Rate'}];
				var addAlert = function (error, type) {
					$scope.mainData.showMessage(error, type);
					};
					$scope.getMonthName = function (m) {
						return $filter('filter')(dataSvc.months, { id: m })[0].name;
					}
				$scope.closeAlert = function (index) {
					
					};
					
				$scope.add = function () {
					var item = {
						id: 0,
						companyId: $scope.companyId,						
						description: '',
						month: '',
						day: 1
					};
					$scope.list.push(item);
					$scope.setSelected($scope.list.indexOf(item));
				},
				
				$scope.save = function(item) {
					companyRepository.saveRenewalDate(item).then(function(data) {
						item.id = data.id;
						$scope.selected = null;
						$rootScope.$broadcast('companyRenewalUpdated', { pc: data });
						addAlert('successfully saved renewal date', 'success');
					}, function(error) {
						addAlert('error in saving renewal date', 'danger');
					});
				}
				$scope.cancel = function (index) {
					if ($scope.selected.id === 0) {
						$scope.list.splice(index, 1);
					}
					else {
						$scope.list[index] = angular.copy($scope.original);
					}
					$scope.original = null;
					$scope.selected = null;
				}
					$scope.setSelected = function (index) {

						$scope.selected = $scope.list[index];
						$scope.original = angular.copy($scope.selected);
					}
					
				$scope.isItemValid = function(item) {
					if (!item.description || !item.month || !item.day )
						return false;
					else if ((item.month === 2 && item.day > 28) || ((item.month === 4 || item.month === 6 || item.month === 9 || item.month === 11) && item.day > 30))
						return false;
					else
						return true;
				}
				
				
				

			}]
		}
	}
]);
