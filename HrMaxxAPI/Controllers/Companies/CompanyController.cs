using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxxAPI.Resources.OnlinePayroll;

namespace HrMaxxAPI.Controllers.Companies
{
  public class CompanyController : BaseApiController
  {
	  private readonly IMetaDataService _metaDataService;
		private readonly ICompanyService _companyService;

	  public CompanyController(IMetaDataService metaDataService, ICompanyService companyService)
	  {
			_metaDataService = metaDataService;
		  _companyService = companyService;
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
		[Route(CompanyRoutes.Companies)]
		public IList<CompanyResource> GetCompanies(Guid hostId)
		{
			var companies =  MakeServiceCall(() => _companyService.GetCompanies(hostId, CurrentUser.Company), "Get companies for hosts", true);
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
  }
}