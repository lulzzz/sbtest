using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Enum;

namespace HrMaxx.Common.Repository.Security
{
	public interface IUserRepository
	{
		UserProfile GetUserProfile(Guid userId);
		IList<UserRole> GetRoles();
		void SaveUserProfile(UserProfile user);
		List<Guid> GetUserByRoleAndId(RoleTypeEnum role, Guid? userId);
	}
}
