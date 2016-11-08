using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using Antlr.Runtime.Misc;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxxAPI.Resources.OnlinePayroll;
using Newtonsoft.Json;

namespace HrMaxxAPI.Resources.Payroll
{
	public class TimesheetResource
	{
		public string EmployeeNo { get; set; }
		public string SSN { get; set; }
		public decimal Salary { get; set; }
		public List<PayrollPayCodeResource> PayCodes { get; set; }
		public List<PayrollPayTypeResource> Compensations { get; set; }

		public void FillFromImport(ExcelRead er, CompanyResource company, List<PayType> payTypes)
		{
			PayCodes = new List<PayrollPayCodeResource>();
			Compensations = new ListStack<PayrollPayTypeResource>();
			var error = string.Empty;
			const string ssnRegex = @"^(\d{3}-\d{2}-\d{4})$";
			if (!Regex.IsMatch(er.Value("ssn"), ssnRegex))
			{
				error += "SSN, ";
			}
			else
			{
				SSN = er.Value("ssn").Replace("-", string.Empty);
			}
			if (string.IsNullOrWhiteSpace(er.Value("employee no")))
			{
				error += "Employee No, ";
			}
			else
			{
				EmployeeNo = er.Value("employee no");
			}
			if (!string.IsNullOrWhiteSpace(er.Value("salary")))
			{
				decimal sala = 0;
				decimal.TryParse(er.Value("salary"), out sala);
				if (sala > 0)
					Salary = sala;
			}
			if (string.IsNullOrWhiteSpace(error))
			{
				company.PayCodes.ForEach(pc =>
				{
					var ratestr = er.Value("Base Rate");
					var h = er.Value(pc.Code + " hours");
					var o = er.Value(pc.Code + " overtime");
					var h1 = er.Value(pc.Description + " hours");
					var o1 = er.Value(pc.Description + " overtime");

					if (!string.IsNullOrWhiteSpace(h) || !string.IsNullOrWhiteSpace(o))
					{

						var hval = (decimal) 0;
						var oval = (decimal) 0;
						if (h.Contains(":") && h.Split(':').Length > 0)
						{
							decimal hhval = 0;
							decimal mmval = 0;
							var splits = h.Split(':');

							var hh = decimal.TryParse(splits[0], out hhval);
							var mm = decimal.TryParse(splits[1], out mmval);

							hval = hhval + Math.Round(mmval/60, 2, MidpointRounding.AwayFromZero);
						}
						else
						{
							decimal.TryParse(h, out hval);
						}

						if (o.Contains(":") && o.Split(':').Length > 0)
						{
							decimal hhval = 0;
							decimal mmval = 0;
							var splits = o.Split(':');

							var hh = decimal.TryParse(splits[0], out hhval);
							var mm = decimal.TryParse(splits[1], out mmval);

							oval = hhval + Math.Round(mmval / 60, 2, MidpointRounding.AwayFromZero);
						}
						else
						{
							decimal.TryParse(o, out oval);
						}
						
						if (hval > 0 || oval > 0)
						{
							decimal rate = 0;
							decimal.TryParse(ratestr, out rate);
							var pcode = new PayrollPayCodeResource
							{
								ScreenHours = !string.IsNullOrWhiteSpace(h) ? h : "0",
								ScreenOvertime = !string.IsNullOrWhiteSpace(o) ? o : "0",
								PayCode = pc,
								Hours = hval,
								OvertimeHours = oval
							};
							if (rate > 0 && pc.Id == 0)
							{
								pcode.PayCode = JsonConvert.DeserializeObject<CompanyPayCodeResource>(JsonConvert.SerializeObject(pc));
								pcode.PayCode.HourlyRate = rate;
							}

							PayCodes.Add(pcode);


						}
						
					}
					else if (!string.IsNullOrWhiteSpace(h1) || !string.IsNullOrWhiteSpace(o1))
					{
						var hval = (decimal) 0;
						var oval = (decimal) 0;
						if (h1.Contains(":") && h1.Split(':').Length > 0)
						{
							decimal hhval = 0;
							decimal mmval = 0;
							var splits = h1.Split(':');

							var hh = decimal.TryParse(splits[0], out hhval);
							var mm = decimal.TryParse(splits[1], out mmval);

							hval = hhval + Math.Round(mmval / 60, 2, MidpointRounding.AwayFromZero);
						}
						else
						{
							decimal.TryParse(h1, out hval);
						}

						if (o1.Contains(":") && o1.Split(':').Length > 0)
						{
							decimal hhval = 0;
							decimal mmval = 0;
							var splits = o1.Split(':');

							var hh = decimal.TryParse(splits[0], out hhval);
							var mm = decimal.TryParse(splits[1], out mmval);

							oval = hhval + Math.Round(mmval / 60, 2, MidpointRounding.AwayFromZero);
						}
						else
						{
							decimal.TryParse(o1, out oval);
						}
						if (hval > 0 || oval > 0)
						{
							decimal rate = 0;
							decimal.TryParse(ratestr, out rate);
							var pcode = new PayrollPayCodeResource
							{
								ScreenHours = !string.IsNullOrWhiteSpace(h1) ? h1 : "0",
								ScreenOvertime = !string.IsNullOrWhiteSpace(o1) ? o1 : "0",
								PayCode = pc,
								Hours = hval,
								OvertimeHours = oval
							};
							if (rate > 0 && pc.Id == 0)
							{
								pcode.PayCode = JsonConvert.DeserializeObject<CompanyPayCodeResource>(JsonConvert.SerializeObject(pc));
								pcode.PayCode.HourlyRate = rate;
							}

							PayCodes.Add(pcode);
						}
					}
				});
				payTypes.ForEach(pt =>
				{
					var cname = er.Value(pt.Name);
					var cdesc = er.Value(pt.Description);
					var amount = (decimal) 0;
					if (!string.IsNullOrWhiteSpace(cname))
					{
						decimal.TryParse(cname, out amount);
					}
					else if (!string.IsNullOrWhiteSpace(cdesc))
					{
						decimal.TryParse(cdesc, out amount);
					}
					if (amount > 0)
					{
						Compensations.Add(new PayrollPayTypeResource
						{
							PayType = pt,
							Amount = amount
						});
					}
				});
			}
			else
			{
				error = "Employee at row# " + er.Row + " has invalid " + error;
				throw new Exception(error);
			}
			
			
		}
	}
}