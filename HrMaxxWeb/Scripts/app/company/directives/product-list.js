'use strict';

common.directive('productList', ['$uibModal', 'zionAPI', 'version',
    function ($modal, zionAPI, version) {
        return {
            restrict: 'E',
            replace: true,
            scope: {
                mainData: "=mainData",
                heading: "=heading",
                showControls: "=showControls"
            },
            templateUrl: zionAPI.Web + 'Areas/Client/templates/product-list.html?v=' + version,

            controller: ['$scope', '$rootScope', '$filter', 'companyRepository', 'NgTableParams',
                function ($scope, $rootScope, $filter, companyRepository, ngTableParams) {
                    var dataSvc = {


                    }
                    $scope.selected = null;

                    var addAlert = function (error, type) {
                        $scope.mainData.showMessage(error, type);
                    };
                    $scope.closeAlert = function (index) {

                    };

                    $scope.add = function () {
                        var item = {
                            id: 0,
                            companyId: $scope.mainData.selectedCompany.id,
                            serialNo: '',
                            name: '',
                            type: null,
                            costPrice: 0,
                            salePrice: 0,
                            isTaxable: true
                        };

                        $scope.set(item);
                    },


                        $scope.set = function (p) {

                            $scope.selected = p;
                            $scope.showProduct();
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

                    $scope.showProduct = function (listitem) {
                        var modalInstance = $modal.open({
                            templateUrl: 'popover/product.html',
                            controller: 'productCtrl',
                            size: 'sm',
                            windowClass: 'my-modal-popup',
                            backdrop: 'static',
                            resolve: {
                                product: function () {
                                    return $scope.selected;
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

                            if (!$scope.selected.id) {

                                $scope.list.push(scope.product);
                            }
                            else {
                                var match1 = $filter('filter')($scope.list, { id: scope.product.id })[0];
                                $scope.list[$scope.list.indexOf(match1)] = angular.copy(scope.product);
                            }
                            $scope.tableParams.reload();
                            $scope.fillTableData($scope.tableParams);
                            $scope.selected = null;

                            addAlert('successfully saved product', 'success');

                        }, function () {
                            if ($scope.selected && !$scope.selected.id)
                                $scope.list.splice($scope.list.indexOf($scope.selected), 1);
                            $scope.selected = null;

                        });
                    }
                    $scope.getProducts = function (companyId) {
                        companyRepository.getProducts(companyId).then(function (data) {
                            $scope.list = data;
                            $scope.tableParams.reload();
                            $scope.fillTableData($scope.tableParams);
                            $scope.selected = null;

                        }, function (erorr) {
                            $scope.mainData.showMessage('error getting products and services list', 'danger');
                        });
                    }

                    $scope.$watch('mainData.selectedCompany',
                        function (newValue, oldValue) {
                            if (newValue !== oldValue) {
                                $scope.getProducts($scope.mainData.selectedCompany.id);
                            }

                        }, true
                    );
                    var init = function () {
                        if ($scope.mainData.selectedCompany)
                            $scope.getProducts($scope.mainData.selectedCompany.id);

                    }
                    init();



                }]
        }
    }
]);
common.controller('productCtrl', function ($scope, $uibModalInstance, $filter, product, repository, company) {
    $scope.original = product;
    $scope.product = angular.copy(product);
    $scope.repository = repository;
    $scope.company = company;
    $scope.changesMade = false;
    if (!$scope.product.id)
        $scope.isNew = true;

    $scope.hasChanges = function () {
        return !angular.equals($scope.product, $scope.original);
    }
    $scope.isProductValid = function () {
        var item = $scope.product;
        if (!item.companyId || !item.name || !item.type || !item.costPrice || !item.salePrice)
            return false;
        else
            return true;
    }
    $scope.save = function () {
        $scope.isClosed = false;
        $scope.repository.saveProduct($scope.product).then(function (data) {
            $scope.product.id = data.id;
            $uibModalInstance.close($scope);


        }, function (error) {

        });
    }
    $scope.cancel = function () {

        $uibModalInstance.dismiss();
    }




});

