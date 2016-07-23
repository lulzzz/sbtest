using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Contracts.Services
{
	public interface IHostService
	{
		IList<Host> GetHostList(Guid host);
		Host GetHost(Guid cpaId);
		void Save(Host cpa);

		HostHomePage GetHostHomePage(Guid cpaId);
		HostHomePage SaveHomePage(Guid stagingId, Guid cpaId, HostHomePage homePage);
		void AddHomePageImageToStaging(HostHomePageDocument homePageDocument);
		object GetHostHomePageByUrl(string url, Guid host);
		object GetNewsfeedMetaData(RoleTypeEnum role, Guid? entityId);
		object GetHostHomePageByFirmName(string firmName, Guid host);
	}
}
