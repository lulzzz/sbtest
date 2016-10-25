using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.Common.Models
{
	public class ExcelRead
	{
		public int Row { get; set; }
		public List<KeyValuePair<string, string>> Values;

		public string Value(string key)
		{
			return Values.Any(v => v.Key.Equals(key.ToLower())) ? Values.First(v=>v.Key.Equals(key.ToLower())).Value : string.Empty;
		} 
	}


	
}
