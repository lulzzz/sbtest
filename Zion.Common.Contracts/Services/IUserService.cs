using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Security.Principal;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;

namespace HrMaxx.Common.Contracts.Services
{
	public interface IUserService
	{
		UserProfile GetUserProfile(Guid userId);
		void SaveUserProfile(UserProfile user);
		List<Guid> GetUsersByRoleAndId(List<RoleTypeEnum> role, Guid? userId);
		List<UserModel> GetUsers(Guid? hostId, Guid? companyId);
		void SaveUser(UserModel usermodel);
		void UpdateClaims(string id, List<Claim> addClaim, List<Claim> removeClaims );
		
	}
}