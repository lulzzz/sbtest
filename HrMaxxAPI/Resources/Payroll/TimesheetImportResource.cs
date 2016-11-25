using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using HrMaxx.Common.Models;
using HrMaxx.OnlinePayroll.Models;
using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations;

namespace HrMaxxAPI.Resources.Payroll
{
	public class TimesheetImportResource
	{
		[JsonProperty("companyId")]
		public Guid CompanyId { get; set; }
		[JsonProperty("payTypes")]
		public List<PayType> PayTypes { get; set; }

		[JsonIgnore]
		public string FileName { get; set; }
		[JsonIgnore]
		public FileInfo file { get; set; }
	}

	public class TimesheetImportWithMapResource
	{
		[JsonProperty("companyId")]
		public Guid CompanyId { get; set; }
		[JsonProperty("payTypes")]
		public List<PayType> PayTypes { get; set; }
		[JsonProperty("importMap")]
		public ImportMap ImportMap { get; set; }
		[JsonIgnore]
		public string FileName { get; set; }
		[JsonIgnore]
		public FileInfo file { get; set; }
	}

	
}