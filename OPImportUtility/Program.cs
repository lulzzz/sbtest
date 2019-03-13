using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity.Core.Metadata.Edm;
using System.Diagnostics.Eventing;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Runtime.CompilerServices;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Results;
using Autofac;
using AutoMapper.QueryableExtensions.Impl;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Common.Repository.Security;
using HrMaxx.Infrastructure.Attributes;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Security;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;
using HrMaxx.OnlinePayroll.Repository;
using HrMaxx.OnlinePayroll.Repository.Companies;
using HrMaxx.OnlinePayroll.Services.Mappers;
using HrMaxxAPI.Code.IOC;
using HrMaxxAPI.Resources.Common;
using Magnum;
using Magnum.Reflection;
using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using RestSharp;

namespace OPImportUtility
{
	class Program
	{
		public static List<UserAccount> users = new List<UserAccount>();
		public static List<Contact> contacts = new List<Contact>();
		public static List<HrMaxx.OnlinePayroll.Models.DataModel.Host> hostList = new List<HrMaxx.OnlinePayroll.Models.DataModel.Host>();
		public static List<HrMaxx.OnlinePayroll.Models.DataModel.Company> CompanyList = new List<HrMaxx.OnlinePayroll.Models.DataModel.Company>(); 
		static void Main(string[] args)
		{
			var builder = new ContainerBuilder();
			builder.RegisterModule<LoggingModule>();
			builder.RegisterModule<MapperModule>();

			builder.RegisterModule<ControllerModule>();
			builder.RegisterModule<BusModule>();

			builder.RegisterModule<OPImportUtility.RepositoriesModule>();
			builder.RegisterModule<OPImportUtility.MappingModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.RepositoriesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.MappingModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.ServicesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.CommandHandlerModule>();

			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.RepositoriesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.MappingModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.ServicesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.CommandHandlerModule>();



			var container = builder.Build();
			var companyId = (int) 0;
			Console.WriteLine("Staring Migration " + DateTime.Now.ToShortTimeString());
			Console.WriteLine("Enter 1 for Base Data, 2 for Hosts 3 for Company ");
			var command = Convert.ToInt32(Console.ReadLine());
			switch (command)
			{
				case 1:
					CopyBaseData(container);
					break;
				case 2:
					ImportHosts(container);
					break;
				case 3:
					Console.WriteLine("Companies: Enter Company Id");
					companyId = Convert.ToInt32(Console.ReadLine());
					ImportCompanies(container, companyId);
					break;
				case 4:
					Console.WriteLine("Accounts: Enter Company Id");
					companyId = Convert.ToInt32(Console.ReadLine());
					ImportCompanyAccounts(container, companyId);
					break;
				case 5:
					Console.WriteLine("Vendors: Enter Company Id");
					companyId = Convert.ToInt32(Console.ReadLine());
					ImportCompanyVendors(container, companyId);
					break;
				case 6:
					Console.WriteLine("Employees: Enter Company Id");
					companyId = Convert.ToInt32(Console.ReadLine());
					ImportEmployees(container, companyId);
					break;
				case 7:
					Console.WriteLine("Payrolls: Enter Company Id");
					companyId = Convert.ToInt32(Console.ReadLine());
					ImportPayrolls(container, companyId);
					break;
				case 8:
					Console.WriteLine("Journals: Enter Company Id");
					companyId = Convert.ToInt32(Console.ReadLine());
					ImportJournals(container, companyId);
					break;
				case 9:
					Console.WriteLine("Users: Enter Company Id");
					companyId = Convert.ToInt32(Console.ReadLine());
					var level = Convert.ToInt32(Console.ReadLine());
					ImportUsers(container, level, companyId);
					break;
				case 10:
					Console.WriteLine("Bulk Companies: Status");
					var status = Console.ReadLine();
					ImportBulkCompanies(container, status);
					break;
				case 11:
					Console.WriteLine("Fill Extracts");
					RunExtracts(container);
					break;
				
				default:
					break;
			}
			
			Console.WriteLine("Finished Migration " + DateTime.Now.ToShortTimeString());
			//var command = Convert.ToInt32(Console.ReadLine());
		}

		private static void ImportBulkCompanies(IContainer scope, string status)
		{
			var read = scope.Resolve<IOPReadRepository>();
			var companies =
				read.GetQueryData<int>(
					string.Format("select CompanyId from Company where Status='{0}' and CompanyId not in (select CompanyIntId from paxolop.dbo.Company);", status));
			Console.WriteLine("Companies matching status {0} : {1}", status, companies.Count);
			var counter = (int) 0;
			companies.ForEach(c =>
			{
				Console.WriteLine("Starting company {0}", c);
				ImportCompanies(scope, c);
				Console.WriteLine("{1} -- Finished company {0}", c, counter++);
			});
		}

		private static void ImportOPData(IContainer container)
		{
			CopyBaseData(container);
			Console.WriteLine("Finsihed copying base data");
			ImportHosts(container);
			Console.WriteLine("Finsihed copying hosts");
			//ImportCompanies(container);
			//Console.WriteLine("Finsihed copying companies");
			//ImportCompanyContract(container);
			//Console.WriteLine("Finsihed copying company contract");
			//ImportCompanyAccounts(container);
			//Console.WriteLine("Finsihed copying company accounts");
			//ImportCompanyVendors(container);
			//Console.WriteLine("Finsihed copying company vendors");
			//ImportEmployees(container);
			//Console.WriteLine("Finsihed copying employees");
			//ImportUsers(container);
			//Console.WriteLine("Finsihed copying users");
			//ImportPayrolls(container);
			//Console.WriteLine("Finsihed copying payrolls");
			
		}

		

		private static void ImportJournals(IContainer scope, int companyId)
		{
			var read = scope.Resolve<IOPReadRepository>();
			var write = scope.Resolve<IWriteRepository>();
			var payrollService = scope.Resolve<IPayrollService>();
			var mapper = scope.Resolve<IMapper>();
			if (!users.Any())
			{
				users = read.GetQueryData<UserAccount>(Queries.users);
			}
			var opjournals = read.GetQueryData<Journal>(string.Format(Queries.journal, companyId));
			if (!opjournals.Any())
				return;
			//var accounts = read.GetQueryData<HrMaxx.OnlinePayroll.Models.DataModel.CompanyAccount>("select * from paxolop.dbo.CompanyAccount");
			var companies =
				read.GetQueryData<KeyValuePair<int, Guid>>("select CompanyIntId as [Key], Id as [Value] from PaxolOP.dbo.Company where companyintid="+companyId);
			var opvendors =
				read.GetQueryData<Vendors>("select * from vendor_customer where CompanyId="+companyId);
			var vendors =
				read.GetQueryData<HrMaxx.OnlinePayroll.Models.DataModel.VendorCustomer>("select * from paxolop.dbo.VendorCustomer where CompanyId='" + companies.First().Value + "' or CompanyId is null");
			
			
			
			var changedchecknumber = new StringBuilder();
			var journals = mapper.Map<List<Journal>, List<HrMaxx.OnlinePayroll.Models.Journal>>(opjournals);

			var groups = journals.GroupBy(j => j.CompanyIntId).ToList();
			var counter = (int)0; 
			var company = companies.First(c => c.Key == companyId);
			var employees = read.GetQueryData<EmployeeMin>("select Id, EmployeeIntId, FirstName, LastName, MiddleInitial from PaxolOP.dbo.Employee where CompanyId='" + companies.First().Value + "'");
			var accounts = read.GetQueryData<KeyValuePair<int, string>>("select Id as [Key], Name as [Value] from paxolop.dbo.CompanyAccount where CompanyId='" + companies.First().Value + "'");
			var payrolls =
					read.GetQueryData<PayCheckMin>("select Id, PayrollId, EmployeeId from paxolop.dbo.PayrollPayCheck where CompanyId='" + companies.First().Value + "'");
			var opjournaldetails = read.GetQueryData<JournalDetail>(string.Format("select * from Journal_Detail where journalid in ({0})", Utilities.GetCommaSeperatedList(opjournals.Select(oj=>oj.JournalID).ToList())) );
			Console.WriteLine(string.Format("Groups: {0} Journals:{1}", groups.Count, opjournals.Count));
			groups.ForEach(cid =>
			{
				var list = new List<HrMaxx.OnlinePayroll.Models.Journal>();
				
				cid.OrderBy(j=>j.Id).ToList().ForEach(j =>
				{
					
					var opj = opjournals.First(o => o.JournalID == j.Id);
					var opjd = opjournaldetails.Where(jd => jd.JournalID == j.Id).ToList();

					j.LastModifiedBy = users.First(u => u.UserID == Convert.ToInt32(j.LastModifiedBy)).UserFullName;
					j.CompanyId = company.Value;

					if (j.TransactionType == TransactionType.PayCheck)
					{
						j.EntityType = EntityTypeEnum.Employee;
						var pc = payrolls.FirstOrDefault(pc1=>pc1.Id==j.PayrollPayCheckId);
						if (pc != null)
						{
							j.PayeeId = pc.EmployeeId;
							j.PayrollId = pc.PayrollId;
							j.PayeeName = employees.First(e=>e.Id==pc.EmployeeId).FullName;
						}
					}

					else if (j.TransactionType == TransactionType.RegularCheck)
					{
						if (opj.EntityID > 0)
						{
							var vend = opvendors.First(v => v.VendorCustomerID == opj.EntityID);
							if (vend.VendorCustomerName.Trim().Equals("IRS") || vend.VendorCustomerName.Trim().Equals("IRS - EFT") ||
									vend.VendorCustomerName.Trim().Equals("IRS - manual") || vend.VendorCustomerName.Trim().Equals("IRS EFTPS"))
							{
								j.EntityType = EntityTypeEnum.Vendor;
								j.PayeeId = vendors.First(v => v.VendorCustomerIntId == 1).Id;
								j.PayeeName = vendors.First(v => v.VendorCustomerIntId == 1).Name;
								j.PaymentMethod = EmployeePaymentMethod.DirectDebit;
								j.TransactionType = TransactionType.TaxPayment;
							}
							else if (vend.VendorCustomerName.Trim().Equals("CA - EDD") || vend.VendorCustomerName.Trim().Equals("CA EDD") ||
											 vend.VendorCustomerName.Trim().Equals("EDD") || vend.VendorCustomerName.Trim().Equals("EDD - manual") ||
											 vend.VendorCustomerName.Trim().Equals("EDD EFT"))
							{
								j.EntityType = EntityTypeEnum.Vendor;
								j.PayeeId = vendors.First(v => v.VendorCustomerIntId == 2).Id;
								j.PayeeName = vendors.First(v => v.VendorCustomerIntId == 2).Name;
								j.PaymentMethod = EmployeePaymentMethod.DirectDebit;
								j.TransactionType = TransactionType.TaxPayment;
							}
							else
							{
								j.PayeeId = vendors.First(v => v.VendorCustomerIntId == vend.VendorCustomerID).Id;
								j.PayeeName = vendors.First(v => v.VendorCustomerIntId == vend.VendorCustomerID).Name;
								j.EntityType = vendors.First(v => v.VendorCustomerIntId == vend.VendorCustomerID).IsVendor ? EntityTypeEnum.Vendor : EntityTypeEnum.Customer;
							}
						}
						else if (j.Memo.StartsWith("Taxes Payable"))
						{
							j.PaymentMethod = EmployeePaymentMethod.DirectDebit;
							j.TransactionType = TransactionType.TaxPayment;
							j.EntityType = EntityTypeEnum.Vendor;
							if (j.Memo.Contains("FUTA") || j.Memo.Contains("SS, MD and FED"))
							{
								j.PayeeId = vendors.First(v => v.VendorCustomerIntId == 1).Id;
								j.PayeeName = vendors.First(v => v.VendorCustomerIntId == 1).Name;
							}
							else
							{
								j.PayeeId = vendors.First(v => v.VendorCustomerIntId == 2).Id;
								j.PayeeName = vendors.First(v => v.VendorCustomerIntId == 2).Name;
							}
						}
						else
						{
							j.PayeeId = Guid.Empty;
							j.PayeeName = string.Empty;
						}


					}
					else
					{
						j.PayeeId = Guid.Empty;
						j.PayeeName = string.Empty;
						j.EntityType = (EntityTypeEnum)j.EntityType1;
					}
					
					opjd.ForEach(ojd =>
					{
						var a2 = accounts.First(ac => ac.Key == ojd.COAID);
						var jd = new HrMaxx.OnlinePayroll.Models.JournalDetail()
						{
							AccountId = ojd.COAID,
							IsDebit = ojd.Decrease > 0,
							Amount = ojd.Decrease > 0 ? ojd.Decrease : ojd.Increase,
							AccountName = a2.Value,
							LastModifiedBy = j.LastModifiedBy,
							LastModfied = j.LastModified,
							Memo = ojd.Memo
						};
						int checknumber = 0;
						if (Int32.TryParse(ojd.Number, out checknumber))
							jd.CheckNumber = checknumber;
						if (j.TransactionType == TransactionType.Deposit && ojd.VendorCustomerID > 0)
						{
							var vend = vendors.First(v => v.VendorCustomerIntId == ojd.VendorCustomerID);
							jd.Payee = new JournalPayee() { Id = vend.Id, PayeeName = vend.Name, PayeeType = vend.IsVendor ? EntityTypeEnum.Vendor : EntityTypeEnum.Customer };
						}


						j.JournalDetails.Add(jd);

					});
					if (
						journals.Any(
							j1 =>
								j1.CompanyId == j.CompanyId && j1.TransactionType == j.TransactionType && j1.CheckNumber > 0 && j1.TransactionDate.Year == j.TransactionDate.Year &&
								j1.CheckNumber == j.CheckNumber))
					{
						var newchecknumber = journals.Where(j1 =>
							j1.CompanyId == j.CompanyId && j1.TransactionType == j.TransactionType && j1.CheckNumber > 0 &&
							j1.TransactionDate.Year == j.TransactionDate.Year)
							.Max(j1 => j1.CheckNumber) + 1;
						changedchecknumber.AppendLine(string.Format("Company: {0}, TransactionType:{1}, Old:{2}, New:{3}, Id:{4}",
							j.CompanyIntId, j.TransactionType, j.CheckNumber, newchecknumber, j.Id));
						j.OriginalCheckNumber = j.CheckNumber;
						j.CheckNumber = newchecknumber;
					}
					list.Add(j);
					Console.Write("\rCompany: {0} Total: {1} Journals: {2}           ",cid.Key, cid.ToList().Count, list.Count);
					
				});
				try
				{
					var mapped1 = mapper.Map<List<HrMaxx.OnlinePayroll.Models.Journal>, List<HrMaxx.OnlinePayroll.Models.DataModel.Journal>>(list);
					write.SaveJournals(mapped1);
					
					Console.WriteLine(string.Format("Counter: CompanyIntId:{0} Total:{1}", cid.Key, list.Count));
				}
				catch (Exception e)
				{
					
					throw;
				}
				
			});
			
		}

		private static void GetExtractStartEndDates(DateTime refDate, DepositSchedule941 schedule, ref DateTime startdate,
			ref DateTime enddate)
		{
			if (schedule == DepositSchedule941.Quarterly)
			{
				if (refDate.Month == 1)
				{
					startdate = new DateTime(refDate.Year - 1, 10, 1);
					enddate = new DateTime(refDate.Year - 1, 12, 31);
				}
				else if (refDate.Month == 4)
				{
					startdate = new DateTime(refDate.Year, 1, 1);
					enddate = new DateTime(refDate.Year, 3, 31);
				}
				else if (refDate.Month == 7)
				{
					startdate = new DateTime(refDate.Year, 4, 1);
					enddate = new DateTime(refDate.Year, 6, 30);
				}
				else
				{
					startdate = new DateTime(refDate.Year, 7, 1);
					enddate = new DateTime(refDate.Year, 9, 30);
				}
			}
			else if (schedule == DepositSchedule941.Monthly)
			{
				var month = refDate.Month == 1 ? 12 : refDate.Month - 1;
				var year = refDate.Month == 1 ? refDate.Year - 1 : refDate.Year;
				startdate = new DateTime(year, month, 1);
				enddate = new DateTime(year, month, DateTime.DaysInMonth(year, month));
			}
			else
			{
				
			}

		}

		private static int Extract(IContainer scope, string memo, DepositSchedule941 schedule, List<int> taxes,
			string extractName, int counter, bool matchschedule)
		{
			var read = scope.Resolve<IOPReadRepository>();
			var write = scope.Resolve<IWriteRepository>();
			var journalquery =
				string.Format(
					"select j.* from paxolop.dbo.CheckbookJournal j, paxolop.dbo.Company c where j.CompanyIntId=c.CompanyIntId and j.TransactionType=5 and j.Memo='{0}' and j.IsVoid=0 and year(j.TransactionDate)>2011",
					memo);
			if (matchschedule)
			{
				journalquery += " and c.DepositSchedule941=" + ((int) schedule).ToString();
			}
			var extracts =
				read.GetQueryData<HrMaxx.OnlinePayroll.Models.DataModel.Journal>(journalquery);
			var groups =
				extracts.GroupBy(j => new { j.TransactionDate, j.LastModified }).OrderBy(j => j.Key.TransactionDate).ToList();
			
			groups.ForEach(e =>
			{
				var startdate = new DateTime();
				var enddate = new DateTime();
				GetExtractStartEndDates(e.Key.TransactionDate, schedule, ref startdate, ref enddate);
				var extract = new MasterExtract()
				{
					DepositDate = e.Key.TransactionDate,
					IsFederal = true,
					StartDate = startdate,
					EndDate = enddate,
					LastModified = e.Key.LastModified,
					LastModifiedBy = "Master",
					ExtractName = extractName,
					Id = counter++,
					Journals = e.ToList().Select(j=>j.Id).ToList()
				};
				
				write.AddExtract(extract, e.ToList());
			});
			return counter;
		}

		private static void RunExtracts(IContainer scope)
		{
			var counter = Extract(scope, "Taxes Payable--FUTA Amount", DepositSchedule941.Quarterly, new List<int> { 6 }, "Federal940", 1, false);
			counter = Extract(scope, "Taxes Payable--UI and ETT Tax Amounts", DepositSchedule941.Quarterly, new List<int> { 9, 10 }, "StateCAUI", counter, false);
			counter = Extract(scope, "Taxes Payable--SDI and CA Income Tax Amounts", DepositSchedule941.Quarterly, new List<int> { 6, 7 }, "StateCAPIT", counter, true);
			counter = Extract(scope, "Taxes Payable--SDI and CA Income Tax Amounts", DepositSchedule941.Monthly, new List<int> { 6, 7 }, "StateCAPIT", counter, true);
			counter = Extract(scope, "Taxes Payable--SS, MD and FED Tax Amounts", DepositSchedule941.Quarterly, new List<int> { 1, 2, 3, 4, 5 }, "Federal941", counter, true);
			counter = Extract(scope, "Taxes Payable--SS, MD and FED Tax Amounts", DepositSchedule941.Monthly, new List<int> { 1, 2, 3, 4, 5 }, "Federal941", counter, true);

			counter = Extract(scope, "Taxes Payable--SDI and CA Income Tax Amounts", DepositSchedule941.SemiWeekly, new List<int> { 6, 7 }, "StateCAPIT", counter, true);
			counter = Extract(scope, "Taxes Payable--SS, MD and FED Tax Amounts", DepositSchedule941.SemiWeekly, new List<int> { 1, 2, 3, 4, 5 }, "Federal941", counter, true);
		}
		

		private static void PayrollStatusesAndExtracts(IContainer scope)
		{
			var read = scope.Resolve<IOPReadRepository>();
			var write = scope.Resolve<IWriteRepository>();
			if (!users.Any())
			{
				users = read.GetQueryData<UserAccount>(Queries.users);
			}
			write.ExecuteQuery("update pc set isvoid=1 from PayrollPayCheck pc, Journal j where pc.Id=j.PayrollPayCheckId and j.IsVoid=1 and pc.IsVoid=0;", new {  });
			write.ExecuteQuery("update Employee set LastPayrollDate=(select max(PayDay) from PayrollPayCheck where EmployeeId=Employee.Id and isvoid=0)", new {  });
			write.ExecuteQuery("update Company set LastPayrollDate=(select max(PayDay) from PayrollPayCheck where CompanyId=Company.Id and isvoid=0)", new { });
			write.ExecuteQuery("update pc set VoidedOn=j.EnteredDate, VoidedBy=j.EnteredBy from PayrollPayCheck pc, OnlinePayroll.dbo.Journal j, OnlinePayroll.dbo.COA_Company cc where pc.id=j.PayrollID and pc.IsVoid=1 and j.TransactionType=6 and j.MainCOAID=cc.COAID and cc.CompanyID=pc.CompanyIntId", new {});

			
		}
		
		private static void ImportPayrolls(IContainer scope, int companyId)
		{
			var read = scope.Resolve<IOPReadRepository>();
			var write = scope.Resolve<IWriteRepository>();
			var readservice = scope.Resolve<IReaderService>();
			var taxservice = scope.Resolve<ITaxationService>();
			var metarep = scope.Resolve<IMetaDataRepository>();
			var companyservice = scope.Resolve<ICompanyRepository>();
			var payrollService = scope.Resolve<IPayrollService>();
			var mapper = scope.Resolve<IMapper>();
			if (!users.Any())
			{
				users = read.GetQueryData<UserAccount>(Queries.users);
			}
			
			
			var oppayrolls = read.GetQueryData<Payroll>(string.Format(Queries.payrolls, companyId));
			if (!oppayrolls.Any())
				return;
			var payrollIds = Utilities.GetCommaSeperatedList(oppayrolls.Select(p => p.PayrollID).ToList());
			var optaxes = read.GetQueryData<PayrollTax>(string.Format(Queries.payrolltax, payrollIds));
			var opcomps = read.GetQueryData<PayrollCompensation>(string.Format(Queries.payrollcompensation, payrollIds));
			var opdeds = read.GetQueryData<PayrollDeduction>(string.Format(Queries.payrolldeduction, payrollIds));
			var opacc = read.GetQueryData<PayrollLeaveAccumulation>(string.Format(Queries.payrollaccumulation, payrollIds));
			var opjournals = read.GetQueryData<Journal>(string.Format(Queries.payrollJournals, payrollIds));
			
			var oppayrollpayrates = read.GetQueryData<PayrollPayRate>(string.Format(Queries.payrollpayrates, payrollIds));
			var compList =
				read.GetQueryData<KeyValuePair<int, Guid>>("select CompanyIntId as [Key], Id as [Value] from paxolop.dbo.Company where CompanyIntId=" +
				                                           companyId);
			var companies = readservice.GetCompanies(company: compList.First().Value);
			var employees = readservice.GetEmployees(company: compList.First().Value);
			oppayrollpayrates.ForEach(opc =>
			{
				var c = companies.First(c1 => c1.CompanyIntId == opc.CompanyID);
				if (!c.PayCodes.Any(pc => pc.Description == opc.PayRateDescription && pc.HourlyRate == opc.PayRate))
				{
					var cpc = new CompanyPayCode(){Code=c.PayCodes.Count.ToString().PadLeft(4,'0'), CompanyId = c.Id, Description = opc.PayRateDescription, HourlyRate = opc.PayRate};
					c.PayCodes.Add(companyservice.SavePayCode(cpc));
				}
				
			});
			//var opjournaldetails = read.GetQueryData<JournalDetail>(Queries.journaldetail);
			var paycodemissing = new StringBuilder();
			var taxtable = taxservice.GetTaxTablesByContext().Taxes;
			var paytypes = metarep.GetAllPayTypes();
			var paychecks = new List<PayCheck>();
			var payrolls = new List<HrMaxx.OnlinePayroll.Models.Payroll>();
			var groups =
				oppayrolls.GroupBy(p => new {p.CompanyID, p.PayStartDate, p.PayEndDate, p.SchedulePayDay, p.EnteredDate, p.EnteredBy})
					.ToList();
			groups = groups.Where(p => p.Key.PayStartDate.HasValue && p.Key.PayEndDate.HasValue).OrderBy(p=>p.Key.SchedulePayDay).ToList();
			var company = companies.First(c => c.CompanyIntId == companyId);
			var counter = oppayrolls.Count();
			groups.ForEach(p =>
			{
				
				
				var oppaychecks = p.ToList();
				var journals = opjournals.Where(j => oppaychecks.Any(pc => pc.PayrollID == j.PayrollID)).ToList();
				var user = users.FirstOrDefault(u => u.UserID == p.Key.EnteredBy);
				var payroll = new HrMaxx.OnlinePayroll.Models.Payroll(){ Id = CombGuid.Generate(), Company = company, CompanyIntId=p.Key.CompanyID, ConfirmedTime=p.Key.EnteredDate, 
					QueuedTime = p.Key.EnteredDate, StartDate = p.Key.PayStartDate.Value, EndDate = p.Key.PayEndDate.Value, PayDay = p.Key.SchedulePayDay, PayChecks = new List<PayCheck>(), 
					PEOASOCoCheck=false, 
					StartingCheckNumber = journals.Min(j=>j.tmpTransactionNumber), Status = PayrollStatus.Printed, TaxPayDay = p.Key.SchedulePayDay, IsConfirmFailed=false, InvoiceId = null, 
					UserName = user!=null? user.UserFullName : "System Import", 
					IsHistory = oppaychecks.All(pc=>pc.ScheduleType.Equals("history")), LastModified = p.Key.EnteredDate, VoidedBy=null, VoidedOn=null, InvoiceSpecialRequest = string.Empty, 
					InvoiceNumber = 0, InvoiceStatus=InvoiceStatus.NA};
				oppaychecks.ForEach(pc =>
				{
					var taxes = optaxes.Where(t => t.PayrollId == pc.PayrollID).ToList();
					var comps = opcomps.Where(c => c.PayrollId == pc.PayrollID).ToList();
					var deds = opdeds.Where(d => d.PayrollID == pc.PayrollID).ToList();
					var acc = opacc.Where(a => a.PayrollId == pc.PayrollID).ToList();
					var journal = journals.First(j => j.PayrollID == pc.PayrollID);
					var isvoid = journal.Status.Equals("void");
					var employee = employees.First(e => e.EmployeeIntId == pc.EmployeeID);
					var prevchecks =
						paychecks.Where(
							pc1 =>
								pc1.EmployeeId == employee.Id && !pc1.IsVoid && pc1.PayDay.Year==pc.PayDay.Year && (pc1.PayDay < pc.PayDay || (pc1.PayDay == pc.PayDay && pc1.Id < pc.PayrollID)))
							.ToList();
					var u1 = users.FirstOrDefault(u => u.UserID == journal.LastUpdateBy);
					var uname = u1 != null ? u1.UserFullName : "System Import";
					var paycheck = new PayCheck()
					{
						Id = pc.PayrollID, PayrollId = payroll.Id, CompanyId = company.Id, Accumulations=new List<PayTypeAccumulation>(), CheckNumber = journal.tmpTransactionNumber, CompanyIntId=pc.CompanyID, Compensations=new List<PayrollPayType>(), 
						Taxes = new List<HrMaxx.OnlinePayroll.Models.PayrollTax>(), Deductions=new List<HrMaxx.OnlinePayroll.Models.PayrollDeduction>(), InvoiceId=null,CreditInvoiceId = null, Notes = pc.PayrollNotes, LastModified = pc.LastUpdateDate, LastModifiedBy = users.First(u=>u.UserID==pc.LastUpdateBy).UserFullName, StartDate = p.Key.PayStartDate.Value, EndDate = p.Key.PayEndDate.Value, 
						PayDay = pc.PayDay, IsHistory = payroll.IsHistory, 
						IsVoid = isvoid, VoidedBy = isvoid?uname : null, VoidedOn = isvoid? journal.LastUpdateDate : default(DateTime?),
						IsReIssued = false, ReIssuedDate = null, OriginalCheckNumber = journal.tmpTransactionNumber, PayCodes = new List<PayrollPayCode>(), PEOASOCoCheck=false, 
						GrossWage = pc.GrossPay, NetWage = pc.NetPay, WCAmount = pc.WCAmount, Salary = pc.Salary, 
						TaxPayDay = pc.PayDay, Status = isvoid ? PaycheckStatus.Void : PaycheckStatus.PrintedAndPaid,
						Employee = employee, Included = true, 
						PaymentMethod = string.IsNullOrWhiteSpace(pc.PaymentMethod) || pc.PaymentMethod.Equals("C") ? EmployeePaymentMethod.Check : pc.PaymentMethod.Equals("DD") ? EmployeePaymentMethod.ProfitStars : EmployeePaymentMethod.DirectDebit,
						YTDGrossWage = prevchecks.Sum(pc1 => pc1.GrossWage) + pc.GrossPay,
						YTDNetWage = prevchecks.Sum(pc1 => pc1.NetWage) + pc.NetPay,
						YTDSalary = prevchecks.Sum(pc1 => pc1.Salary) + pc.Salary
					};
					if (pc.WCAmount > 0 && employee.WorkerCompensation != null)
					{
						paycheck.WorkerCompensation = new PayrollWorkerCompensation()
						{
							Amount = pc.WCAmount,
							Wage = pc.GrossPay,
							WorkerCompensation = employee.WorkerCompensation
						};
					}
					else if(pc.WCAmount>0 && employee.WorkerCompensation==null)
					{
						string s = string.Empty;
					}
					if (pc.HoursWorked > 0 || pc.OTWorked > 0)
					{
						paycheck.PayCodes.Add(new PayrollPayCode(){ Amount = pc.Salary, PayCode = new CompanyPayCode(){Code = "Default", CompanyId=company.Id, Description = "Base Rate", HourlyRate = pc.BaseSalaryRate, Id = 0}, Hours = pc.HoursWorked, 
							OvertimeAmount = pc.OTAmount, OvertimeHours = pc.OTWorked, ScreenHours = pc.HoursWorked.ToString(), ScreenOvertime = pc.OTWorked.ToString(),
							YTD = prevchecks.SelectMany(pc1=>pc1.PayCodes.Where(cd=>cd.PayCode.Id==0)).Sum((cd=>cd.Amount)) + pc.Salary,
							YTDOvertime = prevchecks.SelectMany(pc1=>pc1.PayCodes.Where(cd=>cd.PayCode.Id==0)).Sum((cd=>cd.OvertimeAmount)) + pc.OTAmount
						});
					}
					if (pc.MultiplePayRates.HasValue && pc.MultiplePayRates.Value)
					{
						var oppayrate = oppayrollpayrates.Where(opp => opp.PayrollId == pc.PayrollID).ToList();
						oppayrate.ForEach(opp =>
						{
							var cpp =
								company.PayCodes.FirstOrDefault(
									ppc => ppc.Description == opp.PayRateDescription && ppc.HourlyRate == opp.PayRate);
							
								paycheck.PayCodes.Add(new PayrollPayCode()
								{
									Amount = opp.Salary,
									PayCode = cpp,
									Hours = opp.HoursWorked,
									OvertimeAmount = opp.OTAmount,
									OvertimeHours = opp.OTWorked,
									ScreenHours = opp.HoursWorked.ToString(),
									ScreenOvertime = opp.OTWorked.ToString(),
									YTD =
										prevchecks.SelectMany(pc1 => pc1.PayCodes.Where(cd => cd.PayCode.Id == cpp.Id)).Sum((cd => cd.Amount)) +
										opp.Salary,
									YTDOvertime =
										prevchecks.SelectMany(pc1 => pc1.PayCodes.Where(cd => cd.PayCode.Id == cpp.Id)).Sum((cd => cd.OvertimeAmount)) +
										opp.OTAmount
								});
							
							
						});
					}
					taxtable.Where(t=>t.TaxYear==paycheck.PayDay.Year).ToList().ForEach(t =>
					{
						var t1 = t.Tax.Id == 1 || t.Tax.Id == 6
							? taxes.First(t2 => t2.TaxId == t.Tax.Id)
							: t.Tax.Id == 2
								? taxes.First(t2 => t2.TaxId == 3)
								: t.Tax.Id == 3
									? taxes.First(t2 => t2.TaxId == 2)
									: t.Tax.Id == 4
										? taxes.First(t2 => t2.TaxId == 5)
										: t.Tax.Id == 5 ? taxes.First(t2 => t2.TaxId == 4) : taxes.FirstOrDefault(t2 => t2.TaxId == t.Tax.Id);
						if (t1 != null)
						{
							paycheck.Taxes.Add(new HrMaxx.OnlinePayroll.Models.PayrollTax()
							{
								Amount = t1.Amount,
								TaxableWage = t1.TaxableWage,
								Tax = mapper.Map<TaxByYear, Tax>(t),
								YTDTax = prevchecks.SelectMany(c => c.Taxes.Where(t3 => t3.Tax.Id == t.Tax.Id)).Sum(t3 => t3.Amount) + t1.Amount,
								YTDWage = prevchecks.SelectMany(c => c.Taxes.Where(t3 => t3.Tax.Id == t.Tax.Id)).Sum(t3 => t3.TaxableWage) + t1.TaxableWage
							});
						}
						
					});
					comps.ForEach(c => paycheck.Compensations.Add(new PayrollPayType(){ Amount = c.Amount, PayType = paytypes.First(pt=>pt.Id==c.CompensationTypeId), 
						YTD = prevchecks.SelectMany(pc1=>pc1.Compensations.Where(cp=>cp.PayType.Id==c.CompensationTypeId)).Sum(cp=>cp.Amount) + c.Amount,
						Rate = 0,Hours = 0
					}));
					deds.ForEach(d =>
					{
						var compded = company.Deductions.First(cd => cd.Id == d.DeductionID);
						var empded = employee.Deductions.FirstOrDefault(ed => ed.Deduction.Id == d.DeductionID);
						if (empded == null)
						{
							paycheck.Deductions.Add(new HrMaxx.OnlinePayroll.Models.PayrollDeduction()
							{
								Amount = d.Amount,
								EmployeeDeduction =
									new HrMaxx.OnlinePayroll.Models.EmployeeDeduction()
									{
										Deduction = compded,
										AnnualMax = compded.AnnualMax,
										EmployeeId = employee.Id,
										Rate = d.Amount,
										Method = DeductionMethod.Amount
									},
								Deduction = compded,
								AnnualMax = compded.AnnualMax,
								Method = DeductionMethod.Amount,
								Rate = d.Amount,
								YTD =
									prevchecks.SelectMany(pc1 => pc1.Deductions.Where(pd => pd.Deduction.Id == d.DeductionID)).Sum(pd => pd.Amount) + d.Amount,
								Wage = paycheck.GrossWage,
								YTDWage =
									prevchecks.SelectMany(pc1 => pc1.Deductions.Where(pd => pd.Deduction.Id == d.DeductionID)).Sum(pd => pd.Wage) + paycheck.GrossWage
							});

						}
						else
						{
							paycheck.Deductions.Add(new HrMaxx.OnlinePayroll.Models.PayrollDeduction()
							{
								Amount = d.Amount,
								EmployeeDeduction = empded,
								Deduction = compded,
								AnnualMax = compded.AnnualMax,
								Method = empded.Method,
								Rate = empded.Rate,
								YTD =
									prevchecks.SelectMany(pc1 => pc1.Deductions.Where(pd => pd.Deduction.Id == d.DeductionID)).Sum(pd => pd.Amount) + d.Amount,
								Wage = paycheck.GrossWage,
								YTDWage =
									prevchecks.SelectMany(pc1 => pc1.Deductions.Where(pd => pd.Deduction.Id == d.DeductionID)).Sum(pd => pd.Wage) + paycheck.GrossWage
							});
						}


					});
					acc.ForEach(a =>
					{
						var accumulationBaseDate = new DateTime(2015, 7, 1);
						DateTime result;
						if (employee.HireDate <= accumulationBaseDate)
						{
							if (paycheck.PayDay.Month < 7)
								result = new DateTime(paycheck.PayDay.Year - 1, 7, 1);
							else
								result = new DateTime(paycheck.PayDay.Year, 7, 1);

						}
						else
						{
							if(paycheck.PayDay.Month<employee.HireDate.Month)
								result = new DateTime(paycheck.PayDay.Year-1, employee.HireDate.Month, employee.HireDate.Day);
							else
							{
								result = new DateTime(paycheck.PayDay.Year, employee.HireDate.Month, employee.HireDate.Day);
							}
						}
						paycheck.Accumulations.Add(new PayTypeAccumulation()
						{
							AccumulatedValue = a.Accumulation, Used = a.HoursUsed, PayType = company.AccumulatedPayTypes.First(),
							FiscalStart = result,
							FiscalEnd = result.AddYears(1).AddDays(-1), 
							YTDFiscal = paychecks.Where(pc1=>pc1.EmployeeId==employee.Id && !pc1.IsVoid && pc1.Accumulations.Any(acc1=>acc1.FiscalStart==result) && (pc1.PayDay<paycheck.PayDay || (pc1.PayDay==paycheck.PayDay && pc1.Id<paycheck.Id))).SelectMany(pc1=>pc1.Accumulations).Sum(acc1=>acc1.AccumulatedValue),
							YTDUsed = paychecks.Where(pc1 => pc1.EmployeeId == employee.Id && !pc1.IsVoid && pc1.Accumulations.Any(acc1 => acc1.FiscalStart == result) && (pc1.PayDay < paycheck.PayDay || (pc1.PayDay == paycheck.PayDay && pc1.Id < paycheck.Id))).SelectMany(pc1 => pc1.Accumulations).Sum(acc1 => acc1.Used)
						});
					});
					payroll.PayChecks.Add(paycheck);
					paychecks.Add(paycheck);
				});
				var distinctpayday = payroll.PayChecks.Select(pc => pc.PayDay).Distinct().ToList();
				if (distinctpayday.Count==1 && distinctpayday.First() != payroll.PayDay)
				{
					payroll.PayDay = distinctpayday.First();
					payroll.TaxPayDay = distinctpayday.First();
				}
				payrolls.Add(payroll);
				Console.Write("\rCompany: {0},Payrolls: {1} PayChecks: {3} Done: {2}           ", companyId, payrolls.Count, paychecks.Count, counter);
			});
			using (var txn = TransactionScopeHelper.Transaction())
			{
				var mapped = mapper.Map<List<HrMaxx.OnlinePayroll.Models.Payroll>, List<HrMaxx.OnlinePayroll.Models.DataModel.Payroll>>(payrolls);
				write.SavePayrolls(mapped);	
				txn.Complete();
			}
			payrollService.FillPayCheckNormalized(compList.First().Value, null);
			Console.WriteLine("Finished importing payrolls for Company:{0}, Payrolls:{1}", companyId, payrolls.Count);
			
		}

		private static void ImportUsers(IContainer scope, int level, int companyId=0)
		{
			var read = scope.Resolve<IOPReadRepository>();
			var write = scope.Resolve<IWriteRepository>();
			var readservice = scope.Resolve<IReaderService>();
			var hostservice = scope.Resolve<IHostService>();
			//var write = scope.Resolve<IWriteRepository>();
			if (!users.Any())
			{
				users = read.GetQueryData<UserAccount>(Queries.users);
				//contacts = read.GetQueryData<Contact>(Queries.contacts);
			}
			var companies = readservice.GetCompanies(null, null, null);
			var hosts = hostservice.GetHostList(Guid.Empty);
			var appUsers = new List<UserResource>();
			users = users.Where(u => u.LevelID == level).ToList();
			if (companyId > 0)
				users = users.Where(u => u.CompanyID == companyId).ToList();
			else
			{
				users = users.Where(u => u.LevelID == 3 && companies.Any(c => c.CompanyIntId == u.CompanyID)).ToList();
			}
			users.Where(u =>!string.IsNullOrWhiteSpace(u.UserName) && !string.IsNullOrWhiteSpace(u.UserFirstName) && !string.IsNullOrWhiteSpace(u.UserLastName)).ToList().ForEach(u =>
			{
				var appUser = new UserResource()
				{
				Email = Crypto.Decrypt(u.UserName), Active = string.IsNullOrWhiteSpace(u.Status) || u.Status.Equals("A"), 
				Company = u.CompanyID!=null ? companies.First(c=>c.CompanyIntId==u.CompanyID).Id : default(Guid?), Host = u.CPAID!=null ? hosts.First(h=>h.HostIntId==u.CPAID).Id : default(Guid?), 
				FirstName = u.UserFirstName, LastName = u.UserLastName,
				UserName = Crypto.Decrypt(u.UserName).Split('@')[0],
				Password = Crypto.Decrypt(u.Password),
				SubjectUserName = Crypto.Decrypt(u.UserName).Split('@')[0]
				};
				if(u.LevelID==5)
					appUser.Role = new UserRole(){ RoleId = (int)RoleTypeEnum.Master, RoleName = RoleTypeEnum.Master.GetDbName()};
				else if (u.LevelID == 6)
					appUser.Role = new UserRole() { RoleId = (int)RoleTypeEnum.CorpStaff, RoleName = RoleTypeEnum.CorpStaff.GetDbName() };
				else if (u.LevelID == 3)
					appUser.Role = new UserRole() { RoleId = (int)RoleTypeEnum.Company, RoleName = RoleTypeEnum.Company.GetDbName() };
				else if (u.LevelID == 2)
					appUser.Role = new UserRole() { RoleId = (int)RoleTypeEnum.HostStaff, RoleName = RoleTypeEnum.HostStaff.GetDbName() };
				else if (u.LevelID == 1)
					appUser.Role = new UserRole() { RoleId = (int)RoleTypeEnum.Host, RoleName = RoleTypeEnum.Host.GetDbName() };
				appUsers.Add(appUser);
			});
			Console.WriteLine("Starting import of users " + appUsers.Count);
			var success = new List<UserResource>();
			var failed = new List<UserResource>();
			try
			{
				var client = new RestClient(ConfigurationManager.AppSettings["ZionAPIUrl"] + "MigrateUsers");
				appUsers.ForEach(appUser =>
				{
					try
					{
						var request = new RestRequest(Method.POST);
						request.AddHeader("Authorization", "bearer iAWXH5_uozJZjC7aMjMDXQMhiPw0yDOn859zEMWyweT3yqA_kdTSl90PjmVmuI9u2ccOe8HxKn95KmGIVqFETWPpW8t0SXZ6jHgC6DJXZSHlG5Ql7WSZDjC4gLeArbrErfRVrQdX5EE7_1LgVt_h0jbGTL29RXtM82kPHIxHDviplwT5gSWd-DIOlaIq1F2lOMOW5qFgXOaxfigAho794U744vHY_zsE3MgmtilZMbCZ-EtbERC54Z_sRkGabahcI57jW3pnF4aJv6LPVSeZ2Pj_2NjxnPTgcfHw21Z1LZ54HucjK_sw6YlUA6xCFmvwfuXUm7k86pkUx73f7CZexJ8DuB8uv031cWdY1mDYy1HxoXirnweQRW5C3B2xB12-vcxsP3TzZOufU-a2IeSfn0ROpwK9nk2v5Ekqc_U2fABpJIuNpqZiq83Rg5EZt1mleYNFS9XqPQN9yqxzjS31t8EETxJMpTH6h4NI4Ux49KWSVBmWCsXu4emIMZv633TSVenPV-Q8Fj5pJm-tda_HSyelWmd1NbztsmFimvaTb1h6sW43aky3wPSMI8Iec9AUX47BxZ4nDa345iCpNYE6J0I-uz0PMtEdEG7DNYw-de9c8-rr2ZKlr2I51WYSyErvJoP_sWUbyJ0QU3tj1cz_fiB6ZR62lGo9F95jU_oEfnR4snpkW3cVynkJd8bDmIambsEm28FQP-a5LoTk-VGu2GfJw-771sWKC8WsJKmw4AlGh_voSCAxSRLcb1-j7-jfKTpuJsHbHdUek3bXnUEjy0Sdm9nzfuTGzpFgGfqmPci9B7DNoAxBQpzATVAqLh00WG96NC5aXYJfUzGwUWMyquNZulRtMPymPMyhvqFDtA7QSo_8lGTJ53i5cg3-qvNdRngNZ-ZfADESZdlL8s5yhZTbCxDfh_tTN0e9rcZl_nH5AZ8ymmQLWEWjDRHAtv736btKqD7PR95p5sOmXSKZzx9xb5kue6Gs9ci237wG5_EgNgASOx5UDLKUo1UZP-yvwPLMzxjk2A0tp38O8I9AkqsZOKcpiPv1St2lV5P95_TuBK1FUrzYzq7CIJjStHjdyKRC0L-UoaetJzjhrk6Y0fKGAXLFV3ShoyC1d2LK7FRQKQQIkOMEGknBD-FMSHWS_smjXyL4geJQvWIaNQ4saKkAwnaCTED5ipWHM1G9M7CrnUpK4BaK2wIFlG_k-sI1MGvwgM1Uxq0cdP9u5uf3hfNlyfC1hG33SKE5gfvb0OHHhY47E6MUFSJ29-znkf_NrndbaFOELBEuV5i6fJfJG9TwFkPIkNiyqTx6_ai7ZgSmtbEDhQu17YywCtspaP4l4myc3a1beGKj-cKm9QO_Roay27C9a5QclXSonrONVOrN7DhgG_V0SL2dyOIQo-OsMWOGYoCPlA1AGM54C3PaYo_EmeIx-LoPenah5JD4Qi0");
						request.AddHeader("Content-Type", "application/json");
						request.AddParameter("application/json; charset=utf-8", JsonConvert.SerializeObject(appUser), ParameterType.RequestBody);
						request.RequestFormat = DataFormat.Json;
						var response1 = client.Execute(request);
						if (response1.StatusCode == HttpStatusCode.OK)
						{
							success.Add(appUser);
						}
						else
						{
							Console.WriteLine(string.Format("User: {0}, Message: {1}", appUser.UserName, response1.ToString()));
							failed.Add(appUser);
						}
					}
					catch (Exception e1)
					{
						failed.Add(appUser);
						Console.WriteLine(string.Format("User: {0}, Message: {1}", appUser.UserName, e1.Message));
					}
					
				});
					
				

			}
			catch (Exception e)
			{
				
			}
			Console.WriteLine(string.Format("Successful {0}, Failed {1} ",success.Count, failed.Count));
			write.ExecuteQuery("Update aspnetusers set emailconfirmed=1;insert into AspNetUserClaims(UserId, ClaimType, ClaimValue)  " +
			                   "select u.Id, cl.ClaimType, 1 from AspNetUsers u, AspNetUserRoles ur, AspNetRoles r, PaxolFeatureClaim cl " +
			                   "where u.Id=ur.UserId and ur.RoleId=r.Id and cl.AccessLevel<=r.Id " +
			                   "and not exists(select 'x' from AspNetUserClaims where UserId=u.Id and ClaimType=cl.ClaimType)", new {});
			Console.WriteLine("Finsihed importing users");
				
		}

		private static void ImportEmployees(IContainer scope, int companyId)
		{
			var read = scope.Resolve<IOPReadRepository>();
			var write = scope.Resolve<IWriteRepository>();
			var companyservice = scope.Resolve<IReaderService>();
			//
			
			if (!users.Any())
			{
				users = read.GetQueryData<UserAccount>(Queries.users);
				
			}
			if(!contacts.Any())
				contacts = read.GetQueryData<Contact>(Queries.contacts);
			if (!CompanyList.Any())
				CompanyList = read.GetQueryData<HrMaxx.OnlinePayroll.Models.DataModel.Company>(string.Format(Queries.pxcompanies, companyId));
			var companies = companyservice.GetCompanies(company: CompanyList.First().Id);
			var mapper = scope.Resolve<IMapper>();
			var employees = read.GetQueryData<Employee>(string.Format(Queries.employees, companyId));
			
			var employeepaytypess = read.GetQueryData<EmployeePayType>(Queries.employeepaytypes);
			var employeepayratess = read.GetQueryData<EmployeePayRate>(Queries.employeepayrates);

			var payTypes = read.GetQueryData<HrMaxx.OnlinePayroll.Models.PayType>("select * from paxolop.dbo.paytype");

			var employeeList = new List<HrMaxx.OnlinePayroll.Models.Employee>();
			employees.ForEach(e =>
			{
				var mapped = mapper.Map<Employee, HrMaxx.OnlinePayroll.Models.Employee>(e);
				var company = companies.First(c => c.CompanyIntId == e.CompanyID);
				mapped.HostId = company.HostId;
				mapped.CompanyId = company.Id;
				mapped.SSN = mapped.SSN.Replace("-", string.Empty);
				mapped.State = new EmployeeState
				{
					AdditionalAmount = e.StateAdditionalAmount,
					Exemptions = e.StateExemptions,
					State = company.States.First().State,
					TaxStatus =
						e.StateFilingStatus.Equals("UHH")
							? EmployeeTaxStatus.UnmarriedHeadofHousehold
							: e.StateFilingStatus.Equals("MFJ") ? EmployeeTaxStatus.Married : EmployeeTaxStatus.Single
				};
				var bd = Crypto.Decrypt(e.BirthDate);
				if (!string.IsNullOrWhiteSpace(bd))
				{
					DateTime bd1;
					if (DateTime.TryParse(bd, out bd1))
					{
						mapped.BirthDate = bd1;
					}
					else if (DateTime.TryParseExact(bd, "M/dd/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out bd1))
					{
						mapped.BirthDate = bd1;
					}
					else
					{
						mapped.BirthDate = default(DateTime?);
					}
					if (mapped.BirthDate.HasValue && mapped.BirthDate.Value.Year < 1900)
					{
						mapped.BirthDate = new DateTime( 1900 + Convert.ToInt32(mapped.BirthDate.Value.Year.ToString("0000").Substring(2, 2)), mapped.BirthDate.Value.Month, mapped.BirthDate.Value.Day);
					}
				}

				if (e.MultipleCompensationTypes)
				{
					var ept = employeepaytypess.Where(ep => ep.EmployeeId == e.EmployeeID).ToList();
					ept.ForEach(ep => mapped.Compensations.Add(new HrMaxx.OnlinePayroll.Models.EmployeePayType()
					{
						Amount = ep.Amount,
						PayType = payTypes.First(pt => pt.Id == ep.OtherTypeId)
					}));
				}
				if (e.MultiplePayRates)
				{
					var epr = employeepayratess.Where(ep => ep.EmployeeId == e.EmployeeID).ToList();
					epr.ForEach(ep => mapped.PayCodes.Add(company.PayCodes.First(cpc => cpc.Description.Equals(ep.PayRateDescription) && cpc.HourlyRate == ep.PayRateAmount)));
				}
				
				mapped.WorkerCompensation = company.WorkerCompensations.FirstOrDefault(wc => wc.Code == e.WCJobClass);
				mapped.UserName = e.LastUpdatedBy == 0 ? "System" : users.First(u => u.UserID == e.LastUpdatedBy).UserFullName;
				var mc = contacts.First(c => c.EntityTypeID == 3 && c.EntityID == e.EmployeeID);
				mapped.Contact = new HrMaxx.Common.Models.Dtos.Contact()
				{
					Address = new Address
					{
						AddressLine1 = mc.AddressLine1,
						AddressLine2 = mc.AddressLine2,
						CountryId = 1,
						StateId = ((USStates)HrMaaxxSecurity.GetEnumFromHrMaxxName<USStates>(mc.State)).GetDbId().Value,
						City = mc.City,
						Zip = mc.Zip,
						ZipExtension = mc.ZipExtension,
						Type = AddressType.Business
					}
					,
					Email = string.IsNullOrWhiteSpace(mc.Email1) ? "na@na.com" : string.Empty,
					Id = CombGuid.Generate(),
					Fax = Naturalize(mc.Fax),
					FirstName = mc.ContactFirstName,
					MiddleInitial = mc.ContactMiddleName,
					LastName = mc.ContactLastName,
					IsPrimary = true,
					Mobile = Naturalize(mc.Phone2),
					Phone = Naturalize(mc.Phone1),
					LastModified = DateTime.Now,
					UserName = "System Import"
				};
				mapped.SickLeaveHireDate = mapped.HireDate;
				if(mapped.PayType==EmployeeType.Hourly && mapped.PayCodes.All(pc => pc.Id != 0))
					mapped.PayCodes.Add(new CompanyPayCode()
					{
						Id = 0,
						CompanyId = mapped.CompanyId,
						Code = "Default",
						Description = "Base Rate",
						HourlyRate = mapped.Rate
					});
				employeeList.Add(mapped);


			});
			var dbmapped = mapper.Map<List<HrMaxx.OnlinePayroll.Models.Employee>, List<HrMaxx.OnlinePayroll.Models.DataModel.Employee>>(employeeList);
			using (var txn = TransactionScopeHelper.Transaction())
			{
				write.SaveEmployees(dbmapped, companyId);
				txn.Complete();
			}
			Console.Write("finished importing employees for Company:{0} Employees:{1}", companyId, dbmapped.Count);
		}

		private static void ImportCompanyVendors(IContainer scope, int companyId)
		{
			var read = scope.Resolve<IOPReadRepository>();
			var write = scope.Resolve<IWriteRepository>();
			
			if (!users.Any())
			{
				users = read.GetQueryData<UserAccount>(Queries.users);
				//contacts = read.GetQueryData<Contact>(Queries.contacts);
			}
			if (!CompanyList.Any())
				CompanyList = read.GetQueryData<HrMaxx.OnlinePayroll.Models.DataModel.Company>(string.Format(Queries.pxcompanies, companyId));
			var mapper = scope.Resolve<IMapper>();
			var vendors = read.GetQueryData<Vendors>(string.Format(Queries.vendors, companyId));
			var mapped = mapper.Map<List<Vendors>, List<HrMaxx.OnlinePayroll.Models.VendorCustomer>>(vendors);
			foreach (var vendorCustomer in mapped)
			{
				var src = vendors.First(v => v.VendorCustomerID == vendorCustomer.VendorCustomerIntId);
				vendorCustomer.CompanyId = CompanyList.First(c => c.CompanyIntId == src.CompanyID).Id;
				vendorCustomer.UserName = src.LastUpdatedBy.Equals(0) ? "System" : users.First(u => u.UserID == src.LastUpdatedBy).UserFullName;
				vendorCustomer.IdentifierType = !vendorCustomer.IsVendor1099 || (string.IsNullOrWhiteSpace(vendorCustomer.IndividualSSN) && string.IsNullOrWhiteSpace(vendorCustomer.BusinessFIN))
					? VCIdentifierType.NA
					: !string.IsNullOrWhiteSpace(vendorCustomer.IndividualSSN)
						? VCIdentifierType.IndividualSSN
						: VCIdentifierType.BusinessFIN;

				vendorCustomer.Contact.Address.Type = vendorCustomer.IdentifierType == VCIdentifierType.BusinessFIN
					? AddressType.Business
					: AddressType.Personal;

			}
			var dbvendors = mapper.Map<List<VendorCustomer>, List<HrMaxx.OnlinePayroll.Models.DataModel.VendorCustomer>>(mapped);
			using (var txn = TransactionScopeHelper.Transaction())
			{
				write.SaveVendors(dbvendors);
				txn.Complete();
			}
			

		}

		private static void ImportCompanyAccounts(IContainer container, int companyId)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var write = scope.Resolve<IWriteRepository>();
				const string tmp = "insert into AccountTemplate values(1,2,'Bank',null);update OnlinePayroll.dbo.COA_SubTypeLookup set AccountName='Bank' where COA_SubTypeID=1;";
				const string tmpEd = "update CompanyAccount set TemplateId=null where companyId=(select Id from Company where CompanyIntId=@CompanyId) and Type=1 and SubType=2;" +
				                     "delete from AccountTemplate where Type=1 and SubType=2;" +
				                     "Update OnlinePayroll.dbo.COA_SubTypeLookup set AccountName=null where COA_SubTypeID=1;";
				const string accountsql = "set identity_insert CompanyAccount On;" +
				                          "insert into CompanyAccount(Id, CompanyId, Type, SubType, Name, TaxCode, TemplateId, OpeningBalance, BankAccountId, LastModified, LastModifiedBy, UsedInPayroll, UsedInInvoiceDeposit)" +
				                          "select cc.coaid, " +
				                          "(select Id from company where CompanyIntId=cc.CompanyId), act.Type, act.SubType, cc.COAName, act.TaxCode, act.Id, " +
																	"cc.OpeningBalance, " +
				                          "case when act.Type=1 and act.SubType=2 then (select accountid from onlinepayroll.dbo.BankAccount where entitytypeid=5 and EntityId=coaid) else null end, " +
				                          "getdate(),'System Import'," +
																	"case when act.Type=1 and act.SubType=2 and exists (select 'x' from onlinepayroll.dbo.BankAccount where entitytypeid=5 and EntityId=coaid and PayrollFlag='Y') then 1 else 0 end" +
				                          ",0 " +
				                          "from OnlinePayroll.dbo.COA_Company cc, " +
				                          "(select id, type, accounttemplate.subtype, name, accounttemplate.taxcode, COA_SubTypeID " +
				                          "from AccountTemplate, OnlinePayroll.dbo.COA_SubTypeLookup where name=AccountName collate Latin1_General_CI_AS and Type=COA_TypeID) act " +
				                          "where cc.COA_SubTypeID=act.COA_SubTypeID " +
				                          "and cc.CompanyId=@CompanyId; " +
				                          "set identity_insert CompanyAccount Off;";
				const string banksql = "set identity_insert BankAccount On; " +
				                       "insert into BankAccount(Id, EntityTypeId, EntityId, AccountType, BankName, AccountName, AccountNumber, RoutingNumber, LastModified, LastModifiedBy, FractionId) " +
				                       "select AccountId, 2, (select Id from company where CompanyIntId=(select companyid from OnlinePayroll.dbo.COA_Company where coaid=EntityID)), " +
				                       "case when AccountType='Checking' then 1 else 2 end, BankName, BankName, AccountNumber, RoutingNumber, ba.LastUpdateDate, ba.LastUpdateBy,null " +
															 "from OnlinePayroll.dbo.BankAccount ba, OnlinePayroll.dbo.COA_Company cc " +
				                       "where ba.EntityID=cc.COAID and EntityTypeID=5 and cc.COA_SubTypeID=1 " +
				                       "and cc.CompanyId=@CompanyId;" +
				                       "set identity_insert BankAccount Off;";
				using (var txn = TransactionScopeHelper.Transaction())
				{
					write.ExecuteQuery(tmp, new {});
					write.ExecuteQuery(banksql, new { CompanyId=companyId});
					write.ExecuteQuery(accountsql, new { CompanyId = companyId });
					write.ExecuteQuery(tmpEd, new { CompanyId = companyId });
					txn.Complete();
				}
			}
		}

		private static void CopyBaseData(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var read = scope.Resolve<IOPReadRepository>();
				var write = scope.Resolve<IWriteRepository>();
				write.CopyBaseData();
				
			}
			Console.WriteLine("Finsihed copying base data");
		}
		private static void ImportHosts(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var read = scope.Resolve<IOPReadRepository>();
				var write = scope.Resolve<IWriteRepository>();
				var common = scope.Resolve<ICommonService>();
				if (!users.Any())
				{
					users = read.GetQueryData<UserAccount>(Queries.users);
					contacts = read.GetQueryData<Contact>(Queries.contacts);
				}
					
				var data = read.GetQueryData<CPA>(Queries.cpa);
				var mapper = scope.Resolve<IMapper>();
				var hosts = mapper.Map<List<CPA>, List<Host>>(data);
				data.ForEach(c =>
				{
					var host = hosts.First(h => h.HostIntId == c.CPAID);
					var contact = contacts.First(co => co.EntityTypeID == 1 && co.EntityID == host.HostIntId);
					host.UserName = users.First(u => u.UserID.ToString() == host.UserName).UserFullName;
					host.HomePage = new HostHomePage
					{
						Profile = c.WebOverview,
						Services = string.Concat(c.OurService, c.WebNews),
						Telephone = contact.Phone1, Fax = contact.Fax, Email = contact.Email1
					};
					host.HomePage.InitializeContactHours();
					if (string.IsNullOrWhiteSpace(c.OfficeHours1From))
						host.HomePage.ContactHours[0].IsClosed = true;
					else
					{
						host.HomePage.ContactHours[0].IsClosed = false;
						host.HomePage.ContactHours[0].From = Convert.ToDateTime(c.OfficeHours1From);
						host.HomePage.ContactHours[0].To = Convert.ToDateTime(c.OfficeHours1To);
					}
					if (string.IsNullOrWhiteSpace(c.OfficeHours2From))
						host.HomePage.ContactHours[1].IsClosed = true;
					else
					{
						host.HomePage.ContactHours[1].IsClosed = false;
						host.HomePage.ContactHours[1].From = Convert.ToDateTime(c.OfficeHours2From);
						host.HomePage.ContactHours[1].To = Convert.ToDateTime(c.OfficeHours2To);
					}
					if (string.IsNullOrWhiteSpace(c.OfficeHours3From))
						host.HomePage.ContactHours[2].IsClosed = true;
					else
					{
						host.HomePage.ContactHours[2].IsClosed = false;
						host.HomePage.ContactHours[2].From = Convert.ToDateTime(c.OfficeHours3From);
						host.HomePage.ContactHours[2].To = Convert.ToDateTime(c.OfficeHours3To);
					}

				});
				var dbhosts = mapper.Map<List<Host>, List<HrMaxx.OnlinePayroll.Models.DataModel.Host>>(hosts);
				dbhosts.ForEach(h=>h.HomePage = JsonConvert.SerializeObject(hosts.First(h1=>h1.HostIntId==h.HostIntId).HomePage));
				using (var txn = TransactionScopeHelper.Transaction())
				{
					write.SaveHosts(dbhosts);
					dbhosts.ForEach(host => contacts.Where(c => c.EntityTypeID == 1 && c.EntityID == host.HostIntId).ToList().ForEach(c =>
					{
						var contact = new HrMaxx.Common.Models.Dtos.Contact()
						{
							Address =
								new Address()
								{
									AddressLine1 = c.AddressLine1,
									AddressLine2 = c.AddressLine2,
									City = c.City,
									CountryId = 1,
									StateId = 1,
									Zip = c.Zip,
									ZipExtension = c.ZipExtension,
									Type = AddressType.Business,
									LastModified = DateTime.Now,
									UserName = "System Import"
								}
							,
							Email = c.Email1,
							Id = CombGuid.Generate(),
							Fax = Naturalize(c.Fax),
							FirstName = c.ContactFirstName,
							MiddleInitial = c.ContactMiddleName,
							LastName = c.ContactLastName,
							IsPrimary = true,
							Mobile = Naturalize(c.Phone2),
							Phone = Naturalize(c.Phone1),
							LastModified = DateTime.Now,
							UserName = "System Import"
						};
						common.SaveEntityRelation(EntityTypeEnum.Host, EntityTypeEnum.Contact, host.Id, contact);
						common.SaveEntityRelation(EntityTypeEnum.Host, EntityTypeEnum.Address, host.Id, contact.Address);
					}));
					txn.Complete();
					hostList = dbhosts;
				}
				
			}
			ImportUsers(container, 5);
			ImportUsers(container, 6);
			ImportUsers(container, 1);
			ImportUsers(container, 2);
			Console.WriteLine("Finsihed Hosts");

		}
		private static void ImportCompanies(IContainer container, int companyId = 0)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var read = scope.Resolve<IOPReadRepository>();
				var write = scope.Resolve<IWriteRepository>();
				var common = scope.Resolve<ICommonService>();
				var compList =
				read.GetQueryData<KeyValuePair<int, Guid>>("select CompanyIntId as [Key], Id as [Value] from paxolop.dbo.Company where  CompanyIntId=" +
																									 companyId);
				if (!compList.Any())
				{
					if (!users.Any())
					{
						users = read.GetQueryData<UserAccount>(Queries.users);
					}
					if (!contacts.Any())
						contacts = read.GetQueryData<Contact>(Queries.contacts);
					if (!hostList.Any())
						hostList = read.GetQueryData<HrMaxx.OnlinePayroll.Models.DataModel.Host>(Queries.pxhosts);
					var data = read.GetQueryData<Company>(string.Format(Queries.company, companyId));
					var mapper = scope.Resolve<IMapper>();
					var companies = mapper.Map<List<Company>, List<HrMaxx.OnlinePayroll.Models.Company>>(data);
					data.ForEach(c =>
					{
						var company = companies.First();
						company.HostId = hostList.First(h => h.HostIntId == c.CPAID).Id;
						company.UserName = users.First(u => u.UserID.ToString() == company.UserName).UserFullName;

						var mc = contacts.FirstOrDefault(co => co.EntityTypeID == 2 && co.EntityID == company.CompanyIntId && co.ContactType == 1);
						var bc = contacts.First(co => co.EntityTypeID == 2 && co.EntityID == company.CompanyIntId && co.ContactType == 3);
						if (mc == null)
							mc = bc;
						company.CompanyAddress = new Address
						{
							AddressLine1 = mc.AddressLine1,
							AddressLine2 = mc.AddressLine2,
							CountryId = 1,
							StateId = ((USStates)HrMaaxxSecurity.GetEnumFromHrMaxxName<USStates>(mc.State)).GetDbId().Value,
							City = mc.City,
							Zip = mc.Zip,
							ZipExtension = mc.ZipExtension,
							Type = AddressType.Business
						};
						company.BusinessAddress = new Address
						{
							AddressLine1 = bc.AddressLine1,
							AddressLine2 = bc.AddressLine2,
							CountryId = 1,
							StateId = ((USStates)HrMaaxxSecurity.GetEnumFromHrMaxxName<USStates>(bc.State)).GetDbId().Value,
							City = bc.City,
							Zip = bc.Zip,
							ZipExtension = bc.ZipExtension,
							Type = AddressType.Business
						};
						if (company.CompanyAddress.AddressLine1 == company.BusinessAddress.AddressLine1 &&
								company.CompanyAddress.City == company.BusinessAddress.City &&
								company.CompanyAddress.StateId == company.BusinessAddress.StateId &&
								company.CompanyAddress.Zip == company.BusinessAddress.Zip)
							company.IsAddressSame = true;

						company.Contact = new HrMaxx.Common.Models.Dtos.Contact()
						{
							Address = company.CompanyAddress
							,
							Email = mc.Email1,
							Id = CombGuid.Generate(),
							Fax = Naturalize(mc.Fax),
							FirstName = mc.ContactFirstName,
							MiddleInitial = mc.ContactMiddleName,
							LastName = mc.ContactLastName,
							IsPrimary = true,
							Mobile = Naturalize(mc.Phone2),
							Phone = Naturalize(mc.Phone1),
							LastModified = DateTime.Now,
							UserName = "System Import"
						};

						company.States = new List<CompanyTaxState>();
						var cs = (USStates)HrMaaxxSecurity.GetEnumFromDbId<USStates>(company.BusinessAddress.StateId);
						company.States.Add(new CompanyTaxState()
						{
							CountryId = 1,
							State = new State() { Abbreviation = cs.GetHrMaxxName(), StateId = cs.GetDbId().Value, StateName = cs.GetDbName() },
							StateEIN = Crypto.Decrypt(data.First(opc => opc.CompanyID == company.CompanyIntId).SEIN).Replace("-", string.Empty),
							StatePIN = string.IsNullOrWhiteSpace(Crypto.Decrypt(data.First(opc => opc.CompanyID == company.CompanyIntId).STPIN)) ? "0000" : Crypto.Decrypt(data.First(opc => opc.CompanyID == company.CompanyIntId).STPIN),
							Id = 0

						});
						company.FederalPin = string.IsNullOrWhiteSpace(company.FederalPin) ? "0000" : company.FederalPin;

					});
					var dbcompanies = mapper.Map<List<HrMaxx.OnlinePayroll.Models.Company>, List<HrMaxx.OnlinePayroll.Models.DataModel.Company>>(companies);
					using (var txn = TransactionScopeHelper.Transaction())
					{
						dbcompanies.ForEach(c =>
						{
							c.CompanyTaxStates =
								mapper.Map<List<CompanyTaxState>, List<HrMaxx.OnlinePayroll.Models.DataModel.CompanyTaxState>>(companies.First(c1 => c1.CompanyIntId == c.CompanyIntId).States);
						});
						write.SaveCompanies(dbcompanies);
						dbcompanies.ForEach(c =>
						{
							var comp = companies.First(c1 => c1.CompanyIntId == c.CompanyIntId);
							common.SaveEntityRelation(EntityTypeEnum.Company, EntityTypeEnum.Contact, c.Id, comp.Contact);
						});
						CompanyList = dbcompanies;
						txn.Complete();
					}
					write.SaveCompanyAssociatedData(companyId);

				}
			}
				
			ImportCompanyContract(container, companyId);
			ImportCompanyAccounts(container, companyId);
			ImportCompanyVendors(container, companyId);
			ImportEmployees(container, companyId);
			//ImportUsers(container, level:3, companyId: companyId);
			ImportPayrolls(container, companyId);
			ImportJournals(container, companyId);
			Console.WriteLine("Finsihed copying journals");

		}

		private static string Naturalize(string str)
		{
			return
				str.Replace("-", string.Empty)
					.Replace("+", string.Empty)
					.Replace("(", string.Empty)
					.Replace(")", string.Empty)
					.Replace(" ", string.Empty);
		}
		private static void ImportCompanyContract(IContainer container, int companyId)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var read = scope.Resolve<IOPReadRepository>();
				var write = scope.Resolve<IWriteRepository>();
				var common = scope.Resolve<ICommonService>();
				var userservice = scope.Resolve<IUserService>();
				var users = userservice.GetUsers(null, null);
				if (!hostList.Any())
					hostList = read.GetQueryData<HrMaxx.OnlinePayroll.Models.DataModel.Host>(Queries.pxhosts);
				if (!CompanyList.Any())
					CompanyList = read.GetQueryData<HrMaxx.OnlinePayroll.Models.DataModel.Company>(string.Format(Queries.pxcompanies, companyId));
				var subs = read.GetQueryData<Subscription>(string.Format(Queries.subsscription, companyId));
				
				var bds = read.GetQueryData<BillingDetail>(Queries.billing);
				var mapper = scope.Resolve<IMapper>();
				
				CompanyList.ForEach(c =>
				{
					var contract = new ContractDetails();
					var csub = subs.Where(s => s.CompanyId == c.CompanyIntId).ToList();
					if (csub.Any())
					{
						
						var sub = csub.OrderByDescending(s => s.StartDate).First();
						contract = new ContractDetails()
						{
							ContractOption = ContractOption.PrePaid,
							PrePaidSubscriptionOption = (PrePaidSubscriptionOption)sub.SubscriptionOption,
							InvoiceSetup = new InvoiceSetup()
							{
								InvoiceType = CompanyInvoiceType.PEOASOClientCheck,
								InvoiceStyle = CompanyInvoiceStyle.NA,
								RecurringCharges = new List<RecurringCharge>(),
								PrintClientName = true,
								SalesRep = new SalesRep()
								{
									Method = DeductionMethod.NA,
									Rate = 0,
									User = users.First()
								}
							}
						};
						if (sub.BillingDetailId != 0)
						{
							var bd = bds.First(b => b.Id == sub.BillingDetailId);
							var mbd = mapper.Map<BillingDetail, CreditCard>(bd);
							contract.BillingOption = BillingOptions.CreditCard;
							contract.CreditCardDetails = mbd;
							contract.CreditCardDetails.CardName = string.IsNullOrWhiteSpace(contract.CreditCardDetails.CardName)
								? "NA"
								: contract.CreditCardDetails.CardName;
							contract.CreditCardDetails.BillingAddress.AddressLine1 = string.IsNullOrWhiteSpace(contract.CreditCardDetails.BillingAddress.AddressLine1)
								? "NA"
								: contract.CreditCardDetails.BillingAddress.AddressLine1;
							if (Convert.ToInt32(contract.CreditCardDetails.CardType) < 3 && contract.CreditCardDetails.CardNumber.Length!=16)
							{
								contract.CreditCardDetails.CardNumber = contract.CreditCardDetails.CardNumber.PadLeft(16, '0');
							}
							if (Convert.ToInt32(contract.CreditCardDetails.CardType) == 3 && contract.CreditCardDetails.CardNumber.Length != 15)
							{
								contract.CreditCardDetails.CardNumber = contract.CreditCardDetails.CardNumber.PadLeft(15, '0');
							}
							var stateid = HrMaaxxSecurity.GetEnumFromHrMaxxName<USStates>(Crypto.Decrypt(bd.billingAddressState));
							if (stateid != null)
								contract.CreditCardDetails.BillingAddress.StateId = (int) stateid;

						}
						else
						{
							contract.BillingOption = BillingOptions.None;

						}
						
					}
					else
					{
						contract = new ContractDetails()
						{
							ContractOption = ContractOption.PrePaid,
							PrePaidSubscriptionOption = PrePaidSubscriptionOption.NA,
							BillingOption = BillingOptions.None,
							InvoiceSetup = new InvoiceSetup()
							{
								InvoiceType = CompanyInvoiceType.PEOASOClientCheck,
								InvoiceStyle = CompanyInvoiceStyle.NA,
								RecurringCharges = new List<RecurringCharge>(),
								PrintClientName = true,
								SalesRep = new SalesRep()
								{
									Method = DeductionMethod.NA,
									Rate = 0,
									User = users.First()
								}
							}
						};
					}
					write.SaveCompanyContract(c.Id, contract);
				});
				//var companies = mapper.Map<List<Company>, List<HrMaxx.OnlinePayroll.Models.Company>>(data);
				
			}


		}
	}
}
