'use strict';

common.directive('vendorInvoice', ['$uibModal', 'zionAPI', 'version', '$window', '$timeout',
	function ($modal, zionAPI, version, $window, $timeout) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				item: "=item",
				datasvc: "=datasvc",
				company: "=company",
				showControls: "=showControls",
				mainData: "=mainData",
				print: "=?print"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/vendor-invoice.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'EntityTypes', 'AccountType', 
				function ($scope, $element, $location, $filter, companyRepository, EntityTypes, AccountType) {
					var dataSvc = {
						print: $scope.print,
						payees: $scope.datasvc.payees ? $scope.datasvc.payees : [],
						products: $scope.datasvc.products,
						allPayees: [],
						selectedPayee: null,
						openedRack: 1

					}

					$scope.list = [];

					$scope.data = dataSvc;
					$scope.cancel = function () {
						$scope.$parent.$parent.cancel();

					}
					$scope.newpayee = function () {
						var selected = {
							companyId: $scope.isGlobal ? null : $scope.mainData.selectedCompany.id,
							statusId: 1,
							isVendor: $scope.isVendor,
							contact: {
								isPrimary: true,
								address: {}
							},
							identifierType: null,
							type1099: null,
							subType1099: null,
							individualSSN: null,
							businessFIN: null,
							isVendor1099: $scope.isGlobal ? false : $scope.isVendor,
							isAgency: false,
							isTaxDepartment: false

						};
						dataSvc.selectedPayee = selected;
						$scope.showvendorcustomer();
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
									return dataSvc.selectedPayee;
								},
								mainData: function () {
									return $scope.mainData;
								},
								companyRepository: function () {
									return companyRepository;
								}

							}
						});
						modalInstance.result.then(function (result) {
							dataSvc.payees.push(result);
							dataSvc.selectedPayee = result;
							$scope.payeeSelected();
						}, function () {
							return false;
						});
					}
					$scope.addProduct = function () {
						var product = {
							id: 0,
							companyId: $scope.mainData.selectedCompany.id,
							serialNo: '',
							name: '',
							type: null,
							costPrice: 0,
							salePrice: 0,
							isTaxable: true
						};
						var modalInstance = $modal.open({
							templateUrl: 'popover/product.html',
							controller: 'productCtrl',
							size: 'sm',
							windowClass: 'my-modal-popup',
							backdrop: 'static',
							resolve: {
								product: function () {
									return product;
								},
								repository: function () {
									return companyRepository;
								},
								company: function () {
									return $scope.mainData.selectedCompany;
								}
							}
						});
						modalInstance.result.then(function (scope) {
							
							if (scope.isNew) {
								
								$scope.datasvc.products.push(angular.copy(scope.product));
							}
							var prod = $filter('filter')(dataSvc.products, { id: scope.product.id })[0];
							$scope.selectedji.product = prod;
							$scope.selectedji.rate = prod.salePrice;
							$scope.item.invoiceItems[$scope.selectedjiindex].product = prod;
							$scope.item.invoiceItems[$scope.selectedjiindex].rate = prod.salePrice;
							
						}, function () {
							
						});
					}
					$scope.payeeSelected = function () {
						if (dataSvc.selectedPayee) {
							//if (dataSvc.selectedPayee.id) {
							$scope.item.payeeId = dataSvc.selectedPayee.id;
							$scope.item.payeeName = dataSvc.selectedPayee.name;
							$scope.item.entityType = dataSvc.selectedPayee.entityType;
							$scope.item.contact = dataSvc.selectedPayee.contact;
							//} else {
							//	$scope.item.payeeId = '00000000-0000-0000-0000-000000000000';
							//	$scope.item.payeeName = dataSvc.selectedPayee;
							//	$scope.item.entityType = EntityTypes.Vendor;
							//}
						}
					}
					$scope.changeProduct = function (ji) {
						
						$scope.selectedji.rate = ji.product.salePrice;
						$scope.selectedji.isTaxable = ji.product.isTaxable;
						ji.rate = ji.product.salePrice;
						ji.isTaxable = ji.product.isTaxable;
                    }
					$scope.setselectedji = function (ji, ind) {
						$scope.selectedjiindex = ind;
						$scope.selectedji = ji;
						$scope.originalji = angular.copy(ji);
					}
					$scope.addJournalItem = function () {

						var newJD = {
							id: 0,
							product: null,
							description: '',
							rate: 0,
							quantity: 1,
							amount: 0
						};
						var currentLength = $scope.item.invoiceItems.length;
						$scope.item.invoiceItems.push(newJD);
						$scope.setselectedji($scope.item.invoiceItems[currentLength]);
					}

					$scope.saveJournalItem = function (ji) {
						$scope.updateItemAmount();
						$scope.selectedji = null;
						$scope.originalji = null;
						$scope.selectedjiindex = null;
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
					$scope.isJournalItemValid = function (jd) {
						if (!jd.product || !jd.rate || !jd.quantity)
							return false;
						else
							return true;
					}
					$scope.cancelji = function ($index) {
						if (!$scope.item.id || !$scope.selectedji.amount) {
							$scope.item.invoiceItems.splice($index, 1);
						}
						else {
							$scope.item.invoiceItems[$index] = angular.copy($scope.originalji);
						}
						$scope.selectedji = null;
						$scope.originalji = null;
						$scope.selectedjiindex = null;
					}
					$scope.updateItemAmount = function () {
						var amount = 0;
						$scope.item.salesTax = 0;
						$.each($scope.item.invoiceItems, function (index, jd1) {
							var am = jd1.rate * jd1.quantity;
							amount += am;
							if (jd1.isTaxable) {
								$scope.item.salesTax += (am * $scope.item.salesTaxRate / 100);
							}

						});
						$scope.item.amount = amount;

					}
					$scope.calculateDiscount = function () {
						$scope.item.discount = ($scope.item.discountType === 1 ? $scope.item.discountRate : (am * $scope.item.discountRate / 100));
					}
					$scope.calculateTotal = function () {
						var am = $scope.item.amount;
						am = am + $scope.item.salesTax;
						am = am - $scope.item.discount;
						$scope.item.total = am;
						return am;
					}
					$scope.calculateBalance = function () {
						var am = 0;
						$.each($scope.item.invoicePayments, function (index, jd1) {

							am += jd1.amount;
							
						});
						$scope.item.balance = $scope.item.total - am;
						return $scope.item.balance;
					}
					$scope.isCheckInValid = function () {
						if ($scope.item.amount && $scope.item.invoiceDate && $scope.item.invoiceNumber && dataSvc.selectedPayee)
							return false;
						else
							return true;
					}

					$scope.save = function () {
						$scope.updateItemAmount();
						$scope.$parent.$parent.save();
					}
					$scope.void = function () {
						$scope.$parent.$parent.void();
					}
					$scope.hasChanged = function () {
						return !angular.equals($scope.item, dataSvc.original);
					}
					$scope.addPayment = function () {
						var payment = {
							id: 0,
							companyInvoiceId: $scope.item.id,
							hasChanged: true,
							paymentDate: moment().toDate(),
							method: 2,
							checkNumber: 0,
							amount: $scope.paymentRemaining()
						};
						$scope.item.invoicePayments.push(payment);
						$scope.setselectedpayment($scope.item.invoicePayments.length - 1);
					}
					$scope.setselectedpayment = function (ind) {
						$scope.paymentIndex = ind;
						$scope.selectedPayment = $scope.item.invoicePayments[ind];
						$scope.originalPayment = angular.copy($scope.item.invoicePayments[ind]);
					}
					$scope.cancelpayment = function () {
						$scope.paymentIndex = null;
						$scope.selectedPayment = null;
						$scope.originalPayment = null;
					}
					$scope.savePayment = function (ind) {
						$scope.item.invoicePayments[ind] = $scope.selectedPayment;
						$scope.cancelpayment();
                    
					}
					$scope.deletePayment = function (ind) {
						$scope.item.invoicePayments.splice(ind, 1);
					}
					$scope.isPaymentEditable = function (ind) {
						if ($scope.paymentIndex===ind)
							return true;
						else
							return false;
                    }
					$scope.paymentRemaining = function () {
						var paidamount = 0;
						$.each($scope.item.invoicePayments, function (index, lineitem) {
							var am = parseFloat(lineitem.amount);
							paidamount += +am.toFixed(2);
						});
						return +($scope.item.total - paidamount).toFixed(2);
					}
					var init = function () {
						
						if ($scope.item.payeeId && $scope.item.payeeId != '00000000-0000-0000-0000-000000000000') {
							var exists = $filter('filter')(dataSvc.payees, { id: $scope.item.payeeId })[0];
							if (exists) {
								dataSvc.selectedPayee = exists;
							}
						}
						if ($scope.item.invoiceDate)
							$scope.item.invoiceDate = moment($scope.item.invoiceDate).toDate();
						
						dataSvc.original = angular.copy($scope.item);
						$timeout(function () {
							if (dataSvc.print)
								$scope.print();
						}, 1);
						
					}
					init();


				}]
		}
	}
]);
common.controller('vendorCustomerCtrl', function ($scope, $uibModalInstance, vendor, mainData, companyRepository) {
	$scope.vendor = vendor;
	$scope.mainData = mainData;

	$scope.cancel = function () {
		$uibModalInstance.dismiss();
	};

	$scope.save = function (result) {
		$uibModalInstance.close(result);
	};


});