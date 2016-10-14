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
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Repository.Companies;
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
		private readonly string _filePath;
		private readonly string _templatePath;

		private const string NoData = "No Data exists for this time period and company";
		private const string NoPayrollData = "No Payroll Data exists for this time period and company";
		private const string ReportNotAvailable = "The report template(s) are not available yet";
		private const string HostNotSetUp = "Please set up the Host properly to proceed";
		private const string HostContactNA = "Please add at-least one contact for the Host";
		
		public IBus Bus { get; set; }

		public ReportService(IReportRepository reportRepository, ICompanyRepository companyRepository, IJournalService journalService, IPDFService pdfService, ICommonService commonService, IHostService hostService, string filePath, string templatePath)
		{
			_reportRepository = reportRepository;
			_companyRepository = companyRepository;
			_journalService = journalService;
			_pdfService = pdfService;
			_filePath = filePath;
			_templatePath = templatePath;
			_commonService = commonService;
			_hostService = hostService;
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

		public FileDto PrintPayrollWithSummary(Models.Payroll payroll, List<Guid> documents )
		{
			var fileName = string.Format("Payroll_{0}_{1}.pdf", payroll.Id, payroll.PayDay.ToString("MMddyyyy"));
			var xml = GetXml<Models.Payroll>(payroll);

			var transformed = TransformXml(xml,
				string.Format("{0}{1}", _templatePath, "transformers/payroll/payrollsummary.xslt"), new XsltArgumentList());

			var summary = _pdfService.PrintHtml(transformed.Reports.First());
			return _pdfService.AppendAllDocuments(payroll.Id, fileName, documents, summary.Data);
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
			response.Contact = getContactForEntity(EntityTypeEnum.Host, request.HostId);
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

		private Contact getContactForEntity(EntityTypeEnum source, Guid sourceId)
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
				if(contact==null)
					throw new Exception(HostContactNA);
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
			strOutput = strOutput.Replace("encoding=\"utf-16\"", string.Empty);
			var serializer = new XmlSerializer(typeof(ReportTransformed));
			var memStream = new MemoryStream(Encoding.UTF8.GetBytes(strOutput));
			return (ReportTransformed)serializer.Deserialize(memStream);
			
		}
	}
}

