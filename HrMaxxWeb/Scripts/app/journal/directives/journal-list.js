'use strict';

common.directive('journalList', ['$modal', 'zionAPI', '$timeout', '$window',
	function ($modal, zionAPI, $timeout, $window) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/journal-list.html',

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'ngTableParams', 'EntityTypes', 'journalRepository',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, journalRepository) {
					var dataSvc = {
						isBodyOpen: true,
						opened: false,
						opened1: false,
						opened2: false,
						companyAccounts: [],
						bankAccounts: [],
						vendors: [],
						customers: [],
						startingCheckNumber: 0,
						startingAdjustmentNumber: 0,
						selectedAccount: null,
						selectedTransactionType: 0,
						selectedAccountBalance: 0,
						selectedCheckBalance: 0,
						filterStartDate: null,
						filterEndDate: null,
						filter: {
							years: [],
							month: 0,
							year:0
						}
					}
					var currentYear = new Date().getFullYear();
					dataSvc.filter.year = currentYear;
					for (var i = currentYear-4; i <= currentYear+4; i++) {
						dataSvc.filter.years.push(i);
					}
					$scope.list = [];
					$scope.newItem = null;
					$scope.dateOptions = {
						format: 'dd/MMyyyy',
						startingDay: 1
					};

					$scope.today = function () {
						$scope.dt = new Date();
					};
					$scope.today();

					$scope.clear = function () {
						$scope.dt = null;
					};
					$scope.open = function ($event) {
						$event.preventDefault();
						$event.stopPropagation();
						$scope.data.opened = true;
					};
					
					$scope.open1 = function ($event) {
						$event.preventDefault();
						$event.stopPropagation();
						$scope.data.opened1 = true;
					};

					$scope.open2 = function ($event) {
						$event.preventDefault();
						$event.stopPropagation();
						$scope.data.opened2 = true;
					};

					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;


					$scope.addAlert = function (error, type) {
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
					
					$scope.set = function(item) {
						$scope.selected = null;
						$scope.selected = angular.copy(item);
						if ($scope.selected.transactionType > 1) {
							$scope.selected.paymentMethod = $scope.selected.paymentMethod === 2;
							$.each($scope.selected.journalDetails, function(index, jd) {
								if ($scope.selected.transactionType===4 || !jd.account && jd.accountId) {
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

					}
					$scope.void = function() {
						var check = $scope.selected;

						if (check.transactionType > 1) {
							journalRepository.voidCheck(check).then(function (data) {
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
								$scope.addAlert('successfully voided checkbook item', 'success');
								$scope.cancel();
							}, function (erorr) {
								$scope.addAlert('error making the check void', 'danger');
							});
						}
					}
					$scope.save = function () {
						var check = $scope.selected;

						if (check.transactionType > 1) {
							check.paymentMethod = check.paymentMethod ? 2 : 1;
							
							journalRepository.saveCheck(check).then(function (data) {
								if (data.paymentMethod === 1 && data.checkNumber>dataSvc.startingCheckNumber) {
									dataSvc.startingCheckNumber = data.checkNumber + 1;
								}
								if (data.transactionType === 4 && data.checkNumber > dataSvc.startingAdjustmentNumber) {
									dataSvc.startingAdjustmentNumber = data.checkNumber + 1;
								}
								if (check.transactionType === 1) {
									addPayeeToVendorCustomers(data);
								}
								
								var exists = $filter('filter')($scope.list, { id: data.id })[0];
								if (exists) {
									$scope.list.splice($scope.list.indexOf(exists), 1);
								}
								var jd = $filter('filter')(data.journalDetails, { accountId: dataSvc.selectedAccount.id })[0];
								if (jd) {
									dataSvc.selectedAccountBalance += dataSvc.selectedCheckBalance + (jd.isDebit ? jd.amount * -1 : jd.amount);
								}
								$scope.list.push(data);
								$scope.tableParams.reload();
								$scope.fillTableData($scope.tableParams);
								$scope.addAlert('successfully saved checkbook item', 'success');
								$scope.cancel();
							}, function (erorr) {
								$scope.addAlert('error saving checkbook item', 'danger');
							});
						}
					}
					var addPayeeToVendorCustomers = function (j) {
						var payee = {
							id: j.payeeId,
							name: j.payeeName,
							isVendor: j.entityType === EntityTypes.Vendor
						};
						if (j.entityType === EntityTypes.Vendor) {
							var exists = $filter('filter')(dataSvc.vendors, { id: payee.id })[0];
							if (!exists) {
								dataSvc.vendors.push(payee);
							}
						}
						if (j.entityType === EntityTypes.Customer) {
							var exists1 = $filter('filter')(dataSvc.customers, { id: payee.id })[0];
							if (!exists1) {
								dataSvc.customers.push(payee);
							}
						}
						
					}
					$scope.filterByDateRange = function() {
						dataSvc.filterStartDate = dataSvc.filter.startDate? dataSvc.filter.startDate : null;
						dataSvc.filterEndDate = dataSvc.filter.endDate ? dataSvc.filter.endDate : null;
						dataSvc.filter.filterByMonthYear = false;
						dataSvc.filter.filterByPeriod = false;

						getJournals($scope.mainData.selectedCompany.id, dataSvc.selectedAccount.id, dataSvc.filterStartDate, dataSvc.filterEndDate);
					}
					$scope.filterByMonthYear = function () {
						if (!dataSvc.filter.month) {
							dataSvc.filterStartDate = moment('01/01/' + dataSvc.filter.year).format('MM/DD/YYYY');
							dataSvc.filterEndDate = moment(dataSvc.filterStartDate).endOf('year').format('MM/DD/YYYY');
						} else {
							dataSvc.filterStartDate = moment(dataSvc.filter.month + '/01/' + dataSvc.filter.year).format('MM/DD/YYYY');
							var test1 = moment(dataSvc.filterStartDate).endOf('month');
							var test = moment(dataSvc.filterStartDate).endOf('month').date();
							dataSvc.filterEndDate = moment(dataSvc.filterStartDate).endOf('month').format('MM/DD/YYYY');
						}
						
						dataSvc.filter.filterByDateRange = false;
						dataSvc.filter.filterByPeriod = false;

						getJournals($scope.mainData.selectedCompany.id, dataSvc.selectedAccount.id, dataSvc.filterStartDate, dataSvc.filterEndDate);
					}
					$scope.filterByPeriod = function () {
						if (dataSvc.filter.period === 1) {
							dataSvc.filterStartDate = null;
							dataSvc.filterEndDate = null;
						}
						else if (dataSvc.filter.period === 2) {
							dataSvc.filterEndDate = new Date();
							dataSvc.filterStartDate = moment(dataSvc.filterEndDate).add(-3, 'months').format('MM/DD/YYYY');
						}
						else if (dataSvc.filter.period === 3) {
							dataSvc.filterEndDate = new Date();
							dataSvc.filterStartDate = moment(dataSvc.filterEndDate).add(-6, 'months').format('MM/DD/YYYY');
						}
						else if (dataSvc.filter.period === 4) {
							dataSvc.filterEndDate = new Date();
							dataSvc.filterStartDate = moment(dataSvc.filterEndDate).add(-1, 'years').format('MM/DD/YYYY');
						}
						
						dataSvc.filter.filterByMonthYear = false;
						dataSvc.filter.filterByDateRange = false;

						getJournals($scope.mainData.selectedCompany.id, dataSvc.selectedAccount.id, dataSvc.filterStartDate, dataSvc.filterEndDate);
					}
					var getJournals = function (companyId, accountId, startDate, endDate) {
						journalRepository.getJournalList(companyId, accountId, startDate, endDate).then(function (data) {
							dataSvc.selectedAccountBalance = data.accountBalance;
							$scope.list = data.journals;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							
						}, function (error) {
							$scope.addAlert('error getting journal list', 'danger');
						});
					}
					var getMetaData = function (companyId) {
						journalRepository.getJournalMetaData(companyId).then(function (data) {
							dataSvc.companyAccounts = data.accounts;
							dataSvc.bankAccounts = $filter('filter')(dataSvc.companyAccounts, { isBank: true });
							dataSvc.vendors = data.vendors;
							dataSvc.customers = data.customers;
							dataSvc.startingCheckNumber = data.startingCheckNumber;
							dataSvc.startingAdjustmentNumber = data.startingAdjustmentNumber;
							if (dataSvc.bankAccounts.length > 0) {
								dataSvc.selectedAccount = dataSvc.bankAccounts[0];
								$scope.accountSelected();
							}
						}, function (erorr) {
							$scope.addAlert('error getting journal meta data', 'danger');
						});
					}

					$scope.accountSelected = function() {
						getJournals($scope.mainData.selectedCompany.id, dataSvc.selectedAccount.id, null, null);
					}

					$scope.$watch('mainData.selectedCompany',
						 function (newValue, oldValue) {
						 	if (newValue !== oldValue) {
						 		dataSvc.selectedAccount = null;
						 		dataSvc.selectedAccountBalance = 0;
								 $scope.selected = null;
						 		getMetaData($scope.mainData.selectedCompany.id);
						 		
						 	}

						 }, true
				 );
					$scope.add = function(transactionType, paymentMethod) {
						var newItem = {
							id : 0,
							companyId : $scope.mainData.selectedCompany.id,
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
					}
					$scope.refresh = function() {
						getJournals($scope.mainData.selectedCompany.id, dataSvc.selectedAccount.id, null, null);
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
