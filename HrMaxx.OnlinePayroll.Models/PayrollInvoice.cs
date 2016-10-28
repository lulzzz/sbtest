using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using Newtonsoft.Json;

namespace HrMaxx.OnlinePayroll.Models
{
	public class PayrollInvoice : BaseEntityDto
	{
		public Guid CompanyId { get; set; }
		public Guid PayrollId { get; set; }
		public InvoiceSetup CompanyInvoiceSetup { get; set; }
		public int InvoiceNumber { get; set; }
		public DateTime PeriodStart { get; set; }
		public DateTime PeriodEnd { get; set; }
		public DateTime InvoiceDate { get; set; }
		public DateTime PayrollPayDay { get; set; }
		
		public int NoOfChecks { get; set; }
		public decimal GrossWages { get; set; }
		public decimal EmployeeContribution { get; set; }
		public decimal EmployerContribution { get; set; }
		public decimal AdminFee { get; set; }
		public decimal EnvironmentalFee { get; set; }
		public List<PayrollTax> EmployerTaxes { get; set; }
		public List<PayrollTax> EmployeeTaxes { get; set; }

		public List<PayrollDeduction> Deductions { get; set; } 
		public List<InvoiceWorkerCompensation> WorkerCompensations { get; set; }
		public decimal Total { get; set; }
		public decimal WorkerCompensationCharges { get { return WorkerCompensations.Sum(w => w.Amount); } }
		public List<MiscFee> MiscCharges { get; set; }
		
		public decimal MiscFees { get { return MiscCharges.Sum(w => w.Amount); } }
		public InvoiceStatus Status { get; set; }
		public DateTime? SubmittedOn { get; set; }
		public DateTime? DeliveredOn { get; set; }
		public string SubmittedBy { get; set; }
		public string DeliveredBy { get; set; }
		public Company Company { get; set; }
		public string Courier { get; set; }
		public string Notes { get; set; }
		public string ProcessedBy { get; set; }
		public DateTime ProcessedOn { get; set; }
		public List<InvoicePayment> Payments { get; set; }
		public List<int> PayChecks { get; set; }
		public List<int> VoidedCreditedChecks { get; set; }
		public bool ApplyWCMinWageLimit { get; set; }
		public decimal PaidAmount
		{
			get { return Math.Round(Payments.Where(p => p.Status == PaymentStatus.Paid).Sum(p => p.Amount), 2, MidpointRounding.AwayFromZero); }
		}
		public decimal Balance
		{
			get { return Math.Round(Total - PaidAmount, 2, MidpointRounding.AwayFromZero); }
		}

		public void Initialize(Payroll payroll, List<PayrollInvoice> prevInvoices, decimal envFeePerCheck, Company company, List<PayCheck> voidedPayChecks)
		{
			WorkerCompensations = new List<InvoiceWorkerCompensation>();
			EmployerTaxes = new List<PayrollTax>();
			EmployeeTaxes = new List<PayrollTax>();
			MiscCharges = new List<MiscFee>();
			Payments = new List<InvoicePayment>();
			Deductions = new List<PayrollDeduction>();
			PayChecks = new List<int>();
			VoidedCreditedChecks = new List<int>();
			
			PeriodEnd = payroll.EndDate;
			PeriodStart = payroll.StartDate;
			CompanyId = payroll.Company.Id;
			CompanyInvoiceSetup = company.Contract.InvoiceSetup;
			CalculateDates(payroll);
			PayrollId = payroll.Id;
			GrossWages = payroll.TotalGrossWage;
			payroll.PayChecks.Where(pc => !pc.IsVoid).ToList().ForEach(pc => AddTaxes(pc.Taxes));
			payroll.PayChecks.Where(pc => !pc.IsVoid).ToList().ForEach(pc => AddWorkerCompensation(pc.WorkerCompensation));
			
			payroll.PayChecks.Where(pc => !pc.IsVoid).ToList().ForEach(pc => AddDeductions(pc.Deductions));
			PayChecks.AddRange(payroll.PayChecks.Where(pc=>!pc.IsVoid).Select(pc=>pc.Id));
			
			NoOfChecks = payroll.PayChecks.Count(pc => !pc.IsVoid);
			
			CalculateAdminFee(payroll);
			
			CalculateRecurringCharges(prevInvoices, payroll);
			HandleVoidedChecks(prevInvoices, company, voidedPayChecks);
			CalculateCASUTA(company, payroll.PayDay.Year);

			EmployeeContribution = payroll.TotalGrossWage - payroll.TotalNetWage;
			EmployerContribution = EmployerTaxes.Sum(pc => pc.Amount);
			EnvironmentalFee = CompanyInvoiceSetup.ApplyEnvironmentalFee ? envFeePerCheck*NoOfChecks : 0;
			CalculateTotal();

			Status = InvoiceStatus.Draft;
			ProcessedOn = DateTime.Now;

			Notes = string.Empty;
			if (prevInvoices.Any(i => i.Payments.Any(p => p.Status == PaymentStatus.PaymentBounced)))
			{
				Notes = string.Format("Alert: Payment bounced for Invoices #{0}; ", prevInvoices.Where(i => i.Payments.Any(p => p.Status == PaymentStatus.PaymentBounced)).Aggregate(string.Empty, (current, m) => current + m.InvoiceNumber + ", "));
			}
		}

		private void HandleVoidedChecks(List<PayrollInvoice> prevInvoices, Company company, List<PayCheck> voidedPayChecks)
		{
			voidedPayChecks.ForEach(vpc =>
			{
				if (!prevInvoices.Any(i => i.VoidedCreditedChecks.Any(pivc => pivc == vpc.Id)))
				{
					var prevInv = prevInvoices.First(pi => pi.PayChecks.Contains(vpc.Id));
					var pcCredit = new MiscFee
					{
						PayCheckId = vpc.Id,
						RecurringChargeId = -1,
						Amount = 0,
						Description = string.Format("Credit for PayCheck #{0} invoiced in #{1} voided on{2}", vpc.PaymentMethod==EmployeePaymentMethod.Check ? vpc.CheckNumber.Value.ToString() : "EFT", prevInv.InvoiceNumber, vpc.VoidedOn.Value.ToString("MM/dd/yyyy")),
						isEditable = false
					};
					if (CompanyInvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck)
					{
						pcCredit.Amount += Math.Round(vpc.GrossWage, 2, MidpointRounding.AwayFromZero);
						pcCredit.Amount += Math.Round(vpc.EmployerTaxes, 2, MidpointRounding.AwayFromZero);
					}
					else if (CompanyInvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOClientCheck)
					{
						pcCredit.Amount += Math.Round(vpc.EmployeeTaxes, 2, MidpointRounding.AwayFromZero);
						pcCredit.Amount += Math.Round(vpc.EmployerTaxes, 2, MidpointRounding.AwayFromZero);
					

					}
					pcCredit.Amount *= -1;
					VoidedCreditedChecks.Add(vpc.Id);
					MiscCharges.Add(pcCredit);
				}
			});
		}

		private void AddDeductions(IEnumerable<PayrollDeduction> deds)
		{
			deds.Where(d=>d.Deduction.Type.Id==4).ToList().ForEach(d =>
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

		public void CalculateTotal()
		{
			Total = (decimal)0;
			Total += Math.Round(AdminFee, 2, MidpointRounding.AwayFromZero);
			
			Total += Math.Round(MiscFees, 2, MidpointRounding.AwayFromZero);

			if (CompanyInvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck)
			{
				Total += Math.Round(GrossWages, 2, MidpointRounding.AwayFromZero);
				Total += Math.Round(EmployerContribution, 2, MidpointRounding.AwayFromZero);
				Total += Math.Round(WorkerCompensationCharges, 2, MidpointRounding.AwayFromZero);
				Total += Math.Round(EnvironmentalFee, 2, MidpointRounding.AwayFromZero);
				
			}
			else if (CompanyInvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOClientCheck)
			{
				Total += Math.Round(EmployeeContribution, 2, MidpointRounding.AwayFromZero);
				Total += Math.Round(EmployerContribution, 2, MidpointRounding.AwayFromZero);
				Total += Math.Round(WorkerCompensationCharges, 2, MidpointRounding.AwayFromZero);
				Total += Math.Round(EnvironmentalFee, 2, MidpointRounding.AwayFromZero);

			}
			else if (CompanyInvoiceSetup.InvoiceType == CompanyInvoiceType.ConventioanlPayrollWC)
			{
				Total += Math.Round(WorkerCompensationCharges, 2, MidpointRounding.AwayFromZero);
			}
			else if (CompanyInvoiceSetup.InvoiceType == CompanyInvoiceType.WC)
			{
				Total = Math.Round(WorkerCompensationCharges, 2, MidpointRounding.AwayFromZero);
			}
		}
		private void CalculateCASUTA(Company company, int year)
		{
			if (CompanyInvoiceSetup.SUIManagement > 0)
			{
				EmployerTaxes.Where(t => t.Tax.StateId == 1).ToList().ForEach(t =>
				{
					var taxableWage = CompanyInvoiceSetup.ApplyStatuaryLimits? GrossWages : t.TaxableWage;
					var rate = t.Tax.Rate;
					if (t.Tax.IsCompanySpecific && company.CompanyTaxRates.Any(ct=>ct.TaxYear==year && ct.TaxId==t.Tax.Id))
					{
						rate = company.CompanyTaxRates.First(ct => ct.TaxYear == year && ct.TaxId == t.Tax.Id).Rate;
					}
					t.Amount = Math.Round((decimal) (taxableWage*(rate + CompanyInvoiceSetup.SUIManagement)/100),2,MidpointRounding.AwayFromZero);
					t.TaxableWage = taxableWage;
				});	
			}
		}

		private void AddTaxes(IEnumerable<PayrollTax> taxes)
		{
			taxes.ToList().ForEach(t =>
			{

				var t1 = t.IsEmployeeTax? EmployeeTaxes.FirstOrDefault(tax => tax.Tax.Id == t.Tax.Id) : EmployerTaxes.FirstOrDefault(tax => tax.Tax.Id == t.Tax.Id);
				if (t1 != null)
				{
					t1.TaxableWage = Math.Round(t1.TaxableWage + t.TaxableWage, 2, MidpointRounding.AwayFromZero);
					t1.Amount = Math.Round(t1.Amount + t.Amount, 2, MidpointRounding.AwayFromZero);
				}
				else
				{
					var temp = JsonConvert.SerializeObject(t);
					if(t.IsEmployeeTax)
						EmployeeTaxes.Add(JsonConvert.DeserializeObject<PayrollTax>(temp));
					else
						EmployerTaxes.Add(JsonConvert.DeserializeObject<PayrollTax>(temp));
				}
			});

		}
		private void CalculateDates(Payroll payroll)
		{
			InvoiceDate = payroll.PayDay.Date;
		}

		private void CalculateRecurringCharges(IEnumerable<PayrollInvoice> prevInvoices, Payroll payroll)
		{
			CompanyInvoiceSetup.RecurringCharges.ForEach(rc =>
			{
				if (!rc.Year.HasValue || rc.Year.Value == payroll.PayDay.Year)
				{
					var ytd =
						prevInvoices.SelectMany(i => i.MiscCharges).Where(mc => mc.RecurringChargeId == rc.Id).Sum(mc => mc.Amount);
					var calcAmount = (decimal) 0;
					if (!rc.AnnualLimit.HasValue)
					{
						calcAmount = rc.Amount;
					}
					else if (ytd < rc.AnnualLimit)
					{
						calcAmount = (ytd + rc.Amount) > rc.AnnualLimit ? (rc.AnnualLimit.Value - ytd) : rc.Amount;
					}
					MiscCharges.Add(new MiscFee
					{
						RecurringChargeId = rc.Id,
						Amount = calcAmount,
						Description = rc.Description,
						PayCheckId = 0,
						isEditable = true
					});
				}
			});
			Deductions.ForEach(d => MiscCharges.Add(new MiscFee
			{
				RecurringChargeId = d.Deduction.Id*-1,
				Amount = d.Amount*-1,
				Description = d.Name,
				PayCheckId = 0,
				isEditable = true
			}));
		
		}

		private void AddWorkerCompensation(PayrollWorkerCompensation wcomp)
		{
			if (wcomp != null)
			{
				var wc = WorkerCompensations.FirstOrDefault(w => w.WorkerCompensation.Id == wcomp.WorkerCompensation.Id);
				if (wc != null)
				{
					wc.Amount += Math.Round(wcomp.Amount, 2, MidpointRounding.AwayFromZero);
					wc.Wage += Math.Round(wcomp.Wage, 2, MidpointRounding.AwayFromZero);
					wc.OriginalAmount = wc.Amount;
					wc.OriginalWage = wc.Wage;
				}
				else
				{
					var temp = new InvoiceWorkerCompensation
					{
						Amount = wcomp.Amount,
						OriginalAmount = wcomp.Amount,
						OriginalWage = wcomp.Wage,
						WorkerCompensation = wcomp.WorkerCompensation,
						Wage = wcomp.Wage
					};
					WorkerCompensations.Add(temp);
				}
			}
		}

		private void CalculateAdminFee(Payroll payroll)
		{
			AdminFee = CompanyInvoiceSetup.AdminFeeMethod == 1 ? CompanyInvoiceSetup.AdminFee : Math.Round(CompanyInvoiceSetup.AdminFee*payroll.TotalGrossWage/100, 2, MidpointRounding.AwayFromZero);
		}
	}

	public class MiscFee
	{
		public int RecurringChargeId { get; set; }
		public int PayCheckId { get; set; }
		public string Description { get; set; }
		public decimal Amount { get; set; }
		public decimal Rate { get; set; }
		public bool isEditable { get; set; }
	}

	public class InvoiceWorkerCompensation
	{
		public CompanyWorkerCompensation WorkerCompensation { get; set; }
		public decimal Wage { get; set; }
		public decimal Amount { get; set; }
		public decimal OriginalWage { get; set; }
		public decimal OriginalAmount { get; set; }
		
	}
}
