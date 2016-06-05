using System;
using System.Linq;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Repository.Security;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using Newtonsoft.Json;

namespace HrMaxx.Common.Services.Security
{
	public class UserService : BaseService, IUserService
	{
		private readonly IUserRepository _repository;
		public UserService(IUserRepository repository)
		{
			_repository = repository;
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
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, string.Format("User Profile for {0}", JsonConvert.SerializeObject(user)));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
	}

	
}