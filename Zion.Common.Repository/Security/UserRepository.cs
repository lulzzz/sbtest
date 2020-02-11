using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data.Entity.Core.Common.CommandTrees;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Repository;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Logical;
using UserClaim = HrMaxx.Common.Models.DataModel.UserClaim;

namespace HrMaxx.Common.Repository.Security
{
	public class UserRepository : BaseDapperRepository, IUserRepository
	{
		private readonly UserEntities _dbContext;
		private readonly IMapper _mapper;

		public UserRepository(UserEntities dbContext, IMapper mapper, DbConnection connection): base(connection)
		{
			_dbContext = dbContext;
			_mapper = mapper;
		}

		public UserProfile GetUserProfile(Guid userId)
		{
			var user = QueryObject<User>("select * from AspNetUsers where Id=@Id", new { Id=userId});//_dbContext.Users.First(u => u.Id.Equals(userId.ToString()));
			return _mapper.Map<User, UserProfile>(user);
		}

		public IList<UserRole> GetRoles()
		{
			var roles = Query<Role>("select * from AspNetRoles");//_dbContext.Roles.ToList();
			return _mapper.Map<List<Role>, IList<UserRole>>(roles);
		}

		public void SaveUserProfile(UserProfile user)
		{
			var dbUser = _dbContext.Users.FirstOrDefault(u => u.Id == user.UserId.ToString());
			if (dbUser!=null)
			{
				dbUser.PhoneNumber = user.Phone;
				dbUser.Email = user.Email;
				dbUser.FirstName = user.FirstName;
				dbUser.LastName = user.LastName;
				dbUser.LastModified = DateTime.Now;
				dbUser.LastModifiedBy = dbUser.UserName;
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
			                                        && ((userId.HasValue && u.Id == userId.Value.ToString()) || !userId.HasValue)).ToList();
			
			if (!users.Any())
			{
				return new List<Guid>();
			}
			return users.Select(u => new Guid(u.Id)).ToList();
		}

		public List<UserModel> GetUsers(Guid? hostId, Guid? companyId)
		{
			var sql = "select Id  UserId, Email  , EmailConfirmed  , PasswordHash  , SecurityStamp  , PhoneNumber  , PhoneNumberConfirmed  , TwoFactorEnabled  , LockoutEndDateUtc  , LockoutEnabled  , AccessFailedCount  , UserName  , FirstName  , LastName  , Host  , Company  , Active  , Employee  , RoleVersion  , LastModifiedBy  , LastModified, " +
						"(select Role.Id RoleId, Role.Name RoleName from AspNetUserRoles ur, AspNetRoles[Role] where ur.RoleId =[Role].Id and ur.UserId =[User].Id for xml path('Role'), elements, type),  " +
						"(select * from AspNetUserClaims UserClaim where UserClaim.UserId =[User].Id for xml auto, elements, type) Claims " +
						"from AspNetUsers [User] " +
						"for xml path('UserModel'), elements, type, root('UserList')";
			var users1 = QueryXmlList<List<UserModel>>(sql, rootAttribute: new System.Xml.Serialization.XmlRootAttribute("UserList"));
			var users = users1.AsQueryable();
			if (hostId.HasValue)
			{
				if (companyId.HasValue)
				{
					users = users.Where(u => u.Host.Value == hostId.Value && u.Company.Value == companyId.Value);
				}
				else
				{
					users = users.Where(u => u.Host.Value == hostId.Value);
				}
			}
			else
			{
				if (companyId.HasValue)
					users = users.Where(u => u.Company.Value == companyId.Value);
			}
			
			return users.ToList();
			
			
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

		public void UpdateUserClaims(string id, List<Claim> addClaim, List<Claim> removeClaims)
		{
			removeClaims.ForEach(r=>_dbContext.UserClaims.Remove(_dbContext.UserClaims.FirstOrDefault(u=>u.UserId==id && u.ClaimType.Equals(r.Type))));
			addClaim.ForEach(a => _dbContext.UserClaims.Add(new UserClaim { UserId = id, ClaimType = a.Type, ClaimValue = a.Value }));
			
			_dbContext.SaveChanges();
		}

		public List<UserRoleVersion> GetUserRoleVersions()
		{
			return _dbContext.Users.Select(u => new UserRoleVersion {UserId = u.Id, RoleVersion = u.RoleVersion.ToString()}).ToList();
		}
	}
}
