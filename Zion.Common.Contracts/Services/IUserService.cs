using System;
using System.Security.Principal;
using HrMaxx.Common.Models;

namespace HrMaxx.Common.Contracts.Services
{
	public interface IUserService
	{
		UserProfile GetUserProfile(Guid userId);
		void SaveUserProfile(UserProfile user);
	}
}