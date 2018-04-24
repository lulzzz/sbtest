using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.Common.Models
{
	public class Feature
	{
		public int Id { get; set; }
		public string Name { get; set; }
		public List<Access> Accesses { get; set; } 
	}

	public class Access
	{
		public int Id { get; set; }
		public int FeatureId { get; set; }
		public string FeatureName { get; set; }
		public string ClaimName { get; set; }
		public string ClaimType { get; set; }
		public int AccessLevel { get; set; }
	}

	public class UserRoleVersion
	{
		public string UserId { get; set; }
		public string RoleVersion { get; set; }
	}
}
