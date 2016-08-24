using System.Collections.Generic;
using System.Linq;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Models.USTaxModels;

namespace HrMaxx.OnlinePayroll.Repository.Taxation
{
	public class TaxationRepository : ITaxationRepository
	{
		private readonly USTaxTableEntities _dbContext;
		private readonly IMapper _mapper;

		public TaxationRepository(IMapper mapper, USTaxTableEntities dbContext)
		{
			_dbContext = dbContext;
			_mapper = mapper;
		}

		public USTaxTables FillTaxTables()
		{
			var fit = _dbContext.FITTaxTables;
			var fitwithholding = _dbContext.FITWithholdingAllowanceTables;
			var stddeds = _dbContext.StandardDeductionTables;
			var sit = _dbContext.SITTaxTables;
			var sitlow = _dbContext.SITLowIncomeTaxTables;
			var estded = _dbContext.EstimatedDeductionsTables;
			var exempallow = _dbContext.ExemptionAllowanceTables;
			var dedpre = _dbContext.TaxDeductionPrecedences;

			return new USTaxTables
			{
				FITTaxTable = _mapper.Map<List<FITTaxTable>, List<FITTaxTableRow>>(fit.ToList()),
				FitWithholdingAllowanceTable = _mapper.Map<List<FITWithholdingAllowanceTable>, List<FITWithholdingAllowanceTableRow>>(fitwithholding.ToList()),
				CASITTaxTable = _mapper.Map<List<SITTaxTable>, List<CASITTaxTableRow>>(sit.ToList()),
				CASITLowIncomeTaxTable = _mapper.Map<List<SITLowIncomeTaxTable>, List<CASITLowIncomeTaxTableRow>>(sitlow.ToList()),
				CAStandardDeductionTable = _mapper.Map<List<StandardDeductionTable>, List<CAStandardDeductionTableRow>>(stddeds.ToList()),
				EstimatedDeductionTable = _mapper.Map<List<EstimatedDeductionsTable>, List<EstimatedDeductionTableRow>>(estded.ToList()),
				ExemptionAllowanceTable = _mapper.Map<List<ExemptionAllowanceTable>, List<ExemptionAllowanceTableRow>>(exempallow.ToList()),
				TaxDeductionPrecendences = _mapper.Map<List<Models.DataModel.TaxDeductionPrecedence>, List<Models.USTaxModels.TaxDeductionPrecendence>>(dedpre.ToList())
			};
		}
	}
}
