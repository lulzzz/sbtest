﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
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

		public List<PayrollInvoiceListItem> GetPayrollInvoiceList(Guid? host = null, Guid? companyId = null, List<InvoiceStatus> status = null, DateTime? startDate = null, DateTime? endDate = null, List<PaymentStatus> paymentStatuses = null, List<InvoicePaymentMethod> paymentMethods = null,  bool includeTaxesDelayed = false)
		{
			try
			{
				var paramList = new List<FilterParam>();
				if (host.HasValue && host != Guid.Empty)
				{
					paramList.Add(new FilterParam { Key = "host", Value = host.Value.ToString() });
				}
				if (status != null)
				{
					paramList.Add(new FilterParam { Key = "status", Value = status.Aggregate(string.Empty, (current, m) => current + (int)m + ", ") });
				}
				if (paymentStatuses != null)
				{
					paramList.Add(new FilterParam { Key = "paymentstatus", Value = paymentStatuses.Aggregate(string.Empty, (current, m) => current + (int)m + ", ") });
				}
				if (paymentMethods != null)
				{
					paramList.Add(new FilterParam { Key = "paymentmethod", Value = paymentMethods.Aggregate(string.Empty, (current, m) => current + (int)m + ", ") });
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
				if (status!=null)
				{
					paramList.Add(new FilterParam { Key = "status", Value = status.Aggregate(string.Empty, (current, m) => current + (int)m + ", ") });
				}
				if (paymentStatuses != null)
				{
					paramList.Add(new FilterParam { Key = "paymentstatus", Value = paymentStatuses.Aggregate(string.Empty, (current, m) => current + (int)m + ", ") });
				}
				if (paymentMethods != null)
				{
					paramList.Add(new FilterParam { Key = "paymentmethod", Value = paymentMethods.Aggregate(string.Empty, (current, m) => current + (int)m + ", ") });
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
				if (status != null)
				{
					paramList.Add(new FilterParam { Key = "status", Value = status.Aggregate(string.Empty, (current, m) => current + (int)m + ", ") });
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

		public List<PayrollMinified> GetMinifiedPayrolls(Guid? companyId, DateTime? startDate = null, DateTime? endDate = null, bool includeDrafts = false, Guid? invoiceId = null, int status = 0, int excludeVoids = 0)
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

		public List<PayCheck> GetCompanyPayChecksForInvoiceCredit(Guid companyId)
		{
			try
			{

				var paramList = new List<FilterParam>();
				
					paramList.Add(new FilterParam { Key = "company", Value = companyId.ToString() });
				
				var payrolls = GetDataFromStoredProc<List<PayCheck>, List<Models.JsonDataModel.PayrollPayCheckJson>>(
					"GetCompanyPaychecksForInvoiceCredit", paramList, new XmlRootAttribute("PayCheckList"));

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
							returnVal.Hosts.First(host => host.Host.Id == c.Id && host.HostCompany.Id == c.HostCompany.Id).Contact = selcontact;
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
				var dbReport = GetDataFromStoredProc<Models.ExtractResponseDB>(
					"GetExtractDataSpecial", paramList);
				var returnVal = Mapper.Map<ExtractResponseDB, ExtractResponse>(dbReport);
				dbReport.Hosts.ForEach(c =>
				{
					var contact = new List<Contact>();
					c.Contacts.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
					var selcontact = contact.Any(c2 => c2.IsPrimary) ? contact.First(c1 => c1.IsPrimary) : contact.FirstOrDefault();
					if (selcontact != null)
					{
						returnVal.Hosts.First(host => host.Host.Id == c.Id && host.HostCompany.Id == c.HostCompany.Id).Contact = selcontact;
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

	  public ExtractResponse GetExtractAccumulation(string report, DateTime startDate, DateTime endDate, Guid? hostId = null,
		  DepositSchedule941? depositSchedule941 = null, bool includeVoids = false, bool includeTaxes = false,
		  bool includedDeductions = false, bool includedCompensations = false, bool includeWorkerCompensations = false,
		  bool includePayCodes = false, bool includeDailyAccumulation = false, bool includeMonthlyAccumulation = false, bool includeHistory=false)
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
				var dbReport = GetDataFromStoredProc<Models.ExtractResponseDB>(
					"GetExtractAccumulation", paramList);
				var returnVal = Mapper.Map<ExtractResponseDB, ExtractResponse>(dbReport);
				dbReport.Hosts.OrderBy(h=>h.HostCompany.CompanyName).ToList().ForEach(c =>
				{
					var contact = new List<Contact>();
					c.Contacts.ForEach(ct => contact.Add(JsonConvert.DeserializeObject<Contact>(ct.ContactObject)));
					var selcontact = contact.Any(c2 => c2.IsPrimary) ? contact.First(c1 => c1.IsPrimary) : contact.FirstOrDefault();
					if (selcontact != null)
					{
						returnVal.Hosts.First(host => host.Host.Id == c.Id && host.HostCompany.Id==c.HostCompany.Id).Contact = selcontact;
					}
				});
				return returnVal;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format("Extract Data {0}-{1}-{2}-{3}", report, startDate, endDate, depositSchedule941));
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

		public CommissionsExtract GetCommissionsExtract(int id)
		{
			try
			{
				var paramList = new List<FilterParam> { new FilterParam() { Key = "id", Value = id.ToString() } };
				var result = GetDataFromStoredProc<List<MasterExtractJson>, List<MasterExtractJson>>(
					"GetExtracts", paramList, new XmlRootAttribute("MasterExtractList"));
				var me = result.FirstOrDefault();
				if (me != null)
					return JsonConvert.DeserializeObject<CommissionsExtract>(me.Extract);
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
			bool includeVoids = false, bool includeTaxes = true,
			bool includedDeductions = true, bool includedCompensations = true, bool includeWorkerCompensations = true,
			bool includePayCodes = true, bool includeDailyAccumulation = false, bool includeMonthlyAccumulation = false, bool includePayTypeAccumulation = true, string report = null, bool includeHistory = false, bool includeC1095 = false)
		{
			try
			{
				var proc = type == AccumulationType.Employee ? "GetEmployeesAccumulation" : "GetCompanyTaxAccumulation";
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
