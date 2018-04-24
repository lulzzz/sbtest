using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;

namespace HrMaxx.Common.Repository.Security
{
	public interface IUserRepository
	{
		UserProfile GetUserProfile(Guid userId);
		IList<UserRole> GetRoles();
		void SaveUserProfile(UserProfile user);
		List<Guid> GetUserByRoleAndId(List<RoleTypeEnum> role, Guid? userId);
		List<UserModel> GetUsers(Guid? hostId, Guid? companyId);
		void SaveUser(UserModel usermodel);
		void UpdateUserClaims(string id, List<Claim> addClaim, List<Claim> removeClaims);

		List<UserRoleVersion> GetUserRoleVersions();
	}
}
