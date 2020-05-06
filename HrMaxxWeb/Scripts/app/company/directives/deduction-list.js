'use strict';

common.directive('deductionList', ['zionAPI', 'version',
	function (zionAPI, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				companyId: "=companyId",
				list: "=list",
				types: "=types",
				mainData: "=mainData",
				showControls: "=showControls"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/deduction-list.html?nd=' + version,

			controller: ['$scope', '$rootScope', '$filter', 'companyRepository', 'ClaimTypes',
				function ($scope, $rootScope, $filter, companyRepository, ClaimTypes) {

					$scope.selected = null;
					$scope.canChangeDates = $scope.mainData.hasClaim(ClaimTypes.CompanyDeductionDates, 1);
					var addAlert = function (error, type) {
						$scope.mainData.showMessage(error, type);
					};

					$scope.add = function () {
						$scope.selected = {
							id: 0,
							companyId: $scope.companyId,
							isNew: true,
							applyInvoiceCredit: false,
							annualMax: null,
							floorPerCheck: null,
							startDate: null,
							endDate: null
						};
						$scope.original = angular.copy($scope.selected);
						$scope.list.push($scope.selected);
					},
					$scope.showDates = function (item) {
						if (item.startDate && item.endDate)
							return '(' + moment(item.startDate).format('MM/DD/YYYY') + ' - ' + moment(item.endDate).format('MM/DD/YYYY') + ' )';
						else if (item.startDate)
							return '( From ' + moment(item.startDate).format('MM/DD/YYYY') + ' )';
						else if (item.endDate)
							return '( Till ' + moment(item.endDate).format('MM/DD/YYYY') + ' )';
						else
							return null;
					}
					$scope.showWarningText = function (item) {
						var today = moment().startOf('day').toDate();
						if ((item.startDate && moment(item.startDate).toDate() > today))
							return true;
						else if ((item.endDate && moment(item.endDate).toDate() < today))
							return true;
						else
							return false;
					}
					$scope.showDeductionType = function (item) {
						var selected = [];
						if (item.type) {
							selected = $filter('filter')($scope.types, { id: item.type.id }, true);
						}
						return selected && selected.length ? selected[0].categoryText + ' - ' + selected[0].name : 'Not set';
					},
						$scope.save = function (item) {
							item.startDate = item.startDate ? moment(item.startDate).format("MM/DD/YYYY") : null;
							item.endDate = item.endDate ? moment(item.endDate).format("MM/DD/YYYY") : null;
							companyRepository.saveCompanyDeduction(item).then(function (deduction) {
								item.id = deduction.id;
								$scope.list = $filter('orderBy')($scope.list, 'type.category');
								$scope.selected = null;
								$rootScope.$broadcast('companyDeductionUpdated', { ded: item });
								addAlert('successfully saved deduction', 'success');
							}, function (error) {
								addAlert('error in saving deduction', 'danger');
							});
						}

					$scope.cancel = function (index) {
						var message = "changed will be lost.";
						if ($scope.selected.id === 0) {
							message = "this deduction is not saved so it will be removed";

						}
						$scope.mainData.confirmDialog(message, 'warning', function () {
							if ($scope.selected.id === 0) {
								$scope.list.splice($scope.list.indexOf($scope.selected), 1);
							}
							$scope.selected = null;
							$scope.original = null;
						});
						
					}
					$scope.setSelected = function (index) {
						$scope.selected = $scope.list[index];
						$scope.original = angular.copy($scope.selected);
						$scope.selected.startDate = $scope.selected.startDate ? moment($scope.selected.startDate).toDate() : null;
						$scope.selected.endDate = $scope.selected.endDate ? moment($scope.selected.endDate).toDate() : null;
					}

					$scope.isItemValid = function (item) {
						if (!item.type || !item.deductionName)
							return false;
						else
							return true;
					}
					$scope.getWidgetClass = function (item) {
						if (item && item.type) {
							if (item.type.category === 1)
								return 'bg-green';
							else if (item.type.category === 2)
								return 'bg-blue';
							else if (item.type.category === 3)
								return 'bg-purple';
							else if (item.type.category === 4)
								return 'bg-black';
						}

						else
							return 'bg-red-darker';
					}
					$scope.getWidgetSubClass = function (item) {
						if (item && item.type) {
							if (item.type.category === 1)
								return 'border-green';
							else if (item.type.category === 2)
								return 'border-blue';
							else if (item.type.category === 3)
								return 'border-purple';
							else if (item.type.category === 4)
								return 'border-black';
						}

						else
							return 'border-red';
					}
					$scope.hasItemChanged = function () {
						if (!$scope.selected)
							return false;
						else {
							if (angular.equals($scope.selected, $scope.original))
								return false;
							else
								return true;
						}
					}




				}]
		}
	}
]);
