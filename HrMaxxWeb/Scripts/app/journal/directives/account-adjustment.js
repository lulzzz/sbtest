'use strict';

common.directive('accountAdjustment', ['zionAPI','version',
	function (zionAPI, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				item: "=item",
				datasvc: "=datasvc",
				company: "=company",
				showControls: "=showControls"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/account-adjustment.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'ngTableParams', 'EntityTypes', 'AccountType', 
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, AccountType) {
					var dataSvc = {
						companyAccounts: $scope.datasvc.companyAccounts
					}

					$scope.list = [];
					$scope.dt = new Date();
					
					$scope.data = dataSvc;
					$scope.cancel = function () {
						$scope.$parent.$parent.cancel();
					}

					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					
					
					$scope.save = function () {
						$scope.$parent.$parent.save();
					}
					$scope.void = function() {
						$scope.$parent.$parent.void();
					}
					var addJournalDetail = function () {
						
						var newJD = {
							account: null,
							accountId: 0,
							accountName: '',
							memo: '',
							isDebit: false,
							amount: 0,
							isIncrease:0
						};
						$scope.item.journalDetails.push(newJD);
						
					}
					$scope.fromAccountSelected = function () {
						var jd = $scope.item.journalDetails[0];
						jd.accountId = jd.account.id;
						jd.accountName = jd.account.accountName;
						$scope.item.mainAccountId = jd.accountId;
						$scope.item.isDebit = jd.isDebit;
						adjustDebitAndCredit();
					}
					$scope.toAccountSelected = function () {
						var jd = $scope.item.journalDetails[1];
						jd.accountId = jd.account.id;
						jd.accountName = jd.account.accountName;
						adjustDebitAndCredit();
					}
					$scope.fromDebitChanged = function () {
						var jd = $scope.item.journalDetails[0];
						jd.isDebit = jd.isIncrease === 1;
						adjustDebitAndCredit();
					}
					$scope.updateAmount = function() {
						var jd = $scope.item.journalDetails[0];
						var jd1 = $scope.item.journalDetails[1];
						if (jd.amount < 0)
							jd.amount = 0;
						jd1.amount = jd.amount;
						$scope.item.amount = jd.amount;
					}
					var adjustDebitAndCredit = function() {
						var jd = $scope.item.journalDetails[0];
						var jd1 = $scope.item.journalDetails[1];
						if (jd.account && jd1.account) {
							if (jd.account.type === AccountType.Assets || jd.account.type === AccountType.Expense) {
								if (jd1.account.type === AccountType.Assets || jd1.account.type === AccountType.Expense) {
									jd1.isDebit = !jd.isDebit;
								} else {
									jd1.isDebit = jd.isDebit;
								}

							} else {
								if (jd1.account.type === AccountType.Assets || jd1.account.type === AccountType.Expense) {
									jd1.isDebit = jd.isDebit;
								} else {
									jd1.isDebit = !jd.isDebit;
								}
							}
						}
					}
					$scope.isCheckInValid = function () {
						if ($scope.item.journalDetails.length === 2 && $scope.item.journalDetails[0].account && $scope.item.journalDetails[1].account && $scope.item.journalDetails[1].amount === $scope.item.journalDetails[0].amount)
							return false;
						else
							return true;
					}
					$scope.availableAccounts = function(forAccount) {
						return $filter('filter')(dataSvc.companyAccounts, {id:'!'+forAccount.accountId});
					}
					var init = function () {
						
						$scope.minPayDate = new Date();
						$scope.item.checkNumber = $scope.datasvc.startingAdjustmentNumber;
						$scope.item.payeeId = '00000000-0000-0000-0000-000000000000';
						$scope.item.payeeName = 'Adjustment';
						$scope.item.entityType = EntityTypes.COA;
						if ($scope.item.journalDetails.length === 0) {
							addJournalDetail();
							addJournalDetail();
						}
						if (!$scope.item.journalDetails[0].isIncrease) {
							$scope.item.journalDetails[0].isIncrease = $scope.item.journalDetails[0].isDebit ? 1 : 0;
						}
						if ($scope.item.transactionDate)
							$scope.item.transactionDate = moment($scope.transactionDate).toDate();

					}
					init();


				}]
		}
	}
]);
