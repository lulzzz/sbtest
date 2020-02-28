'use strict';

common.directive('depositTicket', ['zionAPI','version',
	function (zionAPI, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				item: "=item",
				datasvc: "=datasvc",
				company: "=company",
				showControls: "=showControls",
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/deposit-ticket.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'EntityTypes','AccountType',
				function ($scope, $element, $location, $filter, companyRepository, EntityTypes, AccountType) {
					var dataSvc = {
						companyAccounts: $scope.datasvc.companyAccounts,
						payees: $scope.datasvc.payees? $scope.datasvc.payees : [],
						selectedPayee: null,
						depositMethods: [{ key: 1, value: 'Check' }, { key: 2, value: 'Cash' }],
						sortedBy: null,
						sortMethod: null

					}

					$scope.list = [];
					$scope.dt = new Date();
					

					$scope.data = dataSvc;
					$scope.cancel = function () {
						$scope.$parent.$parent.cancel();
					}

					
					$scope.payeeSelected = function() {
						if (dataSvc.selectedPayee) {
							if (dataSvc.selectedPayee.id) {
								$scope.item.payeeId = dataSvc.selectedPayee.id;
								$scope.item.payeeName = dataSvc.selectedPayee.payeeName;
								$scope.item.entityType = dataSvc.selectedPayee.payeeType;
							} else {
								$scope.item.payeeId = '00000000-0000-0000-0000-000000000000';
								$scope.item.payeeName = dataSvc.selectedPayee;
								$scope.item.entityType = EntityTypes.Vendor;
							}
						}
					}
					$scope.setselectedjd = function(jd) {
						if (!jd.account && jd.accountId) {
							var account = $filter('filter')(dataSvc.companyAccounts, { templateId: jd.accountId })[0];
							if (account) {
								jd.accoount = account;
							}
						}
						$scope.selectedjd = jd;
					}
					$scope.cashAmount = 0;
					$scope.checkAmount = 0;

					$scope.addJournalDetail = function () {
						var defaultCompanyAccount = $filter('filter')(dataSvc.companyAccounts, { templateId: 70 })[0];
						var newJD = {
							account: defaultCompanyAccount,
							accountId: defaultCompanyAccount.id,
							accountName: defaultCompanyAccount.accountName,
							memo: '',
							amount: 0,
							isNew:true
						};
						var currentLength = $scope.item.journalDetails.length;
						$scope.item.journalDetails.push(newJD);
						$scope.selectedjd = $scope.item.journalDetails[currentLength];
					}
					
					$scope.saveJournalDetail = function (jd) {
						if (jd.screenPayee) {
							if (!jd.screenPayee.id) {
								jd.payee = {
									id : '00000000-0000-0000-0000-000000000000',
									payeeName: jd.screenPayee,
									payeeType: EntityTypes.Vendor,
									displayName: 'Vendor: ' + jd.screenPayee
								};
								dataSvc.payees.push(jd.payee);
							} else {
								jd.payee = jd.screenPayee;
							}
						}
						$scope.selectedjd = null;

						updateItemAmount();
					}
					$scope.removejd = function(jd) {
						$scope.item.journalDetails.splice($scope.item.journalDetails.indexOf(jd), 1);
						updateItemAmount();
					}
					$scope.isJournalDetailValid = function (jd) {
						if (jd.account.isBank)
							return true;
						if (!jd.accountId || !jd.accountName || !jd.amount || !jd.depositMethod || (!jd.payee && !jd.screenPayee))
							return false;
						else if (jd.depositMethod && jd.depositMethod.key === 1 && !jd.checkNumber)
							return false;
						else
							return true;
					}
					$scope.canceljd = function($index) {
						if ($scope.selectedjd.isNew) {
							$scope.item.journalDetails.splice($index+1, 1);
						}
						$scope.selectedjd = null;
					}
					var updateItemAmount = function() {
						var amount = 0;
						var cashAmount = 0;
						var checkAmount = 0;
						$.each($scope.item.journalDetails, function (index, jd1) {
							if (jd1.accountId !== $scope.item.mainAccountId) {
								amount += jd1.amount;
								if (jd1.depositMethod && jd1.depositMethod.key === 1)
									checkAmount += jd1.amount;
								if (jd1.depositMethod && jd1.depositMethod.key === 2)
									cashAmount += jd1.amount;
								if (jd1.account && jd1.account.type) {
									if (jd1.account.type === AccountType.Assets || jd1.account.type === AccountType.Expense)
										jd1.isDebit = true;
									else {
										jd1.isDebit = false;
									}
								} 
								
							}
								
						});
						$scope.item.amount = amount;
						var mainJd = $filter('filter')($scope.item.journalDetails, { accountId: $scope.item.mainAccountId })[0];
						if (mainJd) {
							mainJd.amount = amount;
						} else {
							var main = {
								accountId: $scope.datasvc.selectedAccount.id,
								accountName: $scope.datasvc.selectedAccount.accountName,
								memo: '',
								isDebit: false,
								amount: amount,
								account: $scope.datasvc.selectedAccount
							}
							$scope.item.journalDetails.push(main);
						}
						$scope.checkAmount = checkAmount;
						$scope.cashAmount = cashAmount;
					}
					$scope.isCheckInValid = function () {
						var returnVal = false;
						if (!$scope.item.amount || !$scope.item.transactionDate || $scope.item.journalDetails.length === 0)
							returnVal = true;
						else {
							$.each($scope.item.journalDetails, function(id, jd1) {
								if (!$scope.isJournalDetailValid(jd1)) {
									returnVal = true;
									return;
								}
							});
						};
						return returnVal;
					}

					$scope.save = function () {
						var check = $scope.item;
						$.each(check.journalDetails, function (index, jd) {
							if (!jd.accountId !== $scope.datasvc.selectedAccount.id) {
								jd.depositMethod = jd.depositMethod? jd.depositMethod.key : 1;
							}
						});
						check.payeeId = '00000000-0000-0000-0000-000000000000';
						if (check.journalDetails.length > 2)
							check.payeeName = 'Multiple';
						else {
							var jd = $filter('filter')(check.journalDetails, { accountId: '!' + $scope.datasvc.selectedAccount.id })[0];
							if (jd && jd.payee)
								check.payeeName = jd.payee.name;
							else {
								check.payeeName = "NA";
							}
						}
						updateItemAmount();
						$scope.item.transactionDate = moment($scope.item.transactionDate).format("MM/DD/YYYY");
						$scope.$parent.$parent.save();
					}
					$scope.print = function () {
						var j = angular.copy($scope.item);
						j.paymentMethod = j.paymentMethod ? 2 : 1;
						$.each(j.journalDetails, function (index, jd) {
							if (!jd.accountId !== $scope.datasvc.selectedAccount.id) {
								jd.depositMethod = jd.depositMethod ? jd.depositMethod.key : 1;
							}
						});
					
						$scope.$parent.$parent.printJournal(j);
					}
					$scope.void = function () {
						$scope.$parent.$parent.void();
					}
					$scope.hasChanged = function () {
						var changed = !angular.equals($scope.item, dataSvc.original);
						return changed;
					}
					var init = function () {
						
						
						$scope.minPayDate = new Date();
						
						$.each($scope.item.journalDetails, function (index, jd) {
							jd.screenPayee = angular.copy(jd.payee);
							if (!jd.accountId!==$scope.datasvc.selectedAccount.id) {
								var dp = $filter('filter')(dataSvc.depositMethods, { key: jd.depositMethod })[0];
								if (dp) {
									jd.depositMethod = dp;
								}
							}
						});
						if ($scope.item.transactionDate)
							$scope.item.transactionDate = moment($scope.item.transactionDate).toDate();
						updateItemAmount();
						dataSvc.original = angular.copy($scope.item);
						$scope.sort('payee.payeeName');
					}
					$scope.sort = function(col) {
						dataSvc.sortedBy = col;
						dataSvc.sortMethod = !dataSvc.sortMethod || dataSvc.sortMethod===2 ? 1 : 2;
						$scope.item.journalDetails = $filter('orderBy')($scope.item.journalDetails, col, dataSvc.sortMethod === 1);
						dataSvc.original.journalDetails = $filter('orderBy')(dataSvc.original.journalDetails, col, dataSvc.sortMethod === 1);
					}
					init();


				}]
		}
	}
]);
