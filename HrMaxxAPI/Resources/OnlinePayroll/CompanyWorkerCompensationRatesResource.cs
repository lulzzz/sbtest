using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HrMaxx.Common.Models;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxxAPI.Resources.OnlinePayroll
{
	public class CompanyWorkerCompensationRatesResource
	{
		public Guid CompanyId { get; set; }
		public string CompanyName { get; set; }
		public string ClientNo { get; set; }
		public int Code { get; set; }
		public decimal? CurrentRate { get; set; }
		public decimal ProposedRate { get; set; }

		public static List<CompanyWorkerCompensationRatesResource> FillFromImport(ExcelRead er, List<Company> companies, ImportMap importMap)
		{
			var returnList = new List<CompanyWorkerCompensationRatesResource>();
			var clientNo = er.ValueFromContains("ClientNo");
			var proposedRate = Convert.ToDecimal(er.ValueFromContains("Rate"));
			var code = Convert.ToInt32(er.ValueFromContains("Code"));

			companies.Where(c=>!string.IsNullOrWhiteSpace(c.InsuranceClientNo) && c.InsuranceClientNo==clientNo).ToList().ForEach(c =>
			{
				var wcr = new CompanyWorkerCompensationRatesResource()
				{
					CompanyId = c.Id, CompanyName = c.Name, Code = code, ClientNo = clientNo, ProposedRate = proposedRate, CurrentRate = c.WorkerCompensations.Any(cwc=>cwc.Code==code) ? c.WorkerCompensations.First(cwc=>cwc.Code==code).Rate : default(decimal?)
				};
				returnList.Add(wcr);
			});

			return returnList;
		}
	}

	public class UpdateWCRatesResource
	{
		public int WCImportOption { get; set; }
		public List<CompanyWorkerCompensationRatesResource> Rates { get; set; } 
	}
}