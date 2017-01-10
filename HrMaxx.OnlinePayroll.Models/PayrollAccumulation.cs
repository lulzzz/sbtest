using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace HrMaxx.OnlinePayroll.Models
{
	public class PayrollAccumulation
	{
		public decimal Salary { get; set; }
		public decimal GrossWage { get; set; }
		public decimal NetWage { get; set; }
		public decimal CheckPay { get; set; }
		public decimal DDPay { get; set; }

		public List<PayrollWorkerCompensation> WorkerCompensations { get; set; } 
		public List<PayrollPayCode> PayCodes { get; set; } 
		public List<PayrollPayType> Compensations { get; set; }
		public List<PayrollDeduction> Deductions { get; set; }
		public List<PayrollTax> Taxes { get; set; }
		public List<PayCheck> PayChecks { get; set; }
		public List<EmployeeAccumulation> EmployeeAccumulations { get; set; }

		public List<DailyAccumulation> DailyAccumulations { get; set; } 

		public decimal EmployeeTaxes
		{
			get { return Math.Round(Taxes.Where(t => t.IsEmployeeTax).Sum(t => t.Amount), 2, MidpointRounding.AwayFromZero); }
		}
		public decimal EmployerTaxes
		{
			get { return Math.Round(Taxes.Where(t => !t.IsEmployeeTax).Sum(t => t.Amount), 2, MidpointRounding.AwayFromZero); }
		}

		public decimal CashRequirement
		{
			get { return Math.Round(GrossWage + EmployerTaxes, 2, MidpointRounding.AwayFromZero); }
		}
		public decimal EmployeeDeductions
		{
			get { return Math.Round(Deductions.Sum(t => t.Amount), 2, MidpointRounding.AwayFromZero); }
		}

		public decimal EmployeeWorkerCompensations
		{
			get { return WorkerCompensations!=null? Math.Round(WorkerCompensations.Sum(t => t.Amount), 2, MidpointRounding.AwayFromZero) : 0; }
		}

		public decimal UsaIrs940
		{
			get { return Taxes.Any(t => t.Tax.Code == "FUTA") ? Taxes.First(t => t.Tax.Code == "FUTA").Amount : 0; }
		}
		public decimal FederalTaxes
		{
			get { return Taxes.Where(t=>!t.Tax.StateId.HasValue).Sum(t=>t.Amount); }
		}

		public decimal CaliforniaEmployeeTaxes
		{
			get { return Taxes.Where(t => t.Tax.StateId.HasValue && t.Tax.StateId==1 && t.IsEmployeeTax).Sum(t => t.Amount); }
		}
		public decimal CaliforniaEmployerTaxes
		{
			get { return Taxes.Where(t => t.Tax.StateId.HasValue && t.Tax.StateId == 1 && !t.IsEmployeeTax).Sum(t => t.Amount); }
		}

		public decimal Overtime
		{
			get { return PayCodes.Sum(p => p.OvertimeHours); }
		}
		public decimal Regular
		{
			get { return PayCodes.Sum(p => p.Hours); }
		}

		public decimal TotalCompensations
		{
			get { return Compensations.Sum(c => c.Amount); }
		}

		public PayrollAccumulation()
		{
			Salary = 0;
			GrossWage = 0;
			NetWage = 0;
			WorkerCompensations = new List<PayrollWorkerCompensation>();
			PayCodes = new List<PayrollPayCode>();
			Compensations=new List<PayrollPayType>();
			Deductions=new List<PayrollDeduction>();
			Taxes=new List<PayrollTax>();
			PayChecks = new List<PayCheck>();
			
		}

		public void Add(PayrollAccumulation add)
		{
			Salary += Math.Round(add.Salary, 2, MidpointRounding.AwayFromZero);
			GrossWage += Math.Round(add.GrossWage, 2, MidpointRounding.AwayFromZero);
			NetWage += Math.Round(add.NetWage, 2, MidpointRounding.AwayFromZero);
			CheckPay += Math.Round(add.CheckPay, 2, MidpointRounding.AwayFromZero);
			DDPay += Math.Round(add.DDPay, 2, MidpointRounding.AwayFromZero);

			add.WorkerCompensations.ForEach(AddWorkerCompensation);
			
			AddPayCodes(add.PayCodes);
			AddCompensations(add.Compensations);
			AddDeductions(add.Deductions);
			AddTaxes(add.Taxes);
			PayChecks.AddRange(add.PayChecks);
		}

		public void Remove(PayrollAccumulation remove)
		{
			Salary -= Math.Round(remove.Salary, 2, MidpointRounding.AwayFromZero);
			GrossWage -= Math.Round(remove.GrossWage, 2, MidpointRounding.AwayFromZero);
			NetWage -= Math.Round(remove.NetWage, 2, MidpointRounding.AwayFromZero);
			CheckPay -= Math.Round(remove.CheckPay, 2, MidpointRounding.AwayFromZero);
			DDPay -= Math.Round(remove.DDPay, 2, MidpointRounding.AwayFromZero);

			remove.WorkerCompensations.ForEach(RemoveWorkerCompensation);
			RemovePayCodes(remove.PayCodes);
			RemoveCompensations(remove.Compensations);
			RemoveDeductions(remove.Deductions);
			RemoveTaxes(remove.Taxes);
			PayChecks.RemoveAll(pc => remove.PayChecks.Any(pc1 => pc1.Id == pc.Id));
		}

		public void AddPayCheck(PayCheck add)
		{
			if (PayChecks.All(pci => pci.Id != add.Id))
			{
				Salary += Math.Round(add.CalculatedSalary, 2, MidpointRounding.AwayFromZero);
				GrossWage += Math.Round(add.GrossWage, 2, MidpointRounding.AwayFromZero);
				NetWage += Math.Round(add.NetWage, 2, MidpointRounding.AwayFromZero);
				CheckPay += Math.Round(add.CheckPay, 2, MidpointRounding.AwayFromZero);
				DDPay += Math.Round(add.DDPay, 2, MidpointRounding.AwayFromZero);

				AddWorkerCompensation(add.WorkerCompensation);
				AddPayCodes(add.PayCodes);
				AddCompensations(add.Compensations);
				AddDeductions(add.Deductions);
				AddTaxes(add.Taxes);
				PayChecks.Add(add);
			}
		}

		public void AddPayChecks(IEnumerable<PayCheck> checks)
		{
			foreach ( var add in checks)
			{
				AddPayCheck(add);
			}
			
		}

		public void RemovePayCheck(PayCheck add)
		{
			if (PayChecks.Any(pci => pci.Id == add.Id))
			{
				Salary -= Math.Round(add.CalculatedSalary, 2, MidpointRounding.AwayFromZero);
				GrossWage -= Math.Round(add.GrossWage, 2, MidpointRounding.AwayFromZero);
				NetWage -= Math.Round(add.NetWage, 2, MidpointRounding.AwayFromZero);
				CheckPay -= Math.Round(add.CheckPay, 2, MidpointRounding.AwayFromZero);
				DDPay -= Math.Round(add.DDPay, 2, MidpointRounding.AwayFromZero);

				RemoveWorkerCompensation(add.WorkerCompensation);
				RemovePayCodes(add.PayCodes);
				RemoveCompensations(add.Compensations);
				RemoveDeductions(add.Deductions);
				RemoveTaxes(add.Taxes);

				PayChecks.Remove(add);
			}
			
		}

		public void AddPayroll(Payroll payroll)
		{
			payroll.PayChecks.Where(pc=>!pc.IsVoid).ToList().ForEach(AddPayCheck);
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


		private void AddPayCodes(IEnumerable<PayrollPayCode> paycode)
		{
			paycode.ToList().ForEach(p =>
			{
				var p1 = PayCodes.FirstOrDefault(pc => pc.PayCode.Id == p.PayCode.Id);
				if (p1 != null)
				{
					p1.Hours += Math.Round(p.Hours, 2, MidpointRounding.AwayFromZero);
					p1.OvertimeHours += Math.Round(p.OvertimeHours, 2, MidpointRounding.AwayFromZero);
					p1.Amount += Math.Round(p.Amount, 2, MidpointRounding.AwayFromZero);
					p1.OvertimeAmount += Math.Round(p.OvertimeAmount, 2, MidpointRounding.AwayFromZero);
				}
				else
				{
					var temp = JsonConvert.SerializeObject(p);
					PayCodes.Add(JsonConvert.DeserializeObject<PayrollPayCode>(temp));
				}
			});

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

		private void RemoveWorkerCompensation(PayrollWorkerCompensation wcomp)
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

		private void RemovePayCodes(IEnumerable<PayrollPayCode> paycode)
		{
			paycode.ToList().ForEach(p =>
			{
				var p1 = PayCodes.FirstOrDefault(pc => pc.PayCode.Id == p.PayCode.Id);
				if (p1 != null)
				{
					p1.Amount -= Math.Round(p.Amount, 2, MidpointRounding.AwayFromZero);
					p1.OvertimeAmount -= Math.Round(p.OvertimeAmount, 2, MidpointRounding.AwayFromZero);
				}
				
			});

		}

		private void RemoveCompensations(IEnumerable<PayrollPayType> comps)
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

		private void RemoveDeductions(IEnumerable<PayrollDeduction> deds)
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

		private void RemoveTaxes(IEnumerable<PayrollTax> taxes)
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

		public void BuildDailyAccumulations(int quarter)
		{
			DailyAccumulations = new List<DailyAccumulation>();
			var groups = PayChecks.GroupBy(p => p.PayDay);
			foreach (var @group in groups)
			{
				var ea = new DailyAccumulation
				{
					Month = quarter>0 ? @group.Key.Month % 3 > 0 ? @group.Key.Month%3 : 3 : @group.Key.Month,
					Day = @group.Key.Day,
					Value = @group.ToList().SelectMany(p=>p.Taxes.Where(t=>!t.Tax.StateId.HasValue && !t.Tax.Code.Equals("FUTA"))).ToList().Sum(t=>t.Amount)
				};
				DailyAccumulations.Add(ea);
			}
		}
	}
}
