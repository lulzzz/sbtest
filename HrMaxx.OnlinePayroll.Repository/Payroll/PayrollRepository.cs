﻿using System;
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
using Journal = HrMaxx.OnlinePayroll.Models.Journal;
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
			//const string psql =
			//	"insert into Payroll (Id,CompanyId,StartDate,EndDate,PayDay,StartingCheckNumber,Status,Company,LastModified,LastModifiedBy,InvoiceId,PEOASOCoCheck,Notes,TaxPayDay,IsHistory,CopiedFrom,MovedFrom) values(@Id,@CompanyId,@StartDate,@EndDate,@PayDay,@StartingCheckNumber,@Status,@Company,@LastModified,@LastModifiedBy,@InvoiceId,@PEOASOCoCheck,@Notes,@TaxPayDay,@IsHistory,@CopiedFrom,@MovedFrom);";
			//const string pcsql = "insert into PayrollPayCheck(PayrollId,CompanyId,EmployeeId,Employee,GrossWage,NetWage,WCAmount,Compensations,Deductions,Taxes,Accumulations,Salary,YTDSalary,PayCodes,DeductionAmount,EmployeeTaxes,EmployerTaxes,Status,IsVoid,PayrmentMethod,PrintStatus,StartDate,EndDate,PayDay,CheckNumber,PaymentMethod,Notes,YTDGrossWage,YTDNetWage,LastModified,LastModifiedBy,WorkerCompensation,PEOASOCoCheck,InvoiceId,VoidedOn,CreditInvoiceId,TaxPayDay,IsHistory,IsReIssued,OriginalCheckNumber,ReIssuedDate) values(@PayrollId,@CompanyId,@EmployeeId,@Employee,@GrossWage,@NetWage,@WCAmount,@Compensations,@Deductions,@Taxes,@Accumulations,@Salary,@YTDSalary,@PayCodes,@DeductionAmount,@EmployeeTaxes,@EmployerTaxes,@Status,@IsVoid,@PayrmentMethod,@PrintStatus,@StartDate,@EndDate,@PayDay,@CheckNumber,@PaymentMethod,@Notes,@YTDGrossWage,@YTDNetWage,@LastModified,@LastModifiedBy,@WorkerCompensation,@PEOASOCoCheck,@InvoiceId,@VoidedOn,@CreditInvoiceId,@TaxPayDay,@IsHistory,@IsReIssued,@OriginalCheckNumber,@ReIssuedDate);select cast(Scope_Identity() as int)";
			//using (var conn = GetConnection())
			//{
			//	conn.Execute(psql, mapped);
			//	mapped.PayrollPayChecks.ToList().ForEach(pc =>
			//	{
			//		pc.PayrollId = mapped.Id;
			//		pc.Id = conn.Query<int>(pcsql, pc).Single();
			//	});
			//}
			var dbPayroll = _dbContext.Payrolls.FirstOrDefault(p => p.Id == mapped.Id);
			if (dbPayroll == null)
			{
				_dbContext.Payrolls.Add(mapped);
				_dbContext.SaveChanges();
			}
			return _mapper.Map<Models.DataModel.Payroll, Models.Payroll>(mapped);

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
				//var dbPayCheck = _dbContext.PayrollPayChecks.FirstOrDefault(p => p.Id == pc.Id);
				//if (dbPayCheck != null)
				//{
				//	dbPayCheck.PayCodes = JsonConvert.SerializeObject(pc.PayCodes);
				//	dbPayCheck.Compensations = JsonConvert.SerializeObject(pc.Compensations);
				//	dbPayCheck.Taxes = JsonConvert.SerializeObject(pc.Taxes);
				//	dbPayCheck.Deductions = JsonConvert.SerializeObject(pc.Deductions);
				//	dbPayCheck.Accumulations = JsonConvert.SerializeObject(pc.Accumulations);
				//	dbPayCheck.YTDSalary = pc.YTDSalary;
				//	dbPayCheck.YTDGrossWage = pc.YTDGrossWage;
				//	dbPayCheck.YTDNetWage = pc.YTDNetWage;
				//	_dbContext.SaveChanges();
				//}
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

		public PayCheck UnVoidPayCheck(PayCheck paycheck, string name)
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

			using (var conn = GetConnection())
			{
				const string updatecheck = @"update PayrollPayCheck set Status=case status when 3 then 4 when 5 then 6 else status end Where PayrollId=@PayrollId";
				const string updatepayroll = @"update Payroll set Status=@Status Where Id=@Id";

				conn.Execute(updatepayroll, new {Status = (int) PayrollStatus.Printed, Id = payrollId});
				conn.Execute(updatecheck, new { PayrollId = payrollId });
				
			}

			
		}

		//public PayrollInvoice SavePayrollInvoice(PayrollInvoice payrollInvoice)
		//{
		//	var mapped = _mapper.Map<Models.PayrollInvoice, Models.DataModel.PayrollInvoice>(payrollInvoice);
		//	var dbPayrollInvoice = _dbContext.PayrollInvoices.FirstOrDefault(pi => pi.Id == payrollInvoice.Id || pi.PayrollId == payrollInvoice.PayrollId);
		//	var dbPayroll = _dbContext.Payrolls.First(p => p.Id == payrollInvoice.PayrollId);
		//	var dbPayChecks = _dbContext.PayrollPayChecks.Where(pc => payrollInvoice.PayChecks.Any(pc1 => pc1 == pc.Id)).ToList();
		//	var dbCreditedChecks = _dbContext.PayrollPayChecks.Where(pc => payrollInvoice.VoidedCreditedChecks.Any(vpc => vpc == pc.Id) && pc.IsVoid && pc.InvoiceId.HasValue).ToList();
		//	if (dbPayrollInvoice == null)
		//	{
		//		_dbContext.PayrollInvoices.Add(mapped);
		//		dbPayroll.InvoiceId = mapped.Id;
		//		dbPayChecks.ForEach(pc => pc.InvoiceId = mapped.Id);
		//		dbCreditedChecks.ForEach(pc => pc.CreditInvoiceId = mapped.Id);
		//	}
		//	else
		//	{
		//		var linkedVoidedChecks = _dbContext.PayrollPayChecks.Where(pc => pc.CreditInvoiceId == dbPayrollInvoice.Id).ToList();
		//		linkedVoidedChecks.ForEach(lvc => lvc.CreditInvoiceId = null);
		//		dbCreditedChecks.ForEach(pc => pc.CreditInvoiceId = dbPayrollInvoice.Id);


		//		dbPayrollInvoice.MiscCharges = mapped.MiscCharges;
		//		dbPayrollInvoice.Total = mapped.Total;
		//		dbPayrollInvoice.LastModified = mapped.LastModified;
		//		dbPayrollInvoice.LastModifiedBy = mapped.LastModifiedBy;
		//		dbPayrollInvoice.Status = mapped.Status;
		//		dbPayrollInvoice.SubmittedBy = mapped.SubmittedBy;
		//		dbPayrollInvoice.SubmittedOn = mapped.SubmittedOn;
		//		dbPayrollInvoice.DeliveredBy = mapped.DeliveredBy;
		//		dbPayrollInvoice.DeliveredOn = mapped.DeliveredOn;
		//		dbPayrollInvoice.InvoiceDate = mapped.InvoiceDate;
		//		dbPayrollInvoice.Deductions = mapped.Deductions;
		//		dbPayrollInvoice.Courier = mapped.Courier;
		//		dbPayrollInvoice.Notes = mapped.Notes;
		//		dbPayrollInvoice.Balance = mapped.Balance;
		//		dbPayrollInvoice.WorkerCompensations = mapped.WorkerCompensations;
		//		dbPayrollInvoice.ApplyWCMinWageLimit = mapped.ApplyWCMinWageLimit;
		//		dbPayrollInvoice.VoidedCreditChecks = mapped.VoidedCreditChecks;
		//		dbPayrollInvoice.NetPay = mapped.NetPay;
		//		dbPayrollInvoice.DDPay = mapped.DDPay;
		//		dbPayrollInvoice.CheckPay = mapped.CheckPay;
		//		dbPayrollInvoice.SalesRep = mapped.SalesRep;
		//		dbPayrollInvoice.Commission = mapped.Commission;
		//		var removeCounter = 0;
		//		for (removeCounter = 0; removeCounter < dbPayrollInvoice.InvoicePayments.Count; removeCounter++)
		//		{
		//			var existingPayment = dbPayrollInvoice.InvoicePayments.ToList()[removeCounter];
		//			if (mapped.InvoicePayments.All(ip => ip.Id != existingPayment.Id))
		//			{
		//				_dbContext.InvoicePayments.Remove(existingPayment);
		//				removeCounter--;
		//			}
		//		}

		//		foreach (var p in dbPayrollInvoice.InvoicePayments.Where(dip => mapped.InvoicePayments.Any(mip => dip.Id == mip.Id) && payrollInvoice.InvoicePayments.Any(pip => pip.Id == dip.Id && pip.HasChanged)))
		//		{
		//			var matching = mapped.InvoicePayments.First(mip => mip.Id == p.Id);
		//			p.Amount = matching.Amount;
		//			p.CheckNumber = matching.CheckNumber;
		//			p.Method = matching.Method;
		//			p.Notes = matching.Notes;
		//			p.PaymentDate = matching.PaymentDate;
		//			p.Status = (int)matching.Status;
		//			p.LastModified = mapped.LastModified;
		//			p.LastModifiedBy = mapped.LastModifiedBy;
		//		}
		//		_dbContext.InvoicePayments.AddRange(mapped.InvoicePayments.Where(mip => mip.Id == 0));

		//	}
		//	_dbContext.SaveChanges();
		//	dbPayrollInvoice = _dbContext.PayrollInvoices.FirstOrDefault(pi => pi.Id == payrollInvoice.Id);
		//	return _mapper.Map<Models.DataModel.PayrollInvoice, Models.PayrollInvoice>(dbPayrollInvoice);
		//}

		public PayrollInvoice SavePayrollInvoice(PayrollInvoice payrollInvoice)
		{
			const string pisql = "select * from PayrollInvoice where Id=@Id or PayrollId=@PayrollId";
			const string pipaysql = "select * from InvoicePayment where InvoiceId=@Id";
			const string insertsql =
						"insert into PayrollInvoice(Id,CompanyId,PayrollId,PeriodStart,PeriodEnd,InvoiceSetup,GrossWages,EmployerTaxes,InvoiceDate,NoOfChecks,Deductions,WorkerCompensations,EmployeeContribution,EmployerContribution,AdminFee,EnvironmentalFee,MiscCharges,Total,Status,SubmittedOn,SubmittedBy,DeliveredOn,DeliveredBy,LastModified,LastModifiedBy,Courier,EmployeeTaxes,Notes,ProcessedBy,Balance,ProcessedOn,PayChecks,VoidedCreditChecks,ApplyWCMinWageLimit,DeliveryClaimedBy,DeliveryClaimedOn,NetPay,CheckPay,DDPay,SalesRep,Commission) values(@Id,@CompanyId,@PayrollId,@PeriodStart,@PeriodEnd,@InvoiceSetup,@GrossWages,@EmployerTaxes,@InvoiceDate,@NoOfChecks,@Deductions,@WorkerCompensations,@EmployeeContribution,@EmployerContribution,@AdminFee,@EnvironmentalFee,@MiscCharges,@Total,@Status,@SubmittedOn,@SubmittedBy,@DeliveredOn,@DeliveredBy,@LastModified,@LastModifiedBy,@Courier,@EmployeeTaxes,@Notes,@ProcessedBy,@Balance,@ProcessedOn,@PayChecks,@VoidedCreditChecks,@ApplyWCMinWageLimit,@DeliveryClaimedBy,@DeliveryClaimedOn,@NetPay,@CheckPay,@DDPay,@SalesRep,@Commission); select cast(scope_identity() as int)";
			const string updatepayrollsql =
				"update Payroll set InvoiceId=@Id where Id=@PayrollId;update PayrollPayCheck set InvoiceId=@Id where Id in @PayCheckIds;";

			const string updatecreditcheckssql = "update PayrollPayCheck set CreditInvoiceId=@Id where Id in @CreditChecks;";

			var mapped = _mapper.Map<Models.PayrollInvoice, Models.DataModel.PayrollInvoice>(payrollInvoice);
			using (var conn = GetConnection())
			{
				var pi =
					conn.Query<Models.DataModel.PayrollInvoice>(pisql, new { Id = payrollInvoice.Id, PayrollId = payrollInvoice.PayrollId })
						.FirstOrDefault();
				if (pi == null)
				{

					payrollInvoice.InvoiceNumber = conn.Query<int>(insertsql, mapped).Single();

					conn.Execute(updatepayrollsql,
						new
						{
							Id = mapped.Id,
							PayrollId = mapped.PayrollId,
							PayCheckIds = payrollInvoice.PayChecks
						});
					if (payrollInvoice.VoidedCreditedChecks.Any())
					{

						conn.Execute(updatecreditcheckssql,
							new
							{
								Id = mapped.Id,
								CreditChecks = payrollInvoice.VoidedCreditedChecks
							});
					}
					return payrollInvoice;
				}
				else
				{
					pi.InvoicePayments = conn.Query<Models.DataModel.InvoicePayment>(pipaysql, new { Id = pi.Id }).ToList();
					const string updatepisql =
						@"update PayrollInvoice set MiscCharges=@MiscCharges, Total=@Total, LastModified=@LastModified, LastModifiedBy=@LastModifiedBy, Status=@Status, 
																		SubmittedBy=@SubmittedBy, SubmittedOn	=@SubmittedOn, DeliveredBy=@DeliveredBy, DeliveredOn=@DeliveredOn, InvoiceDate=@InvoiceDate, Deductions=@Deductions, Courier=@Courier,
																		Notes=@Notes, Balance=@Balance, WorkerCompensations=@WorkerCompensations, VoidedCreditChecks=@VoidedCreditChecks, NetPay=@NetPay, DDPay=@DDPay, CheckPay=@CheckPay, SalesRep=@SalesRep, 
																		Commission=@Commission , TaxesDelayed=@TaxesDelayed  															
																		where Id=@Id";
					
					conn.Execute(updatepisql, mapped);
					
					if (pi.VoidedCreditChecks!=mapped.VoidedCreditChecks)
					{
						const string removecreditchecks = "update PayrollPayCheck set CreditInvoiceId=null where CreditInvoiceId=@Id";
						conn.Execute(removecreditchecks, mapped);
						if (payrollInvoice.VoidedCreditedChecks.Any())
						{
							conn.Execute(updatecreditcheckssql,new { Id = mapped.Id, CreditChecks = payrollInvoice.VoidedCreditedChecks });
						}
					}
					
					const string removepayment = "delete from InvoicePayment where Id=@Id;";
					const string updatepayment =
						@"update InvoicePayment set Amount=@Amount, CheckNumber=@CheckNumber, Method=@Method, Notes=@Notes, PaymentDate=@PaymentDate, Status=@Status, 
LastModified=@LastModified, LastModifiedBy=@LastModifiedBy where Id=@Id;";
					const string insertpayment = "insert into InvoicePayment(InvoiceId,PaymentDate,Method,Status,CheckNumber,Amount,Notes,LastModified,LastModifiedBy) values(@InvoiceId,@PaymentDate,@Method,@Status,@CheckNumber,@Amount,@Notes,@LastModified,@LastModifiedBy);select cast(scope_identity() as int)";

					
					if(pi.InvoicePayments.Any(ip=>mapped.InvoicePayments.All(mp => mp.Id != ip.Id)))
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
					
						
					//var dbPayrollInvoice = conn.Query<Models.DataModel.PayrollInvoice>(pisql, new { Id = mapped.Id, PayrollId = mapped.PayrollId }).First();
					//dbPayrollInvoice.InvoicePayments =
					//	conn.Query<Models.DataModel.InvoicePayment>(pipaysql, new { Id = mapped.Id }).ToList();
					return _mapper.Map<Models.DataModel.PayrollInvoice, Models.PayrollInvoice>(mapped);
				}

			}


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
				dbPayroll.TaxPayDay = date.Date;
				var dbPayChecks = dbPayroll.PayrollPayChecks.Where(pc => payChecks.Contains(pc.Id)).ToList();
				dbPayChecks.ForEach(pc => pc.TaxPayDay = date.Date);
				//var dbJournals = _dbContext.Journals.Where(j => payChecks.Contains(j.PayrollPayCheckId.Value)).ToList();
				//dbJournals.ForEach(j =>
				//{
				//	j.TransactionDate = date.Date;
				//	if (!j.OriginalDate.HasValue && DateTime.Today > originalDate)
				//	{
				//		j.OriginalDate = originalDate;
				//	}
				//});
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

		public void SavePayrollInvoiceCommission(PayrollInvoice payrollInvoice)
		{
			var dbi = _dbContext.PayrollInvoices.First(i => i.Id == payrollInvoice.Id);
			dbi.SalesRep = payrollInvoice.SalesRep;
			dbi.Commission = payrollInvoice.Commission;
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
				const string insertsql = @"insert into PayCheckDeduction (PayCheckId, EmployeeDeductionId, CompanyDeductionId, EmployeeDeductionFlat, Method, Rate, AnnualMax, Wage, Amount) values(@PayCheckId, @EmployeeDeductionId, @CompanyDeductionId, @EmployeeDeductionFlat, @Method, @Rate, @AnnualMax, @Wage, @Amount);";
				
				ptdeds.ForEach(pta =>
				{
					conn.Execute(deletesql, new { pta.PayCheckId, pta.EmployeeDeductionId, pta.CompanyDeductionId });
					conn.Execute(insertsql, new { pta.PayCheckId, pta.EmployeeDeductionId, pta.CompanyDeductionId, pta.EmployeeDeductionFlat, pta.Method, pta.Rate, pta.AnnualMax, pta.Wage, pta.Amount });
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
			const string updatepayroll = @"update Payroll set CompanyId=@CompanyId, Company=@Company, MovedFrom=@MovedFrom where Id=@Id";
			const string updatecheck = @"update PayrollPayCheck set CompanyId=@CompanyId, EmployeeId=@EmployeeId, Employee=@Employee, Deductions=@Deductions, WorkerCompensation=@WorkerCompensation, Accumulations=@Accumulations, PayCodes=@PayCodes Where Id=@Id";
			const string updatejournals = @"update journal set CompanyId=@CompanyId, JournalDetails=@JournalDetails, MainAccountId=@MainAccountId, PayeeId=@PayeeId Where Id=@Id";
			const string updateInvoices = @"update PayrollInvoice set CompanyId=@CompanyId, WorkerCompensations = @WorkerCompensations where Id=@Id";
			const string updatepayrolldate = @"update employee set LastPayrollDate=(select max(PayDay) from PayrollPayCheck where EmployeeId=Employee.Id and isvoid=0) where companyid=@CompanyId";
			const string updatesource = "update Company set LastPayrollDate=null where Id=@SourceCompanyId;update Employee set LastPayrollDate=null where CompanyId=@CompanyId";
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
				@"delete from Journal where PayrollPayCheckId in (select Id from PayrollPayCheck where CompanyId=@JCompanyId);delete from PayrollPayCheck where CompanyId=@PCompanyId;delete from Payroll where CompanyId=@PPCompanyId;";
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
	}
}
