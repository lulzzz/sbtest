using System;
using System.Linq;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Repository;

namespace HrMaxx.OnlinePayroll.Services
{
	public class MetaDataService : BaseService, IMetaDataService
	{
		private readonly ICommonService _commonService;
		private readonly IMetaDataRepository _metaDataRepository;
		public MetaDataService(IMetaDataRepository metaDataRepository, ICommonService commonService)
		{
			_metaDataRepository = metaDataRepository;
			_commonService = commonService;
		}

		public object GetCompanyMetaData()
		{
			try
			{
				var countries = _commonService.GetCountries();
				var taxes = _metaDataRepository.GetTaxes();
				var deductiontypes = _metaDataRepository.GetDeductionTypes();
				var paytypes = _metaDataRepository.GetAccumulablePayTypes();
				return new {Countries = countries, Taxes = taxes, DeductionTypes = deductiontypes, PayTypes = paytypes};
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, "Meta Data for Company");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
	}
}
