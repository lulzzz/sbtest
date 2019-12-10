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
				agencies:"=agencies"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/employee-deduction-list.html?v=' + version,

			controller: ['$scope', '$filter', 'companyRepository',
				function ($scope, $filter, companyRepository) {
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
						agencies: $scope.agencies? angular.copy($scope.agencies) : []
					};

					$scope.data = dataSvc;

				
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
				$scope.add = function () {
					$scope.selected = {
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
                        employerWithheld:0

					};
					$scope.list.push($scope.selected);
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
                    $scope.delete = function (index) {
                        var item = $scope.list[index];
					if ($scope.saveToServer) {
						companyRepository.deleteEmployeeDeduction(item.id).then(function(deduction) {
							$scope.list.splice(index, 1);
							$scope.$parent.$parent.updateDeductionList($scope.list);
						}, function(error) {
							addAlert('error in saving deduction', 'danger');
						});
					} else {
						$scope.list.splice(index, 1);
					}
				}
                    $scope.cancel = function () {
                        var index = $scope.list.indexOf($scope.selected);
					if ($scope.selected.id === 0) {
						$scope.list.splice(index, 1);
					}
					else if ($scope.original && $scope.original.id === $scope.selected.id) {
						$scope.list[index] = angular.copy($scope.original);
					}
					$scope.selected = null;
				}
				$scope.setSelected = function(item) {
					$scope.selected = item;
					$scope.original = angular.copy($scope.selected);
				}
                    $scope.isValid = function(index) {
                        var form = $('form[name="dedform' + index + '"]');
                        return form.parsley().validate();
                    }
                    $scope.isItemValid = function (item) {
                        var returnVal = true;
                        if (item) {
                            if (!item.deduction || !item.method || item.rate<0)
                                returnVal =  false;
                            if (item.ceilingPerCheck < 0 || (item.ceilingMethod.key === 1 && item.ceilingPerCheck > 100))
                                returnVal =  false;
                            if (item.employerRate>100)
                                returnVal =  false;
                            if (item.deduction.type.id === 3) {
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
							var matching = $filter('filter')($scope.list, { deduction: { id: d.id } })[0];
							if (!matching || (index !== -1 && $scope.list.indexOf(matching) === index)) {
								returnList.push(d);
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
				
				

			}]
		}
	}
]);
