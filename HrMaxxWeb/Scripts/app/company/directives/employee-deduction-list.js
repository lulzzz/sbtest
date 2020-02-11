'use strict';

common.directive('employeeDeductionList', ['$uibModal', 'zionAPI', 'version',
	function ($modal, zionAPI, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				employeeId: "=employeeId",
				companyDeductions: "=companyDeductions",
				list: "=list",
				saveToServer: "=saveToServer",
				showControls: "=showControls",
				payDay: "=?payDay",
				agencies: "=agencies",
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/employee-deduction-list.html?v=' + version,

			controller: ['$scope', '$filter', 'companyRepository', 'ClaimTypes',
				function ($scope, $filter, companyRepository, ClaimTypes) {
					var dataSvc = {
						types: [{
								key: 1,
								value: 'Percentage'
							}, {
								key: 2,
								value: 'Amount'
							}
						],
						ceilingMethods: [{
							key: 1,
							value: '%'
						}, {
							key: 2,
							value: '$'
						}
						],
						agencies: $scope.agencies ? angular.copy($scope.agencies) : [],
						canChangeDates: $scope.mainData.hasClaim(ClaimTypes.EmployeeDeductionDates, 1)
					};
					$scope.payDay = $scope.payDay ? moment($scope.payDay).startOf('day').toDate() : moment().startOf('day').toDate();
					$scope.data = dataSvc;

					$scope.showDates = function (item) {
						if (item.deduction) {
							if (item.deduction.startDate && item.deduction.endDate)
								return '(' + moment(item.deduction.startDate).format('MM/DD/YYYY') + ' - ' + moment(item.deduction.endDate).format('MM/DD/YYYY') + ' )';
							else if (item.deduction.startDate)
								return '( From ' + moment(item.deduction.startDate).format('MM/DD/YYYY') + ' )';
							else if (item.deduction.endDate)
								return '( Till ' + moment(item.deduction.endDate).format('MM/DD/YYYY') + ' )';
							else
								return null;
						}
						
					}
					$scope.showEmployeeDates = function (item) {
						if (item.startDate && item.endDate)
							return '(' + moment(item.startDate).format('MM/DD/YYYY') + ' - ' + moment(item.endDate).format('MM/DD/YYYY') + ' )';
						else if (item.startDate)
							return '( From ' + moment(item.startDate).format('MM/DD/YYYY') + ' )';
						else if (item.endDate)
							return '( Till ' + moment(item.endDate).format('MM/DD/YYYY') + ' )';
						else
							return null;
					}
				$scope.getAgencyName = function(id) {
					if (id) {
						var fil = $filter('filter')(dataSvc.agencies, { id: id })[0];
						if (fil)
							return fil.name;
					}
				}
				var addAlert = function (error, type) {
					$scope.$parent.$parent.addAlert(error, type);
				};
					$scope.selected = null;
					$scope.selectedIndex = null;
				$scope.add = function () {
					var item = {
						id: 0,
						employeeId: $scope.employeeId,
						deduction: null,
						method: dataSvc.types[1],
						rate: 0,
						annualMax: null,
						limit: null,
						ceilingPerCheck: null,
                        ceilingMethod: null,
                        employerRate: null,
                        employeeWithheld: 0,
                        employerWithheld: 0,
						note: '',
						startDate: null,
						endDate: null

					};
					$scope.list.push(item);
					$scope.setSelected(item, $scope.list.indexOf(item));
				},
				
                    $scope.save = function (index) {
                    
                        var item = $scope.selected;
						if ($scope.saveToServer) {
							item.employeeId = $scope.employeeId;
							item.ceilingPerCheck1 = item.ceilingPerCheck;
							companyRepository.saveEmployeeDeduction(item).then(function(deduction) {
								item.id = deduction.id;
								$scope.selected = null;
								$scope.$parent.$parent.updateDeductionList($scope.list);
								addAlert('successfully saved employee deduction', 'success');
							}, function(error) {
								addAlert('error in saving deduction', 'danger');
							});
						} else {
							$scope.selected = null;
							$scope.selectedIndex = null;
						}
					
                    }
                    $scope.showWarning = function() {
                        if ($scope.selected) {
                            if ($scope.selected.limit === "0" || $scope.selected.ceilingPerCheck === "0")
                                return true;
                            else
                                return false;
                        }
					}
					$scope.showWarningText = function (item) {
						if ((item.startDate && moment(item.startDate).toDate() > $scope.payDay)
							|| (item.endDate && moment(item.endDate).toDate() < $scope.payDay)
							|| (item.deduction && item.deduction.startDate && moment(item.deduction.startDate).toDate() > $scope.payDay)
							|| (item.deduction && item.deduction.endDate && moment(item.deduction.endDate).toDate() < $scope.payDay))
							return true;
						else
							return false;
					}
                    $scope.delete = function (index) {
                        var item = $scope.list[index];
						if ($scope.saveToServer) {
							$scope.mainData.confirmDialog('to remove this employee deduction', 'danger',
								function () {
									companyRepository.deleteEmployeeDeduction(item.id).then(function (deduction) {
										$scope.list.splice(index, 1);
										$scope.$parent.$parent.updateDeductionList($scope.list);
									}, function (error) {
											$scope.mainData.handleError('error in saving deduction', error, 'danger');
									})
								});
						} else {
							$scope.list.splice(index, 1);
						}
					}
                    $scope.cancel = function (index) {
                        
					if ($scope.original && $scope.original.id === $scope.selected.id) {
						$scope.list[index] = angular.copy($scope.original);
					}
						$scope.selected = null;
						$scope.selectedIndex = null;
				}
				$scope.setSelected = function(item, index) {
					$scope.selected = item;
					$scope.selectedIndex = index;
					$scope.original = angular.copy($scope.selected);
					$scope.selected.startDate = $scope.selected.startDate ? moment($scope.selected.startDate).toDate() : null;
					$scope.selected.endDate = $scope.selected.endDate ? moment($scope.selected.endDate).toDate() : null;
				}
                    $scope.isValid = function(index) {
                        var form = $('form[name="dedform' + index + '"]');
                        return form.parsley().validate();
                    }
                    $scope.isItemValid = function (item, index) {
                        var returnVal = true;
                        if (item) {
							var form = $('form[name="dedform' + index + '"]');
							var formvalidation = form.parsley().validate();
							if (!formvalidation)
								return false;

							if (!item.deduction || !item.method || item.rate < 0)
								returnVal = false;
							else if (item.ceilingPerCheck < 0 || (item.ceilingPerCheck > 0 && (!item.ceilingMethod || (item.ceilingMethod.key === 1 && item.ceilingPerCheck > 100))))
								returnVal = false;
							else if (item.employerRate > 100)
								returnVal = false;
							else if (item.deduction && item.deduction.type && item.deduction.type.id === 3) {
								if (!item.accountNo || !item.agencyId)
									returnVal = false;


							}
							
                        }
                        return returnVal;

                    }
				$scope.availableCompanyDeductions = function(index) {
					var returnList = [];
					if ($scope.companyDeductions) {
						$.each($scope.companyDeductions, function (ind, d) {
							if (!d.endDate || (d.endDate && (moment(d.endDate).toDate()>$scope.payDay ))) {
								var matching = $filter('filter')($scope.list, { deduction: { id: d.id } })[0];
								if (!matching || (index !== -1 && $scope.list.indexOf(matching) === index)) {
									returnList.push(d);
								}
							}
							
						});
					}
					
					return returnList;
                    }
                    $scope.getWidgetClass = function (item) {
                        if (item.deduction && item.deduction.type) {
                            if (item.deduction.type.category === 1)
                                return 'bg-green';
                            else if (item.deduction.type.category === 2)
                                return 'bg-blue';
                            else if (item.deduction.type.category === 3)
                                return 'bg-purple';
                            else if (item.deduction.type.category === 4)
                                return 'bg-black';
                        }
                        
                        else
                            return 'bg-red-darker';
                    }
                    $scope.getWidgetSubClass = function (item) {
                        if (item.deduction && item.deduction.type) {
                            if (item.deduction.type.category === 1)
                                return 'border-green';
                            else if (item.deduction.type.category === 2)
                                return 'border-blue';
                            else if (item.deduction.type.category === 3)
                                return 'border-purple';
                            else if (item.deduction.type.category === 4)
                                return 'border-black';
                        }

                        else
                            return 'border-red';
					}
					$scope.showDetails = function (item, index) {
						if (!$scope.selected) {
							return false;
						}
						else if ($scope.selected.id === item.id && index===$scope.selectedIndex)
							return true;
						//return selected && ((selected.id && selected.id === item.id) || (!selected.id && saveToServer && selected.employeeDeduction.id === item.employeeDeduction.id))
					}
				
				

			}]
		}
	}
]);
