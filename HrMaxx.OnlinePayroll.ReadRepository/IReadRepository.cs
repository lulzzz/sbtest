﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;

namespace HrMaxx.OnlinePayroll.ReadRepository
{
	public interface IReadRepository
	{
		T GetDataFromStoredProc<T>(string proc, List<FilterParam> paramList);
	}
}
