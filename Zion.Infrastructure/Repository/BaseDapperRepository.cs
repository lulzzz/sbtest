using System;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using HrMaxx.Infrastructure.Mapping;
using StackExchange.Profiling.Data;

namespace HrMaxx.Infrastructure.Repository
{
	public class BaseDapperRepository
	{
		private DbConnection Connection;
		protected string _connectionString;

		protected BaseDapperRepository(DbConnection connection)
		{
			Connection = connection;
			_connectionString = connection.ConnectionString;
			//OpenConnection();
		}

		public IMapper Mapper { get; set; }

		public void OpenConnection()
		{
			if (Connection == null) throw new InvalidOperationException("Connection can not be null");

			if (Connection.State == ConnectionState.Closed)
				Connection.Open();
		}

		public IDbConnection GetConnection()
		{
			return new SqlConnection(_connectionString);
		}
	}
}