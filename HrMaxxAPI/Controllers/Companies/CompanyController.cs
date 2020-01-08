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
using System.Web.Mvc;
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
using Microsoft.Ajax.Utilities;
using Newtonsoft.Json;

namespace HrMaxxAPI.Controllers.Companies
{
  public class CompanyController : BaseApiController
  {
	  private readonly IMetaDataService _metaDataService;
		private readonly ICompanyService _companyService;
		private readonly IPayrollService _payrollService;
		private readonly IExcelService _excelServce ;
	  
	  private readonly IReaderService _readerService;
	  
	  public CompanyController(IMetaDataService metaDataService, ICompanyService companyService, IExcelService excelService, IPayrollService payrollService, IReaderService readerService)
	  {
			_metaDataService = metaDataService;
		  _companyService = companyService;
		  _excelServce = excelService;
		 
		  _payrollService = payrollService;
		  _readerService = readerService;
	  }

	  [System.Web.Http.HttpGet]
	  [System.Web.Http.Route(CompanyRoutes.FixEmployeePayCodes)]
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

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.CopyEmployees)]
		public HttpStatusCode CopyEmployees(CopyEmployeeResource resource)
		{
			MakeServiceCall(() => _companyService.CopyEmployees(resource.SourceCompanyId, resource.TargetCompanyId, resource.EmployeeIds, CurrentUser.FullName, resource.KeepEmployeeNumbers), "Copy employees from one company to another");
			return HttpStatusCode.OK;
		}

	  [System.Web.Http.HttpGet]
	  [System.Web.Http.Route(CompanyRoutes.MetaData)]
		[DeflateCompression]
	  public object GetMetaData()
	  {
			return MakeServiceCall(() => _metaDataService.GetCompanyMetaData(), "Get company meta data", true);
	  }

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(CompanyRoutes.PEOCompanies)]
		[DeflateCompression]
		public List<CompanySUIRate> PEOCompanies()
		{
			return MakeServiceCall(() => _metaDataService.GetPEOCompanies(), "Get PEO Companies", true);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(CompanyRoutes.EmployeeMetaData)]
		[DeflateCompression]
		public object GetEmployeeMetaData()
		{
			return MakeServiceCall(() => _metaDataService.GetEmployeeMetaData(), "Get employee meta data", true);
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.PayrollMetaData)]
		[DeflateCompression]
		public object GetPayrollMetaData(CheckBookMetaDataRequestResource request)
		{
			var r = Mapper.Map<CheckBookMetaDataRequestResource, CheckBookMetaDataRequest>(request);
			return MakeServiceCall(() => _metaDataService.GetPayrollMetaData(r), "Get payroll meta data", true);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(CompanyRoutes.InvoiceMetaData)]
		[DeflateCompression]
		public object GetInvoiceMetaData(Guid companyId)
		{
			return MakeServiceCall(() => _metaDataService.GetInvoiceMetaData(companyId), "Get invoice meta data", true);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(CompanyRoutes.CompanyList)]
		[DeflateCompression]
		public IList<CompanyResource> GetAllCompanies()
		{
			//var companies =  MakeServiceCall(() => _companyService.GetAllCompanies(), "Get companies for hosts", true);
			var companies = MakeServiceCall(() => _readerService.GetCompanies(), "Get companies for hosts", true);
			
			return Mapper.Map<List<HrMaxx.OnlinePayroll.Models.Company>, List<CompanyResource>>(companies.OrderBy(c => c.CompanyIntId).ToList());
		}
		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(CompanyRoutes.MinifiedCompanyList)]
		[DeflateCompression]
		public HttpResponseMessage GetAllCompaniesMinified()
		{
			//var companies =  MakeServiceCall(() => _companyService.GetAllCompanies(), "Get companies for hosts", true);
			var companies = MakeServiceCall(() => _readerService.GetCompanies(), "Get companies for hosts", true);

			var returnString = new StringBuilder();
			companies.ForEach(c => returnString.AppendLine(string.Format("{0},{1},{2},{3},{4},{5},{6}", c.Id, c.CompanyNo, c.Name.Replace(",",""), c.FederalEIN,
				c.FederalPin, c.States.First().StateEIN, c.States.First().StatePIN)));
            using(var stream = new MemoryStream())
            {
                using(var writer = new StreamWriter(stream))
                {
                    writer.Write(returnString.ToString());
                    writer.Flush();
                    stream.Position = 0;
                    var result = new HttpResponseMessage(HttpStatusCode.OK) {Content = new StreamContent(stream)};
                    result.Content.Headers.ContentType = new MediaTypeHeaderValue("text/csv");
                    result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment") { FileName = "CompaniesExport.csv" };
                    return result;
                }
            }
			
			
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(CompanyRoutes.MinifiedEmployeeList)]
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
            using (var stream = new MemoryStream())
            {
                using (var writer = new StreamWriter(stream))
                {
                    writer.Write(returnString.ToString());
                    writer.Flush();
                    stream.Position = 0;

                    var result = new HttpResponseMessage(HttpStatusCode.OK) {Content = new StreamContent(stream)};
                    result.Content.Headers.ContentType = new MediaTypeHeaderValue("text/csv");
                    result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment") { FileName = "EmployeeExport.csv" };
                    return result;
                }
            }
                
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(CompanyRoutes.Companies)]
		[DeflateCompression]
		public IList<CompanyResource> GetCompanies(Guid hostId)
		{
			//var companies =  MakeServiceCall(() => _companyService.GetCompanies(hostId, CurrentUser.Company), "Get companies for hosts", true);
			var companies = MakeServiceCall(() => _readerService.GetCompanies(host: hostId, company:(CurrentUser.Company==Guid.Empty? default(Guid?) : CurrentUser.Company)), "Get companies for hosts", true);
			if (CurrentUser.Role == RoleTypeEnum.HostStaff.GetDbName() )
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
		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(CompanyRoutes.Company)]
		[DeflateCompression]
		public CompanyResource GetCompany(Guid id)
		{
			//var companies = MakeServiceCall(() => _companyService.GetCompanyById(id), "Get company by id", true);
			var companies = MakeServiceCall(() => _readerService.GetCompany(id), "Get company by id", true);
			return Mapper.Map<HrMaxx.OnlinePayroll.Models.Company, CompanyResource>(companies);
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.Save)]
		public CompanyResource Save(CompanyResource resource)
		{
			var mappedResource = Mapper.Map<CompanyResource, Company>(resource);
			var savedCompany = MakeServiceCall(() => _companyService.Save(mappedResource, updateEmployeeSchedules: resource.UpdateEmployeeSchedules), "save company details", true);
			return Mapper.Map<Company, CompanyResource>(savedCompany);
		}
		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.SaveDeduction)]
		public CompanyDeductionResource SaveDeduction(CompanyDeductionResource resource)
		{
			var mappedResource = Mapper.Map<CompanyDeductionResource, CompanyDeduction>(resource);
			var ded = MakeServiceCall(() => _companyService.SaveDeduction(mappedResource, CurrentUser.FullName, new Guid(CurrentUser.UserId)), "save company deduction", true);
			return Mapper.Map<CompanyDeduction, CompanyDeductionResource>(ded);
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.SaveCompanyTaxYearRate)]
		public CompanyTaxRateResource SaveCompanyTaxYearRate(CompanyTaxRateResource resource)
		{
			var mappedResource = Mapper.Map<CompanyTaxRateResource, CompanyTaxRate>(resource);
			var taxrate = MakeServiceCall(() => _companyService.SaveCompanyTaxYearRate(mappedResource, CurrentUser.FullName, new Guid(CurrentUser.UserId)), "save company tax year rate", true);
			return Mapper.Map<CompanyTaxRate, CompanyTaxRateResource>(taxrate);
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.SaveWorkerCompensation)]
		public CompanyWorkerCompensationResource SaveWorkerCompensation(CompanyWorkerCompensationResource resource)
		{
			var mappedResource = Mapper.Map<CompanyWorkerCompensationResource, CompanyWorkerCompensation>(resource);
			var wc = MakeServiceCall(() => _companyService.SaveWorkerCompensation(mappedResource, CurrentUser.FullName, new Guid(CurrentUser.UserId)), "save worker compensation", true);
			return Mapper.Map<CompanyWorkerCompensation, CompanyWorkerCompensationResource>(wc);
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.SaveAccumulatedPayType)]
		public AccumulatedPayTypeResource SaveAccumulatedPayType(AccumulatedPayTypeResource resource)
		{
			var mappedResource = Mapper.Map<AccumulatedPayTypeResource, AccumulatedPayType>(resource);
			var wc = MakeServiceCall(() => _companyService.SaveAccumulatedPayType(mappedResource, CurrentUser.FullName, new Guid(CurrentUser.UserId)), "save company accumulated pay type", true);
			return Mapper.Map<AccumulatedPayType, AccumulatedPayTypeResource>(wc);
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.SavePayCode)]
		public CompanyPayCodeResource SavePayCode(CompanyPayCodeResource resource)
		{
			var mappedResource = Mapper.Map<CompanyPayCodeResource, CompanyPayCode>(resource);
			var wc = MakeServiceCall(() => _companyService.SavePayCode(mappedResource, CurrentUser.FullName, new Guid(CurrentUser.UserId)), "save company pay code", true);
			return Mapper.Map<CompanyPayCode, CompanyPayCodeResource>(wc);
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.SaveLocation)]
		[DeflateCompression]
		public CompanyResource SaveLocation(CompanyLocationResource resource)
		{
			var mappedResource = Mapper.Map<CompanyLocationResource, CompanyLocation>(resource);
			var child = MakeServiceCall(() => _companyService.SaveLocation(mappedResource, CurrentUser.FullName, new Guid(CurrentUser.UserId)), "save company pay code", true);
			return Mapper.Map<Company, CompanyResource>(child);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(CompanyRoutes.VendorCustomerList)]
		[DeflateCompression]
		public List<VendorCustomerResource> SavePayCode(Guid? companyId, bool isVendor)
		{
			var vendors = MakeServiceCall(() => _companyService.GetVendorCustomers(companyId, isVendor), string.Format("getting list of vendor or customer for {0}, {1}", companyId, isVendor), true);
			return Mapper.Map<List<VendorCustomer>, List<VendorCustomerResource>>(vendors);
		}
		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(CompanyRoutes.GlobalVendors)]
		[DeflateCompression]
		public List<VendorCustomerResource> GlobalVendors()
		{
			var vendors = MakeServiceCall(() => _companyService.GetVendorCustomers(null, true), string.Format("getting list of global vendors"), true);
			return Mapper.Map<List<VendorCustomer>, List<VendorCustomerResource>>(vendors);
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.VendorCustomer)]
		public VendorCustomerResource SaveVendorCustomer(VendorCustomerResource resource)
		{
			var mappedResource = Mapper.Map<VendorCustomerResource, VendorCustomer>(resource);
			var vendor = MakeServiceCall(() => _companyService.SaveVendorCustomers(mappedResource), string.Format("saving vendor or customer for {0}, {1}", resource.CompanyId, mappedResource.IsVendor), true);
			return Mapper.Map<VendorCustomer, VendorCustomerResource>(vendor);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(CompanyRoutes.Accounts)]
		[DeflateCompression]
		public List<AccountResource> GetCompanyAccounts(Guid companyId)
		{
			var accounts = MakeServiceCall(() => _companyService.GetComanyAccounts(companyId), string.Format("getting list of accounts for {0}", companyId), true);
			return Mapper.Map<List<Account>, List<AccountResource>>(accounts);
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.SaveAccount)]
		public AccountResource SaveAccount(AccountResource resource)
		{
			var mappedResource = Mapper.Map<AccountResource, Account>(resource);
			mappedResource.LastModified = DateTime.Now;
			mappedResource.LastModifiedBy = CurrentUser.FullName;
			var account = MakeServiceCall(() => _companyService.SaveCompanyAccount(mappedResource), string.Format("saving account for {0}", resource.CompanyId), true);
			return Mapper.Map<Account, AccountResource>(account);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(CompanyRoutes.EmployeeList)]
		[DeflateCompression]
		public List<EmployeeResource> EmployeeList(Guid companyId, int? status = 1)
		{
			var employees = MakeServiceCall(() => _readerService.GetEmployees(company:companyId, status: status), string.Format("getting list of employees for {0} status {1}", companyId, status), true);
			if (CurrentUser.Employee != Guid.Empty)
			{
				employees = employees.Where(e => e.Id == CurrentUser.Employee).ToList();
			}
			return Mapper.Map<List<Employee>, List<EmployeeResource>>(employees);
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.Employee)]
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

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.EmployeeDeduction)]
		public EmployeeDeductionResource SaveEmployee(EmployeeDeductionResource resource)
		{
			var mappedResource = Mapper.Map<EmployeeDeductionResource, EmployeeDeduction>(resource);
			var deductions = MakeServiceCall(() => _companyService.SaveEmployeeDeduction(mappedResource, CurrentUser.FullName), string.Format("saving deduction for employee {0}", resource.EmployeeId), true);
			return Mapper.Map<EmployeeDeduction, EmployeeDeductionResource>(deductions);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(CompanyRoutes.DeleteEmployeeDeduction)]
		public void DeleteEmployeeDeduction(int deductionId)
		{
			MakeServiceCall(() => _companyService.DeleteEmployeeDeduction(deductionId), string.Format("deleting deduction id {0}", deductionId));
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.BulkTerminateEmployees)]
		public void BulkTerminateEmployees(BulkTerminateEmployeesResource resource)
		{
			MakeServiceCall(() => _companyService.BulkTerminateEmployees(resource.CompanyId, resource.EmployeeList, CurrentUser.UserId, CurrentUser.FullName), string.Format("bulk terminate employees {0}", resource.EmployeeList.Aggregate(string.Empty, (current, m) => current + m + ", ")));
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(CompanyRoutes.GetEmployeeImportTemplate)]
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
						if (!string.IsNullOrWhiteSpace(er.Value("SSN")))
						{
							var empresource = new EmployeeResource().FillFromImport(er, company);
							empresource.UserName = CurrentUser.FullName;
							employees.Add(empresource);
						}
						
					}
					catch (Exception ex)
					{
						error += "Row #: " + er.Row + ": " +ex.Message + "<br>";
					}
				});
				if (!string.IsNullOrWhiteSpace(error))
					throw new Exception(error);

				var existingEmployees = _readerService.GetEmployees(company: company.Id);
				var mappedResource = Mapper.Map<List<EmployeeResource>, List<Employee>>(employees);
				mappedResource.ForEach(e1 =>
				{
					var exists = existingEmployees.FirstOrDefault(e2 => e2.Id == e1.Id || e2.SSN.Equals(e1.SSN));
					if (exists != null)
					{
						e1.PaymentMethod = exists.PaymentMethod;
						e1.BankAccounts = exists.BankAccounts;
						e1.DirectDebitAuthorized = exists.DirectDebitAuthorized;
						e1.Compensations = exists.Compensations;
						e1.Deductions = exists.Deductions;
						
					}
				});
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
					ReasonPhrase = e.Message, Content=new StringContent(e.Message)
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
					ReasonPhrase = e.Message,
					Content = new StringContent(e.Message)
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

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.SaveTaxRates)]
		public List<CaliforniaCompanyTax> SaveTaxRates(List<CaliforniaCompanyTaxResource> resource)
		{
			var rates = Mapper.Map<List<CaliforniaCompanyTaxResource>, List<CaliforniaCompanyTax>>(resource);
			return MakeServiceCall(() => _metaDataService.SaveTaxRates(rates), "copy company", true);
			
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.UpdateWCRates)]
		public HttpStatusCode UpdateWCRates(UpdateWCRatesResource resource)
		{
			var rates = Mapper.Map<List<CompanyWorkerCompensationRatesResource>, List<CompanyWorkerCompensation >> (resource.Rates);
			
			MakeServiceCall(() => _companyService.UpdateWCRates(rates, CurrentUser.FullName, new Guid(CurrentUser.UserId), resource.WCImportOption), "update WC Rates");
			return HttpStatusCode.OK;
		}

		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.CopyCompany)]
		public CompanyResource CopyCompany(CopyCompanyResource resource)
		{
			var newcompany = MakeServiceCall(() => _payrollService.Copy(resource.CompanyId, resource.HostId, resource.CopyEmployees, resource.CopyPayrolls, resource.StartDate, resource.EndDate, CurrentUser.FullName, new Guid(CurrentUser.UserId), resource.KeepEmployeeNumbers), "copy company", true);
			return Mapper.Map<Company, CompanyResource>(newcompany);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(CompanyRoutes.AllCompanies)]
		[DeflateCompression]
		public List<CaliforniaCompanyTax> AllCompanies(int year)
		{
			return MakeServiceCall(() => _companyService.GetCaliforniaCompanyTaxes(year), "Get all companies for tax rates", true);
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(CompanyRoutes.GetCaliforniaEDDExport)]
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
		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(CompanyRoutes.RaiseMinWage)]
		public void RaiseMinWage(MinWageEligibilityCriteria request)
		{
			MakeServiceCall(() => _companyService.RaiseMinWage(request, CurrentUser.FullName, new Guid(CurrentUser.UserId)), "Raise Min Wage ");
		}

	  [System.Web.Http.HttpGet]
	  [System.Web.Http.Route(CompanyRoutes.SSNCheck)]
	  public List<EmployeeSSNCheck> SsnCheck(string ssn)
	  {
			return MakeServiceCall(() => _companyService.CheckSSN(ssn), "check ssn ", true);
	  } 
  }
}