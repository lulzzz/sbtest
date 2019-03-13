using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;

namespace HrMaxx.Common.Models.Dtos
{
	public class Address : BaseEntityDto
	{
		public string AddressLine1 { get; set; }
		public string City { get; set; }
		public int StateId { get; set; }
		public int CountryId { get; set; }
		public string Zip { get; set; }
		public string ZipExtension { get; set; }
		public AddressType Type { get; set; }

		public string StateCode
		{
			get { return ((States) StateId).GetHrMaxxName(); }
			set { }
		}
		public string AddressLine2
		{
			get
			{
				return string.Format("{0}, {1} {2}{3}", City, "CA", Zip,
					!string.IsNullOrWhiteSpace(ZipExtension) ? "-" + ZipExtension : string.Empty);
			}
			set { }
		}
	}

	public class State
	{
		public int StateId { get; set; }
		public string StateName { get; set; }
		public string Abbreviation { get; set; }
		public bool TaxesEnabled { get; set; }
	}

	public class Country
	{
		public int CountryId { get; set; }
		public string CountryName { get; set; }
		public List<State> States { get; set; } 
	}

}
