using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	[Serializable]
	[XmlRoot("JournalList")]
	public class JournalJson
	{
		public int Id { get; set; }
		public int TransactionType { get; set; }
		public int PaymentMethod { get; set; }
		public int CheckNumber { get; set; }
		public int? PayrollPayCheckId { get; set; }
		public int EntityType { get; set; }
		public Guid PayeeId { get; set; }
		public decimal Amount { get; set; }
		public string Memo { get; set; }
		public bool IsDebit { get; set; }
		public bool IsVoid { get; set; }
		public DateTime TransactionDate { get; set; }
		public DateTime LastModified { get; set; }
		public string LastModifiedBy { get; set; }
		public string JournalDetails { get; set; }
		public Guid CompanyId { get; set; }
		public string PayeeName { get; set; }
		public int MainAccountId { get; set; }
		public Guid DocumentId { get; set; }
		public bool PEOASOCoCheck { get; set; }
		public DateTime? OriginalDate { get; set; }
		public bool IsReIssued { get; set; }
		public int? OriginalCheckNumber { get; set; }
		public DateTime? ReIssuedDate { get; set; }
	}
}
