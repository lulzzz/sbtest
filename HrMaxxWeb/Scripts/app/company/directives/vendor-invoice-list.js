'use strict';

common.directive('vendorInvoiceList', ['zionAPI', '$timeout', '$window','version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/vendor-invoice-list.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'NgTableParams', 'EntityTypes', 'journalRepository', 'payrollRepository',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, journalRepository, payrollRepository) {
					var dataSvc = {
						isBodyOpen: true,
						payees: [],
						maxInvoiceNumber: 0,
						print: false,
						reportFilter: {
							filterStartDate: moment().add(-2, 'week').toDate(),
							filterEndDate: null,
							filter: {
								startDate: moment().add(-2, 'week').toDate(),
								endDate: null,
								years: [],
								month: 0,
								year: 0,
								quarter: 0
							}
						}

					}
					
					$scope.list = [];
					$scope.newItem = null;
					$scope.dt = new Date();
					
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;


					
					$scope.selected = null;
				
					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						sorting: {
							invoiceDate: 'desc'     // initial sorting
						}
					}, {
						total: $scope.list ? $scope.list.length : 0, // length of data
						getData: function (params) {
							$scope.fillTableData(params);
							return $scope.tableData;
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
						dataSvc.print = false;
						dataSvc.isBodyOpen = true;
					}
					
					$scope.set = function(item) {
						$scope.selected = null;
						$timeout(function() {
							$scope.selected = angular.copy(item);
							$scope.selected.invoiceDate = moment($scope.selected.invoiceDate).toDate();
							$scope.selected.dueDate = moment($scope.selected.dueDate).toDate();
							
							dataSvc.isBodyOpen = false;
						}, 1);
						

					}
					$scope.print = function (item) {
						dataSvc.print = true;
						$scope.set(item);
                    }
                   
					$scope.void = function () {
						if ($window.confirm('Are you sure you want to mark this invoice Void?')) {
							var check = $scope.selected;
							journalRepository.voidVendorInvoice(check).then(function (data) {
								var exists = $filter('filter')($scope.list, { id: data.id })[0];
								if (exists) {
									$scope.list.splice($scope.list.indexOf(exists), 1);
								}
								
								$scope.list.push(data);
								$scope.tableParams.reload();
								$scope.fillTableData($scope.tableParams);
								$scope.mainData.showMessage('successfully voided invoice', 'success');
								$scope.cancel();
							}, function (error) {
								$scope.mainData.handleError('error making the invoice void', error, 'danger');
							});
						}
					}
					$scope.save = function () {
						var check = $scope.selected;
						check.invoiceDate = moment(check.invoiceDate).format("MM/DD/YYYY");
						check.dueDate = moment(check.dueDate).format("MM/DD/YYYY");
						journalRepository.saveVendorInvoice(check).then(function (data) {
							dataSvc.maxInvoiceNumber = data.invoiceNumber + 1;
							if (check.id) {
								var match = $filter('filter')($scope.list, { id: check.id })[0];
								var ind = $scope.list.indexOf(match);
								$scope.list[ind] = data;
							}
							else
								$scope.list.push(data);

							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							$scope.mainData.showMessage('successfully saved invoice item', 'success');
							$scope.cancel();
							dataSvc.print = false;
							$scope.set(data);
						}, function (erorr) {
							$scope.set(check);

							$scope.mainData.handleError('error saving invoice item: ', erorr, 'danger');
						});
					}
					
					var addPayeeToVendorCustomers = function (j) {
						var payee = {
							id: j.payeeId,
							payeeName: j.payeeName,
							payeeType: j.entityType,
							displayName: translatePayeeType(j.entityType) + ': ' + j.payeeName
						};
						var exists = $filter('filter')(dataSvc.payees, { id: payee.id })[0];
						if (!exists) {
							dataSvc.payees.push(payee);
						}
						
					}
					
					$scope.getVendorInvoiceList = function () {
						var m = $scope.mainData;
						journalRepository.getVendorInvoiceList(m.selectedCompany.id, dataSvc.reportFilter.filterStartDate, dataSvc.reportFilter.filterEndDate).then(function (data) {
							
							$scope.list = data;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);

						}, function (error) {
							$scope.mainData.handleError('', error, 'danger');
						});
						
					}
					var getMetaData = function (companyId) {
						journalRepository.getVendorInvoiceMetaData(companyId, $scope.mainData.selectedCompany.companyIntId).then(function (data) {
							dataSvc.maxInvoiceNumber = data.maxInvoiceNumber + 1;
							dataSvc.payees = data.payees;
							dataSvc.products = data.products;
						}, function (erorr) {
								$scope.mainData.handleError('' , erorr, 'danger');
						});
					}

					$scope.$watch('mainData.selectedCompany',
						 function (newValue, oldValue) {
						 	if (newValue !== oldValue && $scope.mainData.selectedCompany) {
						 		
								 $scope.selected = null;
						 		getMetaData($scope.mainData.selectedCompany.id);
								 dataSvc.isBodyOpen = true;
							 }

						 }, true
				 );
					$scope.add = function() {
						var newItem = {
							id : 0,
							companyId: $scope.mainData.selectedCompany.id,
							
							invoiceNumber : dataSvc.maxInvoiceNumber,
							
							payeeId : null,
							payeeName : '',
							amount : 0,
							total: 0,
							balance: 0,
							salesTaxRate: $scope.mainData.selectedCompany.salesTaxRate ?? 10 ,
							salesTax: 0,
							discountType: 1,
							discountRate: 0,
							discount: 0,
							invoiceDate: new Date(),
							dueDate: new Date(),
							memo : '',
							
							isVoid : false,
							
							invoiceItems: [],
							invoicePayments: []
						};
						
						$scope.selected = newItem;
						dataSvc.isBodyOpen = false;
					}
					$scope.refresh = function() {
						//getJournals($scope.mainData.selectedCompany.id, dataSvc.selectedAccount.id, null, null);
						$scope.getVendorInvoiceList();
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
