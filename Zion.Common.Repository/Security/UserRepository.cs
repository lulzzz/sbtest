using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Common.CommandTrees;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Infrastructure.Mapping;

namespace HrMaxx.Common.Repository.Security
{
	public class UserRepository : IUserRepository
	{
		private readonly UserEntities _dbContext;
		private readonly IMapper _mapper;

		public UserRepository(UserEntities dbContext, IMapper mapper)
		{
			_dbContext = dbContext;
			_mapper = mapper;
		}

		public UserProfile GetUserProfile(Guid userId)
		{
			var user = _dbContext.Users.First(u => u.Id.Equals(userId.ToString()));
			return _mapper.Map<User, UserProfile>(user);
		}

		public IList<UserRole> GetRoles()
		{
			var roles = _dbContext.Roles.ToList();
			return _mapper.Map<List<Role>, IList<UserRole>>(roles);
		}

		public void SaveUserProfile(UserProfile user)
		{
			var dbUser = _dbContext.Users.FirstOrDefault(u => u.Id == user.UserId.ToString());
			if (dbUser!=null)
			{
				dbUser.PhoneNumber = user.Phone;
				dbUser.PhoneNumberConfirmed = dbUser.PhoneNumberConfirmed || !string.IsNullOrWhiteSpace(user.Phone);
				if (user.Role != null)
				{
					if (!dbUser.Roles.Any(r => r.Id == user.Role.RoleId.ToString()))
					{
						_dbContext.Roles.First(r => r.Id == user.Role.RoleId.ToString()).Users.Add(dbUser);	
					}
					
				}
				_dbContext.SaveChanges();
			}
		}
	}
}
