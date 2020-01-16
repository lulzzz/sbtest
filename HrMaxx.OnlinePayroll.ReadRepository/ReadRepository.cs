using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using Dapper;
using HrMaxx.Common.Models;
using HrMaxx.Infrastructure;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Repository;
using Newtonsoft.Json;
using XmlSerializer = System.Xml.Serialization.XmlSerializer;

namespace HrMaxx.OnlinePayroll.ReadRepository
{
	public class ReadRepository : BaseDapperRepository, IReadRepository
	{
		private readonly IMapper _mapper;
		private string _sqlCon;

		public ReadRepository(IMapper mapper, string sqlCon, DbConnection connection)
			: base(connection)
		{
			_mapper = mapper;
			_sqlCon = sqlCon;
		}

		private string GetData(string proc, IEnumerable<FilterParam> paramList)
		{
			using (var con = new SqlConnection(_sqlCon))
			{
				using (var cmd = new SqlCommand(proc))
				{
					cmd.CommandType = CommandType.StoredProcedure;
					paramList.Where(p=>!string.IsNullOrWhiteSpace(p.Key) && !string.IsNullOrWhiteSpace(p.Value)).ToList()
									.ForEach(p => cmd.Parameters.AddWithValue(string.Format("@{0}", p.Key), p.Value));
					cmd.Connection = con;
					cmd.CommandTimeout = 0;
					con.Open();

					var data = string.Empty;
					using (var reader = cmd.ExecuteXmlReader())
					{
						var sb = new StringBuilder();

						while (reader.Read())
							sb.AppendLine(reader.ReadOuterXml());

						data = sb.ToString();
					}
					con.Close();
					return data;
				}
			}
		}

		private string GetQueryData(string query)
		{
			using (var con = new SqlConnection(_sqlCon))
			{
				using (var cmd = new SqlCommand(query))
				{
					cmd.CommandType = CommandType.Text;
					
					cmd.Connection = con;
					cmd.CommandTimeout = 0;
					con.Open();

					var data = string.Empty;
					using (var reader = cmd.ExecuteXmlReader())
					{
						var sb = new StringBuilder();

						while (reader.Read())
							sb.AppendLine(reader.ReadOuterXml());

						data = sb.ToString();
					}
					con.Close();
					return data;
				}
			}
		}

		private static T Deserialize<T>(string xmlStream, XmlRootAttribute rootAttribute)
		{
			
			if (string.IsNullOrWhiteSpace(xmlStream))
				return default(T);
			using (var reader = new MemoryStream(Encoding.UTF8.GetBytes(xmlStream)))
			{
				//var serializer = new XmlSerializer(typeof(T), rootAttribute);
				var serializer = XmlSerializerCache.Create(typeof(T), rootAttribute);
				return (T)serializer.Deserialize(reader);
			}
		}
		
		private string GetDataJson(string proc, List<FilterParam> paramList)
		{
			using (var con = new SqlConnection(_sqlCon))
			{
				using (var cmd = new SqlCommand(proc))
				{
					cmd.CommandType = CommandType.StoredProcedure;
					paramList.ForEach(p => cmd.Parameters.AddWithValue(string.Format("@{0}", p.Key), p.Value));
					cmd.Connection = con;
					con.Open();

					var data = string.Empty;
					using (var reader = cmd.ExecuteReader())
					{
						var sb = new StringBuilder();

						while (reader.Read())
							sb.Append(reader.GetString(0));

						data = sb.ToString();
					}
					con.Close();
					return data;
				}
			}
		}

		public T GetDataFromStoredProc<T>(string proc, List<FilterParam> paramList)
		{
			var data = GetData(proc, paramList);
			if (string.IsNullOrWhiteSpace(data))
			{
				return default(T);
			}
			//var serializer = new XmlSerializer(typeof(T));
			using (var memStream = new MemoryStream(Encoding.UTF8.GetBytes(data)))
			{
				var serializer = new XmlSerializer(typeof(T));
				return (T)serializer.Deserialize(memStream);	
			}
		}
		public T GetDataFromStoredProc1<T>(string proc, List<FilterParam> paramList, XmlRootAttribute rootAttribute)
		{
			var data = GetData(proc, paramList);
			return Deserialize<T>(data, rootAttribute);
		}
		public T GetDataFromStoredProc<T, T1>(string proc, List<FilterParam> paramList, XmlRootAttribute rootAttribute)
		{
			var data = GetData(proc, paramList);
			var intermediary = Deserialize<T1>(data,rootAttribute);
			return _mapper.Map<T1, T>(intermediary);
		}

		public T GetDataFromJsonStoredProc<T, T1>(string proc, List<FilterParam> paramList)
		{
			var data = GetDataJson(proc, paramList);
			if (string.IsNullOrWhiteSpace(data))
				return default(T);
			var intermediary = JsonConvert.DeserializeObject<T1>(data);
			return _mapper.Map<T1, T>(intermediary);
		}

		public T GetDataFromStoredProc<T, T1>(string proc, List<FilterParam> paramList)
		{
			var data = GetData(proc, paramList);
			if (string.IsNullOrWhiteSpace(data))
				return default(T);

			
			using (var memStream = new MemoryStream(Encoding.UTF8.GetBytes(data)))
			{
				var serializer = new XmlSerializer(typeof(T1));
				var intermediary = (T1)serializer.Deserialize(memStream);

				return _mapper.Map<T1, T>(intermediary);
			}
			
			
		}
		public T GetQueryData<T>(string query , XmlRootAttribute rootAttribute)
		{
			var data = GetQueryData(query);
			return Deserialize<T>(data, rootAttribute);

		}

		public List<T> GetQueryData<T>(string query)
		{
			using (var conn = GetConnection())
			{
				
				IEnumerable<T> results = conn.Query<T>(query );

				return results.ToList();
			}
		}
		public List<T1> GetQueryData<T, T1>(string query)
		{
			using (var conn = GetConnection())
			{

				IEnumerable<T> results = conn.Query<T>(query);

				return _mapper.Map<List<T>, List<T1>>(results.ToList());
			}
		}
	}
}
