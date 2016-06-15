using System;

namespace HrMaxxAPI.Resources
{
	public class BaseRestResource
	{
		public Guid? Id { get; set; }
		public Guid UserId { get; set; }
		public string UserName { get; set; }
	}
}