'use strict';

common.directive('invoice', ['$uibModal', 'zionAPI', '$timeout', '$window','version',
	function ($modal, zionAPI, $timeout, $window,version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				item: "=?item",
				itemId: "=?itemId",
				datasvc: "=datasvc",
				company: "=company",
				fromPayroll: "=?fromPayroll"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/invoice.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'ngTableParams', 'EntityTypes', 'payrollRepository',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, payrollRepository) {
					var dataSvc = {
						
						payrolls: [],
						invoiceMethod: $scope.company.contract.method,
						invoiceRate: $scope.company.contract.invoiceCharge

				}
					
					$scope.list = [];
					$scope.dt = new Date();
					

					$scope.data = dataSvc;
					$scope.cancel = function () {
						if (!$scope.fromPayroll)
							$scope.$parent.$parent.selected = null;
						else {
							$scope.$parent.$parent.committed = null;
							$scope.$parent.$parent.invoiceId = null;
						}
							
						if ($scope.itemId)
							$scope.itemId = null;
						$scope.datasvc.isBodyOpen = true;
					}

					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					
					
					var calculateInvoiceCharge = function () {

						if ($scope.item.invoiceMethod === 1) {
							$scope.item.invoiceValue = +($scope.item.invoiceRate * $scope.item.payrollIds.length).toFixed(2);
						} else {
							$scope.item.invoiceValue = +(($scope.item.invoiceRate * $scope.item.payrollValue) / 100).toFixed(2);
						}
					}
					$scope.updatePayrollAmounts = function() {
						var payrollAmount = 0;
						
						$.each($scope.datasvc.payrolls, function (index, payroll) {
							if (payroll.selected)
								payrollAmount += +payroll.totalCost.toFixed(2);
						});
						$.each(dataSvc.payrolls, function (index1, payroll1) {
							if (payroll1.selected)
								payrollAmount += +payroll1.totalCost.toFixed(2);
						});
						$scope.item.payrollValue = payrollAmount;
						calculateInvoiceCharge();
						updateTotal();
					}
					$scope.updateLineAmounts = function () {
						var linesAmount = 0;

						$.each($scope.item.lineItems, function (index, lineitem) {
							var am = parseFloat(lineitem.amount);
							linesAmount += +am.toFixed(2);
						});
						$scope.item.lineItemTotal = linesAmount;
						updateTotal();
					}
					
					var updateTotal = function() {
						$scope.item.total = +($scope.item.invoiceValue + $scope.item.lineItemTotal).toFixed(2);
					}
					$scope.addLineItem = function() {
						var lineitem = {
							description:'',
							amount: 0,
							notes:''
						}
						$scope.item.lineItems.push(lineitem);
						
					}
					$scope.addPayment = function() {
						var payment = {
							hasChanged: true,
							paymentDate: moment().toDate(),
							method:1,
							checkNumber: 0,
							status: 1,
							notes:'',
							amount: $scope.paymentRemaining()
						};
						$scope.item.payments.push(payment);
					}
					$scope.payrollSelected = function (payroll) {
						if ($scope.item.status === 1) {
							payroll.selected = !payroll.selected;
							
							if (payroll.selected) {
								$scope.item.payrollIds.push(payroll.id);
							} else {
								$scope.item.payrollIds.splice($scope.item.payrollIds.indexOf(payroll.id), 1);
							}
							$scope.updatePayrollAmounts();
						}
						
					}
					$scope.paymentRemaining = function() {
						var paidamount = 0;
						$.each($scope.item.payments, function (index, lineitem) {
							if(lineitem.status!==4){
								var am = parseFloat(lineitem.amount);
								paidamount += +am.toFixed(2);
							}
						});
						return +($scope.item.total - paidamount).toFixed(2);
					}
					$scope.deletelineitem = function(index) {
						$scope.item.lineItems.splice(index, 1);
						$scope.updateLineAmounts();
					}
					$scope.deletepayment = function (index) {
						$scope.item.payments.splice(index, 1);
					}
					
					$scope.isLineItemValid = function(li) {
						if (!li.description || parseFloat(li.amount))
							return false;
						else
							return true;
					}

					var isInvoiceInvalid = function() {
						var invoice = $scope.item;
						if (!invoice.dueDate)
							return 'Please enter a valid Due Date';
						else if (!invoice.invoiceNumber)
							return 'Please enter a valid Invoice Number';
						else if (!invoice.invoiceValue || invoice.payrollIds.length === 0)
							return 'Please select at least one payroll';
						else if (!invoice.total)
							return 'The invoice total must be greated than 0';
						else
							return '';
					}
					
					$scope.save = function() {
						if (false === $('form[name="invoice"]').parsley().validate()) {
							var errors = $('.parsley-error');
							return false;
						}
						var validation = isInvoiceInvalid();
						if (validation) {
							addAlert(validation, 'warning');
							return false;
						}
						//$.each($scope.item.payments, function (index, p) {
						//	p.paymentDate = moment(p.paymentDate, 'MM/DD/YYYY').format("MM/DD/YYYY");
						//});
						payrollRepository.saveInvoice($scope.item).then(function(data) {
							$timeout(function () {
								$scope.cancel();
								$scope.$parent.$parent.invoiceSaved(data, $scope.item.payrollIds);
								addAlert('successfully saved invoice', 'success');
							});


						}, function(error) {
							addAlert('error processing payroll', 'danger');
						});
					};
					
					var getInvoicePayrolls = function (invoiceId) {
						payrollRepository.getPayrollsForInvoice(invoiceId).then(function (data) {
							$.each(data, function (index, p) {
								p.selected = true;
								dataSvc.payrolls.push(p);
								$scope.item.payrollIds.push(p.id);
							});
							$scope.updatePayrollAmounts();


						}, function (error) {
							addAlert('error getting invoices', 'danger');
						});
					}
					var getInvoiceById = function (invoiceId) {
						payrollRepository.getInvoiceById(invoiceId).then(function (data) {
							$scope.item = angular.copy(data);
							$.each($scope.item.payments, function (index, p) {
								p.paymentDate = moment(p.paymentDate).toDate();
							});
							$scope.item.dueDate = moment($scope.item.dueDate).toDate();
							getInvoicePayrolls(invoiceId);
						}, function (error) {
							addAlert('error getting invoices', 'danger');
						});
					}
					$scope.getProgressBarValue = function() {
						return $scope.item.status > 4 ? 80 : $scope.item.status * 25;
					}
					$scope.getProgressType = function() {
						if ($scope.item.status <= 2)
							return 'warning';
						else if ($scope.item.status === 3)
							return 'info';
						else if ($scope.item.status === 4 || $scope.item.status === 7)
							return 'success';
						else if ($scope.item.status === 6)
							return 'danger';
					}

					var init = function () {
						if ($scope.item) {
							$.each($scope.item.payments, function (index, p) {
								p.paymentDate = moment(p.paymentDate).toDate();
							});
							$scope.item.dueDate = moment($scope.item.dueDate).toDate();
							if($scope.item.id)
								getInvoicePayrolls($scope.item.id);
						}
						else if (!$scope.item && $scope.itemId) {
							getInvoiceById($scope.itemId);
							
						}
						
						$scope.datasvc.isBodyOpen = false;
						
					}
					
					init();


				}]
		}
	}
]);
