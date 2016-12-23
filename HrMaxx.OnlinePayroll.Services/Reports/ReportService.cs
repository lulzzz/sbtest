using System;
using System.CodeDom;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Cache;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using System.Xml.Xsl;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Security;
using HrMaxx.Infrastructure.Services;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Repository;
using HrMaxx.OnlinePayroll.Repository.Companies;
using HrMaxx.OnlinePayroll.Repository.Payroll;
using HrMaxx.OnlinePayroll.Repository.Reports;

namespace HrMaxx.OnlinePayroll.Services.Reports
{
	public class ReportService : BaseService, IReportService
	{
		private readonly IReportRepository _reportRepository;
		private readonly IJournalService _journalService;
		private readonly ICompanyRepository _companyRepository ;
		private readonly IPDFService _pdfService;
		private readonly ICommonService _commonService;
		private readonly IHostService _hostService;
		private readonly ITaxationService _taxationService;
		private readonly IPayrollRepository _payrollRepository;
		private readonly IMetaDataRepository _metaDataRepository;

		private readonly string _filePath;
		private readonly string _templatePath;

		private const string NoData = "No Data exists for this time period and company";
		private const string NoPayrollData = "No Payroll Data exists for this time period and company";
		private const string ReportNotAvailable = "The report template(s) are not available yet";
		private const string HostNotSetUp = "Please set up the Host properly to proceed";
		private const string HostContactNA = "Please add at-least one contact for the Host";
		
		public IBus Bus { get; set; }

		public ReportService(IReportRepository reportRepository, ICompanyRepository companyRepository, IJournalService journalService, IPDFService pdfService, ICommonService commonService, IHostService hostService, ITaxationService taxationService, IPayrollRepository payrollRepository, IMetaDataRepository metaDataRepository, string filePath, string templatePath)
		{
			_reportRepository = reportRepository;
			_companyRepository = companyRepository;
			_journalService = journalService;
			_pdfService = pdfService;
			_filePath = filePath;
			_templatePath = templatePath;
			_commonService = commonService;
			_payrollRepository = payrollRepository;
			_metaDataRepository = metaDataRepository;
			_hostService = hostService;
			_taxationService = taxationService;
		}


		public ReportResponse GetReport(ReportRequest request)
		{
			try
			{
				if (request.ReportName.Equals("PayrollRegister"))
					return GetPayrollRegisterReport(request);
				else if (request.ReportName.Equals("PayrollSummary"))
					return GetPayrollSummaryReport(request);
				else if (request.ReportName.Equals("Deductions"))
					return GetDeductionsReport(request);
				else if (request.ReportName.Equals("WorkerCompensations"))
					return GetWorkerCompensationReport(request);
				else if (request.ReportName.Equals("IncomeStatement"))
					return GetIncomeStatementReport(request);
				else //if (request.ReportName.Equals("BalanceSheet"))
					return GetBalanceSheet(request);
			
			}
			catch (Exception e)
			{
				var message = string.Empty;
				if (e.Message == NoPayrollData || e.Message == ReportNotAvailable || e.Message == HostContactNA || e.Message == HostNotSetUp)
				{
					message = e.Message;
				}
				else
				{
					message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" Get report data for report={0} {1}-{2}", request.ReportName, request.StartDate.ToString(), request.EndDate.ToString()));
				}

				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public FileDto GetReportDocument(ReportRequest request)
		{
			try
			{
				CalculateDates(ref request);
				if (request.ReportName.Equals("Federal940"))
					return GetFederal940(request);
				else if (request.ReportName.Equals("Federal941"))
					return GetFederal941(request);
				else if (request.ReportName.Equals("Federal944"))
					return GetFederal944(request);
				else if (request.ReportName.Equals("W2Employee"))
					return GetW2Report(request, true);
				else if (request.ReportName.Equals("W2Employer"))
					return GetW2Report(request, false);
				else if (request.ReportName.Equals("W3"))
					return GetW3Report(request);
				else if (request.ReportName.Equals("Report1099"))
					return Get1099Report(request);
				else if (request.ReportName.Equals("CaliforniaDE7"))
					return GetCaliforniaDE7(request);
				else if (request.ReportName.Equals("CaliforniaDE6"))
					return GetCaliforniaDE6(request);
				else if (request.ReportName.Equals("CaliforniaDE9"))
					return GetCaliforniaDE9(request);
				else if (request.ReportName.Equals("CaliforniaDE9C"))
					return GetCaliforniaDE9C(request);

				else if (request.ReportName.Equals("QuarterAnnualReport"))
					return GetQuarterAnnualReport(request);
				else if (request.ReportName.Equals("MonthlyQuarterAnnualReport"))
					return GetMonthlyQuarterAnnualReport(request);
				else if (request.ReportName.Equals("EmployeeJournalByCheckReport"))
					return GetCaliforniaDE9(request);
				else if (request.ReportName.Equals("EmployeeHourJournalByCheck"))
					return GetCaliforniaDE9C(request);

				else if (request.ReportName.Equals("W4_1"))
					return GetW4Report(request, false);
				else if (request.ReportName.Equals("W4_2"))
					return GetW4Report(request, true);
				else if (request.ReportName.Equals("I9_1"))
					return GetI9Report(request, false);
				else if (request.ReportName.Equals("I9_2"))
					return GetI9Report(request, true);
				else if (request.ReportName.Equals("CaliforniaDE34"))
					return GetCaliforniaDE34(request);

				else if (request.ReportName.StartsWith("Federal8109B"))
					return GetFederal8109B(request);
				else if (request.ReportName.StartsWith("CaliforniaDE88"))
					return GetCaliforniaDE88(request);
				else if (request.ReportName.StartsWith("Blank_"))
					return GetBlankForms(request);
				return null;
			}
			catch (Exception e)
			{
				var message = string.Empty;
				if (e.Message == NoPayrollData || e.Message == ReportNotAvailable || e.Message == HostContactNA || e.Message==HostNotSetUp)
				{
					message = e.Message;
				}
				else if (e.Message.ToLower().StartsWith("could not find file"))
				{
					message = ReportNotAvailable;
				}
				else
				{
					message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" Get report data for report={0} {1}-{2}", request.ReportName, request.StartDate.ToString(), request.EndDate.ToString()));
				}

				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
			
		}

		public Extract GetExtractDocument(ReportRequest request)
		{
			try
			{
				CalculateDates(ref request);
				if (request.ReportName.Equals("Paperless941"))
					return GetPaperless941(request);
				else if (request.ReportName.Equals("Paperless940"))
					return GetPaperless940(request);
				else if (request.ReportName.Equals("SSAW2Magnetic"))
					return GetSSAMagnetic(request);
				else if (request.ReportName.Equals("Report1099"))
					return Get1099Extract(request);
				else if (request.ReportName.Equals("Federal940"))
					return Federal940(request);
				else if (request.ReportName.Equals("Federal940Excel"))
					return Federal940Excel(request);
				else if (request.ReportName.Equals("Federal941"))
					return Federal941(request);
				else if (request.ReportName.Equals("Federal941Excel"))
					return Federal941Excel(request);
				else if (request.ReportName.Equals("StateCAPIT"))
					return StateCAPIT(request);
				else if (request.ReportName.Equals("StateCAPITExcel"))
					return StateCAPITExcel(request);
				else if (request.ReportName.Equals("StateCAUI"))
					return StateCAUI(request);
				else if (request.ReportName.Equals("StateCAUIExcel"))
					return StateCAUIExcel(request);
				else if (request.ReportName.Equals("StateCADE6"))
					return StateCADE6(request);
				else if (request.ReportName.Equals("HostWCReport"))
					return GetHostWCReport(request);
				else if (request.ReportName.Equals("DailyDepositReport"))
					return GetDailyDepositReport(request);
				else if (request.ReportName.Equals("PositivePayReport"))
					return GetPositivePayReport(request);
				else if (request.ReportName.Equals("InternalPositivePayReport"))
					return GetInternalPositivePayReport(request);
				else if (request.ReportName.Equals("GarnishmentReport"))
					return GetGarnishmentReport(request);
				else
				{
					throw new Exception(ReportNotAvailable);
				}
			}
			catch (Exception e)
			{
				var message = string.Empty;
				if (e.Message == NoData || e.Message == NoPayrollData || e.Message == ReportNotAvailable || e.Message == HostContactNA || e.Message == HostNotSetUp)
				{
					message = e.Message;
				}
				else if (e.Message.ToLower().StartsWith("could not find file"))
				{
					message = ReportNotAvailable;
				}
				else
				{
					message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" Get report data for report={0} {1}-{2}", request.ReportName, request.StartDate.ToString(), request.EndDate.ToString()));
				}

				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private Extract GetHostWCReport(ReportRequest request)
		{
			var data = GetExtractResponse(request, buildEmployeeAccumulations: true, buildCompanyEmployeeAccumulation: true);

			request.Description = string.Format("{0} WC Report {1}-{2}", data.Hosts.First().Host.FirmName, request.StartDate.ToString("MM/dd/yyyy"), request.EndDate.ToString("MM/dd/yyyy"));
			request.AllowFiling = false;

			var argList = new XsltArgumentList();
			
			return GetExtractTransformed(request, data, argList, "transformers/extracts/HostWCReport.xslt", "xls", request.Description + ".xls");
		}

		private Extract GetDailyDepositReport(ReportRequest request)
		{
			request.EndDate = request.StartDate.AddHours(24);
			var invoices = _payrollRepository.GetPayrollInvoices(Guid.Empty, null);
			var invoicePayments = invoices.SelectMany(i => i.InvoicePayments.Select(p => new ExtractInvoicePayment
			{
				CompanyId = i.CompanyId, PaymentDate = p.PaymentDate, Amount = p.Amount, CheckNumber = p.CheckNumber, Method = p.Method, Status = p.Status
			})).ToList();
			var filtered =
				invoicePayments.Where(p => p.PaymentDate >= request.StartDate && p.PaymentDate <= request.EndDate).ToList();
			if (!filtered.Any())
				throw new Exception(NoData);
			var hosts = _hostService.GetHostList(Guid.Empty);
			var companies = _companyRepository.GetAllCompanies();
			var hostList = new List<ExtractHost>();
			var companyList = new List<ExtractCompany>();
			filtered.ForEach(j =>
			{
				if (companyList.All(c => c.Company.Id != j.CompanyId))
				{
					var company = companies.First(c => c.Id == j.CompanyId);
					companyList.Add(new ExtractCompany()
					{
						Company = company
					});
					
				}
			});
			companyList.ForEach(c =>
			{
				c.Payments =
					filtered.Where(i => i.CompanyId == c.Company.Id)
						.ToList();
				if (hostList.All(h => h.Host.Id != c.Company.HostId))
				{
					var host = hosts.First(h => h.Id == c.Company.HostId);
					hostList.Add(new ExtractHost()
					{
						Host = host,
						HostCompany = host.Company,
						Companies = companyList.Where(c1=>c1.Company.HostId==host.Id).ToList()
					});
				}
			});
			var data = new ExtractResponse()
			{
				Hosts = hostList,
				History = new List<MasterExtract>()
			};

			request.Description = string.Format("Daily Deposit Report {0}-{1}", request.StartDate.ToString("MM/dd/yyyy"), request.EndDate.ToString("MM/dd/yyyy"));
			request.AllowFiling = false;

			var argList = new XsltArgumentList();
			argList.AddParam("today", "", request.StartDate.ToString("MM/dd/yyyy"));
			return GetExtractTransformed(request, data, argList, "transformers/extracts/DailyDepositReport.xslt", "xls", request.Description + ".xls");
		}

		private Extract GetInternalPositivePayReport(ReportRequest request)
		{
			request.IncludeVoids = true;
			var data = GetExtractResponse(request);

			request.Description = string.Format("{0} Internal Positive Pay Report {1}", data.Hosts.First().Host.FirmName, request.StartDate.ToString("MMddyyyy"));
			request.AllowFiling = false;

			var argList = new XsltArgumentList();

			return GetExtractTransformed(request, data, argList, "transformers/extracts/InternalPositivePayReport.xslt", "xls", request.Description + ".xls");
		}
		private Extract GetGarnishmentReport(ReportRequest request)
		{
			var data = GetExtractResponse(request, buildGarnishments:true);
			if (!data.Hosts.Any(h => h.Accumulation.GarnishmentAgencies.Any()))
			{
				throw new Exception(NoData);
			}
			data.Hosts = data.Hosts.Where(h => h.Accumulation.GarnishmentAgencies.Any()).ToList();
			request.Description = string.Format("Garnishment Report {0} - {1}", request.StartDate.ToString("MMddyyyy"), request.EndDate.ToString("MMddyyyy"));
			request.AllowFiling = true;

			var argList = new XsltArgumentList();

			return GetExtractTransformed(request, data, argList, "transformers/extracts/GarnishmentReport.xslt", "xls", request.Description + ".xls");
		}

		public Extract GetPositivePayReport(ReportRequest request)
		{
			var host = _hostService.GetHost(request.HostId);
			var accounts = _companyRepository.GetCompanyAccounts(host.Company.Id);
			var journals = _journalService.GetJournalListByDate(host.CompanyId, request.StartDate.Date,
				request.EndDate.Date);
			journals =
				journals.Where(
					j =>
						(j.TransactionType == TransactionType.PayCheck || j.TransactionType == TransactionType.RegularCheck) &&
						j.PaymentMethod == EmployeePaymentMethod.Check).ToList();
			if(!journals.Any())
				throw  new Exception(NoData);
			var data = new ExtractResponse()
			{
				Hosts = new List<ExtractHost>()
				{
					new ExtractHost()
					{
						Host = host,
						HostCompany = host.Company,
						Journals = journals, 
						Accounts = accounts
					}
				},
				History = new List<MasterExtract>()
			};
			
			request.Description = string.Format("{0} Positive Pay Report {1}", data.Hosts.First().Host.FirmName,  request.StartDate.ToString("MMddyyyy"));
			request.AllowFiling = false;

			var argList = new XsltArgumentList();

			return GetExtractTransformed(request, data, argList, "transformers/extracts/PositivePayReport.xslt", "txt", request.Description + ".txt");
		}

		private ExtractResponse GetExtractResponse(ReportRequest request, bool buildEmployeeAccumulations = false, bool buildCounts = false, bool buildDaily  =false, bool buildCompanyEmployeeAccumulation = false, bool getCompanyDeposits = false, bool buildGarnishments = false)
		{
			var data = _reportRepository.GetExtractReport(request);

			if (request.ReportName.Contains("1099"))
			{
				if (request.ReportName.Contains("1099") && data.Hosts.All(h => h.Companies.All(c => !c.Vendors.Any(v => v.Amount > 0))))
				{

					throw new Exception(NoPayrollData);
				}
				else
				{
					data.Hosts = data.Hosts.Where(h => h.Companies.Any(c => c.Vendors.Any(v => v.Amount > 0))).ToList();
				}
				
			}
			else 
			{
				if (data.Hosts.All(h => h.Companies.All(c => !c.PayChecks.Any() && !c.VoidedPayChecks.Any())))
				{
					throw new Exception(NoPayrollData);
				}
				else
				{
					data.Hosts = data.Hosts.Where(h => h.Companies.Any(c => c.PayChecks.Any() || c.VoidedPayChecks.Any())).ToList();
				}
			}
			var garnishmentAgencies = new List<VendorCustomer>();
			if (buildGarnishments)
				garnishmentAgencies = _metaDataRepository.GetGarnishmentAgencies();
			data.Hosts.ForEach(h =>
			{
				if (!request.ReportName.Contains("1099"))
				{
					h.Companies = h.Companies.Where(c => c.PayChecks.Any() || c.VoidedPayChecks.Any()).ToList();
					h.Accumulation = new ExtractAccumulation() { ExtractType = request.ExtractType };
					var payChecks = h.Companies.SelectMany(c => c.PayChecks).ToList();
					var voidedPayChecks = h.Companies.SelectMany(c => c.PayChecks).ToList();
					h.Accumulation.AddPayChecks(payChecks);
					h.Accumulation.CreditPayChecks(voidedPayChecks);
					h.Accumulation.SetQuarters();

					if (buildEmployeeAccumulations)
						h.EmployeeAccumulations = getEmployeeAccumulations(payChecks);
					if (buildCounts)
						h.Accumulation.SetCounts(request.Year, request.Quarter);
					if (buildDaily)
						h.Accumulation.BuildDailyAccumulations(request.Quarter);
					if(buildGarnishments)
						h.Accumulation.BuildGarnishmentAccumulations(garnishmentAgencies);

					h.Companies.ForEach(c =>
					{
						c.Accumulation = new ExtractAccumulation() { ExtractType = request.ExtractType };
						c.Accumulation.AddPayChecks(c.PayChecks);
						c.Accumulation.CreditPayChecks(c.VoidedPayChecks);
						if (buildCompanyEmployeeAccumulation)
							c.EmployeeAccumulations = getEmployeeAccumulations(c.Accumulation.PayChecks);
						
					});
				}
				else
				{
					h.Companies = h.Companies.Where(c => c.Vendors.Any(v => v.Amount > 0)).ToList();
					h.Companies.ForEach(c =>
					{
						c.VendorAccumulation = new VendorAccumulation();
						c.VendorAccumulation.Add(c.Vendors);
					});
					h.VendorAccumulation = new VendorAccumulation();
					h.VendorAccumulation.Add(h.Companies.SelectMany(c => c.Vendors).ToList());
				}	
			
			});
			
			return data;
		}
		private Extract Federal940(ReportRequest request)
		{
			request.Description = string.Format("Federal 940 EFTPS for {0} (Schedule={1})", request.Year, request.DepositSchedule);
			request.AllowFiling = true;
			var tempDepositSchedule = request.DepositSchedule;
			request.DepositSchedule = null;
			var data = GetExtractResponse(request);
			request.DepositSchedule = tempDepositSchedule;
			var reportConst = _taxationService.PullReportConstant("Form940", (int)request.DepositSchedule.Value);
			var config = _taxationService.GetApplicationConfig();
			var argList = new XsltArgumentList();
			argList.AddParam("batchFilerId", "", config.BatchFilerId);
			argList.AddParam("masterPinNumber", "", config.MasterInquiryPin);
			argList.AddParam("fileSeq", "", reportConst);
			argList.AddParam("today", "", DateTime.Today.ToString("yyyyMMdd"));
			argList.AddParam("settleDate", "", request.DepositDate.Value.Date.ToString("yyyyMMdd"));
			argList.AddParam("selectedYear", "", request.Year);

			return GetExtractTransformed(request, data, argList, "transformers/extracts/Federal940EFTPS.xslt", "txt", string.Format("Federal {2} 940 Extract-{0}-{1}.txt", request.Year, request.Quarter, request.DepositSchedule));
		}

		private Extract Federal940Excel(ReportRequest request)
		{
			request.ReportName = "Federal940";
			request.Description = string.Format("Federal 940 EFTPS Excel for {0} (Schedule={1})", request.Year, request.DepositSchedule);
			request.AllowFiling = false;
			var data = GetExtractResponse(request);

			var reportConst = _taxationService.PullReportConstant("Form940", (int)request.DepositSchedule.Value);
			var config = _taxationService.GetApplicationConfig();
			var argList = new XsltArgumentList();
			argList.AddParam("batchFilerId", "", config.BatchFilerId);
			argList.AddParam("masterPinNumber", "", config.MasterInquiryPin);
			argList.AddParam("fileSeq", "", reportConst);
			argList.AddParam("today", "", DateTime.Today.ToString("yyyyMMdd"));
			argList.AddParam("settleDate", "", request.DepositDate.Value.Date.ToString("yyyyMMdd"));
			argList.AddParam("selectedYear", "", request.Year);

			return GetExtractTransformed(request, data, argList, "transformers/extracts/Federal940EFTPSExcel.xslt", "xls", string.Format("Federal {2} 940 Excel Extract-{0}-{1}.xls", request.Year, request.Quarter, request.DepositSchedule));
		}
		private Extract Federal941(ReportRequest request)
		{
			request.Description = string.Format("Federal 941 EFTPS for {0} (Schedule={1})", request.Year, request.DepositSchedule);
			request.AllowFiling = true;
			var data = GetExtractResponse(request);
			
			var reportConst = _taxationService.PullReportConstant("Form941", (int)request.DepositSchedule.Value);
			var config = _taxationService.GetApplicationConfig();
			var argList = new XsltArgumentList();
			argList.AddParam("batchFilerId", "", config.BatchFilerId);
			argList.AddParam("masterPinNumber", "", config.MasterInquiryPin);
			argList.AddParam("fileSeq", "", reportConst);
			argList.AddParam("today", "", DateTime.Today.ToString("yyyyMMdd"));
			argList.AddParam("settleDate", "", request.DepositDate.Value.Date.ToString("yyyyMMdd"));
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("endQuarterMonth", "", request.EndDate.Month);

			return GetExtractTransformed(request, data, argList, "transformers/extracts/Federal941EFTPS.xslt", "txt", string.Format("Federal {2} 941 Extract-{0}-{1}.txt", request.Year, request.Quarter, request.DepositSchedule.Value.ToString()));
		}

		private Extract Federal941Excel(ReportRequest request)
		{
			request.ReportName = "Federal941";
			request.Description = string.Format("Federal 941 EFTPS Excel for {0} (Schedule={1})", request.Year, request.DepositSchedule);
			request.AllowFiling = false;
			
			var data = GetExtractResponse(request);

			var reportConst = _taxationService.PullReportConstant("Form941", (int)request.DepositSchedule.Value);
			var config = _taxationService.GetApplicationConfig();
			var argList = new XsltArgumentList();
			argList.AddParam("batchFilerId", "", config.BatchFilerId);
			argList.AddParam("masterPinNumber", "", config.MasterInquiryPin);
			argList.AddParam("fileSeq", "", reportConst);
			argList.AddParam("today", "", DateTime.Today.ToString("yyyyMMdd"));
			argList.AddParam("settleDate", "", request.DepositDate.Value.Date.ToString("yyyyMMdd"));
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("endQuarterMonth", "", request.EndDate.Month);

			return GetExtractTransformed(request, data, argList, "transformers/extracts/Federal941EFTPSExcel.xslt", "xls", string.Format("Federal {2} 941 Excel Extract-{0}-{1}.xls", request.Year, request.Quarter, request.DepositSchedule.Value.ToString()));
		}
		private Extract StateCAPIT(ReportRequest request)
		{
			request.Description = string.Format("California State PIT & SDI for {0} (Quarter={1})", request.Year, request.Quarter);
			request.AllowFiling = true;
			var data = GetExtractResponse(request);
			
			var argList = new XsltArgumentList();
		
			argList.AddParam("reportConst", "", request.DepositSchedule == DepositSchedule941.SemiWeekly ? "01100" : request.DepositSchedule == DepositSchedule941.Monthly ? "01101" : "01104");
			argList.AddParam("enddate", "",request.EndDate.ToString("MM/dd/yyyy"));
			argList.AddParam("settleDate", "", request.DepositDate.Value.Date.ToString("MM/dd/yyyy"));
			argList.AddParam("selectedYear", "", request.Year);
			

			return GetExtractTransformed(request, data, argList, "transformers/extracts/CAPITEFTPS.xslt", "txt", string.Format("California State {2} PIT & DI GovOne File-{0}-{1}.txt", request.Year, request.Quarter, request.DepositSchedule.Value.ToString()));
		}
		private Extract StateCAPITExcel(ReportRequest request)
		{
			request.ReportName = "StateCAPIT";
			request.Description = string.Format("California State PIT & SDI Excel for {0} (Quarter={1})", request.Year, request.Quarter);
			request.AllowFiling = true;
			var data = GetExtractResponse(request);

			var argList = new XsltArgumentList();

			argList.AddParam("reportConst", "", request.DepositSchedule == DepositSchedule941.SemiWeekly ? "01100" : request.DepositSchedule == DepositSchedule941.Monthly ? "01101" : "01104");
			argList.AddParam("enddate", "", request.EndDate.ToString("MM/dd/yyyy"));
			argList.AddParam("settleDate", "", request.DepositDate.Value.Date.ToString("MM/dd/yyyy"));
			argList.AddParam("selectedYear", "", request.Year);


			return GetExtractTransformed(request, data, argList, "transformers/extracts/CAPITEFTPSExcel.xslt", "xls", string.Format("California State {2} PIT & DI Excel File-{0}-{1}.xls", request.Year, request.Quarter, request.DepositSchedule.Value.ToString()));
		}

		private Extract StateCAUI(ReportRequest request)
		{
			request.Description = string.Format("California State UI & ETT for {0} (Sechedule={1})", request.Year, request.DepositSchedule);
			request.AllowFiling = true;
			var tempDepositSchedule = request.DepositSchedule;
			request.DepositSchedule = null;
			var data = GetExtractResponse(request);
			request.DepositSchedule = tempDepositSchedule;
			var argList = new XsltArgumentList();

			argList.AddParam("reportConst", "", "01300");
			argList.AddParam("enddate", "", request.EndDate.ToString("MM/dd/yyyy"));
			argList.AddParam("settleDate", "", request.DepositDate.Value.Date.ToString("MM/dd/yyyy"));
			argList.AddParam("selectedYear", "", request.Year);


			return GetExtractTransformed(request, data, argList, "transformers/extracts/CAUIETTEFTPS.xslt", "txt", string.Format("California State {2} UI & ETT GovOne File-{0}-{1}.txt", request.Year, request.Quarter, request.DepositSchedule));
		}
		private Extract StateCAUIExcel(ReportRequest request)
		{
			request.ReportName = "StateCAUI";
			request.Description = string.Format("California State UI & ETT Excel for {0} (Sechedule={1})", request.Year, request.DepositSchedule);
			request.AllowFiling = true;
			var data = GetExtractResponse(request);

			var argList = new XsltArgumentList();

			argList.AddParam("reportConst", "", "01300");
			argList.AddParam("enddate", "", request.EndDate.ToString("MM/dd/yyyy"));
			argList.AddParam("settleDate", "", request.DepositDate.Value.Date.ToString("MM/dd/yyyy"));
			argList.AddParam("selectedYear", "", request.Year);


			return GetExtractTransformed(request, data, argList, "transformers/extracts/CAUIETTEFTPSExcel.xslt", "xls", string.Format("California State {2} UI & ETT Excel File-{0}-{1}.xls", request.Year, request.Quarter, request.DepositSchedule));
		}
		private Extract StateCADE6(ReportRequest request)
		{
			request.Description = string.Format("California State DE6 for {0} (Quarter={1})", request.Year, request.Quarter);
			request.AllowFiling = true;
			var data = GetExtractResponse(request, true);
			
			var argList = new XsltArgumentList();

			argList.AddParam("endQuarterMonth", "", request.EndDate.Month);
			argList.AddParam("selectedYear", "", request.Year);


			return GetExtractTransformed(request, data, argList, "transformers/extracts/DE6Transformer.xslt", "txt", string.Format("California State Quarterly DE 6 Reporting File-{0}-{1}.txt", request.Year, request.Quarter));
		}

		private Extract Get1099Extract(ReportRequest request)
		{
			request.Description = string.Format("Megnatic 1099 for {0}", request.Year);
			request.AllowFiling = false;
			var data = GetExtractResponse(request);
			var config = _taxationService.GetApplicationConfig();
			var argList = new XsltArgumentList();
			argList.AddParam("currentYear", "", DateTime.Today.Year);
			argList.AddParam("tcc", "", config.TCC);
			argList.AddParam("MagFileUserId", "", config.SsaBsoW2MagneticFileId);
			argList.AddParam("selectedYear", "", request.Year);

			return GetExtractTransformed(request, data, argList, "transformers/extracts/F1099-" + request.Year + ".xslt", "txt", string.Format("Federal/State Form 1099 Magnetic File -{0}.txt", request.Year));

		}

		private Extract GetPaperless940(ReportRequest request)
		{
			request.Description = string.Format("Paperless 940 for {0}", request.Year);
			request.AllowFiling = false;
			var data = GetExtractResponse(request);
			
			var argList = new XsltArgumentList();
			argList.AddParam("quarter", "", request.Quarter);
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			argList.AddParam("startdate", "", request.StartDate.ToString("MM/dd/yyyy"));
			argList.AddParam("enddate", "", request.EndDate.ToString("MM/dd/yyyy"));

			return GetExtractTransformed(request, data, argList, "transformers/extracts/Paperless940-" + request.Year + ".xslt", "xls", string.Format("Paperless Extract 940-{0}.xls", request.Year));
			
		}

		private Extract GetPaperless941(ReportRequest request)
		{
			request.Description = string.Format("Paperless 941 for {0} (Quarter={1})", request.Year, request.Quarter);
			request.AllowFiling = false;
			var data = GetExtractResponse(request, buildCounts:true, buildDaily:true);
			
			var argList = new XsltArgumentList();
			argList.AddParam("quarter", "", request.Quarter);
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			argList.AddParam("startdate", "", request.StartDate.ToString("MM/dd/yyyy"));
			argList.AddParam("enddate", "", request.EndDate.ToString("MM/dd/yyyy"));


			return
					GetExtractTransformed(request, data, argList, "transformers/extracts/Paperless941-" + request.Year + ".xslt", "xls",
						string.Format("Paperless Extract 941-{0}-{1}.xls", request.Year, request.Quarter));
		}
		private Extract GetSSAMagnetic(ReportRequest request)
		{
			request.Description = string.Format("SSA W2 Megnatic for {0} ", request.Year);
			request.AllowFiling = false;
			var data = GetExtractResponse(request, buildEmployeeAccumulations:true);
			
			var config = _taxationService.GetApplicationConfig();
			var argList = new XsltArgumentList();
			argList.AddParam("MagFileUserId", "", config.BatchFilerId);
			argList.AddParam("selectedYear", "", request.Year);
			
			return GetExtractTransformed(request, data, argList, "transformers/extracts/SSAW2-" + request.Year + ".xslt", "txt", string.Format("Federal SSA W2 Magentic-{0}.txt", request.Year));
			
		}
		private Extract GetExtractTransformed(ReportRequest request, ExtractResponse data, XsltArgumentList argList, string template, string extension, string filename)
		{
			var xml = GetXml<ExtractResponse>(data);

			var transformed = XmlTransform(xml,
				string.Format("{0}{1}", _templatePath, template), argList);

			if (extension.Equals("txt"))
				transformed = Transform(transformed);

			return new Extract()
			{
				Report = request,
				Data = data,
				File = new FileDto
				{
					Data = Encoding.UTF8.GetBytes(transformed),
					DocumentExtension = extension,
					Filename = filename,
					MimeType = "application/octet-stream"	
				}
			};
		}

		public FileDto PrintPayrollSummary(Models.Payroll payroll )
		{
			var fileName = string.Format("Payroll_{0}_{1}.pdf", payroll.Id, payroll.PayDay.ToString("MMddyyyy"));
			var xml = GetXml<Models.Payroll>(payroll);
		
			var args = new XsltArgumentList();
				
			var transformed = TransformXml(xml,
				string.Format("{0}{1}", _templatePath, "transformers/payroll/payrollsummary.xslt"), args);

			var summary = _pdfService.PrintHtml(transformed.Reports.First());
			return _pdfService.AppendAllDocuments(payroll.Id, fileName, new List<Guid>(), summary.Data);
		}

		public DashboardData GetDashboardData(DashboardRequest dashboardRequest)
		{
			try
			{
				return _reportRepository.GetDashboardData(dashboardRequest);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX,
					"Dashboard for report " + dashboardRequest.Report);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<MasterExtract> GetExtractList(string report)
		{
			try
			{
				return _reportRepository.GetExtractList(report);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX,
					"Extract List for report " + report);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<SearchResult> GetSearchResults(string criteria, string role, Guid host, Guid company)
		{
			try
			{
				return _reportRepository.GetSearchResults(criteria, role, host, company).Results;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX,
					"get search results for " + criteria);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public ACHExtract GetACHReport(ReportRequest request)
		{
			try
			{
				var data = _reportRepository.GetACHReport(request);
				if(data.Hosts.All(h=>!h.ACHTransactions.Any()))
					throw new Exception(NoData);
				data.Hosts.ForEach(h =>
				{
					if (h.HostBank != null)
					{
						h.HostBank.AccountNumber = Crypto.Decrypt(h.HostBank.AccountNumber);
						h.HostBank.RoutingNumber = Crypto.Decrypt(h.HostBank.RoutingNumber);
						h.HostBank.RoutingNumber1 = Convert.ToInt32(h.HostBank.RoutingNumber.Substring(0, 8));
					}
					if (h.ACHTransactions != null)
						h.ACHTransactions.ForEach(t =>
						{
							if (t.CompanyBankAccount != null)
							{
								t.CompanyBankAccount.AccountNumber = Crypto.Decrypt(t.CompanyBankAccount.AccountNumber);
								t.CompanyBankAccount.RoutingNumber = Crypto.Decrypt(t.CompanyBankAccount.RoutingNumber);
								t.CompanyBankAccount.RoutingNumber1 = Convert.ToInt32(t.CompanyBankAccount.RoutingNumber.Substring(0, 8));
							}
							if (t.EmployeeBankAccounts != null && t.EmployeeBankAccounts.Any())
							{
								t.EmployeeBankAccounts.ForEach(eb =>
								{
									eb.BankAccount.AccountNumber = Crypto.Decrypt(eb.BankAccount.AccountNumber);
									eb.BankAccount.RoutingNumber = Crypto.Decrypt(eb.BankAccount.RoutingNumber);
									eb.BankAccount.RoutingNumber1 = Convert.ToInt32(eb.BankAccount.RoutingNumber.Substring(0, 8));
								});
							}
						});
				});
				return new ACHExtract
				{
					Report = request, Data = data
				};
			}
			catch (Exception e)
			{
				var message = string.Empty;
				if (e.Message == NoData || e.Message == NoPayrollData || e.Message == ReportNotAvailable || e.Message == HostContactNA || e.Message == HostNotSetUp)
				{
					message = e.Message;
				}
				else if (e.Message.ToLower().StartsWith("could not find file"))
				{
					message = ReportNotAvailable;
				}
				else
				{
					message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" Get ACH report data for {0} {1}", request.StartDate.ToString(), request.EndDate.ToString()));
				}

				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
			
		}

		public ACHExtract GetACHExtract(ACHExtract extract, string fullName)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					extract.Data.Hosts.ForEach(h =>
					{
						h.ACHTransactions = h.ACHTransactions.Where(t => t.Included).ToList();
					});
					if (extract.Data.Hosts.All(h => !h.ACHTransactions.Any()))
					{
						throw new Exception(NoData);
					}
					var xml = GetXml<ACHResponse>(extract.Data);
					var args = new XsltArgumentList();
					args.AddParam("time", "", DateTime.Now.ToString("HHmm"));
					args.AddParam("today", "", DateTime.Today.ToString("yyMMdd"));
					args.AddParam("postingDate", "", extract.Report.DepositDate.Value.ToString("yyMMdd"));
					var transformed = XmlTransform(xml,
						string.Format("{0}{1}", _templatePath, "transformers/extracts/CBT-ACHTransformer.xslt"), args);

					transformed = Transform(transformed);

					extract.File = new FileDto
					{
						Data = Encoding.UTF8.GetBytes(transformed),
						DocumentExtension = ".txt",
						Filename = string.Format("CBT-ACH-Extract-{0}.txt", DateTime.Now.ToString("MM/dd/yyyy")),
						MimeType = "application/octet-stream"
					};
					_reportRepository.SaveACHExtract(extract, fullName);
					txn.Complete();
					return extract;
				}
			}
			catch (Exception e)
			{
				var message = string.Empty;
				if (e.Message == NoData || e.Message == NoPayrollData || e.Message == ReportNotAvailable || e.Message == HostContactNA || e.Message == HostNotSetUp)
				{
					message = e.Message;
				}
				else if (e.Message.ToLower().StartsWith("could not find file"))
				{
					message = ReportNotAvailable;
				}
				else
				{
					message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" Get ACH report data for {0} {1}", extract.Report.StartDate.ToString(), extract.Report.EndDate.ToString()));
				}

				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
			
		}

		public List<ACHMasterExtract> GetACHExtractList()
		{
			try
			{
				return _reportRepository.GetACHExtractList();
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" Get ACH extract list for "));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public FileDto PrintPayrollWithoutSummary(Models.Payroll payroll, List<Guid> documents)
		{
			var fileName = string.Format("Payroll_Checks_{0}_{1}.pdf", payroll.Id, payroll.PayDay.ToString("MMddyyyy"));
			
			return _pdfService.AppendAllDocuments(payroll.Id, fileName, documents, new byte[0]);
		}


		private ReportResponse GetIncomeStatementReport(ReportRequest request)
		{

			var coas = _journalService.GetCompanyAccountsWithJournalsForTypes(request.CompanyId, request.StartDate,
				request.EndDate, new List<AccountType> {AccountType.Income, AccountType.Expense});

			return GetAccountJournalReport(coas);
		}

		private ReportResponse GetBalanceSheet(ReportRequest request)
		{

			var coas = _journalService.GetCompanyAccountsWithJournalsForTypes(request.CompanyId, null,
				new DateTime(DateTime.Now.Year, 12, 31), new List<AccountType> {AccountType.Assets, AccountType.Liability});
			var coasall = _journalService.GetCompanyAccountsWithJournalsForTypes(request.CompanyId, null,
				new DateTime(DateTime.Now.Year, 12, 31), new List<AccountType> { AccountType.Income, AccountType.Expense });
			var coasty = _journalService.GetCompanyAccountsWithJournalsForTypes(request.CompanyId, new DateTime(DateTime.Now.Year, 1, 1),
				new DateTime(DateTime.Now.Year, 12, 31), new List<AccountType> { AccountType.Income, AccountType.Expense });

			var allIncome = coasall.Where(c => c.Type == AccountType.Income).Sum(c => c.AccountBalance);
			var thisyearIncome = coasty.Where(c => c.Type == AccountType.Income).Sum(c => c.AccountBalance);
			var allExpense = coasall.Where(c => c.Type == AccountType.Expense).Sum(c => c.AccountBalance);
			

			var thisyearExpense = coasty.Where(c => c.Type == AccountType.Expense).Sum(c => c.AccountBalance);


			var thisyearequity = Math.Round(thisyearIncome - thisyearExpense, 2, MidpointRounding.AwayFromZero);
			var previousyearequity = Math.Round(allIncome - allExpense - thisyearequity, 2, MidpointRounding.AwayFromZero);
			var equity = new CoaTypeBalanceDetail
			{
				Type = AccountType.Equity,
				SubTypeDetails = new List<CoaSubTypeBalanceDetail>()
			};
			var retainedearningsubtype = new CoaSubTypeBalanceDetail
			{
				SubType = AccountSubType.RetainedEarnings,
				AccountDetails = new List<CoaBalanceDetail>()
			};
			var rteAccount = new CoaBalanceDetail
			{
				Name = "Retained Earnings for Previous Years (system managed)	",
				Balance = previousyearequity
			};

			var currentNetIncome = new CoaSubTypeBalanceDetail
			{
				SubType = AccountSubType.OtherIncome,
				AccountDetails = new List<CoaBalanceDetail>()
			};
			var cnetincome = new CoaBalanceDetail
			{
				Name = "Current Net Income",
				Balance = thisyearequity
			};
			retainedearningsubtype.AccountDetails.Add(rteAccount);
			currentNetIncome.AccountDetails.Add(cnetincome);
			equity.SubTypeDetails.Add(retainedearningsubtype);
			equity.SubTypeDetails.Add(currentNetIncome);
			
			var returnVal = GetAccountJournalReport(coas);
			returnVal.AccountDetails.Add(equity);

			return returnVal;

		}

		private ReportResponse GetAccountJournalReport(IEnumerable<AccountWithJournal> coas)
		{
			var test =
				coas.GroupBy(c => c.Type)
					.Select(
						c =>
							new CoaTypeBalanceDetail
							{
								Type = c.Key,
								SubTypeDetails =
									c.ToList()
										.GroupBy(s => s.SubType)
										.Select(
											st =>
												new CoaSubTypeBalanceDetail
												{
													SubType = st.Key,
													AccountDetails =
														st.ToList()
															.Select(
																ac =>
																	new CoaBalanceDetail
																	{
																		Name = ac.AccountName,
																		Balance = ac.AccountBalance
																	}).ToList().Where(a => a.Balance !=0).ToList()
												}).ToList().Where(st => st.AccountDetails.Any()).ToList()
							}).ToList();
			

			var response = new ReportResponse
			{
				AccountDetails = test
			};
			return response;
		}

		private ReportResponse GetWorkerCompensationReport(ReportRequest request)
		{
			var response = new ReportResponse
			{
				Company = _companyRepository.GetCompanyById(request.CompanyId),
				EmployeeAccumulations = _reportRepository.GetEmployeeGroupedChecks(request, false),
				CompanyAccumulation = new PayrollAccumulation()
			};
			response.EmployeeAccumulations.Where(ea => ea.Accumulation.EmployeeWorkerCompensations > 0).ToList().ForEach(ea => response.CompanyAccumulation.Add(ea.Accumulation));

			return response;
		}

		private ReportResponse GetDeductionsReport(ReportRequest request)
		{
			var response = new ReportResponse();
			response.Company = _companyRepository.GetCompanyById(request.CompanyId);
			response.EmployeeAccumulations = _reportRepository.GetEmployeeGroupedChecks(request, false);
			response.CompanyAccumulation = new PayrollAccumulation();
			response.EmployeeAccumulations.Where(ea=>ea.Accumulation.EmployeeDeductions>0).ToList().ForEach(ea => response.CompanyAccumulation.Add(ea.Accumulation));
			
			return response;
		}

		private ReportResponse GetPayrollSummaryReport(ReportRequest request)
		{
			var response = new ReportResponse();
			var cubes = GetCompanyPayrollCubes(request);
			response.CompanyAccumulation = cubes.First(c => ((request.Quarter > 0 && request.Quarter == c.Quarter) || (request.Quarter == 0 && !c.Quarter.HasValue))).Accumulation;
			response.EmployeeAccumulations = getEmployeeAccumulations(response.CompanyAccumulation.PayChecks);
			response.Company = GetCompany(request.CompanyId);
			return response;
		}

		private List<EmployeeAccumulation> getEmployeeAccumulations(List<PayCheck> paychecks)
		{
			var result = new List<EmployeeAccumulation>();
			var empchecks = paychecks.GroupBy(p => p.Employee.Id).ToList();
			foreach (var group in empchecks)
			{
				var ea = new EmployeeAccumulation
				{
					PayChecks = group.ToList(),
					Accumulation = new PayrollAccumulation()
				};
				ea.Accumulation.AddPayChecks(ea.PayChecks);
				ea.Employee = ea.PayChecks.OrderByDescending(p=>p.LastModified).First().Employee;
				result.Add(ea);
			}
			return result;
		} 

		private ReportResponse GetPayrollRegisterReport(ReportRequest request)
		{
			var response = new ReportResponse();
			response.PayChecks = _reportRepository.GetReportPayChecks(request, true);
			return response;

		}

		private FileDto GetFederal940(ReportRequest request)
		{
			var response = new ReportResponse();
			var cubes = GetCompanyPayrollCubes(request);
			response.CompanyAccumulation = cubes.First(c => !c.Quarter.HasValue && !c.Month.HasValue).Accumulation;
			response.Host = GetHost(request.HostId);
			response.Company = GetCompany(request.CompanyId);
			response.Contact = getContactForEntity(EntityTypeEnum.Host, request.HostId, response.Host.CompanyId);
			response.CompanyContact = getContactForEntity(EntityTypeEnum.Company, request.CompanyId);
				
			var argList = new XsltArgumentList();
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			argList.AddParam("firstQuarter", "", cubes.Any(c=>c.Quarter==1) ? cubes.First(c=>c.Quarter==1).Accumulation.Taxes.Where(t=>t.Tax.Code.Equals("FUTA")).Sum(t=>t.Amount) : 0);
			argList.AddParam("secondQuarter", "", cubes.Any(c => c.Quarter == 2) ? cubes.First(c => c.Quarter == 2).Accumulation.Taxes.Where(t => t.Tax.Code.Equals("FUTA")).Sum(t => t.Amount) : 0);
			argList.AddParam("thirdQuarter", "", cubes.Any(c => c.Quarter == 3) ? cubes.First(c => c.Quarter == 3).Accumulation.Taxes.Where(t => t.Tax.Code.Equals("FUTA")).Sum(t => t.Amount) : 0);
			argList.AddParam("fourthQuarter", "", cubes.Any(c => c.Quarter == 4) ? cubes.First(c => c.Quarter == 4).Accumulation.Taxes.Where(t => t.Tax.Code.Equals("FUTA")).Sum(t => t.Amount) : 0);
			argList.AddParam("immigrantsIncluded", "", response.CompanyAccumulation.PayChecks.Any(pc => pc.Employee.TaxCategory == EmployeeTaxCategory.NonImmigrantAlien && pc.GrossWage > 0));
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/940/Fed940-" + request.Year + ".xslt");
			
		}
		private FileDto GetFederal941(ReportRequest request)
		{
			var response = new ReportResponse();
			var cubes = GetCompanyPayrollCubes(request);
			response.CompanyAccumulation = cubes.First(c => c.Quarter.HasValue && c.Quarter==request.Quarter && !c.Month.HasValue).Accumulation;
			response.CompanyAccumulation.BuildDailyAccumulations(request.Quarter);
			response.Host = GetHost(request.HostId);
			response.Company = GetCompany(request.CompanyId);
			response.Contact = getContactForEntity(EntityTypeEnum.Host, request.HostId);
			response.CompanyContact = getContactForEntity(EntityTypeEnum.Company, request.CompanyId);

			var argList = new XsltArgumentList();
			argList.AddParam("quarter", "", request.Quarter);
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			argList.AddParam("month1", "", cubes.Any(c => c.Month == (request.Quarter * 3 - 2)) ? cubes.First(c => c.Month == (request.Quarter * 3 - 2)).Accumulation.Taxes.Where(t => !t.Tax.StateId.HasValue && t.Tax.Id!=6).Sum(t => t.Amount) : 0);
			argList.AddParam("month2", "", cubes.Any(c => c.Month == (request.Quarter * 3 - 1)) ? cubes.First(c => c.Month == (request.Quarter * 3 - 1)).Accumulation.Taxes.Where(t => !t.Tax.StateId.HasValue && t.Tax.Id!=6).Sum(t => t.Amount) : 0);
			argList.AddParam("month3", "", cubes.Any(c => c.Month == (request.Quarter * 3)) ? cubes.First(c => c.Month == (request.Quarter * 3)).Accumulation.Taxes.Where(t => !t.Tax.StateId.HasValue && t.Tax.Id!=6).Sum(t => t.Amount) : 0);

			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/941/Fed941-" + request.Year + ".xslt");

		}

		private FileDto GetFederal944(ReportRequest request)
		{
			var response = new ReportResponse();
			var cubes = GetCompanyPayrollCubes(request);
			response.CompanyAccumulation = cubes.First(c => !c.Quarter.HasValue && !c.Month.HasValue).Accumulation;
			response.CompanyAccumulation.BuildDailyAccumulations(0);
			response.Host = GetHost(request.HostId);
			response.Company = GetCompany(request.CompanyId);
			response.Contact = getContactForEntity(EntityTypeEnum.Host, request.HostId);
			response.CompanyContact = getContactForEntity(EntityTypeEnum.Company, request.CompanyId);

			var argList = new XsltArgumentList();
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			argList.AddParam("month1", "", cubes.Any(c => c.Month == 1) ? cubes.First(c => c.Month == 1).Accumulation.Taxes.Where(t => !t.Tax.StateId.HasValue && t.Tax.Id != 6).Sum(t => t.Amount) : 0);
			argList.AddParam("month2", "", cubes.Any(c => c.Month == 2) ? cubes.First(c => c.Month == 2).Accumulation.Taxes.Where(t => !t.Tax.StateId.HasValue && t.Tax.Id != 6).Sum(t => t.Amount) : 0);
			argList.AddParam("month3", "", cubes.Any(c => c.Month == 3) ? cubes.First(c => c.Month == 3).Accumulation.Taxes.Where(t => !t.Tax.StateId.HasValue && t.Tax.Id != 6).Sum(t => t.Amount) : 0);
			argList.AddParam("month4", "", cubes.Any(c => c.Month == 4) ? cubes.First(c => c.Month == 4).Accumulation.Taxes.Where(t => !t.Tax.StateId.HasValue && t.Tax.Id != 6).Sum(t => t.Amount) : 0);
			argList.AddParam("month5", "", cubes.Any(c => c.Month == 5) ? cubes.First(c => c.Month == 5).Accumulation.Taxes.Where(t => !t.Tax.StateId.HasValue && t.Tax.Id != 6).Sum(t => t.Amount) : 0);
			argList.AddParam("month6", "", cubes.Any(c => c.Month == 6) ? cubes.First(c => c.Month == 6).Accumulation.Taxes.Where(t => !t.Tax.StateId.HasValue && t.Tax.Id != 6).Sum(t => t.Amount) : 0);
			argList.AddParam("month7", "", cubes.Any(c => c.Month == 7) ? cubes.First(c => c.Month == 7).Accumulation.Taxes.Where(t => !t.Tax.StateId.HasValue && t.Tax.Id != 6).Sum(t => t.Amount) : 0);
			argList.AddParam("month8", "", cubes.Any(c => c.Month == 8) ? cubes.First(c => c.Month == 8).Accumulation.Taxes.Where(t => !t.Tax.StateId.HasValue && t.Tax.Id != 6).Sum(t => t.Amount) : 0);
			argList.AddParam("month9", "", cubes.Any(c => c.Month == 9) ? cubes.First(c => c.Month == 9).Accumulation.Taxes.Where(t => !t.Tax.StateId.HasValue && t.Tax.Id != 6).Sum(t => t.Amount) : 0);
			argList.AddParam("month10", "", cubes.Any(c => c.Month == 10) ? cubes.First(c => c.Month == 10).Accumulation.Taxes.Where(t => !t.Tax.StateId.HasValue && t.Tax.Id != 6).Sum(t => t.Amount) : 0);
			argList.AddParam("month11", "", cubes.Any(c => c.Month == 11) ? cubes.First(c => c.Month == 11).Accumulation.Taxes.Where(t => !t.Tax.StateId.HasValue && t.Tax.Id != 6).Sum(t => t.Amount) : 0);
			argList.AddParam("month12", "", cubes.Any(c => c.Month == 12) ? cubes.First(c => c.Month == 12).Accumulation.Taxes.Where(t => !t.Tax.StateId.HasValue && t.Tax.Id != 6).Sum(t => t.Amount) : 0);
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/944/Fed944-" + request.Year + ".xslt");

		}

		private FileDto GetW2Report(ReportRequest request, bool isEmployee)
		{
			var response = new ReportResponse();
			var cubes = GetCompanyPayrollCubes(request);
			var yearCube = cubes.First(c => !c.Quarter.HasValue && !c.Month.HasValue).Accumulation;
			response.EmployeeAccumulations = getEmployeeAccumulations(yearCube.PayChecks);
			response.Company = GetCompany(request.CompanyId);
			

			var argList = new XsltArgumentList();
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/W2/W2-" + (isEmployee? string.Empty : "Employer-") + request.Year + ".xslt");

		}

		private FileDto GetW3Report(ReportRequest request)
		{
			var response = new ReportResponse();
			var cubes = GetCompanyPayrollCubes(request);
			response.CompanyAccumulation = cubes.First(c => !c.Quarter.HasValue && !c.Month.HasValue).Accumulation;
			response.Company = GetCompany(request.CompanyId);


			var argList = new XsltArgumentList();
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			argList.AddParam("c", "", response.CompanyAccumulation.PayChecks.Select(p=>p.Employee.Id).Distinct().Count());
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/W3/W3-" + request.Year + ".xslt");

		}

		private FileDto GetW4Report(ReportRequest request, bool isEmployeeFilled)
		{
			if (!isEmployeeFilled)
				return _pdfService.GetTemplateFile("GovtForms\\EmployerForms\\fw4", DateTime.Now.Year, "W4");
			var response = new ReportResponse();
			response.Company = GetCompany(request.CompanyId);
			response.Employees = _companyRepository.GetEmployeeList(request.CompanyId).Where(e => e.StatusId == StatusOption.Active).ToList();
			if (!response.Employees.Any())
				throw new Exception(NoData);


			var argList = new XsltArgumentList();
			
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/employer/FedW4.xslt");

		}

		private FileDto GetBlankForms(ReportRequest request)
		{
			var report = request.ReportName.Split('_')[1];
			return _pdfService.GetTemplateFile("GovtForms\\BlankForms\\" + report, DateTime.Now.Year, report);
			
		}
		private FileDto GetFederal8109B(ReportRequest request)
		{
			var response = new ReportResponse();
			response.Company = GetCompany(request.CompanyId);
			var paychecks = _reportRepository.GetReportPayChecks(request, false);
			var type = Convert.ToInt32(request.ReportName.Split('_')[1]);
			var total = type == 1
				? paychecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Id == 6)).Sum(t => t.Amount)
				: paychecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Id < 6)).Sum(t => t.Amount);
			var totalstr = total.ToString("000000000.00").Replace(".", string.Empty);
			var argList = new XsltArgumentList();
			argList.AddParam("type", "", type);
			argList.AddParam("month", "", request.EndDate.Month);
			argList.AddParam("total", "", totalstr);
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/depositcoupons/Fed8109B.xslt");

		}
		private FileDto GetI9Report(ReportRequest request, bool isEmployeeFilled)
		{
			if (!isEmployeeFilled)
				return _pdfService.GetTemplateFile("GovtForms\\EmployerForms\\I9", DateTime.Now.Year, "I9");
			var response = new ReportResponse();
			response.Company = GetCompany(request.CompanyId);
			response.Employees = _companyRepository.GetEmployeeList(request.CompanyId).Where(e => e.StatusId == StatusOption.Active).ToList();
			if(!response.Employees.Any())
				throw new Exception(NoData);

			var argList = new XsltArgumentList();

			return GetReportTransformedAndPrinted(request, response, argList, "transformers/employer/FedI9.xslt");

		}

		private FileDto Get1099Report(ReportRequest request)
		{
			var response = new ReportResponse();
			response.Company = GetCompany(request.CompanyId);
			response.CompanyContact = getContactForEntity(EntityTypeEnum.Company, request.CompanyId);
			var vendors = _companyRepository.GetVendorCustomers(request.CompanyId, true);
			var journals = _journalService.GetJournalList(request.CompanyId,
				new DateTime(request.Year, 1, 1).Date, new DateTime(request.Year, 12, 31));
			response.VendorList = vendors.Where(v => v.IsVendor && v.IsVendor1099).Select(v => new CompanyVendor
			{
				Vendor = v,
				Amount = Math.Round(journals.Where(j=>j.PayeeId==v.Id).Sum(j=>j.Amount),2,MidpointRounding.AwayFromZero)

			}).Where(cv=>cv.Amount>0).ToList();
			if (!response.VendorList.Any())
			{
				throw new Exception(NoPayrollData);
			}

			var argList = new XsltArgumentList();
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/1099/F1099.xslt");

		}
		private FileDto GetCaliforniaDE7(ReportRequest request)
		{
			var response = new ReportResponse();
			var cubes = GetCompanyPayrollCubes(request);
			response.CompanyAccumulation = cubes.First(c => !c.Quarter.HasValue && !c.Month.HasValue).Accumulation;
			response.Company = GetCompany(request.CompanyId);
			var argList = new XsltArgumentList();
			
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/CAForms/DE7.xslt");

		}
		private FileDto GetCaliforniaDE6(ReportRequest request)
		{
			var response = new ReportResponse();
			var cubes = GetCompanyPayrollCubes(request);
			response.CompanyAccumulation = cubes.First(c => c.Quarter.HasValue && c.Quarter==request.Quarter && !c.Month.HasValue).Accumulation;
			response.EmployeeAccumulations = getEmployeeAccumulations(response.CompanyAccumulation.PayChecks);
			response.Company = GetCompany(request.CompanyId); 
			response.Host = GetHost(request.HostId);
			response.Contact = getContactForEntity(EntityTypeEnum.Host, request.HostId);

			var twelve1 = new DateTime(request.Year, request.Quarter*3 - 2, 12);
			var twelve2 = new DateTime(request.Year, request.Quarter * 3 - 1, 12);
			var twelve3 = new DateTime(request.Year, request.Quarter * 3 , 12);
			var quarterEndDate = new DateTime(request.Year, request.Quarter*3,
				DateTime.DaysInMonth(request.Year, request.Quarter*3));
			var dueDate = quarterEndDate.AddDays(1);
			var argList = new XsltArgumentList();

			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			argList.AddParam("quarter", "", request.Quarter);
			argList.AddParam("quarterEndDate", "", quarterEndDate.ToString("MM/dd/yyyy"));
			argList.AddParam("dueDate", "", dueDate.ToString("MM/dd/yyyy"));
			argList.AddParam("count1", "", response.CompanyAccumulation.PayChecks.Where(pc=>pc.StartDate<=twelve1 && pc.EndDate>=twelve1).Select(pc=>pc.Employee.Id).Distinct().Count());
			argList.AddParam("count2", "", response.CompanyAccumulation.PayChecks.Where(pc => pc.StartDate <= twelve2 && pc.EndDate >= twelve2).Select(pc => pc.Employee.Id).Distinct().Count());
			argList.AddParam("count3", "", response.CompanyAccumulation.PayChecks.Where(pc => pc.StartDate <= twelve3 && pc.EndDate >= twelve3).Select(pc => pc.Employee.Id).Distinct().Count());

			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/CAForms/DE6.xslt");

		}
		private FileDto GetCaliforniaDE9(ReportRequest request)
		{
			var response = new ReportResponse();
			var cubes = GetCompanyPayrollCubes(request);
			response.CompanyAccumulation = cubes.First(c => c.Quarter.HasValue && c.Quarter==request.Quarter && !c.Month.HasValue).Accumulation;
			response.Company = GetCompany(request.CompanyId);

			var quarterEndDate = new DateTime(request.Year, request.Quarter * 3,
				DateTime.DaysInMonth(request.Year, request.Quarter * 3));
			var dueDate = quarterEndDate.AddDays(1);
			var dueDate2 = quarterEndDate.AddMonths(1);
			var argList = new XsltArgumentList();

			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			argList.AddParam("quarter", "", request.Quarter);
			argList.AddParam("quarterEndDate", "", quarterEndDate.ToString("MM/dd/yyyy"));
			argList.AddParam("dueDate", "", dueDate.ToString("MM/dd/yyyy"));
			argList.AddParam("dueDate2", "", dueDate2.ToString("MM/dd/yyyy"));

			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/CAForms/DE9.xslt");

		}
		private FileDto GetCaliforniaDE9C(ReportRequest request)
		{
			var response = new ReportResponse();
			var cubes = GetCompanyPayrollCubes(request);
			response.CompanyAccumulation = cubes.First(c => c.Quarter.HasValue && c.Quarter == request.Quarter && !c.Month.HasValue).Accumulation;
			response.EmployeeAccumulations = getEmployeeAccumulations(response.CompanyAccumulation.PayChecks);
			response.Company = GetCompany(request.CompanyId);
			response.Host = GetHost(request.HostId);
			response.Contact = getContactForEntity(EntityTypeEnum.Host, request.HostId);

			var twelve1 = new DateTime(request.Year, request.Quarter * 3 - 2, 12);
			var twelve2 = new DateTime(request.Year, request.Quarter * 3 - 1, 12);
			var twelve3 = new DateTime(request.Year, request.Quarter * 3, 12);
			var quarterEndDate = new DateTime(request.Year, request.Quarter * 3,
				DateTime.DaysInMonth(request.Year, request.Quarter * 3));
			var dueDate = quarterEndDate.AddDays(1);
			var argList = new XsltArgumentList();

			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			argList.AddParam("quarter", "", request.Quarter);
			argList.AddParam("quarterEndDate", "", quarterEndDate.ToString("MM/dd/yyyy"));
			argList.AddParam("dueDate", "", dueDate.ToString("MM/dd/yyyy"));
			argList.AddParam("count1", "", response.CompanyAccumulation.PayChecks.Where(pc => pc.StartDate <= twelve1 && pc.EndDate >= twelve1).Select(pc => pc.Employee.Id).Distinct().Count());
			argList.AddParam("count2", "", response.CompanyAccumulation.PayChecks.Where(pc => pc.StartDate <= twelve2 && pc.EndDate >= twelve2).Select(pc => pc.Employee.Id).Distinct().Count());
			argList.AddParam("count3", "", response.CompanyAccumulation.PayChecks.Where(pc => pc.StartDate <= twelve3 && pc.EndDate >= twelve3).Select(pc => pc.Employee.Id).Distinct().Count());

			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/CAForms/DE9C.xslt");

		}

		private FileDto GetCaliforniaDE34(ReportRequest request)
		{
			var response = new ReportResponse();
			response.Company = GetCompany(request.CompanyId);
			var emps = _companyRepository.GetEmployeeList(request.CompanyId);
			response.Employees = emps.Where(e=>e.StatusId==StatusOption.Active && e.HireDate>=request.StartDate ).ToList();
			if(!response.Employees.Any())
				throw new Exception(NoData);
			var argList = new XsltArgumentList();

			return GetReportTransformedAndPrinted(request, response, argList, "transformers/employer/CADE34.xslt");

		}
		private FileDto GetCaliforniaDE88(ReportRequest request)
		{
			var response = new ReportResponse();
			response.Company = GetCompany(request.CompanyId);
			var paychecks = _reportRepository.GetReportPayChecks(request, false);
			response.PayChecks = paychecks;
			var type = Convert.ToInt32(request.ReportName.Split('_')[1]);
			var total = type == 1
				? paychecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Id > 6 && t.Tax.Id < 11)).Sum(t => t.Amount)
				: type == 2
					? paychecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Id == 9 || t.Tax.Id == 10)).Sum(t => t.Amount)
					: paychecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Id == 7 || t.Tax.Id == 8)).Sum(t => t.Amount);
			var totalstr = Math.Round(total,2, MidpointRounding.AwayFromZero).ToString("00000000.00").Replace(".", string.Empty);
			var argList = new XsltArgumentList();
			argList.AddParam("type", "", type);
			argList.AddParam("month", "", request.EndDate.Month);
			argList.AddParam("enddatestr", "", request.EndDate.ToString("MMddyy"));
			argList.AddParam("total", "", totalstr);
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/depositcoupons/CADE88.xslt");

		}


		private FileDto GetQuarterAnnualReport(ReportRequest request)
		{
			var response = new ReportResponse();
			var cubes = GetCompanyPayrollCubes(request);
			response.CompanyAccumulation = cubes.First(c => !c.Quarter.HasValue && !c.Month.HasValue).Accumulation;
			response.Cubes = cubes.Where(c => c.Quarter.HasValue || c.Month.HasValue).ToList();
			response.Company = GetCompany(request.CompanyId);

			var argList = new XsltArgumentList();
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			
			
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/other/quarterannualtaxsummary.xslt");

		}
		private FileDto GetMonthlyQuarterAnnualReport(ReportRequest request)
		{
			var response = new ReportResponse();
			var cubes = GetCompanyPayrollCubes(request);
			response.CompanyAccumulation = cubes.First(c => !c.Quarter.HasValue && !c.Month.HasValue).Accumulation;
			response.Cubes = cubes.Where(c => c.Quarter.HasValue || c.Month.HasValue).ToList();
			response.Company = GetCompany(request.CompanyId);

			var argList = new XsltArgumentList();
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));


			return GetReportTransformedAndPrinted(request, response, argList, "transformers/other/monthlyquarterannualtaxsummary.xslt");

		}


		private Company GetCompany(Guid companyId)
		{
			return _companyRepository.GetCompanyById(companyId);
		}

		private Models.Host GetHost(Guid hostId)
		{
			var host = _hostService.GetHost(hostId);
			if(host==null || host.Company==null || string.IsNullOrWhiteSpace(host.PTIN) || string.IsNullOrWhiteSpace(host.DesigneeName940941) || string.IsNullOrWhiteSpace(host.PIN940941))
				throw new Exception(HostNotSetUp);
			return host;
		}

		private Contact getContactForEntity(EntityTypeEnum source, Guid sourceId, Guid? hostCompanyId = null)
		{
			var contacts = _commonService.GetRelatedEntities<Contact>(source, EntityTypeEnum.Contact,
					sourceId);
			if (contacts.Any(c => c.IsPrimary))
			{
				return contacts.First(c => c.IsPrimary);
			}
			else
			{
				var contact = contacts.FirstOrDefault();
				if (contact==null && source == EntityTypeEnum.Host)
				{
					if (!hostCompanyId.HasValue)
					{
						throw new Exception(HostContactNA);	
					}
					contact = getContactForEntity(EntityTypeEnum.Company, hostCompanyId.Value);
					if(contact==null)
						throw new Exception(HostContactNA);
				}
					
				return contact;
			}
		}
		private List<CompanyPayrollCube> GetCompanyPayrollCubes(ReportRequest request)
		{
			var cubes = _reportRepository.GetCompanyCubesForYear(request.CompanyId, request.Year);
			if (cubes == null || !cubes.Any() )
			{
				throw new Exception(NoPayrollData);
			}
			var relevantCube = cubes.FirstOrDefault(c => ((request.Quarter>0 && request.Quarter==c.Quarter) || (request.Quarter==0 && !c.Quarter.HasValue)));
			if (relevantCube==null || relevantCube.Accumulation.GrossWage <= 0)
				throw new Exception(NoPayrollData);
			for (var i = 1; i < 5; i++)
			{
				if(!cubes.Any(c=>c.Quarter==i))
					cubes.Add(new CompanyPayrollCube { CompanyId = request.CompanyId, Accumulation = new PayrollAccumulation(), Quarter = i, Year = request.Year });
			}
			for (var i = 1; i < 13; i++)
			{
				if (!cubes.Any(c => c.Month == i))
					cubes.Add(new CompanyPayrollCube { CompanyId = request.CompanyId, Accumulation = new PayrollAccumulation(), Month = i, Year = request.Year });
			}
				
			return cubes;

		} 
		private FileDto GetReportTransformedAndPrinted(ReportRequest request, ReportResponse response, XsltArgumentList argList, string template)
		{
			var xml = GetXml<ReportResponse>(response);
			

			var transformed = TransformXml(xml,
				string.Format("{0}{1}", _templatePath, template), argList);

			return _pdfService.PrintReport(transformed);
		}

		private XmlDocument GetXml<T>(T response)
		{
			var ser = new XmlSerializer(typeof(T));
			XmlDocument xd = null;

			using (var memStm = new MemoryStream())
			{
				ser.Serialize(memStm, response);

				memStm.Position = 0;

				var settings = new XmlReaderSettings();
				settings.IgnoreWhitespace = true;

				using (var xtr = XmlReader.Create(memStm, settings))
				{
					xd = new XmlDocument();
					xd.Load(xtr);
				}
			}

			return xd;
		}

		private ReportTransformed TransformXml(XmlDocument source, string transformer, XsltArgumentList args)
		{
			var strOutput = XmlTransform(source, transformer, args);
			var serializer = new XmlSerializer(typeof(ReportTransformed));
			var memStream = new MemoryStream(Encoding.UTF8.GetBytes(strOutput));
			return (ReportTransformed)serializer.Deserialize(memStream);
			
		}
		private string XmlTransform(XmlDocument source, string transformer, XsltArgumentList args)
		{
			string strOutput = null;
			var sb = new System.Text.StringBuilder();
			var xslt = new Mvp.Xml.Exslt.ExsltTransform();



			xslt.Load(transformer);
			using (TextWriter xtw = new StringWriter(sb))
			{
				xslt.Transform(source, args, xtw);
				xtw.Flush();
			}
			strOutput = sb.ToString();
			return strOutput.Replace("encoding=\"utf-16\"", string.Empty);
		}

		private void CalculateDates(ref ReportRequest request)
		{
			if (request.StartDate != DateTime.MinValue && request.EndDate != DateTime.MinValue)
			{
				return;
			}
			if (request.Quarter > 0)
			{
				request.StartDate = new DateTime(request.Year, request.Quarter*3 -2, 1 ).Date;
				request.EndDate = new DateTime(request.Year, request.Quarter * 3, DateTime.DaysInMonth(request.Year, request.Quarter*3)).Date;
			}
			else if (request.Month > 0)
			{
				request.StartDate = new DateTime(request.Year, request.Month, 1).Date;
				request.EndDate = new DateTime(request.Year, request.Month, DateTime.DaysInMonth(request.Year, request.Month)).Date;
			}
			else
			{
				request.StartDate = new DateTime(request.Year, 1, 1).Date;
				request.EndDate = new DateTime(request.Year, 12, 31).Date;
			}
		}

		private string Transform(string result)
		{
			result = result.Replace("\r\n", "");
			result = result.Replace("\n", "");
			result = result.Replace("&amp;", "&");
			result = result.Replace("$$n", Environment.NewLine);
			result = result.Replace("$$spaces100$$", "".PadRight(100));
			result = result.Replace("$$spaces20$$", "".PadRight(20));
			result = result.Replace("$$spaces10$$", "".PadRight(10));
			result = result.Replace("$$spaces5$$", "".PadRight(5));
			result = result.Replace("$$spaces2$$", "".PadRight(2));
			result = result.Replace("$$spaces1$$", "".PadRight(1));
			result = result.Replace("$$n", Environment.NewLine);
			if(result.IndexOf("mainCounter", StringComparison.InvariantCulture)>0)
			{
				var lines = result.Split(Environment.NewLine.ToCharArray());
				var mainCounter = (int) 1;
				result = string.Empty;
				foreach (var line in lines)
				{
					if (!string.IsNullOrWhiteSpace(line))
					{
						result += line.Replace("mainCounter", mainCounter++.ToString().PadLeft(8, '0'));
						result += Environment.NewLine;
					}
				}
			}
			return result;
		}
	}
}

