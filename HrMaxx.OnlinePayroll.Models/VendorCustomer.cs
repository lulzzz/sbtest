using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class VendorCustomer : BaseEntityDto
	{
		public Guid CompanyId { get; set; }
		public string Name { get; set; }
		public StatusOption StatusId { get; set; }
		public string AccountNo { get; set; }
		public bool IsVendor { get; set; }
		public Contact Contact { get; set; }
		public string Note { get; set; }
		public F1099Type Type1099 { get; set; }
		public F1099SubType SubType1099 { get; set; }
		public VCIdentifierType IdentifierType { get; set; }
		public string IndividualSSN { get; set; }
		public string BusinessFIN { get; set; }
		public bool IsVendor1099 { get; set; }

		public VendorCustomer(Guid id, Guid companyId, string name, bool isVendor, string lastModifiedBy)
		{
			Id = id;
			CompanyId = companyId;
			IsVendor = isVendor;
			IsVendor1099 = false;
			Name = name;
			StatusId = StatusOption.Active;
			AccountNo = string.Empty;
			Contact = new Contact();
			Note = string.Empty;
			Type1099= F1099Type.NA;
			SubType1099 = F1099SubType.NA;
			IdentifierType = VCIdentifierType.NA;
			BusinessFIN = string.Empty;
			IndividualSSN = string.Empty;
			LastModified = DateTime.Now;
			UserName = lastModifiedBy;
		}
	}
}
