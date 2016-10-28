using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web.Http;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxxAPI.Code.Helpers;
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
	  
	  public CompanyController(IMetaDataService metaDataService, ICompanyService companyService, IExcelService excelService, ITaxationService taxationService, IPayrollService payrollService)
	  {
			_metaDataService = metaDataService;
		  _companyService = companyService;
		  _excelServce = excelService;
		  _taxationService = taxationService;
		  _payrollService = payrollService;
	  }

	  [HttpGet]
	  [Route(CompanyRoutes.MetaData)]
	  public object GetMetaData()
	  {
			return MakeServiceCall(() => _metaDataService.GetCompanyMetaData(), "Get company meta data", true);
	  }
		[HttpGet]
		[Route(CompanyRoutes.EmployeeMetaData)]
		public object GetEmployeeMetaData()
		{
			return MakeServiceCall(() => _metaDataService.GetEmployeeMetaData(), "Get employee meta data", true);
		}

		[HttpGet]
		[Route(CompanyRoutes.PayrollMetaData)]
		public object GetPayrollMetaData(Guid companyId)
		{
			return MakeServiceCall(() => _metaDataService.GetPayrollMetaData(companyId), "Get payroll meta data", true);
		}

		[HttpGet]
		[Route(CompanyRoutes.InvoiceMetaData)]
		public object GetInvoiceMetaData(Guid companyId)
		{
			return MakeServiceCall(() => _metaDataService.GetInvoiceMetaData(companyId), "Get invoice meta data", true);
		}

		[HttpGet]
		[Route(CompanyRoutes.Companies)]
		public IList<CompanyResource> GetCompanies(Guid hostId)
		{
			var companies =  MakeServiceCall(() => _companyService.GetCompanies(hostId, CurrentUser.Company), "Get companies for hosts", true);
			if (CurrentUser.Role == RoleTypeEnum.HostStaff.GetDbName())
			{
				companies = companies.Where(c => !c.IsHostCompany).ToList();
			}
			var appConfig = _taxationService.GetApplicationConfig();
			if (CurrentUser.Role == RoleTypeEnum.CorpStaff.GetDbName() && appConfig.RootHostId.HasValue)
			{
				companies = companies.Where(c => !(c.HostId==appConfig.RootHostId.Value && c.IsHostCompany)).ToList();
			}
			return Mapper.Map<List<HrMaxx.OnlinePayroll.Models.Company>, List<CompanyResource>>(companies.ToList());
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
			var ded = MakeServiceCall(() => _companyService.SaveDeduction(mappedResource), "save company deduction", true);
			return Mapper.Map<CompanyDeduction, CompanyDeductionResource>(ded);
		}

		[HttpPost]
		[Route(CompanyRoutes.SaveCompanyTaxYearRate)]
		public CompanyTaxRateResource SaveCompanyTaxYearRate(CompanyTaxRateResource resource)
		{
			var mappedResource = Mapper.Map<CompanyTaxRateResource, CompanyTaxRate>(resource);
			var taxrate = MakeServiceCall(() => _companyService.SaveCompanyTaxYearRate(mappedResource), "save company tax year rate", true);
			return Mapper.Map<CompanyTaxRate, CompanyTaxRateResource>(taxrate);
		}

		[HttpPost]
		[Route(CompanyRoutes.SaveWorkerCompensation)]
		public CompanyWorkerCompensationResource SaveWorkerCompensation(CompanyWorkerCompensationResource resource)
		{
			var mappedResource = Mapper.Map<CompanyWorkerCompensationResource, CompanyWorkerCompensation>(resource);
			var wc = MakeServiceCall(() => _companyService.SaveWorkerCompensation(mappedResource), "save company deduction", true);
			return Mapper.Map<CompanyWorkerCompensation, CompanyWorkerCompensationResource>(wc);
		}

		[HttpPost]
		[Route(CompanyRoutes.SaveAccumulatedPayType)]
		public AccumulatedPayTypeResource SaveAccumulatedPayType(AccumulatedPayTypeResource resource)
		{
			var mappedResource = Mapper.Map<AccumulatedPayTypeResource, AccumulatedPayType>(resource);
			var wc = MakeServiceCall(() => _companyService.SaveAccumulatedPayType(mappedResource), "save company accumulated pay type", true);
			return Mapper.Map<AccumulatedPayType, AccumulatedPayTypeResource>(wc);
		}

		[HttpPost]
		[Route(CompanyRoutes.SavePayCode)]
		public CompanyPayCodeResource SavePayCode(CompanyPayCodeResource resource)
		{
			var mappedResource = Mapper.Map<CompanyPayCodeResource, CompanyPayCode>(resource);
			var wc = MakeServiceCall(() => _companyService.SavePayCode(mappedResource), "save company pay code", true);
			return Mapper.Map<CompanyPayCode, CompanyPayCodeResource>(wc);
		}

		[HttpGet]
		[Route(CompanyRoutes.VendorCustomerList)]
		public List<VendorCustomerResource> SavePayCode(Guid companyId, bool isVendor)
		{
			var vendors = MakeServiceCall(() => _companyService.GetVendorCustomers(companyId, isVendor), string.Format("getting list of vendor or customer for {0}, {1}", companyId, isVendor), true);
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
		public List<EmployeeResource> EmployeeList(Guid companyId)
		{
			var vendors = MakeServiceCall(() => _companyService.GetEmployeeList(companyId), string.Format("getting list of employees for {0}", companyId), true);
			return Mapper.Map<List<Employee>, List<EmployeeResource>>(vendors);
		}

		[HttpPost]
		[Route(CompanyRoutes.Employee)]
		public EmployeeResource SaveEmployee(EmployeeResource resource)
		{
			var mappedResource = Mapper.Map<EmployeeResource, Employee>(resource);
			var vendor = MakeServiceCall(() => _companyService.SaveEmployee(mappedResource), string.Format("saving employee for {0}", resource.CompanyId), true);
			return Mapper.Map<Employee, EmployeeResource>(vendor);
		}

		[HttpPost]
		[Route(CompanyRoutes.EmployeeDeduction)]
		public EmployeeDeductionResource SaveEmployee(EmployeeDeductionResource resource)
		{
			var mappedResource = Mapper.Map<EmployeeDeductionResource, EmployeeDeduction>(resource);
			var deductions = MakeServiceCall(() => _companyService.SaveEmployeeDeduction(mappedResource), string.Format("saving deduction for employee {0}", resource.EmployeeId), true);
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
				var company = Mapper.Map<Company, CompanyResource>(_companyService.GetCompanyById(fileUploadObj.CompanyId));
				var importedRows = _excelServce.ImportEmployees(fileUploadObj.file);
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
						error += ex.Message + "<br>";
					}
				});
				if (!string.IsNullOrWhiteSpace(error))
					throw new Exception(error);

				var employeeList = _companyService.GetEmployeeList(company.Id.Value);
				if (employeeList.Any(e=>employees.Any(e1=>e1.SSN==e.SSN)))
				{
					var exists = employeeList.Where(e=>employees.Any(e1=>e1.SSN==e.SSN)).Aggregate(string.Empty, (current, emp) => current + (emp.SSN + ", "));
					if(!string.IsNullOrWhiteSpace(exists))
						throw new Exception("Employees already exist with these SSNs " + exists + "<br>");
				}
				
				var mappedResource = Mapper.Map<List<EmployeeResource>, List<Employee>>(employees);
				var savedEmployees = _companyService.SaveEmployees(mappedResource);
				return this.Request.CreateResponse(HttpStatusCode.OK, Mapper.Map<List<Employee>, List<EmployeeResource>>(savedEmployees));
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

		[HttpPost]
		[Route(CompanyRoutes.CopyCompany)]
		public CompanyResource CopyCompany(CopyCompanyResource resource)
		{
			var newcompany = MakeServiceCall(() => _payrollService.Copy(resource.CompanyId, resource.HostId, resource.CopyEmployees, resource.CopyPayrolls, resource.StartDate, resource.EndDate, CurrentUser.FullName), "copy company", true);
			return Mapper.Map<Company, CompanyResource>(newcompany);
		}
  }
}