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

			controller: ['$scope', '$element', '$location', '$filter', 'payrollRepository', 'reportRepository',
				function ($scope, $element, $location, $filter, payrollRepository, reportRepository) {
					var dataSvc = {
						startDate: null,
						endDate: null,
						report: null
					}
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

					
					var showReview = function (report, extract) {
						dataSvc.report = extract;
						if (dataSvc.report && dataSvc.report.hosts.length > 0) {
							$timeout(function () {
								handleUnlimitedTabsRender();
							}, 1);
							$scope.set(dataSvc.report.hosts[0]);
						}
					}
					$scope.getReport = function () {
						var m = $scope.mainData;
						var request = {
							reportName: 'ACHReport',
							startDate: moment(dataSvc.startDate).format("MM/DD/YYYY"),
							endDate: moment(dataSvc.endDate).format("MM/DD/YYYY")
						}
						reportRepository.getACHReport(request).then(function (extract) {
							showReview(request, extract);
							

						}, function (erorr) {
							addAlert('Error getting ACH Extract: ' + erorr.statusText, 'danger');
						});
					}
					$scope.getACHDocumentAndFile = function () {
						reportRepository.getACHDocumentAndFile(dataSvc.report).then(function (data) {
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
						}, function (erorr) {
							addAlert('Failed to download ACH extract : ' + erorr, 'danger');
						});

					};
					
					var _init = function () {
						
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
