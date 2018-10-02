using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Serialization;
using HrMaxx.Common.Models;

namespace HrMaxx.OnlinePayroll.ReadRepository
{
	public interface IReadRepository
	{
		T GetDataFromStoredProc<T>(string proc, List<FilterParam> paramList);
		T GetDataFromStoredProc<T, T1>(string proc, List<FilterParam> paramList, XmlRootAttribute xmlRootAttribute);
		T GetDataFromStoredProc1<T>(string proc, List<FilterParam> paramList, XmlRootAttribute xmlRootAttribute);
		T GetDataFromJsonStoredProc<T, T1>(string proc, List<FilterParam> paramList);
		T GetDataFromStoredProc<T, T1>(string proc, List<FilterParam> paramList);
		T GetQueryData<T>(string query, XmlRootAttribute attribute);
		List<T> GetQueryData<T>(string query);
	}
}
