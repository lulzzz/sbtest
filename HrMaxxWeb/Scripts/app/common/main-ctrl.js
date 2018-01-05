common.controller('mainCtrl', [
	'$scope', '$rootScope', '$element', 'hostRepository', 'zionAPI', 'companyRepository', 'localStorageService', '$interval', '$filter', '$routeParams', '$document', '$window', '$uibModal', 'commonRepository',
	function ($scope, $rootScope, $element, hostRepository, zionAPI, companyRepository, localStorageService, $interval, $filter, $routeParams, $document, $window, $modal, commonRepository) {
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
		$scope.confirmDialog = function(message, type, callback) {
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
			}, function () {
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
			refreshedOn: null
		};
		$scope.data = dataSvc;
		$scope.refreshHostAndCompanies = function() {
			commonRepository.getHostsAndCompanies().then(function (data) {
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
				$scope.refreshHostAndCompanies();
				dataSvc.showFilterPanel = !dataSvc.userHost || (dataSvc.userHost && !dataSvc.userCompany);
				dataSvc.showCompanies = !dataSvc.userCompany;
				dataSvc.isReady = true;
				commonRepository.getConfigData().then(function (result) {
					dataSvc.config = angular.copy(result);

				}, function (error) {

				});
				commonRepository.getUsers(null, null).then(function (result) {
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
					$scope.companySelected(url);
					
				}
				
				
			} else if (!dataSvc.selectedCompany || (dataSvc.selectedCompany && dataSvc.selectedCompany.id !== companyId)) {
				dataSvc.selectedCompany = null;
				dataSvc.selectedCompany1 = null;
				dataSvc.selectedCompany1 = $filter('filter')(dataSvc.hostCompanies, { id: companyId })[0];
				if (dataSvc.selectedCompany1) {
					$scope.companySelected(url);
					
				}
			} else {
				if (url)
					$window.location.href = url;
			}
			
		}
		$scope.setHostandCompanyFromInvoice = function(hostId, company){
			if (!dataSvc.selectedHost || (dataSvc.selectedHost && dataSvc.selectedHost.id !== hostId)) {
				dataSvc.selectedHost = $filter('filter')(dataSvc.hosts, { id: hostId })[0];
				$scope.hostSelected();
			}
			if (!dataSvc.selectedCompany || (dataSvc.selectedCompany && dataSvc.selectedCompany.id !== company.id)) {
				dataSvc.selectedCompany1 = company;
				dataSvc.selectedCompany = angular.copy(company);
			}
			
		}

		$scope.getCompanies = function (sel) {
			//companyRepository.getCompanyList(dataSvc.selectedHost.id).then(function (data) {
			//	dataSvc.companies = data;
			//	if (dataSvc.userCompany) {
			//		var selected = $filter('filter')(dataSvc.companies, {id: dataSvc.userCompany})[0];
			//		dataSvc.selectedCompany = selected;
			//		$window.location.href = "#!/Client/Company/" + (new Date().getTime());
			//	}
			//	else if (sel) {
			//		var selected2 = $filter('filter')(dataSvc.companies, { id: sel.id })[0];
			//		dataSvc.selectedCompany = selected2;
			//	}
			//}, function (erorr) {
			//	$scope.addAlert('error getting company list', 'danger');
			//});
			dataSvc.hostCompanies = $filter('filter')(dataSvc.companies, {hostId: dataSvc.selectedHost.id});
			if (dataSvc.userCompany) {
				$scope.setHostandCompany(dataSvc.userHost, dataSvc.userCompany, "#!/Client/Employees/" + (new Date().getTime()));
			}
		}
		$scope.hostSelected = function () {
			dataSvc.selectedCompany = null;
			dataSvc.selectedCompany1 = null;
			dataSvc.fromSearch = null;
			if (dataSvc.selectedHost) {
				dataSvc.selectedHost = $filter('filter')(dataSvc.hosts, { id: dataSvc.selectedHost.id })[0];
				//dataSvc.selectedHost = angular.copy(match);
				//if (!dataSvc.selectedHost.company) {
				//	getHostDetails();
				//}
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
		$scope.companySelected = function(url) {
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
				$scope.setHostandCompany(result.hostId, result.companyId, "#!/Client/Payrolls/" + +(new Date().getTime()) + '#invoice');
			}
			else if (result.sourceTypeId === 3) {
				dataSvc.fromSearch = true;
				dataSvc.showemployee = result.sourceId;
				$scope.setHostandCompany(result.hostId, result.companyId, "#!/Client/Employees/" + +(new Date().getTime()));
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