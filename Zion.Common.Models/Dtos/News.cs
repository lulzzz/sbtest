using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.Common.Models.Dtos
{
	public class News : BaseEntityDto
	{
		public string Title { get; set; }
		public string NewsContent { get; set; }
		public int? AudienceScope { get; set; }
		public string Audience { get; set; }
		public bool IsActive { get; set; }
		public DateTime TimeStamp { get; set; }
	}
}
