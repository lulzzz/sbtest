using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.OnlinePayroll.Models.Enum;
using Newtonsoft.Json;

namespace HrMaxx.OnlinePayroll.Models
{
	public class PayrollInvoice : BaseEntityDto, IOriginator<PayrollInvoice>
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
		public List<InvoicePayment> InvoicePayments { get; set; }
		public List<int> PayChecks { get; set; }
		public List<int> VoidedCreditedChecks { get; set; }
		public bool ApplyWCMinWageLimit { get; set; }

		public string DeliveryClaimedBy { get; set; }
		public DateTime DeliveryClaimedOn { get; set; }

		public decimal CheckPay { get; set; }
		public decimal DDPay { get; set; }
		public decimal NetPay { get; set; }

		public decimal PaidAmount
		{
			get { return Math.Round(InvoicePayments!=null ? InvoicePayments.Where(p => p.Status == PaymentStatus.Paid).Sum(p => p.Amount) : 0, 2, MidpointRounding.AwayFromZero); }
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
			InvoicePayments = new List<InvoicePayment>();
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
			payroll.PayChecks.Where(pc => !pc.IsVoid).ToList().ForEach(pc => AddWorkerCompensation(pc.WorkerCompensation, company));
			ApplyWCMinWage();

			NetPay = payroll.PayChecks.Where(pc => !pc.IsVoid).Sum(pc => pc.NetWage);
			CheckPay = payroll.PayChecks.Where(pc => !pc.IsVoid).Sum(pc => pc.CheckPay);
			DDPay = payroll.PayChecks.Where(pc => !pc.IsVoid).Sum(pc => pc.DDPay);

			payroll.PayChecks.Where(pc => !pc.IsVoid).ToList().ForEach(pc => AddDeductions(pc.Deductions));
			PayChecks.AddRange(payroll.PayChecks.Where(pc => !pc.IsVoid).Select(pc => pc.Id));

			NoOfChecks = payroll.PayChecks.Count(pc => !pc.IsVoid);

			CalculateAdminFee(payroll);

			CalculateRecurringCharges(prevInvoices, payroll);
			HandleVoidedChecks(prevInvoices, company, voidedPayChecks);
			CalculateCASUTA(company, payroll.PayDay.Year);

			EmployeeContribution = payroll.TotalGrossWage - payroll.TotalNetWage;
			EmployerContribution = EmployerTaxes.Sum(pc => pc.Amount);
			EnvironmentalFee = CompanyInvoiceSetup.ApplyEnvironmentalFee ? envFeePerCheck * NoOfChecks : 0;
			CalculateTotal();

			Status = InvoiceStatus.Draft;
			ProcessedOn = DateTime.Now;

			Notes = string.Empty;
			if (prevInvoices.Any(i => i.InvoicePayments.Any(p => p.Status == PaymentStatus.PaymentBounced)))
			{
				Notes = string.Format("Alert: Payment bounced for Invoices #{0}; ", prevInvoices.Where(i => i.InvoicePayments.Any(p => p.Status == PaymentStatus.PaymentBounced)).Aggregate(string.Empty, (current, m) => current + m.InvoiceNumber + ", "));
				Notes += Environment.NewLine;
			}
			if (prevInvoices.Any(i => i.Status==InvoiceStatus.Delivered))
			{
				Notes += string.Format("Alert: Previous Invoices still only Deliverd #{0}; ", prevInvoices.Where(i => i.Status==InvoiceStatus.Delivered).Aggregate(string.Empty, (current, m) => current + m.InvoiceNumber + ", ")) + Environment.NewLine;
			}
		}

		private void ApplyWCMinWage()
		{
			ApplyWCMinWageLimit = true;
			WorkerCompensations.ForEach(wc =>
			{
				if (wc.WorkerCompensation.MinGrossWage.HasValue && wc.OriginalWage < wc.WorkerCompensation.MinGrossWage)
				{
					wc.Wage = wc.WorkerCompensation.MinGrossWage.Value;
					wc.Amount = Math.Round(wc.Wage*wc.WorkerCompensation.Rate/100, 2, MidpointRounding.AwayFromZero);

				}
			});
		}

		private void HandleVoidedChecks(List<PayrollInvoice> prevInvoices, Company company, List<PayCheck> voidedPayChecks)
		{
			voidedPayChecks.ForEach(vpc =>
			{
				if (!prevInvoices.Any(i => i.VoidedCreditedChecks.Any(pivc => pivc == vpc.Id)) && prevInvoices.Any(pi => pi.Id == vpc.InvoiceId))
				{
					var prevInv = prevInvoices.First(pi => pi.Id == vpc.InvoiceId);
					if (prevInv.Balance <= 0)
					{
						var pcCredit = new MiscFee
						{
							PayCheckId = vpc.Id,
							RecurringChargeId = -1,
							Amount = 0,
							Description = string.Format("Credit for PayCheck #{0} invoiced in #{1} voided on{2}", vpc.PaymentMethod == EmployeePaymentMethod.Check ? vpc.CheckNumber.Value.ToString() : "EFT", prevInv.InvoiceNumber, vpc.VoidedOn.Value.ToString("MM/dd/yyyy")),
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
						vpc.Deductions.ForEach(vpcd =>
						{
							if (prevInv.MiscCharges.Any(c => c.RecurringChargeId == vpcd.Deduction.Id * -1))
							{
								var chargedDeduction = prevInv.MiscCharges.First(c => c.RecurringChargeId == vpcd.Deduction.Id * -1);
								var dedCredit = new MiscFee
								{
									PayCheckId = 0,
									RecurringChargeId = vpcd.Deduction.Id * -1,
									Amount = chargedDeduction.Amount * -1,
									Description = string.Format("Reverse Credit for Deduction:{1} on voided PayCheck #{0} ", vpc.PaymentMethod == EmployeePaymentMethod.Check ? vpc.CheckNumber.Value.ToString() : "EFT", chargedDeduction.Description),
									isEditable = false
								};

								MiscCharges.Add(dedCredit);
							}
						});
					}
					


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
					var taxableWage = CompanyInvoiceSetup.ApplyStatuaryLimits ? GrossWages : t.TaxableWage;
					var rate = t.Tax.Rate;
					if (t.Tax.IsCompanySpecific && company.CompanyTaxRates.Any(ct => ct.TaxYear == year && ct.TaxCode.Equals(t.Tax.Code)))
					{
						rate = company.CompanyTaxRates.First(ct => ct.TaxYear == year && ct.TaxCode.Equals(t.Tax.Code)).Rate;
					}
					if (!t.Tax.Code.Equals("ETT"))
					{
						rate = rate + CompanyInvoiceSetup.SUIManagement;
					}

					t.Amount = Math.Round((decimal)(taxableWage * rate / 100), 2, MidpointRounding.AwayFromZero);
					t.TaxableWage = taxableWage;
					
				});
			}
		}

		private void AddTaxes(IEnumerable<PayrollTax> taxes)
		{
			taxes.ToList().ForEach(t =>
			{

				var t1 = t.IsEmployeeTax ? EmployeeTaxes.FirstOrDefault(tax => tax.Tax.Code == t.Tax.Code) : EmployerTaxes.FirstOrDefault(tax => tax.Tax.Code == t.Tax.Code);
				if (t1 != null)
				{
					t1.TaxableWage = Math.Round(t1.TaxableWage + t.TaxableWage, 2, MidpointRounding.AwayFromZero);
					t1.Amount = Math.Round(t1.Amount + t.Amount, 2, MidpointRounding.AwayFromZero);
				}
				else
				{
					var temp = JsonConvert.SerializeObject(t);
					if (t.IsEmployeeTax)
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
				var calcAmount = rc.Amount;
				var previouslyClaimed = (decimal)0;
				if (!rc.Year.HasValue)
				{
					previouslyClaimed =
						prevInvoices.SelectMany(i => i.MiscCharges).Where(mc => mc.RecurringChargeId == rc.Id).Sum(mc => mc.Amount);
					MiscCharges.Add(new MiscFee
					{
						RecurringChargeId = rc.Id,
						Amount = calcAmount,
						Description = rc.Description,
						PayCheckId = 0,
						isEditable = true,
						PreviouslyClaimed = previouslyClaimed
					});
				}
				else
				{
					if (rc.Year.Value == payroll.PayDay.Year)
					{
						previouslyClaimed =
							prevInvoices.Where(i => i.PayrollPayDay.Year == payroll.PayDay.Year).SelectMany(i => i.MiscCharges).Where(mc => mc.RecurringChargeId == rc.Id).Sum(mc => mc.Amount);

						if (rc.AnnualLimit.HasValue)
						{
							if (previouslyClaimed < rc.AnnualLimit)
							{
								calcAmount = (previouslyClaimed + rc.Amount) > rc.AnnualLimit ? (rc.AnnualLimit.Value - previouslyClaimed) : rc.Amount;
							}

						}
						MiscCharges.Add(new MiscFee
						{
							RecurringChargeId = rc.Id,
							Amount = calcAmount,
							Description = rc.Description,
							PayCheckId = 0,
							isEditable = true,
							PreviouslyClaimed = previouslyClaimed
						});
					}
				}
				

			});
			if (CompanyInvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck ||
			    CompanyInvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOClientCheck)
			{
				Deductions.Where(d => d.Deduction.Type.Id == 4).ToList().ForEach(d => MiscCharges.Add(new MiscFee
				{
					RecurringChargeId = d.Deduction.Id * -1,
					Amount = d.Amount * -1,
					Description = d.Name,
					PayCheckId = 0,
					isEditable = true
				}));	
				
			}
			
			if (CompanyInvoiceSetup.InvoiceType!=CompanyInvoiceType.PEOASOCoCheck && payroll.PayChecks.Any(pc => !pc.IsVoid && pc.PaymentMethod == EmployeePaymentMethod.DirectDebit))
			{
				var ddSum =
					payroll.PayChecks.Where(pc => !pc.IsVoid && pc.PaymentMethod == EmployeePaymentMethod.DirectDebit)
						.Sum(pc => pc.NetWage);
				MiscCharges.Add(new MiscFee
				{
					RecurringChargeId = 0,
					Amount = ddSum,
					Description = "ACH Pay Check(s)",
					PayCheckId = 0,
					isEditable = false,
					PreviouslyClaimed = 0
				});
			}

		}

		private void AddWorkerCompensation(PayrollWorkerCompensation wcomp, Company company)
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
					var companyWC = company.WorkerCompensations.FirstOrDefault(wc1 => wc1.Id == wcomp.WorkerCompensation.Id);
					var temp = new InvoiceWorkerCompensation
					{
						Amount = wcomp.Amount,
						OriginalAmount = wcomp.Amount,
						OriginalWage = wcomp.Wage,
						WorkerCompensation = companyWC ?? wcomp.WorkerCompensation,
						Wage = wcomp.Wage
					};
					WorkerCompensations.Add(temp);
				}
			}
		}

		private void CalculateAdminFee(Payroll payroll)
		{
			AdminFee = CompanyInvoiceSetup.AdminFeeMethod == 1 ? CompanyInvoiceSetup.AdminFee : Math.Round(CompanyInvoiceSetup.AdminFee * payroll.TotalGrossWage / 100, 2, MidpointRounding.AwayFromZero);
			CompanyInvoiceSetup.AdminFeeThreshold = CompanyInvoiceSetup.AdminFeeThreshold.HasValue
				? CompanyInvoiceSetup.AdminFeeThreshold
				: 35;
			if (AdminFee < CompanyInvoiceSetup.AdminFeeThreshold.Value)
				AdminFee = CompanyInvoiceSetup.AdminFeeThreshold.Value;
		}

		public Guid MementoId
		{
			get { return Id; }
		}

		public void ApplyMemento(Memento<PayrollInvoice> memento)
		{
			throw new NotImplementedException();
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
		public decimal PreviouslyClaimed { get; set; }
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
