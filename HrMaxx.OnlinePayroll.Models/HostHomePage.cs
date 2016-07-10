using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;

namespace HrMaxx.OnlinePayroll.Models
{
	public class HostHomePage : BaseEntityDto
	{
		public DocumentDto Logo { get; set; }
		public DocumentDto Contact { get; set; }
		public string Profile { get; set; }
		public string Services { get; set; }
		public string Email { get; set; }
		public string Telephone { get; set; }
		public string Fax { get; set; }
		public List<ContactHours> ContactHours { get; set; }

		public void InitializeContactHours()
		{
			ContactHours = new List<ContactHours>();
			ContactHours.Add(new ContactHours { Description = "Monday - Friday", From = DateTime.Now, To = DateTime.Now, IsClosed = false });
			ContactHours.Add(new ContactHours { Description = "Saturday", From = DateTime.Now, To = DateTime.Now, IsClosed = false });
			ContactHours.Add(new ContactHours { Description = "Sunday", IsClosed = true });
		}
	}

	public class ContactHours
	{
		public string Description { get; set; }
		public DateTime From { get; set; }
		public DateTime To { get; set; }
		public bool IsClosed { get; set; }
	}
}
