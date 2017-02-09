'use strict';

common.directive('vendorCustomer', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData",
				selected: "=vendor",
				isVendor: "=isVendor",
				isGlobal: "=isGlobal",
				showControls: "=showControls"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/vendor-customer.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'EntityTypes',
				function ($scope, $element, $location, $filter, companyRepository, EntityTypes) {
					
					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};

					
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

					
					$scope.cancel = function () {
						$scope.$parent.$parent.cancel();
					}

					$scope.set = function (item) {
						$scope.selected = null;
						$timeout(function () {
							$scope.selected = angular.copy(item);
							
						}, 1);

					}

					$scope.save = function () {
						if (false === $('form[name="vendorcustomer"]').parsley().validate())
							return false;
						companyRepository.saveVendorCustomer($scope.selected).then(function (result) {
							$scope.$parent.$parent.save(result);
						}, function (error) {
							addAlert('error saving ' + ($scope.isVendor ? 'vendor' : 'customer'), 'danger');
						});
					}
					
					var init = function () {
						if (!$scope.selected.contact) {
							$scope.selected.contact = {
								address: {}
							};
						}
						else if (!$scope.selected.contact.address) {
							$scope.selected.contact.address = {

							};
						}
					}
					init();


				}]
		}
	}
]);
