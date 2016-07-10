﻿using System;
using System.Collections.Generic;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Repository.Host
{
	public interface IHostRepository
	{
		IList<Models.Host> GetHostList();
		Models.Host GetHost(Guid cpaId);
		void Save(Models.Host cpa);
		string GetHostHomePage(Guid cpaiId);
		void SaveHomePage(Guid cpaId, string homePage);
		Models.Host GetHostByUrl(string url);
		Models.Host GetHostByFirmName(string firmName);
	}
}