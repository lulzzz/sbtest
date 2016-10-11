﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Models.Enum;
using Newtonsoft.Json;
using Invoice = HrMaxx.OnlinePayroll.Models.Invoice;
using PayrollInvoice = HrMaxx.OnlinePayroll.Models.PayrollInvoice;

namespace HrMaxx.OnlinePayroll.Repository.Payroll
{
	public class PayrollRepository : IPayrollRepository
	{
		private readonly OnlinePayrollEntities _dbContext;
		private readonly IMapper _mapper;
		
		public PayrollRepository(IMapper mapper, OnlinePayrollEntities dbContext)
		{
			_dbContext = dbContext;
			_mapper = mapper;
		}

		public List<PayCheck> GetPayChecksTillPayDay(DateTime payDay)
		{
			var paychecks = _dbContext.PayrollPayChecks.Where(pc => pc.PayDay.Year == payDay.Year && pc.PayDay <= payDay && !pc.IsVoid);
			return _mapper.Map<List<Models.DataModel.PayrollPayCheck>, List<PayCheck>>(paychecks.ToList());

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

		public List<PayCheck> GetPayChecksPostPayDay(Guid companyId, DateTime payDay)
		{
			var paychecks = _dbContext.PayrollPayChecks.Where(pc => pc.CompanyId == companyId && pc.PayDay.Year == payDay.Year && pc.PayDay > payDay && !pc.IsVoid);
			return _mapper.Map<List<Models.DataModel.PayrollPayCheck>, List<PayCheck>>(paychecks.ToList());
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

		public List<Models.Payroll> GetCompanyPayrolls(Guid companyId, DateTime? startDate, DateTime? endDate)
		{
			var company = _dbContext.Companies.First(c => c.Id == companyId);
			var dbPayrolls = _dbContext.Payrolls.AsQueryable();
			if (!company.IsHostCompany)
				dbPayrolls = dbPayrolls.Where(p => p.CompanyId == companyId);
			else
			{
				var allHostCompanies = _dbContext.Companies.Where(c => c.HostId == company.HostId).Select(c => c.Id).ToList();
				dbPayrolls = dbPayrolls.Where(p => allHostCompanies.Any(c => c == p.CompanyId));
				dbPayrolls = dbPayrolls.Where(p => p.CompanyId == companyId || p.PEOASOCoCheck);
			}
			if (startDate.HasValue)
				dbPayrolls = dbPayrolls.Where(p => p.PayDay >= startDate);
			if (endDate.HasValue)
				dbPayrolls = dbPayrolls.Where(p => p.PayDay <= endDate);
			return _mapper.Map<List<Models.DataModel.Payroll>, List<Models.Payroll>>(dbPayrolls.ToList());
		}

		public List<PayCheck> GetEmployeePayChecks(Guid id, DateTime fiscalStartDate, DateTime fiscalEndDate)
		{
			var paychecks = _dbContext.PayrollPayChecks.Where(pc => pc.EmployeeId == id && pc.PayDay<=fiscalEndDate && !pc.IsVoid);
			return _mapper.Map<List<Models.DataModel.PayrollPayCheck>, List<PayCheck>>(paychecks.ToList());
		}

		public PayCheck GetPayCheckById(Guid payrollId, int payCheckId)
		{
			var paycheck = _dbContext.PayrollPayChecks.First(pc => pc.PayrollId == payrollId && pc.Id == payCheckId);
			return _mapper.Map<PayrollPayCheck, PayCheck>(paycheck);
		}

		public PayCheck VoidPayCheck(PayCheck paycheck, string name)
		{
			var pc = _dbContext.PayrollPayChecks.FirstOrDefault(p => p.Id == paycheck.Id);
			if (pc != null)
			{
				pc.IsVoid = paycheck.IsVoid;
				pc.Status = (int)paycheck.Status;
				pc.LastModified = DateTime.Now;
				pc.LastModifiedBy = name;
				_dbContext.SaveChanges();
			}
			return _mapper.Map<PayrollPayCheck, PayCheck>(pc);
		}

		public Models.Payroll GetPayrollById(Guid payrollId)
		{
			var payroll = _dbContext.Payrolls.FirstOrDefault(p => p.Id == payrollId);
			return _mapper.Map<Models.DataModel.Payroll, Models.Payroll>(payroll);
		}

		public PayCheck GetPayCheckById(int payCheckId)
		{
			var paycheck = _dbContext.PayrollPayChecks.First(p => p.Id == payCheckId);
			return _mapper.Map<PayrollPayCheck, PayCheck>(paycheck);
		}

		public List<Invoice> GetCompanyInvoices(Guid companyId)
		{
			var invoices = _dbContext.Invoices.Where(i => i.CompanyId == companyId);
			return _mapper.Map<List<Models.DataModel.Invoice>, List<Invoice>>(invoices.ToList());
		}

		public Invoice SaveInvoice(Invoice invoice)
		{
			var dbinvoice = _dbContext.Invoices.FirstOrDefault(i => i.Id == invoice.Id);
			var mapped = _mapper.Map<Invoice, Models.DataModel.Invoice>(invoice);
			if (dbinvoice == null)
			{
				_dbContext.Invoices.Add(mapped);
				
			}
			else
			{
				dbinvoice.DueDate = mapped.DueDate;
				dbinvoice.LastModifiedBy = mapped.LastModifiedBy;
				dbinvoice.LastModified = mapped.LastModified;
				dbinvoice.LineItemTotal = mapped.LineItemTotal;
				dbinvoice.Total = mapped.Total;
				dbinvoice.Balance = mapped.Balance;
				dbinvoice.LineItems = mapped.LineItems;
				dbinvoice.Payments = mapped.Payments;
				dbinvoice.InvoiceNumber = mapped.InvoiceNumber;
				dbinvoice.Status = mapped.Status;
				dbinvoice.SubmittedBy = mapped.SubmittedBy;
				dbinvoice.SubmittedOn = mapped.SubmittedOn;
				dbinvoice.DeliveredBy = mapped.DeliveredBy;
				dbinvoice.DeliveredOn = mapped.DeliveredOn;
			}
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.Invoice, Invoice>(mapped);
		}

		public Invoice GetInvoiceById(Guid invoiceId)
		{
			var invoice = _dbContext.Invoices.FirstOrDefault(i => i.Id == invoiceId);
			return _mapper.Map<Models.DataModel.Invoice, Invoice>(invoice);
		}

		public List<Models.Payroll> GetInvoicePayrolls(Guid invoiceId)
		{
			var payrolls = _dbContext.Payrolls.Where(p => p.InvoiceId == invoiceId);
			return _mapper.Map<List<Models.DataModel.Payroll>, List<Models.Payroll>>(payrolls.ToList());
		}

		public void SetPayrollInvoiceId(Invoice savedInvoice)
		{
			var dbPayrolls = _dbContext.Payrolls.Where(p => savedInvoice.PayrollIds.Any(pi => pi == p.Id)).ToList();
			dbPayrolls.ForEach(p =>
			{
				p.InvoiceId = savedInvoice.Id;
				p.Status = (int) PayrollStatus.Invoiced;
			});
			_dbContext.SaveChanges();
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
			var dbPayrollInvoice = _dbContext.PayrollInvoices.FirstOrDefault(pi => pi.Id == payrollInvoice.Id);
			var dbPayroll = _dbContext.Payrolls.First(p => p.Id == payrollInvoice.PayrollId);
			if (dbPayrollInvoice == null)
			{
				_dbContext.PayrollInvoices.Add(mapped);
				dbPayroll.InvoiceId = mapped.Id;
			}
			else
			{
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
				dbPayrollInvoice.Payrments = mapped.Payrments;
				dbPayrollInvoice.InvoiceNumber = mapped.InvoiceNumber;
				dbPayrollInvoice.Courier = mapped.Courier;
				dbPayrollInvoice.Notes = mapped.Notes;
			}
			_dbContext.SaveChanges();
			dbPayrollInvoice = _dbContext.PayrollInvoices.FirstOrDefault(pi => pi.Id == payrollInvoice.Id);
			return _mapper.Map<Models.DataModel.PayrollInvoice, Models.PayrollInvoice>(dbPayrollInvoice);
		}

		public List<PayrollInvoice> GetPayrollInvoices(Guid hostId, Guid? companyId)
		{
			var invoices = _dbContext.PayrollInvoices.Where(pi => (hostId!=Guid.Empty && pi.Company.HostId == hostId) || hostId==Guid.Empty).AsQueryable();
			if (companyId.HasValue)
				invoices = invoices.Where(pi => pi.CompanyId == companyId);
			return _mapper.Map<List<Models.DataModel.PayrollInvoice>, List<Models.PayrollInvoice>>(invoices.ToList());
		}

		public PayrollInvoice GetPayrollInvoiceById(Guid id)
		{
			var db = _dbContext.PayrollInvoices.FirstOrDefault(i => i.Id == id);
			return _mapper.Map<Models.DataModel.PayrollInvoice, Models.PayrollInvoice>(db);
		}

		public void DeletePayrollInvoice(Guid invoiceId)
		{
			var db = _dbContext.PayrollInvoices.FirstOrDefault(i => i.Id == invoiceId);
			if (db != null)
			{
				db.Payroll.InvoiceId = null;
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
				_dbContext.SaveChanges();
			}
		}
	}
}
