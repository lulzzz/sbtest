using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data.Common;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text.RegularExpressions;
using Dapper;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Repository;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;
using Newtonsoft.Json;
using Invoice = HrMaxx.OnlinePayroll.Models.Invoice;
using InvoiceDeliveryClaim = HrMaxx.OnlinePayroll.Models.InvoiceDeliveryClaim;
using PayrollInvoice = HrMaxx.OnlinePayroll.Models.PayrollInvoice;

namespace HrMaxx.OnlinePayroll.Repository.Payroll
{
	public class PayrollRepository : BaseDapperRepository, IPayrollRepository
	{
		private readonly OnlinePayrollEntities _dbContext;
		private readonly IMapper _mapper;
		
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
				_dbContext.Payrolls.Add(mapped);
				_dbContext.SaveChanges();
			}
			return _mapper.Map<Models.DataModel.Payroll, Models.Payroll>(mapped);

		}

		public void UpdatePayCheckYTD(PayCheck employeeFutureCheck)
		{
			var dbPayCheck = _dbContext.PayrollPayChecks.FirstOrDefault(p => p.Id == employeeFutureCheck.Id);
			if (dbPayCheck != null)
			{
				dbPayCheck.PayCodes = JsonConvert.SerializeObject(employeeFutureCheck.PayCodes);
				dbPayCheck.Compensations = JsonConvert.SerializeObject(employeeFutureCheck.Compensations);
				dbPayCheck.Taxes = JsonConvert.SerializeObject(employeeFutureCheck.Taxes);
				dbPayCheck.Deductions = JsonConvert.SerializeObject(employeeFutureCheck.Deductions);
				dbPayCheck.Accumulations = JsonConvert.SerializeObject(employeeFutureCheck.Accumulations);
				dbPayCheck.YTDSalary = employeeFutureCheck.YTDSalary;
				dbPayCheck.YTDGrossWage = employeeFutureCheck.YTDGrossWage;
				dbPayCheck.YTDNetWage = employeeFutureCheck.YTDNetWage;
				_dbContext.SaveChanges();
			}
		}

		public PayCheck VoidPayCheck(PayCheck paycheck, string name)
		{
			var pc = _dbContext.PayrollPayChecks.FirstOrDefault(p => p.Id == paycheck.Id);
			if (pc != null)
			{
				pc.IsVoid = paycheck.IsVoid;
				pc.Status = (int)paycheck.Status;
				pc.VoidedOn = DateTime.Now;
				pc.LastModified = DateTime.Now;
				pc.LastModifiedBy = name;
				_dbContext.SaveChanges();
			}
			return _mapper.Map<PayrollPayCheck, PayCheck>(pc);
		}

		public void ChangePayCheckStatus(int payCheckId, PaycheckStatus printed)
		{
			var dbcheck = _dbContext.PayrollPayChecks.First(p => p.Id == payCheckId);
			dbcheck.Status = (int) printed;
			_dbContext.SaveChanges();
		}

		public void MarkPayrollPrinted(Guid payrollId)
		{
			var dbPayroll = _dbContext.Payrolls.First(p => p.Id == payrollId);
			dbPayroll.Status = (int)PayrollStatus.Printed;
			foreach (var check in dbPayroll.PayrollPayChecks.Where(pc=>!pc.IsVoid).ToList())
			{
				if (check.Status == (int) PaycheckStatus.Saved)
					check.Status = (int) PaycheckStatus.Printed;
				else if (check.Status == (int)PaycheckStatus.Paid)
					check.Status = (int)PaycheckStatus.PrintedAndPaid;
			}
			_dbContext.SaveChanges();
		}

		public PayrollInvoice SavePayrollInvoice(PayrollInvoice payrollInvoice)
		{
			var mapped = _mapper.Map<Models.PayrollInvoice, Models.DataModel.PayrollInvoice>(payrollInvoice);
			var dbPayrollInvoice = _dbContext.PayrollInvoices.FirstOrDefault(pi => pi.Id == payrollInvoice.Id || pi.PayrollId==payrollInvoice.PayrollId);
			var dbPayroll = _dbContext.Payrolls.First(p => p.Id == payrollInvoice.PayrollId);
			var dbPayChecks = _dbContext.PayrollPayChecks.Where(pc => payrollInvoice.PayChecks.Any(pc1 => pc1 == pc.Id)).ToList();
			var dbCreditedChecks = _dbContext.PayrollPayChecks.Where(pc => payrollInvoice.VoidedCreditedChecks.Any(vpc => vpc == pc.Id) && pc.IsVoid && pc.InvoiceId.HasValue).ToList();
			if (dbPayrollInvoice == null)
			{
				_dbContext.PayrollInvoices.Add(mapped);
				dbPayroll.InvoiceId = mapped.Id;
				dbPayChecks.ForEach(pc=>pc.InvoiceId=mapped.Id);
				dbCreditedChecks.ForEach(pc=>pc.CreditInvoiceId=mapped.Id);
			}
			else
			{
				var linkedVoidedChecks = _dbContext.PayrollPayChecks.Where(pc => pc.CreditInvoiceId == dbPayrollInvoice.Id).ToList();
				linkedVoidedChecks.ForEach(lvc=>lvc.CreditInvoiceId=null);
				dbCreditedChecks.ForEach(pc=>pc.CreditInvoiceId=dbPayrollInvoice.Id);


				dbPayrollInvoice.MiscCharges = mapped.MiscCharges;
				dbPayrollInvoice.Total = mapped.Total;
				dbPayrollInvoice.LastModified = mapped.LastModified;
				dbPayrollInvoice.LastModifiedBy = mapped.LastModifiedBy;
				dbPayrollInvoice.Status = mapped.Status;
				dbPayrollInvoice.SubmittedBy = mapped.SubmittedBy;
				dbPayrollInvoice.SubmittedOn = mapped.SubmittedOn;
				dbPayrollInvoice.DeliveredBy = mapped.DeliveredBy;
				dbPayrollInvoice.DeliveredOn = mapped.DeliveredOn;
				dbPayrollInvoice.InvoiceDate = mapped.InvoiceDate;
				dbPayrollInvoice.Deductions = mapped.Deductions;
				dbPayrollInvoice.Courier = mapped.Courier;
				dbPayrollInvoice.Notes = mapped.Notes;
				dbPayrollInvoice.Balance = mapped.Balance;
				dbPayrollInvoice.WorkerCompensations = mapped.WorkerCompensations;
				dbPayrollInvoice.ApplyWCMinWageLimit = mapped.ApplyWCMinWageLimit;
				dbPayrollInvoice.VoidedCreditChecks = mapped.VoidedCreditChecks;
				dbPayrollInvoice.NetPay = mapped.NetPay;
				dbPayrollInvoice.DDPay = mapped.DDPay;
				dbPayrollInvoice.CheckPay = mapped.CheckPay;
				dbPayrollInvoice.SalesRep = mapped.SalesRep;
				dbPayrollInvoice.Commission = mapped.Commission;
				var removeCounter = 0;
				for (removeCounter = 0; removeCounter < dbPayrollInvoice.InvoicePayments.Count; removeCounter++)
				{
					var existingPayment = dbPayrollInvoice.InvoicePayments.ToList()[removeCounter];
					if (mapped.InvoicePayments.All(ip=>ip.Id!=existingPayment.Id))
					{
						_dbContext.InvoicePayments.Remove(existingPayment);
						removeCounter--;
					}
				}

				foreach (var p in dbPayrollInvoice.InvoicePayments.Where(dip=>mapped.InvoicePayments.Any(mip=>dip.Id==mip.Id) && payrollInvoice.InvoicePayments.Any(pip=>pip.Id==dip.Id && pip.HasChanged)))
				{
					var matching = mapped.InvoicePayments.First(mip=>mip.Id==p.Id);
					p.Amount = matching.Amount;
					p.CheckNumber = matching.CheckNumber;
					p.Method = matching.Method;
					p.Notes = matching.Notes;
					p.PaymentDate = matching.PaymentDate;
					p.Status = (int) matching.Status;
					p.LastModified = mapped.LastModified;
					p.LastModifiedBy = mapped.LastModifiedBy;
				}
				_dbContext.InvoicePayments.AddRange(mapped.InvoicePayments.Where(mip=>mip.Id==0));
				
			}
			_dbContext.SaveChanges();
			dbPayrollInvoice = _dbContext.PayrollInvoices.FirstOrDefault(pi => pi.Id == payrollInvoice.Id);
			return _mapper.Map<Models.DataModel.PayrollInvoice, Models.PayrollInvoice>(dbPayrollInvoice);
		}

		public void DeletePayrollInvoice(Guid invoiceId)
		{
			var db = _dbContext.PayrollInvoices.FirstOrDefault(i => i.Id == invoiceId);
			if (db != null)
			{
				var creditInvoices = _dbContext.PayrollPayChecks.Where(pc => pc.CreditInvoiceId == invoiceId).ToList();
				creditInvoices.ForEach(ci=>ci.CreditInvoiceId=null);
				db.Payroll.InvoiceId = null;
				db.PayrollPayChecks.ToList().ForEach(pc=>pc.InvoiceId=null);
				_dbContext.PayrollInvoices.Remove(db);
				_dbContext.SaveChanges();
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
			var dbPayroll = _dbContext.Payrolls.FirstOrDefault(p => p.Id == payrollId);
			
			if (dbPayroll != null)
			{
				var originalDate = dbPayroll.PayDay;
				dbPayroll.PayDay = date.Date;
				var dbPayChecks = dbPayroll.PayrollPayChecks.Where(pc => payChecks.Contains(pc.Id)).ToList();
				dbPayChecks.ForEach(pc=>pc.PayDay=date.Date);
				var dbJournals = _dbContext.Journals.Where(j => payChecks.Contains(j.PayrollPayCheckId.Value)).ToList();
				dbJournals.ForEach(j =>
				{
					j.TransactionDate = date.Date;
					if (!j.OriginalDate.HasValue && DateTime.Today > originalDate)
					{
						j.OriginalDate = originalDate;
					}
				});
				_dbContext.SaveChanges();
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

		public void UpdatePayCheckSickLeaveAccumulation(PayCheck pc)
		{
			var dbCheck = _dbContext.PayrollPayChecks.FirstOrDefault(p => p.Id == pc.Id);
			//var dbEmp = _dbContext.Employees.First(e => e.Id == pc.Employee.Id);
			if (dbCheck != null)
			{
				dbCheck.Accumulations = JsonConvert.SerializeObject(pc.Accumulations);
				//dbCheck.Employee = JsonConvert.SerializeObject(pc.Employee);
				//dbEmp.CarryOver = pc.Employee.CarryOver;
				_dbContext.SaveChanges();
			}
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

		public void SavePayrollInvoiceCommission(PayrollInvoice payrollInvoice)
		{
			var dbi = _dbContext.PayrollInvoices.First(i => i.Id == payrollInvoice.Id);
			dbi.SalesRep = payrollInvoice.SalesRep;
			dbi.Commission = payrollInvoice.Commission;
			_dbContext.SaveChanges();
		}
		
		public List<InvoiceDeliveryClaim> GetInvoiceDeliveryClaims()
		{
			var dbClaims = _dbContext.InvoiceDeliveryClaims.ToList();
			return _mapper.Map<List<Models.DataModel.InvoiceDeliveryClaim>, List<Models.InvoiceDeliveryClaim>>(dbClaims);
		}

		public void SavePayCheckPayTypeAccumulations(List<PayCheckPayTypeAccumulation> ptaccums)
		{
			const string deletesql = @"DELETE FROM PayCheckPayTypeAccumulation WHERE PayCheckId = @PayCheckId and PayTypeId=@PayTypeId";
			const string insertsql = @"insert into PayCheckPayTypeAccumulation (PayCheckId, PayTypeId, FiscalStart, FiscalEnd, AccumulatedValue, Used, CarryOver) values(@PayCheckId, @PayTypeId, @FiscalStart, @FiscalEnd, @AccumulatedValue, @Used, @CarryOver);";
			OpenConnection();
			ptaccums.ForEach(pta =>
			{
				Connection.Execute(deletesql, new { pta.PayCheckId, pta.PayTypeId });
				Connection.Execute(insertsql, new { pta.PayCheckId, pta.PayTypeId, pta.FiscalStart, pta.FiscalEnd, pta.AccumulatedValue, pta.Used, pta.CarryOver });
			});
		}

		public void SavePayCheckTaxes(List<PayCheckTax> pttaxes)
		{
			const string deletesql = @"DELETE FROM PayCheckTax WHERE PayCheckId = @PayCheckId and TaxId=@TaxId;";
			const string insertsql = @"insert into PayCheckTax (PayCheckId, TaxId, TaxableWage, Amount) values(@PayCheckId, @TaxId, @TaxableWage, @Amount);";
			OpenConnection();
			pttaxes.ForEach(pta =>
			{
				Connection.Execute(deletesql, new { pta.PayCheckId, pta.TaxId });
				Connection.Execute(insertsql, new { pta.PayCheckId, pta.TaxId, pta.TaxableWage, pta.Amount });
			});
		}

		public void SavePayCheckCompensations(List<PayCheckCompensation> ptcomps)
		{
			const string deletesql = @"DELETE FROM PayCheckCompensation WHERE PayCheckId = @PayCheckId and PayTypeId=@PayTypeId;";
			const string insertsql = @"insert into PayCheckCompensation (PayCheckId, PayTypeId, Amount) values(@PayCheckId, @PayTypeId, @Amount);";
			OpenConnection();
			ptcomps.ForEach(pta =>
			{
				Connection.Execute(deletesql, new { pta.PayCheckId, pta.PayTypeId });
				Connection.Execute(insertsql, new { pta.PayCheckId, pta.PayTypeId,  pta.Amount });
			});
		}

		public void SavePayCheckDeductions(List<PayCheckDeduction> ptdeds)
		{
			const string deletesql = @"DELETE FROM PayCheckDeduction WHERE PayCheckId = @PayCheckId and EmployeeDeductionId=@EmployeeDeductionId and CompanyDeductionId=@CompanyDeductionId;";
			const string insertsql = @"insert into PayCheckDeduction (PayCheckId, EmployeeDeductionId, CompanyDeductionId, EmployeeDeductionFlat, Method, Rate, AnnualMax, Wage, Amount) values(@PayCheckId, @EmployeeDeductionId, @CompanyDeductionId, @EmployeeDeductionFlat, @Method, @Rate, @AnnualMax, @Wage, @Amount);";
			OpenConnection();
			ptdeds.ForEach(pta =>
			{
				Connection.Execute(deletesql, new { pta.PayCheckId, pta.EmployeeDeductionId, pta.CompanyDeductionId });
				Connection.Execute(insertsql, new { pta.PayCheckId, pta.EmployeeDeductionId, pta.CompanyDeductionId, pta.EmployeeDeductionFlat, pta.Method, pta.Rate, pta.AnnualMax, pta.Wage, pta.Amount });
			});
		}

		public void SavePayCheckPayCodes(List<PayCheckPayCode> ptcodes)
		{
			const string deletesql = @"DELETE FROM PayCheckPayCode WHERE PayCheckId = @PayCheckId and PayCodeId=@PayCodeId;";
			const string insertsql = @"insert into PayCheckPayCode (PayCheckId, PayCodeId, PayCodeFlat, Amount, Overtime) values(@PayCheckId, @PayCodeId, @PayCodeFlat, @Amount, @Overtime);";
			OpenConnection();
			ptcodes.ForEach(pta =>
			{
				Connection.Execute(deletesql, new { pta.PayCheckId, pta.PayCodeId });
				Connection.Execute(insertsql, new { pta.PayCheckId, pta.PayCodeId, pta.PayCodeFlat, pta.Amount, pta.Overtime });
			});
		}

		public void SavePayCheckWorkerCompensations(List<PayCheckWorkerCompensation> ptwcs)
		{
			const string deletesql = @"DELETE FROM PayCheckWorkerCompensation WHERE PayCheckId = @PayCheckId;";
			const string insertsql = @"insert into PayCheckWorkerCompensation (PayCheckId, WorkerCompensationId, WorkerCompensationFlat, Wage, Amount) values(@PayCheckId, @WorkerCompensationId, @WorkerCompensationFlat, @Wage, @Amount);";
			OpenConnection();
			ptwcs.ForEach(pta =>
			{
				Connection.Execute(deletesql, new { pta.PayCheckId });
				Connection.Execute(insertsql, new { pta.PayCheckId, pta.WorkerCompensationId, pta.WorkerCompensationFlat, pta.Wage, pta.Amount });
			});
		}
	}
}
