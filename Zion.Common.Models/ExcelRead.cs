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
			return Values.Any(v => v.Key.ToLower().Equals(key.ToLower())) ? Values.First(v=>v.Key.ToLower().Equals(key.ToLower())).Value : string.Empty;
		}

		public string ValueFromContains(string key)
		{
			return Values.Any(v => v.Key.ToLower().Contains(key.ToLower())) ? Values.First(v => v.Key.ToLower().Contains(key.ToLower())).Value : string.Empty;
		}
	}

	public class ImportMap
	{
		
		public int StartingRow { get; set; }
		
		public int ColumnCount { get; set; }
		public List<KeyValuePair<string, int>> ColumnMap { get; set; }
	}
	
}
