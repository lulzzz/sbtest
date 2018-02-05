using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Reflection;
using System.Resources;
using System.Runtime.Remoting.Messaging;
using System.Threading.Tasks;
using System.Web.Http;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;
using HrMaxxAPI.Code.Filters;
using HrMaxxAPI.Code.Helpers;
using HrMaxxAPI.Controllers.Companies;
using HrMaxxAPI.Resources.OnlinePayroll;
using HrMaxxAPI.Resources.Payroll;
using Newtonsoft.Json;

namespace HrMaxxAPI.Controllers.Payrolls
{
	public class PayrollController : BaseApiController
	{
		private readonly IPayrollService _payrollService;
		private readonly IDocumentService _documentService;
		private readonly IFileRepository _fileRepository;
		private readonly ITaxationService _taxationService;
		private readonly ICompanyService _companyService;
		private readonly IExcelService _excelService;
		private readonly IReaderService _readerService;
		
		public PayrollController(IPayrollService payrollService, IDocumentService documentService, ITaxationService taxationService, ICompanyService companyService, IExcelService excelService, IReaderService readerService, IFileRepository fileRepository)
		{
			_payrollService = payrollService;
			_documentService = documentService;
			_taxationService = taxationService;
			_companyService = companyService;
			_excelService = excelService;
			_readerService = readerService;
			_fileRepository = fileRepository;
		}

		[HttpGet]
		[Route(PayrollRoutes.FillPayCheckNormalized)]
		public HttpStatusCode FillPayCheckNormalized()
		{
			try
			{
				var payChecks = _readerService.GetPayChecks();
				var ptaccums = new List<PayCheckPayTypeAccumulation>();
				var pttaxes = new List<PayCheckTax>();
				var ptcomps = new List<PayCheckCompensation>();
				var ptdeds = new List<PayCheckDeduction>();
				var ptcodes = new List<PayCheckPayCode>();
				var ptwcs = new List<PayCheckWorkerCompensation>();
				payChecks.ForEach(pc => pc.Accumulations.ForEach(a =>
				{
					var ptaccum = new PayCheckPayTypeAccumulation
					{
						PayCheckId = pc.Id,
						PayTypeId = a.PayType.PayType.Id,
						FiscalEnd = a.FiscalEnd,
						FiscalStart = a.FiscalStart,
						AccumulatedValue = a.AccumulatedValue,
						Used = a.Used,
						CarryOver = a.CarryOver
					};
					ptaccums.Add(ptaccum);
				}));
				payChecks.ForEach(pc => pc.Taxes.ForEach(t =>
				{
					var pt = new PayCheckTax()
					{
						PayCheckId = pc.Id,
						TaxId = t.Tax.Id,
						TaxableWage = t.TaxableWage,
						Amount = t.Amount
					};
					pttaxes.Add(pt);
				}));
				payChecks.ForEach(pc => pc.Compensations.ForEach(t =>
				{
					var pt = new PayCheckCompensation()
					{
						PayCheckId = pc.Id,
						PayTypeId = t.PayType.Id,
						Amount = t.Amount
					};
					ptcomps.Add(pt);
				}));
				payChecks.ForEach(pc => pc.Deductions.ForEach(t =>
				{
					var pt = new PayCheckDeduction()
					{
						PayCheckId = pc.Id,
						EmployeeDeductionId = t.EmployeeDeduction.Id,
						CompanyDeductionId=t.Deduction.Id,
						EmployeeDeductionFlat = JsonConvert.SerializeObject(t.EmployeeDeduction),
						Method = t.Method, Rate = t.Rate, AnnualMax = t.AnnualMax,
						Amount = t.Amount, Wage = t.Wage
					};
					ptdeds.Add(pt);
				}));
				payChecks.ForEach(pc => pc.PayCodes.ForEach(t =>
				{
					var pt = new PayCheckPayCode()
					{
						PayCheckId = pc.Id,
						PayCodeId = t.PayCode.Id,
						PayCodeFlat = JsonConvert.SerializeObject(t.PayCode),
						Amount = t.Amount,
						Overtime = t.OvertimeAmount
					};
					ptcodes.Add(pt);
				}));
				payChecks.Where(pc=>pc.WorkerCompensation!=null).ToList().ForEach(pc =>
				
				{
					var pt = new PayCheckWorkerCompensation()
					{
						PayCheckId = pc.Id,
						WorkerCompensationId = pc.WorkerCompensation.WorkerCompensation.Id,
						WorkerCompensationFlat = JsonConvert.SerializeObject(pc.WorkerCompensation.WorkerCompensation),
						Amount = pc.WorkerCompensation.Amount,
						Wage = pc.WorkerCompensation.Wage
					};
					ptwcs.Add(pt);
				});
				_payrollService.SavePayCheckWorkerCompensation(ptwcs);
				_payrollService.SavePayCheckPayCodes(ptcodes);
				_payrollService.SavePayCheckDeductions(ptdeds);
				_payrollService.SavePayCheckCompensations(ptcomps);
				_payrollService.SavePayCheckTaxes(pttaxes);
				_payrollService.SavePayCheckPayTypeAccumulations(ptaccums);
				return HttpStatusCode.OK;
			}
			catch (Exception)
			{

				return HttpStatusCode.ExpectationFailed;
			}
		}

		[HttpGet]
		[Route(PayrollRoutes.FixCompanyCubes)]
		public HttpStatusCode FixCompanyCubes(int year)
		{
			try
			{
				var companies = _readerService.GetCompanies(); //_companyService.GetAllCompanies();
				companies.ForEach(c =>
				{
					var payrolls = _readerService.GetPayrolls(c.Id, new DateTime(year, 1, 1).Date,
					new DateTime(year, 12, 31));
					if (payrolls.Any())
					{
						//_dashboardService.FixCompanyCubes(payrolls, c.Id, year);
					}
				});
				return HttpStatusCode.OK;
			}
			catch (Exception)
			{

				return HttpStatusCode.ExpectationFailed;
			}
		}

		[HttpGet]
		[Route(PayrollRoutes.FixCubesByCompany)]
		public HttpStatusCode FixCompanyCubes(Guid companyId, int year)
		{
			try
			{
				var company = _readerService.GetCompany(companyId); //_companyService.GetAllCompanies();
				var payrolls = _readerService.GetPayrolls(company.Id, new DateTime(year, 1, 1).Date,
					new DateTime(year, 12, 31));
				if (payrolls.Any())
				{
					//_dashboardService.FixCompanyCubes(payrolls, company.Id, year);
				}
				return HttpStatusCode.OK;
			}
			catch (Exception)
			{

				return HttpStatusCode.ExpectationFailed;
			}
		}

		[HttpGet]
		[Route(PayrollRoutes.FixInvoices)]
		public List<Guid> FixInvoiceData()
		{
			try
			{
				return _payrollService.FixInvoiceData();
				
			}
			catch (Exception e)
			{

				throw e;
			}
		}

		[HttpGet]
		[Route(PayrollRoutes.FixPayrollDataForCompany)]
		public HttpStatusCode FixPayrollData(Guid companyId)
		{
			var done = MakeServiceCall(() => _payrollService.FixPayrollData(companyId), "Fix payroll data for company id =" + companyId, true);
			if (done != null)
				return HttpStatusCode.OK;
			return HttpStatusCode.ExpectationFailed;
		}
		[HttpGet]
		[Route(PayrollRoutes.FixPayrollData)]
		public HttpStatusCode FixPayrollData()
		{
			var done = MakeServiceCall(() => _payrollService.FixPayrollData(null), "Fix payroll data for all companies", true);
			if (done != null)
				return HttpStatusCode.OK;
			return HttpStatusCode.ExpectationFailed;
		}


		[HttpPost]
		[Route(PayrollRoutes.Print)]
		[DeflateCompression]
		public HttpResponseMessage GetDocument(PayrollPrintRequest request)
		{
			var printedCheck = MakeServiceCall(() => _payrollService.PrintPayCheck(request.PayCheckId), "print check by payroll id and check id", true);
			return Printed(printedCheck);	
			
			
		}

		[HttpPost]
		[Route(PayrollRoutes.PrintPayrollReport)]
		[DeflateCompression]
		public HttpResponseMessage PrintPayrollReport(PayrollResource payroll)
		{
			var mapped = Mapper.Map<PayrollResource, Payroll>(payroll);
			var printed = MakeServiceCall(() => _payrollService.PrintPayrollReport(mapped), "print all check for payroll with id " + mapped.Id, true);
			return Printed(printed);
		}
		[HttpPost]
		[Route(PayrollRoutes.PrintPayrollTimesheet)]
		[DeflateCompression]
		public HttpResponseMessage PrintPayrollTimesheet(PayrollResource payroll)
		{
			var mapped = Mapper.Map<PayrollResource, Payroll>(payroll);
			var printed = MakeServiceCall(() => _payrollService.PrintPayrollTimesheet(mapped), "print payroll timesheet", true);
			return Printed(printed);
		}

		[HttpGet]
		[Route(PayrollRoutes.PrintPayrollChecks)]
		[DeflateCompression]
		public HttpResponseMessage PrintPayrollChecks(Guid payrollId, bool reprint, int companyCheckPrintOrder)
		{
			var queueItem = _taxationService.GetConfirmPayrollQueueItem(payrollId);
			if(queueItem!=null)
				throw new HttpResponseException(new HttpResponseMessage
				{
					StatusCode = HttpStatusCode.InternalServerError,
					ReasonPhrase = "The PDF file is not ready for this payroll. Please try again later"
				});
			
			if (!reprint && _documentService.DocumentExists(payrollId))
			{
				_payrollService.MarkPayrollPrinted(payrollId);
				return Printed(new FileDto()
					{
						DocumentId = payrollId,
						Data = _fileRepository.GetFile(payrollId + ".pdf"),
						Filename = payrollId.ToString(),
						DocumentExtension = ".pdf",
						MimeType = "application/pdf"
					});
				
			}
			var printed = MakeServiceCall(() => _payrollService.PrintPayrollChecks(payrollId, companyCheckPrintOrder), "print all check for payroll with id " + payrollId, true);
			return Printed(printed);
		}

		[HttpGet]
		[Route(PayrollRoutes.PrintPayrollPaySlips)]
		[DeflateCompression]
		public HttpResponseMessage PrintPayrollPaySlips(Guid payrollId)
		{
			var printed = MakeServiceCall(() => _payrollService.PrintPayrollPayslips(payrollId), "print all pay slips for payroll with id " + payrollId, true);
			return Printed(printed);
		}

		[HttpGet]
		[Route(PayrollRoutes.PrintPayCheckPaySlip)]
		[DeflateCompression]
		public HttpResponseMessage PrintPayCheckPaySlip(Guid payrollId, int checkId)
		{
			var printed = MakeServiceCall(() => _payrollService.PrintPaySlip(checkId), string.Format("print payslip with id={0}", checkId), true);
			return Printed(printed);
		}

		[HttpGet]
		[Route(PayrollRoutes.MarkPayCheckPrinted)]
		public void MarkPayCheckPrinted(int payCheckId)
		{
			MakeServiceCall(() => _payrollService.MarkPayCheckPrinted(payCheckId), "mark paycheck printed");
		}

		[HttpGet]
		[Route(PayrollRoutes.ReIssuePayCheck)]
		public void ReIssuePayCheck(int payCheckId)
		{
			MakeServiceCall(() => _payrollService.ReIssuePayCheck(payCheckId), "re issue Check");
			
		}

		private HttpResponseMessage Printed(FileDto document)
		{
			var response = new HttpResponseMessage { Content = new StreamContent(new MemoryStream(document.Data)) };
			response.Content.Headers.ContentType = new MediaTypeHeaderValue(document.MimeType);

			response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
			{
				FileName = document.Filename +  document.DocumentExtension
			};
			return response;
		}

		[HttpPost]
		[Route(PayrollRoutes.Payrolls)]
		[DeflateCompression]
		public List<PayrollResource> GetPayrolls(PayrollFilterResource filter)
		{
			var payrolls = MakeServiceCall(() => _readerService.GetPayrolls(filter.CompanyId, filter.StartDate, filter.EndDate, true), string.Format("get list of payrolls for company={0}", filter.CompanyId));
			if (filter.WithoutInvoice.HasValue)
			{
				payrolls = payrolls.Where(p => !p.IsHistory && !p.IsVoid && ( !p.InvoiceId.HasValue || p.InvoiceStatus == InvoiceStatus.Draft)).ToList();
			}
			if (payrolls.Any(p => p.IsQueued))
			{
				var p = payrolls.First(p1=>p1.IsQueued);
				p.QueuePosition = _taxationService.GetConfirmPayrollQueueItemIndex(p.Id);
			}
			return Mapper.Map<List<Payroll>, List<PayrollResource>>(payrolls);
		}

		[HttpPost]
		[Route(PayrollRoutes.IsPayrollConfirmed)]
		public PayrollResource IsPayrollConfirmed(PayrollResource payroll)
		{
			var queueItem = _taxationService.GetConfirmPayrollQueueItem(payroll.Id.Value);
			if (queueItem != null && !queueItem.ConfirmedTime.HasValue)
			{
				payroll.QueuePosition = _taxationService.GetConfirmPayrollQueueItemIndex(queueItem);
				return payroll;
			}
				
			var payrolls = MakeServiceCall(() => _readerService.GetPayroll(payroll.Id.Value), string.Format("get payroll with id={0}", payroll.Id));
			if (payrolls.IsQueued)
			{
				payrolls.QueuePosition = _taxationService.GetConfirmPayrollQueueItemIndex(payrolls.Id);
			}
			return Mapper.Map<Payroll, PayrollResource>(payrolls);
		}

		[HttpGet]
		[Route(PayrollRoutes.CompanyPayrolls)]
		[DeflateCompression]
		public List<PayrollMinifiedResource> CompanyPayrolls(Guid companyId)
		{
			var payrolls = MakeServiceCall(() => _readerService.GetMinifiedPayrolls(companyId: companyId));
			return Mapper.Map<List<PayrollMinified>, List<PayrollMinifiedResource>>(payrolls);
		}

		[HttpGet]
		[Route(PayrollRoutes.CompanyPayrollsForRelocation)]
		[DeflateCompression]
		public List<PayrollMinifiedResource> CompanyPayrollsForRelocation(Guid companyId)
		{
			var payrolls = MakeServiceCall(() => _readerService.GetMinifiedPayrolls(companyId: companyId, excludeVoids:1));
			payrolls = payrolls.Where(p => !p.IsHistory && (!p.InvoiceId.HasValue || p.InvoiceStatus < 4)).ToList();
			return Mapper.Map<List<PayrollMinified>, List<PayrollMinifiedResource>>(payrolls);
		}

		[HttpGet]
		[Route(PayrollRoutes.UnPrintedPayrolls)]
		[DeflateCompression]
		public List<PayrollMinifiedResource> GetUnPrintedPayrolls()
		{
			var payrolls = MakeServiceCall(() => _readerService.GetMinifiedPayrolls(null, isprinted: false, excludeVoids:1), string.Format("get list of un printed payrolls "));
			payrolls = payrolls.Where(p => !p.IsHistory).ToList();
			return Mapper.Map<List<PayrollMinified>, List<PayrollMinifiedResource>>(payrolls);
		}

		[HttpPost]
		[Route(PayrollRoutes.UpdatePayrollDates)]
		[DeflateCompression]
		public HttpStatusCode UpdatePayrollDates(PayrollResource resource)
		{
			resource.PayChecks.ForEach(p =>
			{
				p.StartDate = resource.StartDate;
				p.EndDate = resource.EndDate;
				p.PayDay = resource.PayDay;
			});
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(resource);

			MakeServiceCall(() => _payrollService.UpdatePayrollDates(mappedResource), string.Format("update payroll dates for id={0}", resource.Id));
			return HttpStatusCode.OK;
		}
		[HttpPost]
		[Route(PayrollRoutes.UpdatePayrollCheckNumbers)]
		[DeflateCompression]
		public PayrollResource UpdatePayrollCheckNumbers(PayrollResource resource)
		{
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(resource);

			var payroll = MakeServiceCall(() => _payrollService.UpdatePayrollCheckNumbers(mappedResource), string.Format("update payroll check numbers for id={0} to {1}", resource.Id, resource.StartingCheckNumber));
			return Mapper.Map<Payroll, PayrollResource>(payroll);
		}

		[HttpPost]
		[Route(PayrollRoutes.UpdateAccumulation)]
		[DeflateCompression]
		public HttpStatusCode UpdateAccumulation(PayCheckAccumulation resource)
		{
			var accumulation = Mapper.Map<PayTypeAccumulationResource, PayTypeAccumulation>(resource.Accumulation);

			MakeServiceCall(() => _payrollService.UpdatePayCheckAccumulation(resource.PayCheckId, accumulation, CurrentUser.FullName, CurrentUser.UserId), string.Format("update pay check accumulation for id={0} and accumulation type={1}", resource.PayCheckId, accumulation.PayType.PayType.Description));
			return HttpStatusCode.OK;
		}

		[HttpPost]
		[Route(PayrollRoutes.ProcessPayroll)]
		[DeflateCompression]
		public PayrollResource ProcessPayroll(PayrollResource resource)
		{
			resource.PayChecks.ForEach(p =>
			{
				p.StartDate = resource.StartDate;
				p.EndDate = resource.EndDate;
				p.PayDay = resource.PayDay;
			});
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(resource);
			
			var processed = MakeServiceCall(() => _payrollService.ProcessPayroll(mappedResource), string.Format("process payrolls for company={0}", resource.Company.Id));
			return Mapper.Map<Payroll, PayrollResource>(processed);
		}

		[HttpPost]
		[Route(PayrollRoutes.CommitPayroll)]
		[DeflateCompression]
		public PayrollResource CommitPayroll(PayrollResource resource)
		{
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(resource);
			mappedResource.PayChecks.ForEach(p =>
			{
				p.PayrollId = mappedResource.Id;
				p.LastModified = DateTime.Now;
				p.LastModifiedBy = CurrentUser.FullName;
			});
			var processed = MakeServiceCall(() => _payrollService.ConfirmPayroll(mappedResource), string.Format("commit payrolls for company={0}", resource.Company.Id));
			return Mapper.Map<Payroll, PayrollResource>(processed);
		}
		[HttpPost]
		[Route(PayrollRoutes.ReQueuePayroll)]
		[DeflateCompression]
		public PayrollResource ReQueuePayroll(PayrollResource resource)
		{
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(resource);
			
			var requeued = MakeServiceCall(() => _payrollService.ReQueuePayroll(mappedResource), string.Format("requeue payrolls for id={0}", resource.Id));
			return Mapper.Map<Payroll, PayrollResource>(requeued);

		}

		[HttpPost]
		[Route(PayrollRoutes.ReProcessReConfirmPayroll)]
		[DeflateCompression]
		public PayrollResource ReProcessReConfirmPayroll(PayrollResource resource)
		{
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(resource);
			mappedResource.UserName = CurrentUser.FullName;
			mappedResource.UserId = new Guid(CurrentUser.UserId);
			mappedResource.PayChecks.ForEach(p =>
			{
				p.LastModified = DateTime.Now;
				p.LastModifiedBy = CurrentUser.FullName;
			});
			var processed = MakeServiceCall(() => _payrollService.ReProcessReConfirmPayroll(mappedResource), string.Format("re process and re confirm payrolls for company={0}", resource.Company.Id));
			return Mapper.Map<Payroll, PayrollResource>(processed);
		}
		[HttpPost]
		[Route(PayrollRoutes.SaveProcessedPayroll)]
		[DeflateCompression]
		public PayrollResource SaveProcessedPayroll(PayrollResource resource)
		{
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(resource);
			mappedResource.PayChecks.ForEach(p =>
			{
				p.PayrollId = mappedResource.Id;
				p.LastModified = DateTime.Now;
				p.LastModifiedBy = CurrentUser.FullName;
			});
			var processed = MakeServiceCall(() => _payrollService.SaveProcessedPayroll(mappedResource), string.Format("save payroll to staging for company={0}", resource.Company.Id));
			return Mapper.Map<Payroll, PayrollResource>(processed);
		}

		[HttpPost]
		[Route(PayrollRoutes.DeleteDraftPayroll)]
		public PayrollResource DeleteDraftPayroll(PayrollResource resource)
		{
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(resource);
			if(mappedResource.Status!=PayrollStatus.Draft)
				throw new Exception("Only draft payrolls can be deleted from the system");
			var processed = MakeServiceCall(() => _payrollService.DeleteDraftPayroll(mappedResource), string.Format("delete draft payroll from staging for company={0}", resource.Company.Id));
			return Mapper.Map<Payroll, PayrollResource>(processed);
		}
		[HttpPost]
		[Route(PayrollRoutes.DeletePayroll)]
		public PayrollResource DeletePayroll(PayrollResource resource)
		{
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(resource);
			
			var processed = MakeServiceCall(() => _payrollService.DeletePayroll(mappedResource), string.Format("delete payroll for company={0} with Id={1}", resource.Company.Id, resource.Id));
			return Mapper.Map<Payroll, PayrollResource>(processed);
		}


		[HttpPost]
		[Route(PayrollRoutes.VoidPayroll)]
		[DeflateCompression]
		public PayrollResource VoidPayroll(PayrollResource resource)
		{
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(resource);
			var processed = MakeServiceCall(() => _payrollService.VoidPayroll(mappedResource, CurrentUser.FullName, CurrentUser.UserId), string.Format("Void all pay checks and invocie for Payroll={0}", resource.Id));
			return Mapper.Map<Payroll, PayrollResource>(processed);
		}

		[HttpGet]
		[Route(PayrollRoutes.VoidPayCheck)]
		[DeflateCompression]
		public PayrollResource CommitPayroll(Guid payrollId, int payCheckId)
		{
			var voided = MakeServiceCall(() => _payrollService.VoidPayCheck(payrollId, payCheckId, CurrentUser.FullName, CurrentUser.UserId), string.Format("void paycheck in payroll={0} with id={1}",payrollId, payCheckId));
			return Mapper.Map<Payroll, PayrollResource>(voided);
		}

		[HttpGet]
		[Route(PayrollRoutes.UnVoidPayCheck)]
		[DeflateCompression]
		public PayrollResource UnVoidPayCheck(Guid payrollId, int payCheckId)
		{
			var voided = MakeServiceCall(() => _payrollService.UnVoidPayCheck(payrollId, payCheckId, CurrentUser.FullName, CurrentUser.UserId), string.Format("void paycheck in payroll={0} with id={1}", payrollId, payCheckId));
			return Mapper.Map<Payroll, PayrollResource>(voided);
		}

		[HttpPost]
		[Route(PayrollRoutes.MovePayrolls)]
		[DeflateCompression]
		public HttpStatusCode MovePayrolls(MoveCopyPayrollRequest request)
		{
			MakeServiceCall(() => _payrollService.MovePayrolls(request.SourceId, request.TargetId, new Guid(CurrentUser.UserId), CurrentUser.FullName, request.MoveAll, request.Payrolls, request.AsHistory), string.Format("move payrolls from {0}  to {1}", request.SourceId, request.TargetId));
			return HttpStatusCode.OK;
		}
		[HttpPost]
		[Route(PayrollRoutes.CopyPayrolls)]
		[DeflateCompression]
		public HttpStatusCode CopyPayrolls(MoveCopyPayrollRequest request)
		{
			MakeServiceCall(() => _payrollService.CopyPayrolls(request.SourceId, request.TargetId, new Guid(CurrentUser.UserId), CurrentUser.FullName, request.MoveAll, request.Payrolls, request.AsHistory), string.Format("move payrolls from {0}  to {1}", request.SourceId, request.TargetId));
			return HttpStatusCode.OK;
		}

		[HttpGet]
		[Route(PayrollRoutes.PayCheck)]
		[DeflateCompression]
		public PayCheckResource GetPayCheck(int checkId)
		{
			var check = MakeServiceCall(() => _readerService.GetPaycheck(checkId), string.Format("get paycheck with id={0}", checkId));
			return Mapper.Map<PayCheck, PayCheckResource>(check);
		}

		
		[HttpGet]
		[Route(PayrollRoutes.PrintPayCheck)]
		[DeflateCompression]
		public FileDto PrintPayCheck(Guid payrollId, int checkId)
		{
			return MakeServiceCall(() => _payrollService.PrintPayCheck(checkId), string.Format("print paycheck with id={0}", checkId), true);
			
		}
		

		[HttpPost]
		[Route(PayrollRoutes.CreatePayrollInvoice)]
		[DeflateCompression]
		public PayrollInvoiceResource CreatePayrollInvoice(PayrollResource payroll)
		{
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(payroll);
			var processed = MakeServiceCall(() => _payrollService.CreatePayrollInvoice(mappedResource, CurrentUser.FullName, new Guid(CurrentUser.UserId), true), string.Format("create payroll invoice for payroll={0}", payroll.Id));
			var returnInvocie = Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(processed);
			returnInvocie.TaxPaneltyConfig = _taxationService.GetApplicationConfig().InvoiceLateFeeConfigs;
			return returnInvocie;
		}

		[HttpPost]
		[Route(PayrollRoutes.PayrollInvoice)]
		[DeflateCompression]
		public PayrollInvoiceResource SavePayrollInvoice(PayrollInvoiceResource invoice)
		{
			var mappedResource = Mapper.Map<PayrollInvoiceResource, PayrollInvoice>(invoice);
			mappedResource.LastModified = DateTime.Now;
			mappedResource.UserName = CurrentUser.FullName;
			mappedResource.InvoicePayments.Where(ip=>ip.HasChanged).ToList().ForEach(ip =>
			{
				ip.LastModifiedBy = CurrentUser.FullName;
				ip.LastModified = mappedResource.LastModified;

			});

			var processed = MakeServiceCall(() => _payrollService.SavePayrollInvoice(mappedResource), string.Format("save payroll invoice for invoice={0}", invoice.Id));
			var returnInvocie = Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(processed);
			returnInvocie.TaxPaneltyConfig = _taxationService.GetApplicationConfig().InvoiceLateFeeConfigs;
			return returnInvocie;
		}

		[HttpPost]
		[Route(PayrollRoutes.PayrollInvoices)]
		[DeflateCompression]
		public List<PayrollInvoiceListItemResource> GetPayrollInvoices(PayrollInvoiceFilterResource resource)
		{
			
			var invoices = MakeServiceCall(() => _readerService.GetPayrollInvoiceList(CurrentUser.Host, companyId: resource.CompanyId, status: resource.Status, startDate: resource.StartDate, endDate: resource.EndDate, paymentStatuses: resource.PaymentStatus, paymentMethods:resource.PaymentMethod, includeTaxesDelayed: resource.IncludeDelayedTaxes), string.Format("get invoices for host with id={0}", CurrentUser.Host));
			if (CurrentUser.Role == RoleTypeEnum.HostStaff.GetDbName() || CurrentUser.Role == RoleTypeEnum.Host.GetDbName())
			{
				invoices = invoices.Where(i => !i.IsHostCompany && i.IsVisibleToHost).ToList();
			}
			var appConfig = _taxationService.GetApplicationConfig();
			if (CurrentUser.Role == RoleTypeEnum.CorpStaff.GetDbName() && appConfig.RootHostId.HasValue)
			{
				invoices = invoices.Where(i => !(i.HostId == appConfig.RootHostId && i.IsHostCompany)).ToList();
			}
			var result = Mapper.Map<List<PayrollInvoiceListItem>, List<PayrollInvoiceListItemResource>>(invoices);
			var ic = _taxationService.GetApplicationConfig().InvoiceLateFeeConfigs;
			result.ForEach(i => i.TaxPaneltyConfig = ic);
			return result;
		}

		[HttpGet]
		[Route(PayrollRoutes.ApprovedInvoices)]
		[DeflateCompression]
		public List<PayrollInvoiceListItemResource> GetApprovedInvoices()
		{
			var invoices = MakeServiceCall(() => _readerService.GetPayrollInvoiceList(CurrentUser.Host, status: new List<InvoiceStatus>(){InvoiceStatus.Submitted}), string.Format("get approved invoices for host with id={0}", CurrentUser.Host));
			var result = Mapper.Map<List<PayrollInvoiceListItem>, List<PayrollInvoiceListItemResource>>(invoices);
			var ic = _taxationService.GetApplicationConfig().InvoiceLateFeeConfigs;
			result.ForEach(i => i.TaxPaneltyConfig = ic);
			return result;
		}
		[HttpGet]
		[Route(PayrollRoutes.DeletePayrollInvoice)]
		public void DeletePayrollInvoice(Guid invoiceId)
		{
			MakeServiceCall(() => _payrollService.DeletePayrollInvoice(invoiceId, new Guid(CurrentUser.UserId), CurrentUser.FullName), string.Format("delete invoice with id={0}", invoiceId));
			
		}
		[HttpGet]
		[Route(PayrollRoutes.GetInvoiceById)]
		public PayrollInvoiceResource GetInvoiceById(Guid invoiceId)
		{
			var invoice = MakeServiceCall(() => _readerService.GetPayrollInvoice(invoiceId), string.Format("get invoice with id={0}", invoiceId));
			return Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(invoice);

		}
		[HttpGet]
		[Route(PayrollRoutes.RecreateInvoice)]
		[DeflateCompression]
		public PayrollInvoiceResource RecreateInvoice(Guid invoiceId)
		{
			var invoice = MakeServiceCall(() => _payrollService.RecreateInvoice(invoiceId, CurrentUser.FullName, new Guid(CurrentUser.UserId)), string.Format("recreate invoice with id={0}", invoiceId));
			return Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(invoice);
		}

		[HttpGet]
		[Route(PayrollRoutes.DelayTaxes)]
		[DeflateCompression]
		public PayrollInvoiceResource DelayTaxes(Guid invoiceId)
		{
			var invoice = MakeServiceCall(() => _payrollService.DelayTaxes(invoiceId, CurrentUser.FullName), string.Format("delay taxes on invoice with id={0}", invoiceId));
			return Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(invoice);
		}
		[HttpPost]
		[Route(PayrollRoutes.RedateInvoice)]
		[DeflateCompression]
		public PayrollInvoiceResource RedateInvoice(PayrollInvoiceResource resource)
		{
			var mapped = Mapper.Map<PayrollInvoiceResource, PayrollInvoice>(resource);
			mapped.UserName = CurrentUser.FullName;
			var invoice = MakeServiceCall(() => _payrollService.RedateInvoice(mapped), string.Format("redate invoice with id={0}", mapped.Id));
			return Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(invoice);
		}

		[HttpPost]
		[Route(PayrollRoutes.ClaimDelivery)]
		[DeflateCompression]
		public InvoiceDeliveryClaim ClaimDelivery(List<Guid> invoiceIds)
		{
			return MakeServiceCall(() => _payrollService.ClaimDelivery(invoiceIds, CurrentUser.FullName, new Guid(CurrentUser.UserId)), string.Format("claim delivery of invoices with ids={0}", invoiceIds));
			
		}
		[HttpPost]
		[Route(PayrollRoutes.SaveInvoiceDelivery)]
		public void SaveInvoiceDelivery(InvoiceDeliveryClaim claim)
		{
			MakeServiceCall(() => _payrollService.SaveClaimDelivery(claim), string.Format("update claim delivery"));

		}

		[HttpPost]
		[Route(PayrollRoutes.InvoiceDeliveryClaims)]
		[DeflateCompression]
		public List<InvoiceDeliveryClaim> GetInvoiceDeliveryClaims(PayrollFilterResource request)
		{
			return MakeServiceCall(() => _payrollService.GetInvoiceDeliveryClaims(request.StartDate, request.EndDate), "Get Invoice Delivery Claims");
		}

		[HttpPost]
		[Route(PayrollRoutes.SaveEmployeeAccumulation)]
		[DeflateCompression]
		public PayCheckPayTypeAccumulationResource SaveEmployeeAccumulation(PayCheckPayTypeAccumulationResource request)
		{
			var mapped = Mapper.Map<PayCheckPayTypeAccumulationResource, PayCheckPayTypeAccumulation>(request);
			var result = MakeServiceCall(() => _payrollService.UpdateEmployeeAccumulation(mapped, request.NewFiscalStart, request.NewFiscalEnd, request.EmployeeId), "update employee accumulation");
			return Mapper.Map<PayCheckPayTypeAccumulation, PayCheckPayTypeAccumulationResource>(result);
		}

		[HttpGet]
		[Route(PayrollRoutes.FixPayrollYTD)]
		[DeflateCompression]
		public HttpStatusCode FixPayrollYTD(Guid payrollId)
		{
			
			MakeServiceCall(() => _payrollService.FixPayrollYTD(payrollId), "Fix Payroll YTD for " + payrollId);
			return HttpStatusCode.OK;
		}

		[HttpGet]
		[Route(PayrollRoutes.EmployeeChecks)]
		[DeflateCompression]
		public List<PayCheck> GetEmployeeChecks(Guid companyId, Guid employeeId)
		{
			return MakeServiceCall(() => _readerService.GetPayChecks(companyId:companyId, employeeId:employeeId, isvoid:0), "Get Pay Check for employee");
		}
		
		[HttpPost]
		[Route(PayrollRoutes.ImportTimesheetsTemplate)]
		public HttpResponseMessage GetTimesheetImportTemplate(TimesheetImportResource resource)
		{

			var printed = MakeServiceCall(() => _excelService.GetTimesheetImportTemplate(resource.CompanyId, resource.PayTypes.Select(p=>p.Name).ToList()), "get timesheet import template for " + resource.CompanyId, true);
			var response = new HttpResponseMessage { Content = new StreamContent(new MemoryStream(printed.Data)) };
			response.Content.Headers.ContentType = new MediaTypeHeaderValue(printed.MimeType);

			response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
			{
				FileName = printed.Filename
			};
			return response;
		}
		/// <summary>
		/// Upload Entity Document for a given entity
		/// </summary>
		/// <returns></returns>
		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(PayrollRoutes.ImportTimesheets)]
		[DeflateCompression]
		public async Task<HttpResponseMessage> ImportTimesheets()
		{
			var filename = string.Empty;
			try
			{
				var fileUploadObj = await ProcessMultipartContent();
				filename = fileUploadObj.file.FullName;
				var company = Mapper.Map<Company, CompanyResource>(_readerService.GetCompany(fileUploadObj.CompanyId));
				var importedRows = _excelService.ImportFromExcel(fileUploadObj.file, 2);
				var timesheets = new List<TimesheetResource>();
				var error = string.Empty;
				company.PayCodes.Add(new CompanyPayCodeResource
				{
					Code = "Default", Description = "Base Rate", CompanyId = company.Id.Value, Id=0, HourlyRate = 0
				});
				importedRows.ForEach(er =>
				{
					try
					{
						var timesheet = new TimesheetResource();
						timesheet.FillFromImport(er, company, fileUploadObj.PayTypes);
						timesheets.Add(timesheet);
					}
					catch (Exception ex)
					{
						error += ex.Message + "<br>";
					}
				});
				if (!string.IsNullOrWhiteSpace(error))
					throw new Exception(error);
				
				return this.Request.CreateResponse(HttpStatusCode.OK, timesheets);
			}
			catch (Exception e)
			{
				Logger.Error("Error importing timesheets", e);

				throw new HttpResponseException(new HttpResponseMessage
				{
					StatusCode = HttpStatusCode.InternalServerError,
					ReasonPhrase = e.Message
				});
			}
			finally
			{
				if (!string.IsNullOrWhiteSpace(filename))
					File.Delete(filename);
			}
		}

		/// <summary>
		/// Upload Entity Document for a given entity
		/// </summary>
		/// <returns></returns>
		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(PayrollRoutes.ImportTimesheetsWithMap)]
		[DeflateCompression]
		public async Task<HttpResponseMessage> ImportTimesheetsWithMap()
		{
			var filename = string.Empty;
			try
			{
				var fileUploadObj = await ProcessMultipartContentWithMap();
				filename = fileUploadObj.file.FullName;
				var company = Mapper.Map<Company, CompanyResource>(_readerService.GetCompany(fileUploadObj.CompanyId));
				var importedRows = _excelService.ImportWithMap(fileUploadObj.file, fileUploadObj.ImportMap, fileUploadObj.FileName);
				var timesheets = new List<TimesheetResource>();
				var error = string.Empty;
				company.PayCodes.Add(new CompanyPayCodeResource
				{
					Code = "Default",
					Description = "Base Rate",
					CompanyId = company.Id.Value,
					Id = 0,
					HourlyRate = 0
				});
				company.PayCodes.Add(new CompanyPayCodeResource
				{
					Code = "PieceRate",
					Description = "Piece-Rate",
					CompanyId = company.Id.Value,
					Id = -1,
					HourlyRate = 0
				});
				importedRows.ForEach(er =>
				{
					try
					{
						var timesheet = new TimesheetResource();
						timesheet.FillFromImportWithMap(er, company, fileUploadObj.PayTypes, fileUploadObj.ImportMap);
						timesheets.Add(timesheet);
					}
					catch (Exception ex)
					{
						error += ex.Message + "<br>";
					}
				});
				if (!string.IsNullOrWhiteSpace(error))
					throw new Exception(error);
				_companyService.SaveTSImportMap(company.Id.Value, fileUploadObj.ImportMap);
				return this.Request.CreateResponse(HttpStatusCode.OK, timesheets);
			}
			catch (Exception e)
			{
				Logger.Error("Error importing timesheets", e);

				throw new HttpResponseException(new HttpResponseMessage
				{
					StatusCode = HttpStatusCode.InternalServerError,
					ReasonPhrase = e.Message
				});
			}
			finally
			{
				if (!string.IsNullOrWhiteSpace(filename))
					File.Delete(filename);
			}
		}

		private async Task<TimesheetImportResource> ProcessMultipartContent()
		{
			if (!Request.Content.IsMimeMultipartContent())
			{
				throw new HttpResponseException(new HttpResponseMessage
				{
					StatusCode = HttpStatusCode.UnsupportedMediaType
				});
			}

			var provider = FileUploadHelpers.GetMultipartProvider();
			var result = await Request.Content.ReadAsMultipartAsync(provider);

			var fileUploadObj = FileUploadHelpers.GetFormData<TimesheetImportResource>(result);

			var originalFileName = FileUploadHelpers.GetDeserializedFileName(result.FileData.First());
			var uploadedFileInfo = new FileInfo(result.FileData.First().LocalFileName);
			fileUploadObj.FileName = originalFileName;
			fileUploadObj.file = uploadedFileInfo;
			return fileUploadObj;
		}
		private async Task<TimesheetImportWithMapResource> ProcessMultipartContentWithMap()
		{
			if (!Request.Content.IsMimeMultipartContent())
			{
				throw new HttpResponseException(new HttpResponseMessage
				{
					StatusCode = HttpStatusCode.UnsupportedMediaType
				});
			}

			var provider = FileUploadHelpers.GetMultipartProvider();
			var result = await Request.Content.ReadAsMultipartAsync(provider);

			var fileUploadObj = FileUploadHelpers.GetFormData<TimesheetImportWithMapResource>(result);

			var originalFileName = FileUploadHelpers.GetDeserializedFileName(result.FileData.First());
			var uploadedFileInfo = new FileInfo(result.FileData.First().LocalFileName);
			fileUploadObj.FileName = originalFileName;
			fileUploadObj.file = uploadedFileInfo;
			return fileUploadObj;
		}

	}


}