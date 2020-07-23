'use strict';

common.directive('account', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData",
				selected: "=selected",
				types: "=?types",
				subTypes: "=?subTypes",
				selectedType: "=?selectedType",
				selectedSubType: "=?selectedSubType",
				isPopup: "=?isPopup"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/account.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'companyRepository', 'NgTableParams', 'EntityTypes', 'commonRepository', 'journalRepository',
				function ($scope, $element, $location, $filter, companyRepository, ngTableParams, EntityTypes, commonRepository, journalRepository) {
					var dataSvc = {
						sourceTypeId: EntityTypes.Company,
						types: $scope.types,
						subTypes: $scope.subTypes,
						selectableSubTypes: [],
						selectedType: null,
						selectedSubType: null,
						isBodyOpen: true
					}
					
					$scope.data = dataSvc;
					$scope.cancel = function () {
						if ($scope.isPopup) {
							$scope.$parent.cancel();
						}
						else {
							
							$scope.$parent.$parent.cancel();
						}
                    }
					$scope.saveAccount = function () {
						if (false === $('form[name="account"]').parsley().validate())
							return false;
						companyRepository.saveCompanyAccount($scope.selected).then(function (result) {
							if ($scope.isPopup) {
								$scope.$parent.save(result);
							}
							else {
								$scope.selected = result;
								$scope.$parent.$parent.save(result);			
                            }
												
							
						}, function (error) {
							$scope.mainData.showMessage('error saving account', 'danger');
						});
					}
					
					$scope.typeSelected = function () {
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
						if ($scope.selected.id || $scope.selected.subType) {
							dataSvc.selectedSubType = $filter('filter')(dataSvc.subTypes, { key: $scope.selected.subType })[0];
						}
					}
					$scope.subTypeSelected = function () {
						$scope.selected.subType = dataSvc.selectedSubType.key;
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
					$scope.isBank = function () {
						if ($scope.selected.type === 1 && $scope.selected.subType === 2)
							return true;
						return false;
					}
					var init = function () {
						if (!dataSvc.types) {
							commonRepository.getAccountsMetaData().then(function (data) {
								dataSvc.types = data.types;
								dataSvc.subTypes = data.subTypes;
								if ($scope.selectedType) {
									dataSvc.selectedType = $filter('filter')(dataSvc.types, { key: $scope.selectedType })[0];
									$scope.typeSelected();
                                }
									
							}, function (erorr) {

							});
                        }
						if ($scope.selected.id) {
							dataSvc.selectedType = $filter('filter')(dataSvc.types, { key: $scope.selected.type })[0];
							
                        }
							
						if (dataSvc.selectedType) {
							$scope.typeSelected();
							
                        }

					}
					
					init();


				}]
		}
	}
]);
