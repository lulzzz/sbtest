'use strict';

common.directive('employee', ['zionAPI', '$timeout', '$window', 'version', '$uibModal',
	function (zionAPI, $timeout, $window, version, $modal) {
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

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'payrollRepository', 'EntityTypes', 'reportRepository', 'ClaimTypes',
				function ($scope, $element, $location, $filter, companyRepository, payrollRepository, EntityTypes, reportRepository, ClaimTypes) {
					var dataSvc = {
						tab: 1,
						payCodes: [],
						companyStates: [],
						compensations: [],
						employeeMetaData: null,
						sourceTypeId: EntityTypes.Employee,
						openedRack: 1,
						filter: {
							years: []
						},
						filterW2: {
							year: 0,
							includeHistory: true,
							includeTaxDelayed: false
						},
						filterC1095: {
							year: 0,
							includeHistory: true, includeTaxDelayed: false
						},
						payrollSummary: {
							year: 0,
							includeHistory: true, includeTaxDelayed: true
						},
						viewVersions: $scope.mainData.hasClaim(ClaimTypes.EmployeeVersions, 1),
						viewReports: $scope.mainData.hasClaim(ClaimTypes.EmployeeReports, 1),
						editableDeductions: $scope.mainData.hasClaim(ClaimTypes.EmployeeDeductions, 1),
						editableAccumulations: $scope.mainData.hasClaim(ClaimTypes.EmployeeEditableAccumulatatedPayTypes, 1),
						showSSN: $scope.mainData.hasClaim(ClaimTypes.EmployeeManageEmployees, 1),
						showSickLeaveExport: $scope.mainData.hasClaim(ClaimTypes.EmployeeSickLeaveExport, 1),
						showSickLeaveRecalculate: $scope.mainData.hasClaim(ClaimTypes.RecalculateSickLeave,1)
				}
					$scope.showincludeclients = false;
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
					$scope.getCompanySickLeaveExport = function(mode) {
						$scope.$parent.$parent.getCompanySickLeaveExport(mode);
					}
					$scope.recalculateEmployeePayTypeAccumulations = function (mode) {
						payrollRepository.recalculateEmployeePayTypeAccumulations($scope.selected.id).then(function (result) {
							$scope.$parent.$parent.save(result);
						}, function (error) {
							$scope.addAlert('error re-calculating employee accumulations', 'danger');
						});
					}

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
						if ($scope.selected.payType === 1) {
							$scope.selected.rate = 0;
							$scope.selected.payCodes = [];
							$scope.selectedPayCodes = [];
						}
						else if ($scope.selected.payType == 3) {
							$scope.selected.payCodes = [];
							$scope.selectedPayCodes = [];
							$scope.selected.rate = 0;
							$scope.selected.payCodes.push({
								id: -1,
								companyId: $scope.selected.companyId,
								code: 'PieceRate',
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
						if (!c.ssn || !c.hireDate || !c.statusId || !c.sickLeaveHireDate)
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
					$scope.showAccruals = function() {
						var exists = $filter('filter')($scope.mainData.selectedCompany.accumulatedPayTypes, { isEmployeeSpecific: true });
						return exists.length > 0;
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
					$scope.accrualEvents = {
						onItemSelect: function (item) {
							$scope.selected.payTypeAccruals.push(item.id);
						},
						onItemDeselect: function (item) {
							$scope.selected.payTypeAccruals.splice($scope.selected.payTypeAccruals.indexOf(item.id), 1);
						},
						onDeselectAll: function () {
							$scope.selected.payTypeAccruals = [];
						}
					};
					$scope.updateDeductionList = function(list) {
						$scope.$parent.$parent.updateDeductionList(list);
					}
					$scope.setSelectedAccumulation = function(pt, index) {
						pt.employeeId = $scope.selected.id;
						pt.newFiscalStart = moment(pt.newFiscalStart).toDate();
						pt.newFiscalEnd = moment(pt.newFiscalEnd).toDate();
						pt.oldCarryOver = angular.copy(pt.carryOver);
						$scope.selectedAccumulation = pt;
						$scope.selectedAccumulationIndex = index;
					}
					$scope.cancelAccumulation = function(pt) {
						pt.carryOver = angular.copy(pt.oldCarryOver);
						$scope.selectedAccumulation = null;
						$scope.selectedAccumulationIndex = null;
					}
					$scope.saveEmployeeAccumulation = function (pt) {
						pt.fiscalStart = moment(pt.fiscalStart).format("MM/DD/YYYY");
						pt.fiscalEnd = moment(pt.fiscalEnd).format("MM/DD/YYYY");
						pt.newFiscalStart = moment(pt.newFiscalStart).format("MM/DD/YYYY");
						pt.newFiscalEnd = moment(pt.newFiscalEnd).format("MM/DD/YYYY");
						payrollRepository.saveEmployeeAccumulation(pt).then(function (result) {
							pt.fiscalStart = result.fiscalStart;
							pt.fiscalEnd = result.fiscalEnd;
							pt.available = result.available;
							$scope.selectedAccumulation = null;
							$scope.selectedAccumulationIndex = null;
						}, function (error) {
							$scope.addAlert('error saving employee accumultion', 'danger');
						});
					}
					$scope.save = function () {
						if (false === $('form[name="employee"]').parsley().validate())
							return false;
						if ($scope.selected.payType === 1 || $scope.selected.payType===3) {
							var baseRatePC = $filter('filter')($scope.selected.payCodes, { id: 0 })[0];
							if (baseRatePC)
								baseRatePC.hourlyRate = $scope.selected.rate;
							else {
								$scope.selected.payCodes.push({
									id: 0,
									companyId: $scope.selected.companyId,
									code: 'Base Rate',
									description: 'Base Rate',
									hourlyRate: $scope.selected.rate
								});
							}
						}
						if ($scope.selected.paymentMethod === 1) {
							$scope.selected.bankAccounts = [];
						}
						if ($scope.selected.sickLeaveHireDate !== $scope.original.sickLeaveHireDate) {
							$scope.$parent.$parent.$parent.$parent.confirmDialog('Changing sick leave hire date would require you to update the Sick Leave accumulations for existing Pay Checks manually.\n' +
								'do you want to proceed?', 'danger', function () {
									saveEmpployee();
								}
							);
						} else {
							saveEmpployee();
						}
						
						
					}
					$scope.checkSSN = function () {
						companyRepository.checkSSN($scope.selected.ssn).then(function (data) {
							var modalInstance = $modal.open({
								templateUrl: 'popover/ssnlist.html',
								controller: 'ssnListCtrl',
								size: 'lg',
								windowClass: 'my-modal-popup',
								resolve: {
									list: function () {
										return data;
									},
									modal: function() {
										return $modal;
									}
								}
							});
						}, function (erorr) {
							addAlert('error checking for ssn existance', 'danger');
						});
					}
					var saveEmpployee = function () {
						$scope.selected.hireDate = moment($scope.selected.hireDate).format("MM/DD/YYYY");
						$scope.selected.sickLeaveHireDate = moment($scope.selected.sickLeaveHireDate).format("MM/DD/YYYY");
						companyRepository.saveEmployee($scope.selected).then(function (result) {
							if (!$scope.isPopup)
								$scope.$parent.$parent.save(result);
							else
								$scope.$parent.save(result);
						}, function (error) {
							$scope.addAlert('error saving employee', 'danger');
						});
					}
					$scope.calculateAvailableWage = function (paytype) {
						if (paytype) {
							
								var accumulated = 0;
								var hrs = paytype.available;
								if ($scope.selected.payType === 1 || $scope.selected.payType === 3) {
									return hrs * $scope.selected.rate;
								}
								else if ($scope.selected.payType === 2) {
									var rate = $scope.selected.rate;
									var schedule = $scope.selected.payrollSchedule;
									var quotient = schedule === 1 ? 52 : schedule === 2 ? 26 : schedule === 3 ? 24 : 12;
									return hrs * rate * (quotient / (40 * 52));
								}
								
							
						}


					}

					var init = function () {
						var currentYear = new Date().getFullYear();
						for (var i = currentYear - 4; i <= currentYear; i++) {
							if (i >= 2017)
								dataSvc.filter.years.push(i);
						}
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
							$scope.selectedAccruals = [];
							$scope.selectedPayTypes = [];
							dataSvc.companyStates = [];
							dataSvc.accrualPayTypes = [];
							$.each($scope.mainData.selectedCompany.states, function (index, st) {
								dataSvc.companyStates.push(st.state);
							});
							$.each($scope.mainData.selectedCompany.accumulatedPayTypes, function (index, at) {
								if (at.isEmployeeSpecific)
									dataSvc.accrualPayTypes.push(at.payType);
							});
						}
						
						$timeout(function () {
							$scope.original = angular.copy($scope.selected);
							if ($scope.selected.birthDate)
								$scope.selected.birthDate = moment($scope.selected.birthDate).toDate();
							$scope.selected.hireDate = moment($scope.selected.hireDate).toDate();

							$scope.selected.sickLeaveHireDate = moment($scope.selected.sickLeaveHireDate).toDate();
							$.each($scope.selected.payCodes, function (index, pc) {
								if (pc.id > 0)
									$scope.selectedPayCodes.push({ id: pc.id });
							});
							$.each($scope.selected.payTypeAccruals, function (index, ac) {
								if (ac > 0)
									$scope.selectedAccruals.push({ id: ac });
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

					$scope.fixEmployeeYTD = function () {
						payrollRepository.fixEmployeeYTD($scope.selected.id).then(function (data) {
							
							$scope.addAlert('successfully updated YTDs', 'success');
						}, function (error) {
							
							$scope.addAlert('error getting report payroll summary report ' + error.statusText, 'danger');
						});
					}
					$scope.getReportW2Employee = function () {
						getReport('W2Employee', 'Federal W2 (Employee version)', dataSvc.filterW2.year, null, dataSvc.filterW2.includeHistory, dataSvc.filterW2.includeTaxDelayed);
					}
					$scope.getReportW2Employer = function () {
						getReport('W2Employer', 'Federal W2 (Employer version)', dataSvc.filterW2.year, null, dataSvc.filterW2.includeHistory, dataSvc.filterW2.includeTaxDelayed);
					}
					$scope.getReportC1095 = function () {
						getReport('C1095', 'Federal 1095-C', dataSvc.filterC1095.year, null, dataSvc.filterC1095.includeHistory, dataSvc.filterC1095.includeTaxDelayed);
					}
					$scope.getReportPayrollSummary = function () {
						//getReport('PayrollSummary', 'Payroll Summary', dataSvc.payrollSummary.year, null, dataSvc.payrollSummary.includeHistory);
						var m = $scope.mainData;
						var request = {
							reportName: 'PayrollSummary',
							hostId: m.selectedHost.id,
							companyId: m.selectedCompany.id,
							employeeId: $scope.selected.id,
							year: dataSvc.payrollSummary.year,
							quarter: null,
							month: null,
							startDate: moment('01/01/' + dataSvc.payrollSummary.year).format('MM/DD/YYYY'),
							endDate: moment('12/31/' + dataSvc.payrollSummary.year).format('MM/DD/YYYY'),
							includeHistory: dataSvc.payrollSummary.includeHistory,
							includeClients: true,
							includeTaxDelayed: dataSvc.payrollSummary.includeTaxDelayed
						}
						reportRepository.getReport(request).then(function (data) {
							dataSvc.payrollSummaryReport = data;

						}, function (error) {
							dataSvc.payrollSummaryReport = null;
							$scope.addAlert('error getting report payroll summary report ' + error.statusText, 'danger');
						});
					}
					var getReport = function (reportName, desc, year, quarter, includeHistory, includeTaxDelayed) {
						var m = $scope.mainData;
						var request = {
							reportName: reportName,
							hostId: m.selectedHost.id,
							companyId: m.selectedCompany.id,
							employeeId: $scope.selected.id,
							year: year,
							quarter: quarter,
							month: null,
							startDate: null,
							endDate: null,
							includeHistory: includeHistory,
							includeClients: true,
							includeTaxDelayed: includeTaxDelayed
						}
						reportRepository.getReportDocument(request).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();

						}, function (erorr) {
							$scope.addAlert('Error getting report ' + desc + ': ' + erorr, 'danger');
						});
					}


					init();


				}]
		}
	}
]);
common.controller('ssnListCtrl', function ($scope, $uibModalInstance, list) {
	$scope.list = list;
	
	$scope.cancel = function () {
		$uibModalInstance.close($scope);
	};
	
	
});
