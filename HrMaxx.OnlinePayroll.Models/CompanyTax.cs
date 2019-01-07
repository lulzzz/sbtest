using System;


namespace HrMaxx.OnlinePayroll.Models
{
	public class CaliforniaCompanyTax
	{
		public Guid CompanyId { get; set; }
		public string CompanyName { get; set; }
		public string StateEin { get; set; }
		public int UITaxId { get; set; }
		public int ETTTaxId { get; set; }
		public int TaxYear { get; set; }
		public Decimal UiRate { get; set; }
		public Decimal EttRate { get; set; }
		public string SUIManagementRate { get; set; }
		
	}
}
