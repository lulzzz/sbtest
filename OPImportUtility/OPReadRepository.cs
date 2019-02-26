using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using HrMaxx.Infrastructure.Repository;

namespace OPImportUtility
{
	public class OPReadRepository:BaseDapperRepository, IOPReadRepository
	{
		public OPReadRepository(DbConnection opconnection): base(opconnection)
		{
			
		}
		public List<T> GetQueryData<T>(string query)
		{
			using (var conn = GetConnection())
			{

				IEnumerable<T> results = conn.Query<T>(query);

				return results.ToList();
			}
		}
	}
}
