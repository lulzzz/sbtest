'use strict';

common.directive('commissionsView', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				masterExtract: "=masterExtract"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/commissions-view.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter',
				function ($scope, $element, $location, $filter) {
					$scope.data = $scope.masterExtract.extract.data;
					$scope.report = $scope.masterExtract.extract.report;
					$scope.selectedRep = null;
					
					$scope.set = function (rep) {
						$scope.selectedRep = rep;
						
					}
					
					$scope.exclude = function (event, rep) {
						event.stopPropagation();
						if ($scope.selectedRep && rep.id === $scope.selectedRep.id) {
							$scope.selectedRep = null;
							
						}
						$scope.data.salesReps.splice($scope.data.salesReps.indexOf(rep), 1);
					}

					

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
					var _init = function () {
						if ($scope.data && $scope.data.salesReps.length > 0) {
							$timeout(function () {
								handleUnlimitedTabsRender();
							}, 1);
							$scope.set($scope.data.salesReps[0]);
						}

					}
					_init();

				}
			]

		}
	}
]);
