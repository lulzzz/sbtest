hostmodule.factory('hostRepository', [
	'$http', 'zionAPI', 'zionPaths', '$q', '$upload', 'hostServer', '$filter', 'Entities',
	function ($http, zionAPI, zionPaths, $q, upload, hostServer, $filter, Entities) {
		return {
			getHostList: function () {
				var deferred = $q.defer();
				hostServer.one('Hosts').getList().then(function (data) {
						deferred.resolve(data);
					}, function (error) {
						deferred.reject(error);
					});

				return deferred.promise;
			},
			getHostWelcomePage: function (url) {
				var deferred = $q.defer();
				hostServer.one('HostWelcome', url).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getHostWelcomePageByFirmName: function (firmName) {
				var deferred = $q.defer();
				hostServer.one('HostWelcomeByFirmName', firmName).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			
			getHomePage: function (hostId) {
				var deferred = $q.defer();
				hostServer.one('HomePage', hostId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getHomePageForEdit: function (hostId) {
				var deferred = $q.defer();
				hostServer.one('HomePageForEdit', hostId).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveHomePage: function (homepage) {
				var deferred = $q.defer();
				hostServer.all('HomePage').post(homepage).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveHost: function (host) {
				var deferred = $q.defer();
				hostServer.all('Save').post(host).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			uploadDocument: function (attachment) {
				var url = zionAPI.URL + 'Document/HomePageImage';
				var deferred = $q.defer();
				upload.upload({
					url: url,
					method: 'POST',
					data: {
						inspection: attachment.data
					},
					file: attachment.doc.file,
				}).progress(function (evt) {
					attachment.currentProgress = parseInt(100.0 * evt.loaded / evt.total);
					deferred.notify();
				}).success(function (data, status, headers, config) {
					attachment.doc.uploaded = true;
					attachment.completed = true;
					deferred.resolve(data);

				})
				.error(function (error) {
					deferred.reject(error);
				});
				return deferred.promise;
			},
		};
	}
]);