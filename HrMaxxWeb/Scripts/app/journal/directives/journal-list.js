'use strict';

common.directive('journalList', ['zionAPI', '$timeout', '$window','version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/journal-list.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'NgTableParams', 'EntityTypes', 'journalRepository', 'payrollRepository',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, journalRepository, payrollRepository) {
					var dataSvc = {
						isBodyOpen: true,
						
						companyAccounts: [],
						bankAccounts: [],
						payees: [],
						startingCheckNumber: 0,
						startingAdjustmentNumber: 0,
						selectedAccount: null,
						selectedTransactionType: 0,
						selectedAccountBalance: 0,
						selectedCheckBalance: 0,
						reportFilter: {
							filterStartDate: moment().add(-2, 'week').toDate(),
							filterEndDate: null,
							filter: {
								startDate: moment().add(-2, 'week').toDate(),
								endDate: null,
								years: [],
								month: 0,
								year: 0,
								quarter: 0
							}
						}

					}
					
					$scope.list = [];
					$scope.newItem = null;
					$scope.dt = new Date();
					
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;


					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					
					$scope.selected = null;
				
					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						sorting: {
							transactionDate: 'desc'     // initial sorting
						}
					}, {
						total: $scope.list ? $scope.list.length : 0, // length of data
						getData: function (params) {
							$scope.fillTableData(params);
							return $scope.tableData;
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
						dataSvc.isBodyOpen = true;
					}
					
					$scope.set = function(item) {
						$scope.selected = null;
						$timeout(function() {
							$scope.selected = angular.copy(item);
							if ($scope.selected.transactionType > 1) {
								$scope.selected.paymentMethod = $scope.selected.paymentMethod === 2;
								$.each($scope.selected.journalDetails, function (index, jd) {
									if ($scope.selected.transactionType === 4 || !jd.account && jd.accountId) {
										var account = $filter('filter')(dataSvc.companyAccounts, { id: jd.accountId })[0];
										if (account) {
											jd.account = account;
										}
									}
								});

								var jd = $filter('filter')($scope.selected.journalDetails, { accountId: dataSvc.selectedAccount.id })[0];
								if (jd) {
									dataSvc.selectedCheckBalance = jd.isDebit ? jd.amount : jd.amount * -1;
								}
							}

							dataSvc.isBodyOpen = false;
						}, 1);
						

					}
					$scope.markPrinted = function (listitem) {
						payrollRepository.printPayCheck(listitem.documentId, listitem.payrollPayCheckId).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
							
							payrollRepository.markPayCheckPrinted(listitem.payrollPayCheckId).then(function () {
									
								}, function (error) {
									addAlert('error marking pay check as printed', 'danger');
								});
							


						}, function (error) {
							addAlert('error printing pay check', 'danger');
						});
					}
					$scope.printJournal = function (journal) {
						journalRepository.printCheck(journal).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
						}, function (error) {
							addAlert('error printing check', 'danger');
						});
					}
					$scope.void = function () {
						if ($window.confirm('Are you sure you want to mark this check Void?')) {
							var check = $scope.selected;
							
							if (check.transactionType > 1) {
								journalRepository.voidCheck(check).then(function(data) {
									var exists = $filter('filter')($scope.list, { id: data.id })[0];
									if (exists) {
										$scope.list.splice($scope.list.indexOf(exists), 1);
									}
									var jd = $filter('filter')(data.journalDetails, { accountId: dataSvc.selectedAccount.id })[0];
									if (jd) {
										dataSvc.selectedAccountBalance -= (jd.isDebit ? jd.amount * -1 : jd.amount);
									}

									$scope.list.push(data);
									$scope.tableParams.reload();
									$scope.fillTableData($scope.tableParams);
									addAlert('successfully voided checkbook item', 'success');
									$scope.cancel();
								}, function(erorr) {
									addAlert('error making the check void', 'danger');
								});
							}
						}
					}
					$scope.save = function () {
						var check = $scope.selected;

						if (check.transactionType > 1) {
							check.paymentMethod = check.paymentMethod ? 2 : 1;
							check.transactionDate = moment(check.transactionDate).format("MM/DD/YYYY");
							journalRepository.saveCheck(check).then(function (data) {
								if ((check.transactionType === 2 || check.transactionType === 3) && data.paymentMethod === 1 && data.checkNumber >= dataSvc.startingCheckNumber) {
									dataSvc.startingCheckNumber = data.checkNumber + 1;
								}
								if (data.transactionType === 4 && data.checkNumber >= dataSvc.startingAdjustmentNumber) {
									dataSvc.startingAdjustmentNumber = data.checkNumber + 1;
								}
								if (check.transactionType === 2 || check.transactionType===3) {
									addPayeeToVendorCustomers(data);
								}
								
								var exists = $filter('filter')($scope.list, { id: data.id })[0];
								if (exists) {
									$scope.list.splice($scope.list.indexOf(exists), 1);
									
								} 

								$scope.list.push(data);
								
								var jd = $filter('filter')(data.journalDetails, { accountId: dataSvc.selectedAccount.id })[0];
								if (jd) {
									dataSvc.selectedAccountBalance += dataSvc.selectedCheckBalance + (jd.isDebit ? jd.amount * -1 : jd.amount);
								}
								
								$scope.tableParams.reload();
								$scope.fillTableData($scope.tableParams);
								addAlert('successfully saved checkbook item', 'success');
								$scope.cancel();
								$scope.set(data);
							}, function (erorr) {
								addAlert('error saving checkbook item', 'danger');
							});
						}
					}
					var translatePayeeType = function(type) {
						if (type === EntityTypes.Company)
							return 'Company';
						else if (type === EntityTypes.Employee)
							return 'Employee';
						else if (type === EntityTypes.Vendor)
							return 'Vendor';
						else if (type === EntityTypes.Customer)
							return 'Customer';
						else {
							return '';
						}
					}
					var addPayeeToVendorCustomers = function (j) {
						if (j.transactionType === 2) {
							var payee = {
								id: j.payeeId,
								payeeName: j.payeeName,
								payeeType: j.entityType,
								displayName: translatePayeeType(j.entityType) + ': ' + j.payeeName
							};
							var exists = $filter('filter')(dataSvc.payees, { id: payee.id })[0];
							if (!exists) {
								dataSvc.payees.push(payee);
							}
						}
						else if (j.transactionType === 3) {
							$.each(j.journalDetails, function (i, jd) {
								if (jd.payee && jd.payee.id) {
									var exists = $filter('filter')(dataSvc.payees, { id: jd.payee.id })[0];
									if (!exists) {
										dataSvc.payees.push(payee);
									}
								}
							});
							
						}
						
						
					}
					
					var getJournals = function (companyId, accountId, startDate, endDate) {
						journalRepository.getJournalList(companyId, accountId, startDate, endDate).then(function (data) {
							dataSvc.selectedAccountBalance = data.accountBalance;
							$scope.list = data.journals;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							
						}, function (error) {
							addAlert('error getting journal list', 'danger');
						});
					}
					$scope.getJournalList = function () {
						if (dataSvc.selectedAccount) {
							var m = $scope.mainData;
							journalRepository.getJournalList(m.selectedCompany.id, dataSvc.selectedAccount.id, dataSvc.reportFilter.filterStartDate, dataSvc.reportFilter.filterEndDate).then(function (data) {
								dataSvc.selectedAccountBalance = data.accountBalance;
								$scope.list = data.journals;
								$scope.tableParams.reload();
								$scope.fillTableData($scope.tableParams);

							}, function (error) {
								addAlert('error getting journal list', 'danger');
							});
						}
						
					}
					var getMetaData = function (companyId) {
						journalRepository.getJournalMetaData(companyId, $scope.mainData.selectedCompany.companyIntId).then(function (data) {
							dataSvc.companyAccounts = data.accounts;
							var bankAccounts = $filter('filter')(dataSvc.companyAccounts, { isBank: true });
							dataSvc.bankAccounts = $filter('orderBy')(bankAccounts, 'userInPayroll', true );
							dataSvc.payees = data.payees;
							dataSvc.startingCheckNumber = data.startingCheckNumber;
							dataSvc.startingAdjustmentNumber = data.startingAdjustmentNumber;
							if (dataSvc.bankAccounts.length > 0) {
								dataSvc.selectedAccount = dataSvc.bankAccounts[0];
								$scope.accountSelected();
							}
						}, function (erorr) {
							addAlert('error getting journal meta data ' + erorr, 'danger');
						});
					}

					$scope.accountSelected = function() {
						//getJournals($scope.mainData.selectedCompany.id, dataSvc.selectedAccount.id, null, null);
						$scope.getJournalList();
					}

					$scope.$watch('mainData.selectedCompany',
						 function (newValue, oldValue) {
						 	if (newValue !== oldValue && $scope.mainData.selectedCompany) {
						 		dataSvc.selectedAccount = null;
						 		dataSvc.selectedAccountBalance = 0;
								 $scope.selected = null;
						 		getMetaData($scope.mainData.selectedCompany.id);
								 dataSvc.isBodyOpen = true;
							 }

						 }, true
				 );
					$scope.add = function(transactionType, paymentMethod) {
						var newItem = {
							id : 0,
							companyId: $scope.mainData.selectedCompany.id,
							companyIntId: $scope.mainData.selectedCompany.companyIntId,
							transactionType: transactionType,
							paymentMethod : paymentMethod,
							checkNumber : paymentMethod? -1 :dataSvc.startingCheckNumber,
							payrollPayCheckId : null,
							entityType : null,
							payeeId : null,
							payeeName : '',
							amount : 0,
							mainAccountId : dataSvc.selectedAccount.id,
							transactionDate : new Date(),
							memo : '',
							isDebit : transactionType===3? false : true,
							isVoid : false,
							journalDetails : []
						};
						if (transactionType === 3) {
							newItem.checkNumber = -1;
							newItem.entityType = EntityTypes.Deposit;
							newItem.payeeName = '';
						}
						$scope.selected = newItem;
						dataSvc.isBodyOpen = false;
					}
					$scope.refresh = function() {
						//getJournals($scope.mainData.selectedCompany.id, dataSvc.selectedAccount.id, null, null);
						$scope.getJournalList();
						dataSvc.isBodyOpen = !dataSvc.isBodyOpen;
					}
					var init = function () {
						
						if ($scope.mainData.selectedCompany) {
							getMetaData($scope.mainData.selectedCompany.id);
						}
						

					}
					init();


				}]
		}
	}
]);
