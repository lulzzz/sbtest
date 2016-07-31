using System.Collections.Generic;
using System.Linq;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;
using DeductionType = HrMaxx.OnlinePayroll.Models.DeductionType;
using PayType = HrMaxx.OnlinePayroll.Models.PayType;

namespace HrMaxx.OnlinePayroll.Repository
{
	public class MetaDataRepository : IMetaDataRepository
	{
		private readonly OnlinePayrollEntities _dbContext;
		private readonly IMapper _mapper;
		
		public MetaDataRepository(IMapper mapper, OnlinePayrollEntities dbContext)
		{
			_dbContext = dbContext;
			_mapper = mapper;
		}

		public IList<TaxByYear> GetTaxes()
		{
			var taxes = _dbContext.TaxYearRates.Where(t=>t.Tax.IsCompanySpecific).ToList();
			return _mapper.Map<List<TaxYearRate>, List<TaxByYear>>(taxes);
		}

		public IList<DeductionType> GetDeductionTypes()
		{
			var types = _dbContext.DeductionTypes.ToList();
			return _mapper.Map<List<Models.DataModel.DeductionType>, List<DeductionType>>(types);
		}

		public IList<PayType> GetAccumulablePayTypes()
		{
			var paytypes = _dbContext.PayTypes.Where(pt=>pt.IsAccumulable).ToList();
			return _mapper.Map<List<Models.DataModel.PayType>, List<PayType>>(paytypes);
		}

		public IList<PayType> GetAllPayTypes()
		{
			var paytypes = _dbContext.PayTypes.ToList();
			return _mapper.Map<List<Models.DataModel.PayType>, List<PayType>>(paytypes);
		}
	}
}
