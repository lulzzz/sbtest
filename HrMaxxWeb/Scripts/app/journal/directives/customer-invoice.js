'use strict';

common.directive('customerInvoice', ['$uibModal','zionAPI','version','$window',
	function ($modal, zionAPI, version, $window) {
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
			templateUrl: zionAPI.Web + 'Areas/Client/templates/customer-invoice.html?v=' + version,

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
					$scope.showvendorcustomer = function () {
						var modalInstance = $modal.open({
							templateUrl: 'popover/vendorcustomer.html',
							controller: 'vendorCustomerCtrl',
							size: 'md',
							windowClass: 'my-modal-popup',
							backdrop: true,
							keyboard: true,
							backdropClick: true,
							resolve: {
								vendor: function () {
									return $scope.selectedPayee;
								},
								mainData: function () {
									return $scope.mainData;
								},
								isVendor: function () {
									return $scope.selectedPayee.isVendor;
								},
								isGlobal: function () {
									return $scope.selectedPayee.isGlobal;
								}

							}
						});
					}
					
					$scope.payeeSelected = function() {
						if (dataSvc.selectedPayee) {
							//if (dataSvc.selectedPayee.id) {
								$scope.item.payeeId = dataSvc.selectedPayee.id;
								$scope.item.payeeName = dataSvc.selectedPayee.name;
								$scope.item.entityType = dataSvc.selectedPayee.entityType;
							//} else {
							//	$scope.item.payeeId = '00000000-0000-0000-0000-000000000000';
							//	$scope.item.payeeName = dataSvc.selectedPayee;
							//	$scope.item.entityType = EntityTypes.Vendor;
							//}
						}
					}
					$scope.setselectedji = function(ji) {
						$scope.selectedji = ji;
						$scope.originalji = angular.copy(ji);
					}
					$scope.addJournalItem = function () {
						
						var newJD = {
							item: '',
							rate: 0,
							quantity: 1,							
							amount:0
						};
						var currentLength = $scope.item.listItems.length;
						$scope.item.listItems.push(newJD);
						$scope.setselectedji($scope.item.listItems[currentLength]);
					}

					$scope.saveJournalItem = function (ji) {
						updateItemAmount();
						$scope.selectedji = null;
						$scope.originalji = null;
						
					}
					$scope.print = function () {
						$window.print();
						//var j = angular.copy($scope.item);
						////j.paymentMethod = j.paymentMethod ? 2 : 1;
						//$scope.$parent.$parent.printJournal(j);
					}
					$scope.getContactPhone = function (c) {
						var p = '';
						if (c) {
							p = c.phone ? c.phone : (c.mobile ? c.mobile : '');
						}
						if (p)
							return '(' + p.substring(0, 3) + ') ' + p.substring(3, 6) + '-' + p.substring(6, 12);
						else {
							return '';
						}
					}
					$scope.getContactFax = function (c) {
						var p = '';
						if (c) {
							p = c.fax ? c.fax : '';
						}
						if (p)
							return '(' + p.substring(0, 3) + ') ' + p.substring(3, 6) + '-' + p.substring(6, 12);
						else {
							return '';
						}
					}
					$scope.isJournalItemValid = function(jd) {
						if (!jd.item || !jd.rate || !jd.quantity)
							return false;
						else
							return true;
					}
					$scope.cancelji = function($index) {
						if (!$scope.item.id || !$scope.selectedji.amount ) {
							$scope.item.listItems.splice($index, 1);
						}
						else {
							$scope.item.listItems[$index] = angular.copy($scope.originalji);
						}
						$scope.selectedji = null;
						$scope.originalji = null;
					}
					var updateItemAmount = function() {
						var amount = 0;
						$.each($scope.item.listItems, function (index, jd1) {
							
								amount += jd1.rate * jd1.quantity;
							
								
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
						var incomeJd = $filter('filter')($scope.item.journalDetails, { accountId: '!' +$scope.item.mainAccountId })[0];
						incomeJd.amount = amount;
						
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
						if (!$scope.item.id || $scope.item.journalDetails.length === 0) {
							var defaultCompanyAccount = $filter('filter')(dataSvc.companyAccounts, { templateId: 70 })[0];
							
							var newJD = {
								account: defaultCompanyAccount,
								accountId: defaultCompanyAccount.id,
								accountName: defaultCompanyAccount.accountName,
								memo: '',
								amount: 0,
								isDebit: false
							};							
							$scope.item.journalDetails.push(newJD);
							
						} 
						dataSvc.original = angular.copy($scope.item);
					}
					init();


				}]
		}
	}
]);
