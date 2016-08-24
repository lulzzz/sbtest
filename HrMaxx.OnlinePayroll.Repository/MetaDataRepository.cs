using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Models.Enum;
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

		public IList<TaxByYear> GetCompanyOverridableTaxes()
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

		public IList<TaxByYear> GetAllTaxes()
		{
			var taxes = _dbContext.TaxYearRates.ToList();
			return _mapper.Map<List<TaxYearRate>, List<TaxByYear>>(taxes);
		}

		public Account GetPayrollAccount(Guid companyId)
		{
			var account =
				_dbContext.CompanyAccounts.FirstOrDefault(
					c =>
						c.CompanyId == companyId && c.Type == (int) AccountType.Assets && c.SubType == (int) AccountSubType.Bank &&
						c.UsedInPayroll);
			return _mapper.Map<CompanyAccount, Account>(account);
		}

		public int GetMaxCheckNumber(Guid companyId)
		{
			var journals = _dbContext.Journals.Where(p => p.CompanyId == companyId && !p.IsVoid).ToList();
			if (journals.Any())
			{
				var max  = journals.Max(p => p.CheckNumber) + 1;
				max = max <= 0 ? 1001 : max;
				return max; 
			}
				
			else
			{
				return 1001;
			}
		}

		public int GetMaxAdjustmenetNumber(Guid companyId)
		{
			var journals = _dbContext.Journals.Where(p => p.CompanyId == companyId && !p.IsVoid && p.TransactionType==(int)TransactionType.Adjustment).ToList();
			if (journals.Any())
			{
				var max = journals.Max(p => p.CheckNumber) + 1;
				max = max <= 0 ? 1 : max;
				return max;
			}

			else
			{
				return 1;
			}
		}
	}
}
