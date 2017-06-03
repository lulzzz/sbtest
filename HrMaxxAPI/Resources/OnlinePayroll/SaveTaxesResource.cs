using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using HrMaxx.OnlinePayroll.Models.USTaxModels;
using RestSharp.Validation;

namespace HrMaxxAPI.Resources.OnlinePayroll
{
	public class SaveTaxesResource
	{
		[Required]
		public int Year { get; set; }
		[Required]
		public USTaxTables TaxTables { get; set; }
	}
}