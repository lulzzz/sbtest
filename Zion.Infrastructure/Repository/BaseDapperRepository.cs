using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using HrMaxx.Infrastructure.Mapping;
using Dapper;
using System.Linq;
using System.IO;
using System.Text;
using System.Xml.Serialization;

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

		public List<T> Query<T>(string query, object param = null)
		{
			using (var conn = GetConnection())
			{

				IEnumerable<T> results = conn.Query<T>(query, param);

				return results.ToList();
			}
		}
		public List<object> Query(string query, object param = null)
		{
			using (var conn = GetConnection())
			{

				return conn.Query(query, param).ToList();

			}
		}
		public T QueryObject<T>(string query, object param = null)
		{
			using (var conn = GetConnection())
			{
				return conn.Query<T>(query, param).FirstOrDefault();

			}
		}
		public T QueryXmlList<T>(string query, object param = null, XmlRootAttribute rootAttribute = null)
		{
			using (var conn = GetConnection())
			{
				var data1 = conn.Query<string>(query, param);
				var data = string.Join("", data1);
				if (string.IsNullOrWhiteSpace(data))
					return default(T);


				using (var memStream = new MemoryStream(Encoding.UTF8.GetBytes(data)))
				{
					var serializer = XmlSerializerCache.Create(typeof(T), rootAttribute);
					return (T)serializer.Deserialize(memStream);

				}
			}
		}
		public void Execute(string query, object param = null)
		{
			using (var conn = GetConnection())
			{
				conn.Execute(query, param);

			}
		}
	}
}