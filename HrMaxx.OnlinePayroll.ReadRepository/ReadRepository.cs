using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using HrMaxx.Common.Models;
using HrMaxx.Infrastructure.Mapping;

namespace HrMaxx.OnlinePayroll.ReadRepository
{
	public class ReadRepository: IReadRepository
	{
		private readonly IMapper _mapper;
		private string _sqlCon;

		public ReadRepository(IMapper mapper, string sqlCon)
		{
			_mapper = mapper;
			_sqlCon = sqlCon;
		}

		private string GetData(string proc, List<FilterParam> paramList)
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

		public T GetDataFromStoredProc<T>(string proc, List<FilterParam> paramList)
		{
			var data = GetData(proc, paramList);
			var serializer = new XmlSerializer(typeof(T));
			var memStream = new MemoryStream(Encoding.UTF8.GetBytes(data));
			return (T)serializer.Deserialize(memStream);
		}
	}
}
