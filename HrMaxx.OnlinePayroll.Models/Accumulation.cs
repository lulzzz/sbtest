using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Security;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;
using Newtonsoft.Json;

namespace HrMaxx.OnlinePayroll.Models
{
	public class Accumulation
	{
		public int Quarter { get; set; }
		public int Month { get; set; }
		public DateTime StartDate { get; set; }
		public DateTime EndDate { get; set; }
		public Guid? CompanyId { get; set; }
		public string CompanyName { get; set; }
		public string FEIN { get; set; }
		public string FPIN { get; set; }
		public string FederalEIN { get { return Crypto.Decrypt(FEIN); } }
		public string FederalPIN { get { return Crypto.Decrypt(FPIN); } }

		public Guid? EmployeeId { get; set; }
		public string FirstName { get; set; }
		public string LastName { get; set; }
		public string MiddleInitial { get; set; }
		public string Department { get; set; }
		public DateTime HireDate { get; set; }
		public int EmpPayType { get; set; }
		public EmployeeType PayType{get
			{
				return (EmployeeType) EmpPayType;
			}}

		public string ContactStr { get; set; }
		public Contact Contact { 
			get
			{
				return !string.IsNullOrWhiteSpace(ContactStr) ? JsonConvert.DeserializeObject<Contact>(ContactStr) : default(Contact);
			}
			set { }
		}

		public string SSN { get; set; }
		public string SSNVal { get { return !string.IsNullOrWhiteSpace(SSN) ? Crypto.Decrypt(SSN) : string.Empty; } set{} }
		public PayCheckWages PayCheckWages { get; set; }
		public List<PayCheckTax> Taxes { get; set; }
		public List<PayCheckDeduction> Deductions { get; set; }
		public List<PayCheckWorkerCompensation> WorkerCompensations { get; set; }
		public List<PayCheckPayCode> PayCodes { get; set; }
		public List<PayCheckCompensation> Compensations { get; set; }
		public List<PayCheckPayTypeAccumulation> Accumulations { get; set; }
		public List<PayCheckPayTypeAccumulation> PreviousAccumulations { get; set; }

		public List<ExtractTaxState> States { get; set; }

		public List<DailyAccumulation> DailyAccumulations { get; set; }
		public List<MonthlyAccumulation> MonthlyAccumulations { get; set; } 

		public decimal EmployeeTaxes { get { return Math.Round( Taxes.Where(t => t.IsEmployeeTax).Sum(t => t.YTD),2,MidpointRounding.AwayFromZero); } }
		public decimal EmployerTaxes { get { return Math.Round( Taxes.Where(t => !t.IsEmployeeTax).Sum(t => t.YTD), 2, MidpointRounding.AwayFromZero); } }
		public decimal CashRequirement { get { return Math.Round(PayCheckWages.GrossWage + EmployerTaxes, 2, MidpointRounding.AwayFromZero); } }
		public decimal EmployeeDeductions { get { return Math.Round(Deductions.Sum(d => d.YTD), 2, MidpointRounding.AwayFromZero); } }
		public decimal WorkerCompensationAmount { get { return Math.Round(WorkerCompensations.Sum(w=>w.YTD), 2, MidpointRounding.AwayFromZero); } }
		public decimal IRS940 { 
			get
			{
				return Math.Round(Taxes.Where(t => !t.Tax.StateId.HasValue && t.Tax.Code.Equals("FUTA")).Sum(t => t.YTD),2,MidpointRounding.AwayFromZero);
			}
			set { }
		}
		public decimal IRS941
		{
			get
			{
				return Math.Round( Taxes.Where(t => !t.Tax.StateId.HasValue && !t.Tax.Code.Equals("FUTA")).Sum(t => t.YTD),2,MidpointRounding.AwayFromZero);
			}
			set { }
		}
		public decimal FederalTaxes { get { return Math.Round(Taxes.Where(t => !t.Tax.StateId.HasValue).Sum(t => t.YTD), 2, MidpointRounding.AwayFromZero); } set { } }

		public string FullName { get { return string.Format("{0} {1} {2}", FirstName, MiddleInitial, LastName); } set { } }

		public bool HasCalifornia { get { return States != null && States.Any(s => s.CountryId == 1 && s.StateId == 1); } set { } }
		public decimal CaliforniaEmployeeTaxes { get { return Math.Round(Taxes.Where(t => t.Tax.StateId.HasValue && t.Tax.StateId.Value == 1 && t.Tax.IsEmployeeTax).Sum(t => t.YTD), 2, MidpointRounding.AwayFromZero); } set { } }
		public decimal CaliforniaEmployerTaxes { get { return Math.Round(Taxes.Where(t => t.Tax.StateId.HasValue && t.Tax.StateId.Value == 1 && !t.Tax.IsEmployeeTax).Sum(t => t.YTD), 2, MidpointRounding.AwayFromZero); } set { } }
		public decimal CaliforniaTaxes { get { return Math.Round(Taxes.Where(t => t.Tax.StateId.HasValue && t.Tax.StateId.Value == 1).Sum(t => t.YTD), 2, MidpointRounding.AwayFromZero); } set { } }

		public decimal Overtime { get { return Math.Round(PayCodes.Sum(pc => pc.YTDOvertime), 2, MidpointRounding.AwayFromZero); } set { } }
		
	}
}
