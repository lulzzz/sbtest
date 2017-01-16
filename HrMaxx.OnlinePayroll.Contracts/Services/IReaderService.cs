using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;

namespace HrMaxx.OnlinePayroll.Contracts.Services
{
	public interface IReaderService
	{
		T GetDataFromStoreProc<T>(string proc, List<FilterParam> paramList);
	}
}
