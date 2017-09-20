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
		public ExtractType ExtractType { get; set; }
		public int Quarter { get; set; }
		public int Month { get; set; }
		public int Year { get; set; }
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
		public List<PayCheckSummary> PayCheckList { get; set; }
		public List<PayCheckSummary> VoidedPayCheckList { get; set; } 
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
		public decimal Regular { get { return Math.Round(PayCodes.Sum(pc => pc.YTDAmount), 2, MidpointRounding.AwayFromZero); } set { } }
		public decimal TotalCompensations { get { return Math.Round(Compensations.Sum(pc => pc.YTD), 2, MidpointRounding.AwayFromZero); } set { } }

		public List<PayCheckTax> ApplicableTaxes
		{
			get
			{
				if (ExtractType == ExtractType.Federal940)
					return Taxes.Where(t => t.Tax.Code.Equals("FUTA")).ToList();
				if (ExtractType == ExtractType.Federal941)
					return Taxes.Where(t => !t.Tax.StateId.HasValue && !t.Tax.Code.Equals("FUTA")).ToList();
				if (ExtractType == ExtractType.CAPITSDI)
					return Taxes.Where(t => t.Tax.Code.Equals("SIT") || t.Tax.Code.Equals("SDI")).ToList();
				if (ExtractType == ExtractType.CAETTUI)
					return Taxes.Where(t => t.Tax.Code.Equals("ETT") || t.Tax.Code.Equals("SUI")).ToList();

				return Taxes;

			}
		}
		public decimal ApplicableWages
		{
			get { return ApplicableTaxes.Sum(t => t.YTDWage); }
		}
		public decimal ApplicableAmounts
		{
			get { return ApplicableTaxes.Sum(t => t.YTD); }
		}

		public void AddAccumulation(Accumulation acc)
		{
			PayCheckWages.GrossWage += acc.PayCheckWages.GrossWage;
			PayCheckWages.Salary += acc.PayCheckWages.Salary;
			PayCheckWages.NetWage += acc.PayCheckWages.NetWage;
			PayCheckWages.CheckPay += acc.PayCheckWages.CheckPay;
			PayCheckWages.DDPay += acc.PayCheckWages.DDPay;
			PayCheckWages.Quarter1FUTA += acc.PayCheckWages.Quarter1FUTA;
			PayCheckWages.Quarter2FUTA += acc.PayCheckWages.Quarter2FUTA;
			PayCheckWages.Quarter3FUTA += acc.PayCheckWages.Quarter3FUTA;
			PayCheckWages.Quarter4FUTA += acc.PayCheckWages.Quarter4FUTA;
			PayCheckWages.Quarter1FUTAWage += acc.PayCheckWages.Quarter1FUTAWage;
			PayCheckWages.Quarter2FUTAWage += acc.PayCheckWages.Quarter2FUTAWage;
			PayCheckWages.Quarter3FUTAWage += acc.PayCheckWages.Quarter3FUTAWage;
			PayCheckWages.Quarter4FUTAWage += acc.PayCheckWages.Quarter4FUTAWage;
			PayCheckWages.Twelve1 += acc.PayCheckWages.Twelve1;
			PayCheckWages.Twelve2 += acc.PayCheckWages.Twelve2;
			PayCheckWages.Twelve3 += acc.PayCheckWages.Twelve3;
			PayCheckWages.Immigrants += acc.PayCheckWages.Immigrants;

			PayCheckList.AddRange(acc.PayCheckList);
			acc.Taxes.ForEach(t1 =>
			{
				var t = Taxes.FirstOrDefault(t2 => t2.TaxId == t1.TaxId);
				if (t == null)
					Taxes.Add(JsonConvert.DeserializeObject<PayCheckTax>(JsonConvert.SerializeObject(t1)));
				else
				{
					t.YTD += t1.YTD;
					t.YTDWage += t1.YTDWage;
				}
			});
			acc.Deductions.ForEach(d1 =>
			{
				var d = Deductions.FirstOrDefault(d2 => d2.CompanyDeductionId == d1.CompanyDeductionId);
				if (d == null)
					Deductions.Add(JsonConvert.DeserializeObject<PayCheckDeduction>(JsonConvert.SerializeObject(d1)));
				else
				{
					d.YTD += d1.YTD;
					d.YTDWage += d1.YTDWage;
				}
			});
			acc.Compensations.ForEach(c1 =>
			{
				var c = Compensations.FirstOrDefault(c2 => c2.PayTypeId == c1.PayTypeId);
				if (c == null)
					Compensations.Add(JsonConvert.DeserializeObject<PayCheckCompensation>(JsonConvert.SerializeObject(c1)));
				else
				{
					c.YTD += c1.YTD;
				}
			});
			acc.WorkerCompensations.ForEach(c1 =>
			{
				var c = WorkerCompensations.FirstOrDefault(c2 => c2.WorkerCompensationId == c1.WorkerCompensationId);
				if (c == null)
					WorkerCompensations.Add(JsonConvert.DeserializeObject<PayCheckWorkerCompensation>(JsonConvert.SerializeObject(c1)));
				else
				{
					c.YTD += c1.YTD;
				}
			});
			acc.PayCodes.ForEach(c1 =>
			{
				var c = PayCodes.FirstOrDefault(c2 => c2.PayCodeId == c1.PayCodeId);
				if (c == null)
					PayCodes.Add(JsonConvert.DeserializeObject<PayCheckPayCode>(JsonConvert.SerializeObject(c1)));
				else
				{
					c.YTDAmount += c1.YTDAmount;
					c.YTDOvertime += c1.YTDOvertime;
				}
			});
			acc.DailyAccumulations.ForEach(d1 =>
			{
				var d = DailyAccumulations.FirstOrDefault(d2 => d2.Month == d1.Month && d2.Day == d1.Day);
				if (d == null) DailyAccumulations.Add(JsonConvert.DeserializeObject<DailyAccumulation>(JsonConvert.SerializeObject(d1)));
				else d.Value += d1.Value;
			});
			acc.MonthlyAccumulations.ForEach(d1 =>
			{
				var d = MonthlyAccumulations.FirstOrDefault(d2 => d2.Month == d1.Month);
				if (d == null) MonthlyAccumulations.Add(JsonConvert.DeserializeObject<MonthlyAccumulation>(JsonConvert.SerializeObject(d1)));
				else
				{
					d.IRS940 += d1.IRS940;
					d.IRS941 += d1.IRS941;
					d.EDD += d1.EDD;
				}
			});
		}
		public void SubtractAccumulation(Accumulation acc)
		{
			PayCheckWages.GrossWage -= acc.PayCheckWages.GrossWage;
			PayCheckWages.Salary -= acc.PayCheckWages.Salary;
			PayCheckWages.NetWage -= acc.PayCheckWages.NetWage;
			PayCheckWages.CheckPay -= acc.PayCheckWages.CheckPay;
			PayCheckWages.DDPay -= acc.PayCheckWages.DDPay;
			PayCheckWages.Quarter1FUTA -= acc.PayCheckWages.Quarter1FUTA;
			PayCheckWages.Quarter2FUTA -= acc.PayCheckWages.Quarter2FUTA;
			PayCheckWages.Quarter3FUTA -= acc.PayCheckWages.Quarter3FUTA;
			PayCheckWages.Quarter4FUTA -= acc.PayCheckWages.Quarter4FUTA;
			PayCheckWages.Quarter1FUTAWage -= acc.PayCheckWages.Quarter1FUTAWage;
			PayCheckWages.Quarter2FUTAWage -= acc.PayCheckWages.Quarter2FUTAWage;
			PayCheckWages.Quarter3FUTAWage -= acc.PayCheckWages.Quarter3FUTAWage;
			PayCheckWages.Quarter4FUTAWage -= acc.PayCheckWages.Quarter4FUTAWage;
			
			PayCheckWages.Immigrants -= acc.PayCheckWages.Immigrants;

			VoidedPayCheckList.AddRange(acc.VoidedPayCheckList);
			acc.Taxes.ForEach(t1 =>
			{
				var t = Taxes.FirstOrDefault(t2 => t2.TaxId == t1.TaxId);
				if (t != null)
					
				{
					t.YTD -= t1.YTD;
					t.YTDWage -= t1.YTDWage;
				}
			});
			acc.Deductions.ForEach(d1 =>
			{
				var d = Deductions.FirstOrDefault(d2 => d2.CompanyDeductionId == d1.CompanyDeductionId);
				if (d != null)
				{
					d.YTD -= d1.YTD;
					d.YTDWage -= d1.YTDWage;
				}
			});
			acc.Compensations.ForEach(c1 =>
			{
				var c = Compensations.FirstOrDefault(c2 => c2.PayTypeId == c1.PayTypeId);
				if (c != null)
					
				{
					c.YTD -= c1.YTD;
				}
			});
			acc.WorkerCompensations.ForEach(c1 =>
			{
				var c = WorkerCompensations.FirstOrDefault(c2 => c2.WorkerCompensationId == c1.WorkerCompensationId);
				if (c != null)
					
				{
					c.YTD -= c1.YTD;
				}
			});
			acc.PayCodes.ForEach(c1 =>
			{
				var c = PayCodes.FirstOrDefault(c2 => c2.PayCodeId == c1.PayCodeId);
				if (c != null)
					
				{
					c.YTDAmount -= c1.YTDAmount;
					c.YTDOvertime -= c1.YTDOvertime;
				}
			});
			acc.DailyAccumulations.ForEach(d1 =>
			{
				var d = DailyAccumulations.FirstOrDefault(d2 => d2.Month == d1.Month && d2.Day == d1.Day);
				if (d != null) 
				 d.Value -= d1.Value;
			});
			acc.MonthlyAccumulations.ForEach(d1 =>
			{
				var d = MonthlyAccumulations.FirstOrDefault(d2 => d2.Month == d1.Month);
				if (d != null) 
				{
					d.IRS940 -= d1.IRS940;
					d.IRS941 -= d1.IRS941;
					d.EDD -= d1.EDD;
				}
			});
		}
		
	}
}
