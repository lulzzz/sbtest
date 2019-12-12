﻿using System;
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
		public Guid? LastCheckCompany { get; set; }
		public string FirstName { get; set; }
		public string LastName { get; set; }
		public decimal Rate { get; set; }
		public string MiddleInitial { get; set; }
		public string Department { get; set; }
		public DateTime HireDate { get; set; }
		public DateTime BirthDate { get; set; }
		public string BirthDateString { get; set; }
		public string HireDateString { get; set; }
		public string HireDateStr {
			get { return HireDate.ToString("MM-dd-yyyy"); }
			set { } }
		public int EmpPayType { get; set; }
		public EmployeeType PayType{get
			{
				return (EmployeeType) EmpPayType;
			}}
		public CompanyWorkerCompensation CompanyWorkerCompensation { get; set; }
		public List<CompanyDeduction> CompanyDeductions { get; set; }
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

		public List<PayCheckSummary1095> PayCheck1095Summaries { get; set; } 
		public List<C1095Month> C1095Months { get; set; } 

		public decimal EmployeeTaxes { get { return Math.Round( Taxes.Where(t => t.IsEmployeeTax).Sum(t => t.YTD),2,MidpointRounding.AwayFromZero); } }
		public decimal EmployerTaxes { get { return Math.Round( Taxes.Where(t => !t.IsEmployeeTax).Sum(t => t.YTD), 2, MidpointRounding.AwayFromZero); } }
		public decimal CashRequirement { get { return Math.Round((PayCheckWages!=null ? PayCheckWages.GrossWage : 0) + EmployerTaxes, 2, MidpointRounding.AwayFromZero); } }
		public decimal EmployeeDeductions { get { return Math.Round(Deductions.Sum(d => d.YTD), 2, MidpointRounding.AwayFromZero); } }
		public decimal WorkerCompensationAmount { get { return Math.Round(WorkerCompensations.Sum(w=>w.YTD), 2, MidpointRounding.AwayFromZero); } }
        public decimal WorkerCompensationWage { get { return Math.Round(WorkerCompensations.Sum(w => w.YTDWage), 2, MidpointRounding.AwayFromZero); } }
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

		public bool HasCalifornia { get { return States != null && States.Any(s => s.CountryId == 1 && s.StateId == (int)Common.Models.Enum.States.California); } set { } }
        public bool HasTexas { get { return States != null && States.Any(s => s.CountryId == 1 && s.StateId == (int)Common.Models.Enum.States.Texas); } set { } }
        public bool HasHawaii { get { return States != null && States.Any(s => s.CountryId == 1 && s.StateId == (int)Common.Models.Enum.States.Hawaii); } set { } }
        public decimal CaliforniaEmployeeTaxes { get { return Math.Round(Taxes.Where(t => t.Tax.StateId.HasValue && t.Tax.StateId.Value == (int)Common.Models.Enum.States.California && t.Tax.IsEmployeeTax).Sum(t => t.YTD), 2, MidpointRounding.AwayFromZero); } set { } }
		public decimal CaliforniaEmployerTaxes { get { return Math.Round(Taxes.Where(t => t.Tax.StateId.HasValue && t.Tax.StateId.Value == (int)Common.Models.Enum.States.California && !t.Tax.IsEmployeeTax).Sum(t => t.YTD), 2, MidpointRounding.AwayFromZero); } set { } }
		public decimal CaliforniaTaxes { get { return Math.Round(Taxes.Where(t => t.Tax.StateId.HasValue && t.Tax.StateId.Value == (int)Common.Models.Enum.States.California).Sum(t => t.YTD), 2, MidpointRounding.AwayFromZero); } set { } }

        public decimal HawaiiEmployeeTaxes { get { return Math.Round(Taxes.Where(t => t.Tax.StateId.HasValue && t.Tax.StateId.Value == (int)Common.Models.Enum.States.Hawaii && t.Tax.IsEmployeeTax).Sum(t => t.YTD), 2, MidpointRounding.AwayFromZero); } set { } }
        public decimal HawaiiEmployerTaxes { get { return Math.Round(Taxes.Where(t => t.Tax.StateId.HasValue && t.Tax.StateId.Value == (int)Common.Models.Enum.States.Hawaii && !t.Tax.IsEmployeeTax).Sum(t => t.YTD), 2, MidpointRounding.AwayFromZero); } set { } }
        public decimal HawaiiTaxes { get { return Math.Round(Taxes.Where(t => t.Tax.StateId.HasValue && t.Tax.StateId.Value == (int)Common.Models.Enum.States.Hawaii).Sum(t => t.YTD), 2, MidpointRounding.AwayFromZero); } set { } }
        public decimal TexasTaxes { get { return Math.Round(Taxes.Where(t => t.Tax.StateId.HasValue && t.Tax.StateId.Value == (int)Common.Models.Enum.States.Texas).Sum(t => t.YTD), 2, MidpointRounding.AwayFromZero); } set { } }

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
				if (ExtractType == ExtractType.CADE9)
					return Taxes.Where(t => t.Tax.Code.Equals("ETT") || t.Tax.Code.Equals("SUI") || t.Tax.Code.Equals("SIT") || t.Tax.Code.Equals("SDI")).ToList();
				if (ExtractType == ExtractType.TXSuta)
					return Taxes.Where(t => t.Tax.Code.Equals("TX-SUTA")).ToList();
                if (ExtractType == ExtractType.HISIT)
                    return Taxes.Where(t => t.Tax.Code.Equals("HI-SIT")).ToList();
                if (ExtractType == ExtractType.HIUI)
                    return Taxes.Where(t => t.Tax.Code.Equals("HI-SUI")).ToList();
                return Taxes;

			}
			set { }
		}
		public decimal ApplicableWages
		{
			get { return ApplicableTaxes.Sum(t => t.YTDWage); }
			set { }
		}
        public decimal OutOfStateUIWages
        {
            get { return Taxes.Where(t => t.Tax.Code.Equals("HI-SUI") || t.Tax.Code.Equals("SUI") || t.Tax.Code.Equals("TX-SUTA")).Sum(t=>t.YTDWage) - ApplicableWages; }
            set { }
        }
        
        public decimal ApplicableAmounts
		{
			get { return ApplicableTaxes.Sum(t => t.YTD); }
			set { }
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
			PayCheckWages.DepositAmount += acc.PayCheckWages.DepositAmount;
			PayCheckWages.FUTARate = acc.PayCheckWages.FUTARate;
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
			PayCheckWages.DepositAmount -= acc.PayCheckWages.DepositAmount;
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

		public string C1095Line14All { get; set; }
		public string C1095Line15All { get; set; }
		public string C1095Line16All { get; set; }
		public void BuildC1095Months(Company company, decimal c1095Limit)
		{
			C1095Months = new List<C1095Month>();
			HireDateString = HireDate.ToString("MM-dd-yyyy");
			BirthDateString = BirthDate==DateTime.MinValue ? string.Empty :  BirthDate.ToString("MM-dd-yyyy");
			var months = PayCheck1095Summaries.GroupBy(pc => pc.PayDay.Month).ToList();
			months.ForEach(m =>
			{
				var monthVal = new C1095Month
				{
					Month = m.Key,
					IsFullTime = getIsFullTime(m.ToList(), company.MinWage),
					IsNonNewHire = getIsNonNewHire(m.ToList()),
					Value = m.ToList().SelectMany(pc => pc.Deductions).Sum(d => d.Amount),
					Checks = m.Count(),
					IsEnrolled = ((company.FileUnderHost) || (!company.FileUnderHost && company.Deductions.Any(d=>d.DeductionType.Id==10))) && m.ToList().Any(pc => pc.Deductions.Any()),
					Code14 = m.ToList().Any() ? "1E" : "1H"
				};
				var capValue = Math.Round(m.ToList().Sum(d => d.GrossWage)*c1095Limit/100, 2, MidpointRounding.AwayFromZero);
				if (monthVal.Value > capValue)
					monthVal.Value = capValue;

				C1095Months.Add(monthVal);
			});
			for (var i = 1; i <= 12; i++)
			{
				if (C1095Months.All(c => c.Month != i))
				{
					C1095Months.Add(new C1095Month{Month=i, IsFullTime = false, Checks = 0, Value=0, IsEnrolled = false, IsNonNewHire = false, Code14 = "1H"});
				}
				var m = C1095Months.First(c => c.Month == i);
				if (m.Checks == 0)
					m.Code16 = "2A";
				else if (!m.IsFullTime || m.IsNonNewHire)
					m.Code16 = "2B";
				else if (m.IsEnrolled)
					m.Code16 = "2C";
				else
				{
					m.Code16 = "2F";
				}
			}
			C1095Line14All = C1095Months.Select(c=>c.Code14).Distinct().Count()==1 ? C1095Months[0].Code14 : string.Empty;
			C1095Line15All = C1095Months.Select(c => c.Value).Distinct().Count() == 1 ? C1095Months[0].Value.ToString("##,##0.00") : string.Empty;
			C1095Line16All = C1095Months.Select(c => c.Code16).Distinct().Count() == 1 ? C1095Months[0].Code16 : string.Empty;
		}

		public bool getIsFullTime(List<PayCheckSummary1095> checks, decimal minWage )
		{
			decimal hours = 0;
			if (PayType == EmployeeType.Hourly || PayType==EmployeeType.PieceWork)
			{
				hours = checks.Sum(pc => pc.PayCodes.Sum(pcc => pcc.Hours + pcc.OvertimeHours));
				
			}
			else if (PayType == EmployeeType.Salary)
			{
				hours = checks.Sum(pc => pc.GrossWage)/minWage;
			}
			else if (PayType == EmployeeType.JobCost)
			{
				hours = checks.Sum(pc => pc.PayCodes.Where(pcc=>pcc.PayCode.Id==0).Sum(pcc=>pcc.Hours + pcc.OvertimeHours));
			}

			

			if (hours >= 120) 
				return true;

			return false;
		}

		public bool getIsNonNewHire(List<PayCheckSummary1095> checks)
		{
			var maxPayDay = checks.Max(pc => pc.PayDay);
			var diff = (maxPayDay - HireDate).TotalDays;
			return diff < 90 ? true : false;
		}
	}
}
