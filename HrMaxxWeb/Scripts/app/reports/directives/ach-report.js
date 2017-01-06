'use strict';
common.directive('achReport', ['zionAPI', '$timeout', '$window', 'version', '$uibModal',
	function (zionAPI, $timeout, $window, version, $modal) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/ach-report.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'payrollRepository', 'reportRepository', 'ngTableParams',
				function ($scope, $element, $location, $filter, payrollRepository, reportRepository, ngTableParams) {
					var dataSvc = {
						startDate: null,
						endDate: null,
						postingDate: moment().toDate(),
						extract: null,
						extractFiled: false,
						isBodyOpen: true
					}
					
					$scope.list = [];
					$scope.selected = null;
					$scope.toggleAll = function() {
						$.each($scope.selectedHost.achTransactions, function(i, t) {
							t.included = $scope.selectedHost.toggleState;
						});
					}
					$scope.tableData = [];
					$scope.tableParams = new ngTableParams({
						page: 1,            // show first page
						count: 10,

						sorting: {
							lastModified: 'desc'     // initial sortingf.
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
					$scope.setItem = function (item) {
						$scope.selected = null;
						dataSvc.extract = null;
						$scope.selected = item;
						showReview(item.extract.report, item.extract, true);


					}

					var getExtracts = function () {
						reportRepository.getACHExtractList().then(function (data) {
							$scope.list = data;
							$scope.tableParams.reload();
							$scope.fillTableData($scope.tableParams);

						}, function (error) {
							$scope.addAlert('error getting extract list for report: ACH', 'danger');
						});
					}

					$scope.refresh = function () {
						getExtracts();

					}
					$scope.downloadFile = function () {
						reportRepository.downloadExtract(dataSvc.extract.file).then(function (data) {

							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
						}, function (erorr) {
							addAlert('Failed to download report ' + $scope.masterExtract.extract.report.description + ': ' + erorr, 'danger');
						});
					};
					$scope.selectedHost = null;
					$scope.set = function (host) {
						
						$scope.selectedHost = host;
						
					}
					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = false;
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;

					
					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					$scope.view = function (ach) {
						if (ach.transactionType === 1) {
							var modalInstance = $modal.open({
								templateUrl: 'popover/viewpaycheck.html',
								controller: 'paycheckPopupACHCtrl',
								size: 'lg',
								resolve: {
									paycheck: function() {
										return ach.sourceId;
									}
								}
							});
						} else {
							var modalInstance1 = $modal.open({
								templateUrl: 'popover/viewinvoice.html',
								controller: 'invoicePopupACHCtrl',
								size: 'lg',
								windowClass: 'my-modal-popup',
								backdrop: true,
								keyboard: true,
								backdropClick: true,
								resolve: {
									invoiceId: function () {
										return ach.sourceParentId;
									},
									mainData: function() {
										return $scope.mainData;
									},
									selectedHost: function() {
										return $scope.selectedHost;
									}
								}
							});
						}
						
					}
					
					var showReview = function (report, extract, extractFiled) {
						dataSvc.extract = extract;
						if (dataSvc.extract && dataSvc.extract.data.hosts.length > 0) {
							$timeout(function () {
								handleUnlimitedTabsRender();
							}, 1);
							$scope.set(dataSvc.extract.data.hosts[0]);
							dataSvc.extractFiled = extractFiled;
						}
					}
					$scope.getReport = function () {
						var m = $scope.mainData;
						var request = {
							reportName: 'ACHReport',
							startDate: moment(dataSvc.startDate).format("MM/DD/YYYY"),
							endDate: moment(dataSvc.endDate).format("MM/DD/YYYY"),
							depositDate: moment(dataSvc.postingDate).format("MM/DD/YYYY")
						}
						$scope.selected = null;
						reportRepository.getACHReport(request).then(function (extract) {
							showReview(request, extract, false);
							

						}, function (erorr) {
							dataSvc.extract = null;
							addAlert('Error getting ACH Extract: ' + erorr.statusText, 'danger');
						});
					}
					$scope.getACHDocumentAndFile = function () {
						reportRepository.getACHDocumentAndFile(dataSvc.extract).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
							dataSvc.extractFiled = true;
							$scope.refresh();
						}, function (erorr) {
							addAlert('Failed to download ACH extract : ' + erorr, 'danger');
						});

					};
					
					var _init = function () {
						getExtracts();
					}
					_init();
					var handleUnlimitedTabsRender = function () {

						// function handle tab overflow scroll width 
						function handleTabOverflowScrollWidth(obj, animationSpeed) {
							var marginLeft = parseInt($(obj).css('margin-left'));
							var viewWidth = $(obj).width();
							var prevWidth = $(obj).find('li.active').width();
							var speed = (animationSpeed > -1) ? animationSpeed : 150;
							var fullWidth = 0;

							$(obj).find('li.active').prevAll().each(function () {
								prevWidth += $(this).width();
							});

							$(obj).find('li').each(function () {
								fullWidth += $(this).width();
							});

							if (prevWidth >= viewWidth) {
								var finalScrollWidth = prevWidth - viewWidth;
								if (fullWidth != prevWidth) {
									finalScrollWidth += 40;
								}
								$(obj).find('.nav.nav-tabs').animate({ marginLeft: '-' + finalScrollWidth + 'px' }, speed);
							}

							if (prevWidth != fullWidth && fullWidth >= viewWidth) {
								$(obj).addClass('overflow-right');
							} else {
								$(obj).removeClass('overflow-right');
							}

							if (prevWidth >= viewWidth && fullWidth >= viewWidth) {
								$(obj).addClass('overflow-left');
							} else {
								$(obj).removeClass('overflow-left');
							}
						}

						// function handle tab button action - next / prev
						function handleTabButtonAction(element, direction) {
							var obj = $(element).closest('.tab-overflow');
							var marginLeft = parseInt($(obj).find('.nav.nav-tabs').css('margin-left'));
							var containerWidth = $(obj).width();
							var totalWidth = 0;
							var finalScrollWidth = 0;

							$(obj).find('li').each(function () {
								if (!$(this).hasClass('next-button') && !$(this).hasClass('prev-button')) {
									totalWidth += $(this).width();
								}
							});

							switch (direction) {
								case 'next':
									var widthLeft = totalWidth + marginLeft - containerWidth;
									if (widthLeft <= containerWidth) {
										finalScrollWidth = widthLeft - marginLeft;
										setTimeout(function () {
											$(obj).removeClass('overflow-right');
										}, 150);
									} else {
										finalScrollWidth = containerWidth - marginLeft - 80;
									}

									if (finalScrollWidth != 0) {
										$(obj).find('.nav.nav-tabs').animate({ marginLeft: '-' + finalScrollWidth + 'px' }, 150, function () {
											$(obj).addClass('overflow-left');
										});
									}
									break;
								case 'prev':
									var widthLeft = -marginLeft;

									if (widthLeft <= containerWidth) {
										$(obj).removeClass('overflow-left');
										finalScrollWidth = 0;
									} else {
										finalScrollWidth = widthLeft - containerWidth + 80;
									}
									$(obj).find('.nav.nav-tabs').animate({ marginLeft: '-' + finalScrollWidth + 'px' }, 150, function () {
										$(obj).addClass('overflow-right');
									});
									break;
							}
						}

						// handle page load active tab focus
						function handlePageLoadTabFocus() {
							$('.tab-overflow').each(function () {
								var targetWidth = $(this).width();
								var targetInnerWidth = 0;
								var targetTab = $(this);
								var scrollWidth = targetWidth;

								$(targetTab).find('li').each(function () {
									var targetLi = $(this);
									targetInnerWidth += $(targetLi).width();

									if ($(targetLi).hasClass('active') && targetInnerWidth > targetWidth) {
										scrollWidth -= targetInnerWidth;
									}
								});

								handleTabOverflowScrollWidth(this, 0);
							});
						}

						// handle tab next button click action
						$('a[data-click="next-tab"]').click(function (e) {
							e.preventDefault();
							handleTabButtonAction(this, 'next');
						});

						// handle tab prev button click action
						$('a[data-click="prev-tab"]').click(function (e) {
							e.preventDefault();
							handleTabButtonAction(this, 'prev');

						});

						// handle unlimited tabs responsive setting
						$(window).resize(function () {
							$('.tab-overflow .nav.nav-tabs').removeAttr('style');
							handlePageLoadTabFocus();
						});

						handlePageLoadTabFocus();
					};

				}]
		}
	}
]);
common.controller('paycheckPopupACHCtrl', function ($scope, $uibModalInstance, $filter, paycheck) {
	$scope.checkId = paycheck;


});
common.controller('invoicePopupACHCtrl', function ($scope, $uibModalInstance, $filter, invoiceId, mainData, selectedHost, payrollRepository) {
	$scope.invoiceId = invoiceId;
	$scope.selectedHost = selectedHost;
	$scope.mainData = mainData;
	$scope.data = {};
	$scope.invoice = null;
	var _init = function() {
		payrollRepository.getInvoiceById($scope.invoiceId).then(function (invoice) {
			$scope.invoice = invoice;


		}, function (erorr) {
			//addAlert('Error getting invoice: ' + erorr.statusText, 'danger');
		});
	}
	_init();
});
