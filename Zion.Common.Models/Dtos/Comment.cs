using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.Common.Models.Dtos
{
	public class Comment : BaseEntityDto
	{
		public string Content { get; set; }
		public DateTime TimeStamp { get; set; }
	}

	public class CommentList
	{
		public List<Comment> Comments { get; set; } 
	}
}
