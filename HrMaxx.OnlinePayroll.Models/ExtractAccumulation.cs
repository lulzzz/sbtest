using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.OnlinePayroll.Models.Enum;
using Newtonsoft.Json;

namespace HrMaxx.OnlinePayroll.Models
{
	public class ExtractAccumulation
	{
		public ExtractType ExtractType { get; set; }
		public decimal GrossWage { get; set; }
		public decimal NetWage { get; set; }
		public int Count1 { get; set; }
		public int Count2 { get; set; }
		public int Count3 { get; set; }
		public decimal Q1Wage { get; set; }
		public decimal Q2Wage { get; set; }
		public decimal Q3Wage { get; set; }
		public decimal Q4Wage { get; set; }
		public decimal Q1Amount { get; set; }
		public decimal Q2Amount { get; set; }
		public decimal Q3Amount { get; set; }
		public decimal Q4Amount { get; set; }
		public ExtractAccumulationMode Mode { get; set; }

		public List<PayrollWorkerCompensation> WorkerCompensations { get; set; }
		public List<PayrollPayType> Compensations { get; set; }
		public List<PayrollDeduction> Deductions { get; set; }
		public List<PayrollTax> Taxes { get; set; }
		public List<PayCheck> PayChecks { get; set; }
		public List<PayCheck> CreditChecks { get; set; }
		public List<DailyAccumulation> DailyAccumulations { get; set; }
		public List<GarnishmentAgency> GarnishmentAgencies { get; set; }
		public ExtractAccumulation()
		{
			GrossWage = 0;
			NetWage = 0;
			
			Compensations=new List<PayrollPayType>();
			Deductions=new List<PayrollDeduction>();
			Taxes=new List<PayrollTax>();
			PayChecks = new List<PayCheck>();
			CreditChecks = new List<PayCheck>();
			WorkerCompensations = new List<PayrollWorkerCompensation>();
			
		}

		public List<PayrollTax> ApplicableTaxes
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

		public List<PayrollDeduction> Garnishments
		{
			get
			{
				if (ExtractType == ExtractType.Garnishment)
					return Deductions.Where(d => d.Deduction.Type.Id == 3).ToList();
				return new List<PayrollDeduction>();
			}
		}

		public decimal GarnishmentAmount
		{
			get
			{
				return Garnishments.Sum(d => d.Amount); 
				
			}
		}

		public decimal ApplicableWages
		{
			get { return ApplicableTaxes.Sum(t => t.TaxableWage); }
		}
		public decimal ApplicableAmounts
		{
			get { return ApplicableTaxes.Sum(t => t.Amount); }
		}
		public decimal EmployeeDeductions
		{
			get { return Math.Round(Deductions.Sum(t => t.Amount), 2, MidpointRounding.AwayFromZero); }
		}

		public decimal EmployeeWorkerCompensations
		{
			get { return WorkerCompensations != null ? Math.Round(WorkerCompensations.Sum(t => t.Amount), 2, MidpointRounding.AwayFromZero) : 0; }
		}
		public void Initialize(IEnumerable<PayCheck> checks, IEnumerable<PayCheck> voidedchecks, List<VendorCustomer> vendors , bool buildCounts,
			bool buildDaily, bool buildGarnishment, int year, int quarter, ExtractAccumulationMode mode=ExtractAccumulationMode.All)
		{
			Mode = mode;
			var payChecks = checks as IList<PayCheck> ?? checks.ToList();
			AddPayChecks(payChecks);
			CreditPayChecks(voidedchecks);
			SetQuarters(payChecks);
			if(buildCounts) SetCounts(year, quarter, payChecks);
			if(buildDaily) BuildDailyAccumulations(quarter, payChecks);
			if(buildGarnishment) BuildGarnishmentAccumulations(vendors, payChecks);


		}
		public void AddPayChecks(IEnumerable<PayCheck> checks)
		{
			foreach (var add in checks)
			{
				AddPayCheck(add);
			}
			
		}
		private void AddPayCheck(PayCheck add)
		{
			//if (PayChecks.All(pci => pci.Id != add.Id))
			{
				
				GrossWage += Math.Round(add.GrossWage, 2, MidpointRounding.AwayFromZero);
				NetWage += Math.Round(add.NetWage, 2, MidpointRounding.AwayFromZero);
				if (Mode == ExtractAccumulationMode.All)
				{
					AddCompensations(add.Compensations);
					AddDeductions(add.Deductions);
					AddTaxes(add.Taxes);
				}
				
				//PayChecks.Add(add);
				if (Mode == ExtractAccumulationMode.WC || Mode==ExtractAccumulationMode.All)
				{
					if (add.WorkerCompensation != null)
						AddWorkerCompensation(add.WorkerCompensation);
				}
				
			}
		}
		private void CreditPayChecks(IEnumerable<PayCheck> checks)
		{
			foreach (var add in checks)
			{
				CreditPayCheck(add);
			}

		}
		private void CreditPayCheck(PayCheck add)
		{
			//if (PayChecks.All(pci => pci.Id != add.Id))
			{
				
				GrossWage -= Math.Round(add.GrossWage, 2, MidpointRounding.AwayFromZero);
				NetWage -= Math.Round(add.NetWage, 2, MidpointRounding.AwayFromZero);
				if (Mode == ExtractAccumulationMode.All)
				{
					CreditCompensations(add.Compensations);
					CreditDeductions(add.Deductions);
					CreditTaxes(add.Taxes);
				}
				//CreditChecks.Add(add);
				if (Mode == ExtractAccumulationMode.WC || Mode == ExtractAccumulationMode.All)
				{
					CreditWorkerCompensation(add.WorkerCompensation);
				}
			}
		}
		private void AddWorkerCompensation(PayrollWorkerCompensation wcomp)
		{
			if (wcomp != null)
			{
				var wc = WorkerCompensations.FirstOrDefault(w => w.WorkerCompensation.Id == wcomp.WorkerCompensation.Id);
				if (wc != null)
				{
					wc.Wage += Math.Round(wcomp.Wage, 2, MidpointRounding.AwayFromZero);
					wc.Amount += Math.Round(wcomp.Amount, 2, MidpointRounding.AwayFromZero);
				}
				else
				{
					var temp = JsonConvert.SerializeObject(wcomp);
					WorkerCompensations.Add(JsonConvert.DeserializeObject<PayrollWorkerCompensation>(temp));
				}
			}
		}
		private void AddCompensations(IEnumerable<PayrollPayType> comps)
		{
			comps.ToList().ForEach(c =>
			{
				var c1 = Compensations.FirstOrDefault(comp => comp.PayType.Id == c.PayType.Id);
				if (c1 != null)
				{
					c1.Amount += Math.Round(c.Amount, 2, MidpointRounding.AwayFromZero);
				}
				else
				{
					var temp = JsonConvert.SerializeObject(c);
					Compensations.Add(JsonConvert.DeserializeObject<PayrollPayType>(temp));
				}
			});

		}

		private void AddDeductions(IEnumerable<PayrollDeduction> deds)
		{
			deds.ToList().ForEach(d =>
			{
				var d1 = Deductions.FirstOrDefault(ded => ded.Deduction.Id == d.Deduction.Id);
				if (d1 != null)
				{
					d1.Amount += Math.Round(d.Amount, 2, MidpointRounding.AwayFromZero);
					d1.Wage += Math.Round(d.Wage, 2, MidpointRounding.AwayFromZero);
				}
				else
				{
					var temp = JsonConvert.SerializeObject(d);
					Deductions.Add(JsonConvert.DeserializeObject<PayrollDeduction>(temp));
				}
			});

		}

		private void AddTaxes(IEnumerable<PayrollTax> taxes)
		{
			taxes.ToList().ForEach(t =>
			{

				var t1 = Taxes.FirstOrDefault(tax => tax.Tax.Code == t.Tax.Code);
				if (t1 != null)
				{
					t1.TaxableWage = Math.Round(t1.TaxableWage + t.TaxableWage, 2, MidpointRounding.AwayFromZero);
					t1.Amount = Math.Round(t1.Amount + t.Amount, 2, MidpointRounding.AwayFromZero);
				}
				else
				{
					var temp = JsonConvert.SerializeObject(t);
					Taxes.Add(JsonConvert.DeserializeObject<PayrollTax>(temp));
				}
			});

		}
		private void CreditCompensations(IEnumerable<PayrollPayType> comps)
		{
			comps.ToList().ForEach(c =>
			{
				var c1 = Compensations.FirstOrDefault(comp => comp.PayType.Id == c.PayType.Id);
				if (c1 != null)
				{
					c1.Amount -= Math.Round(c.Amount, 2, MidpointRounding.AwayFromZero);
				}
			});
		}

		private void CreditDeductions(IEnumerable<PayrollDeduction> deds)
		{
			deds.ToList().ForEach(d =>
			{
				var d1 = Deductions.FirstOrDefault(ded => ded.Deduction.Id == d.Deduction.Id);
				if (d1 != null)
				{
					d1.Amount -= Math.Round(d.Amount, 2, MidpointRounding.AwayFromZero);
					d1.Wage -= Math.Round(d.Wage, 2, MidpointRounding.AwayFromZero);
				}
			});

		}

		private void CreditTaxes(IEnumerable<PayrollTax> taxes)
		{
			taxes.ToList().ForEach(t =>
			{
				var t1 = Taxes.FirstOrDefault(tax => tax.Tax.Code == t.Tax.Code);
				if (t1 != null)
				{
					t1.TaxableWage -= Math.Round(t.TaxableWage, 2, MidpointRounding.AwayFromZero);
					t1.Amount -= Math.Round(t.Amount, 2, MidpointRounding.AwayFromZero);
				}
			});

		}
		private void CreditWorkerCompensation(PayrollWorkerCompensation wcomp)
		{
			if (wcomp != null)
			{
				var wc = WorkerCompensations.FirstOrDefault(w => w.WorkerCompensation.Id == wcomp.WorkerCompensation.Id);
				if (wc != null)
				{
					wc.Wage -= Math.Round(wcomp.Wage, 2, MidpointRounding.AwayFromZero);
					wc.Amount -= Math.Round(wcomp.Amount, 2, MidpointRounding.AwayFromZero);
				}
			}
		}

		private void SetCounts(int year, int quarter, IList<PayCheck> payChecks )
		{
			var q1date = new DateTime(year, quarter*3 - 2, 12).Date;
			var q2date = new DateTime(year, quarter*3 - 1, 12).Date;
			var q3date = new DateTime(year, quarter*3, 12).Date;
			Count1 = payChecks.Count(p => p.StartDate.Date <= q1date && p.EndDate >= q1date);
			Count2 = payChecks.Count(p => p.StartDate.Date <= q2date && p.EndDate >= q2date);
			Count3 = payChecks.Count(p => p.StartDate.Date <= q3date && p.EndDate >= q3date);
		}

		private void SetQuarters(IList<PayCheck> payChecks )
		{
			Q1Wage =
				payChecks.Where(p => p.PayDay.Month >= 1 && p.PayDay.Month <= 3)
					.Select(p => p.Taxes.First(t => t.Tax.Code.Equals("FUTA")))
					.Sum(t => t.TaxableWage);
			Q1Amount =
				payChecks.Where(p => p.PayDay.Month >= 1 && p.PayDay.Month <= 3)
					.Select(p => p.Taxes.First(t => t.Tax.Code.Equals("FUTA")))
					.Sum(t => t.Amount);
			Q2Wage =
				payChecks.Where(p => p.PayDay.Month >= 4 && p.PayDay.Month <= 6)
					.Select(p => p.Taxes.First(t => t.Tax.Code.Equals("FUTA")))
					.Sum(t => t.TaxableWage);
			Q2Amount =
				payChecks.Where(p => p.PayDay.Month >= 4 && p.PayDay.Month <= 6)
					.Select(p => p.Taxes.First(t => t.Tax.Code.Equals("FUTA")))
					.Sum(t => t.Amount);
			Q3Wage =
				payChecks.Where(p => p.PayDay.Month >= 7 && p.PayDay.Month <= 9)
					.Select(p => p.Taxes.First(t => t.Tax.Code.Equals("FUTA")))
					.Sum(t => t.TaxableWage);
			Q3Amount =
				payChecks.Where(p => p.PayDay.Month >= 7 && p.PayDay.Month <= 9)
					.Select(p => p.Taxes.First(t => t.Tax.Code.Equals("FUTA")))
					.Sum(t => t.Amount);
			Q4Wage =
				payChecks.Where(p => p.PayDay.Month >= 10 && p.PayDay.Month <= 12)
					.Select(p => p.Taxes.First(t => t.Tax.Code.Equals("FUTA")))
					.Sum(t => t.TaxableWage);
			Q4Amount =
				payChecks.Where(p => p.PayDay.Month >= 10 && p.PayDay.Month <= 12)
					.Select(p => p.Taxes.First(t => t.Tax.Code.Equals("FUTA")))
					.Sum(t => t.Amount);
		}

		private void BuildDailyAccumulations(int quarter, IEnumerable<PayCheck> payChecks )
		{
			DailyAccumulations = new List<DailyAccumulation>();
			var groups = payChecks.GroupBy(p => p.PayDay);
			
			foreach (var @group in groups)
			{
				var ea = new DailyAccumulation
				{
					Month = quarter > 0 ? @group.Key.Month % 3 > 0 ? @group.Key.Month % 3 : 3 : @group.Key.Month,
					Day = @group.Key.Day,
					Value = @group.ToList().SelectMany(p => p.Taxes.Where(t => !t.Tax.StateId.HasValue && !t.Tax.Code.Equals("FUTA"))).ToList().Sum(t => t.Amount)
				};
				DailyAccumulations.Add(ea);
			}
		}

		private void BuildGarnishmentAccumulations(IEnumerable<VendorCustomer> agencies, IList<PayCheck> payChecks  )
		{
			GarnishmentAgencies = new List<GarnishmentAgency>();
			var garnishments = payChecks.SelectMany(pc => pc.Deductions.Where(d => d.Deduction.Type.Id == 3 && d.Amount>0)).ToList();

			foreach (var @agency in agencies)
			{
				if (garnishments.Any(g => g.EmployeeDeduction.AgencyId == @agency.Id))
				{
					var ea = new GarnishmentAgency
					{
						Agency = @agency,
						Accounts = garnishments.Where(g => g.EmployeeDeduction.AgencyId == @agency.Id).Select(g => new GarnishmentAgencyAccount { Deduction = g.Deduction.DeductionName, AccountNo = g.EmployeeDeduction.AccountNo, Amount = g.Amount }).ToList(),
						PayCheckIds = payChecks.Where(pc => pc.Deductions.Any(d => d.Deduction.Type.Id == 3 && d.EmployeeDeduction.AgencyId == @agency.Id && d.Amount>0)).Select(pc => pc.Id).ToList()
					};
					GarnishmentAgencies.Add(ea);
				}
				
			}
		}



		
	}
}
