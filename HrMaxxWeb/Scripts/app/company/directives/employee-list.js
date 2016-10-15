'use strict';

common.directive('employeeList', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData",
				isVendor: "=isVendor"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/employee-list.html?v='+version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'ngTableParams', 'EntityTypes',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes) {
					var dataSvc = {
						sourceTypeId: EntityTypes.Employee,
						isBodyOpen: true,
						payCodes: [],
						companyStates: [],
						compensations: [],
						employeeMetaData: null
					}
					
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;


					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};

					$scope.onFileSelect = function ($files) {
						$scope.files = [];
						for (var i = 0; i < $files.length; i++) {
							var $file = $files[i];

							var fileReader = new FileReader();
							fileReader.readAsDataURL($files[i]);
							var loadFile = function (fileReader, index) {
								fileReader.onload = function (e) {
									$timeout(function () {
										$scope.files.push({
											doc: {
												file: $files[index],
												file_data: e.target.result,
												uploaded: false
											},
											data: JSON.stringify({
												companyId: $scope.mainData.selectedCompany.id
											}),
											currentProgress: 0,
											completed: false
										});
										uploadDocument();
									});
								}
							}(fileReader, i);
						}
						
					};
					var uploadDocument = function () {
						companyRepository.importEmployees($scope.files[0]).then(function (employees) {
							$.each(employees, function(ind, emp) {
								$scope.list.push(emp);
							});
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							$scope.selected = null;
							addAlert('successfully imported ' + employees.length + 'employees', 'success');
						}, function (error) {
							addAlert('error in importing employees: ' + error, 'danger');

							});

						
					}
					
					$scope.selected = null;
					$scope.files = [];
					$scope.getEmployeeImportTemplate = function() {
						companyRepository.getEmployeeImportTemplate($scope.mainData.selectedCompany.id).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
							
						}, function (error) {
							addAlert('error getting employee import template', 'danger');
						});
					}

					$scope.add = function () {
						var selected = {
							companyId: $scope.mainData.selectedCompany.id,
							statusId: 1,
							contact: {
								isPrimary: true,
								address: {
									countryId: 1,
									stateId:1
								}
							},
							rate:0,
							payCodes:[],
							compensations: [],
							federalAdditionalAmount: 0,
							federalExemptions: 0,
							state: {
								state: dataSvc.companyStates[0],
								exemptions: 0,
								additionalAmount:0
							},
							workerCompensation: $scope.mainData.selectedCompany.workerCompensations.length===1? $scope.mainData.selectedCompany.workerCompensations[0] : null,
							taxCategory: 1,
							payrollSchedule: $scope.mainData.selectedCompany.payrollSchedule,
							paymentMethod: 1

						};
						
						$scope.set(selected);
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
						if ($scope.list && $scope.list.length > 0) {
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
					$scope.cancel = function () {
						$scope.selected = null;
						$scope.data.isBodyOpen = true;
					}

					$scope.set = function (item) {
						$scope.selected = null;
						$scope.selectedPayCodes = [];
						$timeout(function () {
							$scope.selected = angular.copy(item);
							if ($scope.selected.birthDate)
								$scope.selected.birthDate = moment($scope.selected.birthDate).toDate();
							if ($scope.selected.hireDate)
								$scope.selected.hireDate = moment($scope.selected.hireDate).toDate();

							$.each($scope.selected.payCodes, function (index, pc) {
								if(pc.id>0)
								$scope.selectedPayCodes.push({id:pc.id});
							});
							//$scope.selectedstate = $scope.selected.state.state;
							dataSvc.isBodyOpen = false;
							$timeout(function () {
								$("#wizard").bwizard({
									validating: function (e, ui) {
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
						}, 1);

					}
					$scope.payTypeList = function(item) {
						var returnList = $scope.availablePayTypes();
						if(item && item.payType)
							returnList.push(item.payType);
						return returnList;
					}
					$scope.availablePayTypes = function () {
						return $filter('filter')(dataSvc.employeeMetaData.payTypes, {used:0});
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
						else {
							$scope.selected.payCodes = [];
							$scope.selectedPayCodes = [];
						}
					}

					$scope.validate = function () {
						return validateStep1() && validateStep2() && validateStep3();
					}
					var validateStep1 = function () {
						var c = $scope.selected;
						if (!c.gender || !c.ssn || !c.hireDate || !c.statusId)
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
						if (c.payType!==3 && !c.rate)
							return false;
						if (c.paymentMethod === 2) {
							var b = c.bankAccount;
							if (!b || !b.bankName || !b.accountType || !$scope.validateRoutingNumber(b.routingNumber) || !b.routingNumber || !b.accountNumber)
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

							var exists = $filter('filter')($scope.list, { id: result.id });
							if (exists.length === 0) {
								$scope.list.push(result);
							} else {
								$scope.list.splice($scope.list.indexOf(exists[0]), 1);
								$scope.list.push(result);
							}
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							$scope.set(result);
							addAlert('successfully saved employee', 'success');
						}, function (error) {
							addAlert('error saving employee', 'danger');
						});
					}
					$scope.getEmployees = function(companyId) {
						companyRepository.getEmployees(companyId).then(function (data) {
							$scope.list = data;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							$scope.selected = null;
						}, function (erorr) {
							addAlert('error getting employee list', 'danger');
						});
					}

					$scope.$watch('mainData.selectedCompany',
						 function (newValue, oldValue) {
						 	if (newValue !== oldValue) {
						 		dataSvc.payCodes = $scope.mainData.selectedCompany.payCodes;
						 		$scope.selectedPayCodes = [];
						 		$scope.selectedPayTypes = [];
						 		dataSvc.companyStates = [];
						 		$.each($scope.mainData.selectedCompany.states, function (index, st) {
									 dataSvc.companyStates.push(st.state);
								 });
								 $scope.getEmployees($scope.mainData.selectedCompany.id);
							 }

						 }, true
				 );
					var init = function () {
						companyRepository.getEmployeeMetaData().then(function (data) {
							$.each(data.payTypes, function (index, paytype) {
								paytype.used = 0;
							});
							dataSvc.employeeMetaData = data;
						}, function (error) {
							addAlert('error getting employee meta data', 'danger');
						});
						if ($scope.mainData.selectedCompany) {
							dataSvc.payCodes = $scope.mainData.selectedCompany.payCodes;
							$scope.selectedPayCodes = [];
							$scope.selectedPayTypes = [];
							$scope.getEmployees($scope.mainData.selectedCompany.id);
							dataSvc.companyStates = [];
							$.each($scope.mainData.selectedCompany.states, function (index, st) {
								dataSvc.companyStates.push(st.state);
							});
						}
						

					}
					init();


				}]
		}
	}
]);
