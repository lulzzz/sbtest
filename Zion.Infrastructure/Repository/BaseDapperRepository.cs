using System;
using System.Data;
using System.Data.Common;
using HrMaxx.Infrastructure.Mapping;
using StackExchange.Profiling.Data;

namespace HrMaxx.Infrastructure.Repository
{
	public class BaseDapperRepository
	{
		protected DbConnection Connection;

		protected BaseDapperRepository(DbConnection connection)
		{
			Connection = connection;
			//OpenConnection();
		}

		public IMapper Mapper { get; set; }

		public void OpenConnection()
		{
			if (Connection == null) throw new InvalidOperationException("Connection can not be null");

			if (Connection.State == ConnectionState.Closed)
				Connection.Open();
		}
	}
}