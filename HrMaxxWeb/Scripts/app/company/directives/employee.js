'use strict';

common.directive('employee', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData",
				selected: "=employee",
				isPopup: "=isPopup",
				showControls: "=showControls"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/employee.html?v='+version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'EntityTypes',
				function ($scope, $element, $location, $filter, companyRepository, EntityTypes) {
					var dataSvc = {
						payCodes: [],
						companyStates: [],
						compensations: [],
						employeeMetaData: null,
						sourceTypeId: EntityTypes.Employee,
						openedRack:1
					}
					$scope.tab = 1;
					$scope.alert = null;
					$scope.addAlert = function (error, type) {
						$scope.alert = null;
						if (!$scope.isPopup)
							$scope.$parent.$parent.addAlert(error, type);
						else {
							$scope.alert = { message: error, type: type };
						}
					};
				
					$scope.data = dataSvc;
					
					$scope.cancel = function () {
						if (!$scope.isPopup)
							$scope.$parent.$parent.cancel();
						else
							$scope.$parent.cancel();
					}

					$scope.payTypeList = function(item) {
						var returnList = $scope.availablePayTypes();
						if(item && item.payType)
							returnList.push(item.payType);
						return returnList;
					}
					$scope.availablePayTypes = function () {
						if(dataSvc.employeeMetaData)
							return $filter('filter')(dataSvc.employeeMetaData.payTypes, { used: 0 });
						else {
							return [];
						}
					}
					$scope.updatePayTypeUsed = function (item) {
						if (item.payType) {
							$.each(dataSvc.employeeMetaData.payTypes, function (index, paytype) {
								paytype.used = 0;
							});
							$.each($scope.selected.compensations, function (index, comp) {
								var exists = $filter('filter')(dataSvc.employeeMetaData.payTypes, { id: comp.payType.id })[0];
								if (exists)
									exists.used = 1;
							});
						}
						
					}
					$scope.addPayType = function () {
						var newpaytype = {
							payType: null,
							amount: 0,
							isNew: true
						};
						$scope.selected.compensations.push(newpaytype);
					}
					$scope.cancel1 = function (index) {
						$scope.selected.compensations.splice(index, 1);
					}
					$scope.isPayTypeValid = function (item) {
						if (!item.payType || !item.amount)
							return false;
						else
							return true;
					}
					$scope.selectedState = null;
					$scope.stateSelected = function() {
						$scope.selected.state.state = $scope.selectedState.state;
					}
					$scope.payTypeChanged = function() {
						if ($scope.selected.payType === 1)
							$scope.selected.rate = 0;
						else if ($scope.selected.payType == 3) {
							$scope.selected.payCodes = [];
							$scope.selectedPayCodes = [];
							$scope.selected.rate = 0;
							$scope.selected.payCodes.push({
								id: -1,
								companyId: $scope.selected.companyId,
								code: 'PW',
								description: 'Piece-work',
								hourlyRate:0
							});
						}
						else if ($scope.selected.payType === 2) {
							$scope.selected.payCodes = [];
							$scope.selectedPayCodes = [];
						} else {
							$scope.selected.payCodes = [];
							$scope.selectedPayCodes = [];
							$scope.selected.rate = 0;
							for (var i = 1; i <= 18; i++) {
								$scope.selected.payCodes.push({
									id: (-1 - i),
									companyId: $scope.selected.companyId,
									code: 'JC',
									description: 'Job Cost ' + i ,
									hourlyRate: 0
								});
							}
							
						}
					}

					$scope.validate = function () {
						return validateStep1() && validateStep2() && validateStep3();
					}
					var validateStep1 = function () {
						var c = $scope.selected;
						if (!c.ssn || !c.hireDate || !c.statusId)
							return false;
						else if (!c.contact.firstName || !c.contact.lastName || !c.contact.email)
							return false;
						else if (!c.contact.address.addressLine1 || !c.contact.address.countryId || !c.contact.address.stateId || !c.contact.address.zip)
							return false;
						else {
							return true;
						}
					}
					var validateStep2 = function () {
						var c = $scope.selected;
						if (!c.payrollSchedule || !c.payType)
							return false;
						if ((c.payType===1 || c.payType===2) && (c.rate<0 || c.rate===null))
							return false;
						if (c.paymentMethod === 2) {
							//var b = c.bankAccount;
							//if (!b || !b.bankName || !b.accountType || !$scope.validateRoutingNumber(b.routingNumber) || !b.routingNumber || !b.accountNumber)
							//	return false;
							if (!c.directDebitAuthorized || $scope.selectedBank || !c.bankAccounts || c.bankAccounts.length === 0 || $scope.ddPercentageAvailable() !== 0)
								return false;

						}
						return true;
					}
					var validateStep3 = function () {
						var c = $scope.selected;
						var returnVal = true;
						if (!c.taxCategory || !c.federalStatus || c.federalAdditionalAmount<0)
							returnVal = false;
						else if (!c.state.state || !c.state.state.stateId || !c.state.taxStatus || c.state.additionalAmount<0) {
							returnVal = false;
						}
						return returnVal;
					}
					$scope.validateRoutingNumber = function (rtn) {
						if (!rtn) {
							return true;
						}
						if (rtn === '000000000')
							return false;
						//Calculate Check Digit

						var sum = (rtn.charAt(0)) * 3;
						sum += (rtn.charAt(1)) * 7;
						sum += (rtn.charAt(2)) * 1;
						sum += (rtn.charAt(3)) * 3;
						sum += (rtn.charAt(4)) * 7;
						sum += (rtn.charAt(5)) * 1;
						sum += (rtn.charAt(6)) * 3;
						sum += (rtn.charAt(7)) * 7;

						sum = sum % 10;

						sum = 10 - sum;
						if (sum == 10)
							sum = 0;

						if (sum == (rtn.charAt(8) - '0'))
							return true;

						return false;
					}
					
					$scope.payCodeEvents = {
						onItemSelect: function (item) {
							$scope.selected.payCodes.push($filter('filter')($scope.mainData.selectedCompany.payCodes, { id: item.id })[0]);
						},
						onItemDeselect: function (item) {
							$scope.selected.payCodes.splice($scope.selected.payCodes.indexOf($filter('filter')($scope.mainData.selectedCompany.payCodes, { id: item.id })[0]), 1);
						},
						onDeselectAll: function () {
							$scope.selected.payCodes = [];
						}
					};
					
					$scope.save = function () {
						if (false === $('form[name="employee"]').parsley().validate())
							return false;
						if ($scope.selected.payType === 1) {
							var baseRatePC = $filter('filter')($scope.selected.payCodes, { id: 0 })[0];
							if (baseRatePC)
								baseRatePC.hourlyRate = $scope.selected.rate;
							else {
								$scope.selected.payCodes.push({
									id: 0,
									companyId: $scope.selected.companyId,
									code: 'Default',
									description: 'Base Rate',
									hourlyRate: $scope.selected.rate
								});
							}
						}
						companyRepository.saveEmployee($scope.selected).then(function (result) {
							if (!$scope.isPopup)
								$scope.$parent.$parent.save(result);
							else
								$scope.$parent.save(result);
						}, function (error) {
							$scope.addAlert('error saving employee', 'danger');
						});
					}
					

					var init = function () {
						companyRepository.getEmployeeMetaData().then(function (data) {
							$.each(data.payTypes, function (index, paytype) {
								paytype.used = 0;
							});
							dataSvc.employeeMetaData = data;
						}, function (error) {
							$scope.addAlert('error getting employee meta data', 'danger');
						});
						if ($scope.mainData.selectedCompany) {
							dataSvc.payCodes = $scope.mainData.selectedCompany.payCodes;
							$scope.selectedPayCodes = [];
							$scope.selectedPayTypes = [];
							dataSvc.companyStates = [];
							$.each($scope.mainData.selectedCompany.states, function (index, st) {
								dataSvc.companyStates.push(st.state);
							});
						}
						
						$timeout(function () {
							
							if ($scope.selected.birthDate)
								$scope.selected.birthDate = moment($scope.selected.birthDate).toDate();
							if ($scope.selected.hireDate)
								$scope.selected.hireDate = moment($scope.selected.hireDate).toDate();

							$.each($scope.selected.payCodes, function (index, pc) {
								if (pc.id > 0)
									$scope.selectedPayCodes.push({ id: pc.id });
							});
							if ($scope.showControls) {
								$timeout(function() {
									$("#wizard").bwizard({
										validating: function(e, ui) {
											if (ui.index == 0) {
												// step-1 validation
												if (false === $('form[name="employee"]').parsley().validate('wizard-step-1') || false === validateStep1()) {
													return false;
												}
											} else if (ui.index == 1) {
												// step-2 validation
												if (false === $('form[name="employee"]').parsley().validate('wizard-step-2') || false === validateStep2()) {
													return false;
												}
											} else if (ui.index == 2) {
												// step-3 validation
												if (false === $('form[name="employee"]').parsley().validate('wizard-step-3') || false === validateStep3()) {
													return false;
												}
											}
											return true;
										}
									});
								});
							} else {
								$timeout(function () {
									$("#wizard").bwizard();
								});
							}
							
						}, 1);
						

					}
					///Bank Account handling
					$scope.selectedBank = null;
					$scope.addBankAccount = function () {
						var acc = {
							id: 0,
							employeeId: $scope.selected.id,
							percentage: $scope.ddPercentageAvailable(),
							bankAccount:null
						};
							var ind = $scope.selected.bankAccounts.length;
						$scope.selected.bankAccounts.push(acc);
							$scope.setSelectedBank(ind);
						},

					$scope.saveBank = function () {
						$scope.selectedBank = null;
						$scope.selectedBankIndex = null;
					}
					$scope.delete = function (index) {
						$scope.selected.bankAccounts.splice(index, 1);
					}
					$scope.cancelBank = function (index) {
						if (!$scope.selectedBank.id) {
							$scope.selected.bankAccounts.splice(index, 1);
						}
						else if ($scope.originalBank && $scope.originalBank.id === $scope.selectedBank.id) {
							$scope.selected.bankAccounts[index] = angular.copy($scope.originalBank);
						}
						$scope.selectedBank = null;
						$scope.selectedBankIndex = null;
					}
					$scope.setSelectedBank = function (index) {
						$scope.selectedBank = null;
						$scope.selectedBankIndex = null;
						$timeout(function () {
							$scope.selectedBankIndex = index;
							$scope.selectedBank = $scope.selected.bankAccounts[index];
							$scope.originalBank = angular.copy($scope.selectedBank);
						}, 1);
						
					}
					$scope.ddPercentageAvailable = function () {
						var covered = 0;
						$.each($scope.selected.bankAccounts, function(ind, b) {
							covered += b.percentage;
						});
						return 100 - covered;
					}

					$scope.isbankValid = function () {
						var b = $scope.selectedBank;

						if (!b || !b.percentage || !b.bankAccount || !b.bankAccount.bankName || !b.bankAccount.accountType || !$scope.validateRoutingNumber(b.bankAccount.routingNumber) || !b.bankAccount.routingNumber || !b.bankAccount.accountNumber) {
							return false;
						}
						else
							return true;
					}
					//Bank Account Handling
					init();


				}]
		}
	}
]);
