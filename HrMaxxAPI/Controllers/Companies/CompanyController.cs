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
  }
}