using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;

namespace HrMaxx.Common.Models.Dtos
{
	public class Address : BaseEntityDto, IEquatable<Address>
	{
		public string AddressLine1 { get; set; }
		public string City { get; set; }
		public string County { get; set; }
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
				return string.Format("{0},{4} {1} {2}{3}", City, ((States)StateId).GetHrMaxxName(), Zip,
					!string.IsNullOrWhiteSpace(ZipExtension) ? "-" + ZipExtension : string.Empty, !string.IsNullOrWhiteSpace(County) ? " " + County + "," : string.Empty);
			}
			set { }
		}

		public bool Equals(Address other)
		{
			if (!this.AddressLine1.Equals(other.AddressLine1) || !this.City.Equals(other.City) || !this.StateId.Equals(other.StateId) || !this.Zip.Equals(other.Zip) || !this.ZipExtension.Equals(other.ZipExtension))
				return false;
			return true;
		}
	}

	public class State
	{
		public int StateId { get; set; }
		public string StateName { get; set; }
		public string Abbreviation { get; set; }
		public bool TaxesEnabled { get; set; }

		public States StateOption
		{
			get { return (States) StateId; }
		}
		public bool HasCounties { get; set; }
		public string EinFormat { get; set; }

        public string UiFormat { get; set; }
    }

	public class Country
	{
		public int CountryId { get; set; }
		public string CountryName { get; set; }
		public List<State> States { get; set; } 
	}

}
