using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using HrMaxx.Infrastructure.Security;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	[Serializable]
	[XmlRoot("ProfitStarsPaymentList")]
	public class ProfitStarsPaymentJson
	{
		public int Id { get; set; }
		public int Type { get; set; }
		public Guid CompanyId { get; set; }
		public Guid EmployeeId { get; set; }
		public decimal Amount { get; set; }
		public DateTime EnteredDate { get; set; }
		public int AccType { get; set; }
		public string AccNum { get; set; }
		public string RoutingNum { get; set; }
		public ProfitStarsPayResponse PayResponse { get; set; }
	}
	
}
