'use strict';

common.directive('accountList', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData",
				isVendor: "=isVendor"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/account-list.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'ngTableParams', 'EntityTypes', 'commonRepository', 'journalRepository',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, commonRepository, journalRepository) {
					var dataSvc = {
						sourceTypeId: EntityTypes.Company,
						types: [],
						subTypes: [],
						selectableSubTypes: [],
						selectedType: null,
						selectedSubType: null,
						isBodyOpen: true,
						
						filter: {
							years: [],
							month: 0,
							year: 0
						}
					}
					var currentYear = new Date().getFullYear();
					dataSvc.filter.year = currentYear;
					for (var i = currentYear - 4; i <= currentYear + 4; i++) {
						dataSvc.filter.years.push(i);
					}
					$scope.dt = new Date();
					
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;


					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					
					$scope.selected = null;


					$scope.add = function () {
						dataSvc.selectedType = null;
						dataSvc.selectedSubType = null;
						var selected = {
							companyId: $scope.mainData.selectedCompany.id,
							type: null,
							subType: null,
							name: null,
							taxCode: null,
							openingBalance: 0,
							templateId: null,
							bankAccount: null,
							useInPayroll: false,
							isBank: function() {
								if (type === 1 && subType === 2)
									return true;
								return false;
							}

						};
						
						$scope.set(selected);
					}
					

					$scope.tableData = [];
					
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						filter: {
							name: '',       // initial filter
						},
						sorting: {
							typeText: 'asc'     // initial sorting
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

					$scope.set = function (item) {
						$scope.selected = null;
						$timeout(function () {
							$scope.selected = angular.copy(item);
							if ($scope.selected.openingDate)
								$scope.selected.openingDate = moment($scope.selected.openingDate).toDate();
							if ($scope.selected.id) {
								dataSvc.selectedType = $filter('filter')(dataSvc.types, { key: $scope.selected.type })[0];
								dataSvc.selectedSubType = $filter('filter')(dataSvc.subTypes, { key: $scope.selected.subType })[0];
								$scope.typeSelected();
								$scope.tableParamsRegister.reload();
								$scope.fillTableDataRegister($scope.tableParamsRegister);
							}
							dataSvc.isBodyOpen = false;
						}, 1);

					}

					$scope.save = function () {
						if (false === $('form[name="account"]').parsley().validate())
							return false;
						companyRepository.saveCompanyAccount($scope.selected).then(function (result) {

							var exists = $filter('filter')($scope.list, { id: result.id });
							if (exists.length === 0) {
								$scope.list.push(result);
							} else {
								$scope.list.splice($scope.list.indexOf(exists[0]), 1);
								$scope.list.push(result);
							}
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							$scope.selected = null;
							dataSvc.isBodyOpen = true;
							addAlert('successfully saved account', 'success');
						}, function (error) {
							addAlert('error saving account', 'danger');
						});
					}
					$scope.filterByDateRange = function () {
						dataSvc.filterStartDate = dataSvc.filter.startDate ? dataSvc.filter.startDate : null;
						dataSvc.filterEndDate = dataSvc.filter.endDate ? dataSvc.filter.endDate : null;
						dataSvc.filter.filterByMonthYear = false;
						dataSvc.filter.filterByPeriod = false;

						$scope.getCompanyAccounts($scope.mainData.selectedCompany.id);
					}
					$scope.filterByMonthYear = function () {
						if (!dataSvc.filter.month) {
							dataSvc.filterStartDate = moment('01/01/' + dataSvc.filter.year).format('MM/DD/YYYY');
							dataSvc.filterEndDate = moment(dataSvc.filterStartDate).endOf('year').format('MM/DD/YYYY');
						} else {
							dataSvc.filterStartDate = moment(dataSvc.filter.month + '/01/' + dataSvc.filter.year).format('MM/DD/YYYY');
							var test1 = moment(dataSvc.filterStartDate).endOf('month');
							var test = moment(dataSvc.filterStartDate).endOf('month').date();
							dataSvc.filterEndDate = moment(dataSvc.filterStartDate).endOf('month').format('MM/DD/YYYY');
						}

						dataSvc.filter.filterByDateRange = false;
						dataSvc.filter.filterByPeriod = false;

						$scope.getCompanyAccounts($scope.mainData.selectedCompany.id);
					}
					$scope.filterByPeriod = function () {
						if (dataSvc.filter.period === 1) {
							dataSvc.filterStartDate = null;
							dataSvc.filterEndDate = null;
						}
						else if (dataSvc.filter.period === 2) {
							dataSvc.filterEndDate = new Date();
							dataSvc.filterStartDate = moment(dataSvc.filterEndDate).add(-3, 'months').format('MM/DD/YYYY');
						}
						else if (dataSvc.filter.period === 3) {
							dataSvc.filterEndDate = new Date();
							dataSvc.filterStartDate = moment(dataSvc.filterEndDate).add(-6, 'months').format('MM/DD/YYYY');
						}
						else if (dataSvc.filter.period === 4) {
							dataSvc.filterEndDate = new Date();
							dataSvc.filterStartDate = moment(dataSvc.filterEndDate).add(-1, 'years').format('MM/DD/YYYY');
						}

						dataSvc.filter.filterByMonthYear = false;
						dataSvc.filter.filterByDateRange = false;

						$scope.getCompanyAccounts($scope.mainData.selectedCompany.id);
					}
					$scope.getCompanyAccounts = function(companyId) {
						journalRepository.getAccountJournalList(companyId, dataSvc.filterStartDate, dataSvc.filterEndDate).then(function (data) {
							$scope.list = data;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							$scope.selected = null;
							dataSvc.isBodyOpen = true;
						}, function (erorr) {
							addAlert('error getting account list', 'danger');
						});
					}

					$scope.$watch('mainData.selectedCompany',
						 function (newValue, oldValue) {
						 	if (newValue !== oldValue) {
						 		$scope.getCompanyAccounts($scope.mainData.selectedCompany.id);
							 }

						 }, true
				 );
					$scope.typeSelected = function() {
						$scope.selected.type = dataSvc.selectedType.key;
						dataSvc.selectableSubTypes = [];
						var idStart = 0;
						var idEnd = 0;
						if ($scope.selected.type === 1) {
							idStart = 1;
							idEnd = 4;
						}
						else if ($scope.selected.type === 2) {
							idStart = 5;
							idEnd = 7;
						}
						else if ($scope.selected.type === 3) {
							idStart = 8;
							idEnd = 21;
						}
						else if ($scope.selected.type === 4) {
							idStart = 22;
							idEnd = 24;
						}
						else if ($scope.selected.type === 5) {
							idStart = 25;
							idEnd = 26;
						}
						$.each(dataSvc.subTypes, function (index, subtype) {
							if (subtype.key >= idStart && subtype.key <= idEnd) {
								dataSvc.selectableSubTypes.push(subtype);
							}
						});
					}
					$scope.validateRoutingNumber = function (rtn) {
						if (!rtn) {
							return true;
						}
						if (rtn === '000000000')
							return false;
						//Calculate Check Digit

						var sum = (rtn.charAt(0)) * 3;
						sum += (rtn.charAt(1)) * 7;
						sum += (rtn.charAt(2)) * 1;
						sum += (rtn.charAt(3)) * 3;
						sum += (rtn.charAt(4)) * 7;
						sum += (rtn.charAt(5)) * 1;
						sum += (rtn.charAt(6)) * 3;
						sum += (rtn.charAt(7)) * 7;

						sum = sum % 10;

						sum = 10 - sum;
						if (sum == 10)
							sum = 0;

						if (sum == (rtn.charAt(8) - '0'))
							return true;

						return false;
					}
					$scope.subTypeSelected = function () {
						$scope.selected.subType = dataSvc.selectedSubType.key;
					}
					$scope.isBank = function() {
						if ($scope.selected.type === 1 && $scope.selected.subType === 2)
							return true;
						return false;
					}
					var init = function () {
						commonRepository.getAccountsMetaData().then(function (data) {
							dataSvc.types = data.types;
							dataSvc.subTypes = data.subTypes;
						}, function (erorr) {
							
						});
						if ($scope.mainData.selectedCompany) {
							$scope.getCompanyAccounts($scope.mainData.selectedCompany.id);
						}
						

					}
					$scope.tableDataRegister = [];
					$scope.tableParamsRegister = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						filter: {
							payee: '',       // initial filter
						},
						sorting: {
							transactionDate: 'desc'     // initial sorting
						}
					}, {
						total: $scope.selected && $scope.selected.journals.length > 0 ? $scope.selected.journals.length : 0, // length of data
						getData: function ($defer, params) {
							$scope.fillTableDataRegister(params);
							$defer.resolve($scope.tableDataRegister);
						}
					});
					$scope.fillTableDataRegister = function (params) {
						// use build-in angular filter
						if ($scope.selected && $scope.selected.journals.length > 0) {
							var orderedData = params.filter() ?
																$filter('filter')($scope.selected.journals, params.filter()) :
																$scope.selected.journals;

							orderedData = params.sorting() ?
														$filter('orderBy')(orderedData, params.orderBy()) :
														orderedData;

							$scope.tableParamsRegister = params;
							$scope.tableDataRegister = orderedData.slice((params.page() - 1) * params.count(), params.page() * params.count());

							params.total(orderedData.length); // set total for recalc pagination
						}
					};
					init();


				}]
		}
	}
]);
