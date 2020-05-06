using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;
using HrMaxx.OnlinePayroll.Models.USTaxModels;

namespace HrMaxx.OnlinePayroll.Models
{
	public class CompanyMetaData
	{
		public IList<Country> Countries { get; set; }
		public IList<TaxByYear> Taxes { get; set; }
		public IList<DeductionType> DeductionTypes { get; set; }
		public IList<PayType> PayTypes { get; set; }
		public IList<InsuranceGroupDto> InsuranceGroups { get; set; }
		public IList<UserModel> Users { get; set; } 

		public IList<MinWageYearRow> MinWages { get; set; }
	}

	public class AccountsMetaData
	{
		public List<KeyValuePair<int, string>> Types { get; set; }
		public List<KeyValuePair<int, string>> SubTypes { get; set; }
	}
	public class EmployeeMetaData
	{
		public IList<PayType> PayTypes { get; set; }
		public List<VendorCustomer> Agencies { get; set; }

		public IList<MinWageYearRow> MinWages { get; set; }
	}
}
