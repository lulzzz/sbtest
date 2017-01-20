using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Serialization;
using HrMaxx.Common.Models;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;
using Newtonsoft.Json;

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

		private static T Deserialize<T>(string xmlStream, params Type[] additionalTypes)
		{
			var serializer = new XmlSerializer(typeof(T), new XmlRootAttribute("PayrollInvoiceJsonList"));


			using (var reader = new MemoryStream(Encoding.UTF8.GetBytes(xmlStream)))
			{
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
			var serializer = new XmlSerializer(typeof(T));
			var memStream = new MemoryStream(Encoding.UTF8.GetBytes(data));
			return (T)serializer.Deserialize(memStream);
			
		}
		public T GetDataFromStoredProc<T, T1>(string proc, List<FilterParam> paramList)
		{
			var data = GetData(proc, paramList);
			//var intermediary = Deserialize<List<PayrollInvoiceJson>>(data);
			var serializer = new XmlSerializer(typeof(XmlResult));
			var memStream = new MemoryStream(Encoding.UTF8.GetBytes(data));
			var intermediary = (XmlResult)serializer.Deserialize(memStream);
			return _mapper.Map<List<PayrollInvoiceJson>, T>(intermediary.ResultList);
		}

		public T GetDataFromJsonStoredProc<T, T1>(string proc, List<FilterParam> paramList)
		{
			var data = GetDataJson(proc, paramList);
			var intermediary = JsonConvert.DeserializeObject<T1>(data);
			return _mapper.Map<T1, T>(intermediary);
		}
	}
}
