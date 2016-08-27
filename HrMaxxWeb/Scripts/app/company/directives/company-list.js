'use strict';

common.directive('companyList', ['$modal', 'zionAPI', '$timeout', '$window',
	function ($modal, zionAPI, $timeout, $window) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				heading: "=heading",
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/company-list.html',

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'ngTableParams', 'EntityTypes', 'hostRepository',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, hostRepository) {
					var dataSvc = {
					hostList: [],
					selectedHost: null,
					selectedHostId: $scope.host ? $scope.host.id : null,
					sourceTypeId: EntityTypes.Company,
					companyMetaData: null,
					isBodyOpen: true
				}

					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = false;
					

				var addAlert = function (error, type) {
					$scope.$parent.$parent.addAlert(error, type);
				};
				
				$scope.selectedCompany = null;
			
					
				$scope.addCompany = function () {
					var selectedCompany = {
						hostId: $scope.mainData.selectedHost.id,
						statusId: 1,
						isAddressSame: true,
						isVisibleToHost: true,
						fileUnderHost: true,
						payrollDaysInPast: 0,
						companyAddress: {},
						states: [],
						companyTaxRates:[],
						contract: {
							contractOption: 2,
							prePaidSubscriptionOption: null,
							billingOption: 3,
							creditCardDetails: null,
							bankDetails: null,
							invoiceCharge:0
						}
					};
					selectedCompany.businessAddress = selectedCompany.companyAddress;
					$.each(dataSvc.companyMetaData.taxes, function (index, taxyearrate) {
						selectedCompany.companyTaxRates.push({
							id: 0,
							taxId: taxyearrate.tax.id,
							companyId: null,
							taxCode: taxyearrate.tax.code,
							taxYear: taxyearrate.taxYear,
							rate: taxyearrate.rate
						});
					});
					$scope.setCompany(selectedCompany);
				}
				
				$scope.tableData = [];
				$scope.tableParams = new ngTableParams({
					page: 1,            // show first page
					count: 10,

					filter: {
						name: '',       // initial filter
					},
					sorting: {
						name: 'asc'     // initial sorting
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
					$scope.selectedCompany = null;
					$scope.data.isBodyOpen = true;
				}
				
				$scope.setCompany = function (item) {
					$scope.selectedCompany = null;
					$timeout(function () {
						$scope.selectedCompany = angular.copy(item);
						$scope.selectedCompany.sourceTypeId = dataSvc.sourceTypeId;
						$scope.data.isBodyOpen = false;
						$scope.mainData.selectedCompany = item;
						$timeout(function() {
							$("#wizard").bwizard({validating: function(e, ui) {
								if (ui.index == 0) {
									// step-1 validation
									if (false === $('form[name="form-wizard"]').parsley().validate('wizard-step-1') || false === validateStep1()) {
										return false;
									}
								} else if (ui.index == 1) {
									// step-2 validation
									if (false === $('form[name="form-wizard"]').parsley().validate('wizard-step-2') || false===validateStep2()) {
										return false;
									}
								} else if (ui.index == 2) {
									// step-3 validation
									if (false === $('form[name="form-wizard"]').parsley().validate('wizard-step-3') || false===validateStep3()) {
										return false;
									}
								} else if (ui.index == 3) {
									// step-3 validation
									if (false === $('form[name="form-wizard"]').parsley().validate('wizard-step-4') || false === validateStep4()) {
										return false;
									}
								}
								else
									return true;
							}
						});
						});
					}, 1);
					
					
				}
				
				$scope.LinkCompanyAndBusinessAddress = function() {
					if ($scope.selectedCompany.isAddressSame) {
						$scope.selectedCompany.taxFilingName = $scope.selectedCompany.name;
						$scope.selectedCompany.businessAddress = $scope.selectedCompany.companyAddress;
					} else {
						$scope.selectedCompany.businessAddress = angular.copy($scope.selectedCompany.companyAddress);
					}

				}
				$scope.namechanged = function() {
					if ($scope.selectedCompany.isAddressSame) {
						$scope.selectedCompany.taxFilingName = $scope.selectedCompany.name;
					}
				}
				$scope.availableStates = function () {
					var states = [];
					$.each(dataSvc.companyMetaData.countries[0].states, function (index, state1) {
						var statematch = $filter('filter')($scope.selectedCompany.states, { state: { stateId: state1.stateId } });
						if (statematch.length === 0) {
							states.push(state1);
						}
					});
					return states;
				}
				$scope.addState = function() {
					$scope.selectedCompany.states.push({
						state: {},
						stateEin: '',
						statePin: '',
						isNew:true
					});
				}
				$scope.removeState = function(state) {
					$scope.selectedCompany.states.splice($scope.selectedCompany.states.indexOf(state), 1);
				}

				$scope.isStateAvailable = function() {
					var stateAvailable = false;
					$.each(dataSvc.companyMetaData.countries[0].states, function (index, state1) {
						var statematch = $filter('filter')($scope.selectedCompany.states, { state: { stateId: state1.stateId } });
						if (statematch.length === 0) {
							stateAvailable = true;
						}
					});
					return stateAvailable;
				}
				$scope.validateRoutingNumber = function(rtn) {
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
				$scope.validateCompany = function() {
					return validateStep1() && validateStep2() && validateStep3() && validateStep4();
				}
				var validateStep1 = function() {
					var c = $scope.selectedCompany;
					if (!c.name || !c.companyNo)
						return false;
					else if (!c.companyAddress.addressLine1 || !c.companyAddress.countryId || !c.companyAddress.stateId || !c.companyAddress.zip)
						return false;
					else {
						return true;
					}
				}
				var validateStep2  =function() {
					var c = $scope.selectedCompany;
					if (c.payrollDaysInPast===null)
						return false;
					else
						return true;
				}
				var validateStep3 = function() {
					var c = $scope.selectedCompany;
					var returnVal = true;
					if (!c.isAddressSame && (!c.businessAddress.addressLine1 || !c.businessAddress.countryId || !c.businessAddress.stateId || !c.businessAddress.zip))
						returnVal = false;
					else if(!c.federalEIN || !c.federalPin) {
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
				var validateStep4 = function() {
					var c = $scope.selectedCompany.contract;
					if (!c)
						return false;
					if (c.contractOption === 1 && (!c.billingOption || !c.prePaidSubscriptionOption || (c.prePaidSubscriptionOption>1 && !c.billingOption )))
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
						if (!b || !b.bankName || !b.accountName || !b.accountType || !b.validateRoutingNumber() || !b.routingNumber || !b.accountNumber)
							return false;
					}
					if (c.billingOption === 3 && (!c.invoiceCharge || !c.method))
						return false;
					
					return true;
					
				}
				$scope.billingOptionChanged = function() {
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

				$scope.getRowClass = function(item) {
					if ($scope.selectedCompany && $scope.selectedCompany.id === item.id)
						return 'success';
					else {
						return 'default';
					}
				}
			
				$scope.save = function () {
					if (false === $('form[name="form-wizard"]').parsley().validate())
						return false;
					if ($scope.selectedCompany.contract.billingOption === 0 || $scope.selectedCompany.contract.billingOption === 3) {
						$scope.selectedCompany.contract.creditCardDetails = null;
						$scope.selectedCompany.contract.bankDetails = null;
					}
					else if ($scope.selectedCompany.contract.billingOption === 1) {
						$scope.selectedCompany.contract.bankDetails = null;
					} else {
						$scope.selectedCompany.contract.creditCardDetails = null;
						if ($scope.selectedCompany.contract.bankDetails) {
							$scope.selectedCompany.contract.bankDetails.sourceTypeId = $scope.sourceTypeId;
							$scope.selectedCompany.contract.bankDetails.sourceId = $scope.selectedCompany.id;
						}
					}
					if ($scope.selectedCompany.contract.contractOption === 1) {
						$scope.selectedCompany.contract.invoiceCharge = 0;
					}
					companyRepository.saveCompany($scope.selectedCompany).then(function (result) {
						
						var exists = $filter('filter')($scope.list, { id:result.id });
						if (exists.length === 0) {
							$scope.list.push(result);
						} else {
							$scope.list.splice($scope.list.indexOf(exists[0]), 1);
							$scope.list.push(result);
						}
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						$scope.selectedCompany = null;
						$scope.data.isBodyOpen = true;
						addAlert('successfully saved Company', 'success');
					}, function (error) {
						addAlert('error saving Company', 'danger');
					});
				}
				//$scope.getCompanies = function(hostId) {
				//	companyRepository.getCompanyList(hostId).then(function (data) {
				//		$scope.list = data;
				//		$scope.tableParams.reload();
				//		$scope.fillTableData($scope.tableParams);
				//		if ($scope.companyId) {
				//			var selected = $filter('filter')($scope.list, { id: $scope.companyId });
				//			if (selected.length > 0) {
				//				$scope.setCompany(selected[0]);
				//			}
				//		}
				//	}, function (erorr) {
				//		addAlert('error getting company list', 'danger');
				//	});
				//}
			
				$scope.$watch('mainData.companies.length',
					 function (newValue, oldValue) {
					 	if (newValue !== oldValue) {
							 $scope.list = $scope.mainData.companies;
			 						$scope.tableParams.reload();
			 						$scope.fillTableData($scope.tableParams);
						 }
			 				
					 }, true
			 );
				var init = function () {
					
					companyRepository.getCompanyMetaData().then(function (data) {
						dataSvc.companyMetaData = data;
					}, function(error)
					{
						addAlert('error getting company meta data', 'danger');
					});
					$scope.list = $scope.mainData.companies;
					var querystring = $location.search();
					if ($scope.mainData.userCompany !== '00000000-0000-0000-0000-000000000000') {
						var exists1 = $filter('filter')($scope.list, { id: $scope.mainData.userCompany }, true)[0];
						if (exists1) {
							$scope.setCompany(exists1);
						}
					}
					else if (querystring.name) {
						var exists = $filter('filter')($scope.list, { name: querystring.name }, true)[0];
						if (exists) {
							$scope.setCompany(exists);
						}
					}
				}
				init();
				

			}]
		}
	}
]);
