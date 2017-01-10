using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;

namespace HrMaxxAPI.Resources.Common
{
	public class CaliforniaCompanyTaxResource
	{
		public Guid? CompanyId { get; set; }
		public string CompanyName { get; set; }
		public string Edd { get; set; }
		public string StateEin { get; set; }
		public int UITaxId { get; set; }
		public int ETTTaxId { get; set; }
		public int TaxYear { get; set; }
		public Decimal UiRate { get; set; }
		public Decimal EttRate { get; set; }
		public Decimal DefaultUiRate { get; set; }
		public Decimal DefaultEttRate { get; set; }

		public void FillFromImport(ExcelRead er, List<TaxByYear> companyOverrideableTaxes, List<Company> companies, int year)
		{
			Edd = er.ValueFromContains("EDD");
			var ui = er.ValueFromContains("UI");
			var ett = er.ValueFromContains("ett");

			var company =
				companies.FirstOrDefault(c => c.StatusId==StatusOption.Active && c.States.Any(s => s.CountryId == 1 && s.State.StateId == 1 && s.StateEIN.Equals(Edd)));

			var uiVal = (decimal)0;
			var ettVal = (decimal)0;
			decimal.TryParse(ui, out uiVal);
			decimal.TryParse(ett, out ettVal);

			
			UITaxId = 10;
			ETTTaxId = 9;
			TaxYear = year;
			UiRate = uiVal;
			EttRate = ettVal;

			if (company != null)
			{
				CompanyId = company.Id;
				CompanyName = company.Name;
				StateEin = Edd;
			}

			DefaultUiRate = companyOverrideableTaxes.First(t => t.Tax.Code.Equals("SUI")).Tax.DefaultRate;
			DefaultEttRate = companyOverrideableTaxes.First(t => t.Tax.Code.Equals("ETT")).Tax.DefaultRate;
		}
	}
}