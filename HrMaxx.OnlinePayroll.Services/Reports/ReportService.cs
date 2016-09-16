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
		private readonly string _filePath;
		private readonly string _templatePath;

		private const string NoData = "No Payroll Data exists for this time period and company";
		private const string ReportNotAvailable = "The report template(s) are not available yet";
		
		public IBus Bus { get; set; }

		public ReportService(IReportRepository reportRepository, ICompanyRepository companyRepository, IJournalService journalService, IPDFService pdfService, ICommonService commonService, string filePath, string templatePath)
		{
			_reportRepository = reportRepository;
			_companyRepository = companyRepository;
			_journalService = journalService;
			_pdfService = pdfService;
			_filePath = filePath;
			_templatePath = templatePath;
			_commonService = commonService;
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
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, string.Format(" Get report data for report={0} {1}-{2}", request.ReportName, request.StartDate.ToString(), request.EndDate.ToString()));
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
				return null;
			}
			catch (Exception e)
			{
				var message = string.Empty;
				if (e.Message == NoData || e.Message == ReportNotAvailable)
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
			response.Company = _companyRepository.GetCompanyById(request.CompanyId);
			response.CompanyAccumulation = _reportRepository.GetCompanyPayrollCube(request);
			response.EmployeeAccumulations = getEmployeeAccumulations(response.CompanyAccumulation.PayChecks);
			
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
			response.Company = GetCompany(request.CompanyId);
			response.Contact = getCompanyContact(request.CompanyId);
				
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

		private Company GetCompany(Guid companyId)
		{
			return _companyRepository.GetCompanyById(companyId);
		}
		private Contact getCompanyContact(Guid companyId)
		{
			var contacts = _commonService.GetRelatedEntities<Contact>(EntityTypeEnum.Company, EntityTypeEnum.Contact,
					companyId);
			if (contacts.Any(c => c.IsPrimary))
			{
				return contacts.First(c => c.IsPrimary);
			}
			else
			{
				return contacts.FirstOrDefault();
			}
		}
		private List<CompanyPayrollCube> GetCompanyPayrollCubes(ReportRequest request)
		{
			var cubes = _reportRepository.GetCompanyCubesForYear(request.CompanyId, request.Year);
			if (cubes == null || !cubes.Any() )
			{
				throw new Exception(NoData);
			}
			var relevantCube = cubes.FirstOrDefault(c => ((request.Quarter>0 && request.Quarter==c.Quarter) || (request.Quarter==0 && !c.Quarter.HasValue)));
			if (relevantCube==null || relevantCube.Accumulation.GrossWage <= 0)
				throw new Exception(NoData);
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
