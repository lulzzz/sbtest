using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class Payroll : BaseEntityDto, IOriginator<Payroll>
	{
		public Company Company { get; set; }
		public DateTime StartDate { get; set; }
		public DateTime EndDate { get; set; }
		public DateTime PayDay { get; set; }
		public List<PayCheck> PayChecks { get; set; }
		public int StartingCheckNumber { get; set; }
		public string Notes { get; set; }
		public PayrollStatus Status { get; set; }
		public PayrollInvoice Invoice { get; set; }
		public bool PEOASOCoCheck { get; set; }
		public decimal TotalGrossWage
		{
			get { return Math.Round(PayChecks.Where(pc => !pc.IsVoid).Sum(pc => pc.GrossWage), 2, MidpointRounding.AwayFromZero); }
		}
		public decimal TotalNetWage
		{
			get { return Math.Round(PayChecks.Where(pc => !pc.IsVoid).Sum(pc => pc.NetWage), 2, MidpointRounding.AwayFromZero); }
		}
		public decimal EmployeeTaxes
		{
			get { return Math.Round(PayChecks.Where(pc => !pc.IsVoid).Sum(pc => pc.EmployeeTaxes), 2, MidpointRounding.AwayFromZero); }
		}
		public decimal EmployerTaxes
		{
			get { return Math.Round(PayChecks.Where(pc => !pc.IsVoid).Sum(pc => pc.EmployerTaxes), 2, MidpointRounding.AwayFromZero); }
		}
		public decimal DeductionAmount
		{
			get { return Math.Round(PayChecks.Where(pc => !pc.IsVoid).Sum(pc => pc.DeductionAmount), 2, MidpointRounding.AwayFromZero); }
		}

		public decimal TotalCost
		{
			get { return Math.Round(PayChecks.Where(pc => !pc.IsVoid).Sum(pc => pc.Cost), 2, MidpointRounding.AwayFromZero); }
		}

		public Guid MementoId
		{
			get { return Id; }
		}

		public void ApplyMemento(Memento<Payroll> memento)
		{
			throw new NotImplementedException();
		}
	}

	public class PayCheck : IOriginator<PayCheck>
	{
		public Guid PayrollId { get; set; }
		public int Id { get; set; }
		public Employee Employee { get; set; }
		public List<PayrollPayCode> PayCodes { get; set; }
		public decimal Salary { get; set; }
		public List<PayrollPayType> Compensations { get; set; }
		public List<PayrollDeduction> Deductions { get; set; }
		public int? CheckNumber { get; set; }
		public List<PayrollTax> Taxes { get; set; }
		public string Notes { get; set; }
		public List<PayTypeAccumulation> Accumulations { get; set; } 
		public EmployeePaymentMethod PaymentMethod { get; set; }
		public PaycheckStatus Status { get; set; }

		public bool IsVoid { get; set; }
		public decimal GrossWage { get; set; }
		public decimal NetWage { get; set; }
		public decimal WCAmount { get; set; }
		public PayrollWorkerCompensation WorkerCompensation { get; set; }

		public DateTime StartDate { get; set; }
		public DateTime EndDate { get; set; }
		public DateTime PayDay { get; set; }

		public decimal YTDSalary { get; set; }
		public decimal YTDGrossWage { get; set; }
		public decimal YTDNetWage { get; set; }

		public string LastModifiedBy { get; set; }
		public DateTime LastModified { get; set; }

		public bool PEOASOCoCheck { get; set; }

		public Guid? InvoiceId { get; set; }
		public DateTime? VoidedOn { get; set; }
		
		public Guid? CreditInvoiceId { get; set; }
		
		public bool Included { get; set; }

		public decimal CheckPay { get { return PaymentMethod == EmployeePaymentMethod.Check ? NetWage : 0; } }
		public decimal DDPay { get { return PaymentMethod == EmployeePaymentMethod.Check ? 0 : NetWage; } }

		public decimal Cost
		{
			get { return Math.Round(GrossWage + EmployerTaxes, 2, MidpointRounding.AwayFromZero); }
		}

		public decimal EmployeeTaxes
		{
			get { return Math.Round(Taxes.Where(t => t.IsEmployeeTax).Sum(t => t.Amount), 2, MidpointRounding.AwayFromZero); }
		}
		public decimal EmployerTaxes
		{
			get { return Math.Round(Taxes.Where(t => !t.IsEmployeeTax).Sum(t => t.Amount), 2, MidpointRounding.AwayFromZero); }
		}

		public decimal EmployeeTaxesYTD
		{
			get { return Math.Round(Taxes.Where(t => t.IsEmployeeTax).Sum(t => t.YTDTax), 2, MidpointRounding.AwayFromZero); }
		}
		public decimal EmployerTaxesYTD
		{
			get { return Math.Round(Taxes.Where(t => !t.IsEmployeeTax).Sum(t => t.YTDTax), 2, MidpointRounding.AwayFromZero); }
		}

		public decimal EmployeeTaxesYTDWage
		{
			get { return Math.Round(Taxes.Where(t => t.IsEmployeeTax).Sum(t => t.YTDWage), 2, MidpointRounding.AwayFromZero); }
		}
		public decimal EmployerTaxesYTDWage
		{
			get { return Math.Round(Taxes.Where(t => !t.IsEmployeeTax).Sum(t => t.YTDWage), 2, MidpointRounding.AwayFromZero); }
		}

		public decimal DeductionAmount
		{
			get { return Math.Round(Deductions.Sum(d => d.Amount), 2, MidpointRounding.AwayFromZero); }
		}

		public decimal DeductionYTD
		{
			get { return Math.Round(Deductions.Sum(d => d.YTD), 2, MidpointRounding.AwayFromZero); }
		}
		public decimal DeductionYTDWage
		{
			get { return Math.Round(Deductions.Sum(d => d.YTDWage), 2, MidpointRounding.AwayFromZero); }
		}

		public decimal CompensationTaxableAmount
		{
			get { return Math.Round(Compensations.Where(c => c.PayType.IsTaxable).Sum(c => c.Amount), 2, MidpointRounding.AwayFromZero); }
		}

		public decimal CompensationTaxableYTD
		{
			get { return Math.Round(Compensations.Where(c => c.PayType.IsTaxable).Sum(c => c.YTD), 2, MidpointRounding.AwayFromZero); }
		}
		public decimal CompensationNonTaxableAmount
		{
			get { return Math.Round(Compensations.Where(c => !c.PayType.IsTaxable).Sum(c => c.Amount), 2, MidpointRounding.AwayFromZero); }
		}

		public decimal CompensationNonTaxableYTD
		{
			get { return Math.Round(Compensations.Where(c => !c.PayType.IsTaxable).Sum(c => c.YTD), 2, MidpointRounding.AwayFromZero); }
		}

		public decimal CalculatedSalary
		{
			get { return Employee.PayType == EmployeeType.Salary || Employee.PayType == EmployeeType.JobCost ? Salary : Math.Round(PayCodes.Sum(pc => pc.Amount + pc.OvertimeAmount), 2, MidpointRounding.AwayFromZero); }
		}
		public decimal CalculatedSalaryYTD
		{
			get { return Employee.PayType == EmployeeType.Salary || Employee.PayType == EmployeeType.JobCost ? YTDSalary : Math.Round(PayCodes.Sum(pc => pc.YTD + pc.YTDOvertime), 2, MidpointRounding.AwayFromZero); }
		}
		public decimal Regular
		{
			get { return PayCodes.Sum(p => p.Hours); }
		}
		public decimal Overtime
		{
			get { return PayCodes.Sum(p => p.OvertimeHours); }
		}
		public Guid DocumentId { get; set; }

		public void ResetYTD()
		{
			YTDSalary = Salary;
			YTDGrossWage = GrossWage;
			YTDNetWage = NetWage;
			Compensations.ForEach(c=>c.YTD=c.Amount);
			Deductions.ForEach(c => c.YTD = c.Amount);
			PayCodes.ForEach(c =>
			{
				c.YTD = c.Amount;
				c.YTDOvertime = c.OvertimeAmount;
			});
			Taxes.ForEach(c =>
			{
				c.YTDTax = c.Amount;
				c.YTDWage = c.TaxableWage;
			});
			Accumulations.ForEach(c =>
			{
				c.YTDFiscal = c.AccumulatedValue;
				c.YTDUsed = c.Used;
			});
			if (WorkerCompensation != null)
			{
				WorkerCompensation.YTD = WCAmount;
			}
		}
		public void AddToYTD(PayCheck paycheck)
		{
			
			AddToYTDCompensation(paycheck.Compensations);
			AddToYTDDeductions(paycheck.Deductions);
			AddToYTDTaxes(paycheck.Taxes);
			AddToLeavedAccumulation(paycheck.Accumulations);
			if (paycheck.Employee.PayType == EmployeeType.Salary)
			{
				YTDSalary = Math.Round(YTDSalary + paycheck.Salary, 2, MidpointRounding.AwayFromZero);
				
			}
			else if (paycheck.Employee.PayType == EmployeeType.JobCost)
			{
				YTDSalary = Math.Round(YTDSalary + paycheck.Salary, 2, MidpointRounding.AwayFromZero);
				AddToYTDPayCodes(paycheck.PayCodes);
			}
			else
			{
				AddToYTDPayCodes(paycheck.PayCodes);
			}
			YTDGrossWage = Math.Round(YTDGrossWage + paycheck.GrossWage, 2, MidpointRounding.AwayFromZero);
			YTDNetWage = Math.Round(YTDNetWage + paycheck.NetWage, 2, MidpointRounding.AwayFromZero);
			if (paycheck.WorkerCompensation != null && WorkerCompensation != null)
			{
				if(WorkerCompensation.WorkerCompensation.Id == paycheck.WorkerCompensation.WorkerCompensation.Id &&
			    paycheck.WCAmount > 0)
				WorkerCompensation.YTD += Math.Round(paycheck.WCAmount, 2, MidpointRounding.AwayFromZero);
			}
			   
		}

		private void AddToLeavedAccumulation(IEnumerable<PayTypeAccumulation> accumulations)
		{
			Accumulations.ForEach(apt =>
			{
				var apt1 = accumulations.FirstOrDefault(pt=>pt.PayType.Id==apt.PayType.Id);
				if (apt1 != null)
				{
					if (apt1.FiscalStart == apt.FiscalStart)
					{
						apt.YTDFiscal = Math.Round(apt.YTDFiscal + apt1.AccumulatedValue, 2, MidpointRounding.AwayFromZero);
						apt.YTDUsed = Math.Round(apt.YTDUsed + apt1.Used, 2, MidpointRounding.AwayFromZero);
					}
					else
					{
						apt.CarryOver = Math.Round(apt.CarryOver + (apt1.AccumulatedValue - apt1.Used), 2, MidpointRounding.AwayFromZero);
					}
				}
			});
		}

		private void AddToYTDPayCodes(IEnumerable<PayrollPayCode> payCodes)
		{
			payCodes.ToList().ForEach(pc1 =>
			{
				var pc = PayCodes.FirstOrDefault(paycode => paycode.PayCode.Id == pc1.PayCode.Id);
				if (pc != null)
				{
					pc.YTD = Math.Round(pc.YTD + pc1.Amount, 2, MidpointRounding.AwayFromZero);
					pc.YTDOvertime = Math.Round(pc.YTDOvertime + pc1.OvertimeAmount, 2, MidpointRounding.AwayFromZero);
				}
				else
				{
					PayCodes.Add(pc1);
				}
			});
			
		}

		private void AddToYTDCompensation(IEnumerable<PayrollPayType> comps)
		{
			comps.ToList().ForEach(c1 =>
			{
				var c = Compensations.FirstOrDefault(comp => comp.PayType.Id == c1.PayType.Id);
				if (c != null)
				{
					c.YTD = Math.Round(c.YTD + c1.Amount, 2, MidpointRounding.AwayFromZero);
				}
				else
				{
					Compensations.Add(c1);
				}
			});
		}

		private void AddToYTDDeductions(IEnumerable<PayrollDeduction> deds)
		{
			deds.ToList().ForEach(d1 =>
			{
				var d = Deductions.FirstOrDefault(ded => ded.Deduction.Id == d1.Deduction.Id);
				if (d != null)
				{
					d.YTD = Math.Round(d.YTD + d1.Amount, 2, MidpointRounding.AwayFromZero);
				}
				else
				{
					Deductions.Add(d1);
				}
			});
		}

		private void AddToYTDTaxes(IEnumerable<PayrollTax> taxes)
		{
			Taxes.ForEach(t =>
			{
				var t1 = taxes.FirstOrDefault(tax => tax.Tax.Id == t.Tax.Id);
				if (t1 != null)
				{
					t.YTDWage = Math.Round(t.YTDWage + t1.TaxableWage, 2, MidpointRounding.AwayFromZero);
					t.YTDTax = Math.Round(t.YTDTax + t1.Amount, 2, MidpointRounding.AwayFromZero);
				}
			});
		}

		public void SubtractFromYTD(PayCheck paycheck)
		{
			SubtractFromYTDCompensation(paycheck.Compensations);
			SubtractFromYTDDeductions(paycheck.Deductions);
			SubtractFromYTDTaxes(paycheck.Taxes);
			SubtractFromYTDAccumulations(paycheck.Accumulations);
			if (paycheck.Employee.PayType == EmployeeType.Salary)
			{
				YTDSalary = Math.Round(YTDSalary - paycheck.Salary, 2, MidpointRounding.AwayFromZero);
				
			}
			else if (paycheck.Employee.PayType == EmployeeType.JobCost)
			{
				YTDSalary = Math.Round(YTDSalary - paycheck.Salary, 2, MidpointRounding.AwayFromZero);
				SubtractFromYTDPayCodes(paycheck.PayCodes);
			}
			else
			{
				SubtractFromYTDPayCodes(paycheck.PayCodes);
			}
			YTDGrossWage = Math.Round(YTDGrossWage - paycheck.GrossWage, 2, MidpointRounding.AwayFromZero);
			YTDNetWage = Math.Round(YTDNetWage - paycheck.NetWage, 2, MidpointRounding.AwayFromZero);
			if (paycheck.WorkerCompensation != null &&
					WorkerCompensation.WorkerCompensation.Id == paycheck.WorkerCompensation.WorkerCompensation.Id &&
					paycheck.WCAmount > 0)
				WorkerCompensation.YTD -= Math.Round(paycheck.WCAmount, 2, MidpointRounding.AwayFromZero);
		}

		private void SubtractFromYTDAccumulations(IEnumerable<PayTypeAccumulation> accumulations)
		{
			Accumulations.ForEach(apt =>
			{
				var apt1 = accumulations.FirstOrDefault(pt => pt.PayType.Id == apt.PayType.Id);
				if (apt1 != null)
				{
					if (apt1.FiscalStart == apt.FiscalStart)
					{
						apt.YTDFiscal = Math.Round(apt.YTDFiscal - apt1.AccumulatedValue, 2, MidpointRounding.AwayFromZero);
						apt.YTDUsed = Math.Round(apt.YTDUsed - apt1.Used, 2, MidpointRounding.AwayFromZero);
					}
					else
					{
						apt.CarryOver = Math.Round(apt.CarryOver - (apt1.AccumulatedValue - apt1.Used), 2, MidpointRounding.AwayFromZero);
					}
				}
			});
		}

		private void SubtractFromYTDPayCodes(IEnumerable<PayrollPayCode> payCodes)
		{
			PayCodes.ForEach(pc =>
			{
				var pc1 = payCodes.FirstOrDefault(paycode => paycode.PayCode.Id == pc.PayCode.Id);
				if (pc1 != null)
				{
					pc.YTD = Math.Round(pc.YTD - pc1.Amount, 2, MidpointRounding.AwayFromZero);
					pc.YTDOvertime = Math.Round(pc.YTDOvertime - pc1.OvertimeAmount, 2, MidpointRounding.AwayFromZero);
				}
			});
		}

		private void SubtractFromYTDCompensation(IEnumerable<PayrollPayType> comps)
		{
			Compensations.ForEach(c =>
			{
				var c1 = comps.FirstOrDefault(comp => comp.PayType.Id == c.PayType.Id);
				if (c1 != null)
				{
					c.YTD = Math.Round(c.YTD - c1.Amount, 2, MidpointRounding.AwayFromZero);
				}
			});
		}

		private void SubtractFromYTDDeductions(IEnumerable<PayrollDeduction> deds)
		{
			Deductions.ForEach(d =>
			{
				var d1 = deds.FirstOrDefault(ded => ded.Deduction.Id == d.Deduction.Id);
				if (d1 != null)
				{
					d.YTD = Math.Round(d.YTD - d1.Amount, 2, MidpointRounding.AwayFromZero);
				}
			});
		}

		private void SubtractFromYTDTaxes(IEnumerable<PayrollTax> taxes)
		{
			Taxes.ForEach(t =>
			{
				var t1 = taxes.FirstOrDefault(tax => tax.Tax.Id == t.Tax.Id);
				if (t1 != null)
				{
					t.YTDWage = Math.Round(t.YTDWage - t1.TaxableWage, 2, MidpointRounding.AwayFromZero);
					t.YTDTax = Math.Round(t.YTDTax - t1.Amount, 2, MidpointRounding.AwayFromZero);
				}
			});
		}

		public Guid MementoId
		{
			get
			{
				var str = string.Format("{0}-0000-0000-0000-{1}", ((int)EntityTypeEnum.PayCheck).ToString().PadLeft(8, '0'),
					Id.ToString().PadLeft(12, '0'));
				return new Guid(str);
			}
		}
		public void ApplyMemento(Memento<PayCheck> memento)
		{
			throw new NotImplementedException();
		}
	}

	public class PayrollPayCode
	{
		public CompanyPayCode PayCode { get; set; }
		public string ScreenHours { get; set; }
		public string ScreenOvertime { get; set; }
		public decimal Hours { get; set; }
		public decimal OvertimeHours { get; set; }
		public decimal PWAmount { get; set; }
		public decimal Amount { get; set; }
		public decimal YTD { get; set; }
		public decimal OvertimeAmount { get; set; }
		public decimal YTDOvertime { get; set; }
	}

	public class PayrollWorkerCompensation
	{
		public CompanyWorkerCompensation WorkerCompensation { get; set; }
		public decimal Wage { get; set; }
		public decimal Amount { get; set; }
		public decimal YTD { get; set; }
	}

	public class PayrollTax
	{
		public Tax Tax { get; set; }
		public decimal TaxableWage { get; set; }
		public decimal Amount { get; set; }

		public decimal YTDWage { get; set; }
		public decimal YTDTax { get; set; }

		public bool IsEmployeeTax
		{
			get { return Tax.IsEmployeeTax; }
		}
	}

	public class PayrollPayType
	{
		public PayType PayType { get; set; }
		public decimal Amount { get; set; }
		public decimal YTD { get; set; }
	}

	public class PayrollDeduction
	{
		public CompanyDeduction Deduction { get; set; }
		public EmployeeDeduction EmployeeDeduction { get; set; }
		public DeductionMethod Method { get; set; }
		public decimal Rate { get; set; }
		public decimal? AnnualMax { get; set; }
		public decimal Wage { get; set; }
		public decimal Amount { get; set; }
		public decimal YTD { get; set; }
		public decimal YTDWage { get; set; }
		public string Name
		{
			get { return string.Format("{0} - {1}",Deduction.Type.Name, Deduction.DeductionName); }
		}

		public int Sort
		{
			get
			{
				var dbId = Deduction.Type.Category.GetDbId().Value;
				var priority = EmployeeDeduction != null && EmployeeDeduction.Priority.HasValue
					? EmployeeDeduction.Priority.Value
					: 0;
				return dbId + priority;
			}
		}
	}

	public class PayTypeAccumulation
	{
		public AccumulatedPayType PayType { get; set; }
		public DateTime FiscalStart { get; set; }
		public DateTime FiscalEnd { get; set; }
		public decimal AccumulatedValue { get; set; }
		public decimal YTDFiscal { get; set; }
		public decimal Used { get; set; }
		public decimal YTDUsed { get; set; }
		public decimal CarryOver { get; set; }

		public decimal Available
		{
			get { return CarryOver + YTDFiscal - YTDUsed; }
		}
	}
	
}
