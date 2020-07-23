using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Security.Claims;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Text.RegularExpressions;
using Dapper;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Repository;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;
using log4net;
using Newtonsoft.Json;
using CompanyPayCode = HrMaxx.OnlinePayroll.Models.CompanyPayCode;
using Invoice = HrMaxx.OnlinePayroll.Models.Invoice;
using InvoiceDeliveryClaim = HrMaxx.OnlinePayroll.Models.InvoiceDeliveryClaim;
using Journal = HrMaxx.OnlinePayroll.Models.Journal;
using PayrollInvoice = HrMaxx.OnlinePayroll.Models.PayrollInvoice;
using PayrollInvoiceMiscCharges = HrMaxx.OnlinePayroll.Models.PayrollInvoiceMiscCharges;

namespace HrMaxx.OnlinePayroll.Repository.Payroll
{
	public class PayrollRepository : BaseDapperRepository, IPayrollRepository
	{
		private readonly OnlinePayrollEntities _dbContext;
		private readonly IMapper _mapper;
		public ILog Log { get; set; }
		
		public PayrollRepository(IMapper mapper, OnlinePayrollEntities dbContext, DbConnection connection):base(connection)
		{
			_dbContext = dbContext;
			_mapper = mapper;
		}

		public Models.Payroll SavePayroll(Models.Payroll payroll)
		{
			var mapped = _mapper.Map<Models.Payroll, Models.DataModel.Payroll>(payroll);
			mapped.PayrollPayChecks.ToList().ForEach(pc=>pc.CompanyId = payroll.Company.Id);
			
			var dbPayroll = _dbContext.Payrolls.FirstOrDefault(p => p.Id == mapped.Id);
			if (dbPayroll == null)
			{
				dbPayroll = _dbContext.Payrolls.Add(mapped);
				_dbContext.SaveChanges();
			}
			return _mapper.Map<Models.DataModel.Payroll, Models.Payroll>(dbPayroll);

		}

		public void UpdatePayCheckYTD(PayCheck pc)
		{
			using (var conn = GetConnection())
			{
				const string updateCheck =
					@"update payrollpaycheck set Taxes=@Taxes, PayCodes=@PayCodes, Compensations=@Compensations, Deductions=@Deductions, Accumulations=@Accumulations, YTDSalary=@YTDSalary, YTDGrossWage=@YTDGrossWage, YTDNetWage=@YTDNetWage, WorkerCompensation=@WorkerCompensation WHERE Id = @PayCheckId;";
				conn.Execute(updateCheck,
					new
					{
						Taxes = JsonConvert.SerializeObject(pc.Taxes),
						PayCodes = JsonConvert.SerializeObject(pc.PayCodes),
						Compensations = JsonConvert.SerializeObject(pc.Compensations),
						Deductions = JsonConvert.SerializeObject(pc.Deductions),
						Accumulations = JsonConvert.SerializeObject(pc.Accumulations),
						YTDSalary = pc.YTDSalary,
						YTDGrossWage = pc.YTDGrossWage,
						YTDNetWage = pc.YTDNetWage,
						WorkerCompensation = pc.WorkerCompensation != null ? JsonConvert.SerializeObject(pc.WorkerCompensation) : null,
						PayCheckId=pc.Id
					});
				const string updateaccumulation =
					"update PayCheckPayTypeAccumulation set CarryOver=@CarryOver where PayCheckId=@PayCheckId and PayTypeId=@PayTypeId";
				pc.Accumulations.ForEach(ac => conn.Execute(updateaccumulation, new {PayCheckId=pc.Id, PayTypeId=ac.PayType.PayType.Id, CarryOver=ac.CarryOver}));
			
			}
		}

		
		

		public void ChangePayCheckStatus(int payCheckId, PaycheckStatus printed)
		{
			var dbcheck = _dbContext.PayrollPayChecks.First(p => p.Id == payCheckId);
			dbcheck.Status = (int) printed;
			_dbContext.SaveChanges();
		}

		public void MarkPayrollPrinted(Guid payrollId)
		{

			using (var conn = GetConnection())
			{
				//const string updatecheck = @"update PayrollPayCheck set Status=case status when 3 then 4 when 5 then 6 else status end Where PayrollId=@PayrollId";
				//const string updatecheck = @"update PayrollPayCheck set Status=4 Where PayrollId=@PayrollId and Status=3;update PayrollPayCheck set Status=6 Where PayrollId=@PayrollId and Status=5;";
				const string updatepayroll = @"update Payroll set Status=@Status, IsPrinted=1 Where Id=@Id";

				conn.Execute(updatepayroll, new {Status = (int) PayrollStatus.Printed, Id = payrollId});
				//conn.Execute(updatecheck, new { PayrollId = payrollId });
				
			}

			
		}

		public PayrollInvoice SavePayrollInvoice(PayrollInvoice payrollInvoice, ref StringBuilder strLog)
		{
			
			const string pisql = "select * from PayrollInvoice with (nolock) where Id=@Id or PayrollId=@PayrollId";
			const string pipaysql = "select * from InvoicePayment  with (nolock) where InvoiceId=@Id";
			
			const string insertsql =
						"insert into PayrollInvoice(Id,CompanyId,PayrollId,PeriodStart,PeriodEnd,InvoiceSetup,GrossWages,EmployerTaxes,InvoiceDate,NoOfChecks,Deductions,WorkerCompensations,EmployeeContribution,EmployerContribution,AdminFee,EnvironmentalFee,MiscCharges,Total,Status,SubmittedOn,SubmittedBy,DeliveredOn,DeliveredBy,LastModified,LastModifiedBy,Courier,EmployeeTaxes,Notes,ProcessedBy,Balance,ProcessedOn,PayChecks,VoidedCreditChecks,ApplyWCMinWageLimit,DeliveryClaimedBy,DeliveryClaimedOn,NetPay,CheckPay,DDPay, SpecialRequest) values(@Id,@CompanyId,@PayrollId,@PeriodStart,@PeriodEnd,@InvoiceSetup,@GrossWages,@EmployerTaxes,@InvoiceDate,@NoOfChecks,@Deductions,@WorkerCompensations,@EmployeeContribution,@EmployerContribution,@AdminFee,@EnvironmentalFee,@MiscCharges,@Total,@Status,@SubmittedOn,@SubmittedBy,@DeliveredOn,@DeliveredBy,@LastModified,@LastModifiedBy,@Courier,@EmployeeTaxes,@Notes,@ProcessedBy,@Balance,@ProcessedOn,@PayChecks,@VoidedCreditChecks,@ApplyWCMinWageLimit,@DeliveryClaimedBy,@DeliveryClaimedOn,@NetPay,@CheckPay,@DDPay, @SpecialRequest); select cast(scope_identity() as int)";
			const string insertcommission = "insert into PayrollInvoiceCommission(InvoiceId, SalesRep, Amount) values(@InvoiceId, @SalesRep, @Amount);";
			const string updatepayrollsql =
				"update Payroll set InvoiceId=@Id where Id=@PayrollId;update PayrollPayCheck set InvoiceId=@Id where Id in @PayCheckIds;";

			const string updatecreditcheckssql = "update PayrollPayCheck set CreditInvoiceId=@Id where Id in @CreditChecks;";
			const string updateRecurringChargeClaimed = "update CompanyRecurringCharge set Claimed=(Claimed+@Claimed) where Id=@Id;";
			const string deletecommission = "delete from PayrollInvoiceCommission where InvoiceId=@InvoiceId;";
			var mapped = _mapper.Map<Models.PayrollInvoice, Models.DataModel.PayrollInvoice>(payrollInvoice);
			using (var conn = GetConnection())
			{
				var pi =
					conn.Query<Models.DataModel.PayrollInvoice>(pisql, new { Id = payrollInvoice.Id, PayrollId = payrollInvoice.PayrollId })
						.FirstOrDefault();
				if (pi == null)
				{
					payrollInvoice.InvoiceNumber = conn.Query<int>(insertsql, mapped).Single();
					conn.Execute(insertcommission, payrollInvoice.Commissions);
					strLog.AppendLine("Created Invoice " + DateTime.Now.ToString("hh:mm:ss:fff"));
					conn.Execute(updatepayrollsql,
						new
						{
							Id = mapped.Id,
							PayrollId = mapped.PayrollId,
							PayCheckIds = payrollInvoice.PayChecks
						});
					strLog.AppendLine("Updated Payroll " + DateTime.Now.ToString("hh:mm:ss:fff"));
					if (payrollInvoice.VoidedCreditedChecks.Any())
					{

						conn.Execute(updatecreditcheckssql,
							new
							{
								Id = mapped.Id,
								CreditChecks = payrollInvoice.VoidedCreditedChecks
							});
						strLog.AppendLine("Updated Credit checks " + DateTime.Now.ToString("hh:mm:ss:fff"));
					}
					payrollInvoice.MiscCharges.Where(mc=>mc.RecurringChargeId>0).ToList().ForEach(mc => conn.Execute(updateRecurringChargeClaimed,
						new {Id = mc.RecurringChargeId, Claimed = mc.Amount}));
					return payrollInvoice;
				}
				else
				{
					
					const string updatepisql =
						@"update PayrollInvoice set MiscCharges=@MiscCharges, Total=@Total, LastModified=@LastModified, LastModifiedBy=@LastModifiedBy, Status=@Status, 
																		SubmittedBy=@SubmittedBy, SubmittedOn	=@SubmittedOn, DeliveredBy=@DeliveredBy, DeliveredOn=@DeliveredOn, InvoiceDate=@InvoiceDate, Deductions=@Deductions, Courier=@Courier,
																		Notes=@Notes, Balance=@Balance, WorkerCompensations=@WorkerCompensations, VoidedCreditChecks=@VoidedCreditChecks, NetPay=@NetPay, DDPay=@DDPay, CheckPay=@CheckPay, 
																		TaxesDelayed=@TaxesDelayed, SpecialRequest = @SpecialRequest  															
																		where Id=@Id";
					
					conn.Execute(updatepisql, mapped);
					conn.Execute(deletecommission, new { InvoiceId = mapped.Id });
					conn.Execute(insertcommission, mapped.PayrollInvoiceCommissions);
					strLog.AppendLine("Updated Invoice " + DateTime.Now.ToString("hh:mm:ss:fff"));
					if (!string.IsNullOrWhiteSpace(pi.VoidedCreditChecks) && pi.VoidedCreditChecks!=mapped.VoidedCreditChecks)
					{
						var dbInvoiceVoidedCredits = JsonConvert.DeserializeObject<List<int>>(pi.VoidedCreditChecks);
						strLog.AppendLine("Voided Credits " + pi.VoidedCreditChecks + "---" + mapped.VoidedCreditChecks);
						
						if (dbInvoiceVoidedCredits.Any(ip => payrollInvoice.VoidedCreditedChecks.All(mp => mp != ip)))
						{
							var removeVoidedCredits =
								dbInvoiceVoidedCredits.Where(ip => payrollInvoice.VoidedCreditedChecks.All(mp => mp != ip)).ToList();
							const string removecreditchecks = "update PayrollPayCheck set CreditInvoiceId=null where Id in @CreditChecks";
							conn.Execute(removecreditchecks, new { CreditChecks = removeVoidedCredits });
							strLog.AppendLine("Removed Voided Credits " + DateTime.Now.ToString("hh:mm:ss:fff"));
						}

						//if (payrollInvoice.VoidedCreditedChecks.Any(ip => dbInvoiceVoidedCredits.All(mp => mp != ip)))
						//{
						//	conn.Execute(updatecreditcheckssql, new { Id = mapped.Id, CreditChecks = payrollInvoice.VoidedCreditedChecks.Where(ip => dbInvoiceVoidedCredits.All(mp => mp != ip)).ToList() });
						//	strLog.AppendLine("added new Voided Credits " + DateTime.Now.ToString("hh:mm:ss:fff"));
						//}
						
					}
					strLog.AppendLine("Updated Voided Credits " + DateTime.Now.ToString("hh:mm:ss:fff"));
					if (pi.Status > 2)
					{
						strLog.AppendLine("Updating Payments " + DateTime.Now.ToString("hh:mm:ss:fff"));
						pi.InvoicePayments = conn.Query<Models.DataModel.InvoicePayment>(pipaysql, new { Id = pi.Id }).ToList();
						const string removepayment = "delete from InvoicePayment where Id=@Id;";
						const string updatepayment =
							@"update InvoicePayment set Amount=@Amount, CheckNumber=@CheckNumber, Method=@Method, Notes=@Notes, PaymentDate=@PaymentDate, Status=@Status, 
LastModified=@LastModified, LastModifiedBy=@LastModifiedBy where Id=@Id;";
						const string insertpayment = "insert into InvoicePayment(InvoiceId,PaymentDate,Method,Status,CheckNumber,Amount,Notes,LastModified,LastModifiedBy) values(@InvoiceId,@PaymentDate,@Method,@Status,@CheckNumber,@Amount,@Notes,@LastModified,@LastModifiedBy);select cast(scope_identity() as int)";


						if (pi.InvoicePayments.Any(ip => mapped.InvoicePayments.All(mp => mp.Id != ip.Id)))
							conn.Execute(removepayment, pi.InvoicePayments.Where(ip => mapped.InvoicePayments.All(mp => mp.Id != ip.Id)));
						foreach (var p in pi.InvoicePayments.Where(dip => mapped.InvoicePayments.Any(mip => dip.Id == mip.Id) && payrollInvoice.InvoicePayments.Any(pip => pip.Id == dip.Id && pip.HasChanged)))
						{
							var matching = mapped.InvoicePayments.First(mip => mip.Id == p.Id);
							conn.Execute(updatepayment, matching);

						}
						mapped.InvoicePayments.Where(ip => ip.Id == 0).ToList().ForEach(p =>
						{
							p.Id = conn.Query<int>(insertpayment, p).Single();
						});
						strLog.AppendLine("Updated Payments " + DateTime.Now.ToString("hh:mm:ss:fff"));
					}
					
					if (!string.IsNullOrWhiteSpace(pi.MiscCharges))
					{
						strLog.AppendLine("Updating Misc charges " + DateTime.Now.ToString("hh:mm:ss:fff"));
						var mc1s = JsonConvert.DeserializeObject<List<MiscFee>>(pi.MiscCharges);
						payrollInvoice.MiscCharges.Where(mc => mc.RecurringChargeId > 0).ToList().ForEach(mc =>
						{
							var mc1 = mc1s.FirstOrDefault(m => m.RecurringChargeId == mc.RecurringChargeId);
							if (mc1 == null)
								conn.Execute(updateRecurringChargeClaimed,
									new { Id = mc.RecurringChargeId, Claimed = mc.Amount });
							else if (mc1.Amount != mc.Amount)
							{
								conn.Execute(updateRecurringChargeClaimed,
									new { Id = mc.RecurringChargeId, Claimed = mc.Amount - mc1.Amount });
							}
						});
						mc1s.Where(m1 => payrollInvoice.MiscCharges.All(mc1 => mc1.RecurringChargeId != m1.RecurringChargeId)).ToList().ForEach(
							m1 => conn.Execute(updateRecurringChargeClaimed,
								new { Id = m1.RecurringChargeId, Claimed = -1 * m1.Amount }));
						strLog.AppendLine("Updated Misc charges " + DateTime.Now.ToString("hh:mm:ss:fff"));
					}
					
					
					return _mapper.Map<Models.DataModel.PayrollInvoice, Models.PayrollInvoice>(mapped);
				}

			}


		}

		public void UpdateInvoiceMiscCharges(List<PayrollInvoice> invoices )
		{
			const string sql = "update PayrollInvoice set MiscCharges=@MiscCharges where Id=@Id";
			var mapped = _mapper.Map<List<PayrollInvoice>, List<Models.DataModel.PayrollInvoice>>(invoices);
			using (var conn = GetConnection())
			{
				conn.Execute(sql, mapped);
			}
		}

		public void SaveInvoiceRecurringCharge(List<InvoiceRecurringCharge> list)
		{
			const string sql = "if not exists(select 'x' from invoicerecurringcharge where invoiceid=@InvoiceId and Recurringchargeid=@RecurringChargeId) insert into invoicerecurringcharge(InvoiceId, CompanyId, InvoiceNumber, RecurringChargeId, Description, Amount, Rate, Claimed) values(@InvoiceId, @CompanyId, @InvoiceNumber, @RecurringChargeId, @Description, @Amount, @Rate, @Claimed);";
			using (var conn = GetConnection())
			{
				conn.Execute(sql, list);
			}
		}

		public List<InvoiceRecurringCharge> GetRecurringChargeToUpdate()
		{
			const string sql = "select * from InvoiceRecurringCharge";
			using (var conn = GetConnection())
			{
				return conn.Query<InvoiceRecurringCharge>(sql).ToList();
			}
		}

		public void FixInvoiceVoidedCredit(PayrollInvoice payrollInvoice)
		{
			const string update1 = "update PayrollPayCheck set CreditInvoiceId=null where Id in =@VoidedCreditedChecks; update PayrollInvoice set VoidedCreditChecks='' where Id=@Id";
			
			using (var conn = GetConnection())
			{
				conn.Execute(update1, payrollInvoice);
				
			}
		}


		public void DeletePayrollInvoice(Guid invoiceId, List<MiscFee> miscCharges, PayrollInvoice invoice)
		{
			const string delete =
				"update payroll set invoiceid=null where invoiceId=@Id;update PayrollPayCheck set CreditInvoiceId=null where Id in @CreditChecks;update payrollpaycheck set invoiceid=null where payrollid=@PayrollId;delete from payrollinvoice where Id=@Id; ";
			const string updateRecurringChargeClaimed = "update CompanyRecurringCharge set Claimed=(Claimed+@Claimed) where Id=@Id;";
			using (var conn = GetConnection())
			{
				conn.Execute(delete, new { Id =invoiceId, CreditChecks=invoice.VoidedCreditedChecks, PayrollId = invoice.PayrollId });
				miscCharges.Where(mc => mc.RecurringChargeId > 0).ToList().ForEach(mc => conn.Execute(updateRecurringChargeClaimed,
					new { Id = mc.RecurringChargeId, Claimed = -1*mc.Amount }));
			}
			
		}

		public void SavePayCheck(PayCheck pc)
		{
			var mapped = _mapper.Map<Models.PayCheck, Models.DataModel.PayrollPayCheck>(pc);
			var dbPaycheck = _dbContext.PayrollPayChecks.FirstOrDefault(p => p.Id == mapped.Id);
			if (dbPaycheck != null)
			{
				dbPaycheck.WorkerCompensation = mapped.WorkerCompensation;
				dbPaycheck.Deductions = mapped.Deductions;
				dbPaycheck.Accumulations = mapped.Accumulations;
				dbPaycheck.Notes = mapped.Notes;

				dbPaycheck.PayCodes = mapped.PayCodes;
				dbPaycheck.Compensations = mapped.Compensations;
				dbPaycheck.Taxes = mapped.Taxes;
				dbPaycheck.Deductions = mapped.Deductions;
				dbPaycheck.Accumulations = mapped.Accumulations;
				dbPaycheck.YTDSalary = mapped.YTDSalary;
				dbPaycheck.YTDGrossWage = mapped.YTDGrossWage;
				dbPaycheck.YTDNetWage = mapped.YTDNetWage;
				_dbContext.SaveChanges();
			}
		}

		public void UpdatePayrollPayDay(Guid payrollId, List<int> payChecks, DateTime date)
		{
			using (var conn = GetConnection())
			{
				const string updatesql = @"Update PayrollPayCheck set TaxPayDay=@TaxPayDay Where PayrollId=@PayrollId; Update Payroll set TaxPayDay=@TaxPayDay where Id=@PayrollId";
				conn.Execute(updatesql, new { TaxPayDay = date.Date, PayrollId=payrollId });
				
			}
			

		}

		public List<PayrollInvoice> ClaimDelivery(List<Guid> invoices, string user)
		{
			var dbInvoices = _dbContext.PayrollInvoices.Where(pi => invoices.Contains(pi.Id)).ToList();
			if (dbInvoices.Any())
			{
				dbInvoices.ForEach(i =>
				{
					i.DeliveryClaimedBy = user;
					i.DeliveryClaimedOn = DateTime.Now;
				});
				_dbContext.SaveChanges();
			}
			return _mapper.Map<List<Models.DataModel.PayrollInvoice>, List<PayrollInvoice>>(dbInvoices);
		}

		public void SaveInvoiceDeliveryClaim(Models.InvoiceDeliveryClaim invoiceDeliveryClaim)
		{
			var dbClaim = _mapper.Map<Models.InvoiceDeliveryClaim, Models.DataModel.InvoiceDeliveryClaim>(invoiceDeliveryClaim);
			_dbContext.InvoiceDeliveryClaims.Add(dbClaim);
			_dbContext.SaveChanges();
		}

		public void UpdatePayCheckSickLeaveAccumulation(PayCheck payCheck)
		{
			var ptaccums = new List<PayCheckPayTypeAccumulation>();
			using (var conn = GetConnection())
			{
				const string updatesql = @"Update PayrollPayCheck set Accumulations=@Accumulation Where Id=@PayCheckId";
				conn.Execute(updatesql, new { Accumulation = JsonConvert.SerializeObject(payCheck.Accumulations), PayCheckId=payCheck.Id });
				payCheck.Accumulations.ForEach(a =>
				{
					var ptaccum = new PayCheckPayTypeAccumulation
					{
						PayCheckId = payCheck.Id,
						PayTypeId = a.PayType.PayType.Id,
						FiscalEnd = a.FiscalEnd,
						FiscalStart = a.FiscalStart,
						AccumulatedValue = a.AccumulatedValue,
						Used = a.Used,
						CarryOver = a.CarryOver
					};
					ptaccums.Add(ptaccum);
				});
				
					
			}
			
			SavePayCheckPayTypeAccumulations(ptaccums);
		}

		public void UpdatePayrollDates(Models.Payroll mappedResource)
		{
			var dbPayrolls = _dbContext.Payrolls.First(p => p.Id == mappedResource.Id);
			dbPayrolls.StartDate = mappedResource.StartDate;
			dbPayrolls.EndDate = mappedResource.EndDate;
			dbPayrolls.PayrollPayChecks.ToList().ForEach(pc =>
			{
				pc.StartDate = mappedResource.StartDate;
				pc.EndDate = mappedResource.EndDate;
			});
			_dbContext.SaveChanges();
		}
				
		public List<InvoiceDeliveryClaim> GetInvoiceDeliveryClaims(DateTime? startDate, DateTime? endDate)
		{
			var dbClaims = _dbContext.InvoiceDeliveryClaims.Where(id => ((startDate.HasValue && id.DeliveryClaimedOn >= startDate.Value) || (!startDate.HasValue)) && ((endDate.HasValue && id.DeliveryClaimedOn <= endDate.Value) || (!endDate.HasValue))).ToList();
			return _mapper.Map<List<Models.DataModel.InvoiceDeliveryClaim>, List<Models.InvoiceDeliveryClaim>>(dbClaims);
		}

		public void SavePayCheckPayTypeAccumulations(List<PayCheckPayTypeAccumulation> ptaccums)
		{
			using (var conn = GetConnection())
			{
				const string deletesql = @"DELETE FROM PayCheckPayTypeAccumulation WHERE PayCheckId = @PayCheckId and PayTypeId=@PayTypeId";
				const string insertsql = @"insert into PayCheckPayTypeAccumulation (PayCheckId, PayTypeId, FiscalStart, FiscalEnd, AccumulatedValue, Used, CarryOver) values(@PayCheckId, @PayTypeId, @FiscalStart, @FiscalEnd, @AccumulatedValue, @Used, @CarryOver);";
				
				ptaccums.ForEach(pta =>
				{
					conn.Execute(deletesql, new { pta.PayCheckId, pta.PayTypeId });
					conn.Execute(insertsql, new { pta.PayCheckId, pta.PayTypeId, pta.FiscalStart, pta.FiscalEnd, pta.AccumulatedValue, pta.Used, pta.CarryOver });
				});
				
			}
			
			
		}

		public void SavePayCheckTaxes(List<PayCheckTax> pttaxes)
		{
			using (var conn = GetConnection())
			{
				const string deletesql = @"DELETE FROM PayCheckTax WHERE PayCheckId = @PayCheckId and TaxId=@TaxId;";
				const string insertsql = @"insert into PayCheckTax (PayCheckId, TaxId, TaxableWage, Amount) values(@PayCheckId, @TaxId, @TaxableWage, @Amount);";
				
				pttaxes.ForEach(pta =>
				{
					conn.Execute(deletesql, new { pta.PayCheckId, pta.TaxId });
					conn.Execute(insertsql, new { pta.PayCheckId, pta.TaxId, pta.TaxableWage, pta.Amount });
				});
				
			}
			
		}

		public void SavePayCheckCompensations(List<PayCheckCompensation> ptcomps)
		{
			using (var conn = GetConnection())
			{
				const string deletesql = @"DELETE FROM PayCheckCompensation WHERE PayCheckId = @PayCheckId and PayTypeId=@PayTypeId;";
				const string insertsql = @"insert into PayCheckCompensation (PayCheckId, PayTypeId, Amount) values(@PayCheckId, @PayTypeId, @Amount);";
				
				ptcomps.ForEach(pta =>
				{
					conn.Execute(deletesql, new { pta.PayCheckId, pta.PayTypeId });
					conn.Execute(insertsql, new { pta.PayCheckId, pta.PayTypeId, pta.Amount });
				});
				
			}
			
		}

		public void SavePayCheckDeductions(List<PayCheckDeduction> ptdeds)
		{
			using (var conn = GetConnection())
			{
				const string deletesql = @"DELETE FROM PayCheckDeduction WHERE PayCheckId = @PayCheckId and EmployeeDeductionId=@EmployeeDeductionId and CompanyDeductionId=@CompanyDeductionId;";

                const string insertsql = @"insert into PayCheckDeduction (PayCheckId, EmployeeDeductionId, CompanyDeductionId, EmployeeDeductionFlat, Method, Rate, AnnualMax, Wage, Amount, EmployerRate, EmployerAmount) values(@PayCheckId, @EmployeeDeductionId, @CompanyDeductionId, @EmployeeDeductionFlat, @Method, @Rate, @AnnualMax, @Wage, @Amount, @EmployerRate, @EmployerAmount);";
				
				ptdeds.ForEach(pta =>
				{
					conn.Execute(deletesql, new { pta.PayCheckId, pta.EmployeeDeductionId, pta.CompanyDeductionId });
					conn.Execute(insertsql, new { pta.PayCheckId, pta.EmployeeDeductionId, pta.CompanyDeductionId, pta.EmployeeDeductionFlat, pta.Method, pta.Rate, pta.AnnualMax, pta.Wage, pta.Amount, pta.EmployerRate, pta.EmployerAmount });
				});
				
			}
			
		}

		public void SavePayCheckPayCodes(List<PayCheckPayCode> ptcodes)
		{
			using (var conn = GetConnection())
			{
				const string deletesql = @"DELETE FROM PayCheckPayCode WHERE PayCheckId = @PayCheckId and PayCodeId=@PayCodeId;";
				const string insertsql = @"insert into PayCheckPayCode (PayCheckId, PayCodeId, PayCodeFlat, Amount, Overtime) values(@PayCheckId, @PayCodeId, @PayCodeFlat, @Amount, @Overtime);";
				
				ptcodes.ForEach(pta =>
				{
					conn.Execute(deletesql, new { pta.PayCheckId, pta.PayCodeId });
					conn.Execute(insertsql, new { pta.PayCheckId, pta.PayCodeId, pta.PayCodeFlat, pta.Amount, pta.Overtime });
				});
				
			}
			
		}

		public void SavePayCheckWorkerCompensations(List<PayCheckWorkerCompensation> ptwcs)
		{
			using (var conn = GetConnection())
			{
				const string deletesql = @"DELETE FROM PayCheckWorkerCompensation WHERE PayCheckId = @PayCheckId;";
				const string insertsql = @"insert into PayCheckWorkerCompensation (PayCheckId, WorkerCompensationId, WorkerCompensationFlat, Wage, Amount) values(@PayCheckId, @WorkerCompensationId, @WorkerCompensationFlat, @Wage, @Amount);";
				
				ptwcs.ForEach(pta =>
				{
					conn.Execute(deletesql, new { pta.PayCheckId });
					conn.Execute(insertsql, new { pta.PayCheckId, pta.WorkerCompensationId, pta.WorkerCompensationFlat, pta.Wage, pta.Amount });
				});
				
			}
			
		}

		public void FixPayCheckTaxes(List<PayCheck> taxupdate)
		{
			
			using (var conn = GetConnection())
			{
				const string updateCheck = @"update payrollpaycheck set Taxes=@Taxes, EmployerTaxes=@EmployerTaxes WHERE Id = @PayCheckId;";
				const string updateJournal = @"update journal set JournalDetails=@JournalDetails WHERE PayrollPayCheckId = @PayCheckId;";
				const string selectJournal = @"select * from Journal Where PayrollPayCheckId=@PayCheckId";
				const string updatePayCheckTax = @"update PayCheckTax set TaxableWage=@TaxableWage, Amount=@Amount Where PayCheckId=@PayCheckId and TaxId=@TaxId";

				taxupdate.ForEach(pc1 =>
				{
					var pc = _mapper.Map<PayCheck, PayrollPayCheck>(pc1);
					conn.Execute(updateCheck, new { Taxes=pc.Taxes, EmployerTaxes = pc.EmployerTaxes, PayCheckId=pc.Id });
					IEnumerable<Models.DataModel.Journal> journals = conn.Query<Models.DataModel.Journal>(selectJournal,
					new { PayCheckId = pc.Id });
					var j = journals.First();
					var j1 = _mapper.Map<Models.DataModel.Journal, Models.Journal>(j);

					var futaTax = pc1.Taxes.First(t => t.Tax.Code.Equals("FUTA"));
					var ettTax = pc1.Taxes.First(t => t.Tax.Code.Equals("ETT"));
					var suiTax = pc1.Taxes.First(t => t.Tax.Code.Equals("SUI"));
					j1.JournalDetails.First(jd => jd.AccountName.Equals("Expense: Payroll Taxes: Federal Unemployment Tax")).Amount =
						futaTax.Amount;
					j1.JournalDetails.First(jd => jd.AccountName.Equals("Expense: Payroll Taxes: CA Employment Training Tax")).Amount =
						ettTax.Amount;
					j1.JournalDetails.First(jd => jd.AccountName.Equals("Expense: Payroll Taxes: CA State Unemployment Tax")).Amount =
						suiTax.Amount;
					conn.Execute(updateJournal, new { JournalDetails=JsonConvert.SerializeObject(j1.JournalDetails), PayCheckId=pc1.Id });
					
					conn.Execute(updatePayCheckTax, new {TaxableWage=futaTax.TaxableWage, Amount=futaTax.Amount, PayCheckId=pc1.Id, TaxId=futaTax.Tax.Id});
					conn.Execute(updatePayCheckTax, new { TaxableWage = ettTax.TaxableWage, Amount = ettTax.Amount, PayCheckId = pc1.Id, TaxId = ettTax.Tax.Id });
					conn.Execute(updatePayCheckTax, new { TaxableWage = suiTax.TaxableWage, Amount = suiTax.Amount, PayCheckId = pc1.Id, TaxId = suiTax.Tax.Id });
				});

			}
		}

		public void FixPayCheckTaxWages(List<PayCheck> taxupdate, string taxCode)
		{

			using (var conn = GetConnection())
			{
				const string updateCheck = @"update payrollpaycheck set Taxes=@Taxes WHERE Id = @PayCheckId;";
				const string updatePayCheckTax = @"update PayCheckTax set TaxableWage=@TaxableWage Where PayCheckId=@PayCheckId and TaxId=@TaxId";

				taxupdate.ForEach(pc1 =>
				{
					var pc = _mapper.Map<PayCheck, PayrollPayCheck>(pc1);
					var pct = pc1.Taxes.First(t => t.Tax.Code.Equals(taxCode));
					conn.Execute(updateCheck, new { Taxes = pc.Taxes, PayCheckId = pc.Id });
					conn.Execute(updatePayCheckTax, new { TaxableWage = pct.TaxableWage, PayCheckId = pc1.Id, TaxId = pct.Tax.Id });
					
				});

			}
		}

		public void FixPayCheckAccumulations(List<PayCheck> accupdate)
		{
			using (var conn = GetConnection())
			{
				const string updatecheck = @"update PayrollPayCheck set Accumulations=@Accumulations Where Id=@Id";
				const string updateacc = @"update PayCheckPayTypeAccumulation set AccumulatedValue=@AccumulatedValue, Used=@Used, CarryOver=@CarryOver Where PayCheckId=@PayCheckId and PayTypeId=@PayTypeId";

				accupdate.ForEach(pta =>
				{
					conn.Execute(updatecheck, new {Accumulations=JsonConvert.SerializeObject(pta.Accumulations), Id=pta.Id });
					pta.Accumulations.ForEach(a => conn.Execute(updateacc,
						new
						{
							AccumulatedValue = a.AccumulatedValue,
							Used = a.Used,
							CarryOver = a.CarryOver,
							PayCheckId = pta.Id,
							PayTypeId = a.PayType.PayType.Id
						}));
				});

			}
		}

		public void ReIssueCheck(int payCheckId)
		{
			using (var conn = GetConnection())
			{
				const string updatecheck = @"update pc set IsReIssued=1, ReIssuedDate=cast(getDate() as date), CheckNumber=(select max(j.CheckNumber)+1 from Journal j where ((pc.PEOASOCoCheck=1 and j.PEOASOCoCheck=1) or (pc.PEOASOCoCheck=0 and j.CompanyId=pc.CompanyId))) from PayrollPayCheck pc Where Id=@Id";
				const string updateacc = @"update Journal set IsReIssued=1, ReIssuedDate=cast(getDate() as date), CheckNumber=(select CheckNumber from PayrollPayCheck pc where pc.Id=PayrollPayCheckId) where PayrollPayCheckId=@PayCheckId";

				conn.Execute(updatecheck, new {Id = payCheckId});
				conn.Execute(updateacc, new {PayCheckId = payCheckId});

			}
		}

		public void MovePayrolls(List<Models.Payroll> payrolls, List<Journal> affectedJournals, List<PayrollInvoice> invoices, Guid source, Guid target)
		{
			var dbPayrolls = _mapper.Map<List<Models.Payroll>, List<Models.DataModel.Payroll>>(payrolls);
			dbPayrolls.ForEach(p=>p.PayrollPayChecks.ToList().ForEach(pc => pc.CompanyId = p.CompanyId));
			var dbPayChecks = dbPayrolls.SelectMany(p => p.PayrollPayChecks.ToList()).ToList();
			var dbjournals = _mapper.Map<List<Journal>, List<Models.DataModel.Journal>>(affectedJournals);
			var dbInvoices = _mapper.Map<List<Models.PayrollInvoice>, List<Models.DataModel.PayrollInvoice>>(invoices);
			const string updatepayroll = @"update Payroll set CompanyId=@CompanyId, Company=@Company, MovedFrom=@MovedFrom, IsHistory=@IsHistory where Id=@Id";
			const string updatecheck = @"update PayrollPayCheck set CompanyId=@CompanyId, IsHistory=@IsHistory, EmployeeId=@EmployeeId, Employee=@Employee, Deductions=@Deductions, WorkerCompensation=@WorkerCompensation, Accumulations=@Accumulations, PayCodes=@PayCodes Where Id=@Id";
			const string updatejournals = @"update journal set CompanyId=@CompanyId, JournalDetails=@JournalDetails, MainAccountId=@MainAccountId, PayeeId=@PayeeId Where Id=@Id";
			const string updateInvoices = @"update PayrollInvoice set CompanyId=@CompanyId, WorkerCompensations = @WorkerCompensations where Id=@Id";
			const string updatepayrolldate = @"update employee set LastPayrollDate=(select max(PayDay) from PayrollPayCheck where EmployeeId=Employee.Id and isvoid=0) where companyid=@CompanyId";
			const string updatesource = "update Company set LastPayrollDate=(select max(PayDay) from Payroll where CompanyId=@SourceCompanyId) where Id=@SourceCompanyId;update Employee set LastPayrollDate=(select max(PayDay) from PayrollPayCheck where EmployeeId=Employee.Id) where CompanyId=@CompanyId";
			using (var conn = GetConnection())
			{
				conn.Execute(updatepayroll, dbPayrolls);
				conn.Execute(updatecheck, dbPayChecks);
				conn.Execute(updatejournals, dbjournals);
				conn.Execute(updateInvoices, dbInvoices);
				conn.Execute(updatepayrolldate, new {CompanyId = target});
				conn.Execute(updatesource, new { CompanyId = source, SourceCompanyId=source });
			}
		}

		public void DeleteAllPayrolls(Guid target)
		{
			const string deletepayrolls =
				@"delete from PayrollInvoice where CompanyId=@JCompanyId and PayrollId in (select Id from Payroll where CompanyId=@PPCompanyId and MovedFrom is null);delete from Journal where PayrollPayCheckId in (select Id from PayrollPayCheck where CompanyId=@JCompanyId and PayrollId in (select Id from Payroll where CompanyId=@PPCompanyId and MovedFrom is null));delete from PayrollPayCheck where CompanyId=@PCompanyId and PayrollId in (select Id from Payroll where CompanyId=@PPCompanyId and MovedFrom is null);delete from Payroll where CompanyId=@PPCompanyId and MovedFrom is null;";
			using (var conn = GetConnection())
			{
				
				conn.Execute(deletepayrolls, new { JCompanyId = target, PCompanyId = target, PPCompanyId=target });
			}
		}

		public void UpdateInvoiceDeliveryData(List<InvoiceDeliveryClaim> claims)
		{
			var dbClaims = _mapper.Map<List<InvoiceDeliveryClaim>, List<Models.DataModel.InvoiceDeliveryClaim>>(claims);
			const string updateinvoicedelivery =
				@"Update InvoiceDeliveryClaim set Invoices=@Invoices where Id=@Id";
			using (var conn = GetConnection())
			{

				conn.Execute(updateinvoicedelivery, dbClaims);
			}
		}
		public void UpdateEmployeeChecksForLeaveCycle(Guid employeeId, DateTime oldHireDate, DateTime newHireDate)
		{
			var previousAccumEndDate = newHireDate.AddDays(-1);
			var pcs = _dbContext.PayrollPayChecks.Where(pc => pc.EmployeeId == employeeId);
			var payChecks = _mapper.Map<List<PayrollPayCheck>, List<PayCheck>>(pcs.ToList());
			const string updatecheck = @"update PayrollPayCheck set Accumulations=@Accumulations where Id=@Id;";
			var updateList = new List<PayCheck>();
			payChecks.ForEach(pc =>
			{
				if (
					pc.Accumulations.Any(
						a =>
							a.FiscalStart.Date == oldHireDate.Date && a.FiscalStart.Date <= previousAccumEndDate.Date &&
							a.FiscalEnd.Date >= previousAccumEndDate.Date))
				{
					pc.Accumulations.Where(a =>
							a.FiscalStart.Date == oldHireDate.Date && a.FiscalStart.Date <= previousAccumEndDate.Date &&
							a.FiscalEnd.Date >= previousAccumEndDate.Date).ToList().ForEach(a=>a.FiscalEnd=previousAccumEndDate.Date);
					updateList.Add(pc);
				}
			});
			var dbUpdateList = _mapper.Map<List<PayCheck>, List<PayrollPayCheck>>(updateList);

			const string update = @"update pta set FiscalEnd=@HireDate from PayCheckPayTypeAccumulation pta, payrollpaycheck ppc where pta.PayCheckId=ppc.Id and ppc.EmployeeId=@EmployeeId and pta.FiscalStart= @OldHireDate and @HireDate between pta.FiscalStart and pta.FiscalEnd";
			using (var conn = GetConnection())
			{
				conn.Execute(updatecheck, dbUpdateList);
				conn.Execute(update, new { EmployeeId = employeeId, HireDate = previousAccumEndDate.ToString("MM/dd/yyyy"), OldHireDate = oldHireDate.ToString("MM/dd/yyyy") });
			}
		}

		public void UpdatePayroll(Models.Payroll payroll)
		{
			const string updatePayroll = "update payroll set PEOASOCoCheck=@PEOASOCoCheck where Id=@Id";
			const string updatePayChecks = "update payrollpaycheck set GrossWage=@GrossWage, NetWage=@NetWage, WCAmount=@WCAmount, DeductionAmount=@DeductionAmount, EmployeeTaxes=@EmployeeTaxes, EmployerTaxes=@EmployerTaxes, PEOASOCOCheck=@PEOASOCOCheck, Taxes=@Taxes, PayCodes=@PayCodes, Compensations=@Compensations, Deductions=@Deductions, Accumulations=@Accumulations, YTDSalary=@YTDSalary, YTDGrossWage=@YTDGrossWage, YTDNetWage=@YTDNetWage, WorkerCompensation=@WorkerCompensation where Id=@Id";
			var mapped = _mapper.Map<Models.Payroll, Models.DataModel.Payroll>(payroll);
			using (var conn = GetConnection())
			{
				conn.Execute(updatePayroll, mapped);
				conn.Execute(updatePayChecks, mapped.PayrollPayChecks);
			}
		}

		public void DeletePayroll(Models.Payroll payroll)
		{
			const string checkCanDelete = "select dbo.CanDeletePayroll(@PayrollId) as candelete";
			const string deletememento =
				"delete from Common.Memento where MementoId = (select cast(('00000007-0000-0000-0000-' + REPLACE(STR(@Id, 12), SPACE(1), '0')) as uniqueidentifier));";
			const string deletejournals = "delete from journal where PayrollPayCheckId = @Id;";
			const string deletepaycheckcomps = "delete from PayCheckCompensation where PayCheckId=@Id; ";
			const string deletepaycheckdeds = "delete from PayCheckDeduction where PayCheckId=@Id; ";
			const string deletepaycheckextract = "delete from PayCheckExtract where PayrollPayCheckId=@Id; ";
			const string deletepaycheckpaycodes = "delete from PayCheckPayCode where PayCheckId=@Id; ";
			const string deletepaycheckaccum = "delete from PayCheckPayTypeAccumulation where PayCheckId=@Id; ";
			const string deletepaychecktaxes = "delete from PayCheckTax where PayCheckId=@Id; ";
			const string deletepaycheckworkercomps = "delete from PayCheckWorkerCompensation where PayCheckId=@Id; ";
			const string deletepaychecks = "delete from PayrollPayCheck where PayrollId=@Id; ";
			const string deletepayroll = "delete from Payroll where Id=@Id;";
			const string logquery = @"insert into PayrollVoidLog(PayrollId, CompanyId, CompanyName, StartDate, EndDate, PayDay, Action, [User], TS) values (@PayrollId, @CompanyId, @CompanyName, @StartDate, @EndDate, @PayDay, 2, @User, getdate())";
			using (var conn = GetConnection())
			{
				Log.Info("delete payroll started " + DateTime.Now);
				dynamic candelete =
					conn.Query(checkCanDelete, new { PayrollId = payroll.Id }).FirstOrDefault();
				if (candelete != null && candelete.candelete)
				{
					conn.Execute(deletememento, payroll.PayChecks);
					Log.Info("deleted mementos " + DateTime.Now);
					conn.Execute(deletejournals, payroll.PayChecks);
					Log.Info("deleted journals " + DateTime.Now);
					conn.Execute(deletepaycheckcomps, payroll.PayChecks);
					conn.Execute(deletepaycheckdeds, payroll.PayChecks);
					conn.Execute(deletepaycheckextract, payroll.PayChecks);
					conn.Execute(deletepaycheckpaycodes, payroll.PayChecks);
					conn.Execute(deletepaychecktaxes, payroll.PayChecks);
					conn.Execute(deletepaycheckworkercomps, payroll.PayChecks);
					conn.Execute(deletepaycheckaccum, payroll.PayChecks);
					conn.Execute(deletepaychecks, new { Id = payroll.Id });
					Log.Info("deleted checks " + DateTime.Now);
					
					conn.Execute(deletepayroll, new {Id = payroll.Id});
					conn.Execute(logquery,
						new
						{
							PayrollId = payroll.Id,
							CompanyId = payroll.Company.Id,
							CompanyName = payroll.Company.Name,
							StartDate = payroll.StartDate,
							EndDate = payroll.EndDate,
							PayDay = payroll.PayDay,
							User = payroll.UserName
						});
					Log.Info("deleted payroll " + DateTime.Now);
				}
				
				
			}
		}

		public bool CanUpdateCheckNumbers(Guid id, int startingCheckNumber, int count)
		{
			const string query = @"select Id from PayrollPayCheck where CompanyId=(select CompanyId from Payroll where Id=@PayrollId) and CheckNumber between @Start and @End;";
			using (var conn = GetConnection())
			{
				var paychecks = conn.Query<int>(query, new { PayrollId = id, Start = startingCheckNumber, End = startingCheckNumber + count - 1 }).ToList();
				if (paychecks.Count > 0)
					return false;
				return true;

			}
		}

		public void UpdatePayrollCheckNumbers(Models.Payroll payroll)
		{
			const string query = @"update PayrollPayCheck set CheckNumber=@CheckNumber where Id=@Id;update Journal set CheckNumber=@CheckNumber where PayrollPayCheckId=@Id;";
			using (var conn = GetConnection())
			{
				conn.Execute(query, payroll.PayChecks);
			}
		}

		public void VoidPayroll(Models.Payroll payroll, string userName)
		{
			const string query = @"update Journal set IsVoid=1, LastModifiedBy=@User, LastModified=getdate() Where PayrollId=@Id;update PayrollPayCheck set IsVoid=1, Status=7, VoidedOn=getdate(), LastModifiedBy=@User, LastModified=getdate(), VoidedBy=@User Where PayrollId=@Id;update Payroll set IsVoid=1, VoidedOn=getDate(), VoidedBy=@User, LastModified=getdate() where Id=@Id;";
			const string logquery = @"insert into PayrollVoidLog(PayrollId, CompanyId, CompanyName, StartDate, EndDate, PayDay, Action, [User], TS) values (@PayrollId, @CompanyId, @CompanyName, @StartDate, @EndDate, @PayDay, 1, @User, getdate())";
			const string timesheetquery = "update timesheetentry set IsPaid=0, PayrollId=null, PayDay=null where PayrollId=@Id";
			using (var conn = GetConnection())
			{
				conn.Execute(query, new {Id = payroll.Id, User = userName});
				conn.Execute(logquery, new { PayrollId=payroll.Id, CompanyId = payroll.Company.Id, CompanyName = payroll.Company.Name, StartDate = payroll.StartDate, EndDate = payroll.EndDate, PayDay = payroll.PayDay, User = userName });
				if (payroll.LoadFromTimesheets)
					conn.Execute(timesheetquery, new { Id = payroll.Id });
			}
		}
		public void UnVoidPayroll(Models.Payroll payroll, string userName)
		{
			const string query = @"update Journal set IsVoid=0, LastModifiedBy=@User, LastModified=getdate() Where PayrollId=@Id;update PayrollPayCheck set IsVoid=0, Status=3, VoidedOn=null, LastModifiedBy=@User, LastModified=getdate(), VoidedBy=null Where PayrollId=@Id;update Payroll set IsVoid=0, VoidedOn=null, VoidedBy=null, LastModified=getdate() where Id=@Id;";
			using (var conn = GetConnection())
			{
				conn.Execute(query, new { Id = payroll.Id, User = userName });
			}
			if (payroll.LoadFromTimesheets)
				UpdateTimesheetsToPaid(payroll);
		}

		public void UpdateCompanyAndEmployeeLastPayrollDate()
		{
			const string query = @"UPDATE C SET LASTPAYROLLDATE=mAXpAYDAY FROM company c, (select CompanyId, max(PayDay) MaxPayDay from Payroll where IsVoid=0 group by CompanyId) mpd where c.Id= mpd.CompanyId and (c.LastPayrollDate<>MaxPayDay OR (C.LastPayrollDate IS NULL AND MPD.MaxPayDay IS NOT NULL)); update e set LastPayrollDate=empd.payday FROM Employee E left outer join DBO.EMPLOYEELASTPAYDAY EMPD on E.ID= EMPD.EMPLOYEEid WHERE  e.LastPayrollDate<>empd.payday or (e.LastPayrollDate is null and empd.payday is not null);";
			using (var conn = GetConnection())
			{
				conn.Execute(query);
			}
		}

		public void VoidPayChecks(List<PayCheck> payChecks, string userName)
		{
			payChecks.ForEach(pc =>
			{
				pc.LastModifiedBy = userName;
				pc.Status=PaycheckStatus.Void;
			});
			const string updatepayroll = @"update PayrollPayCheck set IsVoid=1, Status=@Status, VoidedOn=getdate(), LastModifiedBy=@LastModifiedBy, LastModified=getdate(), VoidedBy=@LastModifiedBy Where Id=@Id";
			const string updatejournal = @"update Journal set IsVoid=1, LastModifiedBy=@LastModifiedBy, LastModified=getdate() Where PayrollPayCheckId=@Id";
			const string updatetimesheet = "update TimesheetEntry set IsPaid=0, PayrollId=null, PayDay=null where PayrollId=@PayrollId and EmployeeId=@EmployeeId";
			using (var conn = GetConnection())
			{
				
				conn.Execute(updatejournal, payChecks);
				conn.Execute(updatepayroll, payChecks);
				conn.Execute(updatetimesheet, payChecks);
			}
		}
		public PayCheck UnVoidPayCheck(PayCheck payCheck, string name)
		{
			using (var conn = GetConnection())
			{
				const string updatepayroll = @"update PayrollPayCheck set IsVoid=@IsVoid, Status=@Status, VoidedOn=@VoidedOn, VoidedBy=@VoidedBy, LastModifiedBy=@LastModifiedBy, LastModified=getdate() Where Id=@Id";
				const string updatejournal = @"update Journal set IsVoid=0, LastModifiedBy=@LastModifiedBy, LastModified=getdate() Where PayrollPayCheckId=@Id";
				
				conn.Execute(updatejournal, payCheck);
				conn.Execute(updatepayroll, payCheck);
			}
			
			return payCheck;
		}
		public void UpdateLastPayrollDateCompany(Guid id, DateTime payDay)
		{
			var sql = "update Company set LastPayrollDate=case when LastPayrollDate is null or LastPayrollDate<@PayDay then @PayDay else LastPayrollDate end where Id=@Id";
			using (var conn = GetConnection())
			{
				conn.Execute(sql, new {Id = id, PayDay = payDay});
			}
			
		}

		public void UpdateLastPayrollDateAndPayRateEmployee(List<PayCheck> payChecks)
		{
			var sql =
				"update Employee set LastPayrollDate=case when LastPayrollDate is null or LastPayrollDate<@PayDay then @PayDay else LastPayrollDate end, Rate = case when PayType in (1,2) and Rate<>@EmployeeRate then @EmployeeRate else Rate end, PayCodes = case when PayType in (1,2) then @EmployeePayCodes else PayCodes end where Id=@EmployeeId";
			using (var conn = GetConnection())
			{
				conn.Execute(sql, payChecks);
			}
		}
		public void UpdateLastPayrollDateAndPayRateEmployee(Guid id, decimal rate)
		{

			var dbEmployee = _dbContext.Employees.FirstOrDefault(c => c.Id == id);
			if (dbEmployee != null)
			{
				if (_dbContext.PayrollPayChecks.Any(pc => pc.EmployeeId == id && !pc.IsVoid))
				{
					dbEmployee.LastPayrollDate = _dbContext.PayrollPayChecks.Where(pc => pc.EmployeeId == id && !pc.IsVoid).Max(pc=>pc.PayDay);
				}
				
				if (dbEmployee.Rate != rate)
				{
					dbEmployee.Rate = rate;
					if (dbEmployee.PayType == (int)EmployeeType.Hourly)
					{
						var pcodes = JsonConvert.DeserializeObject<List<CompanyPayCode>>(dbEmployee.PayCodes);
						var def = pcodes.FirstOrDefault(pc => pc.Id == 0);
						if (def != null)
							def.HourlyRate = rate;
						dbEmployee.PayCodes = JsonConvert.SerializeObject(pcodes);
					}
				}
				_dbContext.SaveChanges();
			}
		}

		public void UnQueuePayroll(Guid id)
		{
			const string sql = "update payroll set isqueued=0, confirmedtime=getdate(), isconfirmfailed=0  where id=@Id";
			using (var conn = GetConnection())
			{
				conn.Execute(sql, new {Id = id});
			}
		}

		public void ConfirmFailed(Guid id)
		{
			const string sql = "update payroll set isqueued=1, confirmedtime=null, isconfirmfailed=1 where id=@Id";
			using (var conn = GetConnection())
			{
				conn.Execute(sql, new { Id = id });
			}
		}
		public void FixMovedInvoice(Guid id, Guid companyId, string wc)
		{
			var sql = "update PayrollInvoice set CompanyId=@CompanyId, WorkerCompensations=@WorkerCompensations where Id=@Id";
			using (var conn = GetConnection())
			{
				conn.Execute(sql, new {Id = id, CompanyId = companyId, WorkerCompensations = wc});
			}
		}

		public List<PayCheckJournal> EnsureCheckNumberIntegrity(Guid payrollId, bool peoasoCoCheck)
		{
			using (var conn = GetConnection())
			{
				return conn.Query<PayCheckJournal>("EnsureCheckNumberintegrity", new {PayrollId = payrollId, PEOASOCoCheck = peoasoCoCheck},
					commandType: CommandType.StoredProcedure).ToList();
			}
		}

		public void UpdateInvoiceRecurringCharges(List<PayrollInvoiceMiscCharges> updatedList)
		{
			var mapped = _mapper.Map<List<Models.PayrollInvoiceMiscCharges>, List<Models.JsonDataModel.PayrollInvoiceMiscCharges>>(updatedList);
			const string sql = "Update PayrollInvoice set MiscCharges=@MiscCharges where Id=@Id";
			using (var conn = GetConnection())
			{
				conn.Execute(sql, mapped);
			}
		}

		public List<PayrollInvoiceMiscCharges> GetFutureInvoicesMiscCharges(Guid companyId, int invoiceNumber)
		{
			const string sql =
				"select Id, MiscCharges from PayrollInvoice where CompanyId=@CompanyId and InvoiceNumber>@InvoiceNumber";
			using (var conn = GetConnection())
			{
				var list = conn.Query<Models.JsonDataModel.PayrollInvoiceMiscCharges>(sql, new {CompanyId = companyId, InvoiceNumber=invoiceNumber}).ToList();
				return
					_mapper.Map<List<Models.JsonDataModel.PayrollInvoiceMiscCharges>, List<Models.PayrollInvoiceMiscCharges>>(list);
			}
		}

		public void DelayPayrollInvoice(Guid id, bool taxesDelayed, DateTime lastModified, string userName)
		{
			const string sql =
				"update PayrollInvoice set TaxesDelayed=@TaxesDelayed, LastModified=getdate(), LastModifiedBy=@User where Id=@Id";
			using (var conn = GetConnection())
			{
				conn.Execute(sql, new {Id = id, TaxesDelayed = taxesDelayed, User = userName});
			}
		}
        public void SaveScheduledPayroll(SchedulePayroll payroll)
		{
			const string sql =
				"if @Id=0 insert into ScheduledPayroll(CompanyId, PaySchedule, ScheduleStartDate, PayDateStart, LastPayrollDate, Status, Data, LastModified, LastModifiedBy, LastPayrollId) values(@CompanyId, @PaySchedule, @ScheduleStartDate, @PayDateStart, @LastPayrollDate, @Status, @Data, @LastModified, @LastModifiedBy, @LastPayrollId) else update ScheduledPayroll set ScheduleStartDate=@ScheduleStartDate, PayDateStart=@PayDateStart,Status=@Status, Data=@Data, LastModified=@LastModified, LastModifiedBy=@LastModifiedBy, LastPayrollDate=@LastPayrollDate, LastPayrollId=@LastPayrollId where Id=@Id";
			var mapped = Mapper.Map<SchedulePayroll, ScheduledPayrollJson>(payroll);
			using (var conn = GetConnection())
			{
				conn.Execute(sql, mapped);
			}
		}
		public void FixPayCheckPayCodes(List<PayCheck> payChecks)
		{
			var mapped = Mapper.Map<List<PayCheck>, List<Models.DataModel.PayrollPayCheck>>(payChecks);
			const string sql =
				"update PayrollPayCheck set PayCodes = @PayCodes where Id=@Id";
			
			using (var conn = GetConnection())
			{
				conn.Execute(sql, mapped);
			}
		}

		public void DeleteSchedulePayroll(SchedulePayroll payroll)
		{
			const string sql =
				"delete from ScheduledPayroll where Id=@Id";

			using (var conn = GetConnection())
			{
				conn.Execute(sql, payroll);
			}
		}

		public void UpdateTimesheetsToPaid(Models.Payroll payroll)
		{
			const string sql =
				"update TimesheetEntry set IsPaid=1, PayrollId=@Id, PayDay=@PayDay where EntryDate between @StartDate and @EndDate " +
				"and ((@ProjectId is not null and ProjectId=@ProjectId) or (ProjectId is null)) and EmployeeId in (select EmployeeId from PayrollPayCheck where PayrollId=@Id)";

			using (var conn = GetConnection())
			{
				int? projectId = payroll.Project != null ? payroll.Project.Id : default(int?);
				conn.Execute(sql, new { ProjectId = projectId, Id=payroll.Id, PayDay = payroll.PayDay, StartDate = payroll.StartDate, EndDate = payroll.EndDate});
			}
		}
	}
}
