using System;
using System.Collections.Generic;
using System.Security.Principal;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Enum;

namespace HrMaxx.Common.Contracts.Services
{
	public interface IUserService
	{
		UserProfile GetUserProfile(Guid userId);
		void SaveUserProfile(UserProfile user);
		List<Guid> GetUsersByRoleAndId(RoleTypeEnum role, Guid? userId);
	}
}