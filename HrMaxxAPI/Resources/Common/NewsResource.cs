using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Attributes;
using HrMaxx.Infrastructure.Helpers;

namespace HrMaxxAPI.Resources.Common
{
	public class NewsResource : BaseRestResource
	{
		public string Title { get; set; }
		public string NewsContent { get; set; }
		public int? AudienceScope { get; set; }
		public List<IdValuePair> Audience { get; set; }
		public DateTime TimeStamp { get; set; }

		public string AudienceScopeText
		{
			get
			{
				return AudienceScope.HasValue
					? HrMaaxxSecurity.GetEnumFromDbId<RoleTypeEnum>(AudienceScope.Value).GetDbName()
					: "All";
			}
		}

		public string TargetAudienceText
		{
			get
			{
				var ta =  !Audience.Any() ? "All" : Audience.Aggregate(string.Empty, (current, a) => current + a.Value + ", ");
				return ta.Equals("All") ? ta : ta.Substring(0, ta.Length - 2);
			}
		}
	}
}