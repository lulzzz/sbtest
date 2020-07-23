'use strict';

common.directive('projectList', ['$uibModal', 'zionAPI','version',
	function ($modal, zionAPI, version) {
		return {
			restrict: 'E',
			replace: true,
			scope: {
				companyId: "=companyId",
				list: "=list",
				mainData: "=mainData",
				showControls: "=showControls"
			},
			templateUrl: zionAPI.Web + 'Areas/Client/templates/project-list.html?v=' + version,

			controller: ['$scope', '$rootScope', '$filter', 'companyRepository',
				function ($scope, $rootScope, $filter, companyRepository) {
					
				$scope.selected = null;
				
				var addAlert = function (error, type) {
					$scope.mainData.showMessage(error, type);
				};
				$scope.closeAlert = function (index) {
					
					};
					
				$scope.add = function () {
					var item = {
						id: 0,
						companyId: $scope.companyId,
						projectId: '',
						projectName: '',
						awardingBoyd: '',
						registrationNo: '',
						licenseNo: '',
						licenseType: ''
					};
					$scope.list.push(item);
					$scope.setSelected($scope.list.indexOf(item));
				},
				
				
					$scope.setSelected = function (index) {

						$scope.selected = $scope.list[index];
						$scope.showProject();
				}

				
				
					$scope.showProject = function (listitem) {
						var modalInstance = $modal.open({
							templateUrl: 'popover/project.html',
							controller: 'projectCtrl',
							size: 'sm',
							windowClass: 'my-modal-popup',
							backdrop: 'static',
							resolve: {
								project: function () {
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
							
								if (scope.isNew) {
									var match1 = $filter('filter')($scope.list, { id: 0 })[0];
									$scope.list[$scope.list.indexOf(match1)] = angular.copy(scope.project);
								}									
								else {
									var match1 = $filter('filter')($scope.list, { id: scope.id })[0];
									$scope.list[$scope.list.indexOf(match1)] = angular.copy(scope.project);
								}
								$scope.selected = null;
								$rootScope.$broadcast('companyProjectUpdated', { pt: scope.project });
								addAlert('successfully saved project', 'success');
							
							$scope.selected = null;
							
						}, function () {
								if (!$scope.selected.id)
									$scope.list.splice($scope.list.indexOf($scope.selected), 1);
								$scope.selected = null;

						});
					}
				

			}]
		}
	}
]);
common.controller('projectCtrl', function ($scope, $uibModalInstance, $filter, project, repository, company) {
	$scope.original = project;
	$scope.project = angular.copy(project);
	$scope.repository = repository;
	$scope.company = company;
	$scope.changesMade = false;
	if (!$scope.project.id)
		$scope.isNew = true;

	$scope.hasChanges = function () {
		return !angular.equals($scope.project, $scope.original);
    }
	$scope.isProjectValid = function () {
		var item = $scope.project;
		if (!item.projectId || !item.projectName || !item.awardingBody || !item.registrationNo || !item.licenseNo || !item.licenseType || !item.policyNo || !item.classification)
			return false;
		else
			return true;
	}
	$scope.save = function () {
		$scope.isClosed = false;
		$scope.repository.saveProject($scope.project).then(function (data) {
			$scope.project.id = data.id;
			$uibModalInstance.close($scope);
			

		}, function (error) {
			
		});
	}
	$scope.cancel = function () {
		
		$uibModalInstance.dismiss();
	}
	

	

});

