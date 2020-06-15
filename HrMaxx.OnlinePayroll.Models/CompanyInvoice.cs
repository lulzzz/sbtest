using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;
using Newtonsoft.Json;

namespace HrMaxx.OnlinePayroll.Models
{
	public class CompanyInvoice : IOriginator<CompanyInvoice>
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public int CompanyIntId { get; set; }
		public int InvoiceNumber { get; set; }
		public Guid PayeeId { get; set; }
		public string PayeeName { get; set; }
		public Contact Contact { get; set; }
		public decimal Amount { get; set; }
		
		public DateTime InvoiceDate { get; set; }
		public string Memo { get; set; }
		public bool IsVoid { get; set; }
		public List<JournalItem> ListItems { get; set; }
		public string ListItemsDb { get { return JsonConvert.SerializeObject(ListItems); } }
		public string LastModifiedBy { get; set; }
		public DateTime LastModified { get; set; }
		

		public Guid MementoId
		{
			get
			{
				var str = string.Format("{0}-0000-0000-0000-{1}", EntityTypeEnum.CompanyInvoice.GetDbId().ToString().PadLeft(8, '0'),	Id.ToString().PadLeft(12, '0'));
				return new Guid(str);
			}
		}
		public void ApplyMemento(Memento<CompanyInvoice> memento)
		{
			throw new NotImplementedException();
		}
	}
	
}
