common.factory('commonRepository', [
	'$http', 'zionAPI', 'zionPaths', '$q', '$upload', 'commonServer', '$filter', 'Entities',
	function ($http, zionAPI, zionPaths, $q, upload, commonServer, $filter, Entities) {
		return {
			token: function(loginData) {
				var data = "grant_type=password&username=" + loginData.username + "&password=" + loginData.password;

				var deferred = $q.defer();

				$http.post(zionAPI.URL + zionPaths.Token, data, { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } }).success(function (response) {
					deferred.resolve(response);
					
				}).error(function(err) {
					deferred.reject(err);
				});
				return deferred.promise;
			},
			postLogin: function(loginData) {
				var deferred = $q.defer();
				$http.post(zionAPI.Web + zionPaths.Login, JSON.stringify(loginData)).success(function(response) {
					deferred.resolve(response);
				}).error(function(err) {
					deferred.reject(err);
				});
				return deferred.promise;
			},
			logout: function() {
				var deferred = $q.defer();
				$http.get(zionAPI.Web + zionPaths.Logout).success(function(response) {
					deferred.resolve(response);
				}).error(function(err) {
					deferred.reject(err);
				});
				return deferred.promise;
			},
			uploadDocument: function(attachment) {
				var url = zionAPI.URL + 'Document/UploadEntityDocument';
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
			deleteDocument: function(entityTypeId, entityId, documentId) {
				var deferred = $q.defer();

				commonServer.one('Document/DeleteEntityDocument/' + entityTypeId + '/' + entityId + '/' + documentId).get().then(function () {
					deferred.resolve();
				}, function (error) {
					deferred.reject(error);
				});
				return deferred.promise;
			},
			getCountries: function() {
				var deferred = $q.defer();

				commonServer.one('Countries').getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});
				return deferred.promise;
			},
			saveComment: function(comment) {
				var deferred = $q.defer();

				commonServer.all('Common/SaveComment').post(comment).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});
				return deferred.promise;
			},
			saveContact: function (contact) {
				var deferred = $q.defer();

				commonServer.all('Common/SaveContact').post(contact).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});
				return deferred.promise;
			},
			saveAddress: function (address) {
				var deferred = $q.defer();

				commonServer.all('Common/SaveAddress').post(address).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});
				return deferred.promise;
			},
			deleteRelationship: function(sourceTypeId, targetTypeId, sourceId, targetId) {
				var deferred = $q.defer();

				commonServer.one('Common/DeleteEntityRelation/' + sourceTypeId + '/' + targetTypeId + '/' + sourceId + '/' + targetId).get().then(function () {
					deferred.resolve();
				}, function (error) {
					deferred.reject(error);
				});
				return deferred.promise;
			},
			getRelatedEntities: function (sourceTypeId, targetTypeId, sourceId) {
				var deferred = $q.defer();
				var entity = $filter('filter')(Entities, { entityTypeId: targetTypeId })[0];
				if (entity) {
					
					commonServer.one(entity.getList + '/' + sourceTypeId + '/' + sourceId).get().then(function (data) {
						deferred.resolve(data);
					}, function (error) {
						deferred.reject(error);
					});
					
				} else {
					deferred.resolve(data);
				}
				return deferred.promise;
			},
			getFirstRelatedEntity: function (sourceTypeId, targetTypeId, sourceId) {
				var deferred = $q.defer();
				var entity = $filter('filter')(Entities, { entityTypeId: targetTypeId })[0];
				if (entity) {

					commonServer.one(entity.first + '/' + sourceTypeId + '/' + sourceId).get().then(function (data) {
						deferred.resolve(data);
					}, function (error) {
						deferred.reject(error);
					});

				} else {
					deferred.resolve(data);
				}
				return deferred.promise;
			},
			getHostList: function () {
				var deferred = $q.defer();
				commonServer.one('Host').getList().then(function (data) {
						deferred.resolve(data);
					}, function (error) {
						deferred.reject(error);
					});

				return deferred.promise;
			},
			getNewsfeed: function (audienceScope, audienceId) {
				var deferred = $q.defer();
				var url = 'Common/Newsfeed/' + audienceScope;
				if (audienceId)
					url += '/' + audienceId;
				commonServer.one( url ).getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getUserNews: function () {
				var deferred = $q.defer();
				var url = 'Common/UserNewsfeed/';
				commonServer.one(url).getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveNews: function (news) {
				var deferred = $q.defer();
				commonServer.all('Common/Newsfeed').post(news).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getNewsfeedMetaData: function (news) {
				var deferred = $q.defer();
				commonServer.one('Host/NewsMetaData').get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getUsers: function (hostId, companyId) {
				var deferred = $q.defer();
				var url = "Users";
				if (hostId)
					url += "/" + hostId;
				if (companyId)
					url += "/" + companyId;
				commonServer.one(url).getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});
				return deferred.promise;
			},
			getUsersMetaData: function () {
				var deferred = $q.defer();
				var url = "MetaDataForUsers";
				commonServer.one(url).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});
				return deferred.promise;
			},
			getAccessMetaData: function () {
				var deferred = $q.defer();
				var url = "AccessMetaData";
				commonServer.one(url).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});
				return deferred.promise;
			},
			saveUser: function(user) {
				var deferred = $q.defer();
				commonServer.all('SaveUser').post(user).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			resetPassword: function (user) {
				var deferred = $q.defer();
				commonServer.all('UserPasswordReset').post(user).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getAccountsMetaData: function () {
				var deferred = $q.defer();
				commonServer.one('AccountsMetaData').get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getConfigData: function () {
				var deferred = $q.defer();
				commonServer.one('Configurations').get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveConfigData: function (configs) {
				var deferred = $q.defer();
				commonServer.all('Configurations').post(configs).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getInsuranceGroups: function () {
				var deferred = $q.defer();
				commonServer.one('InsuranceGroups').getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getMementos: function (type, id) {
				var deferred = $q.defer();
				commonServer.one('Mementos').one(id, type).getList().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveInsuranceGroup: function (group) {
				var deferred = $q.defer();
				commonServer.all('InsuranceGroup').post(group).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getHostsAndCompanies: function () {
				var deferred = $q.defer();
				commonServer.one('HostsAndCompanies').get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getTaxTables: function (year) {
				var deferred = $q.defer();
				commonServer.one('GetTaxes/' + year).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			getTaxTableYears: function () {
				var deferred = $q.defer();
				commonServer.one('GetTaxTableYears').get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			createTaxTables: function (year) {
				var deferred = $q.defer();
				commonServer.one('CreateTaxes/' + year).get().then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},
			saveTaxTables: function (year, taxtables) {
				var deferred = $q.defer();
				commonServer.all('SaveTaxes').post({year: year, taxTables: taxtables}).then(function (data) {
					deferred.resolve(data);
				}, function (error) {
					deferred.reject(error);
				});

				return deferred.promise;
			},


		};
	}
]);