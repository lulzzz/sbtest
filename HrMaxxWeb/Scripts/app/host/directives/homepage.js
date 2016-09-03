'use strict';

common.directive('homepage', ['zionAPI', '$timeout', 'localStorageService', '$window',
	function (zionAPI, $timeout, localStorageService, $window) {
		return {
			restrict: 'E',
			
			scope: {
				hostId: "=hostId",
				sourceTypeId: "=sourceTypeId",
				parent: "=host"
			},
			templateUrl: zionAPI.Web + 'Areas/Administration/templates/homepage.html',

			controller: ['$scope', '$element', '$location', '$filter', 'hostRepository', 'commonRepository', '$q', 'EntityTypes',
				function ($scope, $element, $location, $filter, hostRepository, commonRepository, $q, EntityTypes) {
				var localHomePage = null;
				$scope.logoImage = null;
				$scope.contactImage = null;
				$scope.editProfile = false;
				$scope.editServices = false;

				$scope.data = null;
				$scope.hostaddress = {};
				var addAlert = function (error, type) {
					$scope.alerts = [];
					$scope.alerts.push({
						msg: error,
						type: type
					});
				};
				$scope.closeAlert = function (index) {
					$scope.alerts.splice(index, 1);
				};

				$scope.getDocumentUrl = function (photo) {
					if (photo) {
						if (photo.doc && photo.doc.uploaded === false)
							return photo.doc.file_data;
						if(photo.id)
							return zionAPI.URL + 'DocumentById/' + photo.id + '/' + photo.documentExtension + '/' +  photo.documentName;
					}
					

				};
				$scope.removeLogo = function () {
					$scope.logoImage = null;
				};
				$scope.removeContact = function () {
					$scope.contactImage = null;
				};
				$scope.profileCancel = function () {
					if (localHomePage && localHomePage.profile)
						$scope.data.profile = localHomePage.profile;
					else
						$scope.data.profile = '';
					$scope.editProfile = !$scope.editProfile;
				}
				$scope.profileSave = function () {
					localHomePage.profile = $scope.data.profile;
					$scope.editProfile = !$scope.editProfile;
				}
				$scope.servicesCancel = function () {
					if (localHomePage && localHomePage.services)
						$scope.data.services = localHomePage.services;
					else
						$scope.data.services = '';
					$scope.editServices = !$scope.editServices;
				}
				$scope.servicesSave = function () {
					localHomePage.services = $scope.data.services;
					$scope.editServices = !$scope.editServices;
				}

				$scope.onFileSelect = function ($files, type) {
					for (var i = 0; i < 1; i++) {
						var $file = $files[i];

						var fileReader = new FileReader();
						fileReader.readAsDataURL($files[i]);
						var loadFile = function (fileReader, index) {
							fileReader.onload = function (e) {
								$timeout(function () {
									var lfile = {
										doc: {
											file: $files[index],
											file_data: e.target.result,
											uploaded: false
										},
										data: JSON.stringify({
											stagingId: $scope.data.stagingId,
											hostId: $scope.hostId,
											type: type,
											mimeType: $files[index].type
										}),
										currentProgress: 0,
										completed: false
									};
									if (type === 0) {
										$scope.logoImage = lfile;
									} else {
										$scope.contactImage = lfile;
									}
								});
							}
						}(fileReader, i);
					}
				};
				var uploadDocument = function(document) {
					if (document && !document.doc.uploaded) {

						hostRepository.uploadDocument(document).then(function (doc) {

						}, function () {
							document.doc.uploaded = false;
							$scope.addAlert('error uploading file', 'danger');

						});

					}
				}

				var uploadImages = function () {
					var deferred = $q.defer();
					if ($scope.logoImage && !$scope.logoImage.doc.uploaded) {
						
						hostRepository.uploadDocument($scope.logoImage).then(function(doc) {
							if ($scope.contactImage && !$scope.contactImage.doc.uploaded) {

								hostRepository.uploadDocument($scope.contactImage).then(function(doc1) {
									deferred.resolve();
								}, function(error) {
									$scope.contactImage.doc.uploaded = false;
									addAlert('error uploading contact image', 'danger');
									deferred.reject(error);
								});

							} else {
								deferred.resolve();
							}

						}, function(error) {
							$scope.logoImage.uploaded = false;
							addAlert('error uploading logo image', 'danger');
							deferred.reject(error);
						});

					} else if ($scope.contactImage && !$scope.contactImage.doc.uploaded) {

						hostRepository.uploadDocument($scope.contactImage).then(function(doc1) {
							deferred.resolve();
						}, function(error) {
							$scope.contactImage.doc.uploaded = false;
							addAlert('error uploading contact image', 'danger');
							deferred.reject(error);
						});


					} else {
						deferred.resolve();
					}
					

					return deferred.promise;
				}

				$scope.save = function () {
					if (false === $('form[name="homepageForm"]').parsley().validate('address'))
						return false;
					uploadImages().then(function () {
						$scope.hostaddress.sourceTypeId = EntityTypes.Host;
						$scope.hostaddress.targetTypeId = EntityTypes.Address;
						$scope.hostaddress.sourceId = $scope.hostId;
						commonRepository.saveAddress($scope.hostaddress).then(function(data) {
							$scope.hostaddress.id = data.id;
							hostRepository.saveHomePage($scope.data).then(function(data) {
								localStorageService.set('hostHomePage', data);
								$window.location.href = zionAPI.Web + '#/?host='+$scope.parent.firmName;
								addAlert('successfully saved home page details', 'success');
							}, function(erorr) {
								addAlert('error saving host home page details', 'danger');
							});
						
						}, function(erorr) {
								addAlert('error saving hostaddress', 'danger');
							});
						}, function() {
						
						});
						

				}
				$scope.cancel =  function() {
					$scope.$parent.$parent.cancel();
				}
				var init = function() {
					hostRepository.getHomePageForEdit($scope.hostId).then(function (data) {
						if (!data)
							data = {};
						localHomePage = data;
						$scope.data = angular.copy(localHomePage);
						localStorageService.set('hostHomePage', data);
						
					}, function (erorr) {
						addAlert('error getting host home page details', 'danger');
					});
					
				}
				$scope.loadIfNotLoaded = function () {
					var l = localStorageService.get('hostHomePage');
					if (!l || l.id !== $scope.hostId) {
						init();
					} else {
						localHomePage = l;
						$scope.data = angular.copy(localHomePage);
					}
					
				}
				$scope.loadIfNotLoaded();
				$scope.hstep = 1;
				$scope.mstep = 15;
				$scope.ismeridian = true;
			}]
		}
	}
]);
