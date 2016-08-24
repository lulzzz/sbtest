using System;
using System.Collections;
using System.Collections.Generic;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;

namespace HrMaxx.OnlinePayroll.Repository
{
	public interface IMetaDataRepository
	{
		IList<TaxByYear> GetCompanyOverridableTaxes();
		IList<DeductionType> GetDeductionTypes();
		IList<PayType> GetAccumulablePayTypes();
		IList<PayType> GetAllPayTypes();
		IList<TaxByYear> GetAllTaxes();
		Account GetPayrollAccount(Guid companyId);
		int GetMaxCheckNumber(Guid companyId);
		int GetMaxAdjustmenetNumber(Guid companyId);
	}
}
