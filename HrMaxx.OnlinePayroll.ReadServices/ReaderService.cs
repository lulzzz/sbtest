using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.ReadRepository;

namespace HrMaxx.OnlinePayroll.ReadServices
{
  public class ReaderService: BaseService, IReaderService
  {
	  private readonly IReadRepository _reader;

	  public ReaderService(IReadRepository reader)
	  {
		  _reader = reader;
	  }

	  public T GetDataFromStoredProc<T>(string proc, List<FilterParam> paramList)
	  {
		  try
		  {
			  return _reader.GetDataFromStoredProc<T>(proc, paramList);
		  }
		  catch (Exception e)
		  {
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format("Proc:{0} Params:{1}", proc, paramList.Any() ? paramList.Aggregate(string.Empty, (current, m) => current + m.Key + ":" + m.Value + ", ") : string.Empty));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
		  }
	  }

		public T GetDataFromStoredProc<T, T1>(string proc, List<FilterParam> paramList)
		{
			try
			{
				return _reader.GetDataFromStoredProc<T, T1>(proc, paramList);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format("Proc:{0} Params:{1}", proc, paramList.Any() ? paramList.Aggregate(string.Empty, (current, m) => current + m.Key + ":" + m.Value + ", ") : string.Empty));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

	  public T GetDataFromJsonStoredProc<T, T1>(string proc, List<FilterParam> paramList)
	  {
		  try
		  {
				return _reader.GetDataFromJsonStoredProc<T, T1>(proc, paramList);
		  }
		  catch (Exception e)
		  {
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format("Json Proc:{0} Params:{1}", proc, paramList.Any() ? paramList.Aggregate(string.Empty, (current, m) => current + m.Key + ":" + m.Value + ", ") : string.Empty));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
		  }
	  }

	  public List<PayrollInvoice> GetPayrollInvoices(Guid host)
	  {
		  try
		  {
				var paramList = new List<FilterParam> {new FilterParam() {Key = "host", Value = host.ToString()}};
			  return GetDataFromJsonStoredProc<List<PayrollInvoice>, List<Models.JsonDataModel.PayrollInvoiceJson>>(
				  "GetPayrollInvoices", paramList);
		  }
		  catch (Exception e)
		  {
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Payroll invoices through JSON");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
		  }
	  }

	  public List<PayrollInvoice> GetPayrollInvoicesXml(Guid host)
	  {
			try
			{
				var paramList = new List<FilterParam> { new FilterParam() { Key = "host", Value = host.ToString() } };
				return GetDataFromStoredProc<List<PayrollInvoice>, List<Models.JsonDataModel.PayrollInvoiceJson>>(
					"GetPayrollInvoicesXml", paramList);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Payroll invoices through JSON");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }
  }
}
