using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HrMaxxAPI.Resources
{
	public class ProfitStarsRequest
	{
		public string Url { get; set; }
		public string Data { get; set; }
		public byte[] DataBytes { get { return System.Text.Encoding.ASCII.GetBytes(Data); } }
	}
}