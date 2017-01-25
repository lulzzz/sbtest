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
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Messages.Events;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Repository.Companies;
using HrMaxx.OnlinePayroll.Repository.Journals;
using HrMaxx.OnlinePayroll.Repository.Payroll;
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
			//Console.Write("Staring Batch ? ");
			//int startingBatch = Convert.ToInt32(Console.ReadLine());
			//Console.Write("Batch Size? ");
			//int batchSize = Convert.ToInt32(Console.ReadLine());
			//Console.Write("Number of Batches ? ");
			//int runBatches = Convert.ToInt32(Console.ReadLine());
			//ImportData(container, startingBatch, batchSize, runBatches);

			FixMasterExtracts(container);
			//FixAccumulatedSickLeaveValue(container);
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
					var _readerService = scope.Resolve<IReaderService>();


					var companyMetaData = (CompanyMetaData)_metaDataService.GetCompanyMetaData();
					var accountMetaData = (AccountsMetaData)_metaDataService.GetAccountsMetaData();
					var taxes = _metaDataService.GetCompanyTaxesForYear(2016);
					var employeeMetaData = (EmployeeMetaData)_metaDataService.GetEmployeeMetaData();

					var hostList = _hostService.GetHostList(Guid.Empty);
					var companiestoimport = new List<string>() { "3820" };
					var existingcompanies = _readerService.GetCompanies();



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
									var exists =
										existingcompanies.FirstOrDefault(
											c2 =>
												c2.FederalEIN.Equals(c.FederalEIN) && c2.HostId == company.HostId && c2.CompanyNo == c.CompanyNo &&
												c2.IsLocation);
									if (exists == null)
									{
										var child =
											JsonConvert.DeserializeObject<HrMaxx.OnlinePayroll.Models.Company>(JsonConvert.SerializeObject(parent));
										child.Id = company.Id;
										child.ParentId = parent.Id;
										child.CompanyAddress = new Address
										{
											AddressLine1 = c.AddressLine1,
											City = c.City,
											CountryId = 1,
											StateId = 1,
											Type = AddressType.Business,
											Zip = c.Zip.Trim(),
											ZipExtension = string.Empty
										};
										child.BusinessAddress = new Address
										{
											AddressLine1 = c.AddressLine1,
											City = c.City,
											CountryId = 1,
											StateId = 1,
											Type = AddressType.Business,
											Zip = c.Zip.Trim(),
											ZipExtension = string.Empty
										};
										child.Name = company.Name;
										child.Locations = null;
										child.Created = DateTime.Now;
										child.LastModified = DateTime.Now;
										child.UserName = "System";
										child.UserId = Guid.Empty;
										child.CompanyNo = c.CompanyNo;
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
										company = exists;
									}
									
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
											taxrate.Rate = ctx.Tax.Code.Equals("ETT") ? Convert.ToDecimal(ctaxes.ETTRate) : Convert.ToDecimal(ctaxes.SUIRate);
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
								var existing = _readerService.GetEmployees(company:company.Id);

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

		private static void FixMasterExtracts(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var _readerService = scope.Resolve<IReaderService>();
				var _journalRepository = scope.Resolve<IJournalRepository>();
				var _documentService = scope.Resolve<IDocumentService>();
				var extracts = _readerService.GetExtracts();
				using (var txn = TransactionScopeHelper.Transaction())
				{
					extracts.Where(e=>!e.ExtractName.Equals("ACH")).ToList().ForEach(m =>
					{
						var masterExtract = _readerService.GetExtract(m.Id);
						masterExtract.Extract.Data.Hosts.ForEach(h =>
						{
							h.PayChecks = new List<PayCheck>();
							h.CredChecks = new List<PayCheck>();
							var payChecks = h.Companies.SelectMany(c => c.PayChecks).ToList();
							var voidedPayChecks = h.Companies.SelectMany(c => c.VoidedPayChecks).ToList();
							h.PayChecks.AddRange(payChecks);
							h.CredChecks.AddRange(voidedPayChecks);
							h.Accumulation.PayChecks = new List<PayCheck>();
							h.Companies.ForEach(c =>
							{
								c.PayChecks = new List<PayCheck>();
								c.VoidedPayChecks = new List<PayCheck>();
								c.Accumulation.PayChecks = new List<PayCheck>();
								if (c.EmployeeAccumulations!=null && c.EmployeeAccumulations.Any())
									c.EmployeeAccumulations.ForEach(e =>
									{
										e.Accumulation.PayChecks = new List<PayCheck>();
										e.PayChecks = new List<PayCheck>();
									});
							});
							if (h.EmployeeAccumulations!=null && h.EmployeeAccumulations.Any())
								h.EmployeeAccumulations.ForEach(e =>
								{
									e.Accumulation.PayChecks = new List<PayCheck>();
									e.PayChecks = new List<PayCheck>();
								});


					
					});
					masterExtract.Extract.Data.History = new List<MasterExtract>();
					_journalRepository.FixMasterExtract(masterExtract);
				});

					txn.Complete();
				}
				
			}
		}

		private static void FixAccumulatedSickLeaveValue(IContainer container)
		{
			Console.WriteLine("Starting Sick Leave Import---Updating Checks");
			using (var scope = container.BeginLifetimeScope())
			{
				var _readerService = scope.Resolve<IReaderService>();
				var _payrollRepository = scope.Resolve<IPayrollRepository>();
				var _mementoService = scope.Resolve<IMementoDataService>();
				var empList = new List<MissingSL>();
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("3A20B503-C155-4F1B-86F2-A6FF00D595F3"), missingVal = (decimal)0.13, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("A17EF1DB-F25A-4B27-9C21-A6FF00D52A31"), missingVal = (decimal)0.42, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("C073DC7A-F5AB-40FE-912B-A6FF00D497DF"), missingVal = (decimal)0.42, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("B79B9547-7E17-4FAC-9393-A6ED01577861"), missingVal = (decimal)0.43, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("6417FD2C-6A4E-4012-A65C-A6F800DD0676"), missingVal = (decimal)0.5, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("77C49080-5937-4199-9A08-A6F800DDB2BD"), missingVal = (decimal)0.77, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("55F8D49B-DA77-4AF2-8C2C-A6ED0157777B"), missingVal = (decimal)0.88, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("D9B41DC3-2A40-4195-B807-A6F800DC2F6E"), missingVal = (decimal)1.07, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("80696788-6F06-4EB4-89FC-A6ED01576AFE"), missingVal = (decimal)1.41, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("07A7E59D-A5D8-4456-9449-A6ED01575FF4"), missingVal = (decimal)1.7, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("D3E3DBA7-489D-47B3-BF30-A6ED01577701"), missingVal = (decimal)2.03, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("7782D814-9947-4AA5-9C01-A6ED01576056"), missingVal = (decimal)2.22, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("294DDB64-4E69-4E25-B4D3-A6ED01577544"), missingVal = (decimal)2.25, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("07183960-E647-4BF3-9D55-A6F800DBAE11"), missingVal = (decimal)2.3, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("BFE91378-2786-4DEE-B108-A6F800DB2338"), missingVal = (decimal)2.47, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("F1A336A8-04E9-4EE3-B2DA-A6ED015779AE"), missingVal = (decimal)3.33, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("CA82B140-683F-4B87-81DC-A6F800DAC032"), missingVal = (decimal)3.38, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("C23BA247-95E6-46F2-AA6E-A6ED01577939"), missingVal = (decimal)3.53, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("4B4BAEC7-5124-43B3-9D4A-A6F800DA5B1F"), missingVal = (decimal)3.56, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("D71A16C7-A067-4F81-81B9-A6ED01577C06"), missingVal = (decimal)3.62, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("FC4A316C-51EC-47C3-90EA-A6ED0157768C"), missingVal = (decimal)3.97, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("3E30A7D4-EDC8-454B-AAAB-A6F800D9B72C"), missingVal = (decimal)4, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("88FE08C3-3C5E-40FF-B1AA-A6F800D8AE0A"), missingVal = (decimal)4.09, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("BA97E9DF-1D54-4A21-8D5B-A6ED01576585"), missingVal = (decimal)4.34, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("F39547CD-A984-4FBC-B1EE-A6F100CE62C2"), missingVal = (decimal)4.43, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("63857E4B-CC02-47BC-8913-A6F800D92AC6"), missingVal = (decimal)4.54, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("899A601B-22E9-481D-896C-A6ED01577B8C"), missingVal = (decimal)4.83, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("C6CCE8E9-0090-4187-965D-A6F101195FE2"), missingVal = (decimal)4.92, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("278C34FA-0E0F-44DF-AC10-A6F800D83368"), missingVal = (decimal)4.98, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("8A68C318-4E24-4555-9697-A6ED01576AAA"), missingVal = (decimal)5.01, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("448B962D-B3A5-4D86-8612-A6F100CDC1F4"), missingVal = (decimal)5.32, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("3312B208-0111-4C2B-8BD6-A6ED01577138"), missingVal = (decimal)5.73, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("A9A1F36B-B7D7-4C9C-AFC0-A6ED01577471"), missingVal = (decimal)7.04, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("0FB52E23-E1F8-4775-ADA8-A6ED015778C8"), missingVal = (decimal)7.52, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("D61AB6D9-29FC-4ED0-9EE6-A6ED0157759D"), missingVal = (decimal)8, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("A4E80D47-CBC4-49B4-AA77-A6ED01577B17"), missingVal = (decimal)9.31, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("1A5076EA-12C9-47A8-8383-A6ED01577AA2"), missingVal = (decimal)9.83, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("DED30339-754F-468A-A380-A6ED015774E2"), missingVal = (decimal)10.34, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("4B876FF3-49D8-4563-8517-A6ED01577A28"), missingVal = (decimal)11.75, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("FC45E17E-27F6-4133-AFD6-A6ED01577298"), missingVal = (decimal)11.82, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("B4084E78-EBA4-4902-AF7C-A6ED01577390"), missingVal = (decimal)11.98, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("3509D642-D646-4FA3-9E04-A6ED01576900"), missingVal = (decimal)12.34, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("D9A47F26-C05F-4774-BA2D-A6ED0157688A"), missingVal = (decimal)14.45, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("40BC91A2-431D-4876-8B61-A6ED015772D9"), missingVal = (decimal)14.51, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("EC546EFF-44BB-419D-A0F5-A6ED015770E4"), missingVal = (decimal)14.62, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("74E8C3A2-56DF-4BFF-82E3-A6ED01577324"), missingVal = (decimal)15.2, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("F58BB01F-5E95-43CE-A513-A6ED015777F1"), missingVal = (decimal)17.3, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("B8552DC7-31C6-4630-BC48-A6ED01577617"), missingVal = (decimal)17.71, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("E4693E17-19D3-4B53-9ACF-A6ED01576D77"), missingVal = (decimal)18.62, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("9AE5F60D-D6F3-4B8B-8D88-A6ED01576A4C"), missingVal = (decimal)19.12, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("38863F1B-3BB2-472D-84AD-A6ED01577405"), missingVal = (decimal)20.03, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("6BA86570-D39F-48E1-AF4B-A6ED015769E1"), missingVal = (decimal)20.1, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("319CC647-B9BD-4F2A-A439-A6ED0157696B"), missingVal = (decimal)20.5, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("3415C77C-EDE3-40F8-8AD1-A6ED01577256"), missingVal = (decimal)22.39, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("F3A60789-706C-495F-A78A-A6ED015762A5"), missingVal = (decimal)23.64, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("C787BA7B-086B-4556-8529-A6ED01576510"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("77D74D8F-FAF5-4CDE-AB09-A6ED01576734"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("E479E38A-8CFD-4744-97E6-A6ED015764A4"), missingVal = (decimal)24, missingUsed = (decimal)16 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("A339C2CC-3EB4-49C9-8818-A6ED015765FF"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("1ED7899A-F8E4-4BF7-A613-A6ED01576CB2"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("C6BC4E61-A123-4DCB-81B7-A6ED015767A0"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("229BF69F-1C61-4ABB-9DB1-A6ED015766DB"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("7D12547F-F22B-42FB-B561-A6ED0157630C"), missingVal = (decimal)24, missingUsed = (decimal)8 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("F52D756D-103F-4252-932E-A6ED01576D15"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("87D1D403-9CE9-4F2B-AEEA-A6ED01576B94"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("6DDE6F37-56BE-406B-AD0D-A6ED01576674"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("3812E68F-5363-403D-A176-A6ED01576BDB"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("80119078-9991-474F-B61C-A6ED01576450"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("11ACC125-05F6-49EA-BD93-A6ED015771CE"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("DF893A28-0920-448F-8AAA-A6ED01576B4E"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("EBCD6CFB-0F0E-42FE-B2ED-A6ED01576DEC"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("4B63EE14-058A-4FF9-AB68-A6ED01576239"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("4E8A498E-FA87-466F-8C34-A6ED015761DB"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("F6226836-D4C7-4F4A-8327-A6ED01577188"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("2F3B995E-6FD7-4D14-BD7A-A6ED01576166"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("38529BC6-55D6-4E2B-B4B3-A6ED0157702D"), missingVal = (decimal)24, missingUsed = (decimal)16 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("1E842C36-428E-467E-9F36-A6ED01576F4C"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("63947574-7C5D-4D91-B6D7-A6ED01576E5D"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("B3CFC059-378C-4324-BB84-A6ED015760FF"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("81FD2EDC-34E9-4064-9447-A6ED01577215"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("824ED647-8C00-43D8-B6CA-A6ED01576FC1"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("2CE1EF24-FF40-4303-8A1D-A6ED01576381"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("679CC254-56A1-4877-97EF-A6ED01576ED7"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("7D98B095-84F3-4638-AC5E-A6ED01576C3D"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("40C86467-1791-4B34-BDA2-A6ED0157708B"), missingVal = (decimal)24, missingUsed = (decimal)16 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("64846EBF-D061-4995-A994-A6ED015763ED"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("7803B4E4-FF6F-4413-B58E-A6ED015760AF"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("63E0E1B0-277C-4345-82F7-A6ED0158E297"), missingVal = (decimal)0.27, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("A2465B75-8900-41FC-A56A-A6ED0158FC85"), missingVal = (decimal)0.27, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("B74B2B30-1749-4F3A-801D-A6ED0158EDE4"), missingVal = (decimal)0.27, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("6FBF5A1C-B417-4B70-9B17-A6ED0158EBF7"), missingVal = (decimal)0.72, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("76B5AB53-EE3A-4C53-A56D-A6F800E27203"), missingVal = (decimal)1.04, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("18FBB91B-234E-4786-8DBB-A6ED0158E9BC"), missingVal = (decimal)1.51, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("2906A8BB-C4EE-4EE6-8486-A6ED0158EB66"), missingVal = (decimal)2.6, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("5E55228C-2F09-46D8-B45A-A6ED0158FB21"), missingVal = (decimal)4.32, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("575715A3-11EA-4231-B3A3-A6F100D08CF2"), missingVal = (decimal)4.64, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("90901807-EC96-45BD-889E-A6ED0158F1B3"), missingVal = (decimal)5.32, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("3E5DCB1F-2389-4AD9-B381-A6ED0158F0B1"), missingVal = (decimal)5.32, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("DD2B6AD9-820D-4B87-B66F-A6ED0159051B"), missingVal = (decimal)5.81, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("D7215A5D-F065-45AB-AFCC-A6ED0158EC76"), missingVal = (decimal)6.71, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("68A12436-136C-4C72-BECB-A6ED0158EA69"), missingVal = (decimal)7.28, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("FA95613B-53B6-4D26-9D4E-A6ED015903E6"), missingVal = (decimal)9.43, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("0DBCA05A-23AD-4664-9D63-A6ED0159047C"), missingVal = (decimal)11.13, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("A0CE715B-A873-478C-A14C-A6ED0158F9CA"), missingVal = (decimal)11.2, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("4EE355BE-9E97-4AF6-A71D-A6ED01590347"), missingVal = (decimal)11.97, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("D106703A-E74C-4574-B1EE-A6ED015900C4"), missingVal = (decimal)24, missingUsed = (decimal)24 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("ED406CD1-4303-4F08-B1A7-A6ED0158E909"), missingVal = (decimal)13.75, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("51897137-FAF1-4917-9503-A6ED0158F895"), missingVal = (decimal)13.81, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("CDEA99CE-9471-4973-ABAF-A6ED0158F6C5"), missingVal = (decimal)24, missingUsed = (decimal)24 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("5E1D3C7C-546C-4F69-85E0-A6ED0158FABA"), missingVal = (decimal)14.29, missingUsed = (decimal)8 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("2E23F7C2-26E8-4174-AC8F-A6ED0158F930"), missingVal = (decimal)14.79, missingUsed = (decimal)16 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("3788A709-5FE8-44B2-8F45-A6ED0158EB0D"), missingVal = (decimal)15.15, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("1EC3804F-3686-4773-AA31-A6ED0158FF98"), missingVal = (decimal)15.22, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("38E10333-BA6A-4F4B-9CCF-A6ED0158FBE1"), missingVal = (decimal)24, missingUsed = (decimal)24 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("C0022EF0-D33D-4904-9BAF-A6ED0158ED6A"), missingVal = (decimal)15.5, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("7A5CBCB7-0CA5-468C-A91D-A6ED0158E8A2"), missingVal = (decimal)15.57, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("14105D62-AB96-4DD0-B2C8-A6ED01590208"), missingVal = (decimal)24, missingUsed = (decimal)24 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("50A3E56B-956C-4CED-B7A6-A6ED0158FB7A"), missingVal = (decimal)15.96, missingUsed = (decimal)8 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("FF3B2A32-CB59-43BE-8BE2-A6ED0158EA15"), missingVal = (decimal)16.29, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("F50817B9-D26F-450F-9E1A-A6ED015902A3"), missingVal = (decimal)16.41, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("863C09EC-29A8-48F2-9017-A6ED0159016D"), missingVal = (decimal)16.66, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("6F2B6C90-7AD0-4BD4-9CA5-A6ED0158FA49"), missingVal = (decimal)16.66, missingUsed = (decimal)16 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("D548F26A-782E-4B39-B2A7-A6ED0158E962"), missingVal = (decimal)17, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("18CEDBA9-D733-4057-BF63-A6ED0158F760"), missingVal = (decimal)17.29, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("F2925B17-A257-47A1-BD4A-A6ED0158F7FF"), missingVal = (decimal)17.29, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("6782D933-7E47-4DB7-8A5E-A6ED0158E57C"), missingVal = (decimal)17.29, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("0ADE5A28-F726-4F48-A960-A6ED0158E617"), missingVal = (decimal)17.29, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("AC9F8196-D0BF-4452-AF12-A6ED0159002E"), missingVal = (decimal)17.29, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("75FBCAFE-B4A5-4DC1-9C02-A6ED0158FEF9"), missingVal = (decimal)17.29, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("D21E06F0-F1F2-435E-ADE7-A6ED0158E7BD"), missingVal = (decimal)17.57, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("FFE473F4-2D42-48D8-B109-A6ED0158E33B"), missingVal = (decimal)17.58, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("8BCC7F79-470B-426B-880B-A6ED0158E72B"), missingVal = (decimal)17.77, missingUsed = (decimal)8 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("7875BA0E-FE2D-499F-A93B-A6ED0158EAC2"), missingVal = (decimal)18.43, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("7745B3EE-2776-4FBE-B85B-A6ED0158FDBF"), missingVal = (decimal)18.72, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("482585B4-C220-438E-B290-A6ED0158E6A3"), missingVal = (decimal)18.87, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("C7407A47-7D9E-4B76-984D-A6ED0158F0F2"), missingVal = (decimal)19.16, missingUsed = (decimal)16 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("2FA86710-1EFC-4D88-8282-A6ED0158E47F"), missingVal = (decimal)24, missingUsed = (decimal)24 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("5395CBA8-69BE-42C7-B36F-A6ED0158E832"), missingVal = (decimal)19.68, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("6ADFEADA-9045-4C27-B6B7-A6ED0158F626"), missingVal = (decimal)20.11, missingUsed = (decimal)8 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("EACCD2F5-8C01-45FD-9C4C-A6ED0158F3B2"), missingVal = (decimal)20.29, missingUsed = (decimal)16 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("C66F01FF-AF00-45D7-B01E-A6ED0158F171"), missingVal = (decimal)20.5, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("50A9C52C-2179-4580-A850-A6ED0158F586"), missingVal = (decimal)20.79, missingUsed = (decimal)16 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("8E098C37-D21E-4B25-A9B8-A6ED0158EE4F"), missingVal = (decimal)20.99, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("E3F7913D-C6C3-4099-AD11-A6ED0158E502"), missingVal = (decimal)21, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("ED1DBCC5-E9A4-40FE-9BFF-A6ED0158F061"), missingVal = (decimal)21.66, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("156269CC-AFBB-4AFD-A015-A6ED0158FE5A"), missingVal = (decimal)21.69, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("1B2054B4-F52C-4E02-9FEC-A6ED0158ECEB"), missingVal = (decimal)22.54, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("938E1D13-E681-495B-88D6-A6ED0158E3E0"), missingVal = (decimal)22.88, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("E4050533-4594-43C5-9346-A6ED0158F00D"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("904CE6E7-ECDF-441D-9187-A6ED0158FD24"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28"), employeeId = new Guid("9F81D6B8-537E-4B81-9F21-A6ED0158F134"), missingVal = (decimal)24, missingUsed = (decimal)0 });
				empList.Add(new MissingSL() { companyId = new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58"), employeeId = new Guid("DBB0C2B9-E8C5-41E4-AD8E-A6ED01576815"), missingVal = (decimal)24, missingUsed = (decimal)0 });

				Console.WriteLine("Total Employees: " + empList.Count);
				var payChecks = 0;
				var empsprocessed = 0;
				using (var txn = TransactionScopeHelper.Transaction())
				{
					empList.ForEach(e =>
					{
						var empChecks = _readerService.GetPayChecks(companyId: e.companyId, employeeId: e.employeeId, isvoid: 0).OrderBy(p=>p.PayDay);
						empChecks.ToList().ForEach(pc =>
						{
							var sickLeave = pc.Accumulations.FirstOrDefault(pt => pt.PayType.PayType.Id == 6);
							if (sickLeave != null)
							{
								sickLeave.YTDFiscal += e.missingVal;
								sickLeave.YTDUsed += e.missingUsed;
								_payrollRepository.UpdatePayCheckSickLeaveAccumulation(pc);
								var memento = Memento<PayCheck>.Create(pc, EntityTypeEnum.PayCheck, "System", "Sick Leave Imported", Guid.Empty);
								_mementoService.AddMementoData(memento);
								payChecks++;
							}
						});
						empsprocessed++;

					});
					Console.WriteLine("Checks Updated: " + payChecks);
					Console.WriteLine("Employees Processed: " + empsprocessed);
					Console.Write("Commit? ");
					var commit = Convert.ToInt32(Console.ReadLine());
					if (commit == 1)
					{
						txn.Complete();
					}
					

					
				}

			}
		}

		public class MissingSL
		{
			public Guid companyId { get; set; }
			public Guid employeeId { get; set; }
			public decimal missingVal { get; set; }
			public decimal missingUsed { get; set; }
		}
	}
}
