using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxxAPI.Code.Filters;
using HrMaxxAPI.Code.Helpers;
using HrMaxxAPI.Resources.Common;
using HrMaxxAPI.Resources.OnlinePayroll;

namespace HrMaxxAPI.Controllers.Companies
{
  public class CompanyController : BaseApiController
  {
	  private readonly IMetaDataService _metaDataService;
		private readonly ICompanyService _companyService;
		private readonly IPayrollService _payrollService;
		private readonly IExcelService _excelServce ;
	  private readonly ITaxationService _taxationService;
	  private readonly IReaderService _readerService;
	  
	  public CompanyController(IMetaDataService metaDataService, ICompanyService companyService, IExcelService excelService, ITaxationService taxationService, IPayrollService payrollService, IReaderService readerService)
	  {
			_metaDataService = metaDataService;
		  _companyService = companyService;
		  _excelServce = excelService;
		  _taxationService = taxationService;
		  _payrollService = payrollService;
		  _readerService = readerService;
	  }

	  [HttpGet]
	  [Route(CompanyRoutes.FixEmployeePayCodes)]
	  public HttpStatusCode FixEmployeePayCodes(Guid companyId)
	  {
			var employees = _readerService.GetEmployees(company: companyId);
			employees.ForEach(e =>
			{
				if (e.PayCodes.Any(p => p.Id > 0))
				{
					e.PayCodes.Where(p => p.Id > 0).ToList().ForEach(pc =>
					{
						pc.CompanyId = companyId;
					});
					_companyService.SaveEmployee(e, false);
				}
			});
		  return HttpStatusCode.OK;
	  }

		[HttpPost]
		[Route(CompanyRoutes.CopyEmployees)]
		public HttpStatusCode CopyEmployees(CopyEmployeeResource resource)
		{
			MakeServiceCall(() => _companyService.CopyEmployees(resource.SourceCompanyId, resource.TargetCompanyId, resource.EmployeeIds, CurrentUser.FullName, resource.KeepEmployeeNumbers), "Copy employees from one company to another");
			return HttpStatusCode.OK;
		}

	  [HttpGet]
	  [Route(CompanyRoutes.MetaData)]
		[DeflateCompression]
	  public object GetMetaData()
	  {
			return MakeServiceCall(() => _metaDataService.GetCompanyMetaData(), "Get company meta data", true);
	  }

		[HttpGet]
		[Route(CompanyRoutes.PEOCompanies)]
		[DeflateCompression]
		public List<CompanySUIRate> PEOCompanies()
		{
			return MakeServiceCall(() => _metaDataService.GetPEOCompanies(), "Get PEO Companies", true);
		}

		[HttpGet]
		[Route(CompanyRoutes.EmployeeMetaData)]
		[DeflateCompression]
		public object GetEmployeeMetaData()
		{
			return MakeServiceCall(() => _metaDataService.GetEmployeeMetaData(), "Get employee meta data", true);
		}

		[HttpPost]
		[Route(CompanyRoutes.PayrollMetaData)]
		[DeflateCompression]
		public object GetPayrollMetaData(CheckBookMetaDataRequestResource request)
		{
			var r = Mapper.Map<CheckBookMetaDataRequestResource, CheckBookMetaDataRequest>(request);
			return MakeServiceCall(() => _metaDataService.GetPayrollMetaData(r), "Get payroll meta data", true);
		}

		[HttpGet]
		[Route(CompanyRoutes.InvoiceMetaData)]
		[DeflateCompression]
		public object GetInvoiceMetaData(Guid companyId)
		{
			return MakeServiceCall(() => _metaDataService.GetInvoiceMetaData(companyId), "Get invoice meta data", true);
		}

		[HttpGet]
		[Route(CompanyRoutes.CompanyList)]
		[DeflateCompression]
		public IList<CompanyResource> GetAllCompanies()
		{
			//var companies =  MakeServiceCall(() => _companyService.GetAllCompanies(), "Get companies for hosts", true);
			var companies = MakeServiceCall(() => _readerService.GetCompanies(), "Get companies for hosts", true);
			
			return Mapper.Map<List<HrMaxx.OnlinePayroll.Models.Company>, List<CompanyResource>>(companies.OrderBy(c => c.CompanyIntId).ToList());
		}
		[HttpGet]
		[Route(CompanyRoutes.MinifiedCompanyList)]
		[DeflateCompression]
		public HttpResponseMessage GetAllCompaniesMinified()
		{
			//var companies =  MakeServiceCall(() => _companyService.GetAllCompanies(), "Get companies for hosts", true);
			var companies = MakeServiceCall(() => _readerService.GetCompanies(), "Get companies for hosts", true);

			var returnString = new StringBuilder();
			companies.ForEach(c => returnString.AppendLine(string.Format("{0},{1},{2},{3},{4},{5},{6}", c.Id, c.CompanyNo, c.Name.Replace(",",""), c.FederalEIN,
				c.FederalPin, c.States.First().StateEIN, c.States.First().StatePIN)));
			var stream = new MemoryStream();
			var writer = new StreamWriter(stream);
			writer.Write(returnString.ToString());
			writer.Flush();
			stream.Position = 0;

			var result = new HttpResponseMessage(HttpStatusCode.OK);
			result.Content = new StreamContent(stream);
			result.Content.Headers.ContentType = new MediaTypeHeaderValue("text/csv");
			result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment") { FileName = "CompaniesExport.csv" };
			return result;
		}

		[HttpGet]
		[Route(CompanyRoutes.MinifiedEmployeeList)]
		[DeflateCompression]
		public HttpResponseMessage GetAllCompaniesAndEmployeesMinified()
		{
			//var companies =  MakeServiceCall(() => _companyService.GetAllCompanies(), "Get companies for hosts", true);
			var employees = MakeServiceCall(() => _readerService.GetEmployees(), "Get all employees", true);
			var companies = MakeServiceCall(() => _readerService.GetCompanies(), "Get companies for hosts", true);
			var returnString = new StringBuilder();
			employees.ForEach(e =>
			{
				var company = companies.First(c => c.Id == e.CompanyId);
				returnString.AppendLine(string.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9}", company.CompanyNo, company.Id,
					company.Name.Replace(",", ""), string.Format("{0}-{1}", company.Id, e.SSN), e.Id,
					e.CompanyEmployeeNo, e.EmployeeNo, e.FullName, e.SSN, e.CarryOver));
			});
			var stream = new MemoryStream();
			var writer = new StreamWriter(stream);
			writer.Write(returnString.ToString());
			writer.Flush();
			stream.Position = 0;

			var result = new HttpResponseMessage(HttpStatusCode.OK);
			result.Content = new StreamContent(stream);
			result.Content.Headers.ContentType = new MediaTypeHeaderValue("text/csv");
			result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment") { FileName = "EmployeeExport.csv" };
			return result;
		}

		[HttpGet]
		[Route(CompanyRoutes.Companies)]
		[DeflateCompression]
		public IList<CompanyResource> GetCompanies(Guid hostId)
		{
			//var companies =  MakeServiceCall(() => _companyService.GetCompanies(hostId, CurrentUser.Company), "Get companies for hosts", true);
			var companies = MakeServiceCall(() => _readerService.GetCompanies(host: hostId, company:(CurrentUser.Company==Guid.Empty? default(Guid?) : CurrentUser.Company)), "Get companies for hosts", true);
			if (CurrentUser.Role == RoleTypeEnum.HostStaff.GetDbName() || CurrentUser.Role == RoleTypeEnum.Host.GetDbName())
			{
				companies = companies.Where(c => !c.IsHostCompany && c.IsVisibleToHost).ToList();
			}
			var appConfig = _taxationService.GetApplicationConfig();
			if (CurrentUser.Role == RoleTypeEnum.CorpStaff.GetDbName() && appConfig.RootHostId.HasValue)
			{
				companies = companies.Where(c => !(c.HostId==appConfig.RootHostId.Value && c.IsHostCompany)).ToList();
			}
			return Mapper.Map<List<HrMaxx.OnlinePayroll.Models.Company>, List<CompanyResource>>(companies.OrderBy(c=>c.CompanyIntId).ToList());
		}
		[HttpGet]
		[Route(CompanyRoutes.Company)]
		[DeflateCompression]
		public CompanyResource GetCompany(Guid id)
		{
			//var companies = MakeServiceCall(() => _companyService.GetCompanyById(id), "Get company by id", true);
			var companies = MakeServiceCall(() => _readerService.GetCompany(id), "Get company by id", true);
			return Mapper.Map<HrMaxx.OnlinePayroll.Models.Company, CompanyResource>(companies);
		}

		[HttpPost]
		[Route(CompanyRoutes.Save)]
		public CompanyResource Save(CompanyResource resource)
		{
			var mappedResource = Mapper.Map<CompanyResource, Company>(resource);
			var savedCompany = MakeServiceCall(() => _companyService.Save(mappedResource), "save company details", true);
			return Mapper.Map<Company, CompanyResource>(savedCompany);
		}
		[HttpPost]
		[Route(CompanyRoutes.SaveDeduction)]
		public CompanyDeductionResource SaveDeduction(CompanyDeductionResource resource)
		{
			var mappedResource = Mapper.Map<CompanyDeductionResource, CompanyDeduction>(resource);
			var ded = MakeServiceCall(() => _companyService.SaveDeduction(mappedResource, CurrentUser.FullName, new Guid(CurrentUser.UserId)), "save company deduction", true);
			return Mapper.Map<CompanyDeduction, CompanyDeductionResource>(ded);
		}

		[HttpPost]
		[Route(CompanyRoutes.SaveCompanyTaxYearRate)]
		public CompanyTaxRateResource SaveCompanyTaxYearRate(CompanyTaxRateResource resource)
		{
			var mappedResource = Mapper.Map<CompanyTaxRateResource, CompanyTaxRate>(resource);
			var taxrate = MakeServiceCall(() => _companyService.SaveCompanyTaxYearRate(mappedResource, CurrentUser.FullName, new Guid(CurrentUser.UserId)), "save company tax year rate", true);
			return Mapper.Map<CompanyTaxRate, CompanyTaxRateResource>(taxrate);
		}

		[HttpPost]
		[Route(CompanyRoutes.SaveWorkerCompensation)]
		public CompanyWorkerCompensationResource SaveWorkerCompensation(CompanyWorkerCompensationResource resource)
		{
			var mappedResource = Mapper.Map<CompanyWorkerCompensationResource, CompanyWorkerCompensation>(resource);
			var wc = MakeServiceCall(() => _companyService.SaveWorkerCompensation(mappedResource, CurrentUser.FullName, new Guid(CurrentUser.UserId)), "save worker compensation", true);
			return Mapper.Map<CompanyWorkerCompensation, CompanyWorkerCompensationResource>(wc);
		}

		[HttpPost]
		[Route(CompanyRoutes.SaveAccumulatedPayType)]
		public AccumulatedPayTypeResource SaveAccumulatedPayType(AccumulatedPayTypeResource resource)
		{
			var mappedResource = Mapper.Map<AccumulatedPayTypeResource, AccumulatedPayType>(resource);
			var wc = MakeServiceCall(() => _companyService.SaveAccumulatedPayType(mappedResource, CurrentUser.FullName, new Guid(CurrentUser.UserId)), "save company accumulated pay type", true);
			return Mapper.Map<AccumulatedPayType, AccumulatedPayTypeResource>(wc);
		}

		[HttpPost]
		[Route(CompanyRoutes.SavePayCode)]
		public CompanyPayCodeResource SavePayCode(CompanyPayCodeResource resource)
		{
			var mappedResource = Mapper.Map<CompanyPayCodeResource, CompanyPayCode>(resource);
			var wc = MakeServiceCall(() => _companyService.SavePayCode(mappedResource, CurrentUser.FullName, new Guid(CurrentUser.UserId)), "save company pay code", true);
			return Mapper.Map<CompanyPayCode, CompanyPayCodeResource>(wc);
		}

		[HttpPost]
		[Route(CompanyRoutes.SaveLocation)]
		[DeflateCompression]
		public CompanyResource SaveLocation(CompanyLocationResource resource)
		{
			var mappedResource = Mapper.Map<CompanyLocationResource, CompanyLocation>(resource);
			var child = MakeServiceCall(() => _companyService.SaveLocation(mappedResource, CurrentUser.FullName, new Guid(CurrentUser.UserId)), "save company pay code", true);
			return Mapper.Map<Company, CompanyResource>(child);
		}

		[HttpGet]
		[Route(CompanyRoutes.VendorCustomerList)]
		[DeflateCompression]
		public List<VendorCustomerResource> SavePayCode(Guid? companyId, bool isVendor)
		{
			var vendors = MakeServiceCall(() => _companyService.GetVendorCustomers(companyId, isVendor), string.Format("getting list of vendor or customer for {0}, {1}", companyId, isVendor), true);
			return Mapper.Map<List<VendorCustomer>, List<VendorCustomerResource>>(vendors);
		}
		[HttpGet]
		[Route(CompanyRoutes.GlobalVendors)]
		[DeflateCompression]
		public List<VendorCustomerResource> GlobalVendors()
		{
			var vendors = MakeServiceCall(() => _companyService.GetVendorCustomers(null, true), string.Format("getting list of global vendors"), true);
			return Mapper.Map<List<VendorCustomer>, List<VendorCustomerResource>>(vendors);
		}

		[HttpPost]
		[Route(CompanyRoutes.VendorCustomer)]
		public VendorCustomerResource SaveVendorCustomer(VendorCustomerResource resource)
		{
			var mappedResource = Mapper.Map<VendorCustomerResource, VendorCustomer>(resource);
			var vendor = MakeServiceCall(() => _companyService.SaveVendorCustomers(mappedResource), string.Format("saving vendor or customer for {0}, {1}", resource.CompanyId, mappedResource.IsVendor), true);
			return Mapper.Map<VendorCustomer, VendorCustomerResource>(vendor);
		}

		[HttpGet]
		[Route(CompanyRoutes.Accounts)]
		[DeflateCompression]
		public List<AccountResource> GetCompanyAccounts(Guid companyId)
		{
			var accounts = MakeServiceCall(() => _companyService.GetComanyAccounts(companyId), string.Format("getting list of accounts for {0}", companyId), true);
			return Mapper.Map<List<Account>, List<AccountResource>>(accounts);
		}

		[HttpPost]
		[Route(CompanyRoutes.SaveAccount)]
		public AccountResource SaveAccount(AccountResource resource)
		{
			var mappedResource = Mapper.Map<AccountResource, Account>(resource);
			mappedResource.LastModified = DateTime.Now;
			mappedResource.LastModifiedBy = CurrentUser.FullName;
			var account = MakeServiceCall(() => _companyService.SaveCompanyAccount(mappedResource), string.Format("saving account for {0}", resource.CompanyId), true);
			return Mapper.Map<Account, AccountResource>(account);
		}

		[HttpGet]
		[Route(CompanyRoutes.EmployeeList)]
		[DeflateCompression]
		public List<EmployeeResource> EmployeeList(Guid companyId)
		{
			//var employees = MakeServiceCall(() => _companyService.GetEmployeeList(companyId), string.Format("getting list of employees for {0}", companyId), true);
			var employees = MakeServiceCall(() => _readerService.GetEmployees(company:companyId), string.Format("getting list of employees for {0}", companyId), true);
			if (CurrentUser.Employee != Guid.Empty)
			{
				employees = employees.Where(e => e.Id == CurrentUser.Employee).ToList();
			}
			return Mapper.Map<List<Employee>, List<EmployeeResource>>(employees);
		}

		[HttpPost]
		[Route(CompanyRoutes.Employee)]
		public EmployeeResource SaveEmployee(EmployeeResource resource)
		{
			var mappedResource = Mapper.Map<EmployeeResource, Employee>(resource);
			mappedResource.BankAccounts.Where(b=>b.EmployeeId==Guid.Empty).ToList().ForEach(b =>
			{
				b.EmployeeId = mappedResource.Id;
			});
			var vendor = MakeServiceCall(() => _companyService.SaveEmployee(mappedResource), string.Format("saving employee for {0}", resource.CompanyId), true);
			return Mapper.Map<Employee, EmployeeResource>(vendor);
		}

		[HttpPost]
		[Route(CompanyRoutes.EmployeeDeduction)]
		public EmployeeDeductionResource SaveEmployee(EmployeeDeductionResource resource)
		{
			var mappedResource = Mapper.Map<EmployeeDeductionResource, EmployeeDeduction>(resource);
			var deductions = MakeServiceCall(() => _companyService.SaveEmployeeDeduction(mappedResource, CurrentUser.FullName), string.Format("saving deduction for employee {0}", resource.EmployeeId), true);
			return Mapper.Map<EmployeeDeduction, EmployeeDeductionResource>(deductions);
		}

		[HttpGet]
		[Route(CompanyRoutes.DeleteEmployeeDeduction)]
		public void DeleteEmployeeDeduction(int deductionId)
		{
			MakeServiceCall(() => _companyService.DeleteEmployeeDeduction(deductionId), string.Format("deleting deduction id {0}", deductionId));
		}

		[HttpGet]
		[Route(CompanyRoutes.GetEmployeeImportTemplate)]
		[DeflateCompression]
		public HttpResponseMessage GetEmployeeImportTemplate(Guid companyId)
		{
			
			var printed = MakeServiceCall(() => _excelServce.GetEmployeeImportTemplate(companyId), "get employee import template for " + companyId, true);
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
		[System.Web.Http.Route(CompanyRoutes.ImportEmployees)]
		
		public async Task<HttpResponseMessage> ImportEmployees()
		{
			var filename = string.Empty;
			try
			{
				var fileUploadObj = await ProcessMultipartContent();
				filename = fileUploadObj.file.FullName;
				var company = Mapper.Map<Company, CompanyResource>(_readerService.GetCompany(fileUploadObj.CompanyId));
				var importedRows = _excelServce.ImportFromExcel(fileUploadObj.file, 3);
				var employees = new List<EmployeeResource>();
				var error = string.Empty;
				
				importedRows.ForEach(er =>
				{
					try
					{
						var empresource = new EmployeeResource().FillFromImport(er, company);
						empresource.UserName = CurrentUser.FullName;
						employees.Add(empresource);
					}
					catch (Exception ex)
					{
						error += "Row #: " + er.Row + ": " +ex.Message + "<br>";
					}
				});
				if (!string.IsNullOrWhiteSpace(error))
					throw new Exception(error);

				//var employeeList = _readerService.GetEmployees(company:company.Id.Value);
				//if (employeeList.Any(e=>employees.Any(e1=>e1.SSN==e.SSN)))
				//{
				//	var exists = employeeList.Where(e=>employees.Any(e1=>e1.SSN==e.SSN)).Aggregate(string.Empty, (current, emp) => current + (emp.SSN + ", "));
				//	if(!string.IsNullOrWhiteSpace(exists))
				//		throw new Exception("Employees already exist with these SSNs " + exists + "<br>");
				//}
				
				var mappedResource = Mapper.Map<List<EmployeeResource>, List<Employee>>(employees);
				var savedEmployees = _companyService.SaveEmployees(mappedResource);
				return this.Request.CreateResponse(HttpStatusCode.OK, Mapper.Map<List<Employee>, List<EmployeeResource>>(savedEmployees));
			}
			catch (Exception e)
			{
				Logger.Error("Error importing employees", e);
				throw;
				
			}
			finally
			{
				if(!string.IsNullOrWhiteSpace(filename))
					File.Delete(filename);
			}
		}

		private async Task<EmployeeImportResource> ProcessMultipartContent()
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

			var fileUploadObj = FileUploadHelpers.GetFormData<EmployeeImportResource>(result);

			var originalFileName = FileUploadHelpers.GetDeserializedFileName(result.FileData.First());
			var uploadedFileInfo = new FileInfo(result.FileData.First().LocalFileName);
			fileUploadObj.FileName = originalFileName;
			fileUploadObj.file = uploadedFileInfo;
			return fileUploadObj;
		}

		/// <summary>
		/// Upload Entity Document for a given entity
		/// </summary>
		/// <returns></returns>
		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.ImportTaxRates)]
		[DeflateCompression]
		public async Task<HttpResponseMessage> ImportTaxRates()
		{
			var filename = string.Empty;
			try
			{
				var fileUploadObj = await ProcessMultipartContentTaxRateImport();
				filename = fileUploadObj.file.FullName;
				var companyOverrideableTaxes = _metaDataService.GetCompanyTaxesForYear(fileUploadObj.Year);
				var companies = _readerService.GetCompanies(); //_companyService.GetAllCompanies();
				if(!companyOverrideableTaxes.Any())
					throw new Exception("No Company Specific Taxes Found for Year " + fileUploadObj.Year);

				var importedRows = _excelServce.ImportFromExcel(fileUploadObj.file, 2);
				var taxRates = new List<CaliforniaCompanyTaxResource>();
				var error = string.Empty;
				importedRows.ForEach(er =>
				{
					try
					{
						var companyTax = new CaliforniaCompanyTaxResource();
						companyTax.FillFromImport(er, companyOverrideableTaxes, companies, fileUploadObj.Year);
						taxRates.Add(companyTax);
					}
					catch (Exception ex)
					{
						error += ex.Message + "<br>";
					}
				});
				if (!string.IsNullOrWhiteSpace(error))
					throw new Exception(error);
				
				return this.Request.CreateResponse(HttpStatusCode.OK, taxRates);
			}
			catch (Exception e)
			{
				Logger.Error("Error importing employees", e);

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
		[System.Web.Http.Route(CompanyRoutes.ImportWCRates)]
		public async Task<HttpResponseMessage> ImportWCRates()
		{
			var filename = string.Empty;
			try
			{
				var fileUploadObj = await ProcessMultipartContentWCRateImport();
				filename = fileUploadObj.file.FullName;
				
				var companies = _readerService.GetCompanies(); //_companyService.GetAllCompanies();

				var importedRows = _excelServce.ImportWithMap(fileUploadObj.file, fileUploadObj.ImportMap, fileUploadObj.FileName, false);
				var wcRates = new List<CompanyWorkerCompensationRatesResource>();
				var error = string.Empty;
				importedRows.ForEach(er =>
				{
					try
					{
						wcRates.AddRange(CompanyWorkerCompensationRatesResource.FillFromImport(er, companies, fileUploadObj.ImportMap));
					}
					catch (Exception ex)
					{
						error += "Error at Row " + er.Row + ": " + ex.Message + "<br>";
					}
				});
				if (!string.IsNullOrWhiteSpace(error))
					throw new Exception(error);

				return this.Request.CreateResponse(HttpStatusCode.OK, wcRates);
			}
			catch (Exception e)
			{
				Logger.Error("Error importing employees", e);

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

		private async Task<TaxRateImportResource> ProcessMultipartContentTaxRateImport()
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

			var fileUploadObj = FileUploadHelpers.GetFormData<TaxRateImportResource>(result);

			var originalFileName = FileUploadHelpers.GetDeserializedFileName(result.FileData.First());
			var uploadedFileInfo = new FileInfo(result.FileData.First().LocalFileName);
			fileUploadObj.FileName = originalFileName;
			fileUploadObj.file = uploadedFileInfo;
			return fileUploadObj;
		}

		private async Task<WCRateImportResource> ProcessMultipartContentWCRateImport()
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

			var fileUploadObj = FileUploadHelpers.GetFormData<WCRateImportResource>(result);

			var originalFileName = FileUploadHelpers.GetDeserializedFileName(result.FileData.First());
			var uploadedFileInfo = new FileInfo(result.FileData.First().LocalFileName);
			fileUploadObj.FileName = originalFileName;
			fileUploadObj.file = uploadedFileInfo;
			return fileUploadObj;
		}

		[HttpPost]
		[Route(CompanyRoutes.SaveTaxRates)]
		public List<CaliforniaCompanyTax> SaveTaxRates(List<CaliforniaCompanyTaxResource> resource)
		{
			var rates = Mapper.Map<List<CaliforniaCompanyTaxResource>, List<CaliforniaCompanyTax>>(resource);
			return MakeServiceCall(() => _metaDataService.SaveTaxRates(rates), "copy company", true);
			
		}

		[HttpPost]
		[Route(CompanyRoutes.UpdateWCRates)]
		public HttpStatusCode CopyCompany(UpdateWCRatesResource resource)
		{
			var rates = Mapper.Map<List<CompanyWorkerCompensationRatesResource>, List<CompanyWorkerCompensation >> (resource.Rates);
			
			MakeServiceCall(() => _companyService.UpdateWCRates(rates, CurrentUser.FullName, new Guid(CurrentUser.UserId)), "update WC Rates");
			return HttpStatusCode.OK;
		}

		[HttpPost]
		[Route(CompanyRoutes.CopyCompany)]
		public CompanyResource CopyCompany(CopyCompanyResource resource)
		{
			var newcompany = MakeServiceCall(() => _payrollService.Copy(resource.CompanyId, resource.HostId, resource.CopyEmployees, resource.CopyPayrolls, resource.StartDate, resource.EndDate, CurrentUser.FullName, new Guid(CurrentUser.UserId), resource.KeepEmployeeNumbers), "copy company", true);
			return Mapper.Map<Company, CompanyResource>(newcompany);
		}

		[HttpGet]
		[Route(CompanyRoutes.AllCompanies)]
		[DeflateCompression]
		public List<CaliforniaCompanyTax> AllCompanies(int year)
		{
			return MakeServiceCall(() => _companyService.GetCaliforniaCompanyTaxes(year), "Get all companies for tax rates", true);
		}

		[HttpGet]
		[Route(CompanyRoutes.GetCaliforniaEDDExport)]
		[DeflateCompression]
		public HttpResponseMessage GetCaliforniaEDDExport()
		{

			var printed = MakeServiceCall(() => _excelServce.GetCaliforniaEDDExport(), "Get California EDD Export", true);
			var response = new HttpResponseMessage { Content = new StreamContent(new MemoryStream(printed.Data)) };
			response.Content.Headers.ContentType = new MediaTypeHeaderValue(printed.MimeType);

			response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
			{
				FileName = printed.Filename
			};
			return response;
		}
		[HttpGet]
		[Route(CompanyRoutes.RaiseMinWage)]
		public void RaiseMinWage(decimal minWage)
		{
			MakeServiceCall(() => _companyService.RaiseMinWage(minWage), "Raise Min Wage "+ minWage);
		}

	  [HttpGet]
	  [Route(CompanyRoutes.SSNCheck)]
	  public List<EmployeeSSNCheck> SsnCheck(string ssn)
	  {
			return MakeServiceCall(() => _companyService.CheckSSN(ssn), "check ssn ", true);
	  } 
  }
}