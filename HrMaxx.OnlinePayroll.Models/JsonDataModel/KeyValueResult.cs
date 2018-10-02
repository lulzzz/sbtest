using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	[Serializable]
	[XmlRoot("KeyValueResultList")]
	public class KeyValueResult
	{
		public int Key { get; set; }
		public string Value { get; set; }
	}
}
