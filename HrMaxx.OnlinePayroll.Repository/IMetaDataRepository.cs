using System.Collections;
using System.Collections.Generic;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;

namespace HrMaxx.OnlinePayroll.Repository
{
	public interface IMetaDataRepository
	{
		IList<TaxByYear> GetTaxes();
		IList<DeductionType> GetDeductionTypes();
		IList<PayType> GetAccumulablePayTypes();
		IList<PayType> GetAllPayTypes();
	}
}
