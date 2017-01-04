using System;
using System.Collections.Generic;
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
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Messages.Events;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Repository.Companies;
using HrMaxxAPI.Code.IOC;
using LinqToExcel;
using Magnum;
using Newtonsoft.Json;



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

			builder.RegisterModule<SiteInspectionStatus_Utility.MappingModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.RepositoriesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.MappingModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.ServicesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.CommandHandlerModule>();

			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.RepositoriesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.MappingModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.ServicesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.CommandHandlerModule>();

			var container = builder.Build();
			Console.Write("Staring Batch ? ");
			int startingBatch = Convert.ToInt32(Console.ReadLine());
			Console.Write("Batch Size? ");
			int batchSize = Convert.ToInt32(Console.ReadLine());
			Console.Write("Number of Batches ? ");
			int runBatches = Convert.ToInt32(Console.ReadLine());
			ImportData(container, startingBatch, batchSize, runBatches);


			Console.WriteLine("Utility run finished for ");
		}


		private static void ImportData(IContainer container, int startingBatch, int batchSize, int runBatches)
		{
			var importLog = string.Empty;
			var companyKeys = new List<KeyValuePair<string, Guid>>();
			var employeeKeys = new List<KeyValuePair<string, Guid>>();

			try
			{
				using (var scope = container.BeginLifetimeScope())
				{
					var excelFile = new ExcelQueryFactory("import data.xlsx");

					var companies = excelFile.Worksheet<Company>("2Company").ToList();// from c in excelFile.Worksheet<Company>("2Company") select c;
					var companydeductions = excelFile.Worksheet<CompanyDeduction>("3Company Deduction").ToList();
					var companyworkercompensations = excelFile.Worksheet<CompanyWorkerCompensation>("4Company Worker Compensation").ToList();
					var companytaxrates = excelFile.Worksheet<CompanyTaxRate>("5Company Tax Rates").ToList();
					var companybankaccoutns = excelFile.Worksheet<CompanyBankAccount>("6Company Bank Account").ToList();
					var employees = excelFile.Worksheet<Employee>("7Employee").ToList();
					var employeedeductions = excelFile.Worksheet<EmployeeDeduction>("9EmployeeDeduction").ToList();
					var agencies = excelFile.Worksheet<VendorCustomer>("10Agency").ToList();
					var garnishments = excelFile.Worksheet<EmployeeGarnishments>("11EmployeeGarnishment").ToList();
					var employeebankaccounts = excelFile.Worksheet<EmployeeBankAccount>("8Employee Bank Account").ToList();
					excelFile = null;


					var mapper = scope.Resolve<IMapper>();
					var bus = scope.Resolve<IBus>();
					var _companyService = scope.Resolve<ICompanyService>();
					var _metaDataService = scope.Resolve<IMetaDataService>();
					var _companyRepository = scope.Resolve<ICompanyRepository>();
					var _hostService = scope.Resolve<IHostService>();
					var _mementoDataService = scope.Resolve<IMementoDataService>();


					var companyMetaData = (CompanyMetaData)_metaDataService.GetCompanyMetaData();
					var accountMetaData = (AccountsMetaData)_metaDataService.GetAccountsMetaData();
					var taxes = _metaDataService.GetCompanyTaxesForYear(2016);
					var employeeMetaData = (EmployeeMetaData)_metaDataService.GetEmployeeMetaData();

					var hostList = _hostService.GetHostList(Guid.Empty);
					var companiestoimport = new List<string>() { "2823","3306","3432","3855" };
					var existingcompanies = _companyRepository.GetAllCompanies();



					///Agencies
					var dbAgencies = _companyService.GetVendorCustomers(null, true).Where(v => v.IsAgency).ToList();
					agencies.ForEach(ag =>
					{
						if (!dbAgencies.Any(dba => !string.IsNullOrWhiteSpace(dba.AccountNo) && dba.AccountNo.Equals(ag.AccountNo)))
						{
							var vc = new HrMaxx.OnlinePayroll.Models.VendorCustomer()
							{
								Id = CombGuid.Generate(),
								IsAgency = true,
								IsTaxDepartment = false,
								IsVendor = true,
								IsVendor1099 = false,
								Name = ag.AgencyName,
								AccountNo = ag.AccountNo,
								StatusId = StatusOption.Active,
								Contact = new Contact()
								{
									FirstName = "NA",
									MiddleInitial = string.Empty,
									LastName = "NA",
									IsPrimary = true,
									Email = "na@na.com",
									Address = new Address()
									{
										AddressLine1 = ag.AddressLine,
										City = ag.AddressCity,
										StateId = 1,
										CountryId = 1,
										LastModified = DateTime.Now,
										Type = AddressType.Business,
										Zip = ag.AZip.Trim(),
										ZipExtension = !string.IsNullOrWhiteSpace(ag.ZipExtension) ? ag.ZipExtension.Trim() : string.Empty
									}
								},
								UserId = Guid.Empty,
								LastModified = DateTime.Now,
								UserName = "System",
								Note = string.Empty
							};
							var savedvc = _companyService.SaveVendorCustomers(vc);
							dbAgencies.Add(savedvc);
						}
					});
					/// end Agencies
					/// 
					/// 

					//foreach (var c in companies.Where(co => companiestoimport.Any(c2 => c2.Equals(co.CompanyNo))))
					var companyOrdered =
						companies.Where(co => !string.IsNullOrWhiteSpace(co.CompanyNo) && companiestoimport.Contains(co.CompanyNo))
							.OrderBy(co => co.ParentId)
							.ThenBy(co => Convert.ToInt32(co.CompanyNo)).ToList();
					
					
					
					for (var i = startingBatch; i < (runBatches + startingBatch); i++)
					{
						Console.WriteLine(string.Format("Batch # {0} - starting at {1}", i, DateTime.Now.ToString("g") ));
						using (var txn = TransactionScopeHelper.TransactionNoTimeout())
						{
							//var subList =
							//	companies.Where(
							//		co =>
							//			!string.IsNullOrWhiteSpace(co.CompanyNo)
							//			//&& Convert.ToInt32(co.CompanyNo) > 3600
							//			//&& Convert.ToInt32(co.CompanyNo) <= 3600 
							//			&& !string.IsNullOrWhiteSpace(co.ParentId)).OrderBy(co => co.ParentId).ThenBy(co => Convert.ToInt32(co.CompanyNo));
							//foreach (var c in subList)
							for(var j=0;j<batchSize;j++)
							{
								int index = i*batchSize + j;
								if (index >= companyOrdered.Count)
								{
									j = 50;
									i = 10;
									break;
								}
								var c = companyOrdered[index];
								Console.WriteLine(string.Format("{1}----Company {0}", c.CompanyNo, index));
								var companyDeductionKeys = new List<KeyValuePair<string, int>>();
								var companyWCKeys = new List<KeyValuePair<string, int>>();
								var company = mapper.Map<SiteInspectionStatus_Utility.Company, HrMaxx.OnlinePayroll.Models.Company>(c);
								var existingCompany =
									existingcompanies.FirstOrDefault(c2 => c2.FederalEIN.Equals(company.FederalEIN) && c2.HostId == company.HostId);
								var host = hostList.First(h => h.Id == company.HostId);

								if (company.IsHostCompany)
								{
									company = host.Company;
									existingCompany = host.Company;
								}
								else if (!string.IsNullOrWhiteSpace(c.ParentId))
								{
									var parent = existingcompanies.FirstOrDefault(co1 => co1.CompanyNo == c.ParentId);
									if (parent == null)
										break;
									var child = JsonConvert.DeserializeObject<HrMaxx.OnlinePayroll.Models.Company>(JsonConvert.SerializeObject(parent));
									child.Id = company.Id;
									child.ParentId = parent.Id;
									child.CompanyAddress = new Address { AddressLine1 = c.AddressLine1, City = c.City, CountryId = 1, StateId = 1, Type = AddressType.Business, Zip = c.Zip.Trim(), ZipExtension = string.Empty };
									child.BusinessAddress = new Address { AddressLine1 = c.AddressLine1, City = c.City, CountryId = 1, StateId = 1, Type = AddressType.Business, Zip = c.Zip.Trim(), ZipExtension = string.Empty };
									child.Name = company.Name;
									child.Locations = null;
									child.Created = DateTime.Now;
									child.LastModified = DateTime.Now;
									child.UserName = "System";
									child.UserId = Guid.Empty;
									child.CompanyTaxRates.ForEach(ct =>
									{
										ct.CompanyId = child.Id;

									});

									child.States.ForEach(ct =>
									{
										ct.Id = 0;

									});

									var savedcompany = _companyRepository.SaveCompany(child);
									var savedcontract = _companyRepository.SaveCompanyContract(savedcompany, child.Contract);
									var savedstates = _companyRepository.SaveTaxStates(savedcompany, child.States);
									savedcompany.Contract = savedcontract;
									savedcompany.States = savedstates;
									company = savedcompany;
								}
								else
								{
									if (existingCompany != null)
										company.Id = existingCompany.Id;
									company.CompanyAddress = new Address { AddressLine1 = c.AddressLine1, City = c.City, CountryId = 1, StateId = 1, Type = AddressType.Business, Zip = c.Zip.Trim(), ZipExtension = string.Empty };
									company.BusinessAddress = new Address { AddressLine1 = c.AddressLine1, City = c.City, CountryId = 1, StateId = 1, Type = AddressType.Business, Zip = c.Zip.Trim(), ZipExtension = string.Empty };
									company.UserName = "System";
									company.LastModified = DateTime.Now;
									company.Contract = new ContractDetails
									{
										ContractOption = ContractOption.PostPaid,
										PrePaidSubscriptionOption = PrePaidSubscriptionOption.NA,
										BillingOption = BillingOptions.Invoice,
										InvoiceSetup = new InvoiceSetup
										{
											InvoiceType = (CompanyInvoiceType)Convert.ToInt32(c.InvoiceType),
											InvoiceStyle = CompanyInvoiceStyle.Summary,
											AdminFee = Convert.ToDecimal(c.AdminFee),
											AdminFeeMethod = Convert.ToInt32(c.AdminFeeMethod),
											ApplyEnvironmentalFee = c.ApplyEnvironmentalFee.Equals("1"),
											ApplyWCCharge = c.ApplyWCCharge.Equals("1"),
											ApplyStatuaryLimits = c.ApplyStatuaryLimits.ToLower().Equals("1"),
											PrintClientName = c.PrintCompanyNameOnChecks.Equals("1") || c.HostId.ToLower().Equals("75a78be4-7226-466b-86ba-a6e200dcaaac"),
											RecurringCharges = new List<RecurringCharge>(),
											SUIManagement = Convert.ToDecimal(c.SUIManagementRate)
										}
									};
									company.States = new List<CompanyTaxState>();
									company.States.Add(new CompanyTaxState()
									{
										CountryId = 1,
										StateEIN = c.StateEIN,
										StatePIN = c.StatePIN,
										State = companyMetaData.Countries.First().States.First(),
										Id = 0
									});
									company.CompanyTaxRates = new List<HrMaxx.OnlinePayroll.Models.CompanyTaxRate>();
									var ctaxes = companytaxrates.FirstOrDefault(ctx => ctx.CompanyNo.Equals(c.CompanyNo));
									companyMetaData.Taxes.Where(t => t.TaxYear == 2016 && t.Tax.IsCompanySpecific).ToList().ForEach(ctx =>
									{
										var taxrate = new HrMaxx.OnlinePayroll.Models.CompanyTaxRate()
										{
											CompanyId = company.Id,
											Id = 0,
											TaxId = ctx.Tax.Id,
											TaxCode = ctx.Tax.Code,
											TaxYear = ctx.TaxYear,
											Rate = 0
										};
										if (ctaxes == null)
											taxrate.Rate = ctx.Tax.DefaultRate;
										else
										{
											taxrate.Rate = ctx.Tax.Id == 9 ? Convert.ToDecimal(ctaxes.ETTRate) : Convert.ToDecimal(ctaxes.SUIRate);
										}
										company.CompanyTaxRates.Add(taxrate);
									});
									company.DirectDebitPayer = employeebankaccounts.Any(eba => eba.CompanyNo.Equals(c.CompanyNo));

									var savedcompany = _companyRepository.SaveCompany(company);
									var savedcontract = _companyRepository.SaveCompanyContract(savedcompany, company.Contract);
									var savedstates = _companyRepository.SaveTaxStates(savedcompany, company.States);
									savedcompany.Contract = savedcontract;
									savedcompany.States = savedstates;


									var memento = Memento<HrMaxx.OnlinePayroll.Models.Company>.Create(savedcompany, EntityTypeEnum.Company, savedcompany.UserName, "Company Imported", company.UserId);
									_mementoDataService.AddMementoData(memento);
									existingcompanies.Add(savedcompany);

								}
								companyKeys.Add(new KeyValuePair<string, Guid>(company.CompanyNo, company.Id));

								///deductions import
								var cdeds = companydeductions.Where(cd => cd.CompanyNo.Equals(c.CompanyNo)).ToList();
								cdeds.ForEach(cd =>
								{
									var companyDeduction =
									mapper
										.Map<SiteInspectionStatus_Utility.CompanyDeduction, HrMaxx.OnlinePayroll.Models.CompanyDeduction>(
											cd);
									if (existingCompany != null)
									{
										var existingDeduction =
									existingCompany.Deductions.FirstOrDefault(d => d.Type.Id == Convert.ToInt32(cd.DeductionType));
										if (existingDeduction != null)
											companyDeduction.Id = existingDeduction.Id;
									}

									companyDeduction.Type = companyMetaData.DeductionTypes.First(t => t.Id == Convert.ToInt32(cd.DeductionType));
									companyDeduction.W2_12 = companyDeduction.Type.W2_12;
									companyDeduction.W2_13R = companyDeduction.Type.W2_13R;
									companyDeduction.R940_R = companyDeduction.Type.R940_R;
									companyDeduction.CompanyId = company.Id;
									companyDeduction.AnnualMax = 0;

									var ded = _companyService.SaveDeduction(companyDeduction, "System", Guid.Empty);
									company.Deductions.Add(ded);
									companyDeductionKeys.Add(new KeyValuePair<string, int>(cd.DeductionId, ded.Id));
								});
								/// end deductions import
								/// Company Worker Compensations
								var cws = companyworkercompensations.Where(cw => cw.CompanyNo.Equals(c.CompanyNo)).ToList();
								cws.ForEach(cw =>
								{
									var companyWC = mapper.Map<SiteInspectionStatus_Utility.CompanyWorkerCompensation, HrMaxx.OnlinePayroll.Models.CompanyWorkerCompensation>(cw);
									if (existingCompany != null)
									{
										var existingWC =
											existingCompany.WorkerCompensations.FirstOrDefault(w => w.Code == companyWC.Code);
										if (existingWC != null)
										{
											companyWC.Id = existingWC.Id;
										}
									}
									companyWC.CompanyId = company.Id;
									var wc = _companyService.SaveWorkerCompensation(companyWC, "System", Guid.Empty);
									company.WorkerCompensations.Add(wc);
									companyWCKeys.Add(new KeyValuePair<string, int>(cw.WCId, wc.Id));
								});
								/// end Company Worker Compensations
								/// accumulated paytype
								company.AccumulatedPayTypes = new List<AccumulatedPayType>();
								companyMetaData.PayTypes.ToList().ForEach(apt =>
								{
									if (existingCompany != null)
									{
										var existingPayType = existingCompany.AccumulatedPayTypes.FirstOrDefault(pt => pt.PayType.Id == apt.Id);
										if (existingPayType == null)
										{
											var apts = new AccumulatedPayType()
											{
												AnnualLimit = 24,
												CompanyId = company.Id,
												CompanyManaged = false,
												Id = 0,
												PayType = apt,
												RatePerHour = (decimal)0.0333
											};
											_companyService.SaveAccumulatedPayType(apts, "System", Guid.Empty);
										}
									}
									else
									{
										var apts = new AccumulatedPayType()
										{
											AnnualLimit = 24,
											CompanyId = company.Id,
											CompanyManaged = false,
											Id = 0,
											PayType = apt,
											RatePerHour = (decimal)0.0333
										};
										_companyService.SaveAccumulatedPayType(apts, "System", Guid.Empty);
									}
								});
								/// end accumulated paytype
								/// Company Bank Account
								var banks = companybankaccoutns.Where(b => b.CompanyNo.Equals(c.CompanyNo)).ToList();
								if (!banks.Any() || banks.Any(ba => string.IsNullOrWhiteSpace(ba.AccountNumber) || string.IsNullOrWhiteSpace(ba.RoutingNumber)))
								{
									var ca = new Account()
									{
										Id = 0,
										CompanyId = company.Id,
										Name = "Bank Account",
										Type = AccountType.Assets,
										SubType = AccountSubType.Bank,
										TaxCode = string.Empty,
										TemplateId = null,
										LastModified = DateTime.Now,
										LastModifiedBy = "System",
										OpeningBalance = 0,
										OpeningDate = DateTime.Now,
										UseInPayroll = true,
										BankAccount = new BankAccount()
										{
											AccountName = "CALIFORNIA BANK & TRUST",
											Id = 0,
											BankName = "CALIFORNIA BANK & TRUST",
											AccountNumber = "3400149791",
											RoutingNumber = "122003396",
											AccountType = BankAccountType.Checking,
											LastModified = DateTime.Now,
											LastModifiedBy = "System",
											SourceId = company.Id,
											SourceTypeId = EntityTypeEnum.Company
										}
									};
									_companyService.SaveCompanyAccount(ca);
								}
								else
								{
									banks.ForEach(bank =>
									{
										var ca = new Account()
										{
											Id = 0,
											CompanyId = company.Id,
											Name = bank.AccountName,
											Type = AccountType.Assets,
											SubType = AccountSubType.Bank,
											TaxCode = null,
											TemplateId = null,
											LastModified = DateTime.Now,
											LastModifiedBy = "System",
											OpeningBalance = 0,
											OpeningDate = DateTime.Now,
											UseInPayroll = true,
											BankAccount = new BankAccount()
											{
												AccountName = bank.AccountName,
												Id = 0,
												BankName = bank.BankName,
												AccountNumber = bank.AccountNumber,
												RoutingNumber = bank.RoutingNumber,
												AccountType = BankAccountType.Checking,
												LastModified = DateTime.Now,
												LastModifiedBy = "System",
												SourceId = company.Id,
												SourceTypeId = EntityTypeEnum.Company
											}
										};
										_companyService.SaveCompanyAccount(ca);
									});
								}
								/// end company bank account
								/// employees and their bank accounts
								var existing = _companyRepository.GetEmployeeList(company.Id);

								var cemps = employees.Where(e => e.CompanyNo.Equals(c.CompanyNo)).ToList();
								cemps.ForEach(e =>
								{
									Console.WriteLine(string.Format("Employee {0}", e.EmployeeNo));
									var emp = mapper.Map<SiteInspectionStatus_Utility.Employee, HrMaxx.OnlinePayroll.Models.Employee>(e);
									var existingEmployee = existing.FirstOrDefault(e2 => e2.SSN.Equals(emp.SSN));
									if (existingEmployee != null)
										emp.Id = existingEmployee.Id;
									emp.CompanyId = company.Id;
									emp.Contact = new Contact()
									{
										Address = new Address()
										{
											AddressLine1 = e.EAddressLine1,
											City = e.ECity,
											StateId = 1,
											CountryId = 1,
											LastModified = DateTime.Now,
											Type = AddressType.Personal,
											Zip = e.EZip.Trim(),
											UserName = "System",
											UserId = Guid.Empty,
											ZipExtension = string.Empty
										},
										Email = "na@na.com",
										FirstName = e.FirstName,
										LastModified = DateTime.Now,
										LastName = e.LastName,
										MiddleInitial = e.MiddleInitial,
										IsPrimary = true,
										UserId = Guid.Empty,
										UserName = "System"
									};
									var empbank = employeebankaccounts.FirstOrDefault(eb => eb.EmployeeNo.Equals(e.EmployeeNo));
									if (empbank != null)
									{
										emp.DirectDebitAuthorized = true;
										emp.BankAccounts = new List<HrMaxx.OnlinePayroll.Models.EmployeeBankAccount>();
										emp.BankAccounts.Add(new HrMaxx.OnlinePayroll.Models.EmployeeBankAccount()
										{
											Id = 0,
											EmployeeId = emp.Id,
											Percentage = (decimal)100,
											BankAccount = new BankAccount()
											{
												AccountName = "Bank Account",
												Id = 0,
												BankName = empbank.BankName,
												AccountNumber = empbank.AccountNumber,
												RoutingNumber = empbank.RoutingNumber,
												AccountType = BankAccountType.Checking,
												LastModified = DateTime.Now,
												LastModifiedBy = "System",
												SourceId = emp.Id,
												SourceTypeId = EntityTypeEnum.Employee
											}
										});
									}
									emp.State = new EmployeeState() { State = company.States.First().State, TaxStatus = (EmployeeTaxStatus)Convert.ToInt32(e.StateFilingStatus), AdditionalAmount = Convert.ToDecimal(e.StateAdditionalAmount), Exemptions = Convert.ToInt32(e.StateExemptions) };
									if (!string.IsNullOrWhiteSpace(e.WCId))
									{
										var wcId = companyWCKeys.FirstOrDefault(wc => wc.Key == e.WCId).Value;
										if (wcId != null)
										{
											var emwc = company.WorkerCompensations.FirstOrDefault(wc => wc.Id == wcId);
											if (emwc != null)
												emp.WorkerCompensation = emwc;
											else
												importLog += string.Format("{0}--{1}--{2}", e.WCId, company.CompanyNo, Environment.NewLine);
										}
										else
										{
											importLog += string.Format("{0}--{1}--{2}", e.WCId, company.CompanyNo, Environment.NewLine);
										}


									}
									if (emp.PayType == EmployeeType.Hourly && (emp.PayCodes == null || !emp.PayCodes.Any(pc => pc.Id == 0)))
									{
										if (emp.PayCodes == null)
											emp.PayCodes = new List<CompanyPayCode>();
										emp.PayCodes.Add(new CompanyPayCode()
										{
											Id = 0,
											CompanyId = emp.CompanyId,
											Code = "Default",
											Description = "Base Rate",
											HourlyRate = emp.Rate
										});
									}
									var savedEmployee = _companyRepository.SaveEmployee(emp);
									employeeKeys.Add(new KeyValuePair<string, Guid>(emp.EmployeeNo, emp.Id));
									var memento = Memento<HrMaxx.OnlinePayroll.Models.Employee>.Create(savedEmployee, EntityTypeEnum.Employee, savedEmployee.UserName);

									_mementoDataService.AddMementoData(memento);
									/// employee deductions
									var ededs = employeedeductions.Where(ed => ed.EmployeeNo.Equals(savedEmployee.EmployeeNo)).ToList();
									ededs.ForEach(ed =>
									{
										var cdedId = companyDeductionKeys.First(cd => cd.Key == ed.DeductionId).Value;
										var cded = company.Deductions.First(d => d.Id == cdedId);
										var empded = new HrMaxx.OnlinePayroll.Models.EmployeeDeduction()
										{
											Id = 0,
											EmployeeId = savedEmployee.Id,
											Deduction = cded,
											AgencyId = null,
											Rate = Convert.ToDecimal(ed.Rate),
											Method = (DeductionMethod)Convert.ToInt32(ed.Method),
											CeilingMethod = !string.IsNullOrWhiteSpace(ed.CeilingMethod) ? Convert.ToInt32(ed.CeilingMethod) : 0,
											CeilingPerCheck =
												!string.IsNullOrWhiteSpace(ed.CeilingPerCheck) ? Convert.ToDecimal(ed.CeilingPerCheck) : default(decimal?),
											AnnualMax = null,
											AccountNo = null,
											Limit = null,
											Priority = null
										};
										_companyService.SaveEmployeeDeduction(empded, "System");
									});

									/// end employee deductions
									/// employee garnishments
									var empg = garnishments.Where(g => g.EmployeeNo.Equals(savedEmployee.EmployeeNo)).ToList();
									empg.ForEach(eg =>
									{
										var agency = dbAgencies.First(dba => !string.IsNullOrWhiteSpace(dba.AccountNo) && dba.AccountNo.Equals(eg.AgencyAccountNo));
										var cded = company.Deductions.FirstOrDefault(d => d.Type.Id == 3 && d.DeductionName.Equals(agency.Name));
										if (cded == null)
										{

											var companyDeduction = new HrMaxx.OnlinePayroll.Models.CompanyDeduction();
											companyDeduction.Id = 0;
											if (existingCompany != null)
											{
												var existingDeduction =
											existingCompany.Deductions.FirstOrDefault(d => d.Type.Id == 3 && d.DeductionName.Equals(agency.Name));
												if (existingDeduction != null)
													companyDeduction.Id = existingDeduction.Id;
											}
											companyDeduction.DeductionName = agency.Name;
											companyDeduction.Description = agency.Name;
											companyDeduction.Type = companyMetaData.DeductionTypes.First(t => t.Id == 3);
											companyDeduction.W2_12 = companyDeduction.Type.W2_12;
											companyDeduction.W2_13R = companyDeduction.Type.W2_13R;
											companyDeduction.R940_R = companyDeduction.Type.R940_R;
											companyDeduction.CompanyId = company.Id;
											var ded = _companyService.SaveDeduction(companyDeduction, "System", Guid.Empty);
											company.Deductions.Add(ded);
											companyDeductionKeys.Add(new KeyValuePair<string, int>(eg.GId, ded.Id));
											cded = ded;
										}

										var garnishment = new HrMaxx.OnlinePayroll.Models.EmployeeDeduction()
										{
											Id = 0,
											EmployeeId = savedEmployee.Id,
											Deduction = cded,
											AgencyId = agency.Id,
											Rate = Convert.ToDecimal(eg.Rate),
											Method = (DeductionMethod)Convert.ToInt32(eg.Method),
											CeilingMethod = !string.IsNullOrWhiteSpace(eg.CPC) ? 2 : 0,
											CeilingPerCheck =
												!string.IsNullOrWhiteSpace(eg.CPC) ? Convert.ToDecimal(eg.CPC) : default(decimal?),
											AnnualMax = null,
											AccountNo = eg.AccountNo,
											Limit = !string.IsNullOrWhiteSpace(eg.Limit) ? Convert.ToDecimal(eg.Limit) : default(decimal?),
											Priority = !string.IsNullOrWhiteSpace(eg.Priority) ? Convert.ToInt32(eg.Priority) : 1
										};
										if (existingEmployee != null)
										{
											var existingGarnishment = existingEmployee.Deductions.FirstOrDefault(ed2 => ed2.Deduction.Id == cded.Id);
											if (existingGarnishment != null)
												garnishment.Id = existingGarnishment.Id;
										}
										_companyService.SaveEmployeeDeduction(garnishment, "System");
									});
									/// end employee garnishments

									//bus.Publish<EmployeeUpdatedEvent>(new EmployeeUpdatedEvent
									//{
									//	SavedObject = savedEmployee,
									//	UserId = savedEmployee.UserId,
									//	TimeStamp = DateTime.Now,
									//	NotificationText = string.Format("{0} by {1}", string.Format("Employee Imported", savedEmployee.FullName), savedEmployee.UserName),
									//	EventType = NotificationTypeEnum.Created
									//});


								});
								/// end employees and their bank accounts


							}
							txn.Complete();
							Console.WriteLine(string.Format("Batch # {0} - completed at {1}", i, DateTime.Now.ToString("g")));
						}
					}
					



				}
			}
			catch (Exception e)
			{
				Console.WriteLine(e.Message);
				Console.WriteLine(e.StackTrace);
			}

		}


	}
}
