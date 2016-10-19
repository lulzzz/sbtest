'use strict';

common.directive('payrollInvoice', ['$uibModal', 'zionAPI', '$timeout', '$window','version',
	function ($modal, zionAPI, $timeout, $window,version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				invoice: "=invoice",
				datasvc: "=datasvc",
				host: "=host",
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/payroll-invoice.html?v=2.3.' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'ngTableParams', 'EntityTypes', 'payrollRepository', 'commonRepository', 'hostRepository',
				function ($scope, $element, $location, $filter, ngTableParams, EntityTypes, payrollRepository, commonRepository, hostRepository) {
					var dataSvc = {
						hostContact: null,
						companyContact: null,
						hostHomePage: null,
						config: null

				}
					$scope.company = $scope.invoice.company;
					$scope.list = [];
					$scope.dt = new Date();
					

					$scope.data = dataSvc;
					$scope.cancel = function () {
						$scope.$parent.$parent.cancel();
					}

					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					
					$scope.getLineItemTotal = function () {
						var linesAmount = +($scope.invoice.adminFee + $scope.invoice.environmentalFee).toFixed(2);
						$.each($scope.invoice.miscCharges, function (index, lineitem) {
							var am = parseFloat(lineitem.amount);
							linesAmount += +am.toFixed(2);
						});
						return linesAmount;
					}
					$scope.getHostLogo = function() {
						if (dataSvc.hostHomePage && dataSvc.hostHomePage.logo) {
							var photo = dataSvc.hostHomePage.logo;
							return zionAPI.URL + 'DocumentById/' + photo.id + '/' + photo.documentExtension + '/' + photo.documentName;
						} else {
							return "https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg";
						}
					}
					$scope.getTotal = function() {
						var total = 0;
						
						total += +($scope.getLineItemTotal()).toFixed(2);
						
						if ($scope.invoice.companyInvoiceSetup.invoiceType === 1)
						{
							total += +($scope.invoice.grossWages).toFixed(2);
							total += +($scope.invoice.employerContribution).toFixed(2);
							total += +($scope.invoice.workerCompensationCharges).toFixed(2);
						}
						else if ($scope.invoice.companyInvoiceSetup.invoiceType === 2)
						{
							total += +($scope.invoice.employeeContribution).toFixed(2);
							total += +($scope.invoice.employerContribution).toFixed(2);
							total += +($scope.invoice.workerCompensationCharges).toFixed(2);

						}
						else if ($scope.invoice.companyInvoiceSetup.invoiceType === 4)
						{
							total += +($scope.invoice.workerCompensationCharges).toFixed(2);
						}
						else if ($scope.invoice.companyInvoiceSetup.invoiceType === 5) {
							total = +($scope.invoice.workerCompensationCharges).toFixed(2);
						}
						return total;
					}
					$scope.updateWC = function() {
						var wctotal = 0;
						$.each($scope.invoice.workerCompensations, function (index, wc1) {
							if ($scope.invoice.applyWCMinWageLimit && wc1.workerCompensation.minGrossWage && wc1.originalWage < wc1.workerCompensation.minGrossWage)
								wc1.wage = wc1.workerCompensation.minGrossWage;
							else {
								wc1.wage = wc1.originalWage;
							}
							
							wc1.amount = +(wc1.wage * wc1.workerCompensation.rate / 100).toFixed(2);
							wctotal += wc1.amount;
						});
						$scope.invoice.workerCompensationCharges = +wctotal.toFixed(2);
						$scope.invoice.total = $scope.getTotal();
					}
					$scope.addLineItem = function() {
						var lineitem = {
							description:'',
							amount: 0,
							recurringChargeId: 0,
							payCheckId: -1,
							isEditable:true
						}
						$scope.invoice.miscCharges.push(lineitem);
						
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
						$scope.invoice.payments.push(payment);
					}
					$scope.isInvoiceEditable = function() {
						if ($scope.invoice.status !== 4 || $scope.mainData.userRole === 'Master' || $scope.mainData.userRole === 'CorpStaff')
							return true;
						else
							return false;
					}
					$scope.isPaymentEditable = function (p) {
						if (p.status === 1 || $scope.mainData.userRole === 'Master' || $scope.mainData.userRole === 'CorpStaff')
							return true;
						else
							return false;
					}
					$scope.paymentRemaining = function() {
						var paidamount = 0;
						$.each($scope.invoice.payments, function (index, lineitem) {
							if(lineitem.status!==4){
								var am = parseFloat(lineitem.amount);
								paidamount += +am.toFixed(2);
							}
						});
						return +($scope.invoice.total - paidamount).toFixed(2);
					}
					$scope.unsavedPayments = false;
					$scope.deletelineitem = function (index, lineitem) {
						$scope.$parent.$parent.$parent.$parent.confirmDialog('Are you sure you want to delete this line item?', 'warning', function () {
							if (lineitem.payCheckId) {
								$scope.invoice.voidedCreditedChecks.splice($scope.invoice.voidedCreditedChecks.indexOf(lineitem.payCheckId), 1);
							}
							$scope.invoice.miscCharges.splice(index, 1);
							$scope.invoice.miscFees -= +lineitem.amount.toFixed(2);
							$scope.invoice.total = $scope.getTotal();
							$scope.invoice.deleted = true;
						});
						
						
					}
					$scope.deletepayment = function (index) {
						$scope.$parent.$parent.$parent.$parent.confirmDialog('Are you sure you want to delete this payment?', 'warning', function () {
							$scope.invoice.payments.splice(index, 1);
							$scope.invoice.deleted = true;
						});
						
					}
					
					$scope.isLineItemValid = function(li) {
						if (!li.description || !parseFloat(li.amount))
							return false;
						else
							return true;
					}

					$scope.isInvoiceInvalid = function() {
						var invoice = $scope.invoice;
						if (!invoice.invoiceNumber)
							return 'Please enter a valid Invoice Number';
						else if (!invoice.total || invoice.total<=0)
							return 'The invoice total must be greated than 0';
						else if (invoice.miscCharges.length > 0) {
							var returnVal = true;
							$.each(invoice.miscCharges, function (index, p) {
								if (!$scope.isLineItemValid(p)) {
									returnVal = false;
									return false;
								}
							});
							if(!returnVal)
								return 'Please add correct fee(s) and charge(s)';
						}
						else
							return '';
					}
					$scope.print = function () {
						$window.print();
					}
					$scope.save = function() {
						if (false === $('form[name="invoice"]').parsley().validate()) {
							var errors = $('.parsley-error');
							return false;
						}
						var validation = $scope.isInvoiceInvalid();
						if (validation) {
							addAlert(validation, 'warning');
							return false;
						}
						if ($scope.invoice.deleted) {
							$scope.$parent.$parent.$parent.$parent.confirmDialog('you have delete charges/payments. Do you want to proceed?', 'danger', saveInvoice);
						}
						else
							saveInvoice();


					};
					var saveInvoice = function() {
						payrollRepository.savePayrollInvoice($scope.invoice).then(function (data) {
							$timeout(function () {
								$scope.invoice = data;
								fixDates();
								$scope.updateParent();
								addAlert('successfully saved invoice', 'success');
							});


						}, function (error) {
							addAlert('error saving invoice', 'danger');
						});
					}
					$scope.delete = function () {
						payrollRepository.deletePayrollInvoice($scope.invoice).then(function (data) {
							$timeout(function () {
								$scope.$parent.$parent.deleteInvoice($scope.invoice);
								addAlert('successfully deleted invoice', 'success');
							});


						}, function (error) {
							addAlert('error deleting invoice', 'danger');
						});
					};
					$scope.saveWithStatus = function (status) {
						$scope.invoice.status = status;
						$scope.save();

					}
					$scope.updateParent = function() {
						$scope.$parent.$parent.updateSelectedInvoice($scope.invoice);
					}
					$scope.getProgressBarValue = function() {
						return $scope.invoice.status > 4 ? 80 : $scope.invoice.status * 25;
					}
					$scope.getProgressType = function() {
						if ($scope.invoice.status <= 2)
							return 'warning';
						else if ($scope.invoice.status === 3)
							return 'info';
						else if ($scope.invoice.status === 4 || $scope.invoice.status === 7)
							return 'success';
						else if ($scope.invoice.status === 6)
							return 'danger';
					}
					var getHostContact = function() {
						commonRepository.getRelatedEntities(EntityTypes.Host, EntityTypes.Contact, $scope.invoice.company.hostId).then(function (data) {
							var primary = $filter('filter')(data, { isPrimary: true })[0];
							if (primary)
								dataSvc.hostContact = primary;
							else if (data.length > 0)
								dataSvc.hostContact = data[0];
						}, function (error) {
							
						});
						hostRepository.getHomePage($scope.invoice.company.hostId).then(function (data) {
							dataSvc.hostHomePage = data;
						}, function (error) {

						});
					}
					var getCompanyContact = function () {
						commonRepository.getRelatedEntities(EntityTypes.Company, EntityTypes.Contact, $scope.invoice.company.id).then(function (data) {

							var primary = $filter('filter')(data, { isPrimary: true })[0];
							if (primary)
								dataSvc.companyContact = primary;
							else if (data.length > 0)
								dataSvc.companyContact = data[0];
						}, function (error) {

						});
					}
					$scope.getContactPhone = function(c) {
						var p = '';
						if (c) {
							p = c.phone ? c.phone : (c.mobile ? c.mobile : '');
						}
						if (p)
							return '(' + p.substring(0, 3) + ') ' + p.substring(3, 7) + '-' + p.substring(7, 12);
						else {
							return '';
						}
					}
					var fixDates = function() {
						$.each($scope.invoice.payments, function (index, p) {
							p.paymentDate = moment(p.paymentDate).toDate();

						});
						$scope.invoice.invoiceDate = moment($scope.invoice.invoiceDate).toDate();
					
					}
					var init = function () {
						if ($scope.invoice) {
							fixDates();
							getHostContact();
							getCompanyContact();
							commonRepository.getConfigData().then(function (result) {
								dataSvc.config = angular.copy(result);

							}, function (error) {
								
							});
						}
					}
					
					init();


				}]
		}
	}
]);
