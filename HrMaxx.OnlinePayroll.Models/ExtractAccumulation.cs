using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace HrMaxx.OnlinePayroll.Models
{
	public class ExtractAccumulation
	{
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
		public List<PayrollWorkerCompensation> WorkerCompensations { get; set; }
		public List<PayrollPayType> Compensations { get; set; }
		public List<PayrollDeduction> Deductions { get; set; }
		public List<PayrollTax> Taxes { get; set; }
		public List<PayCheck> PayChecks { get; set; }
		public List<PayCheck> CreditChecks { get; set; }
		public List<DailyAccumulation> DailyAccumulations { get; set; }
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

		public decimal Wages940
		{
			get { return Taxes.Where(t => t.Tax.Id == 6).Sum(t => t.TaxableWage); }
		}
		public decimal Wages941
		{
			get { return Taxes.Where(t => t.Tax.Id ==1 || t.Tax.Id==2 || t.Tax.Id==4).Sum(t => t.TaxableWage); }
		}
		public decimal Taxes940
		{
			get { return Taxes.Where(t => t.Tax.Id == 6).Sum(t => t.Amount); }
		}
		public decimal Taxes941
		{
			get { return Taxes.Where(t => t.Tax.Id == 1 || t.Tax.Id == 2 || t.Tax.Id == 4).Sum(t => t.Amount); }
		}
		public void AddPayChecks(IEnumerable<PayCheck> checks)
		{
			foreach (var add in checks)
			{
				AddPayCheck(add);
			}

		}
		public void AddPayCheck(PayCheck add)
		{
			if (PayChecks.All(pci => pci.Id != add.Id))
			{
				
				GrossWage += Math.Round(add.GrossWage, 2, MidpointRounding.AwayFromZero);
				NetWage += Math.Round(add.NetWage, 2, MidpointRounding.AwayFromZero);
				
				AddCompensations(add.Compensations);
				AddDeductions(add.Deductions);
				AddTaxes(add.Taxes);
				PayChecks.Add(add);
				if(add.WorkerCompensation!=null)
					AddWorkerCompensation(add.WorkerCompensation);
			}
		}
		public void CreditPayChecks(IEnumerable<PayCheck> checks)
		{
			foreach (var add in checks)
			{
				CreditPayCheck(add);
			}

		}
		public void CreditPayCheck(PayCheck add)
		{
			if (PayChecks.All(pci => pci.Id != add.Id))
			{
				
				GrossWage -= Math.Round(add.GrossWage, 2, MidpointRounding.AwayFromZero);
				NetWage -= Math.Round(add.NetWage, 2, MidpointRounding.AwayFromZero);

				CreditCompensations(add.Compensations);
				CreditDeductions(add.Deductions);
				CreditTaxes(add.Taxes);
				CreditChecks.Add(add);
				CreditWorkerCompensation(add.WorkerCompensation);
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

				var t1 = Taxes.FirstOrDefault(tax => tax.Tax.Id == t.Tax.Id);
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
				}
			});

		}

		private void CreditTaxes(IEnumerable<PayrollTax> taxes)
		{
			taxes.ToList().ForEach(t =>
			{
				var t1 = Taxes.FirstOrDefault(tax => tax.Tax.Id == t.Tax.Id);
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

		public void SetCounts(int year, int quarter)
		{
			var q1date = new DateTime(year, quarter*3 - 2, 12).Date;
			var q2date = new DateTime(year, quarter*3 - 1, 12).Date;
			var q3date = new DateTime(year, quarter*3, 12).Date;
			Count1 = PayChecks.Count(p => p.StartDate.Date <= q1date && p.EndDate >= q1date);
			Count2 = PayChecks.Count(p => p.StartDate.Date <= q2date && p.EndDate >= q2date);
			Count3 = PayChecks.Count(p => p.StartDate.Date <= q3date && p.EndDate >= q3date);
		}

		public void SetQuarters()
		{
			Q1Wage =
				PayChecks.Where(p => p.PayDay.Month >= 1 && p.PayDay.Month <= 3)
					.Select(p => p.Taxes.First(t => t.Tax.Id == 6))
					.Sum(t => t.TaxableWage);
			Q1Amount =
				PayChecks.Where(p => p.PayDay.Month >= 1 && p.PayDay.Month <= 3)
					.Select(p => p.Taxes.First(t => t.Tax.Id == 6))
					.Sum(t => t.Amount);
			Q2Wage =
				PayChecks.Where(p => p.PayDay.Month >= 4 && p.PayDay.Month <= 6)
					.Select(p => p.Taxes.First(t => t.Tax.Id == 6))
					.Sum(t => t.TaxableWage);
			Q2Amount =
				PayChecks.Where(p => p.PayDay.Month >= 4 && p.PayDay.Month <= 6)
					.Select(p => p.Taxes.First(t => t.Tax.Id == 6))
					.Sum(t => t.Amount);
			Q3Wage =
				PayChecks.Where(p => p.PayDay.Month >= 7 && p.PayDay.Month <= 9)
					.Select(p => p.Taxes.First(t => t.Tax.Id == 6))
					.Sum(t => t.TaxableWage);
			Q3Amount =
				PayChecks.Where(p => p.PayDay.Month >= 7 && p.PayDay.Month <= 9)
					.Select(p => p.Taxes.First(t => t.Tax.Id == 6))
					.Sum(t => t.Amount);
			Q4Wage =
				PayChecks.Where(p => p.PayDay.Month >= 10 && p.PayDay.Month <= 12)
					.Select(p => p.Taxes.First(t => t.Tax.Id == 6))
					.Sum(t => t.TaxableWage);
			Q4Amount =
				PayChecks.Where(p => p.PayDay.Month >= 10 && p.PayDay.Month <= 12)
					.Select(p => p.Taxes.First(t => t.Tax.Id == 6))
					.Sum(t => t.Amount);
		}

		public void BuildDailyAccumulations(int quarter)
		{
			DailyAccumulations = new List<DailyAccumulation>();
			var groups = PayChecks.GroupBy(p => p.PayDay);
			
			foreach (var @group in groups)
			{
				var ea = new DailyAccumulation
				{
					Month = quarter > 0 ? @group.Key.Month % 3 > 0 ? @group.Key.Month % 3 : 3 : @group.Key.Month,
					Day = @group.Key.Day,
					Value = @group.ToList().SelectMany(p => p.Taxes.Where(t => t.Tax.Id < 6)).ToList().Sum(t => t.Amount)
				};
				DailyAccumulations.Add(ea);
			}
		}

		
	}
}
