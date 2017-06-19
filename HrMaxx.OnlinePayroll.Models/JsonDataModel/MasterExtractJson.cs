using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	[Serializable]
	[XmlRoot("MasterExtractList")]
	public class MasterExtractJson
	{
		public int Id { get; set; }
    public string Extract { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public string ExtractName { get; set; }
    public bool IsFederal { get; set; }
    public DateTime DepositDate { get; set; }
    public string Journals { get; set; }
    public DateTime LastModified { get; set; }
    public string LastModifiedBy { get; set; }
		public string ConfirmationNo { get; set; }
		public string ConfirmationNoUser { get; set; }
		public DateTime? ConfirmationNoTS { get; set; }
    
	}
}
