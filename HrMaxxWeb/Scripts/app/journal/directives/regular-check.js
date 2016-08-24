'use strict';

common.directive('regularCheck', ['$modal', 'zionAPI',
	function ($modal, zionAPI) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				item: "=item",
				datasvc: "=datasvc",
				company: "=company"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/regular-check.html',

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'ngTableParams', 'EntityTypes', 'AccountType', 
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, AccountType) {
					var dataSvc = {
						opened: false,
						companyAccounts: $scope.datasvc.companyAccounts,
						vendors: $scope.datasvc.vendors? $scope.datasvc.vendors : [],
						customers: $scope.datasvc.customers ? $scope.datasvc.customers : [],
						allPayees: [],
						selectedPayee: null

					}

					$scope.list = [];
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

					$scope.data = dataSvc;
					$scope.cancel = function () {
						$scope.$parent.$parent.selected = null;
						$scope.datasvc.isBodyOpen = true;
					}

					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					
					$scope.payeeSelected = function() {
						if (dataSvc.selectedPayee) {
							if (dataSvc.selectedPayee.id) {
								$scope.item.payeeId = dataSvc.selectedPayee.id;
								$scope.item.payeeName = dataSvc.selectedPayee.name;
								$scope.item.entityType = dataSvc.selectedPayee.isVendor ? EntityTypes.Vendor : EntityTypes.Customer;
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

					var init = function () {
						
						$scope.minPayDate = new Date();
						dataSvc.allPayees = dataSvc.vendors.concat(dataSvc.customers);
						if ($scope.item.payeeId != '00000000-0000-0000-0000-000000000000') {
							var exists = $filter('filter')(dataSvc.allPayees, { id: $scope.item.payeeId })[0];
							if (exists) {
								dataSvc.selectedPayee = exists;
							}
						}

					}
					init();


				}]
		}
	}
]);
