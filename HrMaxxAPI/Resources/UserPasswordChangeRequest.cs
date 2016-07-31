using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace HrMaxxAPI.Resources
{
	public class UserPasswordChangeRequest
	{
		[Required]
		public string OldPassword { get; set; }
		[Required]
		public string NewPassword { get; set; }
		[Required]
		public string ConfirmPassword { get; set; }
	}
}