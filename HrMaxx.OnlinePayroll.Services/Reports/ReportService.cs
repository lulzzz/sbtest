﻿using System;
using System.CodeDom;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Cache;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Serialization;
using System.Xml.Xsl;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Security;
using HrMaxx.Infrastructure.Services;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;
using HrMaxx.OnlinePayroll.Repository;
using HrMaxx.OnlinePayroll.Repository.Companies;
using HrMaxx.OnlinePayroll.Repository.Payroll;
using HrMaxx.OnlinePayroll.Repository.Reports;
using Magnum.Collections;
using Magnum.Serialization;
using MassTransit.Logging;
using MassTransit.NewIdProviders;
using Newtonsoft.Json;

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
		private readonly IMetaDataRepository _metaDataRepository;

		private readonly IReaderService _readerService;
		private readonly IDocumentService _documentService;
		private readonly IFileRepository _fileRepository;

		private readonly string _filePath;
		private readonly string _templatePath;

		private const string NoData = "No Data exists for this time period and company";
		private const string NoPayrollData = "No Payroll Data exists for this time period and company";
		private const string ReportNotAvailable = "The report template(s) are not available yet";
		private const string HostNotSetUp = "Please set up the Host properly to proceed";
		private const string HostContactNA = "Please add at-least one contact for the Host";
		private const string LastCheckInAnotherCompany = "Employee's Last Check is for another company";
		
		public IBus Bus { get; set; }

		public ReportService(IReportRepository reportRepository, ICompanyRepository companyRepository, IJournalService journalService, IPDFService pdfService, ICommonService commonService, IHostService hostService, ITaxationService taxationService, IMetaDataRepository metaDataRepository, IReaderService readerService, IDocumentService documentService, IFileRepository fileRepository, string filePath, string templatePath)
		{
			_reportRepository = reportRepository;
			_companyRepository = companyRepository;
			_journalService = journalService;
			_pdfService = pdfService;
			_filePath = filePath;
			_templatePath = templatePath;
			_commonService = commonService;
			_metaDataRepository = metaDataRepository;
			_hostService = hostService;
			_taxationService = taxationService;
			_readerService = readerService;
			_documentService = documentService;
			_fileRepository = fileRepository;
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
				else if (request.ReportName.Equals("C1095"))
					return GetC1095Report(request);
				
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
				else if (request.ReportName.Equals("CompanySickLeaveExport"))
					return GetCompanySickLeaveExport(request);
				
				return null;
			}
			catch (Exception e)
			{
				var message = string.Empty;
				if (e.Message == NoPayrollData || e.Message.StartsWith(NoData) || e.Message.StartsWith(LastCheckInAnotherCompany))
				{
					message = e.Message;
				}
				else if (e.Message == ReportNotAvailable || e.Message == HostContactNA || e.Message == HostNotSetUp)
				{
					message = e.Message;
					Log.Error(message, e);
				}
				else if (e.Message.ToLower().StartsWith("could not find file"))
				{
					message = ReportNotAvailable;
					Log.Error(message, e);
				}
				else
				{
					message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" Get report data for report={0} {1}-{2}", request.ReportName, request.StartDate.ToString(), request.EndDate.ToString()));
					Log.Error(message, e);
				}
				
				throw new HrMaxxApplicationException(message, e);
			}
			
		}

		public Extract GetExtractDocument(ReportRequest request)
		{
			try
			{
				request.CheckEFileFormsFlag = true;
				request.CheckTaxPaymentFlag = true;
				CalculateDates(ref request);
				if (request.ReportName.Equals("Paperless941"))
					return GetPaperless941(request);
				else if (request.ReportName.Equals("HostClientSummary"))
					return GetHostClientSummary(request);
				else if (request.ReportName.Equals("Paperless940"))
					return GetPaperless940(request);
				else if (request.ReportName.Equals("SSAW2Magnetic"))
					return GetSSAMagnetic(request);
				else if (request.ReportName.Equals("SSAW2MagneticReport"))
					return GetSSAMagneticReport(request);
				else if (request.ReportName.Equals("SSAW2MagneticEmployerReport"))
					return GetSSAMagneticEmployerReport(request);
				else if (request.ReportName.Equals("C1095"))
					return GetC1095Extract(request);
				else if (request.ReportName.Equals("C1095Report"))
					return GetC1095ExtractReport(request);
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
				else if (request.ReportName.Equals("TaxReport"))
					return GetTaxReport(request);
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
				else if (request.ReportName.Equals("StateCADE9"))
					return StateCADE9(request);
				else if (request.ReportName.Equals("HostWCReport"))
					return GetHostWCReport(request);
				else if (request.ReportName.Equals("HostWCReportRedated"))
					return GetHostWCReportRedated(request);
				else if (request.ReportName.Equals("DailyDepositReport"))
					return GetDailyDepositReport(request);
				else if (request.ReportName.Equals("PositivePayReport"))
					return GetPositivePayReport(request);
				else if (request.ReportName.Equals("InternalPositivePayReport"))
					return GetInternalPositivePayReport(request);
				else if (request.ReportName.Equals("GarnishmentReport"))
					return GetGarnishmentReport(request);
				else if (request.ReportName.Equals("SemiWeeklyEligibility"))
					return GetSemiWeeklyEligibilityReport(request);
				
				else
				{
					throw new Exception(ReportNotAvailable);
				}
			}
			catch (Exception e)
			{
				var message = string.Empty;
				if (e.Message == NoData || e.Message == NoPayrollData)
				{
					message = e.Message;
				}
				else if (e.Message == ReportNotAvailable || e.Message == HostContactNA || e.Message == HostNotSetUp)
				{
					message = e.Message;
					Log.Error(message, e);
				}
				else if (e.Message.ToLower().StartsWith("could not find file"))
				{
					message = ReportNotAvailable;
					Log.Error(message, e);
				}
				else
				{
					message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" Get report data for report={0} {1}-{2}", request.ReportName, request.StartDate.ToString(), request.EndDate.ToString()));
					Log.Error(message, e);
				}

				
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private Extract GetHostClientSummary(ReportRequest request)
		{
			request.Description = string.Format("Host Client Summary for {0} ", request.Year);
			request.AllowFiling = false;
			var data = GetExtractResponse(request);
			
			data.Hosts.ForEach(h =>
			{
				h.Companies.ForEach(c =>
				{
					var companyPayrolls = _readerService.GetPayrolls(c.Id, request.StartDate, request.EndDate, excludeVoids:1).Where(p => p.Company.Id == c.Id && p.TotalGrossWage>0).ToList();
					c.Summaries = new List<PayrollSummary>();
					companyPayrolls.ForEach(p => c.Summaries.Add(new PayrollSummary
					{
						Id=p.Id, StartDate = p.StartDate, EndDate = p.EndDate, PayDay = p.PayDay, TaxPayDay = p.TaxPayDay,
						GrossWage = p.TotalGrossWage,
						Total940 = Math.Round(p.PayChecks.Where(pc => !pc.IsVoid).Sum(pc => pc.Taxes.Where(t=>t.Tax.Code.Equals("FUTA")).Sum(t=>t.Amount)), 2, MidpointRounding.AwayFromZero),
						Total941 = Math.Round(p.PayChecks.Where(pc => !pc.IsVoid).Sum(pc => pc.Taxes.Where(t => !t.Tax.StateId.HasValue && !t.Tax.Code.Equals("FUTA")).Sum(t => t.Amount)), 2, MidpointRounding.AwayFromZero),
						TotalEtt = Math.Round(p.PayChecks.Where(pc => !pc.IsVoid).Sum(pc => pc.Taxes.Where(t => t.Tax.Code.Equals("ETT")).Sum(t => t.Amount)), 2, MidpointRounding.AwayFromZero),
						TotalUi = Math.Round(p.PayChecks.Where(pc => !pc.IsVoid).Sum(pc => pc.Taxes.Where(t => t.Tax.Code.Equals("SUI")).Sum(t => t.Amount)), 2, MidpointRounding.AwayFromZero),
						TotalFederal = Math.Round(p.PayChecks.Where(pc => !pc.IsVoid).Sum(pc => pc.Taxes.Where(t => !t.Tax.StateId.HasValue).Sum(t => t.Amount)), 2, MidpointRounding.AwayFromZero),
						TotalState = Math.Round(p.PayChecks.Where(pc => !pc.IsVoid).Sum(pc => pc.Taxes.Where(t => t.Tax.StateId.HasValue && t.Tax.StateId.Value==1).Sum(t => t.Amount)), 2, MidpointRounding.AwayFromZero)
					}));
				});
				h.Companies = h.Companies.Where(c => c.Summaries.Any()).ToList();
			});
			data.Hosts = data.Hosts.Where(h => h.Companies.Any()).ToList();
			var argList = new List<KeyValuePair<string, string>>();
			argList.Add(new KeyValuePair<string, string>("selectedYear", request.Year.ToString()));

			return GetExtractTransformed(request, data, argList, "transformers/extracts/HostClientSummary.xslt", "xls", string.Format("Host Client Summary Report-{0}.xls", request.Year));
			
		}

		private Extract GetTaxReport(ReportRequest request)
		{
			request.Description = string.Format("Tax Report for {0} {1} {2}", request.Year, request.Quarter>0 ? request.Quarter.ToString() : string.Empty, request.Month > 0 ?request.Month.ToString():string.Empty);
			request.AllowFiling = false;
			var data = GetExtractResponse(request, includeTaxes: true);

			data.Hosts = data.Hosts.Where(h => h.Companies.Any()).ToList();
			var argList = new List<KeyValuePair<string, string>>();
			argList.Add(new KeyValuePair<string, string>("selectedYear", request.Year.ToString()));

			return GetExtractTransformed(request, data, argList, "transformers/extracts/TaxReport.xslt", "xls", string.Format("Tax Report-{0}-{1}-{2}.xls", request.Year, request.Quarter>0 ? request.Quarter.ToString() : string.Empty, request.Month > 0 ?request.Month.ToString():string.Empty));

		}

		private Extract GetSemiWeeklyEligibilityReport(ReportRequest request)
		{
			var data = GetExtractResponseSemiWeeklyEligibility(request);
			
			request.Description = string.Format("{0} Internal Positive Pay Report {1}", data.Hosts.First().Host.FirmName, request.StartDate.ToString("MMddyyyy"));
			request.AllowExclude = true;

			var argList = new List<KeyValuePair<string, string>>();

			return GetExtractTransformed(request, data, argList, string.Empty, string.Empty, request.Description);
		}
		private FileDto GetCompanySickLeaveExport(ReportRequest request)
		{
			var company = _readerService.GetCompany(request.CompanyId);
			if(company.AccumulatedPayTypes.First(ac=>ac.PayType.Id==6).CompanyManaged)
				throw new Exception(NoData + ". This Company Manages their own Sick Leave");
			var employees = _readerService.GetEmployees(company: request.CompanyId).Where(e=>(request.EmployeeId==Guid.Empty || (request.EmployeeId!=Guid.Empty && e.Id==request.EmployeeId)) && (e.StatusId==StatusOption.Active || e.StatusId==StatusOption.InActive)).ToList();
			if (!employees.Any())
				throw new Exception(NoData + ". No Employees found");
			var result = new List<EmployeeSickLeave>();
			employees.ForEach(e =>
			{
				var payChecks = _readerService.GetEmployeePayChecks(e.Id);
				var empSL = new EmployeeSickLeave()
				{
					Id = e.Id,
					Name = e.FullName,
					CompanyEmployeeNo = e.CompanyEmployeeNo,
					CarryOver = e.CarryOver,
					HireDate = e.HireDate.ToString("MM/dd/yyyy"),
					SickLeaveHireDate = e.SickLeaveHireDate.ToString("MM/dd/yyyy")
				};
				empSL.Accumulations =
					payChecks.OrderBy(pc=>pc.PayDay).Select(
						pc =>
							new SickLeaveAccumulation
							{
								CheckNumber = pc.CheckNumber.Value,
								Id = pc.Id,
								PayDay = pc.PayDay.ToString("MM/dd/yyyy"),
								FiscalEnd = pc.Accumulations.First().FiscalEnd.ToString("MM/dd/yyyy"),
								FiscalStart = pc.Accumulations.First().FiscalStart.ToString("MM/dd/yyyy"),
								AccumulatedValue = pc.Accumulations.First().AccumulatedValue,
								Used = pc.Accumulations.First().Used,
								CarryOver = pc.Accumulations.First().CarryOver,
								YTDFiscal = pc.Accumulations.First().YTDFiscal,
								YTDUsed = pc.Accumulations.First().YTDUsed,
								Available = pc.Accumulations.First().YTDFiscal+pc.Accumulations.First().CarryOver-pc.Accumulations.First().YTDUsed
							}).ToList();
				result.Add(empSL);
			});
			result = result.Where(e => e.Accumulations.Any()).OrderBy(e=>e.CompanyEmployeeNo).ToList();
			if (!result.Any())
				throw new Exception(NoData);
			request.Description = string.Format("{0} Sick Leave by Employee", company.Name);


			var xml = GetXml(result);


			var transformed = XmlTransform(xml, string.Format("{0}{1}", _templatePath, "transformers/extracts/CompanySickLeave.xslt"), new XsltArgumentList());
			return new FileDto
				{
					Data = Encoding.UTF8.GetBytes(transformed),
					DocumentExtension = ".xls",
					Filename = request.Description + ".xls",
					MimeType = "application/octet-stream"
				};

		}

		private Extract GetHostWCReport(ReportRequest request)
		{
			var data = GetExtractResponseHostWC(request, buildCompanyEmployeeAccumulation: true);

			request.Description = string.Format("{0} WC Report {1}-{2}", data.Hosts.First().Host.FirmName, request.StartDate.ToString("MM/dd/yyyy"), request.EndDate.ToString("MM/dd/yyyy"));
			request.AllowFiling = true;

			var argList = new List<KeyValuePair<string, string>>();
			
			return GetExtractTransformed(request, data, argList, "transformers/extracts/HostWCReport.xslt", "xls", request.Description + ".xls");
		}
		private Extract GetHostWCReportRedated(ReportRequest request)
		{
			var data = GetExtractResponseHostWCRedated(request, buildCompanyEmployeeAccumulation: true);
			request.ReportName = "HostWCReport";
			request.Description = string.Format("{0} WC Report {1}-{2}", data.Hosts.First().Host.FirmName, request.StartDate.ToString("MM/dd/yyyy"), request.EndDate.ToString("MM/dd/yyyy"));
			request.AllowFiling = true;

			var argList = new List<KeyValuePair<string, string>>();

			return GetExtractTransformed(request, data, argList, "transformers/extracts/HostWCReport.xslt", "xls", request.Description + ".xls");
		}

		private Extract GetDailyDepositReport(ReportRequest request)
		{
			request.EndDate = request.StartDate.Date.AddHours(24);
			
			var filtered = _readerService.GetInvoicePayments(request.StartDate, request.EndDate);
			if (!filtered.Any())
				throw new Exception(NoData);
			var hosts = _hostService.GetHostList(Guid.Empty);
			var companies = _readerService.GetCompanies();
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

			var argList = new List<KeyValuePair<string, string>>();
			argList.Add(new KeyValuePair<string, string>("today", request.StartDate.ToString("MM/dd/yyyy")));
			return GetExtractTransformed(request, data, argList, "transformers/extracts/DailyDepositReport.xslt", "xls", request.Description + ".xls");
		}

		private Extract GetInternalPositivePayReport(ReportRequest request)
		{
			request.IncludeVoids = true;
			var data = GetExtractResponse(request);

			request.Description = string.Format("{0} Internal Positive Pay Report {1}", data.Hosts.First().Host.FirmName, request.StartDate.ToString("MMddyyyy"));
			request.AllowFiling = false;

			var argList = new List<KeyValuePair<string, string>>();

			return GetExtractTransformed(request, data, argList, "transformers/extracts/InternalPositivePayReport.xslt", "xls", request.Description + ".xls");
		}
		private Extract GetGarnishmentReport(ReportRequest request)
		{
			var data = GetExtractResponseGarnishment(request, buildGarnishments:true);
			if (!data.Hosts.Any(h => h.Accumulation.GarnishmentAgencies.Any()))
			{
				throw new Exception(NoData);
			}
			data.Hosts = data.Hosts.Where(h => h.Accumulation.GarnishmentAgencies.Any()).ToList();
			request.Description = string.Format("Garnishment Report {0} - {1}", request.StartDate.ToString("MMddyyyy"), request.EndDate.ToString("MMddyyyy"));
			request.AllowFiling = true;

			var argList = new List<KeyValuePair<string, string>>();

			return GetExtractTransformed(request, data, argList, "transformers/extracts/GarnishmentReport.xslt", "xls", request.Description + ".xls");
		}
		public CommissionsExtract GetCommissionsReport(CommissionsReportRequest request)
		{
			var data = _readerService.GetCommissionsExtractResponse(request);
			if (!data.SalesReps.Any(s => s.Commissions.Any()))
			{
				throw new Exception(NoData);
			}
			data.SalesReps = data.SalesReps.Where(h => h.Commissions.Any()).ToList();
			request.Description = string.Format("Commissions Report {0} - {1}", request.StartDate.HasValue ? request.StartDate.Value.ToString("MMddyyyy") : string.Empty, request.EndDate.HasValue ? request.EndDate.Value.ToString("MMddyyyy") : string.Empty);
			request.AllowFiling = true;
			return new CommissionsExtract{Report = request, Data = data};
		}

		public Models.MasterExtract PayCommissions(CommissionsExtract extract, string fullName)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					var me = _reportRepository.SaveCommissionExtract(extract, fullName);
					_fileRepository.SaveArchiveJson(ArchiveTypes.Extract.GetDbName(), string.Empty, me.Id.ToString(), JsonConvert.SerializeObject(extract));
					txn.Complete();
					return me;
				}
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, string.Format(" Pay Commissions for {0} {1}", extract.Report.StartDate.ToString(), extract.Report.EndDate.ToString()));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public CommissionsExtract GetCommissionsExtract(int id)
		{
			return _readerService.GetCommissionsExtract(id);
		}

		public void DeleteExtract(int extractId)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					_journalService.DeleteExtract(extractId);
					txn.Complete();
					
				}

			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, string.Format(" delete extract id {0}", extractId));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public MasterExtract ConfirmExtract(MasterExtract extract)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					_reportRepository.ConfirmExtract(extract);
					txn.Complete();
					
				}
				return extract;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, string.Format(" confirm extract id {0}", extract.Id));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public CPAReport GetCPAReport(ReportRequest request)
		{
			try
			{
				var company = _readerService.GetCompany(request.CompanyId);
				var companyAccumulation = _readerService.GetTaxAccumulations(company: request.CompanyId,
								startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Company, includeTaxes:true, includeWorkerCompensations:true, includeHistory: request.IncludeHistory).First();
				var payrollInvoices = _readerService.GetPayrollInvoices(companyId: request.CompanyId, startDate: request.StartDate,
					endDate: request.EndDate, byPayDay:true);
				var employeeAccumulations = _readerService.GetTaxAccumulations(company: request.CompanyId,
				startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Employee, includePayCodes: true, includeTaxes: true, includeWorkerCompensations: true, includeHistory: request.IncludeHistory).Where(e => e.PayCheckWages.GrossWage > 0).ToList();
				var cpareport =  new CPAReport()
				{
					CompanyId = request.CompanyId, StartDate = request.StartDate, EndDate = request.EndDate,
					IsPeo = company.FileUnderHost, CooValue = employeeAccumulations.Where(ea=>ea.CompanyWorkerCompensation!=null && ea.CompanyWorkerCompensation.Rate==0).Sum(ea=>ea.PayCheckWages.GrossWage),
					SawValue = !company.FileUnderHost ? Math.Round(companyAccumulation.PayCheckWages.GrossWage - employeeAccumulations.Where(ea => ea.CompanyWorkerCompensation != null && ea.CompanyWorkerCompensation.Rate == 0).Sum(ea => ea.PayCheckWages.GrossWage) ,2, MidpointRounding.AwayFromZero) : 0,
					PrtValue = !company.FileUnderHost ? companyAccumulation.EmployerTaxes : 0
				};
				if (company.FileUnderHost)
				{
					if(company.Contract.InvoiceSetup.InvoiceType==CompanyInvoiceType.PEOASOCoCheck)
						cpareport.T1Value = Math.Round(payrollInvoices.Sum(pi=>pi.Total),2, MidpointRounding.AwayFromZero);
					else
					{
						cpareport.T1Value = Math.Round(payrollInvoices.Sum(pi=>pi.Total + pi.NetPay),2, MidpointRounding.AwayFromZero);
					}
				}
				else
				{
					cpareport.T1Value = Math.Round(payrollInvoices.Sum(pi => pi.AdminFee + pi.EnvironmentalFee + pi.WorkerCompensationCharges), 2, MidpointRounding.AwayFromZero);
				}
				return cpareport;

			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" cpa report for company id {0}", request.CompanyId));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public FileDto GetExtractTransformedAndPrinted(Extract extract)
		{
			if (extract.Report.ReportName.StartsWith("SSAW2"))
			{
				extract.Data.Companies.ForEach(c =>
				{
					
					var ea = _readerService.GetTaxAccumulations(company: c.Company.Id, startdate: extract.Report.StartDate,
						enddate: extract.Report.EndDate, type: AccumulationType.Employee, includeTaxes: true, includedCompensations: true, 
						includedDeductions: true, report: extract.Report.ReportName, includeHistory: extract.Report.IncludeHistory, includeClients: !c.Company.IsHostCompany);

					c.EmployeeAccumulationList =
						ea.Where(ea1 => ea1.PayCheckWages != null && ea1.PayCheckWages.GrossWage > 0 && ea1.LastCheckCompany.HasValue && ea1.LastCheckCompany.Value==c.Company.Id).ToList();					
				});
			}
			var args = extract.ArgumentList != null ? JsonConvert.DeserializeObject<List<KeyValuePair<string, string>>>(extract.ArgumentList) : new List<KeyValuePair<string, string>>();
			var argList = new XsltArgumentList();
			args.ForEach(a => argList.AddParam(a.Key,string.Empty, a.Value));
			return GetReportTransformedAndPrinted<ExtractResponse>(extract.Report, extract.Data, argList, extract.Template);
		}

		public FileDto GetExtractTransformedAndPrintedZip(Extract extract)
		{
			var dir =
				_documentService.CreateDirectory(string.Format("{0}-{1}", extract.Report.ReportName,
					DateTime.Now.ToString("MM-dd-yyyy")));
			var companies = Utilities.GetCopy( extract.Data.Companies );
			extract.Data.Companies = new List<ExtractCompany>();
			var completedCompanies = new List<Guid>();
			for (var i=0;i< companies.Count;i++)
			{
				GetExractTransformedAndSaved(extract, companies[i], dir);
			}
			
			var zipFile = _documentService.ZipDirectory(dir, extract.Report.ReportName);
			return new FileDto
			{
				Data = zipFile,
				Filename = extract.Report.ReportName + ".zip",
				DocumentExtension = ".zip",
				MimeType = "application/octet-stream"
			};
		}

		public List<MinWageEligibileCompany> GetMinWageEligibilityReport(MinWageEligibilityCriteria criteria)
		{
			var data =  _readerService.GetMinWageEligibilityReport(criteria);
			if(criteria.FilterHourlyEmployeeCompanies)
				data = data.Where(c => c.Employees.Any()).ToList();
			if(criteria.MinEmployeeCount.HasValue)
				data = data.Where(c => c.PaidEmployeeCount >= criteria.MinEmployeeCount.Value).ToList();
			if(criteria.MaxEmployeeCount.HasValue)
				data = data.Where(c => c.PaidEmployeeCount <= criteria.MaxEmployeeCount.Value).ToList();
			return data;
		}

		private void GetExractTransformedAndSaved(Extract extract, ExtractCompany company, string dir)
		{
			if (_fileRepository.FileExists(dir, company.Company.Name, ".pdf"))
			{
				Log.Info("Finished Company " + company.Company.Name);
				return;
			}
			extract.Data.Companies = new List<ExtractCompany>() { company };
			if (extract.Report.ReportName.StartsWith("SSAW2"))
			{
				extract.Data.Companies.ForEach(c =>
				{

					var ea = _readerService.GetTaxAccumulations(company: c.Company.Id, startdate: extract.Report.StartDate,
						enddate: extract.Report.EndDate, type: AccumulationType.Employee, includeTaxes: true, includedCompensations: true, includedDeductions: true, report: extract.Report.ReportName, includeHistory: extract.Report.IncludeHistory, includeClients: !c.Company.IsHostCompany);

					c.EmployeeAccumulationList =
						ea.Where(ea1 => ea1.PayCheckWages != null && ea1.PayCheckWages.GrossWage > 0 && ea1.PayCheckWages.GrossWage > 0 && ea1.LastCheckCompany.HasValue && ea1.LastCheckCompany.Value == c.Company.Id).ToList();
				});
			}

			var args = extract.ArgumentList != null ? JsonConvert.DeserializeObject<List<KeyValuePair<string, string>>>(extract.ArgumentList) : new List<KeyValuePair<string, string>>();
			var argList = new XsltArgumentList();
			args.ForEach(a => argList.AddParam(a.Key, string.Empty, a.Value));
			var file = GetReportTransformedAndPrinted<ExtractResponse>(extract.Report, extract.Data, argList, extract.Template);
			_fileRepository.SaveFile(dir, company.Company.Name, file.DocumentExtension, file.Data);
			Log.Info("Finished Company " + company.Company.Name);
			
		}
		public Extract GetPositivePayReport(ReportRequest request)
		{
			var host = _hostService.GetHost(request.HostId);
			var accounts = _companyRepository.GetCompanyAccounts(host.Company.Id);
			var journals = _journalService.GetJournalListForPositivePay(host.CompanyId, request.StartDate.Date,
				request.EndDate.Date);
			journals =
				journals.Where(
					j => (j.TransactionType == TransactionType.PayCheck || j.TransactionType == TransactionType.RegularCheck || j.TransactionType == TransactionType.DeductionPayment) && j.PaymentMethod == EmployeePaymentMethod.Check).ToList();
			if(!journals.Any())
				throw  new Exception(NoData);
			journals.Where(j=>j.OriginalDate.HasValue).ToList().ForEach(j=>j.TransactionDate = j.OriginalDate.Value);
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

			var argList = new List<KeyValuePair<string, string>>();

			return GetExtractTransformed(request, data, argList, "transformers/extracts/PositivePayReport.xslt", "txt", request.Description + ".txt");
		}
		private ExtractResponse GetExtractResponseGarnishment(ReportRequest request, bool buildCounts = false, bool buildDaily = false, bool buildGarnishments = false)
		{
			var data = _readerService.GetExtractResponse(request);

			if (data.Hosts.All(h => h.Companies.All(c => !c.PayChecks.Any() && !c.VoidedPayChecks.Any())))
			{
				throw new Exception(NoPayrollData);
			}
			else
			{
				data.Hosts = data.Hosts.Where(h => h.Companies.Any(c => c.PayChecks.Any() || c.VoidedPayChecks.Any())).ToList();
			}
			
			var garnishmentAgencies = new List<VendorCustomer>();
			if (buildGarnishments)
				garnishmentAgencies = _metaDataRepository.GetGarnishmentAgencies();
			data.Hosts.ForEach(h =>
			{
				
				h.Companies = h.Companies.Where(c => c.PayChecks.Any() || c.VoidedPayChecks.Any()).ToList();
				h.Accumulation = new ExtractAccumulation() { ExtractType = request.ExtractType };
				var payChecks = h.Companies.SelectMany(c => c.PayChecks).ToList();
				var voidedPayChecks = h.Companies.SelectMany(c => c.VoidedPayChecks).ToList();

				h.Accumulation.Initialize(payChecks, voidedPayChecks, garnishmentAgencies, buildCounts, buildDaily, buildGarnishments, request.Year, request.Quarter);

				h.PayChecks.AddRange(payChecks);
				h.CredChecks.AddRange(voidedPayChecks);

				h.Companies.ForEach(c =>
				{
					c.Accumulation = new ExtractAccumulation() { ExtractType = request.ExtractType };
					c.Accumulation.Initialize(c.PayChecks, c.VoidedPayChecks, new List<VendorCustomer>(), false, false, false, request.Year, request.Quarter);

					c.PayChecks = new List<PayCheck>();
					c.VoidedPayChecks = new List<PayCheck>();
				});

				
				
			});
			if (buildGarnishments)
			{
				data.Hosts = data.Hosts.Where(h => h.Accumulation.GarnishmentAgencies.Any(ga => ga.Total > 0)).ToList();
			}

			return data;
		}

		private ExtractResponse GetExtractResponseHostWC(ReportRequest request, bool buildCompanyEmployeeAccumulation = false)
		{
			var data = _readerService.GetExtractResponse(request);

			if (data.Hosts.All(h => h.Companies.All(c => !c.PayChecks.Any() && !c.VoidedPayChecks.Any())))
			{
				throw new Exception(NoPayrollData);
			}
			else
			{
				data.Hosts = data.Hosts.Where(h => h.Companies.Any(c => c.PayChecks.Any() || c.VoidedPayChecks.Any())).ToList();
			}

			
			data.Hosts.ForEach(h =>
			{

				h.Companies = h.Companies.Where(c => c.PayChecks.Any() || c.VoidedPayChecks.Any()).ToList();
				h.Accumulation = new ExtractAccumulation() { ExtractType = request.ExtractType };
				var payChecks = h.Companies.SelectMany(c => c.PayChecks).ToList();
				var voidedPayChecks = h.Companies.SelectMany(c => c.VoidedPayChecks).ToList();

				
				h.PayChecks.AddRange(payChecks);
				h.CredChecks.AddRange(voidedPayChecks);

				h.Companies.ForEach(c =>
				{
					c.Accumulation = new ExtractAccumulation() { ExtractType = request.ExtractType };
					c.Accumulation.Initialize(c.PayChecks, c.VoidedPayChecks, new List<VendorCustomer>(), false, false, false, request.Year, request.Quarter, ExtractAccumulationMode.WC);

					if (buildCompanyEmployeeAccumulation)
						c.EmployeeAccumulations = getEmployeeAccumulations(c.PayChecks, ExtractAccumulationMode.WC);
					c.PayChecks = new List<PayCheck>();
					c.VoidedPayChecks = new List<PayCheck>();
				});

				h.Accumulation.BuildWCOvertime(h.PayChecks);
				h.PayChecks = new List<PayCheck>();
				h.CredChecks = new List<PayCheck>();

			});
			
			return data;
		}

		private ExtractResponse GetExtractResponseHostWCRedated(ReportRequest request, bool buildCompanyEmployeeAccumulation = false)
		{
			var data = _readerService.GetExtractResponseSpecial(request);

			if (data.Hosts.All(h => h.Companies.All(c => !c.PayChecks.Any() && !c.VoidedPayChecks.Any())))
			{
				throw new Exception(NoPayrollData);
			}
			else
			{
				data.Hosts = data.Hosts.Where(h => h.Companies.Any(c => c.PayChecks.Any() || c.VoidedPayChecks.Any())).ToList();
			}


			data.Hosts.ForEach(h =>
			{

				h.Companies = h.Companies.Where(c => c.PayChecks.Any() || c.VoidedPayChecks.Any()).ToList();
				h.Accumulation = new ExtractAccumulation() { ExtractType = request.ExtractType };
				var payChecks = h.Companies.SelectMany(c => c.PayChecks).ToList();
				var voidedPayChecks = h.Companies.SelectMany(c => c.VoidedPayChecks).ToList();


				h.PayChecks.AddRange(payChecks);
				h.CredChecks.AddRange(voidedPayChecks);

				h.Companies.ForEach(c =>
				{
					c.Accumulation = new ExtractAccumulation() { ExtractType = request.ExtractType };
					c.Accumulation.Initialize(c.PayChecks, c.VoidedPayChecks, new List<VendorCustomer>(), false, false, false, request.Year, request.Quarter, ExtractAccumulationMode.WC);

					if (buildCompanyEmployeeAccumulation)
						c.EmployeeAccumulations = getEmployeeAccumulations(c.PayChecks, ExtractAccumulationMode.WC);
					c.PayChecks = new List<PayCheck>();
					c.VoidedPayChecks = new List<PayCheck>();
				});



			});

			return data;
		}

		private ExtractResponse GetExtractResponseSemiWeeklyEligibility(ReportRequest request)
		{
			var data = _readerService.GetTaxEligibilityAccumulation(request.DepositSchedule);
			
			
			
			data.Hosts.ForEach(h =>
			{
				
					h.PayCheckAccumulation = new Accumulation() {  PayCheckWages = new PayCheckWages(), PayCheckList = new List<PayCheckSummary>(), VoidedPayCheckList = new List<PayCheckSummary>(), Taxes = new List<PayCheckTax>(), Deductions = new List<PayCheckDeduction>(), Compensations = new List<PayCheckCompensation>(), WorkerCompensations = new List<PayCheckWorkerCompensation>(), PayCodes = new List<PayCheckPayCode>(), DailyAccumulations = new List<DailyAccumulation>(), MonthlyAccumulations = new List<MonthlyAccumulation>() };
					h.EmployeeAccumulationList = new List<Accumulation>();
					h.Companies.ForEach(c =>
					{
						h.PayCheckAccumulation.AddAccumulation(c.PayCheckAccumulation);

						c.PayCheckAccumulation.PayCheckList = new List<PayCheckSummary>();

						
					});



			});
			data.Hosts = data.Hosts.Where(h => h.PayCheckAccumulation != null && h.PayCheckAccumulation.PayCheckWages != null
				&& (
						((h.PayCheckAccumulation.PayCheckWages.Quarter1FUTA + h.PayCheckAccumulation.PayCheckWages.Quarter2FUTA + h.PayCheckAccumulation.PayCheckWages.Quarter3FUTA + h.PayCheckAccumulation.PayCheckWages.Quarter4FUTA) >= request.YearlyLimit)
						||
						h.PayCheckAccumulation.PayCheckWages.Quarter1FUTA >= request.QuarterlyLimit
						||
						h.PayCheckAccumulation.PayCheckWages.Quarter2FUTA >= request.QuarterlyLimit
						||
						h.PayCheckAccumulation.PayCheckWages.Quarter3FUTA >= request.QuarterlyLimit
						||
						h.PayCheckAccumulation.PayCheckWages.Quarter4FUTA >= request.QuarterlyLimit
						)
						
				).ToList();
			

			return data;
		}

		private ExtractResponse GetExtractResponse(ReportRequest request, bool buildEmployeeAccumulations = false, bool buildDaily  =false, bool buildCompanyEmployeeAccumulation = false, bool includeTaxes = false, bool includeCompensaitons = false, bool includeDeductions=false, bool includeWorkerCompensations = false, bool includePayCodes= false)
		{
		
			//if(request.ReportName.StartsWith("SSA"))
			//	Log.Info(string.Format("Starting Report {0} - {1}", request.ReportName, DateTime.Now.ToString("hh:mm:ss:fff")));
			var data = _readerService.GetExtractAccumulation(request.ReportName, request.StartDate, request.EndDate,
				depositSchedule941: request.DepositSchedule, includeVoids: request.IncludeVoids, includeTaxes: includeTaxes, includedCompensations:includeCompensaitons, includedDeductions:includeDeductions, includeDailyAccumulation:buildDaily, includeMonthlyAccumulation:buildDaily, includeWorkerCompensations: includeWorkerCompensations, includePayCodes: includePayCodes, includeHistory: request.IncludeHistory
				, checkEFileFormsFlag: request.CheckEFileFormsFlag, checkTaxPaymentFlag: request.CheckTaxPaymentFlag, extractDepositName: request.ExtractDepositName);
			
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
				if (data.Hosts.All(h => h.Companies.All(c => c.PayCheckAccumulation==null || c.PayCheckAccumulation.PayCheckWages==null || c.PayCheckAccumulation.PayCheckWages.GrossWage==0)))
				{
					throw new Exception(NoPayrollData);
				}
				else
				{
					data.Hosts = data.Hosts.Where(h => h.Companies.Any(c => c.PayCheckAccumulation!=null && c.PayCheckAccumulation.PayCheckWages!=null && c.PayCheckAccumulation.PayCheckWages.GrossWage>0)).ToList();
				}
			}
			var counter = (int) 0;
			
			data.Hosts.ForEach(h =>
			{
				if (!request.ReportName.Contains("1099"))
				{
					counter++;
					//if (request.ReportName.StartsWith("SSA"))
					//	Log.Info(string.Format("Report {0} - {1} - {2} - {3}", h.HostCompany.Name, counter, DateTime.Now.ToString("hh:mm:ss:fff"), data.Hosts.Count));
					h.Companies = h.Companies.Where(c => c.PayCheckAccumulation != null && c.PayCheckAccumulation.PayCheckWages != null && c.PayCheckAccumulation.PayCheckWages.GrossWage > 0).ToList();
					h.PayCheckAccumulation = new Accumulation(){ExtractType = request.ExtractType, Year=request.Year, Quarter=request.Quarter,PayCheckWages=new PayCheckWages(), PayCheckList=new List<PayCheckSummary>(), VoidedPayCheckList = new List<PayCheckSummary>(), Taxes=new List<PayCheckTax>(), Deductions=new List<PayCheckDeduction>(), Compensations = new List<PayCheckCompensation>(),WorkerCompensations=new List<PayCheckWorkerCompensation>(), PayCodes = new List<PayCheckPayCode>(), DailyAccumulations = new List<DailyAccumulation>(), MonthlyAccumulations = new List<MonthlyAccumulation>()};
					h.EmployeeAccumulationList = new List<Accumulation>();
					if (buildEmployeeAccumulations)
					{

						var ea = _readerService.GetTaxAccumulations(company: h.HostCompany.Id, startdate: request.StartDate,
							enddate: request.EndDate, type: AccumulationType.Employee, includeWorkerCompensations: includeWorkerCompensations, includeTaxes: includeTaxes, includedCompensations: includeCompensaitons, includedDeductions: includeDeductions, report: request.ReportName, includeHistory: request.IncludeHistory, includeClients: true);

						h.EmployeeAccumulationList = ea.Where(ea1 => ea1.PayCheckWages != null && ea1.PayCheckWages.GrossWage > 0).ToList();
					}
					if (buildCompanyEmployeeAccumulation)
					{
						h.Companies.ForEach(c =>
						{
							var ea = _readerService.GetTaxAccumulations(company: c.Company.Id, startdate: request.StartDate,
							enddate: request.EndDate, type: AccumulationType.Employee, includeWorkerCompensations: includeWorkerCompensations, includeTaxes: includeTaxes, includedCompensations: includeCompensaitons, includedDeductions: includeDeductions, report: request.ReportName, includeHistory: request.IncludeHistory);
							
							c.EmployeeAccumulationList =
								ea.Where(ea1 => ea1.PayCheckWages != null && ea1.PayCheckWages.GrossWage > 0).ToList();
						});
					}
					h.Companies.ForEach(c =>
					{
						c.PayCheckAccumulation.ExtractType = request.ExtractType;
						c.PayCheckAccumulation.Year = request.Year;
						c.PayCheckAccumulation.Quarter = request.Quarter;
						h.PayCheckAccumulation.AddAccumulation(c.PayCheckAccumulation);

						if (c.VoidedAccumulation != null)
						{
							c.PayCheckAccumulation.SubtractAccumulation(c.VoidedAccumulation);
							h.PayCheckAccumulation.SubtractAccumulation(c.VoidedAccumulation);
						}
							
						c.PayCheckAccumulation.PayCheckList = new List<PayCheckSummary>();
						
						
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
			//if (request.ReportName.StartsWith("SSA"))
			//	Log.Info(string.Format("Finished Report {0} - {1}", request.ReportName, DateTime.Now.ToString("hh:mm:ss:fff")));
			return data;
		}
		private ExtractResponse GetExtractResponseC1095(ReportRequest request)
		{
			
			var config = _taxationService.GetApplicationConfig();
			var c1095limit = config.C1095Limits.Any(c => c.Key == request.StartDate.Year)
				? config.C1095Limits.First(c => c.Key == request.StartDate.Year).Value
				: (decimal)9.65;
			
			var data = _readerService.GetExtractAccumulation(request.ReportName, request.StartDate, request.EndDate, includeVoids: false, includeHistory: request.IncludeHistory, includeC1095: true
				, checkEFileFormsFlag: request.CheckEFileFormsFlag, checkTaxPaymentFlag: request.CheckTaxPaymentFlag);
			
			
			
			data.Hosts.ForEach(h =>
			{
				
				h.PayCheckAccumulation = new Accumulation() { ExtractType = request.ExtractType, Year = request.Year, Quarter = request.Quarter, PayCheckWages = new PayCheckWages(), PayCheckList = new List<PayCheckSummary>(), VoidedPayCheckList = new List<PayCheckSummary>(), Taxes = new List<PayCheckTax>(), Deductions = new List<PayCheckDeduction>(), Compensations = new List<PayCheckCompensation>(), WorkerCompensations = new List<PayCheckWorkerCompensation>(), PayCodes = new List<PayCheckPayCode>(), DailyAccumulations = new List<DailyAccumulation>(), MonthlyAccumulations = new List<MonthlyAccumulation>() };
				h.EmployeeAccumulationList = new List<Accumulation>();
				
				h.Companies.ForEach(c =>
				{
					c.EmployeeAccumulationList = _readerService.GetTaxAccumulations(company: c.Company.Id,
						startdate: request.StartDate,
						enddate: request.EndDate, type: AccumulationType.Employee, includeHistory: request.IncludeHistory, includeC1095: true, includeClients: true).Where(ea => ea.PayCheck1095Summaries.Any()).ToList();

					c.EmployeeAccumulationList =
						c.EmployeeAccumulationList.Where(e => e.LastCheckCompany.HasValue && e.LastCheckCompany.Value == c.Company.Id)
						.OrderBy(e=>e.FirstName)
							.ToList();	
					c.EmployeeAccumulationList.ForEach(e=>e.BuildC1095Months(c.Company, c1095limit));
				});
				h.Companies = h.Companies.Where(c => c.EmployeeAccumulationList.Any()).ToList();
			
			});
			data.Hosts = data.Hosts.Where(h => h.Companies.Any()).ToList();
			if(!data.Hosts.Any())
				throw new Exception(NoData);
			//if(data.Hosts.All(h=>h.Companies.All(c=>c.EmployeeAccumulationList.All(e=>e.PayCheck1095Summaries.All(pc=>!pc.Deductions.Any())))))
			//	throw new Exception(NoData);

			return data;
		}
		private Extract Federal940(ReportRequest request)
		{
			request.Description = string.Format("Federal 940 EFTPS for {0} (Schedule={1})", request.Year, request.DepositSchedule);
			request.AllowFiling = true;
			request.AllowExclude = true;
			var tempDepositSchedule = request.DepositSchedule;
			request.DepositSchedule = null;
			var data = GetExtractResponse(request, includeTaxes: true);
			request.DepositSchedule = tempDepositSchedule;
			var reportConst = _taxationService.PullReportConstant("Form940", (int)request.DepositSchedule.Value);
			var config = _taxationService.GetApplicationConfig();
			var argList = new List<KeyValuePair<string, string>>();
			argList.Add(new KeyValuePair<string, string>("batchFilerId", config.BatchFilerId));
			argList.Add(new KeyValuePair<string, string>("masterPinNumber", config.MasterInquiryPin));
			argList.Add(new KeyValuePair<string, string>("fileSeq", reportConst.ToString()));
			argList.Add(new KeyValuePair<string, string>("today", DateTime.Today.ToString("yyyyMMdd")));
			argList.Add(new KeyValuePair<string, string>("settleDate", request.DepositDate.Value.Date.ToString("yyyyMMdd")));
			argList.Add(new KeyValuePair<string, string>("selectedYear", request.Year.ToString()));

			return GetExtractTransformed(request, data, argList, "transformers/extracts/Federal940EFTPS.xslt", "txt", string.Format("Federal {2} 940 Extract-{0}-{1}.txt", request.Year, request.Quarter, request.DepositSchedule));
		}

		private Extract Federal940Excel(ReportRequest request)
		{
			request.ReportName = "Federal940";
			request.Description = string.Format("Federal 940 EFTPS Excel for {0} (Schedule={1})", request.Year, request.DepositSchedule);
			request.AllowFiling = false;
			var tempDepositSchedule = request.DepositSchedule;
			request.DepositSchedule = null;
			var data = GetExtractResponse(request, includeTaxes:true);
			request.DepositSchedule = tempDepositSchedule;

			var reportConst = _taxationService.PullReportConstant("Form940", (int)request.DepositSchedule.Value);
			var config = _taxationService.GetApplicationConfig();
			var argList = new List<KeyValuePair<string, string>>();
			argList.Add(new KeyValuePair<string, string>("batchFilerId", config.BatchFilerId));
			argList.Add(new KeyValuePair<string, string>("masterPinNumber", config.MasterInquiryPin));
			argList.Add(new KeyValuePair<string, string>("fileSeq",  reportConst.ToString()));
			argList.Add(new KeyValuePair<string, string>("today", DateTime.Today.ToString("yyyyMMdd")));
			argList.Add(new KeyValuePair<string, string>("settleDate",  request.DepositDate.Value.Date.ToString("yyyyMMdd")));
			argList.Add(new KeyValuePair<string, string>("selectedYear",  request.Year.ToString()));
			argList.Add(new KeyValuePair<string, string>("endQuarterMonth", ((int)((request.EndDate.Month + 2) / 3)).ToString()));

			return GetExtractTransformed(request, data, argList, "transformers/extracts/Federal940EFTPSExcel.xslt", "xls", string.Format("Federal {2} 940 Excel Extract-{0}-{1}.xls", request.Year, request.Quarter, request.DepositSchedule));
		}
		private Extract Federal941(ReportRequest request)
		{
			request.Description = string.Format("Federal 941 EFTPS for {0} (Schedule={1})", request.Year, request.DepositSchedule);
			request.AllowFiling = true;
			var data = GetExtractResponse(request, includeCompensaitons: true, includeTaxes: true);
			
			var reportConst = _taxationService.PullReportConstant("Form941", (int)request.DepositSchedule.Value);
			var config = _taxationService.GetApplicationConfig();
			var argList = new List<KeyValuePair<string, string>>();
			argList.Add(new KeyValuePair<string, string>("batchFilerId",  config.BatchFilerId));
			argList.Add(new KeyValuePair<string, string>("masterPinNumber",  config.MasterInquiryPin));
			argList.Add(new KeyValuePair<string, string>("fileSeq",  reportConst.ToString()));
			argList.Add(new KeyValuePair<string, string>("today",  DateTime.Today.ToString("yyyyMMdd")));
			argList.Add(new KeyValuePair<string, string>("settleDate",  request.DepositDate.Value.Date.ToString("yyyyMMdd")));
			argList.Add(new KeyValuePair<string, string>("selectedYear",  request.Year.ToString()));
			argList.Add(new KeyValuePair<string, string>("endQuarterMonth",  ((int)((request.EndDate.Month +2)/ 3)*3).ToString()));

			return GetExtractTransformed(request, data, argList, "transformers/extracts/Federal941EFTPS.xslt", "txt", string.Format("Federal {2} 941 Extract-{0}-{1}.txt", request.Year, request.Quarter, request.DepositSchedule.Value.ToString()));
		}

		private Extract Federal941Excel(ReportRequest request)
		{
			request.ReportName = "Federal941";
			request.Description = string.Format("Federal 941 EFTPS Excel for {0} (Schedule={1})", request.Year, request.DepositSchedule);
			request.AllowFiling = false;

			var data = GetExtractResponse(request, includeTaxes: true);

			var reportConst = _taxationService.PullReportConstant("Form941", (int)request.DepositSchedule.Value);
			var config = _taxationService.GetApplicationConfig();
			var argList = new List<KeyValuePair<string, string>>();
			argList.Add(new KeyValuePair<string, string>("batchFilerId", config.BatchFilerId));
			argList.Add(new KeyValuePair<string, string>("masterPinNumber", config.MasterInquiryPin));
			argList.Add(new KeyValuePair<string, string>("fileSeq",  reportConst.ToString()));
			argList.Add(new KeyValuePair<string, string>("today",  DateTime.Today.ToString("yyyyMMdd")));
			argList.Add(new KeyValuePair<string, string>("settleDate", request.DepositDate.Value.Date.ToString("yyyyMMdd")));
			argList.Add(new KeyValuePair<string, string>("selectedYear",  request.Year.ToString()));
			argList.Add(new KeyValuePair<string, string>("endQuarterMonth",  ((int)((request.EndDate.Month+2) / 3)).ToString()));

			return GetExtractTransformed(request, data, argList, "transformers/extracts/Federal941EFTPSExcel.xslt", "xls", string.Format("Federal {2} 941 Excel Extract-{0}-{1}.xls", request.Year, request.Quarter, request.DepositSchedule.Value.ToString()));
		}
		private Extract StateCAPIT(ReportRequest request)
		{
			request.Description = string.Format("California State PIT & SDI for {0} (Quarter={1})", request.Year, request.Quarter);
			request.AllowFiling = true;
			var data = GetExtractResponse(request, includeTaxes: true);
			
			var argList = new List<KeyValuePair<string, string>>();
		
			argList.Add(new KeyValuePair<string, string>("reportConst", request.DepositSchedule == DepositSchedule941.SemiWeekly ? "01100" : request.DepositSchedule == DepositSchedule941.Monthly ? "01101" : "01104"));
			argList.Add(new KeyValuePair<string, string>("enddate", request.EndDate.ToString("MM/dd/yy")));
			argList.Add(new KeyValuePair<string, string>("settleDate", request.DepositDate.Value.Date.ToString("MM/dd/yy")));
			argList.Add(new KeyValuePair<string, string>("selectedYear", request.Year.ToString()));
			

			return GetExtractTransformed(request, data, argList, "transformers/extracts/CAPITEFTPS.xslt", "txt", string.Format("California State {2} PIT & DI GovOne File-{0}-{1}.txt", request.Year, request.Quarter, request.DepositSchedule.Value.ToString()));
		}
		private Extract StateCAPITExcel(ReportRequest request)
		{
			request.ReportName = "StateCAPIT";
			request.Description = string.Format("California State PIT & SDI Excel for {0} (Quarter={1})", request.Year, request.Quarter);
			request.AllowFiling = true;
			var data = GetExtractResponse(request, includeTaxes: true);

			var argList = new List<KeyValuePair<string, string>>();

			argList.Add(new KeyValuePair<string, string>("reportConst",  request.DepositSchedule == DepositSchedule941.SemiWeekly ? "01100" : request.DepositSchedule == DepositSchedule941.Monthly ? "01101" : "01104"));
			argList.Add(new KeyValuePair<string, string>("enddate",  request.EndDate.ToString("MM/dd/yyyy")));
			argList.Add(new KeyValuePair<string, string>("settleDate",  request.DepositDate.Value.Date.ToString("MM/dd/yyyy")));
			argList.Add(new KeyValuePair<string, string>("selectedYear",  request.Year.ToString()));
			argList.Add(new KeyValuePair<string, string>("endQuarterMonth", ((int)((request.EndDate.Month + 2) / 3)).ToString()));

			return GetExtractTransformed(request, data, argList, "transformers/extracts/CAPITEFTPSExcel.xslt", "xls", string.Format("California State {2} PIT & DI Excel File-{0}-{1}.xls", request.Year, request.Quarter, request.DepositSchedule.Value.ToString()));
		}

		private Extract StateCAUI(ReportRequest request)
		{
			request.Description = string.Format("California State UI & ETT for {0} (Sechedule={1})", request.Year, request.DepositSchedule);
			request.AllowFiling = true;
			request.AllowExclude = true;
			var tempDepositSchedule = request.DepositSchedule;
			request.DepositSchedule = null;
			var data = GetExtractResponse(request, includeTaxes: true);
			request.DepositSchedule = tempDepositSchedule;

			var endQuarterMonth = (int) ((request.EndDate.Month + 2)/3)*3;

			var argList = new List<KeyValuePair<string, string>>();

			argList.Add(new KeyValuePair<string, string>("reportConst", "01300"));
			argList.Add(new KeyValuePair<string, string>("enddate", new DateTime(request.EndDate.Year, endQuarterMonth, DateTime.DaysInMonth(request.EndDate.Year,endQuarterMonth)).ToString("MM/dd/yy")));
			argList.Add(new KeyValuePair<string, string>("settleDate",  request.DepositDate.Value.Date.ToString("MM/dd/yy")));
			argList.Add(new KeyValuePair<string, string>("selectedYear", request.Year.ToString()));


			return GetExtractTransformed(request, data, argList, "transformers/extracts/CAUIETTEFTPS.xslt", "txt", string.Format("California State {2} UI & ETT GovOne File-{0}-{1}.txt", request.Year, request.Quarter, request.DepositSchedule));
		}
		private Extract StateCAUIExcel(ReportRequest request)
		{
			request.ReportName = "StateCAUI";
			request.Description = string.Format("California State UI & ETT Excel for {0} (Sechedule={1})", request.Year, request.DepositSchedule);
			request.AllowFiling = true;
			var tempDepositSchedule = request.DepositSchedule;
			request.DepositSchedule = null;
			var data = GetExtractResponse(request, includeTaxes: true);
			request.DepositSchedule = tempDepositSchedule;
			var endQuarterMonth = (int)((request.EndDate.Month + 2) / 3) * 3;
			var argList = new List<KeyValuePair<string, string>>();

			argList.Add(new KeyValuePair<string, string>("reportConst",  "01300"));
			argList.Add(new KeyValuePair<string, string>("enddate", new DateTime(request.EndDate.Year, endQuarterMonth, DateTime.DaysInMonth(request.EndDate.Year, endQuarterMonth)).ToString("MM/dd/yy")));
			argList.Add(new KeyValuePair<string, string>("settleDate",  request.DepositDate.Value.Date.ToString("MM/dd/yyyy")));
			argList.Add(new KeyValuePair<string, string>("selectedYear",  request.Year.ToString()));
			argList.Add(new KeyValuePair<string, string>("endQuarterMonth", ((int)((request.EndDate.Month + 2) / 3)).ToString()));


			return GetExtractTransformed(request, data, argList, "transformers/extracts/CAUIETTEFTPSExcel.xslt", "xls", string.Format("California State {2} UI & ETT Excel File-{0}-{1}.xls", request.Year, request.Quarter, request.DepositSchedule));
		}
		private Extract StateCADE6(ReportRequest request)
		{
			request.Description = string.Format("California State DE6 for {0} (Quarter={1})", request.Year, request.Quarter);
			request.AllowFiling = false;
			request.CheckEFileFormsFlag = true;
			request.CheckTaxPaymentFlag = false;
			var data = GetExtractResponse(request, true, includeTaxes: true, includeDeductions: true);
			
			var argList = new List<KeyValuePair<string, string>>();

			argList.Add(new KeyValuePair<string, string>("endQuarterMonth",  ((int)((request.EndDate.Month+2) / 3)*3).ToString()));
			argList.Add(new KeyValuePair<string, string>("selectedYear",  request.Year.ToString()));


			return GetExtractTransformed(request, data, argList, "transformers/extracts/DE6Transformer.xslt", "txt", string.Format("California State Quarterly DE 6 Reporting File-{0}-{1}.txt", request.Year, request.Quarter));
		}
		private Extract StateCADE9(ReportRequest request)
		{
			request.Description = string.Format("California State DE9 for {0} (Quarter={1})", request.Year, request.Quarter);
			request.AllowFiling = true;
			request.AllowExclude = true;
			request.CheckEFileFormsFlag = true;
			request.CheckTaxPaymentFlag = false;
			request.DepositDate = DateTime.Now;
			var data = GetExtractResponse(request, true, includeTaxes: true, includeDeductions: true);

			var argList = new List<KeyValuePair<string, string>>();

			argList.Add(new KeyValuePair<string, string>("endQuarterMonth", ((int)((request.EndDate.Month + 2) / 3) * 3).ToString()));
			argList.Add(new KeyValuePair<string, string>("selectedYear", request.Year.ToString()));
			argList.Add(new KeyValuePair<string, string>("quarter", request.Quarter.ToString()));
			argList.Add(new KeyValuePair<string, string>("identifier", string.Format("GIIGPaxolCaliforniaDE9-{0}-{1}-{2}",request.StartDate.ToString("MMddyyyy"), request.EndDate.ToString("MMddyyyy"), DateTime.Now.ToString("MMddyyyyhhmmss"))));

			return GetExtractTransformed(request, data, argList, "transformers/extracts/DE9XmlTransformer.xslt", "zip", request.Description);

			
		}

		private void GenerateDE9Xml(ExtractHost host, string template, string extension, string directory, List<KeyValuePair<string, string>> args)
		{
			host.HostCompany.Name = host.HostCompany.Name.Trim();
			host.HostCompany.TaxFilingName = host.HostCompany.TaxFilingName.Trim();
			host.HostCompany.BusinessAddress.AddressLine1 = host.HostCompany.BusinessAddress.AddressLine1.Trim();
			host.HostCompany.BusinessAddress.City = host.HostCompany.BusinessAddress.City.Trim();
			var xml = GetXml<ExtractHost>(host);

			
			var argList = new XsltArgumentList();
			args.ForEach(a => argList.AddParam(a.Key, string.Empty, a.Value));
			var transformed = XmlTransform(xml, string.Format("{0}{1}", _templatePath, template), argList);
			
			_fileRepository.SaveFile(directory, host.HostCompany.Name.Replace(".", string.Empty).Replace(",",string.Empty), extension, transformed);
		}

		private Extract Get1099Extract(ReportRequest request)
		{
			request.Description = string.Format("Megnatic 1099 for {0}", request.Year);
			request.AllowFiling = false;
			request.CheckEFileFormsFlag = true;
			request.CheckTaxPaymentFlag = false;
			var data = GetExtractResponse(request);
			var config = _taxationService.GetApplicationConfig();
			var argList = new List<KeyValuePair<string, string>>();
			argList.Add(new KeyValuePair<string, string>("currentYear",  DateTime.Today.Year.ToString()));
			argList.Add(new KeyValuePair<string, string>("tcc",  config.TCC.ToString()));
			argList.Add(new KeyValuePair<string, string>("MagFileUserId",  config.SsaBsoW2MagneticFileId));
			argList.Add(new KeyValuePair<string, string>("selectedYear",  request.Year.ToString()));

			return GetExtractTransformed(request, data, argList, "transformers/extracts/F1099-" + request.Year + ".xslt", "txt", string.Format("Federal/State Form 1099 Magnetic File -{0}.txt", request.Year));

		}

		private Extract GetPaperless940(ReportRequest request)
		{
			request.Description = string.Format("Paperless 940 for {0}", request.Year);
			request.AllowFiling = false;
			request.CheckEFileFormsFlag = true;
			request.CheckTaxPaymentFlag = false;
			var data = GetExtractResponse(request, includeTaxes:true, includeDeductions:true);
			
			var argList = new List<KeyValuePair<string, string>>();
			argList.Add(new KeyValuePair<string, string>("quarter",  request.Quarter.ToString()));
			argList.Add(new KeyValuePair<string, string>("selectedYear",  request.Year.ToString()));
			argList.Add(new KeyValuePair<string, string>("todaydate", DateTime.Today.ToString("MM/dd/yyyy")));
			argList.Add(new KeyValuePair<string, string>("startdate",  request.StartDate.ToString("MM/dd/yyyy")));
			argList.Add(new KeyValuePair<string, string>("enddate", request.EndDate.ToString("MM/dd/yyyy")));

			return GetExtractTransformed(request, data, argList, "transformers/extracts/Paperless940-" + request.Year + ".xslt", "xls", string.Format("Paperless Extract 940-{0}.xls", request.Year));
			
		}

		private Extract GetPaperless941(ReportRequest request)
		{
			request.Description = string.Format("Paperless 941 for {0} (Quarter={1})", request.Year, request.Quarter);
			request.AllowFiling = false;
			request.CheckEFileFormsFlag = true;
			request.CheckTaxPaymentFlag = false;
			var data = GetExtractResponse(request, buildDaily: true, includeCompensaitons: true, includeTaxes: true);
			
			var argList = new List<KeyValuePair<string, string>>();
			argList.Add(new KeyValuePair<string, string>("quarter",  request.Quarter.ToString()));
			argList.Add(new KeyValuePair<string, string>("selectedYear",  request.Year.ToString()));
			argList.Add(new KeyValuePair<string, string>("todaydate",  DateTime.Today.ToString("MM/dd/yyyy")));
			argList.Add(new KeyValuePair<string, string>("startdate", request.StartDate.ToString("MM/dd/yyyy")));
			argList.Add(new KeyValuePair<string, string>("enddate", request.EndDate.ToString("MM/dd/yyyy")));


			return
					GetExtractTransformed(request, data, argList, "transformers/extracts/Paperless941-" + request.Year + ".xslt", "xls",
						string.Format("Paperless Extract 941-{0}-{1}.xls", request.Year, request.Quarter));
		}
		private Extract GetSSAMagnetic(ReportRequest request)
		{
			request.Description = string.Format("SSA W2 Megnatic for {0} ", request.Year);
			request.AllowFiling = false;
			request.CheckEFileFormsFlag = true;
			request.CheckTaxPaymentFlag = false;
			var data = GetExtractResponse(request, includeTaxes:true, buildEmployeeAccumulations:true, includeCompensaitons:true, includeDeductions:true);
			
			var config = _taxationService.GetApplicationConfig();
			var argList = new List<KeyValuePair<string, string>>();
			argList.Add(new KeyValuePair<string, string>("MagFileUserId",  config.SsaBsoW2MagneticFileId));
			argList.Add(new KeyValuePair<string, string>("selectedYear", request.Year.ToString()));
			
			return GetExtractTransformed(request, data, argList, "transformers/extracts/SSAW2.xslt", "txt", string.Format("Federal SSA W2 Magentic-{0}.txt", request.Year));
			
		}
		private Extract GetSSAMagneticReport(ReportRequest request)
		{
			request.Description = string.Format("SSA W2 Employee Report for {0} ", request.Year);
			request.AllowFiling = false;
			request.IsBatchPrinting = true;
			var data = GetExtractResponse(request);
			
			data.Hosts.ForEach(h=> h.Companies.ForEach(c=>c.HostCompanyId=h.HostCompany.Id));
			data.Companies = data.Hosts.SelectMany(h => h.Companies).OrderBy(c=>c.Company.Name).ToList();
			data.Hosts.ForEach(h => h.Companies = new List<ExtractCompany>());
			var argList = new List<KeyValuePair<string, string>>();
			argList.Add(new KeyValuePair<string, string>("selectedYear", request.Year.ToString()));
			
			var extract = new Extract()
			{
				Report = request,
				Data = data,
				Template = "transformers/extracts/SSAW2PDF.xslt",
				ArgumentList = JsonConvert.SerializeObject(argList),
				FileName = request.Description,
				Extension = ".pdf"
			};
			
			return extract;
		}
		private Extract GetSSAMagneticEmployerReport(ReportRequest request)
		{
			request.Description = string.Format("SSA W2 Employer Report for {0} ", request.Year);
			request.AllowFiling = false;
			request.IsBatchPrinting = true;
			var data = GetExtractResponse(request);
			
			data.Hosts.ForEach(h => h.Companies.ForEach(c => c.HostCompanyId = h.HostCompany.Id));
			data.Companies = data.Hosts.SelectMany(h => h.Companies).OrderBy(c => c.Company.Name).ToList();
			data.Hosts.ForEach(h => h.Companies = new List<ExtractCompany>());
			var argList = new List<KeyValuePair<string, string>>();
			argList.Add(new KeyValuePair<string, string>("selectedYear", request.Year.ToString()));

			var extract = new Extract()
			{
				Report = request,
				Data = data,
				Template = "transformers/extracts/SSAW2PDF-Employer.xslt",
				ArgumentList = JsonConvert.SerializeObject(argList),
				FileName = request.Description,
				Extension = ".pdf"
			};
			
			return extract;
		}
		private Extract GetC1095Extract(ReportRequest request)
		{
			request.Description = string.Format("C1095 Extract for {0} ", request.Year);
			request.AllowFiling = false;
			
			var data = GetExtractResponseC1095(request);

			
			var argList = new List<KeyValuePair<string, string>>();
			argList.Add(new KeyValuePair<string, string>("selectedYear", request.Year.ToString()));
			var extract = new Extract()
			{
				Report = request,
				Data = data,
				Template = string.Format("{0}{1}", _templatePath, "transformers/extracts/C1095-" + request.Year + ".xslt"),
				ArgumentList = JsonConvert.SerializeObject(argList),
				FileName = string.Format("Federal C1095 Extract-{0}.xls", request.Year),
				Extension = "zip"
			};
			var dir =
				_documentService.CreateDirectory(string.Format("{0}-{1}", request.Description,
					DateTime.Now.ToString("MM-dd-yyyy")));
			var hosts = Utilities.GetCopy(extract.Data.Hosts);
			extract.Data.Hosts = new List<ExtractHost>();
			
			for (var i = 0; i < hosts.Count; i++)
			{
				var host = hosts[i];
				if (_fileRepository.FileExists(dir, host.HostCompany.Name, ".xls"))
				{
					Log.Info("Finished Host " + host.HostCompany.Name);

				}
				else
				{
					extract.Data.Hosts = new List<ExtractHost>() { host };
					var args1 = extract.ArgumentList != null ? JsonConvert.DeserializeObject<List<KeyValuePair<string, string>>>(extract.ArgumentList) : new List<KeyValuePair<string, string>>();
					var argList1 = new XsltArgumentList();
					args1.ForEach(a => argList1.AddParam(a.Key, string.Empty, a.Value));
					
					var xml = GetXml(extract.Data);
					var filedata = XmlTransform(xml, extract.Template, argList1);
					_fileRepository.SaveFile(dir, host.HostCompany.Name, "xls", filedata);
					Log.Info("Finished host " + host.HostCompany.Name);
				}
				
			}

			var zipFile = _documentService.ZipDirectory(dir, extract.Report.ReportName);
			extract.File = new FileDto
			{
				Data = zipFile,
				Filename = extract.Report.ReportName + ".zip",
				DocumentExtension = ".zip",
				MimeType = "application/octet-stream"
			};
			return extract;
			//return GetExtractTransformed(request, data, argList, "transformers/extracts/C1095-" + request.Year + ".xslt", "xls", string.Format("Federal C1095 Extract-{0}.xls", request.Year));

		}
		private Extract GetC1095ExtractReport(ReportRequest request)
		{
			Log.Info(string.Format("started C1095 PDF {0}", DateTime.Now.ToString("hh:mm:ss:fff")));
			request.Description = string.Format("C1095 Extract for {0} ", request.Year);
			request.AllowFiling = false;
			request.IsBatchPrinting = true;
			var data = GetExtractResponseC1095(request);
			Log.Info(string.Format("extracted C1095 PDF {0}", DateTime.Now.ToString("hh:mm:ss:fff")));
			data.Hosts.ForEach(h => h.Companies.ForEach(c => c.HostCompanyId = h.HostCompany.Id));
			data.Companies = data.Hosts.SelectMany(h => h.Companies).OrderBy(c => c.Company.Name).ToList();
			data.Hosts.ForEach(h=>h.Companies=new List<ExtractCompany>());
			var argList = new List<KeyValuePair<string, string>>();
			argList.Add(new KeyValuePair<string, string>("selectedYear", request.Year.ToString()));
			argList.Add(new KeyValuePair<string, string>("todaydate", DateTime.Today.ToString("MM/dd/yyyy")));
			
			var extract = new Extract()
			{
				Report = request,
				Data = data,
				Template = "transformers/extracts/C1095PDF-" + request.Year + ".xslt",
				ArgumentList = JsonConvert.SerializeObject(argList),
				FileName = request.Description,
				Extension = ".pdf"
			};
			Log.Info(string.Format("returned C1095 PDF {0}", DateTime.Now.ToString("hh:mm:ss:fff")));
			return extract;
		}
		private Extract GetExtractTransformed(ReportRequest request, ExtractResponse data, List<KeyValuePair<string,string>> argList, string template, string extension, string filename)
		{
			var extract = new Extract()
			{
				Report = request,
				Data = data,
				Template = string.Format("{0}{1}", _templatePath, template),
				ArgumentList =  JsonConvert.SerializeObject(argList),
				FileName = filename,
				Extension = extension
			};
			
			if (!request.AllowExclude)
			{
				return GetExtractTransformedWithFile(extract);
			}
			return extract;
		}

		public Extract GetExtractTransformedWithFile(Extract extract)
		{
			
			var xml = GetXml<ExtractResponse>(extract.Data);

			var args = extract.ArgumentList!=null ? JsonConvert.DeserializeObject<List<KeyValuePair<string, string>>>(extract.ArgumentList) : new List<KeyValuePair<string, string>>();
			var argList = new XsltArgumentList();
			args.ForEach(a => argList.AddParam(a.Key, string.Empty, a.Value));

			var splits = extract.Template.Split('\\');
			var templateName = splits[splits.Length - 1];

			//var transformed = XmlTransformNew<ExtractResponse>(extract.Data,string.Format("{0}{1}", _templatePath, templateName), argList);
			
			if (extract.Report.ReportName.Equals("StateCADE9"))
			{
				var directory = _documentService.CreateDirectory(extract.FileName);
				extract.Data.Hosts.ForEach(h => GenerateDE9Xml(h, templateName, "xml", directory, args));
				var resultFile = extract.Report.Description + ".zip";
				var fileStream = _documentService.ZipDirectory(directory, resultFile);
				_documentService.DeleteDirectory(directory);
				
				extract.File = new FileDto
				{
					Data = fileStream,
					DocumentExtension = extract.Extension,
					Filename = extract.FileName + "." + extract.Extension,
					MimeType = "application/octet-stream"
				};
				
			}
			else
			{
				var transformed = XmlTransform(xml, string.Format("{0}{1}", _templatePath, templateName), argList);
				if (extract.Extension.Equals("txt"))
					transformed = Transform(transformed);

				extract.File = new FileDto
				{
					Data = Encoding.Default.GetBytes(transformed),
					DocumentExtension = extract.Extension,
					Filename = extract.FileName,
					MimeType = "application/octet-stream"
				};
			}

			
			return extract;
			
		}

		public FileDto PrintPayrollSummary(Models.Payroll payroll )
		{
			var fileName = string.Format("Payroll_{0}_{1}.pdf", payroll.Id, payroll.PayDay.ToString("MMddyyyy"));
			var xml = GetXml<Models.Payroll>(payroll);
		
			var args = new XsltArgumentList();
				
			var transformed = TransformXml(xml,
				string.Format("{0}{1}", _templatePath, "transformers/payroll/payrollsummary.xslt"), args);

			var transformedtimesheet = TransformXml(xml,
				string.Format("{0}{1}", _templatePath, "transformers/payroll/payrolltimesheet.xslt"), args);

			//return _pdfService.PrintHtml(transformed.Reports.First());
			return _pdfService.PrintHtmls(new List<Report>(){transformed.Reports.First(), transformedtimesheet.Reports.First()});
			//return _pdfService.AppendAllDocuments(payroll.Id, fileName, new List<Guid>(), summary.Data);
		}

		public List<DashboardData> GetDashboardData(DashboardRequest dashboardRequest)
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
				var extracts = _readerService.GetExtracts(report);
				//extracts.ForEach(me => me.Extract.Data.Hosts.ForEach(h =>
				//{
				//	h.Accumulation.ExtractType = me.Extract.Report.ExtractType;
				//	h.Companies.ForEach(c => c.Accumulation.ExtractType = me.Extract.Report.ExtractType);
				//}));
				return extracts;
				//return _reportRepository.GetExtractList(report);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX,
					"Extract List for report " + report);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		public MasterExtract GetExtract(int id)
		{
			try
			{
				var extracts = _readerService.GetExtract(id);
				extracts.Extract.Data.Hosts.ForEach(h =>
				{
					if(h.Accumulation!=null)
						h.Accumulation.ExtractType = extracts.Extract.Report.ExtractType;
					if (h.PayCheckAccumulation != null)
						h.PayCheckAccumulation.ExtractType = extracts.Extract.Report.ExtractType;
					h.Companies.ForEach(c =>
					{
						if (c.Accumulation != null)
							c.Accumulation.ExtractType = extracts.Extract.Report.ExtractType;
						if (c.PayCheckAccumulation != null)
							c.PayCheckAccumulation.ExtractType = extracts.Extract.Report.ExtractType;
					});
				});
				
				return extracts;
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX,
					"Extract with id " + id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public ACHMasterExtract GetAchReportExtract(int id)
		{
			return _readerService.GetACHExtract(id);
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
								t.Name = Regex.Replace(t.Name, @"[^0-9a-zA-Z\s]+", string.Empty);
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
				if (e.Message == NoData || e.Message == NoPayrollData)
				{
					message = e.Message;
				}
				else if (e.Message == ReportNotAvailable || e.Message == HostContactNA || e.Message == HostNotSetUp)
				{
					message = e.Message;
					Log.Error(message, e);
				}
				else if (e.Message.ToLower().StartsWith("could not find file"))
				{
					message = ReportNotAvailable;
					Log.Error(message, e);
				}
				else
				{
					message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" Get ACH report data for {0} {1}", request.StartDate.ToString(), request.EndDate.ToString()));
					Log.Error(message, e);
				}

				
				throw new HrMaxxApplicationException(message, e);
			}
			
		}

		public ACHExtract GetACHExtract(ACHExtract extract, string fullName)
		{
			try
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
					var me = _reportRepository.SaveACHExtract(extract, fullName);
					_fileRepository.SaveArchiveJson(ArchiveTypes.Extract.GetDbName(), string.Empty, me.Id.ToString(), JsonConvert.SerializeObject(extract));
					return extract;
				
			}
			catch (Exception e)
			{
				var message = string.Empty;
				if (e.Message == NoData || e.Message == NoPayrollData )
				{
					message = e.Message;
				}
				else if (e.Message == ReportNotAvailable || e.Message == HostContactNA || e.Message == HostNotSetUp)
				{
					message = e.Message;
					Log.Error(message, e);
				}
				else if (e.Message.ToLower().StartsWith("could not find file"))
				{
					message = ReportNotAvailable;
					Log.Error(message, e);
				}
				else
				{
					message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" Get ACH extract data for {0} {1}", extract.Report.StartDate.ToString(), extract.Report.EndDate.ToString()));
					Log.Error(message, e);
				}

				
				throw new HrMaxxApplicationException(message, e);
			}
			
		}

	

		public FileDto PrintPayrollWithoutSummary(Models.Payroll payroll, List<Guid> documents)
		{
			var fileName = string.Format("Payroll_Checks_{0}_{1}.pdf", payroll.Id, payroll.PayDay.ToString("MMddyyyy"));
			
			return _pdfService.AppendAllDocuments(payroll.Id, fileName, documents, new byte[0]);
		}
		public FileDto PrintPayrollWithoutSummary(Models.Payroll payroll, List<FileDto> documents)
		{
			var fileName = string.Format("Payroll_Checks_{0}_{1}.pdf", payroll.Id, payroll.PayDay.ToString("MMddyyyy"));

			return _pdfService.AppendAllDocuments(payroll.Id, fileName, documents);
		}
		public FileDto PrintPayrollTimesheet(Models.Payroll payroll)
		{
			var fileName = string.Format("Payroll_Timesheets_{0}_{1}.pdf", payroll.Id, payroll.PayDay.ToString("MMddyyyy"));
			var xml = GetXml<Models.Payroll>(payroll);

			var args = new XsltArgumentList();

			var transformed = TransformXml(xml,
				string.Format("{0}{1}", _templatePath, "transformers/payroll/payrolltimesheet.xslt"), args);

			return _pdfService.PrintHtml(transformed.Reports.First());
		}

		


		private ReportResponse GetIncomeStatementReport(ReportRequest request)
		{

			var companyJournals = _readerService.GetJournals(request.CompanyId, startDate: request.StartDate,
				endDate: request.EndDate, includePayrolls: true);
			var coas = _journalService.GetCompanyAccountsWithJournalsForTypes(request.CompanyId, request.StartDate,
				request.EndDate, new List<AccountType> {AccountType.Income, AccountType.Expense}, companyJournals);

			return GetAccountJournalReport(coas);
		}

		private ReportResponse GetBalanceSheet(ReportRequest request)
		{
			Log.Info("Balance Sheet started " + DateTime.Now.ToString("hh:mm:ss t z"));
			var companyJournals = _readerService.GetJournals(request.CompanyId, isvoid: 0, includePayrolls: true);
			Log.Info("journals fetched " + DateTime.Now.ToString("hh:mm:ss t z"));
			var coas = _journalService.GetCompanyAccountsWithJournalsForTypes(request.CompanyId, null,
				new DateTime(DateTime.Now.Year, 12, 31), new List<AccountType> {AccountType.Assets, AccountType.Liability}, companyJournals);
			var coasall = _journalService.GetCompanyAccountsWithJournalsForTypes(request.CompanyId, null,
				null, new List<AccountType> { AccountType.Income, AccountType.Expense }, companyJournals);
			var coasty = _journalService.GetCompanyAccountsWithJournalsForTypes(request.CompanyId, new DateTime(DateTime.Now.Year, 1, 1),
				new DateTime(DateTime.Now.Year, 12, 31), new List<AccountType> { AccountType.Income, AccountType.Expense }, companyJournals);
			Log.Info("registers made " + DateTime.Now.ToString("hh:mm:ss t z"));
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
			Log.Info("Balance Sheet finished " + DateTime.Now.ToString("hh:mm:ss t z"));
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
			var response = new ReportResponse();

			response.EmployeeAccumulationList = _readerService.GetTaxAccumulations(company: request.CompanyId,
				startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Employee, includeWorkerCompensations:true, includeHistory: request.IncludeHistory, 
				includeClients: request.IncludeClients, includeTaxDelayed: request.IncludeTaxDelayed).Where(e => e.PayCheckWages.GrossWage > 0 && e.WorkerCompensationAmount>0).ToList();
			response.CompanyAccumulations = _readerService.GetTaxAccumulations(company: request.CompanyId,
				startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Company, includeWorkerCompensations: true, includeHistory: request.IncludeHistory, 
				includeClients: request.IncludeClients, includeTaxDelayed: request.IncludeTaxDelayed).First();
			
			return response;
		}

		private ReportResponse GetDeductionsReport(ReportRequest request)
		{
			var response = new ReportResponse();

			response.EmployeeAccumulationList = _readerService.GetTaxAccumulations(company: request.CompanyId,
				startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Employee, includedDeductions: true, includeHistory: request.IncludeHistory, 
				includeClients: request.IncludeClients, includeTaxDelayed: request.IncludeTaxDelayed).Where(e => e.PayCheckWages.GrossWage > 0 && e.EmployeeDeductions > 0).ToList();
			response.CompanyAccumulations = _readerService.GetTaxAccumulations(company: request.CompanyId,
				startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Company, includedDeductions: true, includeHistory: request.IncludeHistory, 
				includeClients: request.IncludeClients, includeTaxDelayed: request.IncludeTaxDelayed).First();
			return response;
		}

		private ReportResponse GetPayrollSummaryReport(ReportRequest request)
		{
			var response = new ReportResponse();

			response.EmployeeAccumulationList = _readerService.GetTaxAccumulations(company: request.CompanyId,
				startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Employee, includePayCodes: true, includeTaxes: true, includePayTypeAccumulation: true, 
				includedDeductions: true, includedCompensations: true, includeWorkerCompensations: true, includeHistory: request.IncludeHistory, 
				includeClients: request.IncludeClients, includeTaxDelayed: request.IncludeTaxDelayed, employee: request.EmployeeId, includeClientEmployees: request.IncludeClientEmployees)
				.Where(e => e.PayCheckWages.GrossWage > 0).ToList();
			if (request.EmployeeId == Guid.Empty)
			{
				response.CompanyAccumulations = _readerService.GetTaxAccumulations(company: request.CompanyId,
					startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Company, includePayCodes: true,
					includeTaxes: true, includePayTypeAccumulation: false,
					includedDeductions: true, includedCompensations: true, includeWorkerCompensations: true,
					includeHistory: request.IncludeHistory,
					includeClients: request.IncludeClients, includeTaxDelayed: request.IncludeTaxDelayed).First();
			}
			
			return response;
		}

		private List<EmployeeAccumulation> getEmployeeAccumulations(List<PayCheck> paychecks, ExtractAccumulationMode mode=ExtractAccumulationMode.All)
		{
			var result = new List<EmployeeAccumulation>();
			var empchecks = paychecks.GroupBy(p => p.Employee.Id).ToList();
			foreach (var group in empchecks)
			{
				var pc = group.ToList();
				var ea = new EmployeeAccumulation
				{
					Accumulation = new ExtractAccumulation() { Mode=mode}
				};
				ea.Accumulation.AddPayChecks(pc);
				ea.Employee = pc.OrderByDescending(p=>p.LastModified).First().Employee;
				result.Add(ea);
			}
			return result;
		}
		private List<EmployeePayrollAccumulation> getEmployeePayrollAccumulations(List<PayCheck> paychecks)
		{
			var result = new List<EmployeePayrollAccumulation>();
			var empchecks = paychecks.GroupBy(p => p.Employee.Id).ToList();
			foreach (var group in empchecks)
			{
				var pc = group.ToList();
				var ea = new EmployeePayrollAccumulation()
				{
					PayChecks = pc,
					Accumulation = new PayrollAccumulation()
				};
				ea.Accumulation.AddPayChecks(pc);
				ea.Employee = pc.OrderByDescending(p => p.LastModified).First().Employee;
				result.Add(ea);
			}
			return result;
		} 

		private ReportResponse GetPayrollRegisterReport(ReportRequest request)
		{
			var response = new ReportResponse();
			//response.PayChecks = _reportRepository.GetReportPayChecks(request, true);
			response.PayChecks = _readerService.GetPayChecks(request.CompanyId, startDate: request.StartDate,
				endDate: request.EndDate);
			if (!request.IncludeHistory)
			{
				response.PayChecks = response.PayChecks.Where(pc => !pc.IsHistory).ToList();
			}
			return response;

		}

		private FileDto GetFederal940(ReportRequest request)
		{
			var response = new ReportResponse();

			response.CompanyAccumulations = _readerService.GetTaxAccumulations(company: request.CompanyId, startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Company,  includeTaxes: true, includedDeductions: true, includeHistory: request.IncludeHistory, includeClients: request.IncludeClients, extractDepositName: request.ExtractDepositName).First();
			response.Host = GetHost(request.HostId);
			response.Company = GetCompany(request.CompanyId);
			response.Contact = getContactForEntity(EntityTypeEnum.Host, request.HostId, response.Host.CompanyId);
			response.CompanyContact = getContactForEntity(EntityTypeEnum.Company, request.CompanyId);
			if (response.Company.FileUnderHost)
			{
				response.Company = response.Host.Company;
			}
			var argList = new XsltArgumentList();
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			argList.AddParam("firstQuarter", "", (response.CompanyAccumulations.PayCheckWages.Quarter1FUTAWage * response.CompanyAccumulations.PayCheckWages.FUTARate/100).ToString());
			argList.AddParam("secondQuarter", "", (response.CompanyAccumulations.PayCheckWages.Quarter2FUTAWage * response.CompanyAccumulations.PayCheckWages.FUTARate/100).ToString());
			argList.AddParam("thirdQuarter", "", (response.CompanyAccumulations.PayCheckWages.Quarter3FUTAWage * response.CompanyAccumulations.PayCheckWages.FUTARate/100).ToString());
			argList.AddParam("fourthQuarter", "", (response.CompanyAccumulations.PayCheckWages.Quarter4FUTAWage * response.CompanyAccumulations.PayCheckWages.FUTARate/100).ToString());
			argList.AddParam("immigrantsIncluded", "", response.CompanyAccumulations.PayCheckWages.Immigrants>0);
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/940/Fed940-" + request.Year + ".xslt");
			
		}
		private FileDto GetFederal941(ReportRequest request)
		{
			var response = new ReportResponse();

			response.CompanyAccumulations = _readerService.GetTaxAccumulations(company: request.CompanyId, startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Company, includeTaxes: true, includedDeductions: true, includedCompensations: true, includeDailyAccumulation: true, includeMonthlyAccumulation: true, includeHistory: request.IncludeHistory, includeClients: request.IncludeClients, extractDepositName: request.ExtractDepositName, includeMedicareExtraWages: true).First();
			
			response.Host = GetHost(request.HostId);
			response.Company = GetCompany(request.CompanyId);
			response.Contact = getContactForEntity(EntityTypeEnum.Host, request.HostId, response.Host.CompanyId);
			response.CompanyContact = getContactForEntity(EntityTypeEnum.Company, request.CompanyId);
			if (response.Company.FileUnderHost)
			{
				response.Company = response.Host.Company;
			}
			var argList = new XsltArgumentList();
			argList.AddParam("quarter", "", request.Quarter);
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("endQuarterMonth", "", (int)((request.EndDate.Month+2)/3)*3);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			

			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/941/Fed941-" + request.Year + ".xslt");

		}

		private FileDto GetFederal944(ReportRequest request)
		{
			var response = new ReportResponse();

			response.CompanyAccumulations = _readerService.GetTaxAccumulations(company: request.CompanyId, startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Company, includeTaxes: true, includedDeductions: true, includedCompensations: true, includeMonthlyAccumulation: true, includeDailyAccumulation: true, includeHistory: request.IncludeHistory, includeClients: request.IncludeClients).First();

			response.Host = GetHost(request.HostId);
			response.Company = GetCompany(request.CompanyId);
			response.Contact = getContactForEntity(EntityTypeEnum.Host, request.HostId, response.Host.CompanyId);
			response.CompanyContact = getContactForEntity(EntityTypeEnum.Company, request.CompanyId);
			if (response.Company.FileUnderHost)
			{
				response.Company = response.Host.Company;
			}
			var argList = new XsltArgumentList();
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/944/Fed944.xslt");

		}

		private FileDto GetW2Report(ReportRequest request, bool isEmployee)
		{
			var response = new ReportResponse();

			response.EmployeeAccumulationList = _readerService.GetTaxAccumulations(company: request.CompanyId, startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Employee, includeTaxes: true, includedDeductions: true, includedCompensations: true, includeHistory: request.IncludeHistory, includeClients: request.IncludeClients, employee: request.EmployeeId);
			if (request.EmployeeId != Guid.Empty && response.EmployeeAccumulationList.First().LastCheckCompany.HasValue && response.EmployeeAccumulationList.First().LastCheckCompany.Value!=request.CompanyId)
			{
				throw new Exception(LastCheckInAnotherCompany);
			}
			response.EmployeeAccumulationList =
				response.EmployeeAccumulationList.Where(
					e => e.PayCheckWages.GrossWage > 0 && e.LastCheckCompany.HasValue && e.LastCheckCompany.Value == request.CompanyId)
					.OrderBy(e => e.FullName)
					.ToList();
			if (!response.EmployeeAccumulationList.Any())
				throw new Exception(NoPayrollData);
			response.Company = GetCompany(request.CompanyId);
			if (response.Company.FileUnderHost)
			{
				response.Host = GetHost(response.Company.HostId);
				response.Company = response.Host.Company;
			}
				
			

			var argList = new XsltArgumentList();
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/W2/W2" + (isEmployee? string.Empty : "-Employer") + ".xslt");

		}
		private FileDto GetC1095Report(ReportRequest request)
		{
			var response = new ReportResponse();
			var config = _taxationService.GetApplicationConfig();
			var c1095limit = config.C1095Limits.Any(c => c.Key == request.StartDate.Year)
				? config.C1095Limits.First(c => c.Key == request.StartDate.Year).Value
				: (decimal)9.65;
			response.Company = GetCompany(request.CompanyId);

			response.EmployeeAccumulationList = _readerService.GetTaxAccumulations(company: request.CompanyId, startdate: request.StartDate, enddate: request.EndDate, 
				type: AccumulationType.Employee, includeHistory: request.IncludeHistory, includeC1095: true, includeClients: request.IncludeClients, employee: request.EmployeeId).ToList();
			//if (response.EmployeeAccumulationList.All(e => e.PayCheck1095Summaries.All(pc=>!pc.Deductions.Any())))
			//{
			//	throw new Exception(NoData);
			//}
			response.EmployeeAccumulationList =
				response.EmployeeAccumulationList.Where(ea => ea.PayCheck1095Summaries.Any()).OrderBy(ea=>ea.FirstName)
					.ToList();
			
			if(!response.EmployeeAccumulationList.Any())
				throw new Exception(NoData);
			response.EmployeeAccumulationList.ForEach(e => e.BuildC1095Months(response.Company, c1095limit));
			
			response.Host = GetHost(response.Company.HostId);
			if (response.Company.FileUnderHost)
				response.Company = response.Host.Company;

			response.Contact = getContactForEntity(EntityTypeEnum.Company, response.Company.Id);
			
			

			var argList = new XsltArgumentList();
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/C1095/C1095-" + request.Year + ".xslt");

		}

		private FileDto GetW3Report(ReportRequest request)
		{
			var response = new ReportResponse();

			response.CompanyAccumulations = _readerService.GetTaxAccumulations(company: request.CompanyId, startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Company, includeTaxes: true, includedDeductions: true, includedCompensations: true, includeHistory: request.IncludeHistory, includeClients: request.IncludeClients).First();
			if(response.CompanyAccumulations.PayCheckWages.EmployeeCount<=0)
				throw new Exception(NoPayrollData);
			response.Company = GetCompany(request.CompanyId);
			if (response.Company.FileUnderHost)
			{
				response.Host = GetHost(response.Company.HostId);
				response.Company = response.Host.Company;
			}

			var argList = new XsltArgumentList();
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			
			
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/W3/W3.xslt");

		}

		private FileDto GetW4Report(ReportRequest request, bool isEmployeeFilled)
		{
			if (!isEmployeeFilled)
				return _pdfService.GetTemplateFile("GovtForms\\EmployerForms\\fw4", DateTime.Now.Year, "W4");
			var response = new ReportResponse();
			response.Company = GetCompany(request.CompanyId);
			response.Employees = _readerService.GetEmployees(company:request.CompanyId).Where(e => e.StatusId == StatusOption.Active).ToList();
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
			response.CompanyAccumulations = _readerService.GetTaxAccumulations(company: request.CompanyId, startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Company, includeTaxes: true, includeHistory: request.IncludeHistory, includeClients: request.IncludeClients).First();
			
			var type = Convert.ToInt32(request.ReportName.Split('_')[1]);
			var total = type == 1
				? response.CompanyAccumulations.IRS940
				: response.CompanyAccumulations.IRS941;
			if (response.Company.FileUnderHost)
			{
				response.Host = GetHost(response.Company.HostId);
				response.Company = response.Host.Company;
			}
			var argList = new XsltArgumentList();
			argList.AddParam("type", "", type);
			argList.AddParam("month", "", request.EndDate.Month);
			
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/depositcoupons/Fed8109B.xslt");

		}
		private FileDto GetI9Report(ReportRequest request, bool isEmployeeFilled)
		{
			if (!isEmployeeFilled)
				return _pdfService.GetTemplateFile("GovtForms\\EmployerForms\\I9", DateTime.Now.Year, "I9");
			var response = new ReportResponse();
			response.Company = GetCompany(request.CompanyId);
			response.Employees = _readerService.GetEmployees(company:request.CompanyId).Where(e => e.StatusId == StatusOption.Active).ToList();
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

			response.CompanyAccumulations = _readerService.GetTaxAccumulations(company: request.CompanyId, startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Company, includeTaxes: true, includePayTypeAccumulation: false, includeHistory: request.IncludeHistory, includeClients: request.IncludeClients, extractDepositName: request.ExtractDepositName).First();
			response.Company = GetCompany(request.CompanyId);
			response.Host = GetHost(request.HostId);
			if (response.Company.FileUnderHost)
			{
				response.Company = response.Host.Company;
			}
			var argList = new XsltArgumentList();
			
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/CAForms/DE7.xslt");

		}
		private FileDto GetCaliforniaDE6(ReportRequest request)
		{
			var response = new ReportResponse();

			response.CompanyAccumulations = _readerService.GetTaxAccumulations(company: request.CompanyId, startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Company, includeTaxes: true, includedDeductions: true, includeHistory: request.IncludeHistory, includeClients: request.IncludeClients).First();
			response.EmployeeAccumulationList = _readerService.GetTaxAccumulations(company: request.CompanyId, startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Employee, includeTaxes: true, includedDeductions: true, includeHistory: request.IncludeHistory, includeClients: request.IncludeClients).Where(e => e.PayCheckWages.GrossWage > 0).ToList();
			response.Company = GetCompany(request.CompanyId); 
			response.Host = GetHost(request.HostId);
			response.Contact = getContactForEntity(EntityTypeEnum.Host, request.HostId, response.Host.CompanyId);

			var quarterEndDate = new DateTime(request.Year, request.Quarter*3,
				DateTime.DaysInMonth(request.Year, request.Quarter*3));
			var dueDate = quarterEndDate.AddDays(1);
			if (response.Company.FileUnderHost)
			{
				response.Company = response.Host.Company;
			}
			var argList = new XsltArgumentList();

			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			argList.AddParam("quarter", "", request.Quarter);
			argList.AddParam("quarterEndDate", "", quarterEndDate.ToString("MM/dd/yyyy"));
			argList.AddParam("dueDate", "", dueDate.ToString("MM/dd/yyyy"));
			
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/CAForms/DE6.xslt");

		}
		private FileDto GetCaliforniaDE9(ReportRequest request)
		{
			var response = new ReportResponse();

			response.CompanyAccumulations = _readerService.GetTaxAccumulations(company: request.CompanyId, startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Company, includeTaxes: true, includeHistory: request.IncludeHistory, includeClients: request.IncludeClients, extractDepositName: request.ExtractDepositName).First();
			response.Company = GetCompany(request.CompanyId);
			response.Host = GetHost(request.HostId);
			var quarterEndDate = new DateTime(request.Year, request.Quarter * 3,
				DateTime.DaysInMonth(request.Year, request.Quarter * 3));
			var dueDate = quarterEndDate.AddDays(1);
			var dueDate2 = quarterEndDate.AddMonths(1);
			if (response.Company.FileUnderHost)
			{
				response.Company = response.Host.Company;
			}
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

			response.CompanyAccumulations = _readerService.GetTaxAccumulations(company: request.CompanyId, startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Company, includeTaxes: true, includeHistory: request.IncludeHistory, includeClients: request.IncludeClients).First();
			response.EmployeeAccumulationList = _readerService.GetTaxAccumulations(company: request.CompanyId, startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Employee, includeTaxes: true, includeHistory: request.IncludeHistory, includeClients: request.IncludeClients, report: "CaliforniaDE9C").Where(e => e.PayCheckWages.GrossWage > 0).ToList();
			response.Company = GetCompany(request.CompanyId);
			response.Host = GetHost(request.HostId);
			response.Contact = getContactForEntity(EntityTypeEnum.Host, request.HostId, response.Host.CompanyId);

			if (response.Company.FileUnderHost)
			{
				response.Company = response.Host.Company;
			}
			var quarterEndDate = new DateTime(request.Year, request.Quarter * 3,
				DateTime.DaysInMonth(request.Year, request.Quarter * 3));
			var dueDate = quarterEndDate.AddDays(1);
			var argList = new XsltArgumentList();

			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			argList.AddParam("quarter", "", request.Quarter);
			argList.AddParam("quarterEndDate", "", quarterEndDate.ToString("MM/dd/yyyy"));
			argList.AddParam("dueDate", "", dueDate.ToString("MM/dd/yyyy"));
			
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/reports/CAForms/DE9C.xslt");

		}

		private FileDto GetCaliforniaDE34(ReportRequest request)
		{
			var response = new ReportResponse();
			response.Company = GetCompany(request.CompanyId);
			
			var emps = _readerService.GetEmployees(company:request.CompanyId);
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
			response.CompanyAccumulations = _readerService.GetTaxAccumulations(company: request.CompanyId, startdate: request.StartDate, enddate: request.EndDate, type: AccumulationType.Company, includeTaxes: true, includeHistory: request.IncludeHistory, includeClients: request.IncludeClients).First();
			var type = Convert.ToInt32(request.ReportName.Split('_')[1]);
			var total = type == 1
				? response.CompanyAccumulations.CaliforniaTaxes
				: type == 2
					? response.CompanyAccumulations.CaliforniaEmployerTaxes
					: response.CompanyAccumulations.CaliforniaEmployeeTaxes;
			var totalstr = Math.Round(total,2, MidpointRounding.AwayFromZero).ToString("00000000.00").Replace(".", string.Empty);
			if (response.Company.FileUnderHost)
			{
				response.Host = GetHost(response.Company.HostId);
				response.Company = response.Host.Company;
			}
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
			response.EmployeeAccumulationList = new List<Accumulation>();
			for (var q = 1; q <= 4; q++)
			{
				var qAcc =
				_readerService.GetTaxAccumulations(company: request.CompanyId, startdate: new DateTime(request.Year, q * 3 - 2, 1), enddate: new DateTime(request.Year, q * 3, DateTime.DaysInMonth(request.Year, q * 3)),
					type: AccumulationType.Company, includeTaxes: true, includeMonthlyAccumulation: true, includeHistory: request.IncludeHistory).First();
				qAcc.Quarter = q;
				response.EmployeeAccumulationList.Add(qAcc);
			}
			
			

			response.Company = GetCompany(request.CompanyId);

			var argList = new XsltArgumentList();
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));
			
			
			return GetReportTransformedAndPrinted(request, response, argList, "transformers/other/quarterannualtaxsummary.xslt");

		}
		private FileDto GetMonthlyQuarterAnnualReport(ReportRequest request)
		{
			var response = new ReportResponse();

			response.EmployeeAccumulationList = new List<Accumulation>();
			for (var m = 1; m <= 12; m++)
			{
				var mAcc =
				_readerService.GetTaxAccumulations(company: request.CompanyId, startdate: new DateTime(request.Year, m, 1), enddate: new DateTime(request.Year, m, DateTime.DaysInMonth(request.Year, m)),
					type: AccumulationType.Company, includeTaxes: true, includedCompensations: true, includeMonthlyAccumulation: true, includeHistory: request.IncludeHistory).First();
				mAcc.Month = m;
				response.EmployeeAccumulationList.Add(mAcc);
			}
			for (var q = 1; q <= 4; q++)
			{
				var qAcc =
				_readerService.GetTaxAccumulations(company: request.CompanyId, startdate: new DateTime(request.Year, q * 3 - 2, 1), enddate: new DateTime(request.Year, q * 3, DateTime.DaysInMonth(request.Year, q * 3)),
					type: AccumulationType.Company, includeTaxes: true, includedCompensations: true, includeHistory: request.IncludeHistory).First();
				qAcc.Quarter = q;
				response.EmployeeAccumulationList.Add(qAcc);
			}
			
			response.Company = GetCompany(request.CompanyId);

			var argList = new XsltArgumentList();
			argList.AddParam("selectedYear", "", request.Year);
			argList.AddParam("todaydate", "", DateTime.Today.ToString("MM/dd/yyyy"));


			return GetReportTransformedAndPrinted(request, response, argList, "transformers/other/monthlyquarterannualtaxsummary.xslt");

		}


		private Company GetCompany(Guid companyId)
		{
			return _readerService.GetCompany(companyId);
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
		
		private FileDto GetReportTransformedAndPrinted<T>(ReportRequest request, T response, XsltArgumentList argList, string template)
		{
			var xml = GetXml<T>(response);
			

			var transformed = TransformXml(xml,
				string.Format("{0}{1}", _templatePath, template), argList);

			return _pdfService.PrintReport(transformed);
		}

		private XmlDocument GetXml<T>(T response)
		{
			
			XmlDocument xd = null;

			using (var memStm = new MemoryStream())
			{
				var ser = new XmlSerializer(typeof(T));
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
			
			using (var memStream = new MemoryStream(Encoding.UTF8.GetBytes(strOutput)))
			{
				var serializer = new XmlSerializer(typeof(ReportTransformed));
				return (ReportTransformed)serializer.Deserialize(memStream);
			}
		}
		private string XmlTransform(XmlDocument source, string transformer, XsltArgumentList args)
		{
			string strOutput = null;
			var sb = new System.Text.StringBuilder();
			//source.Save("C:\\Dev\\EDPI\\docs\\rptresp.xml");
			using (TextWriter xtw = new StringWriter(sb))
			{
				var xslt = new XslCompiledTransform();// Mvp.Xml.Exslt.ExsltTransform();

				xslt.Load(transformer);
				xslt.Transform(source, args, xtw);
				xtw.Flush();
			}
			strOutput = sb.ToString();
			return strOutput.Replace("encoding=\"utf-16\"", string.Empty);
		}
		private string XmlTransformNew<T>(T source1, string transformer, XsltArgumentList args)
		{
			string strOutput = null;
			var sb = new System.Text.StringBuilder();
			
			using (var memstream = new MemoryStream())
			{
				var ser = new XmlSerializer(source1.GetType());
				ser.Serialize(memstream, source1);
				memstream.Position = 0;

				var settings = new XmlReaderSettings();
				settings.IgnoreWhitespace = true;
				using (var xr = XmlReader.Create(memstream, settings))
				{
					xr.MoveToContent();
					using (TextWriter xtw = new StringWriter(sb))
					{
						var xslt = new XslCompiledTransform();// Mvp.Xml.Exslt.ExsltTransform();

						xslt.Load(transformer);
						xslt.Transform(xr, args, xtw);
						xtw.Flush();
						xtw.Close();
						xtw.Dispose();
						
					}
					xr.Close();
					xr.Dispose();
				}
				memstream.Close();
				memstream.Dispose();
				ser = null;
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
			else if (request.Year > 0)
			{
				request.StartDate = new DateTime(request.Year, 1, 1).Date;
				request.EndDate = new DateTime(request.Year, 12, 31).Date;
			}
			else
			{
				request.StartDate = new DateTime(DateTime.Now.Year, 1, 1).Date;
				request.EndDate = new DateTime(DateTime.Now.Year, 12, 31).Date;
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

