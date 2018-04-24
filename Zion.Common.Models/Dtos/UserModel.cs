using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.Common.Models.Dtos
{
	public class UserModel
	{
		public Guid UserId { get; set; }
		public string UserName { get; set; }
		public string FirstName { get; set; }
		public string LastName { get; set; }
		public string Phone { get; set; }
		public bool Active { get; set; }
		public string Email { get; set; }
		public Guid? Host { get; set; }
		public Guid? Company { get; set; }
		public Guid? Employee { get; set; }
		public UserRole Role { get; set; }
		public List<UserClaim> Claims { get; set; } 
		public int Version { get; set; }
		public DateTime? LastModified { get; set; }
		public string LastModifiedBy { get; set; }
	}

	public class UserClaim
	{
		public int Id { get; set; } 
		public string ClaimType { get; set; }
		public string ClaimValue { get; set; }
	}
	
}
