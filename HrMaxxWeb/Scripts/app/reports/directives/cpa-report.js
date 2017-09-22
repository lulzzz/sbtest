'use strict';

common.directive('cpaReport', ['zionAPI', '$timeout', '$window', 'version',
	function (zionAPI, $timeout, $window, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				mainData: "=mainData"
			},
			templateUrl: zionAPI.Web + 'Areas/Reports/templates/cpa-report.html?v=' + version,

			controller: ['$scope', '$element', '$location', '$filter', 'payrollRepository', 'reportRepository',
				function ($scope, $element, $location, $filter, payrollRepository, reportRepository) {
					var dataSvc = {

						isBodyOpen: true,
						response: null,
						startDate: moment().startOf('year').toDate(),
						endDate: moment().endOf('year').toDate(),
						hostHomePage: null
						
					}
					

					$scope.data = dataSvc;
					$scope.mainData.showFilterPanel = !$scope.mainData.userHost || ($scope.mainData.userHost && !$scope.mainData.userCompany);
					$scope.mainData.showCompanies = !$scope.mainData.userCompany;
					dataSvc.hostHomePage = $scope.mainData.selectedHost.homePage;

					var addAlert = function (error, type) {
						$scope.$parent.$parent.addAlert(error, type);
					};
					$scope.print = function () {
						$window.print();
					}
					$scope.getHostLogo = function () {
						if (dataSvc.hostHomePage && dataSvc.hostHomePage.logo) {
							var photo = dataSvc.hostHomePage.logo;
							return zionAPI.URL + 'DocumentById/' + photo.id + '/' + photo.documentExtension + '/' + photo.documentName;
						} else {
							return "https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg";
						}
					}
					$scope.showResponse = function() {
						if (dataSvc.response && dataSvc.response.companyId === $scope.mainData.selectedCompany.id && moment(dataSvc.startDate).format("MM/DD/YYYY") === moment(dataSvc.response.startDate).format("MM/DD/YYYY") && moment(dataSvc.endDate).format("MM/DD/YYYY") === moment(dataSvc.response.endDate).format("MM/DD/YYYY"))
							return true;
						else {
							return false;
						}
					}
					$scope.getReport = function() {
						var m = $scope.mainData;
						var request = {
							hostId: m.selectedHost.id,
							companyId: m.selectedCompany.id,
							startDate: moment(dataSvc.startDate).format("MM/DD/YYYY"),
							endDate: moment(dataSvc.endDate).format("MM/DD/YYYY")
						}
						reportRepository.getCPAReport(request).then(function (data) {
							dataSvc.response = data;

						}, function (erorr) {
							addAlert('Error getting cpa report ' + desc + ': ' + erorr, 'danger');
						});
					}
				

			}]
		}
	}
]);
