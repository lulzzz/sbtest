using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Repository.Payroll;

namespace HrMaxx.OnlinePayroll.Services.ACH
{
	public class ACHService : BaseService, IACHService
	{
		private readonly IPayrollRepository _payrollRepository;
		public ACHService(IPayrollRepository payrollRepository)
		{
			_payrollRepository = payrollRepository;
		}
		public void FillACH()
		{
			try
			{
				FillACHInvoices();
				FillACHPayChecks();
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Fill ACH table");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private void FillACHPayChecks()
		{
			var achChecks = _payrollRepository.GetACHPayChecks();
			var achPayChecks = new List<ACHTransaction>();
			achChecks.ForEach(pc =>
			{
				var ach = new ACHTransaction
				{
					Id=0, Amount = pc.NetWage, SourceId = pc.Id, SourceParentId=pc.PayrollId, TransactionType = ACHTransactionType.PPD, TransactionDescription = "PAYROLL", TransactionDate = pc.PayDay, ReceiverId = pc.Employee.Id, ReceiverType = EntityTypeEnum.Employee, OriginatorType=EntityTypeEnum.Host, OriginatorId = pc.Employee.HostId, Name = pc.Employee.FullName
				};
				achPayChecks.Add(ach);
			});
			var checks = _payrollRepository.SaveACHTransactions(achPayChecks);
			Log.Info(string.Format("{0} Checks moved to ACH Transaction", checks));
		}

		private void FillACHInvoices()
		{
			var invoices = _payrollRepository.GetACHPayrollInvoices();
			var achInvoices = new List<ACHTransaction>();
			invoices.ForEach(i => i.InvoicePayments.Where(p => p.Status == PaymentStatus.Submitted && p.Method == InvoicePaymentMethod.ACH).ToList().ForEach(p =>
			{
				var ach = new ACHTransaction
				{
					Id=0, Amount = p.Amount, SourceId = p.Id, SourceParentId = i.Id, TransactionType = ACHTransactionType.CCD, TransactionDate = p.PaymentDate, TransactionDescription = "INVOICE", OriginatorType = EntityTypeEnum.Company, OriginatorId=i.CompanyId, ReceiverType = EntityTypeEnum.Host, ReceiverId = i.Company.HostId, Name = i.Company.TaxFilingName
				};
				achInvoices.Add(ach);
			}));
			var payments = _payrollRepository.SaveACHTransactions(achInvoices);
			Log.Info(string.Format("{0} Invoice Payments moved to ACH Transaction", payments));

		}
	}
}
