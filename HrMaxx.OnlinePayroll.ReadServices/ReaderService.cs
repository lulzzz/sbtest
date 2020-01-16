using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;
using HrMaxx.OnlinePayroll.ReadRepository;
using Newtonsoft.Json;
using CompanyRecurringCharge = HrMaxx.OnlinePayroll.Models.CompanyRecurringCharge;


namespace HrMaxx.OnlinePayroll.ReadServices
{
  public class ReaderService: BaseService, IReaderService
  {
	  private readonly IReadRepository _reader;
		private readonly IStagingDataService _stagingDataService;
	  private readonly IFileRepository _fileRepository;
	  public ReaderService(IReadRepository reader, IStagingDataService stagingDataService, IFileRepository fileRepository)
	  {
		  _reader = reader;
		  _stagingDataService = stagingDataService;
		  _fileRepository = fileRepository;
	  }

	  public T GetDataFromStoredProc<T>(string proc, List<FilterParam> paramList)
	  {
		  try
		  {
			  return _reader.GetDataFromStoredProc<T>(proc, paramList);
		  }
		  catch (Exception e)
		  {
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX,
                    $"Proc:{proc} Params:{(paramList.Any() ? paramList.Aggregate(string.Empty, (current, m) => current + m.Key + ":" + m.Value + ", ") : string.Empty)}");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
		  }
	  }
		public T GetDataFromStoredProc<T>(string proc, List<FilterParam> paramList, XmlRootAttribute xmlRootAttribute)
		{
			try
			{
				return _reader.GetDataFromStoredProc1<T>(proc, paramList, xmlRootAttribute);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX,
                    $"Proc:{proc} Params:{(paramList.Any() ? paramList.Aggregate(string.Empty, (current, m) => current + m.Key + ":" + m.Value + ", ") : string.Empty)}");
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
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX,
                    $"Proc:{proc} Params:{(paramList.Any() ? paramList.Aggregate(string.Empty, (current, m) => current + m.Key + ":" + m.Value + ", ") : string.Empty)}");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public T GetDataFromStoredProc<T, T1>(string proc, List<FilterParam> paramList, XmlRootAttribute xmlRootAttribute)
		{
			try
			{
				return _reader.GetDataFromStoredProc<T, T1>(proc, paramList, xmlRootAttribute);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX,
                    $"Proc:{proc} Params:{(paramList.Any() ? paramList.Aggregate(string.Empty, (current, m) => current + m.Key + ":" + m.Value + ", ") : string.Empty)}");
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
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX,
                    $"Json Proc:{proc} Params:{(paramList.Any() ? paramList.Aggregate(string.Empty, (current, m) => current + m.Key + ":" + m.Value + ", ") : string.Empty)}");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
		  }
	  }

      public List<T> GetQueryData<T>(string query)
      {
          try
          {
              return _reader.GetQueryData<T>(query);
          }
          catch (Exception e)
          {
              var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, $"Json Proc:{query} ");
              Log.Error(message, e);
              throw new HrMaxxApplicationException(message, e);
          }
        }

		public List<T1> GetQueryData<T, T1>(string query)
		{
			try
			{
				return _reader.GetQueryData<T, T1>(query);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, $"Json Proc:{query} ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<PayrollInvoiceListItem> GetPayrollInvoiceList(Guid? host = null, Guid? companyId = null, List<InvoiceStatus> status = null, DateTime? startDate = null, DateTime? endDate = null, List<PaymentStatus> paymentStatuses = null, List<InvoicePaymentMethod> paymentMethods = null,  bool includeTaxesDelayed = false)
		{
			try
			{
				var paramList = new List<FilterParam>();
				if (host.HasValue && host != Guid.Empty)
				{
					paramList.Add(new FilterParam { Key = "host", Value = host.Value.ToString() });
				}
				if (status != null && status.Any())
				{
					paramList.Add(new FilterParam { Key = "status", Value = Utilities.GetCommaSeperatedList<InvoiceStatus>(status) });
				}
				if (paymentStatuses != null && paymentStatuses.Any())
				{
					paramList.Add(new FilterParam { Key = "paymentstatus", Value = Utilities.GetCommaSeperatedList(paymentStatuses) });
				}
				if (paymentMethods != null && paymentMethods.Any())
				{
					paramList.Add(new FilterParam { Key = "paymentmethod", Value = Utilities.GetCommaSeperatedList(paymentMethods) });
				}
				if (companyId.HasValue)
				{
					paramList.Add(new FilterParam { Key = "company", Value = companyId.Value.ToString() });
				}
				if (startDate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "startdate", Value = startDate.Value.ToString("MM/dd/yyyy") });
				}
				if (endDate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "enddate", Value = endDate.Value.ToString("MM/dd/yyyy") });
				}
				if (includeTaxesDelayed)
				{
					paramList.Add(new FilterParam { Key = "includeTaxesDelayed", Value = "1" });
				}

				return GetDataFromStoredProc<List<PayrollInvoiceListItem>, List<PayrollInvoiceListItem>>(
					"GetPayrollInvoiceList", paramList, new XmlRootAttribute("PayrollInvoiceJsonList"));
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Payroll invoice list through JSON");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<PayrollInvoice> GetPayrollInvoices(Guid? host = null, Guid? companyId = null, List<InvoiceStatus> status = null, DateTime? startDate = null, DateTime? endDate = null, Guid? id = null, List<PaymentStatus> paymentStatuses = null, List<InvoicePaymentMethod> paymentMethods = null, int? invoiceNumber = null, bool byPayDay = false)
	  {
			try
			{
				var paramList = new List<FilterParam>();
				if (host.HasValue && host != Guid.Empty)
				{
					paramList.Add(new FilterParam { Key = "host", Value = host.Value.ToString() });
				}
				if (status != null && status.Any())
				{
					paramList.Add(new FilterParam { Key = "status", Value = Utilities.GetCommaSeperatedList<InvoiceStatus>(status) });
				}
				if (paymentStatuses != null && paymentStatuses.Any())
				{
					paramList.Add(new FilterParam { Key = "paymentstatus", Value = Utilities.GetCommaSeperatedList(paymentStatuses) });
				}
				if (paymentMethods != null && paymentMethods.Any())
				{
					paramList.Add(new FilterParam { Key = "paymentmethod", Value = Utilities.GetCommaSeperatedList(paymentMethods) });
				}
				if (companyId.HasValue)
				{
					paramList.Add(new FilterParam { Key = "company", Value = companyId.Value.ToString() });
				}
				if (startDate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "startdate", Value = startDate.Value.ToString("MM/dd/yyyy") });
				}
				if (endDate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "enddate", Value = endDate.Value.ToString("MM/dd/yyyy") });
				}
				if (id.HasValue)
				{
					paramList.Add(new FilterParam { Key = "id", Value = id.Value.ToString() });
				}
				if (invoiceNumber.HasValue)
				{
					paramList.Add(new FilterParam { Key = "invoicenumber", Value = invoiceNumber.Value.ToString() });
				}
				if(byPayDay)
					paramList.Add(new FilterParam { Key = "bypayday", Value = byPayDay.ToString() });

				return GetDataFromStoredProc<List<PayrollInvoice>, List<Models.JsonDataModel.PayrollInvoiceJson>>(
					"GetPayrollInvoicesXml", paramList, new XmlRootAttribute("PayrollInvoiceJsonList"));
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Payroll invoices through JSON");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

		public List<PayrollInvoice> GetCompanyInvoices(Guid companyId, List<InvoiceStatus> status = null, DateTime? startDate = null, DateTime? endDate = null, Guid? id = null)
		{
			try
			{
				var paramList = new List<FilterParam>();
				paramList.Add(new FilterParam { Key = "company", Value = companyId.ToString() });
				if (status != null && status.Any())
				{
					paramList.Add(new FilterParam { Key = "status", Value = Utilities.GetCommaSeperatedList<InvoiceStatus>(status) });
				}
				
				if (startDate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "startdate", Value = startDate.Value.ToString("MM/dd/yyyy") });
				}
				if (endDate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "enddate", Value = endDate.Value.ToString("MM/dd/yyyy") });
				}
				if (id.HasValue)
				{
					paramList.Add(new FilterParam { Key = "id", Value = id.Value.ToString() });
				}
				return GetDataFromStoredProc<List<PayrollInvoice>, List<Models.JsonDataModel.PayrollInvoiceJson>>(
					"GetCompanyInvoices", paramList, new XmlRootAttribute("PayrollInvoiceJsonList"));
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Payroll invoices through JSON");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

	  public List<InvoiceByStatus> GetCompanyPreviousInvoiceNumbers(Guid companyId)
	  {
			try
			{
				var paramList = new List<FilterParam>();
				paramList.Add(new FilterParam { Key = "company", Value = companyId.ToString() });
				
				return GetDataFromStoredProc<List<InvoiceByStatus>, List<Models.InvoiceByStatus>>(
					"GetCompanyPreviousInvoiceNumbers", paramList, new XmlRootAttribute("InvoiceStatusList"));
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Payroll invoices through JSON");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  public PayrollInvoice GetPayrollInvoice(Guid invoiceId)
	  {
			try
			{
				var paramList = new List<FilterParam> { new FilterParam() { Key = "id", Value = invoiceId.ToString() } };
				var result = GetDataFromStoredProc<List<PayrollInvoice>, List<Models.JsonDataModel.PayrollInvoiceJson>>(
					"GetPayrollInvoicesXml", paramList, new XmlRootAttribute("PayrollInvoiceJsonList"));
				return result.First();
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Payroll invoices through JSON");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  public List<ExtractInvoicePayment> GetInvoicePayments(DateTime? startDate, DateTime? endDate)
	  {
			try
			{
				var paramList = new List<FilterParam>();
				
				
				if (startDate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "startdate", Value = startDate.Value.ToString("MM/dd/yyyy") });
				}
				if (endDate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "enddate", Value = endDate.Value.ToString("MM/dd/yyyy") });
				}
				
				return GetDataFromStoredProc<List<ExtractInvoicePayment>, List<Models.JsonDataModel.ExtractInvoicePaymentJson>>(
					"GetInvoicePayments", paramList, new XmlRootAttribute("InvoicePaymentList"));
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Invoice Payments through JSON");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  public List<Payroll> GetPayrolls(Guid? companyId, DateTime? startDate = null, DateTime? endDate = null, bool includeDrafts = false, Guid? invoiceId = null, int status = 0, int excludeVoids = 0)
	  {
			try
			{

				var paramList = new List<FilterParam> ();
				if (companyId.HasValue)
				{
					paramList.Add(new FilterParam { Key = "company", Value = companyId.Value.ToString() });
				}
				if (startDate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "startdate", Value = startDate.Value.Date.ToString("MM/dd/yyyy") });
				}
				if (endDate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "enddate", Value = endDate.Value.Date.ToString("MM/dd/yyyy") });
				}

				if (invoiceId.HasValue)
				{
					paramList.Add(new FilterParam { Key = "invoice", Value = invoiceId.Value.ToString() });
				}
				if (status>0)
				{
					paramList.Add(new FilterParam { Key = "status", Value = status.ToString() });
				}
				if (excludeVoids > 0)
				{
					paramList.Add(new FilterParam { Key = "void", Value = excludeVoids.ToString() });
				}
				var payrolls = GetDataFromStoredProc<List<Payroll>, List<Models.JsonDataModel.PayrollJson>>(
					"GetPayrolls", paramList, new XmlRootAttribute("PayrollList"));
				if (includeDrafts && companyId.HasValue)
				{
					var draftPayrolls =
							_stagingDataService.GetMostRecentStagingData<PayrollStaging>(companyId.Value);
					if (draftPayrolls != null)
					{
						var p = draftPayrolls.Deserialize();
						payrolls.Add(p.Payroll);

					}
				}
				return payrolls;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Payroll list through XML");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

		public List<PayrollMinified> GetMinifiedPayrolls(Guid? companyId, DateTime? startDate = null, DateTime? endDate = null, bool includeDrafts = false, Guid? invoiceId = null, int status = 0, int excludeVoids = 0, bool? isprinted = null)
		{
			try
			{

				var paramList = new List<FilterParam>();
				if (companyId.HasValue)
				{
					paramList.Add(new FilterParam { Key = "company", Value = companyId.Value.ToString() });
				}
				if (startDate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "startdate", Value = startDate.Value.Date.ToString("MM/dd/yyyy") });
				}
				if (endDate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "enddate", Value = endDate.Value.Date.ToString("MM/dd/yyyy") });
				}

				if (invoiceId.HasValue)
				{
					paramList.Add(new FilterParam { Key = "invoice", Value = invoiceId.Value.ToString() });
				}
				if (status > 0)
				{
					paramList.Add(new FilterParam { Key = "status", Value = status.ToString() });
				}
				if (excludeVoids > 0)
				{
					paramList.Add(new FilterParam { Key = "void", Value = excludeVoids.ToString() });
				}
				if (isprinted!=null)
				{
					paramList.Add(new FilterParam { Key = "isprinted", Value = isprinted.ToString() });
				}
				var payrolls = _reader.GetDataFromStoredProc1<List<PayrollMinified>>("GetMinifiedPayrolls", paramList, new XmlRootAttribute("PayrollMinifiedList"));
				
				return payrolls;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Payroll list through XML");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

	  public Payroll GetPayroll(Guid payrollId)
	  {
			try
			{
				var paramList = new List<FilterParam> { new FilterParam() { Key = "id", Value = payrollId.ToString() } };
				var result = GetDataFromStoredProc<List<Payroll>, List<Models.JsonDataModel.PayrollJson>>(
					"GetPayrolls", paramList, new XmlRootAttribute("PayrollList"));
				return result.First();
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Payroll through XML");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  public List<PayCheck> GetPayChecks(Guid? companyId = null, Guid? employeeId = null, Guid? payrollId = null, DateTime? startDate = null,
		  DateTime? endDate = null, int status = 0, int? isvoid = null, int? year = null)
	  {
			try
			{

				var paramList = new List<FilterParam>();
				if (companyId.HasValue)
				{
					paramList.Add(new FilterParam { Key = "company", Value = companyId.Value.ToString() });
				}
				if (employeeId.HasValue)
				{
					paramList.Add(new FilterParam { Key = "employee", Value = employeeId.Value.ToString() });
				}
				if (payrollId.HasValue)
				{
					paramList.Add(new FilterParam { Key = "payroll", Value = payrollId.Value.ToString() });
				}
				if (startDate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "startdate", Value = startDate.Value.Date.ToString("MM/dd/yyyy") });
				}
				if (endDate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "enddate", Value = endDate.Value.Date.ToString("MM/dd/yyyy") });
				}

				if (status > 0)
				{
					paramList.Add(new FilterParam { Key = "status", Value = status.ToString() });
				}
				if (isvoid.HasValue)
				{
					paramList.Add(new FilterParam { Key = "void", Value = isvoid.Value.ToString() });
				}

				if (year.HasValue)
				{
					paramList.Add(new FilterParam { Key = "year", Value = year.ToString() });
				} 
				var payrolls = GetDataFromStoredProc<List<PayCheck>, List<Models.JsonDataModel.PayrollPayCheckJson>>(
					"GetPaychecks", paramList, new XmlRootAttribute("PayCheckList"));
				
				return payrolls;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Pay Check list through XML");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

		public List<VoidedPayCheckInvoiceCredit> GetCompanyPayChecksForInvoiceCredit(Guid companyId)
		{
			try
			{

				var paramList = new List<FilterParam>();
				
					paramList.Add(new FilterParam { Key = "company", Value = companyId.ToString() });
				
				var payrolls = GetDataFromStoredProc<List<VoidedPayCheckInvoiceCredit>, List<Models.JsonDataModel.VoidedPayCheckInvoiceCreditJson>>(
					"GetCompanyPaychecksForInvoiceCredit", paramList, new XmlRootAttribute("VoidedPayCheckInvoiceCreditList"));

				return payrolls;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Pay Check list through XML");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

	  public List<PayCheck> GetEmployeePayChecks(Guid employeeId)
	  {
			try
			{
				var paramList = new List<FilterParam> { new FilterParam{Key="employee", Value = employeeId.ToString()} };
				var result = GetDataFromStoredProc<List<PayCheck>, List<Models.JsonDataModel.PayrollPayCheckJson>>(
					"GetEmployeePaychecks", paramList, new XmlRootAttribute("PayCheckList"));
				return result;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Pay Check by id ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  public PayCheck GetPaycheck(int payCheckId)
	  {
			try
			{
				var paramList = new List<FilterParam> { new FilterParam() { Key = "id", Value = payCheckId.ToString() } };
				var result = GetDataFromStoredProc<List<PayCheck>, List<Models.JsonDataModel.PayrollPayCheckJson>>(
					"GetPaychecks", paramList, new XmlRootAttribute("PayCheckList"));
				return result.First();
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Pay Check by id ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

		public List<Journal> GetJournals(Guid? companyId = null, Guid? payrollId = null, int? payCheckId = null, DateTime? startDate = null,
		  DateTime? endDate = null,
			int transactionType = 0, int? isvoid = null, int? year = null, int accountId = 0, bool? PEOASOCoCheck = null, int id=0, bool includePayrolls = false, bool includeDetails = true)
	  {
			try
			{
				var paramList = new List<FilterParam>();
				if (companyId.HasValue)
				{
					paramList.Add(new FilterParam {Key = "company", Value = companyId.Value.ToString()});
				}
				if (payrollId.HasValue)
				{
					paramList.Add(new FilterParam { Key = "payrollid", Value = payrollId.Value.ToString() });
				}
				if (payCheckId.HasValue)
				{
					paramList.Add(new FilterParam {Key = "paycheck", Value = payCheckId.Value.ToString()});
				}

				if (startDate.HasValue)
				{
					paramList.Add(new FilterParam {Key = "startdate", Value = startDate.Value.Date.ToString("MM/dd/yyyy")});
				}
				if (endDate.HasValue)
				{
					paramList.Add(new FilterParam {Key = "enddate", Value = endDate.Value.Date.ToString("MM/dd/yyyy")});
				}

				if (transactionType > 0)
				{
					paramList.Add(new FilterParam {Key = "transactiontype", Value = transactionType.ToString()});
				}
				if (includePayrolls)
				{
					paramList.Add(new FilterParam { Key = "includePayrollJournals", Value = "1" });
				}
				if (!includeDetails)
				{
					paramList.Add(new FilterParam { Key = "includeDetails", Value = "0" });
				}
				if (accountId > 0)
				{
					paramList.Add(new FilterParam {Key = "accountid", Value = accountId.ToString()});
				}
				if (isvoid.HasValue)
				{
					paramList.Add(new FilterParam {Key = "void", Value = isvoid.Value.ToString()});
				}
				if (PEOASOCoCheck.HasValue)
				{
					paramList.Add(new FilterParam { Key = "PEOASOCoCheck", Value = PEOASOCoCheck.Value.ToString() });
				}

				if (year.HasValue)
				{
					paramList.Add(new FilterParam {Key = "year", Value = year.ToString()});
				}
				if (id>0)
				{
					paramList.Add(new FilterParam { Key = "id", Value = id.ToString() });
				}
				var journals = GetDataFromStoredProc<List<Journal>, List<Models.JsonDataModel.JournalJson>>(
					"GetJournals", paramList, new XmlRootAttribute("JournalList"));

				return journals;
			}

			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Journal list through XML");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  public List<int> GetJournalIds(Guid companyId, int accountId, DateTime startDate, DateTime endDate, int transactionType)
	  {
			try
			{
				var paramList = new List<FilterParam>();
				paramList.Add(new FilterParam { Key = "company", Value = companyId.ToString() });
				paramList.Add(new FilterParam { Key = "startdate", Value = startDate.Date.ToString("MM/dd/yyyy") });
				paramList.Add(new FilterParam { Key = "enddate", Value = endDate.Date.ToString("MM/dd/yyyy") });
				paramList.Add(new FilterParam { Key = "transactiontype", Value = transactionType.ToString() });
				paramList.Add(new FilterParam { Key = "accountid", Value = accountId.ToString() });
				
				var journals = GetDataFromStoredProc<List<Models.JsonDataModel.JournalJson>, List<Models.JsonDataModel.JournalJson>>(
					"GetJournalIds", paramList, new XmlRootAttribute("JournalList"));

				return journals.Select(j=>j.Id).ToList();
			}

			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Journal list through XML");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  public List<Company> GetCompanies(Guid? host = null, Guid? company = null, int? status = 1)
	  {
			try
			{
				var paramList = new List<FilterParam> ();
				if (status.HasValue && status>0)
				{
					paramList.Add(new FilterParam { Key = "status", Value = ((int)status).ToString() });
				}
				if (host.HasValue)
				{
					paramList.Add(new FilterParam { Key = "host", Value = host.Value.ToString() });
				}
				if (company.HasValue)
				{
					paramList.Add(new FilterParam { Key = "id", Value = company.Value.ToString() });
				}
				return GetDataFromStoredProc<List<Company>, List<Models.JsonDataModel.CompanyJson>>(
					"GetCompanies", paramList, new XmlRootAttribute("CompanyList"));
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Company List through XML");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  public Company GetCompany(Guid companyId)
	  {
			try
			{
				var paramList = new List<FilterParam> { new FilterParam() { Key = "id", Value = companyId.ToString() } };
				var result = GetDataFromStoredProc<List<Company>, List<Models.JsonDataModel.CompanyJson>>(
					"GetCompanies", paramList, new XmlRootAttribute("CompanyList"));
				return result.FirstOrDefault();
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Company by id ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  public List<Employee> GetEmployees(Guid? host = null, Guid? company = null, int? status = 1)
	  {
			try
			{
				var paramList = new List<FilterParam>();
				if (status.HasValue)
				{
					paramList.Add(new FilterParam { Key = "status", Value = ((int)status).ToString() });
				}
				if (host.HasValue)
				{
					paramList.Add(new FilterParam { Key = "host", Value = host.Value.ToString() });
				}
				if (company.HasValue)
				{
					paramList.Add(new FilterParam { Key = "company", Value = company.Value.ToString() });
				}
				return GetDataFromStoredProc<List<Employee>, List<Models.JsonDataModel.EmployeeJson>>(
					"GetEmployees", paramList, new XmlRootAttribute("EmployeeList"));
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Company List through XML");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  public Employee GetEmployee(Guid employeeId)
	  {
			try
			{
				var paramList = new List<FilterParam> { new FilterParam() { Key = "id", Value = employeeId.ToString() } };
				var result = GetDataFromStoredProc<List<Employee>, List<Models.JsonDataModel.EmployeeJson>>(
					"GetEmployees", paramList, new XmlRootAttribute("EmployeeList"));
				return result.FirstOrDefault();
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Employee by id ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  public List<MasterExtract> GetExtracts(string extractname = null)
	  {
			try
			{
				var paramList = new List<FilterParam>();
				if (!string.IsNullOrWhiteSpace(extractname))
				{
					paramList.Add(new FilterParam { Key = "extract", Value = extractname });
				}
				return GetDataFromStoredProc<List<MasterExtract>, List<Models.JsonDataModel.MasterExtractJson>>(
					"GetExtracts", paramList, new XmlRootAttribute("MasterExtractList"));
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Extract List through XML");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  private T GetObjectFromFile<T>(string rootdirectory, string directory, string name)
	  {
		  var data = _fileRepository.GetArchiveJson(rootdirectory, directory,  name);
		  if (string.IsNullOrWhiteSpace(data))
			  return default (T);
		  return JsonConvert.DeserializeObject<T>(data);
	  }
	  public MasterExtract GetExtract(int id)
	  {
			try
			{
				var paramList = new List<FilterParam> { new FilterParam() { Key = "id", Value = id.ToString() } };
				var result = GetDataFromStoredProc<List<MasterExtract>, List<Models.JsonDataModel.MasterExtractJson>>(
					"GetExtracts", paramList, new XmlRootAttribute("MasterExtractList")).FirstOrDefault();
				if (result != null)
				{
					result.Extract = GetObjectFromFile<Extract>(ArchiveTypes.Extract.GetDbName(), string.Empty, result.Id.ToString());
				}
				return result;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Extract by id ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  public ExtractResponse GetExtractResponse(ReportRequest request)
	  {
		  try
		  {
			  var paramList = new List<FilterParam>();
				paramList.Add(new FilterParam{Key="report", Value = request.ReportName});
				paramList.Add(new FilterParam { Key = "startDate", Value = request.StartDate.ToString("MM/dd/yyyy") });
				paramList.Add(new FilterParam { Key = "endDate", Value = request.EndDate.ToString("MM/dd/yyyy") });
				if (request.DepositSchedule != null)
				{
					paramList.Add(new FilterParam{Key="depositSchedule", Value = ((int)request.DepositSchedule).ToString()});
				}
				if (request.HostId != Guid.Empty)
				{
					paramList.Add(new FilterParam { Key = "host", Value = request.HostId.ToString() });
					
				}
				if (request.IncludeVoids)
				{
					paramList.Add(new FilterParam { Key = "includeVoids", Value = request.IncludeVoids.ToString() });
				}
				if (request.IncludeHistory)
				{
					paramList.Add(new FilterParam { Key = "includeHistory", Value = request.IncludeHistory.ToString() });
				}
			  if (request.State > 0)
			  {
					paramList.Add(new FilterParam { Key = "state", Value = request.State.ToString() });
			  }
				var dbReport = GetDataFromStoredProc<Models.ExtractResponseDB>(
					"GetExtractData", paramList);
				var returnVal = Mapper.Map<ExtractResponseDB, ExtractResponse>(dbReport);
				dbReport.Hosts.ForEach(c =>
					{
						var contact = new List<Contact>();
						//c.Contacts.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
						var returnHost = returnVal.Hosts.First(host => host.Host.Id == c.Id && host.HostCompany.Id == c.HostCompany.Id);
						if (returnHost.Host.IsPeoHost && returnHost.HostCompany.FileUnderHost)
						{
							c.Contacts.Where(ct => ct.SourceEntityId == returnHost.Host.Id)
								.ToList()
								.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
						}
						else
						{
							c.Contacts.Where(ct => ct.SourceEntityId == returnHost.HostCompany.Id)
								.ToList()
								.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
						}

						var selcontact = contact.Any(c2 => c2.IsPrimary) ? contact.First(c1 => c1.IsPrimary) : contact.FirstOrDefault();
						if (selcontact != null)
						{
							returnHost.Contact = selcontact;
						}
					});
				return returnVal;
		  }
		  catch (Exception e)
		  {
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX,
                    $"Extract Data {request.ReportName}-{request.StartDate}-{request.EndDate}-{request.DepositDate}-{request.DepositSchedule}");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
		  }
	  }
		public ExtractResponse GetExtractResponseSpecial(ReportRequest request)
		{
			try
			{
				var paramList = new List<FilterParam>();
				paramList.Add(new FilterParam { Key = "report", Value = request.ReportName });
				paramList.Add(new FilterParam { Key = "startDate", Value = request.StartDate.ToString("MM/dd/yyyy") });
				paramList.Add(new FilterParam { Key = "endDate", Value = request.EndDate.ToString("MM/dd/yyyy") });
				if (request.DepositSchedule != null)
				{
					paramList.Add(new FilterParam { Key = "depositSchedule", Value = ((int)request.DepositSchedule).ToString() });
				}
				if (request.HostId != Guid.Empty)
				{
					paramList.Add(new FilterParam { Key = "host", Value = request.HostId.ToString() });

				}
				if (request.IncludeVoids)
				{
					paramList.Add(new FilterParam { Key = "includeVoids", Value = request.IncludeVoids.ToString() });
				}
				if (request.IncludeHistory)
				{
					paramList.Add(new FilterParam { Key = "includeHistory", Value = request.IncludeHistory.ToString() });
				}
				if (request.State > 0)
				{
					paramList.Add(new FilterParam { Key = "state", Value = request.State.ToString() });
				}
				var dbReport = GetDataFromStoredProc<Models.ExtractResponseDB>(
					"GetExtractDataSpecial", paramList);
				var returnVal = Mapper.Map<ExtractResponseDB, ExtractResponse>(dbReport);
				dbReport.Hosts.ForEach(c =>
				{
					var contact = new List<Contact>();
					//c.Contacts.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
					var returnHost = returnVal.Hosts.First(host => host.Host.Id == c.Id && host.HostCompany.Id == c.HostCompany.Id);
					if (returnHost.Host.IsPeoHost && returnHost.HostCompany.FileUnderHost)
					{
						c.Contacts.Where(ct => ct.SourceEntityId == returnHost.Host.Id)
							.ToList()
							.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
					}
					else
					{
						c.Contacts.Where(ct => ct.SourceEntityId == returnHost.HostCompany.Id)
							.ToList()
							.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
					}

					var selcontact = contact.Any(c2 => c2.IsPrimary) ? contact.First(c1 => c1.IsPrimary) : contact.FirstOrDefault();
					if (selcontact != null)
					{
						returnHost.Contact = selcontact;
					}
				});
				return returnVal;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX,
                    $"Extract Data {request.ReportName}-{request.StartDate}-{request.EndDate}-{request.DepositDate}-{request.DepositSchedule}");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

	  public ExtractResponse GetExtractAccumulation(string report, DateTime startDate, DateTime endDate, Guid? hostId = null,
		  DepositSchedule941? depositSchedule941 = null, bool includeVoids = false, bool includeTaxes = false,
		  bool includedDeductions = false, bool includedCompensations = false, bool includeWorkerCompensations = false,
			bool includePayCodes = false, bool includeDailyAccumulation = false, bool includeMonthlyAccumulation = false, 
			bool includeHistory = false, bool includeC1095 = false, bool checkEFileFormsFlag = true, bool checkTaxPaymentFlag=true,
			string extractDepositName=null, int? state = null)
	  {
			try
			{
				var paramList = new List<FilterParam>();
				paramList.Add(new FilterParam { Key = "report", Value = report });
				paramList.Add(new FilterParam { Key = "startDate", Value = startDate.ToString("MM/dd/yyyy") });
				paramList.Add(new FilterParam { Key = "endDate", Value = endDate.ToString("MM/dd/yyyy") });
				if (depositSchedule941 != null)
				{
					paramList.Add(new FilterParam { Key = "depositSchedule", Value = ((int)depositSchedule941).ToString() });
				}
				if (hostId != Guid.Empty)
				{
					paramList.Add(new FilterParam { Key = "host", Value = hostId.ToString() });

				}
				if (includeVoids)
				{
					paramList.Add(new FilterParam { Key = "includeVoids", Value = includeVoids.ToString() });
				}
				if (includeTaxes)
				{
					paramList.Add(new FilterParam { Key = "includeTaxes", Value = includeTaxes.ToString() });
				}
				if (includedDeductions)
				{
					paramList.Add(new FilterParam { Key = "includeDeductions", Value = includedDeductions.ToString() });
				}
				if (includedCompensations)
				{
					paramList.Add(new FilterParam { Key = "includeCompensations", Value = includedCompensations.ToString() });
				}
				if (includeWorkerCompensations)
				{
					paramList.Add(new FilterParam { Key = "includeWorkerCompensations", Value = includeWorkerCompensations.ToString() });
				}
				if (includePayCodes)
				{
					paramList.Add(new FilterParam { Key = "includePayCodes", Value = includePayCodes.ToString() });
				}
				if (includeDailyAccumulation)
				{
					paramList.Add(new FilterParam { Key = "includeDailyAccumulation", Value = includeDailyAccumulation.ToString() });
				}
				if (includeMonthlyAccumulation)
				{
					paramList.Add(new FilterParam { Key = "includeMonthlyAccumulation", Value = includeMonthlyAccumulation.ToString() });
				}
				if (includeHistory)
				{
					paramList.Add(new FilterParam { Key = "includeHistory", Value = includeHistory.ToString() });
				}
				if (includeC1095)
				{
					paramList.Add(new FilterParam { Key = "includeC1095", Value = includeC1095.ToString() });
				}
				if (!checkEFileFormsFlag)
				{
					paramList.Add(new FilterParam { Key = "CheckEFileFormsFlag", Value = checkEFileFormsFlag.ToString() });
				}
				if (!checkTaxPaymentFlag)
				{
					paramList.Add(new FilterParam { Key = "CheckTaxPaymentFlag", Value = checkTaxPaymentFlag.ToString() });
				}
				if (!string.IsNullOrWhiteSpace(extractDepositName))
				{
					paramList.Add(new FilterParam { Key = "extractDepositName", Value = extractDepositName });
				}
				if (state.HasValue)
				{
					paramList.Add(new FilterParam { Key = "state", Value = state.ToString() });
				}
				
				var dbReport = GetDataFromStoredProc<Models.ExtractResponseDB>(
					"GetExtractAccumulation", paramList);
				var returnVal = Mapper.Map<ExtractResponseDB, ExtractResponse>(dbReport);
				dbReport.Hosts.ForEach(c =>
				{
					var contact = new List<Contact>();
					//c.Contacts.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
					var returnHost = returnVal.Hosts.First(host => host.Host.Id == c.Id && host.HostCompany.Id == c.HostCompany.Id);
					if (returnHost.Host.IsPeoHost && returnHost.HostCompany.FileUnderHost)
					{
						c.Contacts.Where(ct => ct.SourceEntityId == returnHost.Host.Id)
							.ToList()
							.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
					}
					else
					{
						c.Contacts.Where(ct => ct.SourceEntityId == returnHost.HostCompany.Id)
							.ToList()
							.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
					}

					var selcontact = contact.Any(c2 => c2.IsPrimary) ? contact.First(c1 => c1.IsPrimary) : contact.FirstOrDefault();
					if (selcontact != null)
					{
						returnHost.Contact = selcontact;
					}
				});
				return returnVal;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX,
                    $"Extract Data {report}-{startDate}-{endDate}-{depositSchedule941}");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

		public ExtractResponse GetExtractDE34(string report, DateTime startDate, DateTime endDate, Guid? hostId = null,
		 DepositSchedule941? depositSchedule941 = null, bool includeVoids = false, bool includeTaxes = false,
		 bool includedDeductions = false, bool includedCompensations = false, bool includeWorkerCompensations = false,
		 bool includePayCodes = false, bool includeDailyAccumulation = false, bool includeMonthlyAccumulation = false,
		 bool includeHistory = false, bool includeC1095 = false, bool checkEFileFormsFlag = true, bool checkTaxPaymentFlag = true,
		 string extractDepositName = null, int? state = null)
		{
			try
			{
				var paramList = new List<FilterParam>();
				paramList.Add(new FilterParam { Key = "report", Value = report });
				paramList.Add(new FilterParam { Key = "startDate", Value = startDate.ToString("MM/dd/yyyy") });
				paramList.Add(new FilterParam { Key = "endDate", Value = endDate.ToString("MM/dd/yyyy") });
				if (depositSchedule941 != null)
				{
					paramList.Add(new FilterParam { Key = "depositSchedule", Value = ((int)depositSchedule941).ToString() });
				}
				if (hostId != Guid.Empty)
				{
					paramList.Add(new FilterParam { Key = "host", Value = hostId.ToString() });

				}
				if (includeVoids)
				{
					paramList.Add(new FilterParam { Key = "includeVoids", Value = includeVoids.ToString() });
				}
				if (includeTaxes)
				{
					paramList.Add(new FilterParam { Key = "includeTaxes", Value = includeTaxes.ToString() });
				}
				if (includedDeductions)
				{
					paramList.Add(new FilterParam { Key = "includeDeductions", Value = includedDeductions.ToString() });
				}
				if (includedCompensations)
				{
					paramList.Add(new FilterParam { Key = "includeCompensations", Value = includedCompensations.ToString() });
				}
				if (includeWorkerCompensations)
				{
					paramList.Add(new FilterParam { Key = "includeWorkerCompensations", Value = includeWorkerCompensations.ToString() });
				}
				if (includePayCodes)
				{
					paramList.Add(new FilterParam { Key = "includePayCodes", Value = includePayCodes.ToString() });
				}
				if (includeDailyAccumulation)
				{
					paramList.Add(new FilterParam { Key = "includeDailyAccumulation", Value = includeDailyAccumulation.ToString() });
				}
				if (includeMonthlyAccumulation)
				{
					paramList.Add(new FilterParam { Key = "includeMonthlyAccumulation", Value = includeMonthlyAccumulation.ToString() });
				}
				if (includeHistory)
				{
					paramList.Add(new FilterParam { Key = "includeHistory", Value = includeHistory.ToString() });
				}
				if (includeC1095)
				{
					paramList.Add(new FilterParam { Key = "includeC1095", Value = includeC1095.ToString() });
				}
				if (!checkEFileFormsFlag)
				{
					paramList.Add(new FilterParam { Key = "CheckEFileFormsFlag", Value = checkEFileFormsFlag.ToString() });
				}
				if (!checkTaxPaymentFlag)
				{
					paramList.Add(new FilterParam { Key = "CheckTaxPaymentFlag", Value = checkTaxPaymentFlag.ToString() });
				}
				if (!string.IsNullOrWhiteSpace(extractDepositName))
				{
					paramList.Add(new FilterParam { Key = "extractDepositName", Value = extractDepositName });
				}
				if (state.HasValue)
				{
					paramList.Add(new FilterParam { Key = "state", Value = state.ToString() });
				}
				

				var dbReport = GetDataFromStoredProc<Models.ExtractResponseDB>(
					"GetExtractDE34", paramList);
				var returnVal = Mapper.Map<ExtractResponseDB, ExtractResponse>(dbReport);
				dbReport.Hosts.ForEach(c =>
				{
					var contact = new List<Contact>();
					//c.Contacts.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
					var returnHost = returnVal.Hosts.First(host => host.Host.Id == c.Id && host.HostCompany.Id == c.HostCompany.Id);
					if (returnHost.Host.IsPeoHost && returnHost.HostCompany.FileUnderHost)
					{
						c.Contacts.Where(ct => ct.SourceEntityId == returnHost.Host.Id)
							.ToList()
							.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
					}
					else
					{
						c.Contacts.Where(ct => ct.SourceEntityId == returnHost.HostCompany.Id)
							.ToList()
							.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
					}

					var selcontact = contact.Any(c2 => c2.IsPrimary) ? contact.First(c1 => c1.IsPrimary) : contact.FirstOrDefault();
					if (selcontact != null)
					{
						returnHost.Contact = selcontact;
					}
				});
				return returnVal;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX,
                    $"Extract Data {report}-{startDate}-{endDate}-{depositSchedule941}");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

	  public ExtractResponse GetExtractAccumulationReverse(string report, int masterExtractId, Guid? hostId = null,
		  DepositSchedule941? depositSchedule941 = null, bool includeVoids = false, bool includeTaxes = false,
		  bool includedDeductions = false, bool includedCompensations = false, bool includeWorkerCompensations = false,
		  bool includePayCodes = false, bool includeDailyAccumulation = false, bool includeMonthlyAccumulation = false,
		  bool includeHistory = false, bool includeC1095 = false, bool checkEFileFormsFlag = true,
		  bool checkTaxPaymentFlag = true, string extractDepositName = null, int? state = null)
	  {
			try
			{
				var paramList = new List<FilterParam>();
				paramList.Add(new FilterParam { Key = "report", Value = report });
				paramList.Add(new FilterParam { Key = "masterExtractId", Value = masterExtractId.ToString() });
				
				if (depositSchedule941 != null)
				{
					paramList.Add(new FilterParam { Key = "depositSchedule", Value = ((int)depositSchedule941).ToString() });
				}
				if (hostId != Guid.Empty)
				{
					paramList.Add(new FilterParam { Key = "host", Value = hostId.ToString() });

				}
				if (includeVoids)
				{
					paramList.Add(new FilterParam { Key = "includeVoids", Value = includeVoids.ToString() });
				}
				if (includeTaxes)
				{
					paramList.Add(new FilterParam { Key = "includeTaxes", Value = includeTaxes.ToString() });
				}
				if (includedDeductions)
				{
					paramList.Add(new FilterParam { Key = "includeDeductions", Value = includedDeductions.ToString() });
				}
				if (includedCompensations)
				{
					paramList.Add(new FilterParam { Key = "includeCompensations", Value = includedCompensations.ToString() });
				}
				if (includeWorkerCompensations)
				{
					paramList.Add(new FilterParam { Key = "includeWorkerCompensations", Value = includeWorkerCompensations.ToString() });
				}
				if (includePayCodes)
				{
					paramList.Add(new FilterParam { Key = "includePayCodes", Value = includePayCodes.ToString() });
				}
				if (includeDailyAccumulation)
				{
					paramList.Add(new FilterParam { Key = "includeDailyAccumulation", Value = includeDailyAccumulation.ToString() });
				}
				if (includeMonthlyAccumulation)
				{
					paramList.Add(new FilterParam { Key = "includeMonthlyAccumulation", Value = includeMonthlyAccumulation.ToString() });
				}
				if (includeHistory)
				{
					paramList.Add(new FilterParam { Key = "includeHistory", Value = includeHistory.ToString() });
				}
				if (includeC1095)
				{
					paramList.Add(new FilterParam { Key = "includeC1095", Value = includeC1095.ToString() });
				}
				if (!checkEFileFormsFlag)
				{
					paramList.Add(new FilterParam { Key = "CheckEFileFormsFlag", Value = checkEFileFormsFlag.ToString() });
				}
				if (!checkTaxPaymentFlag)
				{
					paramList.Add(new FilterParam { Key = "CheckTaxPaymentFlag", Value = checkTaxPaymentFlag.ToString() });
				}
				if (!string.IsNullOrWhiteSpace(extractDepositName))
				{
					paramList.Add(new FilterParam { Key = "extractDepositName", Value = extractDepositName });
				}
				if (state.HasValue)
				{
					paramList.Add(new FilterParam { Key = "state", Value = state.ToString() });
				}

				var dbReport = GetDataFromStoredProc<Models.ExtractResponseDB>(
					"GetExtractAccumulationReverse", paramList);
				var returnVal = Mapper.Map<ExtractResponseDB, ExtractResponse>(dbReport);
				dbReport.Hosts.ForEach(c =>
				{
					var contact = new List<Contact>();
					//c.Contacts.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
					var returnHost = returnVal.Hosts.First(host => host.Host.Id == c.Id && host.HostCompany.Id == c.HostCompany.Id);
					if (returnHost.Host.IsPeoHost && returnHost.HostCompany.FileUnderHost)
					{
						c.Contacts.Where(ct => ct.SourceEntityId == returnHost.Host.Id)
							.ToList()
							.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
					}
					else
					{
						c.Contacts.Where(ct => ct.SourceEntityId == returnHost.HostCompany.Id)
							.ToList()
							.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
					}

					var selcontact = contact.Any(c2 => c2.IsPrimary) ? contact.First(c1 => c1.IsPrimary) : contact.FirstOrDefault();
					if (selcontact != null)
					{
						returnHost.Contact = selcontact;
					}
				});
				return returnVal;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX,
                    $"Extract Data Reverse {report}-{masterExtractId}-{depositSchedule941}");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  public ExtractResponse GetTaxEligibilityAccumulation(DepositSchedule941? depositSchedule)
	  {
			try
			{
				var paramList = new List<FilterParam>();
				paramList.Add(new FilterParam { Key = "depositSchedule", Value = ((int)depositSchedule.Value).ToString() });
				
				
				var dbReport = GetDataFromStoredProc<Models.ExtractResponseDB>(
					"GetTaxEligibilityAccumulation", paramList);
				var returnVal = Mapper.Map<ExtractResponseDB, ExtractResponse>(dbReport);
				
				return returnVal;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "tax eligibility accumulations");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }


	  public List<JournalPayee> GetJournalPayees(Guid company)
	  {
			try
			{
				var paramList = new List<FilterParam>();
				
				paramList.Add(new FilterParam { Key = "company", Value = company.ToString() });
				
				return GetDataFromStoredProc<List<JournalPayee>, List<JournalPayeeJson>>("GetJournalPayees", paramList, new XmlRootAttribute("JournalPayeeList"));
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Company List through XML");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  public JournalPayee GetPayee(Guid company, Guid id, int payeeType)
	  {
			try
			{
				var paramList = new List<FilterParam>();
				paramList.Add(new FilterParam { Key = "company", Value = company.ToString() });
				paramList.Add(new FilterParam { Key = "payeeId", Value = id.ToString() });
				paramList.Add(new FilterParam { Key = "payeeType", Value = payeeType.ToString() });

				var payees = GetDataFromStoredProc<List<JournalPayee>, List<JournalPayeeJson>>("GetJournalPayees", paramList, new XmlRootAttribute("JournalPayeeList"));
				return payees.FirstOrDefault();
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Company List through XML");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  public ACHMasterExtract GetACHExtract(int id)
	  {
			try
			{
				var paramList = new List<FilterParam> { new FilterParam() { Key = "id", Value = id.ToString() } };
				var result = GetDataFromStoredProc<List<ACHMasterExtract>, List<Models.JsonDataModel.MasterExtractJson>>(
					"GetExtracts", paramList, new XmlRootAttribute("MasterExtractList")).FirstOrDefault();
				if (result != null)
				{
					result.Extract = GetObjectFromFile<ACHExtract>(ArchiveTypes.Extract.GetDbName(), string.Empty, result.Id.ToString());
				}
				return result;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Extract by id ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

		public CommissionsExtract GetCommissionsExtract(int id)
		{
			try
			{
				var paramList = new List<FilterParam> { new FilterParam() { Key = "id", Value = id.ToString() } };
				var result = GetDataFromStoredProc<List<MasterExtractJson>, List<MasterExtractJson>>(
					"GetExtracts", paramList, new XmlRootAttribute("MasterExtractList"));
				var me = result.FirstOrDefault();
				if (me != null)
				{
					return GetObjectFromFile<CommissionsExtract>(ArchiveTypes.Extract.GetDbName(), string.Empty, me.Id.ToString());
				}
					//return JsonConvert.DeserializeObject<CommissionsExtract>(me.Extract);
				return null;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Extract by id ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<Accumulation> GetAccumulations(Guid? company = null, DateTime? startdate = null, DateTime? enddate = null, string ssns=null )
	  {
			try
			{
				var proc = "GetEmployeesYTD";
				var paramList = new List<FilterParam>();
				if (company.HasValue)
				{
					paramList.Add(new FilterParam { Key = "company", Value = company.ToString() });
				}
				if (startdate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "startdate", Value = startdate.Value.ToString("MM/dd/yyyy") });
				}
				if (enddate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "enddate", Value = enddate.Value.ToString("MM/dd/yyyy") });
				}
				if (!string.IsNullOrWhiteSpace(ssns))
				{
					paramList.Add(new FilterParam { Key = "ssns", Value = ssns });
				}
			
				return GetDataFromStoredProc<List<Accumulation>, List<Accumulation>>(
					proc, paramList, new XmlRootAttribute("AccumulationList"));
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Company List through XML");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

		public List<Accumulation> GetTaxAccumulations(Guid? company = null, DateTime? startdate = null, DateTime? enddate = null, AccumulationType type = AccumulationType.Employee,
			bool includeVoids = false, bool includeTaxes = false,
			bool includedDeductions = false, bool includedCompensations = false, bool includeWorkerCompensations = false,
			bool includePayCodes = false, bool includeDailyAccumulation = false, bool includeMonthlyAccumulation = false, bool includePayTypeAccumulation = true,
			string report = null, bool includeHistory = false, bool includeC1095 = false, bool includeClients = false, bool includeTaxDelayed = false, Guid? employee = null, 
			string extractDepositName = null, bool includeClientEmployees = false, bool includeMedicareExtraWages = false, int? state = null)
		{
			try
			{
				var proc = type == AccumulationType.Employee ? "GetEmployeesAccumulation" : "GetCompanyTaxAccumulation";
				var paramList = new List<FilterParam>();
				if (company.HasValue)
				{
					paramList.Add(new FilterParam { Key = "company", Value = company.ToString() });
				}
				if (employee.HasValue && employee.Value!=Guid.Empty)
				{
					paramList.Add(new FilterParam { Key = "employee", Value = employee.ToString() });
				}
				if (startdate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "startdate", Value = startdate.Value.ToString("MM/dd/yyyy") });
				}
				if (enddate.HasValue)
				{
					paramList.Add(new FilterParam { Key = "enddate", Value = enddate.Value.ToString("MM/dd/yyyy") });
				}
				if (includeVoids)
				{
					paramList.Add(new FilterParam { Key = "includeVoids", Value = includeVoids.ToString() });
				}
				if (includeTaxes)
				{
					paramList.Add(new FilterParam { Key = "includeTaxes", Value = includeTaxes.ToString() });
				}
				if (includedDeductions)
				{
					paramList.Add(new FilterParam { Key = "includeDeductions", Value = includedDeductions.ToString() });
				}
				if (includedCompensations)
				{
					paramList.Add(new FilterParam { Key = "includeCompensations", Value = includedCompensations.ToString() });
				}
				if (includeWorkerCompensations)
				{
					paramList.Add(new FilterParam { Key = "includeWorkerCompensations", Value = includeWorkerCompensations.ToString() });
				}
				if (includePayCodes)
				{
					paramList.Add(new FilterParam { Key = "includePayCodes", Value = includePayCodes.ToString() });
				}
				if (includeDailyAccumulation)
				{
					paramList.Add(new FilterParam { Key = "includeDailyAccumulation", Value = includeDailyAccumulation.ToString() });
				}
				if (includeMonthlyAccumulation)
				{
					paramList.Add(new FilterParam { Key = "includeMonthlyAccumulation", Value = includeMonthlyAccumulation.ToString() });
				}
				if (includePayTypeAccumulation)
				{
					paramList.Add(new FilterParam { Key = "includeAccumulation", Value = includePayTypeAccumulation.ToString() });
				}
				if (!string.IsNullOrWhiteSpace(report))
				{
					paramList.Add(new FilterParam { Key = "report", Value = report });
				}
				if (includeHistory)
				{
					paramList.Add(new FilterParam { Key = "includeHistory", Value = includeHistory.ToString() });
				}
				if (includeC1095)
				{
					paramList.Add(new FilterParam { Key = "includeC1095", Value = includeC1095.ToString() });
				}
				if (includeClients)
				{
					paramList.Add(new FilterParam { Key = "includeClients", Value = includeClients.ToString() });
				}
				if (includeTaxDelayed)
				{
					paramList.Add(new FilterParam { Key = "includeTaxDelayed", Value = includeTaxDelayed.ToString() });
				}
				if (!string.IsNullOrWhiteSpace(extractDepositName))
				{
					paramList.Add(new FilterParam { Key = "extractDepositName", Value = extractDepositName });
				}
				if (includeClientEmployees)
				{
					paramList.Add(new FilterParam { Key = "includeClientEmployees", Value = includeClientEmployees.ToString() });
				}
				if (includeMedicareExtraWages)
				{
					paramList.Add(new FilterParam { Key = "includeMedicareExtraWage", Value = includeMedicareExtraWages.ToString() });
				}
				if (state.HasValue)
				{
					paramList.Add(new FilterParam { Key = "state", Value = state.ToString() });
				}
				return GetDataFromStoredProc<List<Accumulation>, List<Accumulation>>(
					proc, paramList, new XmlRootAttribute("AccumulationList"));

			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Company List through XML");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

	  public List<CompanyRecurringCharge> GetCompanyRecurringCharges(Guid id)
	  {
			try
			{
				var paramList = new List<FilterParam>();

				paramList.Add(new FilterParam { Key = "company", Value = id.ToString() });

				return GetDataFromStoredProc<List<CompanyRecurringCharge>, List<Models.JsonDataModel.CompanyRecurringCharge>>("GetCompanyRecurringCharges", paramList, new XmlRootAttribute("CompanyRecurringChargeList"));
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Company List through XML");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  public List<MinWageEligibileCompany> GetMinWageEligibilityReport(MinWageEligibilityCriteria criteria)
	  {
		  try
		  {
				var paramList = new List<FilterParam>();
				paramList.Add(new FilterParam { Key = "contractType", Value = criteria.ContractType.ToString() });
				if(criteria.MinWage.HasValue)
					paramList.Add(new FilterParam { Key = "minWage", Value = criteria.MinWage.Value.ToString() });
				paramList.Add(new FilterParam { Key = "statusId", Value = criteria.StatusId.ToString() });
				paramList.Add(new FilterParam { Key = "payrollYear", Value = criteria.PayrollYear.ToString() });
				if (!string.IsNullOrWhiteSpace(criteria.City))
					paramList.Add(new FilterParam { Key = "city", Value = criteria.City.Trim().ToLower() });

				return GetDataFromStoredProc<List<MinWageEligibileCompany>, List<MinWageEligibileCompany>>("GetMinWageEligibleCompanies", paramList, new XmlRootAttribute("MinWageEligibleCompanyList"));
		  }
		  catch (Exception e)
		  {
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " min Wage eligible comanies");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
		  }
	  }

	  public List<Accumulation> GetTaxAccumulationsBulk(string company, DateTime? startdate = null, DateTime? enddate = null, AccumulationType type = AccumulationType.Employee,
			bool includeVoids = false, bool includeTaxes = false,
			bool includedDeductions = false, bool includedCompensations = false, bool includeWorkerCompensations = false,
			bool includePayCodes = false, bool includeDailyAccumulation = false, bool includeMonthlyAccumulation = false, bool includePayTypeAccumulation = false, string report = null, bool includeHistory = false,
			bool includeC1095 = false, bool includeClients = false, bool includeTaxDelayed = false, Guid? employee = null, string extractDepositName = null, int? state=null)
	  {
			try
			{
				var proc = "GetEmployeesAccumulationBulk";
				var paramList = new List<FilterParam>();
				paramList.Add(new FilterParam { Key = "company", Value = company.ToString() });

				if (startdate.HasValue)
				{
					paramList.Add(new FilterParam {Key = "startdate", Value = startdate.Value.ToString("MM/dd/yyyy")});
				}
				if (enddate.HasValue)
				{
					paramList.Add(new FilterParam {Key = "enddate", Value = enddate.Value.ToString("MM/dd/yyyy")});
				}
				if (includeVoids)
				{
					paramList.Add(new FilterParam { Key = "includeVoids", Value = includeVoids.ToString() });
				}
				if (includeTaxes)
				{
					paramList.Add(new FilterParam { Key = "includeTaxes", Value = includeTaxes.ToString() });
				}
				if (includedDeductions)
				{
					paramList.Add(new FilterParam { Key = "includeDeductions", Value = includedDeductions.ToString() });
				}
				if (includedCompensations)
				{
					paramList.Add(new FilterParam { Key = "includeCompensations", Value = includedCompensations.ToString() });
				}
				if (includeWorkerCompensations)
				{
					paramList.Add(new FilterParam { Key = "includeWorkerCompensations", Value = includeWorkerCompensations.ToString() });
				}
				if (includePayCodes)
				{
					paramList.Add(new FilterParam { Key = "includePayCodes", Value = includePayCodes.ToString() });
				}
				if (includeDailyAccumulation)
				{
					paramList.Add(new FilterParam { Key = "includeDailyAccumulation", Value = includeDailyAccumulation.ToString() });
				}
				if (includeMonthlyAccumulation)
				{
					paramList.Add(new FilterParam { Key = "includeMonthlyAccumulation", Value = includeMonthlyAccumulation.ToString() });
				}
				if (includePayTypeAccumulation)
				{
					paramList.Add(new FilterParam { Key = "includeAccumulation", Value = includePayTypeAccumulation.ToString() });
				}
				if (!string.IsNullOrWhiteSpace(report))
				{
					paramList.Add(new FilterParam { Key = "report", Value = report });
				}
				if (includeHistory)
				{
					paramList.Add(new FilterParam { Key = "includeHistory", Value = includeHistory.ToString() });
				}
				if (includeC1095)
				{
					paramList.Add(new FilterParam { Key = "includeC1095", Value = includeC1095.ToString() });
				}
				if (includeClients)
				{
					paramList.Add(new FilterParam { Key = "includeClients", Value = includeClients.ToString() });
				}
				if (includeTaxDelayed)
				{
					paramList.Add(new FilterParam { Key = "includeTaxDelayed", Value = includeTaxDelayed.ToString() });
				}
				if (!string.IsNullOrWhiteSpace(extractDepositName))
				{
					paramList.Add(new FilterParam { Key = "extractDepositName", Value = extractDepositName });
				}
				if (state.HasValue)
				{
					paramList.Add(new FilterParam { Key = "state", Value = state.ToString() });
				}
				return GetDataFromStoredProc<List<Accumulation>, List<Accumulation>>(
					proc, paramList, new XmlRootAttribute("AccumulationList"));

			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " EMployee accumulation bulk");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }

	  public CommissionsResponse GetCommissionsExtractResponse(CommissionsReportRequest request)
	  {
			try
			{
				var paramList = new List<FilterParam>();
				if(request.UserId.HasValue)
					paramList.Add(new FilterParam { Key = "userId", Value = request.UserId.ToString() });
				if(request.StartDate.HasValue)
					paramList.Add(new FilterParam { Key = "startdate", Value = request.StartDate.Value.ToString("MM/dd/yyyy") });
				if (request.EndDate.HasValue)
					paramList.Add(new FilterParam { Key = "enddate", Value = request.EndDate.Value.ToString("MM/dd/yyyy") });
				paramList.Add(new FilterParam { Key = "includeinactive", Value = request.IncludeInactive.ToString() });

				return GetDataFromStoredProc<CommissionsResponse>(
					"GetCommissionsReport", paramList);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Extract by id ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
	  }
		
  }
}
