using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace HrMaxxAPI.Resources.Journals
{
	public class JournalFilterResource
	{
		[Required]
		public Guid CompanyId { get; set; }
		[Required]
		public int AccountId { get; set; }
		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
		public bool IncludePayrolls { get; set; }
	}
}