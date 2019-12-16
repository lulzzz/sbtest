common.controller('mainCtrl', [
	'$scope', '$rootScope', '$element', 'hostRepository', 'zionAPI', 'companyRepository', 'localStorageService', '$interval', '$filter', '$routeParams', '$document', '$window', '$uibModal', 'commonRepository', '$location', 'ClaimTypes',
	function ($scope, $rootScope, $element, hostRepository, zionAPI, companyRepository, localStorageService, $interval, $filter, $routeParams, $document, $window, $modal, commonRepository, $location, ClaimTypes) {
		$scope.alerts = [];
		$scope.params = $routeParams;

		$scope.addAlert = function (error, type) {
			var alerts = [];
			var rows = error.split('<br>');
			$.each(rows, function (index, er) {
				if (er) {
					alerts.push({
						msg: er,
						type: type
					});
				}
				
			});
			
			var modalInstance = $modal.open({
				templateUrl: 'popover/messages.html',
				controller: 'messageCtrl',
				backdrop: true,
				keyboard: true,
				backdropClick: true,
				size: 'lg',
				resolve: {
					alerts: function () {
						return alerts;
					}
				}
			});
			
		};
		$scope.addAlerts = function (message, list, type) {
			var alerts = [];
			
			$.each(list, function (index, er) {
				alerts.push({
						msg: er,
						type: type
					});
				

			});

			var modalInstance = $modal.open({
				templateUrl: 'popover/messages.html',
				controller: 'messageCtrl',
				backdrop: true,
				keyboard: true,
				backdropClick: true,
				size: 'lg',
				resolve: {
					alerts: function () {
						return alerts;
					}
				}
			});

		};
		$scope.confirmDialog = function(message, type, callback, nocallback) {
			var modalInstance = $modal.open({
				templateUrl: 'popover/confirm.html',
				controller: 'confirmDialogCtrl',
				backdrop: true,
				keyboard: true,
				backdropClick: true,
				size: 'lg',
				resolve: {
					message: function () {
						return message;
					},
					type: function () {
						return type;
					}
				}
			});
			modalInstance.result.then(function (result) {
				if (result)
					callback();
				else {
					if (nocallback)
						nocallback();

				}
			}, function () {
				if (nocallback)
					nocallback();
				return false;
			});
		}

		$scope.closeAlert = function (index) {
			$scope.alerts.splice(index, 1);
		};
		$scope.zionAPI = zionAPI;
		
		var dataSvc = {
			hosts: [],
			companies: [],
			hostCompanies: [],
			selectedHost: null,
			selectedCompany: null,
			selectedEmployee: null,
			config: null,
			isFilterOpen: true,
			showFilterPanel: true,
			showCompanies: true,
			userHost: null,
			userCompany: null,
			userEmployee: null,
			userRole: null,
			myName: '',
			isReady: false,
			fromSearch: false,
			invoiceCompany: null,
			users: [],
			reportFilter: {
				filterStartDate: null,
				filterEndDate: null,
				filter: {
					years: [],
					month: 0,
					year: 0,
					quarter: 0
				}
			},
			refreshedOn: null,
			includeAllCompanies: false,
			searchCompany: null,
			hasClaim : function (type1, value) {
				var match = $filter('filter')(this.userClaims, { Type: type1 }, true);
				return match.length > 0;
            },
            confirmDialog : function (message, type, callback, nocallback) {
                var modalInstance = $modal.open({
                    templateUrl: 'popover/confirm.html',
                    controller: 'confirmDialogCtrl',
                    backdrop: true,
                    keyboard: true,
                    backdropClick: true,
                    size: 'lg',
                    resolve: {
                        message: function () {
                            return message;
                        },
                        type: function () {
                            return type;
                        }
                    }
                });
                modalInstance.result.then(function (result) {
                    if (result)
                        callback();
                    else {
                        if (nocallback)
                            nocallback();

                    }
                }, function () {
                    if (nocallback)
                        nocallback();
                    return false;
                });
            }
		};
		$scope.data = dataSvc;
		$scope.addMissingCompany = function(host, company, url) {
			commonRepository.getHostsAndCompanies(0, company).then(function (data) {
				dataSvc.companies.push(data.companies[0]);
				dataSvc.hostCompanies.push(data.companies[0]);
				dataSvc.selectedCompany1 = $filter('filter')(dataSvc.hostCompanies, { id: company })[0];
				$scope.companySelected(url? url : null, url? true : false);
			}, function (error) {
				$scope.addAlert('error getting list of hosts', 'danger');
			});
		}
		$scope.refreshHostAndCompanies = function() {
			commonRepository.getHostsAndCompanies(dataSvc.includeAllCompanies ? 0 : 1).then(function (data) {
				dataSvc.hosts = data.hosts;
				dataSvc.companies = data.companies;
				dataSvc.refreshedOn = new Date();
				if (dataSvc.userHost) {
					var uhost = $filter('filter')(dataSvc.hosts, { id: dataSvc.userHost })[0];
					dataSvc.selectedHost = uhost;
				}
				else if (dataSvc.hosts.length === 1) {
					dataSvc.selectedHost = dataSvc.hosts[0];
				}
				if (dataSvc.selectedHost) {
					$scope.hostSelected();
				}
			}, function (error) {
				$scope.addAlert('error getting list of hosts', 'danger');
			});
		}
		
		function _init() {
			var auth = localStorageService.get('authorizationData');
			if (auth) {
				var dataInput = $element.data();
				dataSvc.userRole = dataInput.role;
				dataSvc.myName = dataInput.name;
				if (dataInput.host !== '00000000-0000-0000-0000-000000000000') {
					dataSvc.userHost = dataInput.host;
				}
				
				if (dataInput.company !== '00000000-0000-0000-0000-000000000000') {
					dataSvc.userCompany = dataInput.company;
					
				}
				if (dataInput.employee !== '00000000-0000-0000-0000-000000000000') {
					dataSvc.userEmployee = dataInput.employee;

				}
				if (dataInput.claims) {
					dataSvc.userClaims = dataInput.claims;

				}
				$scope.refreshHostAndCompanies();
				dataSvc.showFilterPanel = !dataSvc.userHost || (dataSvc.userHost && !dataSvc.userCompany);
				dataSvc.showCompanies = !dataSvc.userCompany;
				dataSvc.isReady = true;
				commonRepository.getConfigData().then(function (result) {
					dataSvc.config = angular.copy(result);

				}, function (error) {

				});
				commonRepository.getAllUsers().then(function (result) {
					dataSvc.users = angular.copy($filter('filter')(result, {active:true}));

				}, function (error) {

				});
			}
			
		};
		
		$scope.setHostandCompany = function (hostId, companyId, url) {
			
			if (!dataSvc.selectedHost || (dataSvc.selectedHost && dataSvc.selectedHost.id !== hostId)) {
				dataSvc.selectedHost = null;
				dataSvc.selectedCompany = null;
				dataSvc.selectedCompany1 = null;

				dataSvc.selectedHost = $filter('filter')(dataSvc.hosts, { id: hostId })[0];
				$rootScope.$broadcast('hostChanged', { host: dataSvc.selectedHost });
				$scope.getCompanies(null);
				dataSvc.selectedCompany1 = $filter('filter')(dataSvc.hostCompanies, { id: companyId })[0];
				if (dataSvc.selectedCompany1) {
					$scope.companySelected(url, true);

				} else {
					$scope.addMissingCompany(hostId, companyId, url);
					//dataSvc.includeAllCompanies = true;
					//dataSvc.searchCompany = companyId;
					//dataSvc.searchUrl = url;
					
					
				}
				
				
			} else if (!dataSvc.selectedCompany || (dataSvc.selectedCompany && dataSvc.selectedCompany.id !== companyId)) {
				dataSvc.selectedCompany = null;
				dataSvc.selectedCompany1 = null;
				dataSvc.selectedCompany1 = $filter('filter')(dataSvc.hostCompanies, { id: companyId })[0];
				if (dataSvc.selectedCompany1) {
					$scope.companySelected(url, true);
					
				}
			} else {
				if (url)
					$window.location.href = url;
			}
			
		}
		$scope.setHostandCompanyFromInvoice = function(hostId, companyId){
			if (!dataSvc.selectedHost || (dataSvc.selectedHost && dataSvc.selectedHost.id !== hostId)) {
				dataSvc.selectedHost = $filter('filter')(dataSvc.hosts, { id: hostId })[0];
				$scope.getCompanies(null);
				$scope.hostSelected();
			}
			if (!dataSvc.selectedCompany || (dataSvc.selectedCompany && dataSvc.selectedCompany.id !== companyId)) {
				dataSvc.selectedCompany1 = $filter('filter')(dataSvc.hostCompanies, { id: companyId })[0];
				if (dataSvc.selectedCompany1)
					$scope.companySelected(null, false);
				else {
					$scope.addMissingCompany(hostId, companyId);
					
				}
			}
			
		}

		$scope.getCompanies = function (sel) {
			
			dataSvc.hostCompanies = $filter('filter')(dataSvc.companies, {hostId: dataSvc.selectedHost.id});
			if (dataSvc.userCompany) {
				$scope.setHostandCompany(dataSvc.userHost, dataSvc.userCompany, "#!/Admin/Dashboard/");
			}
			else if (dataSvc.searchCompany) {
				dataSvc.selectedCompany1 = $filter('filter')(dataSvc.hostCompanies, { id: dataSvc.searchCompany })[0];
				$scope.companySelected(dataSvc.searchUrl, true);
			}
		}
		$scope.hostSelected = function () {
			dataSvc.selectedCompany = null;
			dataSvc.selectedCompany1 = null;
			dataSvc.fromSearch = null;
			if (dataSvc.selectedHost) {
				dataSvc.selectedHost = $filter('filter')(dataSvc.hosts, { id: dataSvc.selectedHost.id })[0];
				
				$scope.getCompanies(null);
				$rootScope.$broadcast('hostChanged', { host: dataSvc.selectedHost });
			}
				
		}
		var getHostDetails = function() {
			hostRepository.getHost(dataSvc.selectedHost.id).then(function (data) {
				dataSvc.selectedHost = angular.copy(data);
			}, function (erorr) {
				addAlert('error getting host details', 'danger');
			});
		}
		$scope.companySelected = function (url, useUrl) {
			if (useUrl) {
				if (!url) {
					url = $window.location.href;
				}
				$window.location.href = "#!/temp";
			}
			
			if (dataSvc.selectedCompany1 && dataSvc.selectedCompany1.id) {
				dataSvc.selectedCompany = angular.copy(dataSvc.selectedCompany1);
				companyRepository.getCompany(dataSvc.selectedCompany.id).then(function (comp) {
					dataSvc.selectedCompany = angular.copy(comp);
					if (url)
						$window.location.href = url;
				}, function (error) {
					$scope.addAlert('error getting company details', 'danger');
				});
				dataSvc.isFilterOpen = false;
			}
		}
		$scope.$on('companyUpdated', function (event, args) {
			var company = args.company;
			var children = $filter('filter')(dataSvc.companies, { parentId: company.id });
			if (children.length > 0) {
				$scope.getCompanies(company);
			} else {
			
				updateInList(dataSvc.companies, company);
			
				if (dataSvc.selectedHost && dataSvc.selectedHost.company && dataSvc.selectedHost.company.id === company.id) {
					dataSvc.selectedHost.company = company;
				}
				if (dataSvc.selectedCompany && dataSvc.selectedCompany.id === company.id) {
					dataSvc.selectedCompany = company;
					dataSvc.selectedCompany1 = angular.copy(company);
				}
			}
		});
		$scope.$on('companyLocationUpdated', function (event, args) {
			var company = args.location;
			updateInList(dataSvc.companies, company);

			if (dataSvc.selectedHost && dataSvc.selectedHost.company.id === company.id) {
				dataSvc.selectedHost.company = company;
			}
			if (dataSvc.selectedCompany && dataSvc.selectedCompany.id === company.id) {
				dataSvc.selectedCompany = company;
				dataSvc.selectedCompany1 = angular.copy(company);
			}
		});
		$scope.$on('switchCompany', function (event, args) {
			var id = args.newcomp;
			var newcomp = $filter('filter')(dataSvc.companies, { id: id })[0];
			if (newcomp) {
				dataSvc.fromSearch = true;
				$scope.setHostandCompany(newcomp.hostId, newcomp.id, "#!/Client/Company/"  +(new Date().getTime()));
			}
			
		});
		$scope.$on('hostUpdated', function (event, args) {
			var host = args.host;
			dataSvc.selectedHost = null;
			updateInList(dataSvc.hosts, host);
		});
		$scope.$on('searchResultSelected', function (event, args) {
			var result = args.result;
			if (result.sourceTypeId === 2) {
				dataSvc.fromSearch = true;
				if(dataSvc.hasClaim(ClaimTypes.PayrollProcess,1))
					$scope.setHostandCompany(result.hostId, result.companyId, "#!/Client/Payrolls/" + +(new Date().getTime()));
				else {
					$scope.setHostandCompany(result.hostId, result.companyId, "#!/Client/Company/" + +(new Date().getTime()));
				}
			}
			else if (result.sourceTypeId === 3) {
				dataSvc.fromSearch = true;
                dataSvc.showemployee = result.sourceId;
                dataSvc.terminatedSearch = result.searchText.indexOf('Terminated') > 0 || result.searchText.indexOf('InActive');
				var currentLocation = $window.location.href;
				$scope.setHostandCompany(result.hostId, result.companyId, (currentLocation.indexOf( "#!/Client/Employees/")===-1 ?"#!/Client/Employees/" + +(new Date().getTime()) : null));
			}
			
		});
		$scope.$on('companyDeductionUpdated', function (event, args) {
			var ded = args.ded;
			updateInList(dataSvc.selectedCompany.deductions, ded);
		});
		$scope.$on('companyWCUpdated', function (event, args) {
			var wc = args.wc;
			updateInList(dataSvc.selectedCompany.workerCompensations, wc);
			
		});
		$scope.$on('companyTaxUpdated', function (event, args) {
			var tax = args.tax;
			updateInList(dataSvc.selectedCompany.companyTaxRates, tax);

		});
		$scope.$on('companyPayCodeUpdated', function (event, args) {
			var pc = args.pc;
			updateInList(dataSvc.selectedCompany.payCodes, pc);

		});
		$scope.$on('companyPayTypeUpdated', function (event, args) {
			var pt = args.pt;
			updateInList(dataSvc.selectedCompany.accumulatedPayTypes, pt);

		});
		var updateInList = function(list, match) {
			var exists = $filter('filter')(list, { id: match.id });
			if (exists.length === 0) {

			} else {
				list.splice(list.indexOf(exists[0]), 1);

			}
			list.push(match);
		}

		var removeMessages = function() {
			$scope.alerts = [];
		}
		_init();
		$interval(removeMessages, 15000);

		$document.on('keydown', function (e) {
			if (e.which === 8 && (e.target.nodeName !== "INPUT" && e.target.nodeName !== "SELECT" && e.target.nodeName !== "PASSWORD" && e.target.nodeName !== "TEXTAREA")) { // you can add others here inside brackets.
				e.preventDefault();
			}
		});
	}
]);

common.controller('printerFriendlyCtrl', function ($scope, $uibModalInstance, content) {
	$scope.content = content;
	$scope.cancel = function () {
		$uibModalInstance.close($scope);
	};
	
	$scope.save = function () {
		
		$uibModalInstance.close($scope);
	};


});

common.controller('messageCtrl', function ($scope, $uibModalInstance, alerts) {
	$scope.alerts = alerts;
	
	$scope.cancel = function () {
		$uibModalInstance.close($scope);
	};
	
	$scope.ok = function () {
		$uibModalInstance.close($scope);
	};


});
common.controller('confirmDialogCtrl', function ($scope, $uibModalInstance, message, type) {
	$scope.message = message;
	$scope.type = type ? type : 'info';
	$scope.cancel = function () {
		$uibModalInstance.close(false);
	};

	$scope.ok = function () {
		$uibModalInstance.close(true);
	};


});