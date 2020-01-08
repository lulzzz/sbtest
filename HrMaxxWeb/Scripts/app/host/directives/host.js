'use strict';

common.directive('host', ['zionAPI','localStorageService','version',
	function (zionAPI, localStorageService, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				host: "=data",
				sourceTypeId: "=sourceTypeId",
				sourceId: "=sourceId",
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Administration/templates/host.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'ClaimTypes', function ($scope, $element, $location, $filter, companyRepository, ClaimTypes) {
				$scope.data1 = {
					
				};
				var dataSvc = {
					companyMetaData: null,
					viewContract: $scope.mainData.hasClaim(ClaimTypes.HostContract, 1),
					disableIsPEO: !$scope.mainData.hasClaim(ClaimTypes.HostPEOFlag, 1),
				}
				$scope.data2 = dataSvc;
				$scope.selectedCompany = null;
				$scope.dt = new Date();
				$scope.host.effectiveDate = moment($scope.host.effectiveDate).toDate();
				if ($scope.host.terminationDate)
					$scope.host.terminationDate = moment($scope.host.terminationDate).toDate();

				
				$scope.validate = function () {
					return validateStep1() && validateStep2() && validateStep3() && validateStep4() && validateStep5();
				}
				var validateStep1 = function () {
					
					return true;
					
				}
				var validateStep2 = function () {
					var c = $scope.selectedCompany;
					if (!c)
						return false;
					if (!c.name)
						return false;
					else if (!c.companyAddress.addressLine1 || !c.companyAddress.countryId || !c.companyAddress.stateId || !c.companyAddress.zip)
						return false;
					else {
						return true;
					}
				}
				var validateStep3 = function () {
					var c = $scope.selectedCompany;
					if (!c)
						return false;
					if (c.payrollDaysInPast === null)
						return false;
					else
						return true;
				}
				var validateStep4 = function () {
					var c = $scope.selectedCompany;
					var returnVal = true;
					if (!c)
						return false;
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
							if (!state1.state.stateId || !state1.stateEIN || !state1.statePIN) {
								returnVal = false;
								return false;
							}

						});
					}
					return returnVal;
				}
				var validateStep5 = function () {
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
					//if (c.contractOption === 2 && c.billingOption === 3) {
					//	var i = c.invoiceSetup;
					//	if (!i)
					//		return false;
					//	if (i.recurringCharges.length > 0) {
					//		var invalidrc = false;
					//		$.each(i.recurringCharges, function (index, rc) {
					//			if (!rc.description || !rc.amount) {
					//				invalidrc = true;
					//				return false;
					//			}
					//		});
					//		if (invalidrc)
					//			return false;
					//	}
					//}
					return true;

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
					if (dataSvc.companyMetaData && dataSvc.companyMetaData.countries.length>0) {
						$.each(dataSvc.companyMetaData.countries[0].states, function (index, state1) {
							var statematch = $filter('filter')($scope.selectedCompany.states, { state: { stateId: state1.stateId } });
							if (statematch.length === 0) {
								states.push(state1);
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
						return cst.taxesEnabled;
					} else {
						return false;
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

				}
				var setCompany = function() {
					if (!$scope.host.company) {
						var selectedCompany = {
							name: $scope.host.firmName,
							hostId: $scope.host.id,
							statusId: 1,
							isAddressSame: true,
							isVisibleToHost: true,
							fileUnderHost: true,
							isHostCompany: true,
							minWage: 10,
							payrollDaysInPast: 0,
							companyAddress: {},
							states: [],
							companyTaxRates: [],
							contract: {
								contractOption: 1,
								prePaidSubscriptionOption: null,
								billingOption: 3,
								creditCardDetails: null,
								bankDetails: null,
								invoiceCharge: 0
							}
						};
						selectedCompany.businessAddress = selectedCompany.companyAddress;
						$.each(dataSvc.companyMetaData.taxes, function(index, taxyearrate) {
							selectedCompany.companyTaxRates.push({
								id: 0,
								taxId: taxyearrate.tax.id,
								companyId: null,
								taxCode: taxyearrate.tax.code,
								taxYear: taxyearrate.taxYear,
								rate: taxyearrate.rate
							});
						});
						$scope.host.company = selectedCompany;
					}

					$scope.selectedCompany = $scope.host.company;

					$("#wizard").bwizard({
						validating: function (e, ui) {
							if (ui.index == 0) {
								// step-1 validation
								if (false === $('form[name="hostForm"]').parsley().validate('wizard-step-1') || false === validateStep1()) {
									return false;
								}
							} else if (ui.index == 1) {
								// step-2 validation
								if (false === $('form[name="hostForm"]').parsley().validate('wizard-step-2') || false === validateStep2()) {
									return false;
								}
							} else if (ui.index == 2) {
								// step-3 validation
								if (false === $('form[name="hostForm"]').parsley().validate('wizard-step-3') || false === validateStep3()) {
									return false;
								}
							} else if (ui.index == 3) {
								// step-4 validation
								if (false === $('form[name="hostForm"]').parsley().validate('wizard-step-4') || false === validateStep4()) {
									return false;
								}
							} else if (ui.index == 4) {
								// step-4 validation
								if (false === $('form[name="hostForm"]').parsley().validate('wizard-step-5') || false === validateStep5()) {
									return false;
								}
							}
							else
								return true;
						}
					});
				}

				$scope.save = function () {
					if (false === $('form[name="hostForm"]').parsley().validate())
						return false;
					$scope.$parent.$parent.save();
				}
				$scope.cancel = function() {
					$scope.$parent.$parent.cancel();
				}
				var _init = function () {
					companyRepository.getCompanyMetaData().then(function (data) {
						dataSvc.companyMetaData = data;
						setCompany();
					}, function (error) {
						$scope.mainData.showMessage('error getting company meta data', 'danger');
					});
					
					
				}
				_init();

			}]
		}
	}
]);
