﻿using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Repository.Security;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using Newtonsoft.Json;

namespace HrMaxx.Common.Services.Security
{
	public class UserService : BaseService, IUserService
	{
		private readonly IUserRepository _repository;
		private readonly ICommonService _commonService;
		public UserService(IUserRepository repository, ICommonService commonService)
		{
			_repository = repository;
			_commonService = commonService;
		}

		public UserProfile GetUserProfile(Guid userId)
		{
			try
			{

				var user = _repository.GetUserProfile(userId);
				user.AvailableRoles = _repository.GetRoles();
				user.Role = user.AvailableRoles.FirstOrDefault(r => r.RoleId.Equals(user.RoleId));
				
				return user;
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, string.Format("User Profile for {0}", userId));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void SaveUserProfile(UserProfile user)
		{
			try
			{
				_repository.SaveUserProfile(user);
				//_commonService.SaveEntityRelation<Address>(EntityTypeEnum.User, EntityTypeEnum.Address, user.UserId, user.Address);
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, string.Format("User Profile for {0}", JsonConvert.SerializeObject(user)));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<Guid> GetUsersByRoleAndId(List<RoleTypeEnum> role, Guid? userId)
		{
			try
			{
				return _repository.GetUserByRoleAndId(role, userId);
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, "user list for role and userid");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<UserModel> GetUsers(Guid? hostId, Guid? companyId)
		{
			try
			{
				var users = _repository.GetUsers(hostId, companyId);
				return users;
			}
			catch (Exception e)
			{

				var message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, "user list for host and company");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void SaveUser(UserModel usermodel)
		{
			try
			{
				_repository.SaveUser(usermodel);
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToSaveX, "user details for user id" + usermodel.UserId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
	}

	
}