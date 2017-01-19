using System;
using System.Collections.Generic;
using System.Globalization;
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
		public string Name { get; set; }
		public string EmployeeNo { get; set; }
		public string SSN { get; set; }
		public decimal Salary { get; set; }
		public decimal Gross { get; set; }
		public string Notes { get; set; }
		public decimal BreakTime { get; set; }
		public decimal PRBreakTime { get; set; }
		public decimal SickLeaveTime { get; set; }
		public List<PayrollPayCodeResource> PayCodes { get; set; }
		public List<PayrollPayCodeResource> JobCostCodes { get; set; }
		public List<PayrollPayTypeResource> Compensations { get; set; }
		public List<PayTypeAccumulationResource> Accumulations { get; set; } 

		public void FillFromImport(ExcelRead er, CompanyResource company, List<PayType> payTypes)
		{
			PayCodes = new List<PayrollPayCodeResource>();
			JobCostCodes = new List<PayrollPayCodeResource>();
			Compensations = new List<PayrollPayTypeResource>();
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
			if (!string.IsNullOrWhiteSpace(er.ValueFromContains("salary")))
			{
				decimal sala = 0;
				decimal.TryParse(er.ValueFromContains("salary"), out sala);
				if (sala > 0)
					Salary = sala;
			}
			if (!string.IsNullOrWhiteSpace(er.ValueFromContains("gross")))
			{
				decimal gross = 0;
				decimal.TryParse(er.ValueFromContains("gross"), out gross);
				if (gross > 0)
					Gross = gross;
			}
			
			if (!string.IsNullOrWhiteSpace(er.ValueFromContains("gross")))
			{
				decimal gross = 0;
				decimal.TryParse(er.ValueFromContains("gross"), out gross);
				if (gross > 0)
					Gross = gross;
			}
			if (!string.IsNullOrWhiteSpace(er.Value("employee name")))
			{
				Name = er.Value("employee name");
			}
			if (string.IsNullOrWhiteSpace(error))
			{
				company.PayCodes.ForEach(pc =>
				{
					
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
							var pcode = new PayrollPayCodeResource
							{
								ScreenHours = !string.IsNullOrWhiteSpace(h) ? h : "0",
								ScreenOvertime = !string.IsNullOrWhiteSpace(o) ? o : "0",
								PayCode = pc,
								Hours = hval,
								OvertimeHours = oval
							};
							if (Salary > 0 && pc.Id == 0)
							{
								pcode.PayCode = JsonConvert.DeserializeObject<CompanyPayCodeResource>(JsonConvert.SerializeObject(pc));
								pcode.PayCode.HourlyRate = Math.Round(Salary,2,MidpointRounding.AwayFromZero);
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
							
							var pcode = new PayrollPayCodeResource
							{
								ScreenHours = !string.IsNullOrWhiteSpace(h1) ? h1 : "0",
								ScreenOvertime = !string.IsNullOrWhiteSpace(o1) ? o1 : "0",
								PayCode = pc,
								Hours = hval,
								OvertimeHours = oval
							};
							if (Salary > 0 && pc.Id == 0)
							{
								pcode.PayCode = JsonConvert.DeserializeObject<CompanyPayCodeResource>(JsonConvert.SerializeObject(pc));
								pcode.PayCode.HourlyRate = Salary;
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

		public void FillFromImportWithMap(ExcelRead er, CompanyResource company, List<PayType> payTypes, ImportMap importMap)
		{
			var style = NumberStyles.Number | NumberStyles.AllowCurrencySymbol;
			var culture = CultureInfo.CreateSpecificCulture("en-US");
			JobCostCodes = new List<PayrollPayCodeResource>();
			PayCodes = new List<PayrollPayCodeResource>();
			Compensations = new List<PayrollPayTypeResource>();
			Accumulations = new List<PayTypeAccumulationResource>();
			var error = string.Empty;
			foreach (var col in importMap.ColumnMap)
			{
				var val = er.Value(col.Key);
				if (col.Key.Equals("SSN"))
				{
					const string ssnRegex = @"^(\d{3}-\d{2}-\d{4})$";
					if (!Regex.IsMatch(val, ssnRegex))
					{
						error += "SSN, ";
					}
					else
					{
						SSN = val.Replace("-", string.Empty);
					}
				}
				else if (col.Key.Equals("Employee No"))
				{
					if (string.IsNullOrWhiteSpace(val))
					{
						error += "Employee No, ";
					}
					else
					{
						EmployeeNo = val;
					}
				}
				else if (col.Key.Equals("Employee Name"))
				{
					if (string.IsNullOrWhiteSpace(val))
					{
						error += "Employee Name, ";
					}
					else
					{
						Name = val;
					}
				}
				else if (col.Key.Equals("Pay Rate/Salary"))
				{
					decimal sala = 0;
					decimal.TryParse(val, style, culture, out sala);
					if (sala > 0)
						Salary = Math.Round(sala,2, MidpointRounding.AwayFromZero);
				}
				else if (col.Key.Contains("Gross Wage"))
				{
					decimal gross = 0;
					decimal.TryParse(val, style, culture, out gross);
					if (gross > 0)
						Gross = Math.Round(gross, 2, MidpointRounding.AwayFromZero);
				}
				else if (col.Key.Equals("Notes"))
				{
					Notes = val;
				}
				else if (col.Key.Equals("Break Time"))
				{
					decimal bt = 0;
					decimal.TryParse(val, style, culture, out bt);
					if (bt > 0)
						BreakTime = bt;
				}
				else if (col.Key.Equals("PieceRate Break Time"))
				{
					decimal bt = 0;
					decimal.TryParse(val, style, culture, out bt);
					if (bt > 0)
						PRBreakTime = bt;
				}
				else if (col.Key.Equals("Sick Leave Time"))
				{
					decimal slt = 0;
					decimal.TryParse(val, style, culture, out slt);
					if (slt > 0)
						SickLeaveTime = slt;
				}

				else if (company.PayCodes.Any(pc => col.Key.StartsWith(pc.Code) || (pc.Id == 0 && col.Key.StartsWith("Base Rate")) || (pc.Id == -1 && col.Key.StartsWith("PieceRate"))))
				{
					var payCode = company.PayCodes.First(pc => col.Key.StartsWith(pc.Code) || (pc.Id == 0 && col.Key.StartsWith("Base Rate")) || (pc.Id == -1 && col.Key.StartsWith("PieceRate")));

					var dval = (decimal) 0;
					decimal.TryParse(val, style, culture, out dval);
					PayrollPayCodeResource pcode;
					var add = true;
					if (PayCodes.Any(pc => pc.PayCode.Id == payCode.Id))
					{
						pcode = PayCodes.First(pc => pc.PayCode.Id == payCode.Id);
						add = false;
					}
					else
					{
						pcode = new PayrollPayCodeResource()
						{
							PayCode = JsonConvert.DeserializeObject<CompanyPayCodeResource>(JsonConvert.SerializeObject(payCode))
						};
						if (Salary > 0 && payCode.Id == 0)
						{
							pcode.PayCode.HourlyRate = Math.Round(Salary, 2, MidpointRounding.AwayFromZero);
						}
					}
					if (col.Key.EndsWith("Hours"))
					{
						pcode.ScreenHours = string.IsNullOrWhiteSpace(val) ? "0" : val;
						pcode.Hours = dval;
					}
					else if (col.Key.EndsWith("Overtime"))
					{
						pcode.ScreenOvertime = string.IsNullOrWhiteSpace(val)? "0" : val;
						pcode.OvertimeHours = dval;
					}
					else if (col.Key.EndsWith("Rate Amount"))
					{
						if(pcode.PayCode.Id==0)
							pcode.Amount = string.IsNullOrWhiteSpace(val) ? 0 : Math.Round(Convert.ToDecimal( val),2,MidpointRounding.AwayFromZero);
						
					}
					else if (col.Key.EndsWith("Overtime Amount"))
					{
						if (pcode.PayCode.Id == 0)
							pcode.OvertimeAmount = string.IsNullOrWhiteSpace(val) ? 0 : Math.Round(Convert.ToDecimal(val),2,MidpointRounding.AwayFromZero);

					}
					
					if(add)
						PayCodes.Add(pcode);
				}
				else if (payTypes.Any(pt => pt.Name.Equals(col.Key)))
				{
					var comp = payTypes.First(pt => pt.Name.Equals(col.Key));
					var dval = (decimal)0;
					decimal.TryParse(val, style, culture, out dval);
					Compensations.Add(new PayrollPayTypeResource
					{
						PayType = comp,
						Amount = dval
					});
				}
				
				 
			}
			if (importMap.HasJobCost && importMap.JobCostStartingColumn > 0 &&
			    (importMap.JobCostColumnCount == 3 || importMap.JobCostColumnCount == 4))
			{
				var jobCostCodeId = -2;
				for (var jci=importMap.JobCostStartingColumn;jci<importMap.ColumnCount && JobCostCodes.Count<18;jci=jci+importMap.JobCostColumnCount)
				{
					var jccode = new PayrollPayCodeResource()
					{
						ScreenOvertime = "0" ,Amount=0, OvertimeHours = 0, OvertimeAmount=0, ScreenHours = "0", Hours = 0,
						PayCode = new CompanyPayCodeResource
						{
							Code="JC", CompanyId = company.Id.Value, Description = "Job Cost", HourlyRate = 0, Id=jobCostCodeId--
						}
					};
					foreach (var jobcost in importMap.JobCostMap.OrderBy(j=>j.Value))
					{
						
						if ((jci + jobcost.Value - 2) < importMap.ColumnCount)
						{
							var dval = (decimal)0;
							var val = er.ValueAtIndex(jci + jobcost.Value - 2);
							decimal.TryParse(val, style, culture, out dval);
							if (jobcost.Key.Equals("Amount"))
							{
								
								jccode.Amount = string.IsNullOrWhiteSpace(val) ? 0 : dval;
							}
							else if (jobcost.Key.Equals("Rate"))
								jccode.PayCode.HourlyRate = string.IsNullOrWhiteSpace(val) ? 0 : Math.Round( dval,2, MidpointRounding.AwayFromZero);
							else if (jobcost.Key.Equals("Pieces"))
								jccode.Hours = string.IsNullOrWhiteSpace(val) ? 0 : dval;
							else
							{
								jccode.PayCode.Description = val;
							}	
						}
						
					}
					JobCostCodes.Add(jccode);
				}
			}
			if (importMap.SelfManagedPayTypes.Any(apt=>apt.ImportMap.All(f=>f.Value>0)))
			{
				foreach (var sapt in importMap.SelfManagedPayTypes.Where(apt => apt.ImportMap.All(f => f.Value > 0)))
				{
					var aptId = sapt.PayTypeId;
					var apt = new PayTypeAccumulationResource()
					{
						PayType = company.AccumulatedPayTypes.First(a => a.Id == aptId)
					};
					foreach (var pair in sapt.ImportMap)
					{
						var dval = (decimal) 0;
						var val = pair.Value==-1 ? "0" : er.ValueAtIndex(pair.Value-1);
						decimal.TryParse(val, style, culture, out dval);
						if (pair.Key.Equals("Used"))
							apt.Used = string.IsNullOrWhiteSpace(val) ? 0 : dval;
						else if (pair.Key.Equals("Accumulated"))
						{
							if (sapt.ImportMap.Count(v => v.Value == pair.Value) > 1)
								apt.AccumulatedValue = 0;
							else
								apt.AccumulatedValue = string.IsNullOrWhiteSpace(val) ? 0 : dval;
						}
							
						else if (pair.Key.Equals("YTD Accumulated"))
							apt.YTDFiscal = string.IsNullOrWhiteSpace(val) ? 0 : dval;
						else if (pair.Key.Equals("YTD Used"))
							apt.YTDUsed = string.IsNullOrWhiteSpace(val) ? 0 : dval;
					}
					Accumulations.Add(apt);
				}
			}
			if (!string.IsNullOrWhiteSpace(error))
			{
				error = "Employee at row# " + er.Row + " has invalid " + error;
				throw new Exception(error);
			}
			
		}
	}
}