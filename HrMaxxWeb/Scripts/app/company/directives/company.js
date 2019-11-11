'use strict';

common.directive('company', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData",
				selectedCompany: "=company",
				isPopup: "=isPopup",
				showControls: "=showControls"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/company.html?v=1.2' + version,

			controller: ['$scope', '$rootScope', '$element', '$location', '$filter', 'companyRepository', 'EntityTypes', 'ClaimTypes',
				function ($scope, $rootScope, $element, $location, $filter, companyRepository, EntityTypes, ClaimTypes) {
					var dataSvc = {
						sourceTypeId: EntityTypes.Company,
						companyMetaData: null,
						viewVersions: $scope.mainData.hasClaim(ClaimTypes.CompanyVersions, 1),
						viewContract: $scope.mainData.hasClaim(ClaimTypes.CompanyContract, 1),
						enablePayrollDaysInPast: $scope.mainData.hasClaim(ClaimTypes.CompanyPayrollDaysinPast, 1),
						updateEmployeeSchedules: false
					}

					$scope.data = dataSvc;
					$scope.alert = null;
					var addAlert = function (error, type) {
						$scope.alert = null;
						$scope.$parent.$parent.addAlert(error, type);
					};
					$scope.addAlert = function (error, type) {
						$scope.alert = null;
						if (!$scope.isPopup)
							$scope.$parent.$parent.addAlert(error, type);
						else {
							$scope.alert = { message: error, type: type };
						}
					};
					$scope.isFileUnderHostDisabled = function () {
						if ($scope.mainData.selectedHost.isPeoHost || ($scope.selectedCompany.lastPayrollDate && moment($scope.selectedCompany.lastPayrollDate).year() === moment().year()))
							return true;
						else {
							return false;
						}
					}


					$scope.cancel = function () {
						if (!$scope.isPopup)
							$scope.$parent.$parent.cancel();
						else
							$scope.$parent.cancel();
					}

					$scope.LinkCompanyAndBusinessAddress = function () {
						if ($scope.selectedCompany.isAddressSame) {
							$scope.selectedCompany.taxFilingName = $scope.selectedCompany.name;
							$scope.selectedCompany.businessAddress = $scope.selectedCompany.companyAddress;
						} else {
							$scope.selectedCompany.businessAddress = angular.copy($scope.selectedCompany.companyAddress);
						}

					}
					$scope.namechanged = function () {
						if ($scope.selectedCompany.isAddressSame) {
							$scope.selectedCompany.taxFilingName = $scope.selectedCompany.name;
						}
					}
					$scope.availableStates = function () {
						var states = [];
						if (dataSvc.companyMetaData) {
							$.each(dataSvc.companyMetaData.countries[0].states, function (index, state1) {
								if (state1.taxesEnabled) {
									var statematch = $filter('filter')($scope.selectedCompany.states, { state: { stateId: state1.stateId } });
									if (statematch.length === 0) {
										states.push(state1);
									}
								}
								
							});
						}

						return states;
					}
					$scope.addState = function () {
						var st = {
							state: {},
							stateEin: '',
							statePin: '',
							isNew: true
						};
						var available = $scope.availableStates();
						if (available.length === 1) {
							st.state = $filter('filter')(dataSvc.companyMetaData.countries[0].states, { stateId: available[0].stateId })[0];
						}
						$scope.selectedCompany.states.push(st);

					}
					$scope.removeState = function (state) {
						$scope.selectedCompany.states.splice($scope.selectedCompany.states.indexOf(state), 1);
					}

					$scope.isStateAvailable = function () {
						var stateAvailable = false;
						$.each(dataSvc.companyMetaData.countries[0].states, function (index, state1) {
							var statematch = $filter('filter')($scope.selectedCompany.states, { state: { stateId: state1.stateId } });
							if (statematch.length === 0) {
								stateAvailable = true;
							}
						});
						return stateAvailable;
					}
					$scope.isStateTaxAvailable = function (st) {
						if (dataSvc.companyMetaData) {
							var cst = $filter('filter')(dataSvc.companyMetaData.countries[0].states, { stateId: st.state.stateId })[0];
							st.einFormat = cst.einFormat;
							return cst.taxesEnabled;
						} else {
							return false;
						}
						

					}
					$scope.getStateEinFormat = function (st) {
						if (dataSvc.companyMetaData) {
							var cst = $filter('filter')(dataSvc.companyMetaData.countries[0].states, { stateId: st.state.stateId })[0];
							return (cst && cst.einFormat) ? cst.einFormat : "999-9999-9";
						}
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
					$scope.validateCCYear = function () {
						if (!$scope.selectedCompany.creditCardDetails)
							return true;
						if (!$scope.selectedCompany.contract.creditCardDetails.expiryYear)
							return false;
						var year = parseInt($scope.selectedCompany.contract.creditCardDetails.expiryYear);
						var month = parseInt($scope.selectedCompany.contract.creditCardDetails.expiryMonth);
						if (year < new Date().getFullYear())
							return true;
						else if (year === new Date().getFullYear() && month < new Date().getMonth() + 1)
							return false;
						else {
							return true;
						}

					}
					$scope.validateCompany = function () {
						return validateStep1() && validateStep2() && validateStep3() && validateStep4();
					}
					var validateStep1 = function () {
						var c = $scope.selectedCompany;
						if (!c.name)
							return false;
						else if (!c.companyAddress.addressLine1 || !c.companyAddress.countryId || !c.companyAddress.stateId || !c.companyAddress.zip)
							return false;
						else {
							return true;
						}
					}
					var validateStep2 = function () {
						var c = $scope.selectedCompany;
						if (c.payrollDaysInPast === null || !c.minWage || c.minWage < 10)
							return false;
						else
							return true;
					}
					var validateStep3 = function () {
						var c = $scope.selectedCompany;
						var returnVal = true;
						if (!c.isAddressSame && (!c.businessAddress.addressLine1 || !c.businessAddress.countryId || !c.businessAddress.stateId || !c.businessAddress.zip))
							returnVal = false;
						else if (!c.federalEIN || !c.federalPin) {
							returnVal = false;
						}
						else {
							if (c.states.length === 0) {
								returnVal = false;
								return false;
							}
							$.each(c.states, function (index, state1) {
								if (!state1.state.stateId || !state1.stateEIN || !state1.statePin) {
									returnVal = false;
									return false;
								}

							});
						}
						return returnVal;
					}
					var validateStep4 = function () {
						var c = $scope.selectedCompany.contract;
						if (!c)
							return false;
						if (c.contractOption === 1 && !c.prePaidSubscriptionOption)// || (c.prePaidSubscriptionOption > 1 && !c.billingOption)))
							return false;
						if (c.contractOption === 2 && !c.billingOption)
							return false;
						if (c.billingOption === 1) {
							var cc = c.creditCardDetails;
							if (!cc || !cc.cardType || !cc.cardNumber || !cc.expiryMonth || !cc.expiryYear || !$scope.validateCCYear() || !cc.securityCode)
								return false;
							if (!cc.billingAddress || !cc.billingAddress.addressLine1 || !cc.billingAddress.countryId || !cc.billingAddress.stateId || !cc.billingAddress.zip)
								return false;
						}
						if (c.billingOption === 2) {
							var b = c.bankDetails;
							if (!b || !b.bankName || !b.accountType || !b.validateRoutingNumber() || !b.routingNumber || !b.accountNumber)
								return false;
						}
						if (c.contractOption === 2 && c.billingOption === 3) {
							var i = c.invoiceSetup;
							if (!i)
								return false;
							if (i.recurringCharges.length > 0) {
								var invalidrc = false;
								$.each(i.recurringCharges, function (index, rc) {
									if (!rc.description || !rc.amount) {
										invalidrc = true;
										return false;
									}
								});
								if (invalidrc)
									return false;
							}
						}
						return true;

					}
					$scope.billingOptionChanged = function () {
						if ($scope.selectedCompany.contract.billingOption === 1 && !$scope.selectedCompany.contract.creditCardDetails) {
							$scope.selectedCompany.contract.creditCardDetails = {
								cardType: 1,
								cardName: '',
								expiryMonth: '',
								expiryYear: new Date().getFullYear(),
								securityCode: '',
								billingAddress: {

								}
							}
						}
						if ($scope.selectedCompany.contract.billingOption === 2 && !$scope.selectedCompany.contract.bankDetails) {
							$scope.selectedCompany.contract.bankDetails = {
								bankName: '',
								accountName: '',
								accountNumber: '',
								routingNumber: '',
								accountType: 1,
								sourceTypeId: $scope.sourceTypeId,
								sourceId: $scope.selectedCompany.id
							}
						}
						if ($scope.selectedCompany.contract.billingOption === 3 && !$scope.selectedCompany.contract.invoiceSetup) {
							$scope.selectedCompany.contract.invoiceSetup = {
								invoiceType: 1,
								invoiceStyle: 1,
								adminFeeMethod: 1,
								adminFee: 0,
								adminFeeThreshold: 35,
								suiManagement: $scope.mainData.selectedHost.isPeoHost ? 1 : 0,
								applyWCCharge: true,
								applyStatuaryLimits: !$scope.mainData.selectedHost.isPeoHost,
								applyEnvironmentalFee: $scope.mainData.selectedHost.isPeoHost,
								printClientName: false,
								recurringCharges: []
							}
						}
					}
					$scope.addRecurringCharge = function () {

						$scope.selectedCompany.recurringCharges.push({
							id: 0,
							year: new Date().getFullYear(),
							description: '',
							amount: 0,
							annualLimit: null,
							claimed:0
						});
					}
					$scope.removeRecurringCharge = function (rc, index) {
						$scope.selectedCompany.recurringCharges.splice(index, 1);
					}
					$scope.getRowClass = function (item) {
						if ($scope.selectedCompany && $scope.selectedCompany.id === item.id)
							return 'success';
						else {
							return 'default';
						}
					}

					$scope.save = function () {
						if (false === $('form[name="form-wizard"]').parsley().validate()) {
							var errors = $('.parsley-error');
							return false;
						}
							
						//if ($scope.selectedCompany.contract.billingOption !== 3)
						//	$scope.selectedCompany.contract.invoiceSetup = null;
						//if ($scope.selectedCompany.contract.billingOption === 0 || $scope.selectedCompany.contract.billingOption === 3) {
						//	$scope.selectedCompany.contract.creditCardDetails = null;
						//	$scope.selectedCompany.contract.bankDetails = null;
						//}
						//else if ($scope.selectedCompany.contract.billingOption === 1) {
						//	$scope.selectedCompany.contract.bankDetails = null;
						//} else {
						//	$scope.selectedCompany.contract.creditCardDetails = null;
						//	if ($scope.selectedCompany.contract.bankDetails) {
						//		$scope.selectedCompany.contract.bankDetails.sourceTypeId = $scope.sourceTypeId;
						//		$scope.selectedCompany.contract.bankDetails.sourceId = $scope.selectedCompany.id;
						//	}
						//}
						if ($scope.selectedCompany.contract.bankDetails) {
							$scope.selectedCompany.contract.bankDetails.sourceTypeId = $scope.sourceTypeId;
							$scope.selectedCompany.contract.bankDetails.sourceId = $scope.selectedCompany.id;
						}
						if ($scope.selectedCompany.isAddressSame) {
							$scope.selectedCompany.businessAddress = $scope.selectedCompany.companyAddress;
						}
						if (!$scope.selectedCompany.id) {
							$.each(dataSvc.companyMetaData.taxes, function (index, taxyearrate) {
								if ((taxyearrate.tax.stateId && taxyearrate.tax.stateId === $scope.selectedCompany.states[0].state.stateId) || !taxyearrate.tax.stateId) {

									var exists = $filter('filter')($scope.selectedCompany.companyTaxRates, { taxYear: taxyearrate.taxYear, taxId: taxyearrate.tax.id });
									if (exists.length === 0) {
										$scope.selectedCompany.companyTaxRates.push({
											id: 0,
											taxId: taxyearrate.tax.id,
											companyId: null,
											taxCode: taxyearrate.tax.code,
											taxYear: taxyearrate.taxYear,
											rate: taxyearrate.rate
										});
									}
									
								}

							});
						}
						var confirmMessage = "";
						if ($scope.mainData.selectedHost.isPeoHost && ($scope.original.contract.invoiceSetup && !angular.equals($scope.original.contract.invoiceSetup, $scope.selectedCompany.contract.invoiceSetup))) {
							confirmMessage = "This company is under a PEO Host. Are you sure you want to change the invoice setup?";
						}
						if (confirmMessage) {
							$scope.$parent.$parent.$parent.$parent.confirmDialog(confirmMessage, 'info', function () {
								saveCompany();
							});
						} else {
							saveCompany();
						}


					}
					var saveCompany = function () {
						companyRepository.saveCompany($scope.selectedCompany).then(function (result) {

							if (!$scope.isPopup) {
								$scope.$parent.$parent.save(result);
								$scope.tab = 2;
							} else {
								$scope.$parent.save(result);
							}
							$rootScope.$broadcast('companyUpdated', { company: result });
						}, function (error) {
							addAlert(error.statusText, 'danger');
						});
					}
					var ready = function () {
						
						if ($scope.selectedCompany.contract.billingOption === 3 && !$scope.selectedCompany.contract.invoiceSetup) {
							$scope.selectedCompany.contract.invoiceSetup = {
								invoiceType: 1,
								invoiceStyle: 1,
								adminFeeMethod: $scope.selectedCompany.contract.method ? $scope.selectedCompany.contract.method : 1,
								adminFee: $scope.selectedCompany.contract.invoiceCharge ? $scope.selectedCompany.contract.invoiceCharge : 0,
								suiManagement: $scope.mainData.selectedHost.isPeoHost ? 1 : 0,
								applyWCCharge: true,
								applyStatuaryLimits: !$scope.mainData.selectedHost.isPeoHost,
								applyEnvironmentalFee: $scope.mainData.selectedHost.isPeoHost,
								printClientName: false,
								recurringCharges: [],
								notSaved: true
							}
						}

						$scope.selectedCompany.sourceTypeId = dataSvc.sourceTypeId;
						if ($scope.showControls) {
							$timeout(function () {
								$("#wizard").bwizard({
									validating: function (e, ui) {
										if (ui.index == 0) {
											// step-1 validation
											if (false === $('form[name="form-wizard"]').parsley().validate('wizard-step-1') || false === validateStep1()) {
												return false;
											}
										} else if (ui.index == 1) {
											// step-2 validation
											if (false === $('form[name="form-wizard"]').parsley().validate('wizard-step-2') || false === validateStep2()) {
												return false;
											}
										} else if (ui.index == 2) {
											// step-3 validation
											if (false === $('form[name="form-wizard"]').parsley().validate('wizard-step-3') || false === validateStep3()) {
												return false;
											}
										} else if (ui.index == 3) {
											// step-3 validation
											if (false === $('form[name="form-wizard"]').parsley().validate('wizard-step-4') || false === validateStep4()) {
												return false;
											}
										} else
											return true;
									}
								});
							});
						} else {
							$timeout(function () {
								$("#wizard").bwizard();
							});
						}



						$scope.tab = 1;
					}
					
					$scope.addSalesRep = function () {

						$scope.selectedCompany.contract.invoiceSetup.salesRep = {
							user: null,
							method: 1,
							rate: 25
						};
					}
					
					var init = function () {
						if ($scope.selectedCompany.contract.contractOption === 2 && $scope.selectedCompany.contract.billingOption===3)
							$scope.selectedCompany.contract.invoiceSetup.adminFeeThreshold = $scope.selectedCompany.contract.invoiceSetup.adminFeeThreshold ? $scope.selectedCompany.contract.invoiceSetup.adminFeeThreshold : 35;
						$scope.original = angular.copy($scope.selectedCompany);
						companyRepository.getCompanyMetaData().then(function (data) {
							dataSvc.companyMetaData = data;
							ready();
						}, function (error) {
							addAlert('error getting company meta data', 'danger');
						});



					}
					init();


				}]
		}
	}
]);
