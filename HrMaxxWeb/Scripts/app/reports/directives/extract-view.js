'use strict';

common.directive('extractView', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				masterExtract: "=masterExtract"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/extract-view.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'reportRepository',
				function ($scope, $element, $location, $filter, reportRepository) {

					var addAlert = function (message, status) {
						$scope.$parent.$parent.alerts = [];
						$scope.$parent.$parent.alerts.push({
							message: message,
							status: status
						});
					}
					$scope.data = $scope.masterExtract.extract.data;
					$scope.history = $scope.masterExtract.extract.data.history;
					$scope.report = $scope.masterExtract.extract.report;

					$scope.selectedPrintCompanies = [];
					$scope.selectedBatchCompanies = [];
					$scope.printedCompanies = [];

					$scope.selectedHost = null;
					$scope.selectedCompany = null;
					$scope.selectedAgency = null;
					$scope.showPayChecks = false;
					$scope.showVoidedChecks = false;
					$scope.selectedRep = null;
					$scope.selectedCompanyFilings = [];
					$scope.viewMode = null;
					$scope.formsToPrint = 0;
					
					$scope.set = function(host) {
						$scope.selectedHost = host;
						$scope.selectedCompany = null;
						$scope.selectedAgency = null;
						$scope.selectedEmployee = null;
						if ($scope.selectedHost.companies.length === 1) {
							$scope.selectedCompany = $scope.selectedHost.companies[0];
						}
					}
					$scope.setCompany = function(comp) {
						$scope.selectedCompany = comp;
						$scope.showPayChecks = false;
						$scope.showVoidedChecks = false;
						$scope.showHistory = false;
						$scope.selectedCompanyFilings = [];
						if ($scope.selectedCompany.employeeAccumulations.length === 1) {
							$scope.selectedEmployee = $scope.selectedCompany.employeeAccumulations[0];
						} else {
							$scope.selectedEmployee = null;
						}
						$.each($scope.history, function(ind, h) {
							var host = $filter('filter')(h.extract.data.hosts, { host: { id: $scope.selectedHost.host.id } })[0];
							if (host) {
								var c = $filter('filter')(host.companies, { company: { id: $scope.selectedCompany.company.id } })[0];
								if (c && c.accumulation) {
									var filing = {
										depositDate: h.extract.report.depositDate,
										grossWage: c.accumulation.grossWage,
										wages: c.accumulation.applicableWages,
										taxes: c.accumulation.applicableAmounts
									};

									$scope.selectedCompanyFilings.push(filing);
								}
							}
						});

					}
					$scope.setEmployee = function (ea) {
						$scope.selectedEmployee = ea;
					}
					$scope.setAgency = function(agency) {
						$scope.selectedAgency = agency;
						var checks = [];
						$.each(agency.payCheckIds, function(ind, pc) {
							var check = $filter('filter')($scope.selectedHost.accumulation.payChecks, { id: pc })[0];
							var company = $filter('filter')($scope.selectedHost.companies, { company: {id: check.employee.companyId} })[0];
							if (check) {
								check.companyName = company ? company.company.name : '';
								checks.push(check);
							}
								
						});
						$scope.selectedAgency.payChecks = checks;
					}
					$scope.exclude = function(event, host) {
						event.stopPropagation();
						if ($scope.selectedHost && host.id === $scope.selectedHost.id) {
							$scope.selectedHost = null;
							$scope.selectedCompany = null;
							$scope.selectedAgency = null;
						}
						$scope.data.hosts.splice($scope.data.hosts.indexOf(host), 1);
					}

					$scope.printBatch = function() {
						var extract = {
							report: $scope.masterExtract.extract.report,
							data: {
								hosts: $scope.data.hosts,
								companies: angular.copy($scope.selectedBatchCompanies),
								history: []
							},
							template: $scope.masterExtract.extract.template,
							argumentList: $scope.masterExtract.extract.argumentList,
							fileName: $scope.masterExtract.extract.fileName,
							extension: $scope.masterExtract.extract.extension
						};

						reportRepository.printExtractBatch(extract).then(function (data) {
							extract = null;
							$.each($scope.selectedBatchCompanies, function (i, h) {
								$scope.printedCompanies.push(h);
								$scope.data.companies.splice($scope.data.companies.indexOf(h),1);
							});
							$scope.selectedPrintCompanies = [];
							$scope.selectedBatchCompanies = [];
							$scope.formsToPrint = 0;
							var a = document.createElement('a');
							a.href = data.file;
							a.target = '_blank';
							a.download = data.name;
							document.body.appendChild(a);
							a.click();
						}, function (erorr) {
							addAlert('Failed to download batch print ' + $scope.masterExtract.extract.report.description + ': ' + erorr, 'danger');
						});
					}
					$scope.batchPrintingEvents = {
						onItemSelect: function (item) {
							var c = $filter('filter')($scope.data.companies, { id: item.id })[0];
							$scope.formsToPrint = $scope.formsToPrint + c.employeeAccumulationList.length;
							$scope.selectedBatchCompanies.push(c);

						},
						onItemDeselect: function (item) {
							var c = $filter('filter')($scope.data.companies, { id: item.id })[0];
							$scope.formsToPrint = $scope.formsToPrint - c.employeeAccumulationList.length;
							$scope.selectedBatchCompanies.splice($scope.selectedBatchCompanies.indexOf(c), 1);

						}
					};

					$scope.getGarnishmentCheckEmployeeName  =function(checkId) {
						var check = $filter('filter')($scope.selectedHost.payChecks, { id: checkId },  true)[0];
						return check ? check.employee.firstName + ' ' + check.employee.lastName : '';
					}

					var handleUnlimitedTabsRender = function() {

						// function handle tab overflow scroll width 
						function handleTabOverflowScrollWidth(obj, animationSpeed) {
							var marginLeft = parseInt($(obj).css('margin-left'));
							var viewWidth = $(obj).width();
							var prevWidth = $(obj).find('li.active').width();
							var speed = (animationSpeed > -1) ? animationSpeed : 150;
							var fullWidth = 0;

							$(obj).find('li.active').prevAll().each(function() {
								prevWidth += $(this).width();
							});

							$(obj).find('li').each(function() {
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

							$(obj).find('li').each(function() {
								if (!$(this).hasClass('next-button') && !$(this).hasClass('prev-button')) {
									totalWidth += $(this).width();
								}
							});

							switch (direction) {
							case 'next':
								var widthLeft = totalWidth + marginLeft - containerWidth;
								if (widthLeft <= containerWidth) {
									finalScrollWidth = widthLeft - marginLeft;
									setTimeout(function() {
										$(obj).removeClass('overflow-right');
									}, 150);
								} else {
									finalScrollWidth = containerWidth - marginLeft - 80;
								}

								if (finalScrollWidth != 0) {
									$(obj).find('.nav.nav-tabs').animate({ marginLeft: '-' + finalScrollWidth + 'px' }, 150, function() {
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
								$(obj).find('.nav.nav-tabs').animate({ marginLeft: '-' + finalScrollWidth + 'px' }, 150, function() {
									$(obj).addClass('overflow-right');
								});
								break;
							}
						}

						// handle page load active tab focus
						function handlePageLoadTabFocus() {
							$('.tab-overflow').each(function() {
								var targetWidth = $(this).width();
								var targetInnerWidth = 0;
								var targetTab = $(this);
								var scrollWidth = targetWidth;

								$(targetTab).find('li').each(function() {
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
						$('a[data-click="next-tab"]').click(function(e) {
							e.preventDefault();
							handleTabButtonAction(this, 'next');
						});

						// handle tab prev button click action
						$('a[data-click="prev-tab"]').click(function(e) {
							e.preventDefault();
							handleTabButtonAction(this, 'prev');

						});

						// handle unlimited tabs responsive setting
						$(window).resize(function() {
							$('.tab-overflow .nav.nav-tabs').removeAttr('style');
							handlePageLoadTabFocus();
						});

						handlePageLoadTabFocus();
					};
					var _init = function () {
						if (!$scope.masterExtract.extract.report.isBatchPrinting) {
							if ($scope.masterExtract.extract.report.reportName !== 'CommissionsReport') {
								if ($scope.data && $scope.data.hosts.length > 0) {
									$timeout(function() {
										handleUnlimitedTabsRender();
									}, 1);
									$scope.set($scope.data.hosts[0]);
								}
							} else {
								if ($scope.data && $scope.data.salesReps.length > 0) {
									$timeout(function() {
										handleUnlimitedTabsRender();
									}, 1);
									$scope.setRep($scope.data.salesReps[0]);
								}
							}
						}
						
							
					}

					$scope.setRep = function (rep) {
						$scope.selectedRep = rep;

					}

					$scope.excludeRep = function (event, rep) {
						event.stopPropagation();
						if ($scope.selectedRep && rep.id === $scope.selectedRep.id) {
							$scope.selectedRep = null;

						}
						$scope.data.salesReps.splice($scope.data.salesReps.indexOf(rep), 1);
					}


					_init();

				}
			]

		}
	}
]);
