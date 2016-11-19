using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;

namespace HrMaxx.OnlinePayroll.Models
{
	public class SearchResult
	{
		public int Id { get; set; }
		public EntityTypeEnum SourceTypeId { get; set; }
		public Guid SourceId { get; set; }
		public Guid? HostId { get; set; }
		public Guid? CompanyId { get; set; }
		public string SearchText { get; set; }

		public string SourceType
		{
			get { return SourceTypeId.GetDbName(); }
		}
	}

	public class SearchResults
	{
		public List<SearchResult> Results;
	}
}
