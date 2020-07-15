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
		public int InvoiceNumber { get; set; }
		public Guid PayeeId { get; set; }
		public string PayeeName { get; set; }
		public Contact Contact { get; set; }
			
		public DateTime InvoiceDate { get; set; }
		public string Memo { get; set; }
		public bool IsVoid { get; set; }
		public List<JournalItem> ListItems { get; set; }
		public List<CompanyInvoiceItem> InvoiceItems { get; set; }
		public decimal SalesTaxRate { get; set; }
		public decimal DiscountRate { get; set; }
		public DeductionMethod DiscountType { get; set; }
		public decimal Amount { get { return Math.Round(InvoiceItems.Sum(ii => ii.Amount), 2, MidpointRounding.AwayFromZero); } set { } }
		public decimal Discount { get { return Math.Round( DiscountType==DeductionMethod.Amount ? DiscountRate : (Amount * DiscountRate/100),2,MidpointRounding.AwayFromZero); } set { } }
		public decimal SalesTax { get { return Math.Round(InvoiceItems.Where(ii=>ii.IsTaxable).Sum(ii=>ii.Amount*SalesTaxRate/100), 2, MidpointRounding.AwayFromZero) ; } set { } }
		public decimal Total { get { return Math.Round( Amount + SalesTax - Discount, 2, MidpointRounding.AwayFromZero); } set { } }
		public decimal Balance { get { return Total - InvoicePayments.Sum(p => p.Amount); } }
		public DateTime DueDate { get; set; }
		public List<InvoicePayment> InvoicePayments { get; set; }
		
		public string ListItemsDb { get { return JsonConvert.SerializeObject(ListItems); } }
		public string LastModifiedBy { get; set; }
		public DateTime LastModified { get; set; }
		
		public bool IsQuote { get; set; }
		public Guid MementoId
		{
			get
			{
				var str = string.Format("{0}-0000-0000-0000-{1}", EntityTypeEnum.CompanyInvoice.GetDbId().ToString().PadLeft(8, '0'),	Id.ToString().PadLeft(12, '0'));
				return new Guid(str);
			}
		}
		public int DaysOverdue
		{
			get
			{
				if (Balance > 0)
				{
					return DueDate.Date.Subtract(InvoiceDate.Date).Days;				

				}
				return 0;
			}
		}
		public void ApplyMemento(Memento<CompanyInvoice> memento)
		{
			throw new NotImplementedException();
		}
	}
	public class CompanyInvoiceItem
	{
		public int Id { get; set; }
		public Product Product { get; set; }
		public string Description { get; set; }
		public decimal Rate { get; set; }
		public decimal Quantity { get; set; }
		public decimal Amount { get { return Math.Round(Rate * Quantity, 2, MidpointRounding.AwayFromZero); } set { } }
		public bool IsTaxable { get; set; }
	}
	public class Product
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public string Name { get; set; }
		public string SerialNo { get; set; }
		public int Type { get; set; }
		public decimal CostPrice { get; set; }
		public decimal SalePrice { get; set; }
		public bool IsTaxable { get; set; }
		public string LastModifiedBy { get; set; }
		public DateTime LastModified { get; set; }
	}
	
}
