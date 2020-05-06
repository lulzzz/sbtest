'use strict';

common.directive('regularCheck', ['zionAPI','version',
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
			templateUrl: zionAPI.Web + 'Areas/Client/templates/regular-check.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'EntityTypes', 'AccountType', 
				function ($scope, $element, $location, $filter, companyRepository, EntityTypes, AccountType) {
					var dataSvc = {
						
						companyAccounts: $scope.datasvc.companyAccounts,
						payees: $scope.datasvc.payees? $scope.datasvc.payees : [],
						allPayees: [],
						selectedPayee: null

					}

					$scope.list = [];
					
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
					$scope.addJournalDetail = function () {
						var defaultCompanyAccount = $filter('filter')(dataSvc.companyAccounts, { templateId: 36 })[0];
						var newJD = {
							account: defaultCompanyAccount,
							accountId: defaultCompanyAccount.id,
							accountName: defaultCompanyAccount.accountName,
							memo: '',
							amount:0
						};
						var currentLength = $scope.item.journalDetails.length;
						$scope.item.journalDetails.push(newJD);
						$scope.selectedjd = $scope.item.journalDetails[currentLength];
					}

					$scope.saveJournalDetail = function(jd) {
						$scope.selectedjd = null;
						updateItemAmount();
					}
					$scope.print = function () {
						var j = angular.copy($scope.item);
						//j.paymentMethod = j.paymentMethod ? 2 : 1;
						$scope.$parent.$parent.printJournal(j);
					}
					$scope.isJournalDetailValid = function(jd) {
						if (!jd.accountId || !jd.accountName || !jd.amount)
							return false;
						else
							return true;
					}
					$scope.canceljd = function($index) {
						if (!$scope.item.id || $scope.selectedjd.amount===0) {
							$scope.item.journalDetails.splice($index, 1);
						}
						$scope.selectedjd = null;
					}
					var updateItemAmount = function() {
						var amount = 0;
						$.each($scope.item.journalDetails, function (index, jd1) {
							if (jd1.accountId !== $scope.item.mainAccountId) {
								amount += jd1.amount;
								if (jd1.account.type === AccountType.Assets || jd1.account.type === AccountType.Expense)
									jd1.isDebit = false;
								else {
									jd1.isDebit = true;
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
								isDebit: true,
								amount: amount,
								account: $scope.datasvc.selectedAccount
							}
							$scope.item.journalDetails.push(main);
						}
					}
					$scope.isCheckInValid = function() {
						if ($scope.item.amount && $scope.item.transactionDate && $scope.item.checkNumber && dataSvc.selectedPayee)
							return false;
						else
							return true;
					}

					$scope.save = function () {
						updateItemAmount();
						$scope.$parent.$parent.save();
					}
					$scope.void = function() {
						$scope.$parent.$parent.void();
					}
					$scope.hasChanged = function() {
						return !angular.equals($scope.item, dataSvc.original);
					}
					var init = function () {
						
						if ($scope.item.payeeId && $scope.item.payeeId != '00000000-0000-0000-0000-000000000000') {
							var exists = $filter('filter')(dataSvc.payees, { id: $scope.item.payeeId })[0];
							if (exists) {
								dataSvc.selectedPayee = exists;
							}
						}
						if ($scope.item.transactionDate)
							$scope.item.transactionDate = moment($scope.item.transactionDate).toDate();

						dataSvc.original = angular.copy($scope.item);
					}
					init();


				}]
		}
	}
]);
