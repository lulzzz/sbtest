'use strict';

common.directive('vendorCustomerList', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData",
				isVendor: "=isVendor",
				isGlobal: "=isGlobal",
				heading: "=heading"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/vendor-customer-list.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'ngTableParams', 'EntityTypes',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes) {
					var dataSvc = {
						sourceTypeId: $scope.isVendor ? EntityTypes.Vendor : EntityTypes.Customer,
						isBodyOpen: true
					}

					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;


					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};

					$scope.selected = null;


					$scope.add = function () {
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
							isVendor1099: $scope.isVendor

						};

						$scope.set(selected);
					}
					$scope.validate = function () {
						var ctx = $scope.selected;
						if (!ctx.name || !ctx.statusId)
							return false;
						else if (!ctx.contact || !ctx.contact.firstName || !ctx.contact.lastName || !ctx.contact.email || !ctx.contact.address || !ctx.contact.address.addressLine1 || !ctx.contact.address.countryId || !ctx.contact.address.stateId || !ctx.contact.address.zip)
							return false;
						else if ($scope.isVendor) {
							if (ctx.isVendor1099) {
								if (!ctx.identifierType || !ctx.type1099 || !ctx.subType1099)
									return false;
								else if ((ctx.identifierType === 1 && !ctx.individualSSN) || (ctx.identifierType === 2 && !ctx.businessFIN))
									return false;
								else if ((ctx.type1099 === 1 && !(ctx.subType1099 > 0 && ctx.subType1099 < 4)) || (ctx.type1099 === 2 && !(ctx.subType1099 === 4)) || (ctx.type1099 === 3 && !(ctx.subType1099 > 4 && ctx.subType1099 < 9)))
									return false;
							}
						}

						return true;


					}

					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						filter: {
							name: '',       // initial filter
						},
						sorting: {
							name: 'asc'     // initial sorting
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
							dataSvc.isBodyOpen = false;
						}, 1);

					}

					$scope.save = function () {
						if (false === $('form[name="vendorcustomer"]').parsley().validate())
							return false;
						companyRepository.saveVendorCustomer($scope.selected).then(function (result) {

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
							addAlert('successfully saved ' + ($scope.isVendor ? 'vendor' : 'customer'), 'success');
						}, function (error) {
							addAlert('error saving ' + ($scope.isVendor ? 'vendor' : 'customer'), 'danger');
						});
					}
					$scope.getVendorCustomers = function (companyId) {
						companyRepository.getVendorCustomers(companyId, $scope.isVendor).then(function (data) {
							$scope.list = data;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);
							$scope.selected = null;
						}, function (erorr) {
							addAlert('error getting ' + ($scope.isVendor ? 'vendor' : 'customer') + ' list', 'danger');
						});
					}

					$scope.$watch('mainData.selectedCompany',
						 function (newValue, oldValue) {
						 	if (newValue !== oldValue) {
						 		$scope.getVendorCustomers($scope.mainData.selectedCompany.id);
						 	}

						 }, true
				 );
					var init = function () {

						if (!$scope.isGlobal) {
							if ($scope.mainData.selectedCompany)
								$scope.getVendorCustomers($scope.mainData.selectedCompany.id);
						} else {
							$scope.getVendorCustomers(null);
						}



					}
					init();


				}]
		}
	}
]);
