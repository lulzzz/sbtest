'use strict';

common.directive('invoiceList', ['$modal', 'zionAPI', '$timeout', '$window',
	function ($modal, zionAPI, $timeout, $window) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/invoice-list.html',

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'ngTableParams', 'EntityTypes', 'payrollRepository',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, payrollRepository) {
					var dataSvc = {
						sourceTypeId: EntityTypes.Employee,
						isBodyOpen: true,
						opened: false,
						opened1: false,
						opened2: false,
						payrolls: [],
						startingInvoiceNumber: 0,
						invoiceMethod: 2,
						invoiceRate:0
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


					$scope.add = function () {
						var committedPayrolls = $filter('filter')(dataSvc.payrolls, { status: 3 });
						if (committedPayrolls.length === 0) {
							addAlert('No Payrolls available to be invoiced!', 'info');
							return;
						}
						var selected = {
							companyId: $scope.mainData.selectedCompany.id,
							invoiceDate: new Date(),
							dueDate: moment().add(2, 'week'),
							invoiceMethod: $scope.mainData.selectedCompany.contract.method,
							invoiceRate: $scope.mainData.selectedCompany.contract.invoiceCharge,
							invoiceNumber: dataSvc.startingInvoiceNumber,
							invoiceValue: 0,
							payrollValue: 0,
							lineItemTotal: 0,
							total: 0,
							status: 1,
							riskLevel: 1,
							lineItems: [],
							payments: [],
							payrollIds: []
						};
						
						$scope.set(selected);
					}
				
					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						sorting: {
							invoiceDate: 'desc'     // initial sorting
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
					$scope.invoiceSaved = function (item, payrollIds) {
						var exists = $filter('filter')($scope.list, { id: item.id })[0];
						if (exists) {
							$scope.list.splice($scope.list.indexOf(exists), 1);
						}
						$scope.list.push(item);
						$scope.tableParams.reload();
						$scope.fillTableData($scope.tableParams);
						$.each(payrollIds, function (index, p) {
							var payroll = $filter('filter')(dataSvc.payrolls, { id: p })[0];
							if (payroll) {
								payroll.invoiceId = item.id;
								payroll.status = 4;
							}
						});
						dataSvc.payrolls = $filter('filter')(dataSvc.payrolls, { status: 3 });
					}
					
					$scope.set = function (item) {
						$scope.selected = null;
						
						$timeout(function () {
							$scope.selected = angular.copy(item);
							
						}, 1);

					}
					
					$scope.submit = function (item) {
						item.status = 2;
						
						payrollRepository.saveInvoice(item).then(function (data) {
							$timeout(function () {
								$scope.selected = null;
								item.status = data.status;
								item.statusText = data.statusText;
								item.submittedOn = data.submittedOn;
								item.submittedBy = data.submittedBy;
								$scope.addAlert('successfully submitted invoice', 'success');
								dataSvc.isBodyOpen = true;
							});


						}, function (error) {
							addAlert('error submitting invoice', 'danger');
						});

					}
					$scope.deliver = function (item) {
						item.status = 3;
						
						payrollRepository.saveInvoice(item).then(function (data) {
							$timeout(function () {
								$scope.selected = null;
								item.status = data.status;
								item.statusText = data.statusText;
								item.deliveredOn = data.deliveredOn;
								item.deliveredBy = data.deliveredBy;
								$scope.addAlert('successfully marked the invoice delivered', 'success');
								dataSvc.isBodyOpen = true;
							});


						}, function (error) {
							addAlert('error marking the invoice delivered', 'danger');
						});

					}
					$scope.showInvoices = function () {
						var comp = $scope.mainData.selectedCompany;
						if (comp && comp.contract.contractOption === 2 && comp.contract.billingOption === 3) {
							return true;
						} else {
							return false;
						}
					}
					var getCompanyInvoiceMetaData = function (companyId) {
						companyRepository.getInvoiceMetaData(companyId).then(function (data) {
							dataSvc.payrolls = data.payrolls;
							dataSvc.startingInvoiceNumber = data.startingInvoiceNumber;
						}, function (error) {
							$scope.addAlert('error getting invoice meta data', 'danger');
						});
					}

					var getInvoices = function (companyId, selected) {
						payrollRepository.getInvoicesForCompany(companyId).then(function (data) {
							$scope.list = data;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							if (selected) {
								var founditem = $filter('filter')($scope.list, { id: selected.id })[0];
								if (founditem) {
									$scope.set(founditem);
								}
							}
							
						}, function (error) {
							$scope.addAlert('error getting invoices', 'danger');
						});
					}
					
					$scope.$watch('mainData.selectedCompany',
						 function (newValue, oldValue) {
						 	if (newValue !== oldValue) {
						 		var comp = $scope.mainData.selectedCompany;
						 		getCompanyInvoiceMetaData(comp.id);
						 		getInvoices(comp.id, null);
						 	}

						 }, true
				 );
					
					var init = function () {
						var comp = $scope.mainData.selectedCompany;
						if (comp && comp.contract.contractOption === 2 && comp.contract.billingOption === 3) {
							getCompanyInvoiceMetaData(comp.id);
							getInvoices(comp.id, null);

						}
						

					}
					init();


				}]
		}
	}
]);
