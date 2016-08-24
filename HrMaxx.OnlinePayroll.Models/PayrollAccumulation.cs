using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class PayrollAccumulation
	{
		public decimal Salary { get; set; }
		public decimal GrossWage { get; set; }
		public decimal NetWage { get; set; }
		public List<PayrollPayType> Compensations { get; set; }
		public List<PayrollDeduction> Deductions { get; set; }
		public List<PayrollTax> Taxes { get; set; }
		public List<int> PayCheckIds { get; set; } 

		public PayrollAccumulation()
		{
			Salary = 0;
			GrossWage = 0;
			NetWage = 0;
			Compensations=new List<PayrollPayType>();
			Deductions=new List<PayrollDeduction>();
			Taxes=new List<PayrollTax>();
			PayCheckIds = new List<int>();
		}

		public void Add(PayrollAccumulation add)
		{
			Salary += Math.Round(add.Salary, 2);
			GrossWage += Math.Round(add.GrossWage, 2);
			NetWage += Math.Round(add.NetWage, 2);

			AddCompensations(add.Compensations);
			AddDeductions(add.Deductions);
			AddTaxes(add.Taxes);
		}

		public void Remove(PayrollAccumulation remove)
		{
			Salary -= Math.Round(remove.Salary, 2);
			GrossWage -= Math.Round(remove.GrossWage, 2);
			NetWage -= Math.Round(remove.NetWage, 2);

			RemoveCompensations(remove.Compensations);
			RemoveDeductions(remove.Deductions);
			RemoveTaxes(remove.Taxes);
		}

		public void AddPayCheck(PayCheck add)
		{
			if (PayCheckIds.All(pci => pci != add.Id))
			{
				Salary += Math.Round(add.Salary, 2);
				GrossWage += Math.Round(add.GrossWage, 2);
				NetWage += Math.Round(NetWage, 2);

				AddCompensations(add.Compensations);
				AddDeductions(add.Deductions);
				AddTaxes(add.Taxes);
				PayCheckIds.Add(add.Id);
			}
		}

		public void RemovePayCheck(PayCheck add)
		{
			if (PayCheckIds.Any(pci => pci == add.Id))
			{
				Salary -= Math.Round(add.Salary, 2);
				GrossWage -= Math.Round(add.GrossWage, 2);
				NetWage -= Math.Round(NetWage, 2);

				RemoveCompensations(add.Compensations);
				RemoveDeductions(add.Deductions);
				RemoveTaxes(add.Taxes);

				PayCheckIds.Remove(add.Id);
			}
			
		}

		public void AddPayroll(Payroll payroll)
		{
			payroll.PayChecks.ForEach(AddPayCheck);
		}

		private void AddCompensations(IEnumerable<PayrollPayType> comps)
		{
			Compensations.ForEach(c =>
			{
				var c1 = comps.FirstOrDefault(comp => comp.PayType.Id == c.PayType.Id);
				if (c1 != null)
				{
					c.Amount += Math.Round(c1.Amount, 2);
				}
			});
			var missingList = comps.Where(c => !Compensations.Any(comp => comp.PayType.Id == c.PayType.Id));
			Compensations.AddRange(missingList);
		}

		private void AddDeductions(IEnumerable<PayrollDeduction> deds)
		{
			Deductions.ForEach(d =>
			{
				var d1 = deds.FirstOrDefault(ded => ded.Deduction.Id == d.Deduction.Id);
				if (d1 != null)
				{
					d.Amount += Math.Round(d1.Amount, 2);
				}
			});
			var missingList = deds.Where(d => !Deductions.Any(ded => ded.Deduction.Id == d.Deduction.Id));
			Deductions.AddRange(missingList);
		}

		private void AddTaxes(IEnumerable<PayrollTax> taxes)
		{
			Taxes.ForEach(t =>
			{
				var t1 = taxes.FirstOrDefault(tax => tax.Tax.Id == t.Tax.Id);
				if (t1 != null)
				{
					t.TaxableWage += Math.Round(t.TaxableWage, 2);
					t.Amount += Math.Round(t1.Amount, 2);
				}
			});
			var missingList = taxes.Where(d => !Taxes.Any(tax => tax.Tax.Id ==d.Tax.Id));
			Taxes.AddRange(missingList);
		}

		private void RemoveCompensations(IEnumerable<PayrollPayType> comps)
		{
			Compensations.ForEach(c =>
			{
				var c1 = comps.FirstOrDefault(comp => comp.PayType.Id == c.PayType.Id);
				if (c1 != null)
				{
					c.Amount -= Math.Round(c1.Amount, 2);
				}
			});
		}

		private void RemoveDeductions(IEnumerable<PayrollDeduction> deds)
		{
			Deductions.ForEach(d =>
			{
				var d1 = deds.FirstOrDefault(ded => ded.Deduction.Id == d.Deduction.Id);
				if (d1 != null)
				{
					d.Amount -= Math.Round(d1.Amount, 2);
				}
			});
			
		}

		private void RemoveTaxes(IEnumerable<PayrollTax> taxes)
		{
			Taxes.ForEach(t =>
			{
				var t1 = taxes.FirstOrDefault(tax => tax.Tax.Id == t.Tax.Id);
				if (t1 != null)
				{
					t.TaxableWage -= Math.Round(t.TaxableWage, 2);
					t.Amount -= Math.Round(t1.Amount, 2);
				}
			});
			
		}
	}
}
