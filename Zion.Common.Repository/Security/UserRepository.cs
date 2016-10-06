using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Common.CommandTrees;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
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

		public List<Guid> GetUserByRoleAndId(List<RoleTypeEnum> role, Guid? userId)
		{
			var users = _dbContext.Users.Where(u => u.Roles.Any(r => role.Any(nr=>r.Id==((int)nr).ToString()))
			                                        && ((userId.HasValue && u.Id == userId.Value.ToString()) || !userId.HasValue)
																				).ToList();
			if (!users.Any())
			{
				return new List<Guid>();
			}
			return users.Select(u => new Guid(u.Id)).ToList();
		}

		public List<UserModel> GetUsers(Guid? hostId, Guid? companyId)
		{
			var users = _dbContext.Users.AsQueryable();
			
			if (hostId.HasValue)
			{
				if (companyId.HasValue)
				{
					users = users.Where(u => u.Host.Value == hostId.Value && u.Company.Value == companyId.Value);
				}
				else
				{
					users = users.Where(u => u.Host.Value == hostId.Value && !u.Company.HasValue);
				}
			}
			
			return _mapper.Map<List<User>, List<UserModel>>(users.Distinct().ToList());
		}

		public void SaveUser(UserModel usermodel)
		{
			var user = _dbContext.Users.First(u => u.Id == usermodel.UserId.ToString());
			user.FirstName = usermodel.FirstName;
			user.LastName = usermodel.LastName;
			user.PhoneNumber = usermodel.Phone;
			user.Active = usermodel.Active;
			user.UserName = usermodel.UserName;
			user.Host = usermodel.Host;
			user.Company = usermodel.Company;
			
			_dbContext.SaveChanges();
		}
	}
}
