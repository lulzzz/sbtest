using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Dtos;

namespace HrMaxx.Common.Models
{
	public class UserProfile
	{
		public Guid UserId { get; set; }
		public string FirstName { get; set; }
		public string LastName { get; set; }
		public string Email { get; set; }
		public string Phone { get; set; }
		public int RoleId { get; set; }
		public UserRole Role { get; set; }
		public IList<UserRole> AvailableRoles { get; set; }
		public Guid? Host { get; set; }
		public Guid? Company { get; set; }
		public bool Active { get; set; }
	}

	public class UserRole
	{
		public int RoleId { get; set; }
		public string RoleName { get; set; }
	}
}
