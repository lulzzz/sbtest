using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using HrMaxx.Common.Models.Enum;
using Newtonsoft.Json;

namespace HrMaxxAPI.Resources.OnlinePayroll
{
	public class EmployeeImportResource
	{
		[JsonProperty("companyId")]
		public Guid CompanyId { get; set; }
		
		[JsonIgnore]
		public string FileName { get; set; }
		[JsonIgnore]
		public FileInfo file { get; set; }
	}
}