﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.Common.Models.Dtos
{
	public class Contact : BaseEntityDto
	{
		public string FirstName { get; set; }
		public string LastName { get; set; }
		public string MiddleInitial { get; set; }
		public string Email { get; set; }
		public string Phone { get; set; }
		public string Mobile { get; set; }
		public string Fax { get; set; }
		public bool IsPrimary { get; set; }
		public Address Address { get; set; }

		public string FullName
		{
			get { return string.Format("{0} {1} {2}", FirstName, MiddleInitial, LastName); }
		}
	}
}
