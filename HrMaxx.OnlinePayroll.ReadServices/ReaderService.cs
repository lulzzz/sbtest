using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.ReadRepository;
using Newtonsoft.Json;


namespace HrMaxx.OnlinePayroll.ReadServices
{
  public class ReaderService: BaseService, IReaderService
  {
	  private readonly IReadRepository _reader;
		private readonly IStagingDataService _stagingDataService;
	  public ReaderService(IReadRepository reader, IStagingDataService stagingDataService)
	  {
		  _reader = reader;
		  _stagingDataService = stagingDataService;
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

		public T GetDataFromStoredProc<T, T1>(string proc, List<FilterParam> paramList, XmlRootAttribute xmlRootAttribute)
		{
			try
			{
				return _reader.GetDataFromStoredProc<T, T1>(proc, paramList, xmlRootAttribute);
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

		//public List<PayrollInvoice> GetPayrollInvoices(Guid host)
		//{
		//	try
		//	{
		//		var paramList = new List<FilterParam> {new FilterParam() {Key = "host", Value = host.ToString()}};
		//		return GetDataFromJsonStoredProc<List<PayrollInvoice>, List<Models.JsonDataModel.PayrollInvoiceJson>>(
		//			"GetPayrollInvoices", paramList);
		//	}
		//	catch (Exception e)
		//	{
		//		var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Payroll invoices through JSON");
		//		Log.Error(message, e);
		//		throw new HrMaxxApplicationException(message, e);
		//	}
		//}

		public List<PayrollInvoice> GetPayrollInvoices(Guid host, Guid? companyId = null, InvoiceStatus status = (InvoiceStatus) 0)
	  {
			try
			{
				var paramList = new List<FilterParam> { new FilterParam() { Key = "host", Value = host.ToString() } };
				if ((int)status!=0)
				{
					paramList.Add(new FilterParam{Key="status", Value = ((int)status).ToString()});
				}
				if (companyId.HasValue)
				{
					paramList.Add(new FilterParam { Key = "company", Value = companyId.Value.ToString() });
				}
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

	  public List<Payroll> GetPayrolls(Guid? companyId, DateTime? startDate = null, DateTime? endDate = null, bool includeDrafts = false, Guid? invoiceId = null, int status = 0)
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

	  public List<Company> GetCompanies(Guid? host = null, Guid? company = null, int? status = null)
	  {
			try
			{
				var paramList = new List<FilterParam> ();
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

	  public List<Employee> GetEmployees(Guid? host = null, Guid? company = null, int? status = null)
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

	  public MasterExtract GetExtract(int id)
	  {
			try
			{
				var paramList = new List<FilterParam> { new FilterParam() { Key = "id", Value = id.ToString() } };
				var result = GetDataFromStoredProc<List<MasterExtract>, List<Models.JsonDataModel.MasterExtractJson>>(
					"GetExtracts", paramList, new XmlRootAttribute("MasterExtractList"));
				return result.FirstOrDefault();
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
				var dbReport = GetDataFromStoredProc<Models.ExtractResponseDB>(
					"GetExtractData", paramList);
				var returnVal = Mapper.Map<ExtractResponseDB, ExtractResponse>(dbReport);
				dbReport.Hosts.ForEach(c =>
					{
						var contact = new List<Contact>();
						c.Contacts.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
						var selcontact = contact.Any(c2 => c2.IsPrimary) ? contact.First(c1 => c1.IsPrimary) : contact.FirstOrDefault();
						if (selcontact != null)
						{
							returnVal.Hosts.First(host=>host.Host.Id==c.Id).Contact = selcontact;
						}
					});
				return returnVal;
		  }
		  catch (Exception e)
		  {
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format("Extract Data {0}-{1}-{2}-{3}-{4}", request.ReportName, request.StartDate, request.EndDate, request.DepositDate, request.DepositSchedule));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
		  }
	  }
  }
}
