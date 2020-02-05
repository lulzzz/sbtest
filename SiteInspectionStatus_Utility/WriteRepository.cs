using System.Data.Common;
using Dapper;
using HrMaxx.Infrastructure.Repository;

namespace SiteInspectionStatus_Utility
{
	public class WriteRepository : BaseDapperRepository, IWriteRepository
	{
		public WriteRepository(DbConnection wConnection) : base(wConnection)
		{

		}

		public void ExecuteQuery(string sql, object unknown)
		{
			using (var con = GetConnection())
			{

				con.Execute(sql, unknown);
				
			}
		}

	}
}
