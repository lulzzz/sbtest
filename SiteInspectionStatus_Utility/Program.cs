﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web.UI;
using Autofac;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Common.Repository.Security;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Security;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Messages.Events;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;
using HrMaxx.OnlinePayroll.Repository;
using HrMaxx.OnlinePayroll.Repository.Companies;
using HrMaxx.OnlinePayroll.Repository.Journals;
using HrMaxx.OnlinePayroll.Repository.Payroll;
using HrMaxxAPI.Code.IOC;
using LinqToExcel;
using Magnum;
using Newtonsoft.Json;
using BankAccount = HrMaxx.OnlinePayroll.Models.BankAccount;
using CompanyPayCode = HrMaxx.OnlinePayroll.Models.CompanyPayCode;
using CompanyTaxState = HrMaxx.OnlinePayroll.Models.CompanyTaxState;


namespace SiteInspectionStatus_Utility
{
	class Program
	{
		static void Main(string[] args)
		{
			var projectId = new Guid("D444F503-3354-40DF-8021-F4C9E99074B6");
			var builder = new ContainerBuilder();
			builder.RegisterModule<LoggingModule>();
			builder.RegisterModule<MapperModule>();

			builder.RegisterModule<ControllerModule>();
			builder.RegisterModule<BusModule>();

			//builder.RegisterModule<SiteInspectionStatus_Utility.MappingModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.RepositoriesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.MappingModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.ServicesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.CommandHandlerModule>();

			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.RepositoriesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.MappingModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.ServicesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.CommandHandlerModule>();

			var container = builder.Build();
			
			Console.WriteLine("Utility run started. Enter 1 for SL general, 2 for SL specific 3 for Assign SalesPerson ");
			var command = Convert.ToInt32(Console.ReadLine());
			switch (command)
			{
				
				case 8:
					FixPayrollTaxesAccumulations(container);
					break;
				case 9:
					FixPayrollYTD(container);
					break;
				case 10:
					FixPayCheckYTD(container);
					break;
				case 11:
					UpdateInvoiceDeliveryLists(container);
					break;
				case 12:
					CompareTaxRates(container);
					break;
				case 13:
					FixAccumulationCycleAndYTD(container);
					break;
				case 14:
					UpdateEmployeeCarryOver(container);
					break;
				case 15:
					FixAccumulationCycleAndYTDForPEO(container);
					break;
				case 16:
					SeparateInvoiceTaxesDelayed(container);
					break;
				case 17:
					FixSickLeave(container);
					break;
				case 18:
					ChangeEmployeesToHourly(container);
					break;
				default:
					break;
			}

			Console.WriteLine("Utility run finished for ");
		}
		private static void ChangeEmployeesToHourly(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var companyservice = scope.Resolve<ICompanyService>();
				var payrollService = scope.Resolve<IPayrollService>();
				var readerservice = scope.Resolve<IReaderService>();

				var compList = new List<Guid>();
				compList.Add(new Guid("9D18DA15-ACB4-4CE5-B6DF-A6ED015174DD"));
				var counter = (int)0;
				compList.ForEach(c =>
				{
					var company = readerservice.GetCompany(c);
					var employees = readerservice.GetEmployees(company: c);
					employees.Where(e=>e.PayType==EmployeeType.JobCost || e.PayType==EmployeeType.PieceWork).ToList().ForEach(e =>
					{
						e.PayType = EmployeeType.Hourly;
						e.PayCodes = new List<CompanyPayCode>();
						var baserate = new CompanyPayCode
						{
							Id = 0,
							Code = "Base Rate",
							Description = "Base Rate",
							HourlyRate = e.Rate,
							CompanyId = e.CompanyId
						};
						if (baserate.HourlyRate == 0)
						{
							e.Rate = company.MinWage;
							baserate.HourlyRate = company.MinWage;
						}
						e.PayCodes.Add(baserate);
						e.UserName = "System";
						companyservice.SaveEmployee(e, false);
						counter++;
					});
					
				});

				Console.WriteLine("Checks Updated " + counter);

			}
		}
		private static void FixSickLeave(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var companyservice = scope.Resolve<ICompanyService>();
				var payrollService = scope.Resolve<IPayrollService>();
				var readerservice = scope.Resolve<IReaderService>();

				var compList = new List<Guid>();
				compList.Add(new Guid("6B22F916-0E34-4DB0-BE20-A6ED01549D3E"));
				compList.Add(new Guid("87AE8C84-2CEC-49F3-881D-A6F20019290B"));
				var payChecks = new List<int>();
				var counter = (int) 0;
				compList.ForEach(c =>
				{
					var company = readerservice.GetCompany(c);
					var employees = readerservice.GetEmployees(company: c);
					var payrolls = readerservice.GetPayrolls(c);
					payrolls.Where(p=>!p.IsHistory).OrderBy(p=>p.PayDay).ToList().ForEach(p =>
					{
						var empList = employees.Where(e => p.PayChecks.Any(pc => pc.Employee.Id == e.Id)).ToList();
						var employeeAccumulations = readerservice.GetAccumulations(company: p.Company.Id,
						startdate: new DateTime(p.PayDay.Year, 1, 1), enddate: p.PayDay, ssns: empList.Select(pc => pc.SSN).Aggregate(string.Empty, (current, m) => current + Crypto.Encrypt(m) + ","));
						p.PayChecks.Where(pc => !pc.IsVoid).ToList().ForEach(pc =>
						{
							var slVal = pc.Accumulations!=null && pc.Accumulations.Any(a => a.PayType.PayType.Id == 6) ? pc.Accumulations.First(a => a.PayType.PayType.Id == 6).AccumulatedValue : 0;
							var ytd = pc.Accumulations != null && pc.Accumulations.Any(a => a.PayType.PayType.Id == 6) ? pc.Accumulations.First(a => a.PayType.PayType.Id == 6).YTDFiscal : 0;
							var employeeAccumulation = employeeAccumulations.First(e => e.EmployeeId.Value == pc.Employee.Id);
							if (employeeAccumulation.Accumulations.Any(a => a.PayTypeId == 6))
							{
								employeeAccumulation.Accumulations.First(a => a.PayTypeId == 6).YTDFiscal -= slVal;
							}
							pc.Employee = employees.First(e => e.Id == pc.Employee.Id);
							var accums = ProcessAccumulations(pc, company.AccumulatedPayTypes,
								employeeAccumulation);
							var shouldbe = accums.First(a => a.PayType.PayType.Id == 6);
							
							if (shouldbe.AccumulatedValue != slVal || shouldbe.YTDFiscal!=ytd)
							{
								var sl = pc.Accumulations.FirstOrDefault(a => a.PayType.PayType.Id == 6);
								if (sl == null)
								{
									sl = shouldbe;
								}
								else
								{
									sl.AccumulatedValue = shouldbe.AccumulatedValue;
									sl.YTDFiscal = shouldbe.YTDFiscal;
								}
								payrollService.UpdatePayCheckAccumulation(pc.Id, sl, "System", Guid.Empty.ToString());
								Console.WriteLine(string.Format("{0}--{1}--{2}--{3}--{4}--{5}", pc.Id, pc.PayDay.ToString("MM/dd/yyyy"), slVal, shouldbe.AccumulatedValue, ytd, shouldbe.YTDFiscal));
								counter++;
							}
						});
					});
				});
				
				Console.WriteLine("Checks Updated " + counter);

			}
		}
		private static void UpdateEmployeeCarryOver(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var companyservice = scope.Resolve<ICompanyService>();
				var payrollService = scope.Resolve<IPayrollService>();
				var readerservice = scope.Resolve<IReaderService>();
				var list = new List<EmpCarryOver>();
				#region "list"
				list.Add(new EmpCarryOver { empno = 1, carryover = (decimal) 34.48 });
				list.Add(new EmpCarryOver { empno = 4, carryover = (decimal) 36.6 });
				list.Add(new EmpCarryOver { empno = 7, carryover = (decimal) 34.41 });
				list.Add(new EmpCarryOver { empno = 8, carryover = (decimal) 10.99 });
				list.Add(new EmpCarryOver { empno = 10, carryover = (decimal) 18.46 });
				list.Add(new EmpCarryOver { empno = 11, carryover = (decimal) 30.13 });
				list.Add(new EmpCarryOver { empno = 12, carryover = (decimal) 36.9 });
				list.Add(new EmpCarryOver { empno = 13, carryover = (decimal) 23.32 });
				list.Add(new EmpCarryOver { empno = 14, carryover = (decimal) 34.7 });
				list.Add(new EmpCarryOver { empno = 16, carryover = (decimal) 26.77 });
				list.Add(new EmpCarryOver { empno = 17, carryover = (decimal) 33.59 });
				list.Add(new EmpCarryOver { empno = 18, carryover = (decimal) 35.69 });
				list.Add(new EmpCarryOver { empno = 20, carryover = (decimal) 36.14 });
				list.Add(new EmpCarryOver { empno = 21, carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { empno = 22, carryover = (decimal) 23.39 });
				list.Add(new EmpCarryOver { empno = 23, carryover = (decimal) 17.5 });
				list.Add(new EmpCarryOver { empno = 24, carryover = (decimal) 21.01 });
				list.Add(new EmpCarryOver { empno = 25, carryover = (decimal) 35.81 });
				list.Add(new EmpCarryOver { empno = 27, carryover = (decimal) 35.31 });
				list.Add(new EmpCarryOver { empno = 28, carryover = (decimal) 31.48 });
				list.Add(new EmpCarryOver { empno = 29, carryover = (decimal) 34.46 });
				list.Add(new EmpCarryOver { empno = 30, carryover = (decimal) 31.85 });
				list.Add(new EmpCarryOver { empno = 33, carryover = (decimal) 13.07 });
				list.Add(new EmpCarryOver { empno = 34, carryover = (decimal) 38.39 });
				list.Add(new EmpCarryOver { empno = 36, carryover = (decimal) 37.29 });
				list.Add(new EmpCarryOver { empno = 38, carryover = (decimal) 9.15 });
				list.Add(new EmpCarryOver { empno = 39, carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { empno = 40, carryover = (decimal) 31.17 });
				list.Add(new EmpCarryOver { empno = 41, carryover = (decimal) 37.43 });
				list.Add(new EmpCarryOver { empno = 43, carryover = (decimal) 35.86 });
				list.Add(new EmpCarryOver { empno = 44, carryover = (decimal) 33.73 });
				list.Add(new EmpCarryOver { empno = 47, carryover = (decimal) 35.74 });
				list.Add(new EmpCarryOver { empno = 48, carryover = (decimal) 31.84 });
				list.Add(new EmpCarryOver { empno = 52, carryover = (decimal) 33.8 });
				list.Add(new EmpCarryOver { empno = 53, carryover = (decimal) 34.96 });
				list.Add(new EmpCarryOver { empno = 57, carryover = (decimal) 28.31 });
				list.Add(new EmpCarryOver { empno = 58, carryover = (decimal) 38.01 });
				list.Add(new EmpCarryOver { empno = 59, carryover = (decimal) 35.11 });
				list.Add(new EmpCarryOver { empno = 62, carryover = (decimal) 38.11 });
				list.Add(new EmpCarryOver { empno = 63, carryover = (decimal) 16.77 });
				list.Add(new EmpCarryOver { empno = 66, carryover = (decimal) 38.27 });
				list.Add(new EmpCarryOver { empno = 67, carryover = (decimal) 34.3 });
				list.Add(new EmpCarryOver { empno = 68, carryover = (decimal) 31.8 });
				list.Add(new EmpCarryOver { empno = 69, carryover = (decimal) 37.97 });
				list.Add(new EmpCarryOver { empno = 72, carryover = (decimal) 36.12 });
				list.Add(new EmpCarryOver { empno = 73, carryover = (decimal) 37.49 });
				list.Add(new EmpCarryOver { empno = 74, carryover = (decimal) 35.63 });
				list.Add(new EmpCarryOver { empno = 76, carryover = (decimal) 8.44 });
				list.Add(new EmpCarryOver { empno = 77, carryover = (decimal) 32.76 });
				list.Add(new EmpCarryOver { empno = 79, carryover = (decimal) 25.83 });
				list.Add(new EmpCarryOver { empno = 81, carryover = (decimal) 32.21 });
				list.Add(new EmpCarryOver { empno = 82, carryover = (decimal) 35.68 });
				list.Add(new EmpCarryOver { empno = 84, carryover = (decimal) 32.12 });
				list.Add(new EmpCarryOver { empno = 85, carryover = (decimal) 25.22 });
				list.Add(new EmpCarryOver { empno = 86, carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { empno = 87, carryover = (decimal) 35.42 });
				list.Add(new EmpCarryOver { empno = 89, carryover = (decimal) 31.8 });
				list.Add(new EmpCarryOver { empno = 90, carryover = (decimal) 27.99 });
				list.Add(new EmpCarryOver { empno = 91, carryover = (decimal) 20.63 });
				list.Add(new EmpCarryOver { empno = 92, carryover = (decimal) 29.02 });
				list.Add(new EmpCarryOver { empno = 93, carryover = (decimal) 22.6 });
				list.Add(new EmpCarryOver { empno = 94, carryover = (decimal) 27.84 });
				list.Add(new EmpCarryOver { empno = 95, carryover = (decimal) 27.1 });
				list.Add(new EmpCarryOver { empno = 97, carryover = (decimal) 20.9 });
				list.Add(new EmpCarryOver { empno = 101, carryover = (decimal) 35.42 });
				list.Add(new EmpCarryOver { empno = 103, carryover = (decimal) 32.5 });
				list.Add(new EmpCarryOver { empno = 104, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 105, carryover = (decimal) 32.5 });
				list.Add(new EmpCarryOver { empno = 107, carryover = (decimal) 21.68 });
				list.Add(new EmpCarryOver { empno = 108, carryover = (decimal) 34.76 });
				list.Add(new EmpCarryOver { empno = 109, carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { empno = 110, carryover = (decimal) 19.82 });
				list.Add(new EmpCarryOver { empno = 111, carryover = (decimal) 31.76 });
				list.Add(new EmpCarryOver { empno = 113, carryover = (decimal) 12.19 });
				list.Add(new EmpCarryOver { empno = 114, carryover = (decimal) 34.81 });
				list.Add(new EmpCarryOver { empno = 115, carryover = (decimal) 35.07 });
				list.Add(new EmpCarryOver { empno = 117, carryover = (decimal) 12 });
				list.Add(new EmpCarryOver { empno = 119, carryover = (decimal) 35.04 });
				list.Add(new EmpCarryOver { empno = 121, carryover = (decimal) 32.3 });
				list.Add(new EmpCarryOver { empno = 122, carryover = (decimal) 35.28 });
				list.Add(new EmpCarryOver { empno = 124, carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { empno = 125, carryover = (decimal) 34.09 });
				list.Add(new EmpCarryOver { empno = 126, carryover = (decimal) 35.95 });
				list.Add(new EmpCarryOver { empno = 129, carryover = (decimal) 31.93 });
				list.Add(new EmpCarryOver { empno = 131, carryover = (decimal) 36.54 });
				list.Add(new EmpCarryOver { empno = 132, carryover = (decimal) 32.74 });
				list.Add(new EmpCarryOver { empno = 133, carryover = (decimal) 35.08 });
				list.Add(new EmpCarryOver { empno = 135, carryover = (decimal) 34.46 });
				list.Add(new EmpCarryOver { empno = 137, carryover = (decimal) 37.55 });
				list.Add(new EmpCarryOver { empno = 138, carryover = (decimal) 34 });
				list.Add(new EmpCarryOver { empno = 139, carryover = (decimal) 36.4 });
				list.Add(new EmpCarryOver { empno = 140, carryover = (decimal) 38.44 });
				list.Add(new EmpCarryOver { empno = 141, carryover = (decimal) 33.34 });
				list.Add(new EmpCarryOver { empno = 142, carryover = (decimal) 30.24 });
				list.Add(new EmpCarryOver { empno = 143, carryover = (decimal) 34.98 });
				list.Add(new EmpCarryOver { empno = 146, carryover = (decimal) 9.57 });
				list.Add(new EmpCarryOver { empno = 147, carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { empno = 151, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 152, carryover = (decimal) 24.8 });
				list.Add(new EmpCarryOver { empno = 160, carryover = (decimal) 32.93 });
				list.Add(new EmpCarryOver { empno = 161, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 163, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 165, carryover = (decimal) 8 });
				list.Add(new EmpCarryOver { empno = 166, carryover = (decimal) 12.59 });
				list.Add(new EmpCarryOver { empno = 168, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 171, carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { empno = 172, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 177, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 180, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 181, carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { empno = 183, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 184, carryover = (decimal) 10.53 });
				list.Add(new EmpCarryOver { empno = 185, carryover = (decimal) 8 });
				list.Add(new EmpCarryOver { empno = 186, carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { empno = 187, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 191, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 194, carryover = (decimal) 8 });
				list.Add(new EmpCarryOver { empno = 197, carryover = (decimal) 16 });
				list.Add(new EmpCarryOver { empno = 198, carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { empno = 199, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 201, carryover = (decimal) 16 });
				list.Add(new EmpCarryOver { empno = 202, carryover = (decimal) 7.01 });
				list.Add(new EmpCarryOver { empno = 204, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 206, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 209, carryover = (decimal) 14.59 });
				list.Add(new EmpCarryOver { empno = 213, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 215, carryover = (decimal) 7.06 });
				list.Add(new EmpCarryOver { empno = 217, carryover = (decimal) 16 });
				list.Add(new EmpCarryOver { empno = 219, carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { empno = 220, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 222, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 225, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 227, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 231, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 232, carryover = (decimal) 14.73 });
				list.Add(new EmpCarryOver { empno = 233, carryover = (decimal) 2.49 });
				list.Add(new EmpCarryOver { empno = 234, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 235, carryover = (decimal) 21.2 });
				list.Add(new EmpCarryOver { empno = 238, carryover = (decimal) 20.08 });
				list.Add(new EmpCarryOver { empno = 239, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 240, carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { empno = 241, carryover = (decimal) 22.66 });
				list.Add(new EmpCarryOver { empno = 242, carryover = (decimal) 17.23 });
				list.Add(new EmpCarryOver { empno = 243, carryover = (decimal) 17.5 });
				list.Add(new EmpCarryOver { empno = 245, carryover = (decimal) 15 });
				list.Add(new EmpCarryOver { empno = 246, carryover = (decimal) 19.9 });
				list.Add(new EmpCarryOver { empno = 247, carryover = (decimal) 15.17 });
				list.Add(new EmpCarryOver { empno = 252, carryover = (decimal) 7.89 });
				list.Add(new EmpCarryOver { empno = 254, carryover = (decimal) 7.43 });
				list.Add(new EmpCarryOver { empno = 256, carryover = (decimal) 6.36 });
				list.Add(new EmpCarryOver { empno = 258, carryover = (decimal) 5.35 });
				list.Add(new EmpCarryOver { empno = 260, carryover = (decimal) 4.11 });
				list.Add(new EmpCarryOver { empno = 262, carryover = (decimal) 3.1 });
				list.Add(new EmpCarryOver { empno = 263, carryover = (decimal) 3.23 });
				list.Add(new EmpCarryOver { empno = 265, carryover = (decimal) 3.21 });
				list.Add(new EmpCarryOver { empno = 268, carryover = (decimal) 0.95 });
				#endregion

				var ud = new Guid("6B22F916-0E34-4DB0-BE20-A6ED01549D3E");
				var ud2 = new Guid("87AE8C84-2CEC-49F3-881D-A6F20019290B");
				var udemployees = readerservice.GetEmployees(company: ud);
				var ud2employees = readerservice.GetEmployees(company: ud2);
				udemployees = udemployees.Where(e => list.Any(e1 => e1.empno == e.CompanyEmployeeNo)).ToList();
				var ssns = udemployees.Select(e => e.SSN).Aggregate(string.Empty, (current, m) => current + Crypto.Encrypt(m) + ",");
				var udaccumulations = readerservice.GetAccumulations(company: ud, startdate: new DateTime(2017, 1, 1).Date,
					enddate: new DateTime(2017,8,27).Date, ssns: ssns);
				var ud2accumulations = readerservice.GetAccumulations(company: ud2, startdate: new DateTime(2017, 1, 1).Date,
					enddate: new DateTime(2017, 8, 27).Date, ssns: ssns);
				var noupdate = (int)0;
				var update = (int) 0;
				var ud2match = (int)0;
				var ud2update = (int)0;
				var ud2noupdate = (int)0;
				list.ForEach(e =>
				{
					var e1 = udemployees.First(e2 => e2.CompanyEmployeeNo == e.empno);
					var ud2e = ud2employees.FirstOrDefault(e2 => e2.SSN == e1.SSN && e2.CompanyEmployeeNo == e1.CompanyEmployeeNo);
					if (e1.CarryOver != e.carryover)
					{
						e1.CarryOver = e.carryover;
						var acc = udaccumulations.First(e2 => e2.EmployeeId == e1.Id);
						if (acc.Accumulations.Count == 1)
						{
							var sl = acc.Accumulations.First();
							sl.CarryOver = e.carryover;
							payrollService.UpdateEmployeeAccumulation(sl, sl.FiscalStart, sl.FiscalEnd, e1.Id);
							update++;
							
						}
						else
						{
							noupdate++;
						}
						e1.UserName = "System";
						companyservice.SaveEmployee(e1, false);
					}
					else
					{
						noupdate++;
					}
					if(ud2e != null && ud2e.CarryOver!=e.carryover)
					{
						ud2match++;
						ud2e.CarryOver = e.carryover;
						var acc = ud2accumulations.First(e2 => e2.EmployeeId == ud2e.Id);
						if (acc.Accumulations.Count == 1)
						{
							var sl = acc.Accumulations.First();
							sl.CarryOver = e.carryover;
							payrollService.UpdateEmployeeAccumulation(sl, sl.FiscalStart, sl.FiscalEnd, e1.Id);
							ud2update++;

						}
						else
						{
							ud2noupdate++;
						}
						ud2e.UserName = "System";
						companyservice.SaveEmployee(ud2e, false);
					}
					
				});
				Console.WriteLine("Total: {0}", list.Count);
				Console.WriteLine("Update: {0}", update);
				Console.WriteLine("No Update: {0}", noupdate);
				Console.WriteLine("Total: {0}", ud2match);
				Console.WriteLine("Update: {0}", ud2update);
				Console.WriteLine("No Update: {0}", ud2noupdate);

			}
		}

		private static void SeparateInvoiceTaxesDelayed(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var _readerService = scope.Resolve<IReaderService>();
				var _payrollService = scope.Resolve<IPayrollService>();
				var _companyRepository = scope.Resolve<ICompanyRepository>();

				var invoices = _readerService.GetPayrollInvoices(status: new List<InvoiceStatus> { InvoiceStatus.OnHold }, paymentStatuses: new List<PaymentStatus>(), paymentMethods: new List<InvoicePaymentMethod>());	
				invoices.ForEach(i =>
				{
					i.Status = InvoiceStatus.Delivered;
					i.TaxesDelayed = true;
					var i1 = _payrollService.SavePayrollInvoice(i);
					Console.WriteLine("New Status {0}", i1.Status.GetDbName());
				});
			
			}
		}


		private static void FixAccumulationCycleAndYTD(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var _readerService = scope.Resolve<IReaderService>();
				var _payrollRepository = scope.Resolve<IPayrollRepository>();
				var _companyRepository = scope.Resolve<ICompanyRepository>();

				var payCheckList = new List<PayCheck>();
				var empList = new List<HrMaxx.OnlinePayroll.Models.Employee>();
				var leaveCycleEmployees = new List<LeaveCycleEmployee>();
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("979CF583-4796-496F-A414-A6ED0156EBFB"),OldFiscalStart = new DateTime(2017,1,2), NewFiscalStart = new DateTime(2017,1,1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("227DCBC0-2C8E-4116-9A4C-A6FA00B1688D"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("887F0FC6-B720-4AE2-A8CA-A6ED01536FC7"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("C8225E66-9FB6-408E-AB75-A6ED01537062"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F4B84B3A-536E-4C0F-B23A-A75B00A6310A"), OldFiscalStart = new DateTime(2017, 4, 21), NewFiscalStart = new DateTime(2017, 4, 20) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("B86121A9-C69A-4E0C-BDA6-A75B00A8403C"), OldFiscalStart = new DateTime(2017, 4, 21), NewFiscalStart = new DateTime(2017, 4, 20) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("4245E431-73EB-4A93-975C-A76F009B41A7"), OldFiscalStart = new DateTime(2017, 5, 11), NewFiscalStart = new DateTime(2017, 5, 10) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F842C501-FE89-4EF4-9731-A76F009CF259"), OldFiscalStart = new DateTime(2017, 5, 11), NewFiscalStart = new DateTime(2017, 5, 10) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("94C36C7B-8EF3-419C-AD04-A73100B59254"), OldFiscalStart = new DateTime(2017, 3, 10), NewFiscalStart = new DateTime(2017, 3, 9) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("CFA22B90-2206-4C32-A234-A777009C156C"), OldFiscalStart = new DateTime(2017, 5, 19), NewFiscalStart = new DateTime(2017, 5, 18) });

				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("D0855437-8643-4E50-AA93-A784009A597B"), OldFiscalStart = new DateTime(2017, 6, 1), NewFiscalStart = new DateTime(2017, 5, 31) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("89762729-1560-4A73-8A27-A6ED01579909"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("66D0F241-FFD0-487D-8AC1-A70700E42FA5"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("9105FD21-4EF7-4877-A3B7-A72300879337"), OldFiscalStart = new DateTime(2017, 2, 24), NewFiscalStart = new DateTime(2017, 2, 23) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("415ED0BF-8BFF-4C1A-8732-A72300890B3B"), OldFiscalStart = new DateTime(2017, 2, 24), NewFiscalStart = new DateTime(2017, 2, 23) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("CD16FF42-2439-49E4-817C-A73700FB1B9D"), OldFiscalStart = new DateTime(2017, 3, 16), NewFiscalStart = new DateTime(2017, 3, 15) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("717E808E-E60D-4FED-A95E-A73700FCB2FF"), OldFiscalStart = new DateTime(2017, 3, 16), NewFiscalStart = new DateTime(2017, 3, 15) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("C7AA35AA-5549-40F2-A34A-A73700FE71C9"), OldFiscalStart = new DateTime(2017, 3, 16), NewFiscalStart = new DateTime(2017, 3, 15) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("BAEE375C-F54E-4B09-877C-A73E0105EC72"), OldFiscalStart = new DateTime(2017, 3, 23), NewFiscalStart = new DateTime(2017, 3, 22) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("4B303004-3B13-4C3B-AAFE-A74D00E74319"), OldFiscalStart = new DateTime(2017, 4, 7), NewFiscalStart = new DateTime(2017, 4, 6) });

				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("C65C5E51-B298-4AE9-A04A-A6ED0152A55E"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("EBA50AEA-511A-4439-8BB4-A6ED0152A5E1"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("E06C5FED-E33F-42A0-B863-A70800C79529"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("95EF384F-3863-4096-8868-A75500C1ABAD"), OldFiscalStart = new DateTime(2017, 4, 15), NewFiscalStart = new DateTime(2017, 4, 14) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F0CA2BA2-0230-41B0-9F9D-A76300C009A9"), OldFiscalStart = new DateTime(2017, 4, 29), NewFiscalStart = new DateTime(2017, 4, 28) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("855D176A-A6A2-4F02-A8C7-A76A00C45630"), OldFiscalStart = new DateTime(2017, 5, 6), NewFiscalStart = new DateTime(2017, 5, 5) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("052A360E-3926-439A-9C5E-A76D00CAC32C"), OldFiscalStart = new DateTime(2017, 5, 9), NewFiscalStart = new DateTime(2017, 5, 8) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("FF127E53-CD60-4A8C-9370-A77500BDFD37"), OldFiscalStart = new DateTime(2017, 5, 17), NewFiscalStart = new DateTime(2017, 5, 16) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F7B77F52-7C04-4563-9CCC-A77500BE97E3"), OldFiscalStart = new DateTime(2017, 5, 17), NewFiscalStart = new DateTime(2017, 5, 16) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("DFCFBD0E-5BB2-444A-B19F-A77500BF54A6"), OldFiscalStart = new DateTime(2017, 5, 17), NewFiscalStart = new DateTime(2017, 5, 16) });

				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("0E80A5B5-9F6A-4FA0-A691-A77E00FCF11D"), OldFiscalStart = new DateTime(2017, 5, 26), NewFiscalStart = new DateTime(2017, 5, 25) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("0504755A-4246-4D44-8206-A70F00A09A2B"), OldFiscalStart = new DateTime(2017, 2, 24), NewFiscalStart = new DateTime(2017, 2, 23) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("170C8802-BCC8-4675-99F1-A70F00A5B303"), OldFiscalStart = new DateTime(2017, 2, 24), NewFiscalStart = new DateTime(2017, 2, 23) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("9E927320-ACCD-41AE-85BA-A71300D76550"), OldFiscalStart = new DateTime(2017, 2, 8), NewFiscalStart = new DateTime(2017, 2, 7) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("153C9CD4-CA57-4F8E-9BF8-A71600C61B84"), OldFiscalStart = new DateTime(2017, 2, 11), NewFiscalStart = new DateTime(2017, 2, 10) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("97665A9E-8EFE-4F13-A3E8-A73700D4B525"), OldFiscalStart = new DateTime(2017, 3, 16), NewFiscalStart = new DateTime(2017, 3, 15) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("CAA5D056-B313-4DAC-8F98-A73F00C22A3A"), OldFiscalStart = new DateTime(2017, 3, 24), NewFiscalStart = new DateTime(2017, 3, 23) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("3A9031F8-8223-4384-A5E2-A73F00CC784F"), OldFiscalStart = new DateTime(2017, 3, 24), NewFiscalStart = new DateTime(2017, 3, 23) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("7908685D-606D-49D1-B952-A75B00A57BAC"), OldFiscalStart = new DateTime(2017, 4, 21), NewFiscalStart = new DateTime(2017, 4, 20) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("91A09021-11D2-4568-A8F9-A76800AD9D02"), OldFiscalStart = new DateTime(2017, 5, 4), NewFiscalStart = new DateTime(2017, 5, 3) });

				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("0504755A-4246-4D44-8206-A70F00A09A2B"), OldFiscalStart = new DateTime(2017, 2, 4), NewFiscalStart = new DateTime(2017, 2, 3) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("170C8802-BCC8-4675-99F1-A70F00A5B303"), OldFiscalStart = new DateTime(2017, 2, 4), NewFiscalStart = new DateTime(2017, 2, 3) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("B02EF90E-F8EB-4C19-B4CE-A77D00B4357C"), OldFiscalStart = new DateTime(2017, 5, 25), NewFiscalStart = new DateTime(2017, 5, 24) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("C91414C0-302F-4B4D-B14B-6AD98BE4AA0C"), OldFiscalStart = new DateTime(2017, 3, 30), NewFiscalStart = new DateTime(2017, 3, 29) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("370D3D17-0101-4D37-A523-AD91FCB4D605"), OldFiscalStart = new DateTime(2017, 2, 16), NewFiscalStart = new DateTime(2017, 2, 15) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("B569C675-3ABA-4B98-A9BC-A6F300A2B232"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("EF37F268-36D0-450E-A01B-A75300BE35FB"), OldFiscalStart = new DateTime(2017, 4, 13), NewFiscalStart = new DateTime(2017, 4, 12) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("FACB2B60-D3B9-47B6-BFEE-A73900B728DB"), OldFiscalStart = new DateTime(2017, 3, 18), NewFiscalStart = new DateTime(2017, 3, 17) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("B596133B-5527-4FFC-B9C3-A70F00B41811"), OldFiscalStart = new DateTime(2017, 2, 4), NewFiscalStart = new DateTime(2017, 2, 3) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("C090DB1C-8006-4F9A-B8BB-A73900B777FB"), OldFiscalStart = new DateTime(2017, 3, 18), NewFiscalStart = new DateTime(2017, 3, 17) });

				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F463F9AC-E9C2-4075-81D3-A73700BEAA6A"), OldFiscalStart = new DateTime(2017, 3, 16), NewFiscalStart = new DateTime(2017, 3, 15) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("C3C12366-63F0-4C00-83E6-A70F00AC7051"), OldFiscalStart = new DateTime(2017, 2, 4), NewFiscalStart = new DateTime(2017, 2, 3) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("6493EE1E-DA0E-4DE1-B1B4-A72200A07E28"), OldFiscalStart = new DateTime(2017, 2, 23), NewFiscalStart = new DateTime(2017, 2, 22) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("4564AC4D-53CF-4F08-AB11-A72200A10F69"), OldFiscalStart = new DateTime(2017, 2, 23), NewFiscalStart = new DateTime(2017, 2, 22) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("DF20DC67-F205-4BFE-B127-A74400B2F2DC"), OldFiscalStart = new DateTime(2017, 3, 29), NewFiscalStart = new DateTime(2017, 3, 28) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("902786B7-04CD-4635-A83A-A77C00BFF83B"), OldFiscalStart = new DateTime(2017, 5, 24), NewFiscalStart = new DateTime(2017, 5, 23) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("96CCE43E-1581-4DFC-A404-A6ED014ECE97"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("0ABFC7EF-468D-44CF-8B44-A6ED014ED45B"), OldFiscalStart = new DateTime(2017, 1, 3), NewFiscalStart = new DateTime(2017, 1, 2) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("0ABFC7EF-468D-44CF-8B44-A6ED014ED45B"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("7A9C47C6-A53F-4526-BA3A-A72300CDFA74"), OldFiscalStart = new DateTime(2017, 2, 24), NewFiscalStart = new DateTime(2017, 2, 23) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("A76BF856-4568-4204-A639-A72800BA47FE"), OldFiscalStart = new DateTime(2017, 3, 1), NewFiscalStart = new DateTime(2017, 2, 28) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("E19F3385-27A4-46EA-975E-A72800BADD34"), OldFiscalStart = new DateTime(2017, 3, 1), NewFiscalStart = new DateTime(2017, 2, 28) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("C9764B07-E85A-4E95-9C27-A72800BBBB92"), OldFiscalStart = new DateTime(2017, 3, 1), NewFiscalStart = new DateTime(2017, 2, 28) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("E2AAAF0B-0154-4B54-BCD9-A77B00B6FE18"), OldFiscalStart = new DateTime(2017, 5, 23), NewFiscalStart = new DateTime(2017, 5, 22) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F4212E23-14CE-40FD-A910-A6ED01596803"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("60E6F47B-6383-4803-9A1F-A6ED0159688B"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("3A0AD396-868A-49D5-9BEE-A73700CA0876"), OldFiscalStart = new DateTime(2017, 3, 16), NewFiscalStart = new DateTime(2017, 3, 15) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("73017F37-6E1F-4FA0-B85E-A76D00B218E8"), OldFiscalStart = new DateTime(2017, 5, 9), NewFiscalStart = new DateTime(2017, 5, 8) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("D7961F8F-1B45-49F2-AD0B-A6ED0158C337"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("9CCCBB53-5264-4832-942F-A70D00BC67C9"), OldFiscalStart = new DateTime(2017, 2, 2), NewFiscalStart = new DateTime(2017, 2, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("FB976F09-085F-4C07-B425-A74B00B00B95"), OldFiscalStart = new DateTime(2017, 4, 5), NewFiscalStart = new DateTime(2017, 4, 4) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("19CAC5C4-6961-439C-925A-A77500A52117"), OldFiscalStart = new DateTime(2017, 5, 17), NewFiscalStart = new DateTime(2017, 5, 16) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("2FD88FDC-3CAA-48D8-8708-A73500B38578"), OldFiscalStart = new DateTime(2017, 3, 14), NewFiscalStart = new DateTime(2017, 3, 13) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("A757BD06-4B4D-4253-9AEF-A70F00C55707"), OldFiscalStart = new DateTime(2017, 2, 5), NewFiscalStart = new DateTime(2017, 2, 4) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("09A7BB5A-4480-4907-9D54-A77400B68DE3"), OldFiscalStart = new DateTime(2017, 5, 16), NewFiscalStart = new DateTime(2017, 5, 15) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F3FE723E-6FB2-41AE-8685-A75800A61E9B"), OldFiscalStart = new DateTime(2017, 4, 18), NewFiscalStart = new DateTime(2017, 4, 17) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("77056273-94E3-45BE-96EA-A76E009D7FC2"), OldFiscalStart = new DateTime(2017, 5, 10), NewFiscalStart = new DateTime(2017, 5, 9) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("59015FD0-B437-4FD1-82C9-A72A00F53D2E"), OldFiscalStart = new DateTime(2017, 3, 3), NewFiscalStart = new DateTime(2017, 3, 2) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("841C34DA-3059-40B7-B2B5-A74400B7DDF1"), OldFiscalStart = new DateTime(2017, 3, 29), NewFiscalStart = new DateTime(2017, 3, 28) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("8A8E4A5A-3F5A-4C7A-AB69-A74400B96A85"), OldFiscalStart = new DateTime(2017, 3, 29), NewFiscalStart = new DateTime(2017, 3, 28) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("D4D9FA54-3990-4884-8AF2-A74400BBBA81"), OldFiscalStart = new DateTime(2017, 3, 29), NewFiscalStart = new DateTime(2017, 3, 28) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("2703B5B0-9EE0-47F9-9ADA-A74E00A29D05"), OldFiscalStart = new DateTime(2017, 4, 8), NewFiscalStart = new DateTime(2017, 4, 7) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("72760DA1-EF67-48BD-8B47-A74E00A3CFA1"), OldFiscalStart = new DateTime(2017, 4, 8), NewFiscalStart = new DateTime(2017, 4, 7) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("093A37DE-BB81-4B96-8E0D-A74E00A50ED0"), OldFiscalStart = new DateTime(2017, 4, 8), NewFiscalStart = new DateTime(2017, 4, 7) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F42A232B-42E4-498D-B876-A75300AA7175"), OldFiscalStart = new DateTime(2017, 4, 13), NewFiscalStart = new DateTime(2017, 4, 12) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("E9CB7D56-E2D7-4152-B6CF-C10838928999"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("A49B5E5D-D8A9-481E-887C-8B0AFC0CEE6B"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });

				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("6E3F724B-4DD2-43A0-BC95-A71C00BE32C8"), OldFiscalStart = new DateTime(2017, 2, 17), NewFiscalStart = new DateTime(2017, 2, 16) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("5134A09A-AA3A-4E57-B3A1-A71C00BF1833"), OldFiscalStart = new DateTime(2017, 2, 17), NewFiscalStart = new DateTime(2017, 2, 16) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("20C78637-7495-4C04-B0AC-A6ED014DB432"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("0675E56F-D18F-483C-8BEF-A6ED014F1E20"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("4A5E1F6F-6194-467C-8B24-A73100D80D8B"), OldFiscalStart = new DateTime(2017, 3, 10), NewFiscalStart = new DateTime(2017, 3, 9) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("0273CCF5-8DE0-4836-9FBE-A77700B2B7FE"), OldFiscalStart = new DateTime(2017, 5, 19), NewFiscalStart = new DateTime(2017, 5, 18) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("64F5E859-591A-417B-9A0D-A77D00CCF102"), OldFiscalStart = new DateTime(2017, 5, 25), NewFiscalStart = new DateTime(2017, 5, 24) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("08E7DE3E-C496-4FAC-A557-A6ED015635C6"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("3CBE1010-3837-46B7-B6A6-A77E00AD75B4"), OldFiscalStart = new DateTime(2017, 5, 26), NewFiscalStart = new DateTime(2017, 5, 25) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F1FA9B13-4B02-417F-9077-A74C00A3BFC9"), OldFiscalStart = new DateTime(2017, 4, 6), NewFiscalStart = new DateTime(2017, 4, 5) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("9AC07F4B-7184-4E3C-AA09-A71300C10A71"), OldFiscalStart = new DateTime(2017, 2, 8), NewFiscalStart = new DateTime(2017, 2, 7) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("728EC1A4-2277-4669-ADAF-A74300BF52CC"), OldFiscalStart = new DateTime(2017, 3, 28), NewFiscalStart = new DateTime(2017, 3, 27) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("90794DF7-56E7-4C4C-A782-A72900B0004F"), OldFiscalStart = new DateTime(2017, 3, 2), NewFiscalStart = new DateTime(2017, 3, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("28E9AA5F-84F5-4C73-9471-A72900B099CC"), OldFiscalStart = new DateTime(2017, 3, 3), NewFiscalStart = new DateTime(2017, 3, 2) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("807E3E79-5691-441F-9C54-A72900B1906A"), OldFiscalStart = new DateTime(2017, 3, 2), NewFiscalStart = new DateTime(2017, 3, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("A1D5CDA1-5B5F-4FDD-9D68-A6FA00BB854E"), OldFiscalStart = new DateTime(2017, 2, 9), NewFiscalStart = new DateTime(2017, 2, 8) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("B1028404-E822-4925-A865-A6ED01524532"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("CE258729-392D-48A2-8110-A72400B29037"), OldFiscalStart = new DateTime(2017, 2, 25), NewFiscalStart = new DateTime(2017, 2, 24) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("AAF9DDD5-DF66-4DFF-BD04-A72400B33650"), OldFiscalStart = new DateTime(2017, 2, 25), NewFiscalStart = new DateTime(2017, 2, 24) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("5160D8D7-E506-4160-9A9B-A72400B389EF"), OldFiscalStart = new DateTime(2017, 2, 25), NewFiscalStart = new DateTime(2017, 2, 24) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("05D86BC8-193C-496E-8CC0-A747009FE4DE"), OldFiscalStart = new DateTime(2017, 4, 1), NewFiscalStart = new DateTime(2017, 3, 31) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("50CC6F76-0C4F-444C-814E-A74700A05533"), OldFiscalStart = new DateTime(2017, 4, 1), NewFiscalStart = new DateTime(2017, 3, 31) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("3273C719-D9A1-4A44-A0B3-A6ED01561671"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("AC4A3AFE-0032-4D32-BEF1-A78C00AD9C18"), OldFiscalStart = new DateTime(2017, 6, 9), NewFiscalStart = new DateTime(2017, 6, 8) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("6C446D0D-990F-444F-9189-A73600C2C223"), OldFiscalStart = new DateTime(2017, 3, 15), NewFiscalStart = new DateTime(2017, 3, 14) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("A118DE32-D1B8-40E4-B898-A73800AA2E11"), OldFiscalStart = new DateTime(2017, 3, 17), NewFiscalStart = new DateTime(2017, 3, 16) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("8A7D3E12-DE70-4CF1-803D-A6ED014E6F56"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("604F8D61-D5DC-4CCE-AE76-A77C00A73854"), OldFiscalStart = new DateTime(2017, 5, 24), NewFiscalStart = new DateTime(2017, 5, 23) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("90661B59-5FF9-4AB2-9CDC-A78300BC6EAD"), OldFiscalStart = new DateTime(2017, 5, 31), NewFiscalStart = new DateTime(2017, 5, 30) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("3EC6A9CE-BCF8-48AF-B793-A70100D15BFF"), OldFiscalStart = new DateTime(2017, 1, 21), NewFiscalStart = new DateTime(2017, 1, 20) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("EA782E25-EB42-4EFB-98D3-A740009AAE57"), OldFiscalStart = new DateTime(2017, 3, 25), NewFiscalStart = new DateTime(2017, 3, 24) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("EA782E25-EB42-4EFB-98D3-A740009AAE57"), OldFiscalStart = new DateTime(2017, 3, 26), NewFiscalStart = new DateTime(2017, 3, 25) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("E0BD5273-49BF-43D9-B8D2-A740009B05A6"), OldFiscalStart = new DateTime(2017, 3, 25), NewFiscalStart = new DateTime(2017, 3, 24) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("E0BD5273-49BF-43D9-B8D2-A740009B05A6"), OldFiscalStart = new DateTime(2017, 3, 26), NewFiscalStart = new DateTime(2017, 3, 25) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("EC11947E-C1C8-4298-BD28-A6F900AC51F9"), OldFiscalStart = new DateTime(2016, 7, 8), NewFiscalStart = new DateTime(2016, 7, 7) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("4018353B-99BE-47BE-B12F-A74C00F77FCB"), OldFiscalStart = new DateTime(2017, 4, 6), NewFiscalStart = new DateTime(2017, 4, 5) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("6B81C4C4-1497-4FB2-9DE4-A74500A75BBE"), OldFiscalStart = new DateTime(2017, 3, 30), NewFiscalStart = new DateTime(2017, 3, 29) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("651C753F-8472-4E77-BE5D-A74500A7FD14"), OldFiscalStart = new DateTime(2017, 3, 30), NewFiscalStart = new DateTime(2017, 3, 29) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("676E335C-BE39-4B3B-98EA-A74500A9AB58"), OldFiscalStart = new DateTime(2017, 3, 30), NewFiscalStart = new DateTime(2017, 3, 29) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("CDBAD246-53CE-40F1-B494-A74500AA4766"), OldFiscalStart = new DateTime(2017, 3, 30), NewFiscalStart = new DateTime(2017, 3, 29) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("BCA5CC20-DC37-4857-932C-A72800F8329F"), OldFiscalStart = new DateTime(2017, 3, 2), NewFiscalStart = new DateTime(2017, 3, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("9CD6606E-E9D7-428C-9CB4-A76200B5DFF9"), OldFiscalStart = new DateTime(2017, 4, 28), NewFiscalStart = new DateTime(2017, 4, 27) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("A34CD49B-2BBE-4437-A82D-A75C00AA5AFE"), OldFiscalStart = new DateTime(2017, 4, 22), NewFiscalStart = new DateTime(2017, 4, 21) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("0085887D-F732-4021-8D84-A75C00BF76CC"), OldFiscalStart = new DateTime(2017, 4, 22), NewFiscalStart = new DateTime(2017, 4, 21) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("11D08777-A636-42D6-BB57-A74C00C31D25"), OldFiscalStart = new DateTime(2017, 4, 6), NewFiscalStart = new DateTime(2017, 4, 5) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("A71740E1-96A0-4251-BA64-A74C00C3EB38"), OldFiscalStart = new DateTime(2017, 4, 6), NewFiscalStart = new DateTime(2017, 4, 5) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("6EA89209-BBBA-48B1-A9E4-A74C00C43F7C"), OldFiscalStart = new DateTime(2017, 4, 6), NewFiscalStart = new DateTime(2017, 4, 5) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("8DC86F1D-D1E9-4C12-8A52-A74C00C49123"), OldFiscalStart = new DateTime(2017, 4, 6), NewFiscalStart = new DateTime(2017, 4, 5) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("A2786CC0-2C77-4184-A865-A74C00C50EAF"), OldFiscalStart = new DateTime(2017, 4, 6), NewFiscalStart = new DateTime(2017, 4, 5) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("33F9CB38-925E-4857-9256-A74C01032EEF"), OldFiscalStart = new DateTime(2017, 4, 6), NewFiscalStart = new DateTime(2017, 4, 5) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("FB070A3A-3076-4B48-BBB7-A74C01074925"), OldFiscalStart = new DateTime(2017, 4, 6), NewFiscalStart = new DateTime(2017, 4, 5) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("E9D93ACD-6FD7-4B49-B3A5-A716009A27A8"), OldFiscalStart = new DateTime(2017, 2, 11), NewFiscalStart = new DateTime(2017, 2, 10) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("5D756EBD-6CC2-47BB-96B8-A71600A53F10"), OldFiscalStart = new DateTime(2017, 2, 11), NewFiscalStart = new DateTime(2017, 2, 10) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("126DF2B1-CB38-4939-84FC-A6ED014CC3B6"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("49ED700F-1A28-42FD-85DA-A76600C43492"), OldFiscalStart = new DateTime(2017, 5, 2), NewFiscalStart = new DateTime(2017, 5, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("52BAB27B-6750-44A7-9ADF-A72300A93953"), OldFiscalStart = new DateTime(2017, 2, 24), NewFiscalStart = new DateTime(2017, 2, 23) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("A41498C8-DC64-4884-AEA9-A6ED0159F928"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("C9979ADA-4A30-40A8-8816-4038855DFAE9"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("833BF5C6-0C1C-451B-B3E4-6380CB6EE638"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("2488907E-927E-45FF-97F0-B87321512700"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("95B5FFD1-2232-466E-BDC0-A73600BFD5FE"), OldFiscalStart = new DateTime(2017, 2, 13), NewFiscalStart = new DateTime(2017, 2, 12) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("829514DB-37C5-420B-B018-A75A01011A95"), OldFiscalStart = new DateTime(2017, 4, 20), NewFiscalStart = new DateTime(2017, 4, 19) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F4C2507B-DAC4-4E8E-9D91-A75A010177A9"), OldFiscalStart = new DateTime(2017, 4, 20), NewFiscalStart = new DateTime(2017, 4, 19) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F48FB93A-9377-497E-A8CE-A75A0102FBE2"), OldFiscalStart = new DateTime(2017, 4, 20), NewFiscalStart = new DateTime(2017, 4, 19) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("DC83F028-F9E9-4D15-89C7-A73100B496BC"), OldFiscalStart = new DateTime(2017, 3, 11), NewFiscalStart = new DateTime(2017, 3, 10) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("B0E74CF6-D73B-4E91-88FE-A73100B78FFD"), OldFiscalStart = new DateTime(2017, 3, 11), NewFiscalStart = new DateTime(2017, 3, 10) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("C4EEAEC3-7F81-42A8-895A-A73200ABCE0E"), OldFiscalStart = new DateTime(2017, 3, 12), NewFiscalStart = new DateTime(2017, 3, 11) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("3F52F21D-3984-4AC0-8077-A73200AF05F3"), OldFiscalStart = new DateTime(2017, 3, 13), NewFiscalStart = new DateTime(2017, 3, 12) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("1D5B6E85-2F00-4745-8CCB-A70E00829592"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("3660DB19-F1FF-4EB2-9D02-A76300A389D4"), OldFiscalStart = new DateTime(2017, 4, 29), NewFiscalStart = new DateTime(2017, 4, 28) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F4BFD81A-056E-4814-8B99-A7710115B072"), OldFiscalStart = new DateTime(2017, 5, 13), NewFiscalStart = new DateTime(2017, 5, 12) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("90E963BA-2694-4FC6-9C2E-A7710116D45D"), OldFiscalStart = new DateTime(2017, 5, 13), NewFiscalStart = new DateTime(2017, 5, 12) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("BBF05FF3-F43D-4DB1-A973-A771011720FD"), OldFiscalStart = new DateTime(2017, 5, 13), NewFiscalStart = new DateTime(2017, 5, 12) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("BCEA660A-ABD9-4A04-BEF3-CCD37BB0EF0F"), OldFiscalStart = new DateTime(2017, 5, 10), NewFiscalStart = new DateTime(2017, 5, 9) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("308DE758-0C08-455F-846A-A70E00F3D705"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("2F67003E-B02E-491E-885C-A71200D175B9"), OldFiscalStart = new DateTime(2017, 2, 7), NewFiscalStart = new DateTime(2017, 2, 6) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("CF0E7F8D-5D58-41C5-9C0E-A6ED0154416F"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("718DCC70-CE87-4C89-B630-A78600A28F4D"), OldFiscalStart = new DateTime(2017, 6, 3), NewFiscalStart = new DateTime(2017, 6, 2) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("073B408D-5155-4E25-AC61-A78600A380BE"), OldFiscalStart = new DateTime(2017, 6, 3), NewFiscalStart = new DateTime(2017, 6, 2) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("99948087-C5AA-4EFE-867F-A78600A44C62"), OldFiscalStart = new DateTime(2017, 6, 3), NewFiscalStart = new DateTime(2017, 6, 2) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("5D550BFB-4507-409A-B500-A74300C32F79"), OldFiscalStart = new DateTime(2017, 3, 28), NewFiscalStart = new DateTime(2017, 3, 27) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("005B053D-97FE-4484-A51E-A74300C386D5"), OldFiscalStart = new DateTime(2017, 3, 28), NewFiscalStart = new DateTime(2017, 3, 27) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("0460CDA0-1EE3-4296-A1C2-A72E00AFCA3E"), OldFiscalStart = new DateTime(2017, 3, 7), NewFiscalStart = new DateTime(2017, 3, 6) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("3AED00FD-4874-4C65-98D0-A71C00D080D2"), OldFiscalStart = new DateTime(2017, 2, 17), NewFiscalStart = new DateTime(2017, 2, 16) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("B016D29F-6953-4C06-A58A-A73700C6DB3C"), OldFiscalStart = new DateTime(2017, 3, 16), NewFiscalStart = new DateTime(2017, 3, 15) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("510731E9-E547-40DF-9D46-A6ED014C9546"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("D8B6C3F9-0290-444B-BF35-A6ED014C9664"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("DBA2F0EF-0FBC-4C3D-8909-A6ED014C9761"), OldFiscalStart = new DateTime(2017, 1, 3), NewFiscalStart = new DateTime(2017, 1, 2) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("DBA2F0EF-0FBC-4C3D-8909-A6ED014C9761"), OldFiscalStart = new DateTime(2017, 1, 3), NewFiscalStart = new DateTime(2017, 1, 2) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("244F6BF9-1F51-4861-96A4-A6ED014C9B84"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("89DA998C-8A6A-490A-AACA-A77801024A31"), OldFiscalStart = new DateTime(2017, 5, 20), NewFiscalStart = new DateTime(2017, 5, 19) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("B23D4696-78EC-4419-8C43-A77801029D64"), OldFiscalStart = new DateTime(2017, 5, 20), NewFiscalStart = new DateTime(2017, 5, 19) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("182097DF-6288-4AC6-B89E-A75500C0A909"), OldFiscalStart = new DateTime(2017, 4, 15), NewFiscalStart = new DateTime(2017, 4, 14) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("EFC342F7-9DDF-490C-A71F-A6ED01598365"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("7CC1C593-2B23-4936-BEFD-A6ED0159866F"), OldFiscalStart = new DateTime(2017, 1, 3), NewFiscalStart = new DateTime(2017, 1, 2) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("7CC1C593-2B23-4936-BEFD-A6ED0159866F"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F91D5945-1CBF-48E6-9868-A6F200C0421C"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("3CC78AD6-F7FA-428B-B204-A6F200C92118"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("E66D12DD-B8A1-4936-8375-A70E00BE656D"), OldFiscalStart = new DateTime(2017, 2, 3), NewFiscalStart = new DateTime(2017, 2, 2) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("4D947614-C846-4C7B-815C-A73200BE9293"), OldFiscalStart = new DateTime(2017, 3, 11), NewFiscalStart = new DateTime(2017, 3, 10) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("C4BDF1DA-BCD5-4F47-BEE8-A74E00A386C6"), OldFiscalStart = new DateTime(2017, 4, 8), NewFiscalStart = new DateTime(2017, 4, 7) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("5C4E9145-82BD-4BFB-AD81-A76A00BC2C77"), OldFiscalStart = new DateTime(2017, 5, 6), NewFiscalStart = new DateTime(2017, 5, 5) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("CEF9D8C7-0B95-4EDB-9315-A77800ACF9B5"), OldFiscalStart = new DateTime(2017, 5, 20), NewFiscalStart = new DateTime(2017, 5, 19) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("6EAFD111-6E48-4D73-9813-A75F00CD86D9"), OldFiscalStart = new DateTime(2017, 4, 25), NewFiscalStart = new DateTime(2017, 4, 24) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("94A6E8C3-E6D9-43D9-8866-A77E00C2A951"), OldFiscalStart = new DateTime(2017, 5, 26), NewFiscalStart = new DateTime(2017, 5, 25) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F70C14D0-69A2-4A7D-B5CB-A6ED014DC961"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("68C6CA96-EF5C-4903-B289-A6ED014DC9BB"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("09909B25-B817-48BE-AA06-A76D00A1D7E3"), OldFiscalStart = new DateTime(2017, 5, 9), NewFiscalStart = new DateTime(2017, 5, 8) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("242FA9A1-0828-4757-B172-A76F00EB89BF"), OldFiscalStart = new DateTime(2017, 5, 11), NewFiscalStart = new DateTime(2017, 5, 10) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("94E255BD-69A8-4C47-8632-A6F900D83BE0"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("C9E85E0E-8857-4230-B5BD-A72A00BC955D"), OldFiscalStart = new DateTime(2017, 3, 3), NewFiscalStart = new DateTime(2017, 3, 2) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("DF494F55-40A4-4C33-841C-A72A00BDBCA6"), OldFiscalStart = new DateTime(2017, 3, 3), NewFiscalStart = new DateTime(2017, 3, 2) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("80BE45AC-741F-4AAA-87DD-A74E00A17397"), OldFiscalStart = new DateTime(2017, 4, 8), NewFiscalStart = new DateTime(2017, 4, 7) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("81FC9388-E34B-46B0-9C7F-A77D00BC4B04"), OldFiscalStart = new DateTime(2017, 5, 25), NewFiscalStart = new DateTime(2017, 5, 24) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("B4B728DC-4705-446A-ABFD-A77D00BD0CD0"), OldFiscalStart = new DateTime(2017, 5, 25), NewFiscalStart = new DateTime(2017, 5, 24) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("BA27A17B-B453-46E0-8C14-A6ED014F0B8D"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("0B69C05E-ADCE-4001-B2E5-A77600A61C87"), OldFiscalStart = new DateTime(2017, 5, 18), NewFiscalStart = new DateTime(2017, 5, 17) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("4FE78800-0E9F-4E40-ACDF-A75C00B7167F"), OldFiscalStart = new DateTime(2017, 4, 22), NewFiscalStart = new DateTime(2017, 4, 21) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("C6AA3FB3-3469-4E05-B638-A6ED014B797E"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("06480A85-707F-45E1-87CC-A74700AE0D88"), OldFiscalStart = new DateTime(2017, 4, 1), NewFiscalStart = new DateTime(2017, 3, 31) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("AF71039C-ABF8-4A6D-9607-A73100ABCB45"), OldFiscalStart = new DateTime(2017, 3, 10), NewFiscalStart = new DateTime(2017, 3, 9) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("68CE5847-5B51-47B1-94B9-A75B00C0D14C"), OldFiscalStart = new DateTime(2017, 4, 21), NewFiscalStart = new DateTime(2017, 4, 20) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("39A3597B-774B-44E7-9133-A78C00A87D72"), OldFiscalStart = new DateTime(2017, 6, 9), NewFiscalStart = new DateTime(2017, 6, 8) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("387197AA-D033-4DB0-8A6E-A6ED0154DB92"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("888FD876-FB34-4009-95B0-A6ED0154DFE4"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("7104C20A-F3E8-4220-8DC7-A6ED0154EAE5"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("BB53FDE8-D4AB-4346-89BD-A6ED0154FB56"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("9A01F0EE-1E96-412F-A087-A76100D5C609"), OldFiscalStart = new DateTime(2017, 4, 27), NewFiscalStart = new DateTime(2017, 4, 26) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("2C11A9D9-1002-4956-9164-A71B00BFF5F4"), OldFiscalStart = new DateTime(2017, 2, 16), NewFiscalStart = new DateTime(2017, 2, 15) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("135C108F-E9D8-4881-B199-A72900B69FEA"), OldFiscalStart = new DateTime(2017, 3, 2), NewFiscalStart = new DateTime(2017, 3, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("8A4796ED-8E5B-4637-A64D-A76E01135AD5"), OldFiscalStart = new DateTime(2017, 5, 10), NewFiscalStart = new DateTime(2017, 5, 9) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("017C6698-A871-4C36-BCD4-A76E0113CEA3"), OldFiscalStart = new DateTime(2017, 5, 10), NewFiscalStart = new DateTime(2017, 5, 9) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("4E4D3FC2-6654-4D34-96C9-A76E0114D228"), OldFiscalStart = new DateTime(2017, 5, 10), NewFiscalStart = new DateTime(2017, 5, 9) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("8C15BA59-808A-4E38-B245-A78400AACD2E"), OldFiscalStart = new DateTime(2017, 6, 1), NewFiscalStart = new DateTime(2017, 5, 31) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("5D310AD5-4B66-423D-AD54-A6ED015674B5"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("AA0C65AF-BE0C-41C8-B41B-A7470110F2E9"), OldFiscalStart = new DateTime(2017, 4, 1), NewFiscalStart = new DateTime(2017, 3, 31) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("7858A641-4951-4B85-A06B-A76A00C4B3ED"), OldFiscalStart = new DateTime(2017, 5, 6), NewFiscalStart = new DateTime(2017, 5, 5) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("E5FA3F38-DC81-4F92-80A1-A78500BAE69B"), OldFiscalStart = new DateTime(2017, 6, 2), NewFiscalStart = new DateTime(2017, 6, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("4284C0D5-8B7B-4C8E-886F-A79000B55299"), OldFiscalStart = new DateTime(2017, 6, 13), NewFiscalStart = new DateTime(2017, 6, 12) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("B98DA369-48D5-4007-92FB-A79E009E59F1"), OldFiscalStart = new DateTime(2017, 6, 27), NewFiscalStart = new DateTime(2017, 6, 26) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("808A594E-3870-4C87-AD84-A73200A9CE67"), OldFiscalStart = new DateTime(2017, 3, 11), NewFiscalStart = new DateTime(2017, 3, 10) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("DDC3ED4F-6AEF-474C-80D4-A77000FBA473"), OldFiscalStart = new DateTime(2017, 5, 12), NewFiscalStart = new DateTime(2017, 5, 11) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("A5E69A6F-0C16-42D9-9D13-A76600ED0AC0"), OldFiscalStart = new DateTime(2017, 5, 2), NewFiscalStart = new DateTime(2017, 5, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("1B16E501-6383-48B3-81F8-A6ED014B54F4"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("6BB52FD2-C741-4E9F-B253-A6ED01596A57"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("6EA3EA15-86C0-45EB-A7BA-11C3835F98CE"), OldFiscalStart = new DateTime(2017, 4, 11), NewFiscalStart = new DateTime(2017, 4, 10) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("89A73068-3FD9-431E-8B10-A78600B5B946"), OldFiscalStart = new DateTime(2017, 6, 3), NewFiscalStart = new DateTime(2017, 6, 2) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("549DB64D-FA13-4FAF-B6FD-A7A000A9AC10"), OldFiscalStart = new DateTime(2017, 6, 29), NewFiscalStart = new DateTime(2017, 6, 28) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("DE7EE3B3-E85A-4056-A90A-A71300C17EE9"), OldFiscalStart = new DateTime(2017, 2, 9), NewFiscalStart = new DateTime(2017, 2, 8) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("44C7F7FE-66CE-417B-BE42-A73200ADA46E"), OldFiscalStart = new DateTime(2017, 3, 12), NewFiscalStart = new DateTime(2017, 3, 11) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("2036F061-FBD1-48B2-A748-A78B0098CC40"), OldFiscalStart = new DateTime(2017, 6, 8), NewFiscalStart = new DateTime(2017, 6, 7) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("D5B793B2-2F7E-4F94-9409-A70C00B234EE"), OldFiscalStart = new DateTime(2017, 1, 3), NewFiscalStart = new DateTime(2017, 1, 2) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("AFAB215C-19FD-4B01-BF4B-A6F200D6A706"), OldFiscalStart = new DateTime(2017, 1, 2), NewFiscalStart = new DateTime(2017, 1, 1) });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("38DEC00D-0DDF-44AC-A5CD-A76F00EC7B74"), OldFiscalStart = new DateTime(2017, 5, 11), NewFiscalStart = new DateTime(2017, 5, 10) });

				leaveCycleEmployees.ForEach(e =>
				{
					var employee = _companyRepository.GetEmployeeById(e.EmployeeId);
					
					if (employee.SickLeaveHireDate.Date != e.NewFiscalStart.Date)
					{
						employee.SickLeaveHireDate = e.NewFiscalStart.Date;
						empList.Add(employee);
					}

					var annualLimit = employee.CompanyId == new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58") ||
														employee.CompanyId == new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28")
						? (decimal)48
						: (decimal)24;
					var checks = _readerService.GetPayChecks(employeeId: e.EmployeeId);
					var firstcarryover = (decimal) checks.OrderBy(p => p.Id).First(p=>p.Accumulations.Any()).Accumulations.First().CarryOver;
					checks.Where(p=>p.Accumulations.Any(a=>a.FiscalStart.Date==e.OldFiscalStart.Date)).OrderBy(p=>p.Id).ToList().ForEach(
						p =>
						{
							p.Accumulations.Where(a=>a.FiscalStart.Date==e.OldFiscalStart.Date).ToList().ForEach(a =>
							{
								a.FiscalStart = e.NewFiscalStart.Date;
								a.FiscalEnd = a.FiscalStart.AddYears(1).AddDays(-1).Date;
								var ytdAccumulation =
									checks.Where(pc => pc.Id < p.Id).SelectMany(pc => pc.Accumulations).Sum(ac => ac.AccumulatedValue);

								if ((ytdAccumulation + a.AccumulatedValue) >= a.PayType.AnnualLimit)
									a.AccumulatedValue = Math.Max(a.PayType.AnnualLimit - ytdAccumulation, 0);

								a.YTDFiscal = Math.Round(ytdAccumulation + a.AccumulatedValue,2,MidpointRounding.AwayFromZero);
								a.YTDUsed = checks.Where(pc => pc.Id < p.Id).SelectMany(pc => pc.Accumulations).Sum(ac => ac.Used) + a.Used;
								a.CarryOver = (decimal)firstcarryover;
							});
							payCheckList.Add(p);
						});

				});
				Console.WriteLine("PayChecks " + payCheckList.Count); 
				Console.WriteLine("Employees " + empList.Count);
				using (var txn = TransactionScopeHelper.TransactionNoTimeout())
				{
					payCheckList.ForEach(_payrollRepository.UpdatePayCheckSickLeaveAccumulation);
					empList.ForEach(e =>
					{
						_companyRepository.SaveEmployee(e);
						Console.WriteLine("E {0}, {1}, {2}",e.CompanyEmployeeNo, e.FullName, e.Id);
					});
					txn.Complete();
				}
			}
		}


		private static void FixAccumulationCycleAndYTDForPEO(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var _readerService = scope.Resolve<IReaderService>();
				var _payrollRepository = scope.Resolve<IPayrollRepository>();
				var _companyRepository = scope.Resolve<ICompanyRepository>();

				var payCheckList = new List<PayCheck>();
				var empList = new List<HrMaxx.OnlinePayroll.Models.Employee>();
				var leaveCycleEmployees = new List<LeaveCycleEmployee>();
				#region "employee cycles"
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("91342FA5-8457-4EF4-A1B3-A769011747F8"), NewFiscalStart = new DateTime(2017, 4, 27), CarryOver = 0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("70407278-E3C9-4119-B2E3-A76D00CB1A04"), NewFiscalStart = new DateTime(2017, 4, 20), CarryOver = 0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("36C99ED4-499F-419B-9444-A70100BFD8B3"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = 0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("D56EDB48-BC0D-46FA-B3A7-A78600A9EBA7"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = 24 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("1A57B387-69C7-40C7-9F9F-A6F300D23BC0"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)3.42 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("C0E1A5BA-1C5A-433D-8760-A6F200193494"), NewFiscalStart = new DateTime(2016, 5, 9), CarryOver = 24 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("71AB1C29-AB73-41A5-826B-A6ED0157A2F6"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)11.61 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("2519CD8A-FD1A-43BB-8BCB-9B0561737745"), NewFiscalStart = new DateTime(2017, 5, 8), CarryOver = 0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("0CF9E3E5-1491-4ED0-82C3-A6ED015600D1"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = 0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("D1221921-5283-4374-8037-527B9F863F42"), NewFiscalStart = new DateTime(2016, 7, 1), CarryOver = 0 });

				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("CF471BF1-5C07-4E69-A3D2-A79400C3203A"), NewFiscalStart = new DateTime(2017, 6, 12), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("0818E8A6-B5C8-4F4C-AAEC-A7B400B69380"), NewFiscalStart = new DateTime(2017, 7, 6), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("404A4634-7032-4BC7-BA0C-A6F300AA2B72"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)19.88 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("386A6E48-B1E0-4DF1-AFDE-A73E010740E5"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)7.51 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("640CA660-EBC4-42D9-B4CB-A769011822FF"), NewFiscalStart = new DateTime(2017, 5, 4), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("E196E5F3-FA21-4EC4-8730-A6F901022B79"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("429CB9B3-C410-47A6-B10E-A728009BF54B"), NewFiscalStart = new DateTime(2017, 2, 28), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("0DF42C13-7971-4202-9331-A7690116CD43"), NewFiscalStart = new DateTime(2017, 5, 4), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("92D970C5-A2EC-4C7D-B3BB-A7690117B5F1"), NewFiscalStart = new DateTime(2017, 5, 4), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F3C3959B-B67D-4C2F-9AB7-A76D00C8C16C"), NewFiscalStart = new DateTime(2017, 5, 8), CarryOver = (decimal)0 });

				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("0700B0E8-6646-45B8-A63A-A769011664AD"), NewFiscalStart = new DateTime(2017, 5, 4), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F14B026F-85B4-4FD2-9EAC-A76901141D2C"), NewFiscalStart = new DateTime(2017, 5, 4), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("52FDA1A4-1D03-474D-A38D-A6ED0156082E"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("244A67D9-4F02-4B0E-9D87-C66132EAC59E"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("65DD8BA8-525F-43CB-A692-A6F900D628D7"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)24 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F82D7957-0538-42C1-8B62-A78600A93515"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)24 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("D4FA0762-5307-4FE5-8FEF-A71B00DDBD9A"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("BBE32717-A722-4620-A741-A768009BD1A8"), NewFiscalStart = new DateTime(2017, 5, 3), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("33FE3166-3ACD-42F4-A66C-A6F300EA9F25"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)4.32 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("74559EE2-9FAD-47DA-B046-A7BD00C13D52"), NewFiscalStart = new DateTime(2017, 2, 23), CarryOver = (decimal)0 });

				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("C53A186F-644B-480A-8D5E-A77000A65A59"), NewFiscalStart = new DateTime(2017, 5, 3), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("FA8C074B-2A61-4C57-B584-A6ED01514B5C"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)8 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("BABE9F3F-9368-41B0-A9CA-A6ED0155BAB8"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("9AE5F074-CF53-401D-A207-A6F300AA31BA"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)16.62 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F0CA2BA2-0230-41B0-9F9D-A76300C009A9"), NewFiscalStart = new DateTime(2017, 4, 12), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("0959C77E-2A4E-4834-8A61-A6ED0155FA80"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F266DDE1-A8D5-4A3C-B478-F3EDC49DA756"), NewFiscalStart = new DateTime(2017, 5, 15), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("7C00DA6E-7B62-41D7-AEA2-A6ED0150E544"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)19 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F56B63D5-2AE9-4307-8CF9-423B8E9A2722"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)23.33 });

				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("C2439697-72D2-406F-A189-A6F800A5EA37"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("DD5AE2F7-9793-45C4-9AFB-A6F300AA03F9"), NewFiscalStart = new DateTime(2017, 1, 1), CarryOver = (decimal)22 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("C2C9ED5A-28FF-4167-8D01-A76D00CB6612"), NewFiscalStart = new DateTime(2017, 5, 8), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("7A33ECF0-8B41-4E1A-991D-A76E009C955A"), NewFiscalStart = new DateTime(2017, 5, 9), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("AD72E3C5-9C80-4B0D-9EA9-A7690115C798"), NewFiscalStart = new DateTime(2017, 5, 4), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("3A4B9D79-CF4A-4E54-B81C-A76901150708"), NewFiscalStart = new DateTime(2017, 5, 4), CarryOver = (decimal)0 });
				leaveCycleEmployees.Add(new LeaveCycleEmployee { EmployeeId = new Guid("F70AAC53-AC9C-4286-B69C-A769011C83C3"), NewFiscalStart = new DateTime(2017, 2, 17), CarryOver = (decimal)0 });
				#endregion
				leaveCycleEmployees.ForEach(e =>
				{
					var employee = _companyRepository.GetEmployeeById(e.EmployeeId);
					var company = _readerService.GetCompany(employee.CompanyId);
					employee.SickLeaveHireDate = e.NewFiscalStart.Date;
					employee.CarryOver = e.CarryOver;
					empList.Add(employee);

					var newFiscalEndDate = e.NewFiscalStart.AddYears(1).AddDays(-1).Date;
					var checks = _readerService.GetEmployeePayChecks(e.EmployeeId);
					
					checks.Where(p => !p.IsHistory).OrderBy(p => p.PayDay).ThenBy(p=>p.Id).ToList().ForEach(
						p =>
						{
							p.Accumulations.ForEach(a =>
							{
								if (p.PayDay >= e.NewFiscalStart.Date && p.PayDay <=newFiscalEndDate)
								{
									a.FiscalStart = e.NewFiscalStart.Date;
									a.FiscalEnd = newFiscalEndDate;
								}
								else
								{
									a.FiscalStart = CalculateFiscalStartDate(employee.SickLeaveHireDate.Date, p.PayDay).Date;
									a.FiscalEnd = a.FiscalStart.AddYears(1).AddDays(-1).Date;
								}
								
								var ytdAccumulation =
									checks.Where(pc =>!pc.IsHistory && (pc.PayDay.Date<p.PayDay || (pc.PayDay.Date==p.PayDay.Date && pc.Id<p.Id)) && pc.Accumulations.Any(a1=>a1.FiscalStart==a.FiscalStart && a1.FiscalEnd==a.FiscalEnd)).SelectMany(pc => pc.Accumulations);
								var prevs =
									checks.Where(
										pc =>
											!pc.IsHistory && (pc.PayDay.Date < p.PayDay || (pc.PayDay.Date == p.PayDay.Date && pc.Id < p.Id)) && pc.Accumulations.Any(a1 => a1.FiscalStart < a.FiscalStart))
										.SelectMany(pc => pc.Accumulations);
								var ytdfiscal = ytdAccumulation.Sum(a2 => a2.AccumulatedValue);
								if ((a.AccumulatedValue + ytdfiscal) >
								    company.AccumulatedPayTypes.First(pt => pt.PayType.Id == a.PayType.PayType.Id).AnnualLimit)
									a.AccumulatedValue =
										company.AccumulatedPayTypes.First(pt => pt.PayType.Id == a.PayType.PayType.Id).AnnualLimit - ytdfiscal;
								
								a.YTDFiscal = Math.Round(a.AccumulatedValue + ytdAccumulation.Sum(a2 => a2.AccumulatedValue), 2,
									MidpointRounding.AwayFromZero);
								a.YTDUsed = Math.Round(a.Used + ytdAccumulation.Sum(a2 => a2.Used), 2,
									MidpointRounding.AwayFromZero);
								a.CarryOver = Math.Round(employee.CarryOver + prevs.Sum(a2 => a2.AccumulatedValue - a2.Used), 2, MidpointRounding.AwayFromZero);
								

								
							});
							payCheckList.Add(p);
						});

				});
				Console.WriteLine("PayChecks " + payCheckList.Count);
				Console.WriteLine("Employees " + empList.Count);
				using (var txn = TransactionScopeHelper.TransactionNoTimeout())
				{
					payCheckList.ForEach(_payrollRepository.UpdatePayCheckSickLeaveAccumulation);
					empList.ForEach(e =>
					{
						_companyRepository.SaveEmployeeSickLeaveAndCarryOver(e);
						Console.WriteLine("E {0}, {1}, {2}", e.CompanyEmployeeNo, e.FullName, e.Id);
					});
					txn.Complete();
				}
			}
		}

		private static void CompareTaxRates(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var _taxationService = scope.Resolve<ITaxationService>();
				var taxTables = _taxationService.GetTaxTables();
				var taxTablesContext = _taxationService.GetTaxTablesByContext();
				var differentTaxYearRates = taxTables.Taxes.Where(t => taxTablesContext.Taxes.All(t1 => !t.Equals(t1))).ToList();
				var differentFIT = taxTables.FITTaxTable.Where(t => taxTablesContext.FITTaxTable.All(t1 => !t.Equals(t1))).ToList();
				var differentSIT = taxTables.CASITTaxTable.Where(t => taxTablesContext.CASITTaxTable.All(t1 => !t.Equals(t1))).ToList();
				var differentSITLow = taxTables.CASITLowIncomeTaxTable.Where(t => taxTablesContext.CASITLowIncomeTaxTable.All(t1 => !t.Equals(t1))).ToList();
				var differentFITW = taxTables.FitWithholdingAllowanceTable.Where(t => taxTablesContext.FitWithholdingAllowanceTable.All(t1 => !t.Equals(t1))).ToList();
				var differentStdDed = taxTables.CAStandardDeductionTable.Where(t => taxTablesContext.CAStandardDeductionTable.All(t1 => !t.Equals(t1))).ToList();
				var differentEStdDed = taxTables.EstimatedDeductionTable.Where(t => taxTablesContext.EstimatedDeductionTable.All(t1 => !t.Equals(t1))).ToList();
				var differentExempAllow = taxTables.ExemptionAllowanceTable.Where(t => taxTablesContext.ExemptionAllowanceTable.All(t1 => !t.Equals(t1))).ToList();
				var differentDedPre = taxTables.TaxDeductionPrecendences.Where(t => taxTablesContext.TaxDeductionPrecendences.All(t1 => !t.Equals(t1))).ToList();

			}
		}

		private static void UpdateInvoiceDeliveryLists(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var _readerService = scope.Resolve<IReaderService>();
				var _payrollRepository = scope.Resolve<IPayrollRepository>();
				var mapper = scope.Resolve<IMapper>();
				using (var txn = TransactionScopeHelper.TransactionNoTimeout())
				{
					var claims = _payrollRepository.GetInvoiceDeliveryClaims(null, null);
					claims.ForEach(id =>
					{
						id.InvoiceSummaries = mapper.Map<List<PayrollInvoice>, List<InvoiceSummaryForDelivery>>(id.Invoices);
						id.Invoices = null;
					});
					_payrollRepository.UpdateInvoiceDeliveryData(claims);
					txn.Complete();
				}
			}
		}

		private static void FixPayCheckYTD(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var _readerService = scope.Resolve<IReaderService>();
				var _payrollRepository = scope.Resolve<IPayrollRepository>();
				var mementoService = scope.Resolve<IMementoDataService>();
				var original = _readerService.GetPaycheck(35693);
				var newone = _readerService.GetPaycheck(37041);
				using (var txn = TransactionScopeHelper.TransactionNoTimeout())
				{
					original.SubtractFromYTD(newone);
					original.Compensations.Remove(original.Compensations.First(c => c.PayType.Id == 4));
					_payrollRepository.SavePayCheck(original);
					var memento = Memento<PayCheck>.Create(original, EntityTypeEnum.PayCheck, "System", "YTD fixed", Guid.Empty);
					mementoService.AddMementoData(memento);
					txn.Complete();
				}
			}
		}

		private static void FixPayrollTaxesAccumulations(IContainer container)
		{
			FileStream ostrm;
			StreamWriter writer;
			TextWriter oldOut = Console.Out;
			try
			{
				ostrm = new FileStream(string.Format("PayCheckYTD-{0}.txt", DateTime.Today.ToString("MMddyyyy")), FileMode.OpenOrCreate, FileAccess.Write);
				writer = new StreamWriter(ostrm);
				Console.SetOut(writer);
			}
			catch (Exception e)
			{
				Console.WriteLine("Cannot open Redirect.txt for writing");
				Console.WriteLine(e.Message);
				return;
			}


			Console.WriteLine("Checks YTD Fix---Updating Checks");
			using (var scope = container.BeginLifetimeScope())
			{
				var _readerService = scope.Resolve<IReaderService>();
				var _payrollRepository = scope.Resolve<IPayrollRepository>();
				var _taxationService = scope.Resolve<ITaxationService>();
				var _hostService = scope.Resolve<IHostService>();
				var pList = new List<Guid>();
				#region "payroll List"
				pList.Add(new Guid("A039EFCF-5875-45F6-96AE-A74300963330"));
				pList.Add(new Guid("3C128D69-C663-4D3D-92F3-A743009692B6"));
				pList.Add(new Guid("F03E7CAD-918C-43E2-917F-A7430097066C"));
				pList.Add(new Guid("6FB5AA3A-627A-4B79-A2CA-A7430097C32A"));
				pList.Add(new Guid("BB4393C2-0903-4CC9-B97E-A74300987B05"));
				pList.Add(new Guid("6BF7B4E7-B4C6-40F3-BF9D-A7430098FF2C"));
				pList.Add(new Guid("1125A896-0279-4EFD-85E9-A7430099E6B3"));
				pList.Add(new Guid("1A75D224-A4D3-43A8-A39F-A743009B976A"));
				pList.Add(new Guid("F64928A4-442C-46AE-AEA0-A743009CD0F2"));
				pList.Add(new Guid("AD9ACB0E-4F54-4661-AA8B-A743009DCBC2"));
				pList.Add(new Guid("DC55632B-5FDB-4AB5-89E7-A743009F5C40"));
				pList.Add(new Guid("F61052AD-6071-43AE-BD28-A74300A03150"));
				pList.Add(new Guid("41CB40AB-0C5C-4F88-8B88-A74300A0DA89"));
				pList.Add(new Guid("BEA65EF5-42A3-4A09-BDF8-A74300A15C31"));
				pList.Add(new Guid("8E2A639A-1009-41FE-AB23-A74300A1AE93"));
				pList.Add(new Guid("DFA7A660-4912-4176-A15F-A74300A2003D"));
				pList.Add(new Guid("E59BF5D6-F4F6-4DC9-B12C-A74300A23A0F"));
				pList.Add(new Guid("A0B5078C-9DFB-43F5-8F0F-A74300A455B7"));
				pList.Add(new Guid("9DDB5E49-7687-4A58-936B-A74300A4B41F"));
				pList.Add(new Guid("50313523-4E68-46B4-9E85-A74300A5AC6F"));
				pList.Add(new Guid("7728B400-CA44-44DA-B01B-A74300A6FC99"));
				pList.Add(new Guid("25022B2B-7EB4-41CD-8D66-A74300A7060F"));
				pList.Add(new Guid("5C319D11-8A53-4574-BD62-A74300A780EF"));
				pList.Add(new Guid("0BDE0170-1B72-4C5C-B062-A74300A7FD48"));
				pList.Add(new Guid("70BA6E6A-3112-4FE1-A645-A74300A8CF80"));
				pList.Add(new Guid("232C3A10-375D-40FD-B810-A74300A8F8E2"));
				pList.Add(new Guid("9794BADF-38A3-427F-86A1-A74300A94112"));
				pList.Add(new Guid("3B5972C0-CF67-4521-9E78-A74300A94D57"));
				pList.Add(new Guid("97567975-693D-4C35-A540-A74300A9AEF2"));
				pList.Add(new Guid("45C9223C-D4E0-411A-8058-A74300A9DB1F"));
				pList.Add(new Guid("500F5733-9326-43F7-9030-A74300AA6113"));
				pList.Add(new Guid("3B0FD098-94BB-4F59-B5F0-A74300AC1377"));
				pList.Add(new Guid("5251E086-9D19-476B-8D06-A74300B2272B"));
				pList.Add(new Guid("9E4E603E-92DA-4CD8-B42A-A74300B2739E"));
				pList.Add(new Guid("6E101E91-AF3F-45FE-9337-A74300B2BB05"));
				pList.Add(new Guid("F54CC5B6-2075-4539-B459-A74300B2D880"));
				pList.Add(new Guid("BC43E682-E807-471F-AE7A-A74300B2FFCF"));
				pList.Add(new Guid("FA6CCB76-40C5-48F9-A223-A74300B90CEC"));
				pList.Add(new Guid("D1A01691-6FBA-42BB-B749-A74300BA1B69"));
				pList.Add(new Guid("4CCEF599-E9D5-4E5E-96D5-A74300BC4A1E"));
				pList.Add(new Guid("845E2425-D4B4-411B-8BEE-A74300BD72A7"));
				pList.Add(new Guid("4BA21345-9A72-4F7B-9B21-A74300BFF6D1"));
				pList.Add(new Guid("761F10FF-A805-4D7C-B61B-A74300C0ABB6"));
				pList.Add(new Guid("8B6101AE-07C2-44CB-B3BC-A74300C1B748"));
				pList.Add(new Guid("35D7F89B-AB43-44E5-83E3-A74300C2D36C"));
				pList.Add(new Guid("AB39553C-D43D-4107-BDE3-A74300C3F405"));
				pList.Add(new Guid("B448C84B-01B0-40B0-A98C-A74300C6F398"));
				pList.Add(new Guid("DFD5FD7B-B322-402E-BCC8-A74300C9277D"));
				pList.Add(new Guid("4AD02F3E-45AE-4C97-8D3A-A74300C9BB2C"));
				pList.Add(new Guid("96822BBC-5EB2-4A8B-A3F4-A74300CA34D3"));
				pList.Add(new Guid("9FF57B2D-3814-4625-8CA4-A74300CA5DB2"));
				pList.Add(new Guid("7BCC4ACE-592B-4182-9396-A74300CA602B"));
				pList.Add(new Guid("8AD4659F-48A0-4021-93C8-A74300CB04A8"));
				pList.Add(new Guid("1FA26D1F-3E5E-4EC6-A118-A74300CE4464"));
				pList.Add(new Guid("789682F1-DFB7-4291-828D-A74300D307AA"));
				pList.Add(new Guid("3E162C13-12F1-40BA-A383-A74300D39A35"));
				pList.Add(new Guid("15255325-502D-4CF4-ACC2-A74300DCB477"));
				pList.Add(new Guid("B1C7ECDB-DEA2-41C3-848F-A74300DED45A"));
				pList.Add(new Guid("263BE9ED-8F3D-41A2-8DF3-A74300EA2066"));
				pList.Add(new Guid("9111F4BB-6880-4A2E-B6D5-A74400808ED9"));
				pList.Add(new Guid("BB63C185-A2F0-4167-B7FC-A7440083713E"));
				pList.Add(new Guid("41A0523F-66CB-42C0-8075-A7440084BFE0"));
				pList.Add(new Guid("C40AC002-27DD-4997-B96F-A7440090C4C2"));
				pList.Add(new Guid("0CC57F0B-741B-4644-A804-A7440095CD02"));
				pList.Add(new Guid("AEDEEBA3-8033-45B2-8267-A74400962F96"));
				pList.Add(new Guid("5FA6B953-A2FE-4276-89BC-A74400968DC0"));
				pList.Add(new Guid("28C6E697-D373-4D26-8A26-A7440098CA9D"));
				pList.Add(new Guid("BBAE863C-7ACA-4D17-A302-A744009962C2"));
				pList.Add(new Guid("56A604F7-991E-418A-B16C-A7440099B79D"));
				pList.Add(new Guid("1B21A638-C49A-4EAD-A586-A744009BCFB2"));
				pList.Add(new Guid("7802447E-8BC5-4C95-B48D-A744009DE162"));
				pList.Add(new Guid("0A2057D0-9E8F-4162-9397-A744009E2A32"));
				pList.Add(new Guid("D20137CE-3F68-499E-B1BB-A74400A06C32"));
				pList.Add(new Guid("99BBEB07-9EBB-440E-8F5A-A74400A621EC"));
				pList.Add(new Guid("A0ABB316-706D-4924-AA5B-A74400A6FB17"));
				pList.Add(new Guid("958EB103-4C0D-4EAB-B2C7-A74400A718E1"));
				pList.Add(new Guid("EDECC557-A9E0-48D1-A651-A74400A77E4B"));
				pList.Add(new Guid("40DC3504-7C60-4F68-934F-A74400AB6C24"));
				pList.Add(new Guid("A043E048-69F8-47D5-B1EA-A74400AC3BF3"));
				pList.Add(new Guid("0CBC4C9B-E3B0-4B24-8B65-A74400AE47D9"));
				pList.Add(new Guid("59F3E07A-3089-4553-B593-A74400B09EAD"));
				pList.Add(new Guid("B0858F34-E8E4-415E-BF66-A74400B0A207"));
				pList.Add(new Guid("9F260057-B658-4BD9-82B2-A74400B0C7F2"));
				pList.Add(new Guid("35029A8E-D172-452F-B96D-A74400B18D08"));
				pList.Add(new Guid("90B5C30E-AF12-4966-98B5-A74400B1E754"));
				pList.Add(new Guid("C9DAFDE1-DA7E-4110-A0E2-A74400B32D9C"));
				pList.Add(new Guid("1B51A7D9-C103-4FF7-9F42-A74400B3E43A"));
				pList.Add(new Guid("A32DA50C-5CC1-492D-A628-A74400B66476"));
				pList.Add(new Guid("ACC42FD3-FF77-45D4-9D09-A74400B6D974"));
				pList.Add(new Guid("97FEAEBA-1D93-415C-8517-A74400BBF957"));
				pList.Add(new Guid("75DDEEA9-5EDE-4808-B093-A74400BC0108"));
				pList.Add(new Guid("BAC93491-29EC-4A09-88F4-A74400BD0B32"));
				pList.Add(new Guid("62978AD3-5EDD-45B0-AC76-A74400C065AF"));
				pList.Add(new Guid("555513BF-5BCB-4EE1-B2EA-A74400C0FAC5"));
				pList.Add(new Guid("A4A2BDB7-E0FA-43EE-9100-A74400C3747D"));
				pList.Add(new Guid("2B572847-9390-4981-9F0D-A74400C40FD6"));
				pList.Add(new Guid("47BFFF3F-CA95-4673-9DA5-A74400C64B7B"));
				pList.Add(new Guid("6D41282F-AC38-4B0E-BECA-A74400C8B2C3"));
				pList.Add(new Guid("344212D2-8EDF-4BF9-8D13-A74400C92632"));
				pList.Add(new Guid("7EB0943F-F816-4B7D-8AD3-A74400C97C48"));
				pList.Add(new Guid("520AAB59-3B6C-4393-BCB6-A74400CA0120"));
				pList.Add(new Guid("F026D76B-4D03-46B8-A376-A74400CEBD11"));
				pList.Add(new Guid("79FA1706-0593-4E32-89CB-A74400CF2DA7"));
				pList.Add(new Guid("DF956719-85E9-449A-B055-A74400E21999"));
				pList.Add(new Guid("5B5C96F0-A1C8-497E-9273-A74400F090A5"));
				pList.Add(new Guid("5F1F8B64-15E1-4E66-9B0D-A74400F3DFC6"));
				pList.Add(new Guid("D0EE262B-ADD6-4E93-B638-A745007C6606"));
				pList.Add(new Guid("7C33869C-1B8A-4D71-B9E9-A74500878B96"));
				pList.Add(new Guid("B71E7346-3984-46A6-A4B5-A74500973F3C"));
				pList.Add(new Guid("F14A96EE-3826-49F1-B7DC-A74500997027"));
				pList.Add(new Guid("82E20536-A510-49E2-B1A1-A745009A7CC3"));
				pList.Add(new Guid("7B089CC6-D9EC-4C44-9B2A-A745009AC443"));
				pList.Add(new Guid("6AF731F7-E185-4715-B532-A745009F09EA"));
				pList.Add(new Guid("CFCFD2B0-8B4A-41CA-BFCF-A74500A5018D"));
				pList.Add(new Guid("2ABB66E1-725B-470D-9B81-A74500A570C8"));
				pList.Add(new Guid("E14D6657-5D83-484C-8568-A74500A5B82A"));
				pList.Add(new Guid("93C556F8-77DE-4385-8735-A74500A5FD0A"));
				pList.Add(new Guid("02C9CA0C-FA17-4E8A-9A7A-A74500A63C75"));
				pList.Add(new Guid("9BBF94AB-2E6C-49EE-9F2F-A74500A67262"));
				pList.Add(new Guid("BD481333-B93E-4CBA-A504-A74500A6BB10"));
				pList.Add(new Guid("7F4E7625-67EF-42E8-9D15-A74500A833A6"));
				pList.Add(new Guid("9BF76D88-3D38-45E4-BE6C-A74500A8B1C5"));
				pList.Add(new Guid("37239108-372B-407D-9348-A74500AA1665"));
				pList.Add(new Guid("B71C8AE7-32F0-4CDC-9235-A74500AA69A7"));
				pList.Add(new Guid("2E44B58A-1DEE-4590-B3C4-A74500AABCBA"));
				pList.Add(new Guid("D8B52654-AA63-4431-AB70-A74500ABBB8D"));
				pList.Add(new Guid("C39590AA-0C36-464F-B636-A74500ACD08C"));
				pList.Add(new Guid("68F7F9A3-4ED2-4526-8A71-A74500AD3AF7"));
				pList.Add(new Guid("9E6C3056-14F8-4F9D-A390-A74500AEBA5E"));
				pList.Add(new Guid("841A82C8-3450-41C9-90F3-A74500B3D1C9"));
				pList.Add(new Guid("313EC1B2-0609-4996-8354-A74500B40B2B"));
				pList.Add(new Guid("8C29DE84-2107-4B01-99A7-A74500B44A06"));
				pList.Add(new Guid("B6A11C33-C219-4085-9203-A74500B4AA9B"));
				pList.Add(new Guid("D2172C78-3624-42A5-90C7-A74500B4C829"));
				pList.Add(new Guid("C55B0FED-41F0-431C-BD04-A74500B4DDB8"));
				pList.Add(new Guid("BD1C2393-EE94-429A-90DE-A74500B6723B"));
				pList.Add(new Guid("D742F56E-1D11-4C9E-A537-A74500B6B056"));
				pList.Add(new Guid("239627F1-3C55-4292-90FC-A74500B727D8"));
				pList.Add(new Guid("3E5CABED-B086-4773-930F-A74500B7711F"));
				pList.Add(new Guid("15CB3104-42B5-4DCA-AF9A-A74500B7BD4E"));
				pList.Add(new Guid("195CE898-F040-48A3-BCFC-A74500B7D9BB"));
				pList.Add(new Guid("69358CB9-B966-4D8C-9B6D-A74500B8C8B0"));
				pList.Add(new Guid("660F3B3E-A7EB-4411-91D9-A74500B94130"));
				pList.Add(new Guid("E05344FF-54CE-4688-A1F4-A74500B9D526"));
				pList.Add(new Guid("315AC2D6-F98A-40C2-87DA-A74500BA6E7A"));
				pList.Add(new Guid("FF7CBE53-C496-462B-961C-A74500BBA923"));
				pList.Add(new Guid("E4886C8D-D552-476F-8223-A74500BBFB91"));
				pList.Add(new Guid("C7B5C285-C2F3-49A5-A2DC-A74500BC4C26"));
				pList.Add(new Guid("4F75B16E-CC33-4578-8E45-A74500BC5E26"));
				pList.Add(new Guid("0202D0A7-A294-4535-8697-A74500BCB6A5"));
				pList.Add(new Guid("DA3FFDBE-624B-45D5-845D-A74500BCC239"));
				pList.Add(new Guid("70D52EE9-535C-41C0-B515-A74500BD02FF"));
				pList.Add(new Guid("60CBA501-20D7-486C-A71D-A74500BD0CD0"));
				pList.Add(new Guid("90F117C3-5EBD-42F9-952B-A74500BE09B0"));
				pList.Add(new Guid("812F8476-EB95-400A-83B3-A74500BF3751"));
				pList.Add(new Guid("BA273FA6-2817-44D3-8443-A74500BF52AF"));
				pList.Add(new Guid("788397B1-A650-4739-842F-A74500C1A392"));
				pList.Add(new Guid("079B10FE-661D-4469-8EA9-A74500C3FA3F"));
				pList.Add(new Guid("9F098E03-A9C4-4F1A-8A2D-A74500C480C9"));
				pList.Add(new Guid("6204047F-CF6C-4B4B-8975-A74500C6287B"));
				pList.Add(new Guid("DC03167D-06EA-4554-AE1F-A74500C9A892"));
				pList.Add(new Guid("4496F2F3-F016-47F6-B6CC-A74500D48FC3"));
				pList.Add(new Guid("5F627330-4832-4652-A513-A74500EEDE51"));
				pList.Add(new Guid("E8CA67E8-6DAD-4755-8171-A74500FDE14A"));
				pList.Add(new Guid("A10B3D7B-EF3E-44A1-AC43-A7450121127F"));
				pList.Add(new Guid("25BD329A-8C02-499C-BF73-A7450126E49D"));
				#endregion

				

				var checksWithFUTAWageIssue = 0;
				var checksProcessed = 0;
				var ytdIssue = 0;
				var payrollsWithIssue = 0;
				var accumissue = 0;
				
				var ytdIssueChecks = new List<int>();
				var taxupdate = new List<PayCheck>();
				var accupdate = new List<PayCheck>();
				Console.WriteLine("CompanyId,company,payrollId,PayCheckId,Employee,ytd futa, futa wage,should be,ytd ett, ett wage,should be, ytd sui, sui wage,should be");
				using (var txn = TransactionScopeHelper.TransactionNoTimeout())
				{
					pList.ForEach(p1 =>
					{
						var payroll = _readerService.GetPayroll(p1);
						var employeeAccumulations = _readerService.GetAccumulations(company: payroll.Company.Id,
						startdate: new DateTime(payroll.PayDay.Year, 1, 1), enddate: payroll.PayDay);
						var thispayrollchecks = 0;
						payroll.PayChecks.Where(pc=>!pc.IsVoid).ToList().ForEach(pc =>
						{
							var ea = employeeAccumulations.First(e => e.EmployeeId.Value == pc.Employee.Id);
							ea.Taxes.ForEach(t =>
							{
								var t2 = pc.Taxes.First(t3 => t3.Tax.Code.Equals(t.Tax.Code));
								t.YTD -= t2.Amount;
								t.YTDWage -=t2.TaxableWage;
							});
							var host = _hostService.GetHost(payroll.Company.HostId);
							var taxes = _taxationService.ProcessTaxes(payroll.Company, pc, pc.PayDay, pc.GrossWage, host.Company, ea);
							var futatax = taxes.First(t => t.Tax.Code.Equals("FUTA"));
							var etttax = taxes.First(t => t.Tax.Code.Equals("ETT"));
							var suitax = taxes.First(t => t.Tax.Code.Equals("SUI"));
							var ytdfuta = futatax.YTDWage;
							var sbfutawage = futatax.TaxableWage;
							var futawage = pc.Taxes.First(t => t.Tax.Code.Equals("FUTA")).TaxableWage;
							var ytdett = etttax.YTDWage;
							var sbettwage = etttax.TaxableWage;
							var ettwage = pc.Taxes.First(t => t.Tax.Code.Equals("ETT")).TaxableWage;
							var ytdsui = suitax.YTDWage;
							var sbsuiwage = suitax.TaxableWage;
							var uiwage = pc.Taxes.First(t => t.Tax.Code.Equals("SUI")).TaxableWage;

							var updateTaxes = false;
							var updateAccumulation = false;


							if (sbfutawage != futawage || ettwage != sbettwage || sbsuiwage != uiwage)
							{
								updateTaxes = true;
								pc.Taxes.First(t => t.Tax.Code.Equals("SUI")).TaxableWage = suitax.TaxableWage;
								pc.Taxes.First(t => t.Tax.Code.Equals("SUI")).Amount = suitax.Amount;
								pc.Taxes.First(t => t.Tax.Code.Equals("ETT")).TaxableWage = etttax.TaxableWage;
								pc.Taxes.First(t => t.Tax.Code.Equals("ETT")).Amount = etttax.Amount;
								pc.Taxes.First(t => t.Tax.Code.Equals("FUTA")).TaxableWage = futatax.TaxableWage;
								pc.Taxes.First(t => t.Tax.Code.Equals("FUTA")).Amount = futatax.Amount;
								Console.WriteLine("{0},{1},{2},{3},{4}", payroll.Company.Id, payroll.Company.Name.Replace(",", string.Empty), payroll.Id, pc.Id, pc.Employee.FullName);
								taxupdate.Add(pc);
								checksWithFUTAWageIssue++;
								thispayrollchecks++;
							}
							
							if (pc.Accumulations.Any())
							{
								ea.Accumulations.ForEach(ea1 =>
								{
									var eaa = pc.Accumulations.First(pca => pca.PayType.PayType.Id == ea1.PayTypeId);
									ea1.YTDFiscal -= eaa.AccumulatedValue;
									ea1.YTDUsed -= eaa.Used;
								});
								var accums = ProcessAccumulations(pc, payroll.Company.AccumulatedPayTypes, ea);
								accums.ForEach(ac =>
								{
									var pcaccum = pc.Accumulations.First(a1 => a1.PayType.Id == ac.PayType.Id);
									if (ac.AccumulatedValue != pcaccum.AccumulatedValue || ac.Used != pcaccum.Used)
									{
										updateAccumulation = true;
										pcaccum.AccumulatedValue = ac.AccumulatedValue;
										pcaccum.Used = ac.Used;
										pcaccum.CarryOver = (decimal) ac.CarryOver;
										Console.WriteLine("{0},{1},{2},{3},{4},{5},{6}, {7},{8}", payroll.Company.Id, payroll.Company.Name.Replace(",", string.Empty), payroll.Id, pc.Id, pc.Employee.FullName, pcaccum.AccumulatedValue, ac.AccumulatedValue, pcaccum.Used, ac.Used);
										accumissue++;
									}
										
								});
								if(updateAccumulation)
									accupdate.Add(pc);
							}
							

							checksProcessed++;
						});
						if (thispayrollchecks > 0) payrollsWithIssue++;
					});

					
					Console.WriteLine("Checks with futa wage issues: " + checksWithFUTAWageIssue);
					Console.WriteLine("Checks with ytd issues: " + ytdIssueChecks);
					Console.WriteLine("Employees Processed: " + checksProcessed);
					Console.WriteLine("Total Payrolls: " + pList.Count);
					Console.WriteLine("Payrolls with  issue: " + payrollsWithIssue);
					Console.WriteLine("Accumulation  issue: " + accumissue);
					writer.AutoFlush = true;
					Console.SetOut(oldOut);
					writer.Close();
					ostrm.Close();
					if (taxupdate.Any() || accupdate.Any())
					{
						if (taxupdate.Any())
							_payrollRepository.FixPayCheckTaxes(taxupdate);
						if (accupdate.Any())
							_payrollRepository.FixPayCheckAccumulations(accupdate);
						Console.Write("Commit? ");
						var commit = Convert.ToInt32(Console.ReadLine());
						if (commit == 1)
						{
							
							txn.Complete();
						}
					}

					


				}

			}
		}

		private static void FixPayrollYTD(IContainer container)
		{
			FileStream ostrm;
			StreamWriter writer;
			TextWriter oldOut = Console.Out;
			try
			{
				ostrm = new FileStream(string.Format("PayCheckYTDs-{0}.txt", DateTime.Today.ToString("MMddyyyy")), FileMode.OpenOrCreate, FileAccess.Write);
				writer = new StreamWriter(ostrm);
				Console.SetOut(writer);
			}
			catch (Exception e)
			{
				Console.WriteLine("Cannot open Redirect.txt for writing");
				Console.WriteLine(e.Message);
				return;
			}


			Console.WriteLine("Checks YTD Fix---Updating Checks");
			using (var scope = container.BeginLifetimeScope())
			{
				var _readerService = scope.Resolve<IReaderService>();
				var _payrollRepository = scope.Resolve<IPayrollRepository>();
				var mementoService = scope.Resolve<IMementoDataService>();
				var pList = new List<Guid>();
				#region "payroll List"
				pList.Add(new Guid("A039EFCF-5875-45F6-96AE-A74300963330"));
				pList.Add(new Guid("3C128D69-C663-4D3D-92F3-A743009692B6"));
				pList.Add(new Guid("F03E7CAD-918C-43E2-917F-A7430097066C"));
				pList.Add(new Guid("6FB5AA3A-627A-4B79-A2CA-A7430097C32A"));
				pList.Add(new Guid("BB4393C2-0903-4CC9-B97E-A74300987B05"));
				pList.Add(new Guid("6BF7B4E7-B4C6-40F3-BF9D-A7430098FF2C"));
				pList.Add(new Guid("1125A896-0279-4EFD-85E9-A7430099E6B3"));
				pList.Add(new Guid("1A75D224-A4D3-43A8-A39F-A743009B976A"));
				pList.Add(new Guid("F64928A4-442C-46AE-AEA0-A743009CD0F2"));
				pList.Add(new Guid("AD9ACB0E-4F54-4661-AA8B-A743009DCBC2"));
				pList.Add(new Guid("DC55632B-5FDB-4AB5-89E7-A743009F5C40"));
				pList.Add(new Guid("F61052AD-6071-43AE-BD28-A74300A03150"));
				pList.Add(new Guid("41CB40AB-0C5C-4F88-8B88-A74300A0DA89"));
				pList.Add(new Guid("BEA65EF5-42A3-4A09-BDF8-A74300A15C31"));
				pList.Add(new Guid("8E2A639A-1009-41FE-AB23-A74300A1AE93"));
				pList.Add(new Guid("DFA7A660-4912-4176-A15F-A74300A2003D"));
				pList.Add(new Guid("E59BF5D6-F4F6-4DC9-B12C-A74300A23A0F"));
				pList.Add(new Guid("A0B5078C-9DFB-43F5-8F0F-A74300A455B7"));
				pList.Add(new Guid("9DDB5E49-7687-4A58-936B-A74300A4B41F"));
				pList.Add(new Guid("50313523-4E68-46B4-9E85-A74300A5AC6F"));
				pList.Add(new Guid("7728B400-CA44-44DA-B01B-A74300A6FC99"));
				pList.Add(new Guid("25022B2B-7EB4-41CD-8D66-A74300A7060F"));
				pList.Add(new Guid("5C319D11-8A53-4574-BD62-A74300A780EF"));
				pList.Add(new Guid("0BDE0170-1B72-4C5C-B062-A74300A7FD48"));
				pList.Add(new Guid("70BA6E6A-3112-4FE1-A645-A74300A8CF80"));
				pList.Add(new Guid("232C3A10-375D-40FD-B810-A74300A8F8E2"));
				pList.Add(new Guid("9794BADF-38A3-427F-86A1-A74300A94112"));
				pList.Add(new Guid("3B5972C0-CF67-4521-9E78-A74300A94D57"));
				pList.Add(new Guid("97567975-693D-4C35-A540-A74300A9AEF2"));
				pList.Add(new Guid("45C9223C-D4E0-411A-8058-A74300A9DB1F"));
				pList.Add(new Guid("500F5733-9326-43F7-9030-A74300AA6113"));
				pList.Add(new Guid("3B0FD098-94BB-4F59-B5F0-A74300AC1377"));
				pList.Add(new Guid("5251E086-9D19-476B-8D06-A74300B2272B"));
				pList.Add(new Guid("9E4E603E-92DA-4CD8-B42A-A74300B2739E"));
				pList.Add(new Guid("6E101E91-AF3F-45FE-9337-A74300B2BB05"));
				pList.Add(new Guid("F54CC5B6-2075-4539-B459-A74300B2D880"));
				pList.Add(new Guid("BC43E682-E807-471F-AE7A-A74300B2FFCF"));
				pList.Add(new Guid("FA6CCB76-40C5-48F9-A223-A74300B90CEC"));
				pList.Add(new Guid("D1A01691-6FBA-42BB-B749-A74300BA1B69"));
				pList.Add(new Guid("4CCEF599-E9D5-4E5E-96D5-A74300BC4A1E"));
				pList.Add(new Guid("845E2425-D4B4-411B-8BEE-A74300BD72A7"));
				pList.Add(new Guid("4BA21345-9A72-4F7B-9B21-A74300BFF6D1"));
				pList.Add(new Guid("761F10FF-A805-4D7C-B61B-A74300C0ABB6"));
				pList.Add(new Guid("8B6101AE-07C2-44CB-B3BC-A74300C1B748"));
				pList.Add(new Guid("35D7F89B-AB43-44E5-83E3-A74300C2D36C"));
				pList.Add(new Guid("AB39553C-D43D-4107-BDE3-A74300C3F405"));
				pList.Add(new Guid("B448C84B-01B0-40B0-A98C-A74300C6F398"));
				pList.Add(new Guid("DFD5FD7B-B322-402E-BCC8-A74300C9277D"));
				pList.Add(new Guid("4AD02F3E-45AE-4C97-8D3A-A74300C9BB2C"));
				pList.Add(new Guid("96822BBC-5EB2-4A8B-A3F4-A74300CA34D3"));
				pList.Add(new Guid("9FF57B2D-3814-4625-8CA4-A74300CA5DB2"));
				pList.Add(new Guid("7BCC4ACE-592B-4182-9396-A74300CA602B"));
				pList.Add(new Guid("8AD4659F-48A0-4021-93C8-A74300CB04A8"));
				pList.Add(new Guid("1FA26D1F-3E5E-4EC6-A118-A74300CE4464"));
				pList.Add(new Guid("789682F1-DFB7-4291-828D-A74300D307AA"));
				pList.Add(new Guid("3E162C13-12F1-40BA-A383-A74300D39A35"));
				pList.Add(new Guid("15255325-502D-4CF4-ACC2-A74300DCB477"));
				pList.Add(new Guid("B1C7ECDB-DEA2-41C3-848F-A74300DED45A"));
				pList.Add(new Guid("263BE9ED-8F3D-41A2-8DF3-A74300EA2066"));
				pList.Add(new Guid("9111F4BB-6880-4A2E-B6D5-A74400808ED9"));
				pList.Add(new Guid("BB63C185-A2F0-4167-B7FC-A7440083713E"));
				pList.Add(new Guid("41A0523F-66CB-42C0-8075-A7440084BFE0"));
				pList.Add(new Guid("C40AC002-27DD-4997-B96F-A7440090C4C2"));
				pList.Add(new Guid("0CC57F0B-741B-4644-A804-A7440095CD02"));
				pList.Add(new Guid("AEDEEBA3-8033-45B2-8267-A74400962F96"));
				pList.Add(new Guid("5FA6B953-A2FE-4276-89BC-A74400968DC0"));
				pList.Add(new Guid("28C6E697-D373-4D26-8A26-A7440098CA9D"));
				pList.Add(new Guid("BBAE863C-7ACA-4D17-A302-A744009962C2"));
				pList.Add(new Guid("56A604F7-991E-418A-B16C-A7440099B79D"));
				pList.Add(new Guid("1B21A638-C49A-4EAD-A586-A744009BCFB2"));
				pList.Add(new Guid("7802447E-8BC5-4C95-B48D-A744009DE162"));
				pList.Add(new Guid("0A2057D0-9E8F-4162-9397-A744009E2A32"));
				pList.Add(new Guid("D20137CE-3F68-499E-B1BB-A74400A06C32"));
				pList.Add(new Guid("99BBEB07-9EBB-440E-8F5A-A74400A621EC"));
				pList.Add(new Guid("A0ABB316-706D-4924-AA5B-A74400A6FB17"));
				pList.Add(new Guid("958EB103-4C0D-4EAB-B2C7-A74400A718E1"));
				pList.Add(new Guid("EDECC557-A9E0-48D1-A651-A74400A77E4B"));
				pList.Add(new Guid("40DC3504-7C60-4F68-934F-A74400AB6C24"));
				pList.Add(new Guid("A043E048-69F8-47D5-B1EA-A74400AC3BF3"));
				pList.Add(new Guid("0CBC4C9B-E3B0-4B24-8B65-A74400AE47D9"));
				pList.Add(new Guid("59F3E07A-3089-4553-B593-A74400B09EAD"));
				pList.Add(new Guid("B0858F34-E8E4-415E-BF66-A74400B0A207"));
				pList.Add(new Guid("9F260057-B658-4BD9-82B2-A74400B0C7F2"));
				pList.Add(new Guid("35029A8E-D172-452F-B96D-A74400B18D08"));
				pList.Add(new Guid("90B5C30E-AF12-4966-98B5-A74400B1E754"));
				pList.Add(new Guid("C9DAFDE1-DA7E-4110-A0E2-A74400B32D9C"));
				pList.Add(new Guid("1B51A7D9-C103-4FF7-9F42-A74400B3E43A"));
				pList.Add(new Guid("A32DA50C-5CC1-492D-A628-A74400B66476"));
				pList.Add(new Guid("ACC42FD3-FF77-45D4-9D09-A74400B6D974"));
				pList.Add(new Guid("97FEAEBA-1D93-415C-8517-A74400BBF957"));
				pList.Add(new Guid("75DDEEA9-5EDE-4808-B093-A74400BC0108"));
				pList.Add(new Guid("BAC93491-29EC-4A09-88F4-A74400BD0B32"));
				pList.Add(new Guid("62978AD3-5EDD-45B0-AC76-A74400C065AF"));
				pList.Add(new Guid("555513BF-5BCB-4EE1-B2EA-A74400C0FAC5"));
				pList.Add(new Guid("A4A2BDB7-E0FA-43EE-9100-A74400C3747D"));
				pList.Add(new Guid("2B572847-9390-4981-9F0D-A74400C40FD6"));
				pList.Add(new Guid("47BFFF3F-CA95-4673-9DA5-A74400C64B7B"));
				pList.Add(new Guid("6D41282F-AC38-4B0E-BECA-A74400C8B2C3"));
				pList.Add(new Guid("344212D2-8EDF-4BF9-8D13-A74400C92632"));
				pList.Add(new Guid("7EB0943F-F816-4B7D-8AD3-A74400C97C48"));
				pList.Add(new Guid("520AAB59-3B6C-4393-BCB6-A74400CA0120"));
				pList.Add(new Guid("F026D76B-4D03-46B8-A376-A74400CEBD11"));
				pList.Add(new Guid("79FA1706-0593-4E32-89CB-A74400CF2DA7"));
				pList.Add(new Guid("DF956719-85E9-449A-B055-A74400E21999"));
				pList.Add(new Guid("5B5C96F0-A1C8-497E-9273-A74400F090A5"));
				pList.Add(new Guid("5F1F8B64-15E1-4E66-9B0D-A74400F3DFC6"));
				pList.Add(new Guid("D0EE262B-ADD6-4E93-B638-A745007C6606"));
				pList.Add(new Guid("7C33869C-1B8A-4D71-B9E9-A74500878B96"));
				pList.Add(new Guid("B71E7346-3984-46A6-A4B5-A74500973F3C"));
				pList.Add(new Guid("F14A96EE-3826-49F1-B7DC-A74500997027"));
				pList.Add(new Guid("82E20536-A510-49E2-B1A1-A745009A7CC3"));
				pList.Add(new Guid("7B089CC6-D9EC-4C44-9B2A-A745009AC443"));
				pList.Add(new Guid("6AF731F7-E185-4715-B532-A745009F09EA"));
				pList.Add(new Guid("CFCFD2B0-8B4A-41CA-BFCF-A74500A5018D"));
				pList.Add(new Guid("2ABB66E1-725B-470D-9B81-A74500A570C8"));
				pList.Add(new Guid("E14D6657-5D83-484C-8568-A74500A5B82A"));
				pList.Add(new Guid("93C556F8-77DE-4385-8735-A74500A5FD0A"));
				pList.Add(new Guid("02C9CA0C-FA17-4E8A-9A7A-A74500A63C75"));
				pList.Add(new Guid("9BBF94AB-2E6C-49EE-9F2F-A74500A67262"));
				pList.Add(new Guid("BD481333-B93E-4CBA-A504-A74500A6BB10"));
				pList.Add(new Guid("7F4E7625-67EF-42E8-9D15-A74500A833A6"));
				pList.Add(new Guid("9BF76D88-3D38-45E4-BE6C-A74500A8B1C5"));
				pList.Add(new Guid("37239108-372B-407D-9348-A74500AA1665"));
				pList.Add(new Guid("B71C8AE7-32F0-4CDC-9235-A74500AA69A7"));
				pList.Add(new Guid("2E44B58A-1DEE-4590-B3C4-A74500AABCBA"));
				pList.Add(new Guid("D8B52654-AA63-4431-AB70-A74500ABBB8D"));
				pList.Add(new Guid("C39590AA-0C36-464F-B636-A74500ACD08C"));
				pList.Add(new Guid("68F7F9A3-4ED2-4526-8A71-A74500AD3AF7"));
				pList.Add(new Guid("9E6C3056-14F8-4F9D-A390-A74500AEBA5E"));
				pList.Add(new Guid("841A82C8-3450-41C9-90F3-A74500B3D1C9"));
				pList.Add(new Guid("313EC1B2-0609-4996-8354-A74500B40B2B"));
				pList.Add(new Guid("8C29DE84-2107-4B01-99A7-A74500B44A06"));
				pList.Add(new Guid("B6A11C33-C219-4085-9203-A74500B4AA9B"));
				pList.Add(new Guid("D2172C78-3624-42A5-90C7-A74500B4C829"));
				pList.Add(new Guid("C55B0FED-41F0-431C-BD04-A74500B4DDB8"));
				pList.Add(new Guid("BD1C2393-EE94-429A-90DE-A74500B6723B"));
				pList.Add(new Guid("D742F56E-1D11-4C9E-A537-A74500B6B056"));
				pList.Add(new Guid("239627F1-3C55-4292-90FC-A74500B727D8"));
				pList.Add(new Guid("3E5CABED-B086-4773-930F-A74500B7711F"));
				pList.Add(new Guid("15CB3104-42B5-4DCA-AF9A-A74500B7BD4E"));
				pList.Add(new Guid("195CE898-F040-48A3-BCFC-A74500B7D9BB"));
				pList.Add(new Guid("69358CB9-B966-4D8C-9B6D-A74500B8C8B0"));
				pList.Add(new Guid("660F3B3E-A7EB-4411-91D9-A74500B94130"));
				pList.Add(new Guid("E05344FF-54CE-4688-A1F4-A74500B9D526"));
				pList.Add(new Guid("315AC2D6-F98A-40C2-87DA-A74500BA6E7A"));
				pList.Add(new Guid("FF7CBE53-C496-462B-961C-A74500BBA923"));
				pList.Add(new Guid("E4886C8D-D552-476F-8223-A74500BBFB91"));
				pList.Add(new Guid("C7B5C285-C2F3-49A5-A2DC-A74500BC4C26"));
				pList.Add(new Guid("4F75B16E-CC33-4578-8E45-A74500BC5E26"));
				pList.Add(new Guid("0202D0A7-A294-4535-8697-A74500BCB6A5"));
				pList.Add(new Guid("DA3FFDBE-624B-45D5-845D-A74500BCC239"));
				pList.Add(new Guid("70D52EE9-535C-41C0-B515-A74500BD02FF"));
				pList.Add(new Guid("60CBA501-20D7-486C-A71D-A74500BD0CD0"));
				pList.Add(new Guid("90F117C3-5EBD-42F9-952B-A74500BE09B0"));
				pList.Add(new Guid("812F8476-EB95-400A-83B3-A74500BF3751"));
				pList.Add(new Guid("BA273FA6-2817-44D3-8443-A74500BF52AF"));
				pList.Add(new Guid("788397B1-A650-4739-842F-A74500C1A392"));
				pList.Add(new Guid("079B10FE-661D-4469-8EA9-A74500C3FA3F"));
				pList.Add(new Guid("9F098E03-A9C4-4F1A-8A2D-A74500C480C9"));
				pList.Add(new Guid("6204047F-CF6C-4B4B-8975-A74500C6287B"));
				pList.Add(new Guid("DC03167D-06EA-4554-AE1F-A74500C9A892"));
				pList.Add(new Guid("4496F2F3-F016-47F6-B6CC-A74500D48FC3"));
				pList.Add(new Guid("5F627330-4832-4652-A513-A74500EEDE51"));
				pList.Add(new Guid("E8CA67E8-6DAD-4755-8171-A74500FDE14A"));
				pList.Add(new Guid("A10B3D7B-EF3E-44A1-AC43-A7450121127F"));
				pList.Add(new Guid("25BD329A-8C02-499C-BF73-A7450126E49D"));
				#endregion



				
				var checksProcessed = 0;
				

				var updateList = new List<PayCheck>();
				var originalList = new List<PayCheck>();
				using (var txn = TransactionScopeHelper.TransactionNoTimeout())
				{
					pList.ForEach(p1 =>
					{
						var payroll = _readerService.GetPayroll(p1);
						var employeeAccumulations = _readerService.GetAccumulations(company: payroll.Company.Id,
						startdate: new DateTime(payroll.PayDay.Year, 1, 1), enddate: payroll.PayDay);
						var thispayrollchecks = 0;
						payroll.PayChecks.Where(pc => !pc.IsVoid).ToList().ForEach(pc =>
						{
							originalList.Add(JsonConvert.DeserializeObject<PayCheck>(JsonConvert.SerializeObject(pc)));
							var ea = employeeAccumulations.First(e => e.EmployeeId.Value == pc.Employee.Id);
							pc.Taxes.ForEach(t =>
							{
								var t2 = ea.Taxes.First(t3 => t3.Tax.Code.Equals(t.Tax.Code));
								t.YTDTax = t2.YTD;
								t.YTDWage = t2.YTDWage;
							});
							pc.Deductions.ForEach(d =>
							{
								var d2 = ea.Deductions.First(d3 => d3.CompanyDeductionId == d.Deduction.Id);
								d.YTD = d2.YTD;
								d.YTDWage = d2.YTDWage;
							});
							pc.Compensations.ForEach(c =>
							{
								var c2 = ea.Compensations.First(c3 => c3.PayTypeId == c.PayType.Id);
								c.YTD = c2.YTD;
							});
							pc.Accumulations.ForEach(a =>
							{
								var a2 = ea.Accumulations.First(a3 => a3.PayTypeId == a.PayType.PayType.Id);
								a.YTDFiscal = a2.YTDFiscal;
								a.YTDUsed = a2.YTDUsed;
							});
							pc.PayCodes.ForEach(p =>
							{
								var p2 = ea.PayCodes.First(p3 => p3.PayCodeId == p.PayCode.Id);
								p.YTD = p2.YTDAmount;
								p.YTDOvertime = p2.YTDOvertime;
							});
							if(pc.WorkerCompensation!=null)
								pc.WorkerCompensation.YTD =
									ea.WorkerCompensations.Where(w2 => w2.WorkerCompensationId == pc.WorkerCompensation.WorkerCompensation.Id)
										.Sum(w2 => w2.YTD);

							pc.YTDGrossWage = ea.PayCheckWages.GrossWage;
							pc.YTDNetWage = ea.PayCheckWages.NetWage;
							pc.YTDSalary = ea.PayCheckWages.Salary;
							
							updateList.Add(pc);

							checksProcessed++;
						});
						
					});


					
					Console.WriteLine("Employees Processed: " + checksProcessed);
					Console.WriteLine("Total Payrolls: " + pList.Count);
					
					writer.AutoFlush = true;
					Console.SetOut(oldOut);
					writer.Close();
					ostrm.Close();
					if (updateList.Any())
					{
						updateList.ForEach(pc=>{
							var memento1 = Memento<PayCheck>.Create(originalList.First(pc1=>pc1.Id==pc.Id), EntityTypeEnum.PayCheck, "System", "Pay Check Before Fix", Guid.Empty);
							mementoService.AddMementoData(memento1);
							_payrollRepository.UpdatePayCheckYTD(pc);
							var memento = Memento<PayCheck>.Create(pc, EntityTypeEnum.PayCheck, "System", "Pay Check Fixed", Guid.Empty);
							mementoService.AddMementoData(memento);
							
						});
						Console.Write("Commit? ");
						var commit = Convert.ToInt32(Console.ReadLine());
						if (commit == 1)
						{

							txn.Complete();
						}
					}




				}

			}
		}

		private static List<PayTypeAccumulation> ProcessAccumulations(PayCheck paycheck, IEnumerable<AccumulatedPayType> accumulatedPayTypes, Accumulation employeeAccumulation)
		{
			var result = new List<PayTypeAccumulation>();
			var fiscalStartDate = CalculateFiscalStartDate(paycheck.Employee.SickLeaveHireDate, paycheck.PayDay);
			var fiscalEndDate = fiscalStartDate.AddYears(1).AddDays(-1);



			foreach (var payType in accumulatedPayTypes)
			{
				if (!payType.CompanyManaged)
				{
					var ytdAccumulation = (decimal)0;
					var ytdUsed = (decimal)0;

					var carryover = (decimal) (decimal)0;

					if (employeeAccumulation.Accumulations != null && employeeAccumulation.Accumulations.Any(ac => ac.PayTypeId == payType.PayType.Id))
					{
						var accum = employeeAccumulation.Accumulations.First(ac => ac.PayTypeId == payType.PayType.Id);
						ytdAccumulation = accum.YTDFiscal;
						ytdUsed = accum.YTDUsed;
						carryover = (decimal) accum.CarryOver;

					}
					else if (employeeAccumulation.PreviousAccumulations != null && employeeAccumulation.PreviousAccumulations.Any(ac => ac.PayTypeId == payType.PayType.Id))
					{
						carryover = (decimal) employeeAccumulation.PreviousAccumulations.First(ac => ac.PayTypeId == payType.PayType.Id).Available;

					}
					else
					{
						carryover = (decimal) paycheck.Employee.CarryOver;
					}

					var thisCheckValue = CalculatePayTypeAccumulation(paycheck, payType.RatePerHour);
					var thisCheckUsed = paycheck.Compensations.Any(p => p.PayType.Id == payType.PayType.Id)
						? CalculatePayTypeUsage(paycheck.Employee,
							paycheck.Compensations.First(p => p.PayType.Id == payType.PayType.Id).Amount)
						: (decimal)0;
					var accumulationValue = (decimal)0;
					if ((ytdAccumulation + thisCheckValue) >= payType.AnnualLimit)
						accumulationValue = Math.Max(payType.AnnualLimit - ytdAccumulation, 0);
					else
					{
						accumulationValue = thisCheckValue;
					}

					result.Add(new PayTypeAccumulation
					{
						PayType = payType,
						AccumulatedValue = Math.Round(accumulationValue, 2, MidpointRounding.AwayFromZero),
						YTDFiscal = Math.Round(ytdAccumulation + accumulationValue, 2, MidpointRounding.AwayFromZero),
						FiscalStart = fiscalStartDate,
						FiscalEnd = fiscalEndDate,
						Used = Math.Round(thisCheckUsed, 2, MidpointRounding.AwayFromZero),
						YTDUsed = Math.Round(ytdUsed + thisCheckUsed, 2, MidpointRounding.AwayFromZero),
						CarryOver = (decimal) Math.Round(carryover, 2, MidpointRounding.AwayFromZero)
					});
				}
				else if (paycheck.Accumulations.Any(apt => apt.PayType.Id == payType.Id))
				{
					var pt = paycheck.Accumulations.First(apt => apt.PayType.Id == payType.Id);
					pt.FiscalStart = fiscalStartDate;
					pt.FiscalEnd = fiscalEndDate;
					result.Add(pt);
				}


			}
			return result;
		}

		private static decimal CalculatePayTypeUsage(HrMaxx.OnlinePayroll.Models.Employee employee, decimal compnesaitonAmount)
		{
			var quotient = employee.Rate;
			if (employee.PayType == EmployeeType.Salary)
			{
				if (employee.PayrollSchedule == PayrollSchedule.Weekly)
					quotient = employee.Rate / (40);
				else if (employee.PayrollSchedule == PayrollSchedule.BiWeekly)
					quotient = (employee.Rate * 26) / (40 * 52);
				else if (employee.PayrollSchedule == PayrollSchedule.SemiMonthly)
					quotient = (employee.Rate * 24) / (40 * 52);
				else if (employee.PayrollSchedule == PayrollSchedule.Monthly)
					quotient = (employee.Rate * 12) / (40 * 52);
			}
			else if (employee.PayType == EmployeeType.PieceWork)
			{
				quotient = employee.Rate;
			}
			else
			{
				if (employee.PayCodes.Any(pc => pc.Id == 0 && pc.HourlyRate > 0))
					quotient = employee.PayCodes.First(pc => pc.Id == 0).HourlyRate;
				else
				{
					quotient = employee.PayCodes.Any() ? employee.PayCodes.OrderBy(pc => pc.HourlyRate).First().HourlyRate : 0;
				}
			}
			return quotient == 0 ? 0 : Convert.ToDecimal(Math.Round(compnesaitonAmount / quotient, 2, MidpointRounding.AwayFromZero));
		}

		private static decimal CalculatePayTypeAccumulation(PayCheck paycheck, decimal ratePerHour)
		{
			if (paycheck.Employee.PayType == EmployeeType.Hourly || paycheck.Employee.PayType == EmployeeType.PieceWork)
			{
				return paycheck.PayCodes.Sum(pc => pc.Hours + pc.OvertimeHours) * ratePerHour;
			}
			else
			{
				if (paycheck.Employee.Rate <= 0)
					return 0;
				var val = (paycheck.Salary / paycheck.Employee.Rate) * (40 * 52 / 365) * ratePerHour;
				if (paycheck.Employee.PayrollSchedule == PayrollSchedule.Weekly)
					return 7 * val;
				else if (paycheck.Employee.PayrollSchedule == PayrollSchedule.BiWeekly)
					return 14 * val;
				else if (paycheck.Employee.PayrollSchedule == PayrollSchedule.SemiMonthly)
					return 15 * val;
				else if (paycheck.Employee.PayrollSchedule == PayrollSchedule.Monthly)
					return DateTime.DaysInMonth(paycheck.PayDay.Year, paycheck.PayDay.Month) * val;
				else
				{
					return 0;
				}
			}
		}

		private static DateTime CalculateFiscalStartDate(DateTime hireDate, DateTime payDay)
		{
			DateTime result;
			var accumulationBaseDate = new DateTime(2015, 7, 1);
			if (hireDate <= accumulationBaseDate)
			{
				if (payDay.Month < 7)
					result = new DateTime(payDay.Year - 1, 7, 1);
				else
					result = new DateTime(payDay.Year, 7, 1);

			}
			else
			{
				if (payDay.Month < hireDate.Month)
					result = new DateTime(payDay.Year - 1, hireDate.Month, hireDate.Day);
				else
				{
					result = new DateTime(payDay.Year, hireDate.Month, hireDate.Day);
				}
			}
			return result;
		}
		

		public class MissingSL
		{
			public Guid companyId { get; set; }
			public Guid employeeId { get; set; }
			public int companyEmployeeNo { get; set; }
			public decimal missingVal { get; set; }
			public decimal missingUsed { get; set; }
			public decimal carryover { get; set; }
		}

		public class SalesPersonCompany
		{
			public Guid CompanyId { get; set; }
			public decimal Percentage { get; set; }
			public Guid UserId { get; set; }
		}

		public class LeaveCycleEmployee
		{
			public Guid EmployeeId { get; set; }
			public DateTime OldFiscalStart { get; set; }
			public DateTime NewFiscalStart { get; set; }
			public decimal CarryOver { get; set; }
		}

		public class EmpCarryOver
		{
			public int empno { get; set; }
			public decimal carryover { get; set; }
		}
	}
}
