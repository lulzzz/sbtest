using System.Data.Entity;

namespace HrMaxx.Common.Models.DataModel
{
	public partial class CommonEntities : DbContext
	{
		public CommonEntities(string nameOrConnectionString)
			: base(nameOrConnectionString)
		{
		}
	}
}