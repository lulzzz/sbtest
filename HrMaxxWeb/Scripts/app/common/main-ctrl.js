common.controller('mainCtrl', [
	'$scope', '$rootScope', '$element', 'hostRepository', 'zionAPI', 'companyRepository', 'localStorageService', '$interval', '$filter', '$routeParams', '$document', '$window', '$uibModal',
	function ($scope, $rootScope, $element, hostRepository, zionAPI, companyRepository, localStorageService, $interval, $filter, $routeParams, $document, $window, $modal) {
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
			selectedHost: null,
			selectedCompany: null,
			isFilterOpen: true,
			showFilterPanel: true,
			showCompanies: true,
			userHost: null,
			userCompany: null,
			userRole: null,
			isReady: false,
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
			
		};
		$scope.data = dataSvc;
		
		function _init() {
			var auth = localStorageService.get('authorizationData');
			if (auth) {
				var dataInput = $element.data();
				dataSvc.userRole = dataInput.role;
				if (dataInput.host !== '00000000-0000-0000-0000-000000000000') {
					dataSvc.userHost = dataInput.host;
				}
				if (dataInput.company !== '00000000-0000-0000-0000-000000000000')
					dataSvc.userCompany = dataInput.company;
				hostRepository.getHostList().then(function (data) {
					dataSvc.hosts = data;
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
				
				

				dataSvc.showFilterPanel = !dataSvc.userHost || (dataSvc.userHost && !dataSvc.userCompany);
				dataSvc.showCompanies = !dataSvc.userCompany;
				dataSvc.isReady = true;
			}
		};
		
		$scope.setHostandCompany = function (hostId, companyId, url) {
			if(!dataSvc.selectedHost || (dataSvc.selectedHost && dataSvc.selectedHost.id!==hostId))
				dataSvc.selectedHost = $filter('filter')(dataSvc.hosts, { id: hostId })[0];
			
			if (dataSvc.selectedHost) {
				if (!dataSvc.selectedCompany || (dataSvc.selectedCompany && dataSvc.selectedCompany.id !== companyId)) {
					dataSvc.selectedCompany = null;
					companyRepository.getCompanyList(dataSvc.selectedHost.id).then(function(data) {
						dataSvc.companies = data;
						var selected = $filter('filter')(dataSvc.companies, { id: companyId })[0];
						dataSvc.selectedCompany1 = selected;
						$scope.companySelected();
						$window.location.href = url;
					}, function(erorr) {
						$scope.addAlert('error getting company list', 'danger');
					});
					$rootScope.$broadcast('hostChanged', { host: dataSvc.selectedHost });
				} else {
					$window.location.href = url;
				}
				
			}
		}

		$scope.getCompanies = function () {
			companyRepository.getCompanyList(dataSvc.selectedHost.id).then(function (data) {
				dataSvc.companies = data;
				if (dataSvc.userCompany) {
					var selected = $filter('filter')(dataSvc.companies, {id: dataSvc.userCompany})[0];
					dataSvc.selectedCompany = selected;
				}
			}, function (erorr) {
				$scope.addAlert('error getting company list', 'danger');
			});
		}
		$scope.hostSelected = function () {
			dataSvc.selectedCompany = null;
			if (dataSvc.selectedHost) {
				$scope.getCompanies();
				$rootScope.$broadcast('hostChanged', { host: dataSvc.selectedHost });
			}
				
		}
		$scope.companySelected = function ($item, $model, $label, $event) {
			if (dataSvc.selectedCompany1 && dataSvc.selectedCompany1.id) {
				dataSvc.selectedCompany = angular.copy(dataSvc.selectedCompany1);
				dataSvc.isFilterOpen = false;
			}
		}
		$scope.$on('companyUpdated', function (event, args) {
			var company = args.company;
			updateInList(dataSvc.companies, company);
			dataSvc.selectedCompany = company;
			if (dataSvc.selectedHost.company.id === company.id) {
				dataSvc.selectedHost.company = company;
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
			updateInList(dataSvc.selectedCompany.payCodes, pt);

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