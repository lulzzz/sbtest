using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web.UI;
using System.Xml.Serialization;
using Autofac;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Common.Repository.Mementos;
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
using HrMaxx.OnlinePayroll.ReadRepository;
using HrMaxx.OnlinePayroll.Repository;
using HrMaxx.OnlinePayroll.Repository.Companies;
using HrMaxx.OnlinePayroll.Repository.Journals;
using HrMaxx.OnlinePayroll.Repository.Payroll;
using HrMaxxAPI.Code.IOC;
using LinqToExcel;
using Magnum;
using Magnum.PerformanceCounters;
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
					FixPayrollYtd(container);
					break;
				case 10:
					FixPayCheckYtd(container);
					break;
				case 11:
					UpdateInvoiceDeliveryLists(container);
					break;
				case 12:
					CompareTaxRates(container);
					break;
				case 13:
					FixAccumulationCycleAndYtd(container);
					break;
				case 14:
					UpdateEmployeeCarryOver(container);
					break;
				case 15:
					FixAccumulationCycleAndYtdForPeo(container);
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
				case 189:
					FixMovedInvoices(container);
					break;
				case 19:
					ChangeEmployeesToFiscalYear(container);
					break;
				case 20:
					SaveRecurringCharges(container);
					break;
				case 21:
					SaveMasterExtractsAsFiles(container);
					break;
				case 22:
					SaveMementosAsFiles(container);
					break;
				case 23:
					SaveRecurringChargeClaimed(container);
					break;
				case 24:
					FixRecurringCharges(container);
					break;
				case 25:
					NormalizeMasterExtractJournals(container);
					break;
				case 26:
					FixInvoicesWithVoidCredits(container);
					break;
				case 27:
					FillCompanyCity(container);
					break;
				case 28:
					UpdateCbcsuiManagementRate(container);
					break;
				case 29:
					UpdateCompanyAch(container);
					break;
				case 30:
					MigrateDocuments(container);
					break;
                case 31:
                    MoveDocuments(container);
                    break;
                case 32:
                    FixFitWage(container);
                    break;
                case 33:
                    FixCreditCardCompanies(container);
                    break;
                default:
					break;
			}

			Console.WriteLine("Utility run finished for ");
		}
        private static void FixCreditCardCompanies(IContainer container)
        {
            using (var scope = container.BeginLifetimeScope())
            {
                var companyService = scope.Resolve<ICompanyService>();
                var repository = scope.Resolve<ICompanyRepository>();
                var readerservice = scope.Resolve<IReaderService>();
                var companies = readerservice.GetCompanies(status:0);
                var counter = (int)0;
                companies.ForEach(c =>
                    {
                        if (c.Contract.BillingOption == BillingOptions.CreditCard)
                        {
                            var update = false;
                            if (c.Contract.CreditCardDetails.CardType == 0 || c.Contract.CreditCardDetails.CardType==null)
                            {
                                if(!string.IsNullOrWhiteSpace(c.Contract.CreditCardDetails.CardNumber) && c.Contract.CreditCardDetails.CardNumber.Length==15)
                                {
                                    c.Contract.CreditCardDetails.CardType = 3;update = true;
                                }
                                else if (!string.IsNullOrWhiteSpace(c.Contract.CreditCardDetails.CardNumber) && c.Contract.CreditCardDetails.CardNumber.Length == 16)
                                {
                                    c.Contract.CreditCardDetails.CardType = 1; update = true;
                                }
                                else if(!string.IsNullOrWhiteSpace(c.Contract.CreditCardDetails.CardNumber))
                                {
                                    c.Contract.CreditCardDetails.CardType = 1;
                                    c.Contract.CreditCardDetails.CardNumber = c.Contract.CreditCardDetails.CardNumber.PadLeft(16, '0');
                                    if (c.Contract.CreditCardDetails.CardNumber.Length > 16)
                                    {
                                        string text = string.Empty;
                                    }
                                    update = true;
                                }
                                else { c.Contract.CreditCardDetails.CardType = 1; update = true; }
                            }
                            if (c.Contract.CreditCardDetails.CardType == 3 && c.Contract.CreditCardDetails.CardNumber.Length!=15)
                            {
                                c.Contract.CreditCardDetails.CardNumber = c.Contract.CreditCardDetails.CardNumber.PadLeft(15, '0');
                                update = true;
                            }
                            else if (c.Contract.CreditCardDetails.CardType != 3 && c.Contract.CreditCardDetails.CardNumber.Length != 16)
                            {
                                c.Contract.CreditCardDetails.CardNumber = c.Contract.CreditCardDetails.CardNumber.PadLeft(16, '0');
                                update = true;
                            }

                            if (update)
                            {
                                repository.SaveCompanyContract(c, c.Contract);
                                Console.WriteLine("Company " + c.Id + "   " + c.Name);
                                counter++;
                            }
                            
                        }
                        
                    });
                Console.WriteLine("Companies Updated " + counter);

            }
        }
        private static void FixFitWage(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var payrollService = scope.Resolve<IPayrollRepository>();
				var readerservice = scope.Resolve<IReaderService>();
                var taxationService = scope.Resolve<ITaxationService>();
				
				var payChecks = new List<PayCheck>();
				var payrolls = readerservice.GetPayChecks(year:2019, startDate:new DateTime(2019,12,19)).Where(pc => pc.Taxes.Any(pct => pct.Tax.Code == "FIT" && pct.TaxableWage == 0)
                && pc.LastModified > new DateTime(2019, 12, 19)).ToList();

                payrolls.ForEach(pc =>
                            {
                                var pct = pc.Taxes.First(t => t.Tax.Code == "FIT");
                                var deductionExempt = taxationService.GetTaxExemptedDeductions(pc, pc.GrossWage, pct.Tax.Code);
                                var taxableWage = pc.GrossWage - deductionExempt;
                                if (pct.TaxableWage != taxableWage)
                                {
                                    pct.YTDWage = Math.Round(pct.YTDWage - pct.TaxableWage + taxableWage, 2, MidpointRounding.AwayFromZero);
                                    pct.TaxableWage = Math.Round(taxableWage, 2, MidpointRounding.AwayFromZero);
                                    payChecks.Add(pc);
                                }
                                
                            }

                );
                payrollService.FixPayCheckTaxWages(payChecks, "FIT");

				Console.WriteLine("Checks Updated " + payChecks.Count);

			}
		}
		private static void UpdateCompanyAch(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var readerservice = scope.Resolve<IReaderService>();
				var companyservice = scope.Resolve<ICompanyService>();
				var companyrepository = scope.Resolve<ICompanyRepository>();
				var achInvoices =
					readerservice.GetPayrollInvoices(paymentMethods: new List<InvoicePaymentMethod> {InvoicePaymentMethod.ACH});

				var companies = readerservice.GetCompanies(status:0);
				var updatedCount = (int) 0;
				var distinctCompanies = achInvoices.Select(i => i.CompanyId).Distinct().ToList();
				distinctCompanies.ForEach(cid =>
				{
					var company = companies.First(c => c.Id == cid);
					if (!company.Contract.InvoiceSetup.PaysByAch)
					{
						company.Contract.InvoiceSetup.PaysByAch = true;
						companyrepository.SaveCompanyContract(company, company.Contract);
						updatedCount++;
					}
				});
				Console.WriteLine("companies updated " + updatedCount);
			}
		}
		private static void MigrateDocuments(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var readerservice = scope.Resolve<IReaderService>();
				var documentService = scope.Resolve<IDocumentService>();
				var commonService = scope.Resolve<ICommonService>();
				var metaDataService = scope.Resolve<IMetaDataService>();
				var reader = scope.Resolve<IReadRepository>();
				const string readSql = "select * from Document";
				const string documentTypeSql = "select * from DocumentType";
				const string  updateSql = "Update Document set Type=@Type, Uploaded=@Uploaded, UploadedBy=@UploadedBy where Id=@Id;";
				var docs = reader.GetQueryData<Document>(readSql);
				var types = reader.GetQueryData<DocumentType>(documentTypeSql);
				docs.ForEach(d =>
				{
					d.DocumentType = types.First(t => t.Id.Equals((int)d.DocumentDto.DocumentType));
					d.Uploaded = d.DocumentDto.LastModified;
					d.UploadedBy = d.DocumentDto.UserName;
					commonService.ExecuteQuery<Document>(updateSql, new {Type=d.DocumentType.Id, d.Id, d.Uploaded, d.UploadedBy});
				});


			
			}
		}
        private static void MoveDocuments(IContainer container)
        {
            using (var scope = container.BeginLifetimeScope())
            {
                
                var _fileRepo = scope.Resolve<IFileRepository>();
                var reader = scope.Resolve<IReadRepository>();
                
                const string readSql = "select Id from Payroll";
                const string docsquery = "select * from Document";
                
                var payrolls = reader.GetQueryData<Guid>(readSql);
                var docs = reader.GetQueryData<Document>(docsquery);
               
                var payrollCounter = (int) 0;
                var docCounter = (int)0;
                payrolls.ForEach(p =>
                {
                   if(_fileRepo.FileExists(string.Empty, p.ToString(), "pdf"))
                   {
                       _fileRepo.MoveDestinationFile($"{p}.pdf", $"{EntityTypeEnum.Payroll.GetDbName()}\\{p}.pdf");
                       payrollCounter++;
                   }
                });
                docs.ForEach(d =>
                {
                    
                    if (_fileRepo.FileExists(string.Empty, d.DocumentDto.Id.ToString(), d.DocumentDto.DocumentExtension))
                    {
                        _fileRepo.MoveDestinationFile($"{d.DocumentDto.Id}.{d.DocumentDto.DocumentExtension}", $"{d.Path}");
                        docCounter++;
                    }
                });

                Console.WriteLine($"Payroll files moved {payrollCounter}: Docs Moved: {docCounter}");
            }
        }

        private static void UpdateCbcsuiManagementRate(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var readerservice = scope.Resolve<IReaderService>();
				var companyservice = scope.Resolve<ICompanyService>();
				var companies = readerservice.GetCompanies(host: new Guid("ECE56649-623B-447B-A02B-A6E200DC8092")).Where(c=>c.Contract.InvoiceSetup.SUIManagement!=(decimal)2.1).ToList();
				companies.ForEach(c =>
				{
					c.Contract.InvoiceSetup.SUIManagement = (decimal) 2.1;
					c.UserId = Guid.Empty;
					c.UserName = "System";
					companyservice.Save(c);
				});
				Console.WriteLine("companies updated " + companies.Count);
			}
		}

		private static void FillCompanyCity(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var readerservice = scope.Resolve<IReaderService>();
				var companyrepository = scope.Resolve<ICompanyRepository>();
				var companies = readerservice.GetCompanies();
				companies.ForEach(c=>companyrepository.SaveCompany(c));
			}
		}

		private static
			void FixInvoicesWithVoidCredits(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var readerservice = scope.Resolve<IReaderService>();

				var payrollrepository = scope.Resolve<IPayrollRepository>();
				var invoices = readerservice.GetPayrollInvoices(invoiceNumber: 52210);
				var nocredits = new List<PayrollInvoice>();
				var yescredits = new List<PayrollInvoice>();
				var partialcredits = new List<PayrollInvoice>();
				invoices = invoices.Where(i => i.VoidedCreditedChecks.Any() && i.ProcessedOn > new DateTime(2018, 9, 1)).ToList();
				invoices.ForEach(i =>
				{
					int counter = 0;
					i.VoidedCreditedChecks.ForEach(vc =>
					{
						if (i.MiscCharges.Any(mc => mc.RecurringChargeId == -1 && mc.PayCheckId == vc))
							counter++;
					});
					if(counter==i.VoidedCreditedChecks.Count)
						yescredits.Add(i);
					else if (counter == 0 && (int)i.CompanyInvoiceSetup.InvoiceType<=2)
					{
						nocredits.Add(i);
						payrollrepository.FixInvoiceVoidedCredit(i);
						Console.WriteLine(i.InvoiceNumber);
					}
						
					else
					{
						partialcredits.Add(i);
					}

					
				});
				
				Console.WriteLine(string.Format("Total {0} No Credits {1} Yes Credits {2} Partial {3}  Min {4} {5} {6}", invoices.Count, nocredits.Count, yescredits.Count, partialcredits.Count, nocredits.Min(i=>i.ProcessedOn), yescredits.Min(i=>i.ProcessedOn), nocredits.Max(i=>i.ProcessedOn)));

			}

		}
		private static void NormalizeMasterExtractJournals(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var readerservice = scope.Resolve<IReaderService>();
				
				var journalrepository = scope.Resolve<IJournalRepository>();
				var extracts = readerservice.GetExtracts();
				extracts.ForEach(journalrepository.NormalizeExtractJournal);
			}
			
		}
		private static void SaveMasterExtractsAsFiles(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var readerservice = scope.Resolve<IReaderService>();
				var reader = scope.Resolve<IReadRepository>();
				var filerepository = scope.Resolve<IFileRepository>();
				var extracts = readerservice.GetExtracts();
				extracts.ForEach(e =>
				{
					var extract = reader.GetQueryData<List<KeyValueResult>>(string.Format("select MasterExtractId as [Key], Extract as Value from PaxolArchive.dbo.MasterExtract where MasterExtractId={0} for xml path('KeyValueResult'), elements, type, root('KeyValueResultList')", e.Id), new XmlRootAttribute("KeyValueResultList"));
					filerepository.SaveArchiveJson(ArchiveTypes.Extract.GetDbName(), string.Empty, e.Id.ToString(), extract.First().Value);
					
				});
			}

		}
		private static void SaveMementosAsFiles(IContainer container)
		{
			Console.WriteLine(DateTime.Now.TimeOfDay);
			using (var scope = container.BeginLifetimeScope())
			{
				
				var reader = scope.Resolve<IReadRepository>();
				var filerepository = scope.Resolve<IFileRepository>();
				var mementos = reader.GetQueryData<List<KeyValueResult>>("select distinct sourceTypeId as [Key], MementoId as Value from PaxolArchive.Common.Memento for xml path('KeyValueResult'), elements, type, root('KeyValueResultList')", new XmlRootAttribute("KeyValueResultList"));
				var remaining = mementos.Count;
				Console.WriteLine(remaining);
				mementos.ForEach(e =>
				{
					var queryy = "select * from PaxolArchive.Common.Memento where MementoId='" + e.Value + "';";
					var mems = reader.GetQueryData<MementoPersistenceDto>(queryy);
					mems.ForEach(m => filerepository.SaveArchiveJson(ArchiveTypes.Mementos.GetDbName(), ((EntityTypeEnum)e.Key).GetDbName() + "\\" + e.Value, m.Id.ToString(), m.Memento));
					
					remaining--;
				});
			}
			Console.WriteLine(DateTime.Now.TimeOfDay);

		}
		private static void FixRecurringCharges(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var readerservice = scope.Resolve<IReaderService>();
				var repository = scope.Resolve<IPayrollRepository>();


				var list = repository.GetRecurringChargeToUpdate();
				var list2 = new List<PayrollInvoice>();
				list.Select(l=>l.InvoiceId).Distinct().ToList().ForEach(l =>
				{
					var i = readerservice.GetPayrollInvoice(l);
					var l1 = list.Where(l2 => l2.InvoiceId == l).ToList();
					l1.ForEach(l2 =>
					{
						if (i.MiscCharges.Any(i1 => i1.RecurringChargeId == l2.RecurringChargeId))
						{
							var mc = i.MiscCharges.First(mc1 => mc1.RecurringChargeId == l2.RecurringChargeId);
							if(l2.NewRecurringChargeId>0)
								mc.RecurringChargeId = l2.NewRecurringChargeId;
							mc.PreviouslyClaimed = l2.Claimed;
							mc.Rate = l2.Rate;
						}
					});
					list2.Add(i);
				});
				//list.ForEach(l =>
				//{
				//	var i = readerservice.GetPayrollInvoice(l.InvoiceId);
					
				//	i.MiscCharges.First(mc => mc.RecurringChargeId == l.RecurringChargeId).RecurringChargeId = l.NewRecurringChargeId;
				//	list2.Add(i);
				//});
				repository.UpdateInvoiceMiscCharges(list2);
			}
			
		}
		private static void SaveRecurringChargeClaimed(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var readerservice = scope.Resolve<IReaderService>();
				var repository = scope.Resolve<IPayrollRepository>();
				
				var company = readerservice.GetCompanies().Where(c => c.Contract.InvoiceSetup.RecurringCharges.Any()).ToList();
				var list = new List<HrMaxx.OnlinePayroll.Models.InvoiceRecurringCharge>();
				company.ForEach(c =>
				{
					

					var invoices = readerservice.GetCompanyInvoices(companyId: c.Id).Where(i=>i.MiscCharges.Any(mc=>mc.RecurringChargeId>0)).ToList();
					invoices.ForEach(i => i.MiscCharges.Where(mc => mc.RecurringChargeId > 0).ToList().ForEach(mc =>
						list.Add(new InvoiceRecurringCharge
						{
							InvoiceId = i.Id, CompanyId=i.CompanyId, InvoiceNumber = i.InvoiceNumber, RecurringChargeId = mc.RecurringChargeId, Description = mc.Description, Rate = mc.Rate, Amount = mc.Amount, Claimed = mc.PreviouslyClaimed
						})));
					
					
				});
				repository.SaveInvoiceRecurringCharge(list);
			}

		}

		private static void SaveRecurringCharges(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var readerservice = scope.Resolve<IReaderService>();
				var companyrepository = scope.Resolve<ICompanyRepository>();
				var payrollrepository = scope.Resolve<IPayrollRepository>();
				var company = readerservice.GetCompanies().Where(c => c.Contract.InvoiceSetup.RecurringCharges.Any()).ToList();
				var invoiceUpdateList = new List<PayrollInvoice>();
				company.ForEach(c=>
				{
					var list = new List<HrMaxx.OnlinePayroll.Models.CompanyRecurringCharge>();
					
					var invoices = readerservice.GetCompanyInvoices(companyId: c.Id);
					var miscCharges = invoices.SelectMany(i => i.MiscCharges).ToList();
					c.Contract.InvoiceSetup.RecurringCharges.ForEach(rc => list.Add(new HrMaxx.OnlinePayroll.Models.CompanyRecurringCharge
					{
						Id = 0,
						CompanyId = c.Id,
						Year = rc.Year,
						Amount = rc.Amount,
						AnnualLimit = rc.AnnualLimit,
						Description = rc.Description,
						OldId = rc.Id,
						Claimed = miscCharges.Where(i => i.RecurringChargeId == rc.Id).Sum(i => i.Amount)
					}));
					var rcs = companyrepository.SaveRecurringCharges(c, list);
					c.Contract.InvoiceSetup.RecurringCharges.ForEach(rc =>
					{
						var rc1 = rcs.First(r => r.OldId == rc.Id);
						rc.TableId = rc1.Id;
					});
					companyrepository.SaveCompanyContract(c, c.Contract);
					invoices.Where(i=>i.MiscCharges.Any(mc=>rcs.Any(r=>r.OldId==mc.RecurringChargeId))).ToList().ForEach(i =>
					{
						i.MiscCharges.Where(mc=>mc.RecurringChargeId>0 && rcs.Any(r=>r.OldId==mc.RecurringChargeId)).ToList().ForEach(mc =>
						{
							mc.RecurringChargeId = rcs.First(r => r.OldId == mc.RecurringChargeId).Id;
						});
						invoiceUpdateList.Add(i);
					});
					
				});
				payrollrepository.UpdateInvoiceMiscCharges(invoiceUpdateList);
			}
		}

		private static void ChangeEmployeesToFiscalYear(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var companyservice = scope.Resolve<ICompanyService>();
				var payrollService = scope.Resolve<IPayrollService>();
				var readerservice = scope.Resolve<IReaderService>();

				//var compList = new List<Guid>();
				//compList.Add(new Guid("6B22F916-0E34-4DB0-BE20-A6ED01549D3E"));
				//compList.Add(new Guid("87AE8C84-2CEC-49F3-881D-A6F20019290B"));
				var payChecks = new List<int>();
				var company = readerservice.GetCompany(new Guid("307CFF5E-8BF6-47F7-AD03-A6ED014C1126"));
				var employees = readerservice.GetEmployees(company: company.Id);
				employees.ForEach(e =>
				{
					
					if (e.SickLeaveHireDate != e.HireDate || e.CarryOver>0)
					{
						e.SickLeaveHireDate = e.HireDate;
						e.CarryOver = 0;
						companyservice.SaveEmployee(e, false);
					}
					
					var paychecks = readerservice.GetEmployeePayChecks(e.Id);
					var checkCounter = (int)0;
					paychecks.Where(pc=>!pc.IsVoid).OrderBy(pc=>pc.Id).ToList().ForEach(pc =>
					{
						var employeeAccumulations = readerservice.GetAccumulations(company: e.CompanyId,startdate: new DateTime(pc.PayDay.Year, 1, 1), enddate: pc.PayDay, ssns: Crypto.Encrypt(e.SSN));
						pc.Employee.SickLeaveHireDate = e.SickLeaveHireDate;
						pc.Accumulations = ProcessAccumulations(pc, company.AccumulatedPayTypes, employeeAccumulations.First());
						pc.Accumulations.ForEach(ac=>ac.CarryOver=0);
						payrollService.UpdatePayCheckAccumulation(pc.Id, pc.Accumulations.First(), "System", Guid.Empty.ToString());
						checkCounter++;
					});
					Console.WriteLine(string.Format("Employee {0} - {1}", e.FullName, checkCounter));
				});
				


				Console.WriteLine("Finished");

			}
		}
		private static void FixMovedInvoices(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				
				var payrollRepository = scope.Resolve<IPayrollRepository>();
				var readerservice = scope.Resolve<IReaderService>();
				var companies = readerservice.GetCompanies();

                var list = new List<InvoiceFix>
                {
                    new InvoiceFix
                    {
                        Id = new Guid("5EFEE771-2392-485B-82E8-A6F20115EE75"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("1FF3CAEE-BD53-4E6B-9CEB-A6F600AC4752"),
                        SourceCompany = new Guid("3DC257CD-1179-472A-A190-A6ED01510C7B")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("73AC5B7F-973F-479A-B96E-A6F900E0E10F"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("A8A6BDEF-94D9-45DA-97E7-A6FD00B22F11"),
                        SourceCompany = new Guid("3DC257CD-1179-472A-A190-A6ED01510C7B")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("FE14DB98-4204-4548-BB6B-A70000EFAFAF"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("8F0356A0-A180-49A3-91F5-A70000F7D01E"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("CF7CAC0B-C82E-419A-83C6-A70100C2D2DE"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("B7542640-403B-4BE7-B8EA-A70700DF2782"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("1C93A7AE-1BDA-463C-9BD7-A70700EB0080"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("3212D259-5AAE-46BF-977A-A70B00AB2F70"),
                        SourceCompany = new Guid("3DC257CD-1179-472A-A190-A6ED01510C7B")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("0D8EBF95-D7A5-46F5-AFBD-A70E00CFF67F"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("ABF4DB33-4708-4324-882C-A71500CFAB3F"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("D5461A73-849C-41C2-9C35-A71500D12DEA"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("84206134-2437-494D-A310-A71900A86B73"),
                        SourceCompany = new Guid("3DC257CD-1179-472A-A190-A6ED01510C7B")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("93CCF940-C738-43D1-97B9-A71C00FD36AB"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("6F2CE812-131F-4162-A617-A71C01020E18"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("B68DB5F4-2F86-4652-85E9-A721009B0DAA"),
                        SourceCompany = new Guid("3DC257CD-1179-472A-A190-A6ED01510C7B")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("D5BC6B90-8625-4F0C-BCB9-A72300E62217"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("71CF527C-31C3-4831-9A66-A72700C58AB5"),
                        SourceCompany = new Guid("3DC257CD-1179-472A-A190-A6ED01510C7B")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("E816C9BE-2B5F-4720-A76F-A72B00CDB9CB"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("9BD5E224-7484-42AF-AD0A-A72E009FCB61"),
                        SourceCompany = new Guid("3DC257CD-1179-472A-A190-A6ED01510C7B")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("D67DEFCD-2311-4CCE-B3D9-A73200D5CA24"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("2FB984C3-BC24-4B76-8BEE-A73500A6ACA5"),
                        SourceCompany = new Guid("3DC257CD-1179-472A-A190-A6ED01510C7B")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("77AA8D08-4665-4132-95B9-A73500C8E9DD"),
                        SourceCompany = new Guid("3DC257CD-1179-472A-A190-A6ED01510C7B")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("EB89EA52-888D-476A-9072-A73900D8951D"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("AC755239-6138-401F-81BE-A73C00B6A5CF"),
                        SourceCompany = new Guid("3DC257CD-1179-472A-A190-A6ED01510C7B")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("B93D0A13-687B-4F39-BE37-A74000D32622"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("C2BCEE4F-AB9C-493A-A04D-A74300C60679"),
                        SourceCompany = new Guid("3DC257CD-1179-472A-A190-A6ED01510C7B")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("ACE0F807-25EC-4DF7-8A72-A74600B7E4AD"),
                        SourceCompany = new Guid("3DC257CD-1179-472A-A190-A6ED01510C7B")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("E344711C-F5B9-4543-9CF7-A74700977827"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("71854711-476C-4518-BD20-A74E00F0B37D"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("CE8AB069-4C7A-4923-A13B-A74E00F45286"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("5F7EDAFC-B2D5-4AF6-BA4C-A75500B3494C"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("BDEAE96D-BBAC-423A-AD8D-A75C00D9C0A9"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("361E2220-C9AC-45BE-A452-A76300CD898A"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("192EA7D7-A03A-4670-B946-A76A00C3DBD1"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("22DE7C01-7C6D-4430-909C-A77100B45C4C"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("2E0B0988-BBD0-4EB1-9C22-A77800B5BE32"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("3E28A3C6-ADFF-4260-8078-A77B00AB35A8"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("47696CE7-EB7E-467B-803E-A77E00BFEB6E"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("0E818E0D-C694-429C-BCAA-A78600B50359"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("A4BDE2B3-D14A-465F-938C-A78B00AAF6F6"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("1BBF1D36-CB41-402E-A24B-A79400B59F5C"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("01809F18-D52C-437D-BEB2-A79B00BF8DA2"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("2239F4C5-D6E2-4E9C-AF34-A7A200B205FC"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("114784D3-FA47-430E-8154-A7A700975179"),
                        SourceCompany = new Guid("3DC257CD-1179-472A-A190-A6ED01510C7B")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("D4115B6E-BF41-4D04-9E6F-A7A900B1096F"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("1A287465-FB83-48E6-8386-A7B000AFBDDD"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("B639F2F3-3A98-4B3A-B2BC-A7B700AFE391"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("3C390DE8-5557-478B-855C-A7BE00AE25D5"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("7AC3B65E-53C5-42C7-AD96-A7C500B89814"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("E7C9FB40-71DF-4E39-B194-A7CC00C2CD10"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("33EF301C-FD04-48BB-90ED-A7D3009267F4"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("65229EEC-A3E2-47FB-9FAA-A7DA00BBA6EA"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("B24EA969-688A-49E4-BF81-A7E100B1355B"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("B7A78412-028F-47FF-A739-A7E800C10AA7"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("1358128B-2994-4F51-BCDA-A7EF00C7B301"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("69D52E2F-FBF1-4025-90CB-A7EF00C82405"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("97B5ACA5-DC6B-4530-BCBC-A7F500A5C4BF"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("08217F25-0055-466B-9C23-A7F600BA94D6"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("C5BE47A9-722D-49DC-B6CC-A7FD00B58140"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("AD762749-82C9-4414-BF7B-A80000A1668D"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("067600AD-3270-4A6A-BDE8-A80400B2FE0B"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("C3BC3961-4BBD-4D00-BCF6-A80B00A9BCCF"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("65F95D21-FA00-4C0D-B3F9-A81000AE3F82"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("8F089358-0848-4E7F-B770-A81900A21AB0"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("37DA3132-E722-4ED4-A008-A82700895F6D"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("A3CF89FA-D9F9-4591-A7E4-A82E00D15AA3"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("D2E88E25-1B71-4418-BDF8-A831009B7D52"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    },
                    new InvoiceFix
                    {
                        Id = new Guid("DEC8C72A-E448-49D1-AC1C-A838009ED7E2"),
                        SourceCompany = new Guid("0974B66C-D453-4063-8D97-A6ED01597D89")
                    }
                };

                list.ForEach(p =>
				{
					var comp = companies.First(c => c.Id == p.SourceCompany);
					var i = readerservice.GetPayrollInvoice(p.Id);
					i.WorkerCompensations.ForEach(wc =>
					{
						wc.WorkerCompensation = comp.WorkerCompensations.First(wc1 => wc1.Code == wc.WorkerCompensation.Code);
					});
					payrollRepository.FixMovedInvoice(i.Id, comp.Id, JsonConvert.SerializeObject(i.WorkerCompensations));
				});

			}
		}
		private static void ChangeEmployeesToHourly(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var companyservice = scope.Resolve<ICompanyService>();
				var payrollService = scope.Resolve<IPayrollService>();
				var readerservice = scope.Resolve<IReaderService>();

                var compList = new List<Guid> {new Guid("9D18DA15-ACB4-4CE5-B6DF-A6ED015174DD")};
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

				//var compList = new List<Guid>();
				//compList.Add(new Guid("6B22F916-0E34-4DB0-BE20-A6ED01549D3E"));
				//compList.Add(new Guid("87AE8C84-2CEC-49F3-881D-A6F20019290B"));
				var payChecks = new List<int>();
				var counter = (int) 0;
				var employees = readerservice.GetEmployees();
				var payrolls = readerservice.GetPayrolls(null, startDate: new DateTime(2018, 1, 1).Date);
				
					payrolls.Where(p=>!p.IsHistory && p.Company.AccumulatedPayTypes.Any() && !p.Company.AccumulatedPayTypes.First().CompanyManaged).OrderBy(p=>p.PayDay).ToList().ForEach(p =>
					{
						var empList = employees.Where(e => p.PayChecks.Any(pc => pc.Employee.Id == e.Id)).ToList();
						var employeeAccumulations = readerservice.GetAccumulations(company: p.Company.Id,
						startdate: new DateTime(p.PayDay.Year, 1, 1), enddate: p.PayDay, ssns: empList.Select(pc => pc.SSN).Aggregate(string.Empty, (current, m) => current + Crypto.Encrypt(m) + ","));
						p.PayChecks.Where(pc => !pc.IsVoid).ToList().ForEach(pc =>
						{
							var ssns = empList.Select(e => e.SSN)
								.Aggregate(string.Empty, (current, m) => current + Crypto.Encrypt(m) + ",");
							var sl = pc.Accumulations.First(a => a.PayType.PayType.Id == 6);
							
							var employeeAccumulation = employeeAccumulations.First(e => e.EmployeeId.Value == pc.Employee.Id);
							if (employeeAccumulation.Accumulations.Any(a => a.PayTypeId == 6))
							{
								employeeAccumulation.Accumulations.First(a => a.PayTypeId == 6 && a.FiscalStart==sl.FiscalStart && a.FiscalEnd==sl.FiscalEnd).YTDFiscal -= sl.AccumulatedValue;
								employeeAccumulation.Accumulations.First(a => a.PayTypeId == 6 && a.FiscalStart == sl.FiscalStart && a.FiscalEnd == sl.FiscalEnd).YTDUsed -= sl.Used;
							}
							//pc.Employee = employees.First(e => e.Id == pc.Employee.Id);
							var accums = ProcessAccumulations(pc, p.Company.AccumulatedPayTypes,
								employeeAccumulation);
							var shouldbe = accums.First(a => a.PayType.PayType.Id == 6);

							if (shouldbe.Available != sl.Available)
							{
								Console.WriteLine(string.Format("{0}--{8}--{9}--{1}--{2}--{3}--{4}--{5}--{6}--{7}", pc.Id, pc.PayDay.ToString("MM/dd/yyyy"), sl.AccumulatedValue, shouldbe.AccumulatedValue, sl.YTDFiscal, shouldbe.YTDFiscal, sl.Available, shouldbe.Available, p.Company.Name, pc.Employee.FullName));
								sl = shouldbe;
								payrollService.UpdatePayCheckAccumulation(pc.Id, sl, "System", Guid.Empty.ToString());
								
								counter++;
							}
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
				list.Add(new EmpCarryOver { Empno = 1, Carryover = (decimal) 34.48 });
				list.Add(new EmpCarryOver { Empno = 4, Carryover = (decimal) 36.6 });
				list.Add(new EmpCarryOver { Empno = 7, Carryover = (decimal) 34.41 });
				list.Add(new EmpCarryOver { Empno = 8, Carryover = (decimal) 10.99 });
				list.Add(new EmpCarryOver { Empno = 10, Carryover = (decimal) 18.46 });
				list.Add(new EmpCarryOver { Empno = 11, Carryover = (decimal) 30.13 });
				list.Add(new EmpCarryOver { Empno = 12, Carryover = (decimal) 36.9 });
				list.Add(new EmpCarryOver { Empno = 13, Carryover = (decimal) 23.32 });
				list.Add(new EmpCarryOver { Empno = 14, Carryover = (decimal) 34.7 });
				list.Add(new EmpCarryOver { Empno = 16, Carryover = (decimal) 26.77 });
				list.Add(new EmpCarryOver { Empno = 17, Carryover = (decimal) 33.59 });
				list.Add(new EmpCarryOver { Empno = 18, Carryover = (decimal) 35.69 });
				list.Add(new EmpCarryOver { Empno = 20, Carryover = (decimal) 36.14 });
				list.Add(new EmpCarryOver { Empno = 21, Carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { Empno = 22, Carryover = (decimal) 23.39 });
				list.Add(new EmpCarryOver { Empno = 23, Carryover = (decimal) 17.5 });
				list.Add(new EmpCarryOver { Empno = 24, Carryover = (decimal) 21.01 });
				list.Add(new EmpCarryOver { Empno = 25, Carryover = (decimal) 35.81 });
				list.Add(new EmpCarryOver { Empno = 27, Carryover = (decimal) 35.31 });
				list.Add(new EmpCarryOver { Empno = 28, Carryover = (decimal) 31.48 });
				list.Add(new EmpCarryOver { Empno = 29, Carryover = (decimal) 34.46 });
				list.Add(new EmpCarryOver { Empno = 30, Carryover = (decimal) 31.85 });
				list.Add(new EmpCarryOver { Empno = 33, Carryover = (decimal) 13.07 });
				list.Add(new EmpCarryOver { Empno = 34, Carryover = (decimal) 38.39 });
				list.Add(new EmpCarryOver { Empno = 36, Carryover = (decimal) 37.29 });
				list.Add(new EmpCarryOver { Empno = 38, Carryover = (decimal) 9.15 });
				list.Add(new EmpCarryOver { Empno = 39, Carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { Empno = 40, Carryover = (decimal) 31.17 });
				list.Add(new EmpCarryOver { Empno = 41, Carryover = (decimal) 37.43 });
				list.Add(new EmpCarryOver { Empno = 43, Carryover = (decimal) 35.86 });
				list.Add(new EmpCarryOver { Empno = 44, Carryover = (decimal) 33.73 });
				list.Add(new EmpCarryOver { Empno = 47, Carryover = (decimal) 35.74 });
				list.Add(new EmpCarryOver { Empno = 48, Carryover = (decimal) 31.84 });
				list.Add(new EmpCarryOver { Empno = 52, Carryover = (decimal) 33.8 });
				list.Add(new EmpCarryOver { Empno = 53, Carryover = (decimal) 34.96 });
				list.Add(new EmpCarryOver { Empno = 57, Carryover = (decimal) 28.31 });
				list.Add(new EmpCarryOver { Empno = 58, Carryover = (decimal) 38.01 });
				list.Add(new EmpCarryOver { Empno = 59, Carryover = (decimal) 35.11 });
				list.Add(new EmpCarryOver { Empno = 62, Carryover = (decimal) 38.11 });
				list.Add(new EmpCarryOver { Empno = 63, Carryover = (decimal) 16.77 });
				list.Add(new EmpCarryOver { Empno = 66, Carryover = (decimal) 38.27 });
				list.Add(new EmpCarryOver { Empno = 67, Carryover = (decimal) 34.3 });
				list.Add(new EmpCarryOver { Empno = 68, Carryover = (decimal) 31.8 });
				list.Add(new EmpCarryOver { Empno = 69, Carryover = (decimal) 37.97 });
				list.Add(new EmpCarryOver { Empno = 72, Carryover = (decimal) 36.12 });
				list.Add(new EmpCarryOver { Empno = 73, Carryover = (decimal) 37.49 });
				list.Add(new EmpCarryOver { Empno = 74, Carryover = (decimal) 35.63 });
				list.Add(new EmpCarryOver { Empno = 76, Carryover = (decimal) 8.44 });
				list.Add(new EmpCarryOver { Empno = 77, Carryover = (decimal) 32.76 });
				list.Add(new EmpCarryOver { Empno = 79, Carryover = (decimal) 25.83 });
				list.Add(new EmpCarryOver { Empno = 81, Carryover = (decimal) 32.21 });
				list.Add(new EmpCarryOver { Empno = 82, Carryover = (decimal) 35.68 });
				list.Add(new EmpCarryOver { Empno = 84, Carryover = (decimal) 32.12 });
				list.Add(new EmpCarryOver { Empno = 85, Carryover = (decimal) 25.22 });
				list.Add(new EmpCarryOver { Empno = 86, Carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { Empno = 87, Carryover = (decimal) 35.42 });
				list.Add(new EmpCarryOver { Empno = 89, Carryover = (decimal) 31.8 });
				list.Add(new EmpCarryOver { Empno = 90, Carryover = (decimal) 27.99 });
				list.Add(new EmpCarryOver { Empno = 91, Carryover = (decimal) 20.63 });
				list.Add(new EmpCarryOver { Empno = 92, Carryover = (decimal) 29.02 });
				list.Add(new EmpCarryOver { Empno = 93, Carryover = (decimal) 22.6 });
				list.Add(new EmpCarryOver { Empno = 94, Carryover = (decimal) 27.84 });
				list.Add(new EmpCarryOver { Empno = 95, Carryover = (decimal) 27.1 });
				list.Add(new EmpCarryOver { Empno = 97, Carryover = (decimal) 20.9 });
				list.Add(new EmpCarryOver { Empno = 101, Carryover = (decimal) 35.42 });
				list.Add(new EmpCarryOver { Empno = 103, Carryover = (decimal) 32.5 });
				list.Add(new EmpCarryOver { Empno = 104, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 105, Carryover = (decimal) 32.5 });
				list.Add(new EmpCarryOver { Empno = 107, Carryover = (decimal) 21.68 });
				list.Add(new EmpCarryOver { Empno = 108, Carryover = (decimal) 34.76 });
				list.Add(new EmpCarryOver { Empno = 109, Carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { Empno = 110, Carryover = (decimal) 19.82 });
				list.Add(new EmpCarryOver { Empno = 111, Carryover = (decimal) 31.76 });
				list.Add(new EmpCarryOver { Empno = 113, Carryover = (decimal) 12.19 });
				list.Add(new EmpCarryOver { Empno = 114, Carryover = (decimal) 34.81 });
				list.Add(new EmpCarryOver { Empno = 115, Carryover = (decimal) 35.07 });
				list.Add(new EmpCarryOver { Empno = 117, Carryover = (decimal) 12 });
				list.Add(new EmpCarryOver { Empno = 119, Carryover = (decimal) 35.04 });
				list.Add(new EmpCarryOver { Empno = 121, Carryover = (decimal) 32.3 });
				list.Add(new EmpCarryOver { Empno = 122, Carryover = (decimal) 35.28 });
				list.Add(new EmpCarryOver { Empno = 124, Carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { Empno = 125, Carryover = (decimal) 34.09 });
				list.Add(new EmpCarryOver { Empno = 126, Carryover = (decimal) 35.95 });
				list.Add(new EmpCarryOver { Empno = 129, Carryover = (decimal) 31.93 });
				list.Add(new EmpCarryOver { Empno = 131, Carryover = (decimal) 36.54 });
				list.Add(new EmpCarryOver { Empno = 132, Carryover = (decimal) 32.74 });
				list.Add(new EmpCarryOver { Empno = 133, Carryover = (decimal) 35.08 });
				list.Add(new EmpCarryOver { Empno = 135, Carryover = (decimal) 34.46 });
				list.Add(new EmpCarryOver { Empno = 137, Carryover = (decimal) 37.55 });
				list.Add(new EmpCarryOver { Empno = 138, Carryover = (decimal) 34 });
				list.Add(new EmpCarryOver { Empno = 139, Carryover = (decimal) 36.4 });
				list.Add(new EmpCarryOver { Empno = 140, Carryover = (decimal) 38.44 });
				list.Add(new EmpCarryOver { Empno = 141, Carryover = (decimal) 33.34 });
				list.Add(new EmpCarryOver { Empno = 142, Carryover = (decimal) 30.24 });
				list.Add(new EmpCarryOver { Empno = 143, Carryover = (decimal) 34.98 });
				list.Add(new EmpCarryOver { Empno = 146, Carryover = (decimal) 9.57 });
				list.Add(new EmpCarryOver { Empno = 147, Carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { Empno = 151, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 152, Carryover = (decimal) 24.8 });
				list.Add(new EmpCarryOver { Empno = 160, Carryover = (decimal) 32.93 });
				list.Add(new EmpCarryOver { Empno = 161, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 163, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 165, Carryover = (decimal) 8 });
				list.Add(new EmpCarryOver { Empno = 166, Carryover = (decimal) 12.59 });
				list.Add(new EmpCarryOver { Empno = 168, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 171, Carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { Empno = 172, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 177, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 180, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 181, Carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { Empno = 183, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 184, Carryover = (decimal) 10.53 });
				list.Add(new EmpCarryOver { Empno = 185, Carryover = (decimal) 8 });
				list.Add(new EmpCarryOver { Empno = 186, Carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { Empno = 187, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 191, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 194, Carryover = (decimal) 8 });
				list.Add(new EmpCarryOver { Empno = 197, Carryover = (decimal) 16 });
				list.Add(new EmpCarryOver { Empno = 198, Carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { Empno = 199, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 201, Carryover = (decimal) 16 });
				list.Add(new EmpCarryOver { Empno = 202, Carryover = (decimal) 7.01 });
				list.Add(new EmpCarryOver { Empno = 204, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 206, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 209, Carryover = (decimal) 14.59 });
				list.Add(new EmpCarryOver { Empno = 213, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 215, Carryover = (decimal) 7.06 });
				list.Add(new EmpCarryOver { Empno = 217, Carryover = (decimal) 16 });
				list.Add(new EmpCarryOver { Empno = 219, Carryover = (decimal) 0 });
				list.Add(new EmpCarryOver { Empno = 220, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 222, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 225, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 227, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 231, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 232, Carryover = (decimal) 14.73 });
				list.Add(new EmpCarryOver { Empno = 233, Carryover = (decimal) 2.49 });
				list.Add(new EmpCarryOver { Empno = 234, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 235, Carryover = (decimal) 21.2 });
				list.Add(new EmpCarryOver { Empno = 238, Carryover = (decimal) 20.08 });
				list.Add(new EmpCarryOver { Empno = 239, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 240, Carryover = (decimal) 24 });
				list.Add(new EmpCarryOver { Empno = 241, Carryover = (decimal) 22.66 });
				list.Add(new EmpCarryOver { Empno = 242, Carryover = (decimal) 17.23 });
				list.Add(new EmpCarryOver { Empno = 243, Carryover = (decimal) 17.5 });
				list.Add(new EmpCarryOver { Empno = 245, Carryover = (decimal) 15 });
				list.Add(new EmpCarryOver { Empno = 246, Carryover = (decimal) 19.9 });
				list.Add(new EmpCarryOver { Empno = 247, Carryover = (decimal) 15.17 });
				list.Add(new EmpCarryOver { Empno = 252, Carryover = (decimal) 7.89 });
				list.Add(new EmpCarryOver { Empno = 254, Carryover = (decimal) 7.43 });
				list.Add(new EmpCarryOver { Empno = 256, Carryover = (decimal) 6.36 });
				list.Add(new EmpCarryOver { Empno = 258, Carryover = (decimal) 5.35 });
				list.Add(new EmpCarryOver { Empno = 260, Carryover = (decimal) 4.11 });
				list.Add(new EmpCarryOver { Empno = 262, Carryover = (decimal) 3.1 });
				list.Add(new EmpCarryOver { Empno = 263, Carryover = (decimal) 3.23 });
				list.Add(new EmpCarryOver { Empno = 265, Carryover = (decimal) 3.21 });
				list.Add(new EmpCarryOver { Empno = 268, Carryover = (decimal) 0.95 });
				#endregion

				var ud = new Guid("6B22F916-0E34-4DB0-BE20-A6ED01549D3E");
				var ud2 = new Guid("87AE8C84-2CEC-49F3-881D-A6F20019290B");
				var udemployees = readerservice.GetEmployees(company: ud);
				var ud2Employees = readerservice.GetEmployees(company: ud2);
				udemployees = udemployees.Where(e => list.Any(e1 => e1.Empno == e.CompanyEmployeeNo)).ToList();
				var ssns = udemployees.Select(e => e.SSN).Aggregate(string.Empty, (current, m) => current + Crypto.Encrypt(m) + ",");
				var udaccumulations = readerservice.GetAccumulations(company: ud, startdate: new DateTime(2017, 1, 1).Date,
					enddate: new DateTime(2017,8,27).Date, ssns: ssns);
				var ud2Accumulations = readerservice.GetAccumulations(company: ud2, startdate: new DateTime(2017, 1, 1).Date,
					enddate: new DateTime(2017, 8, 27).Date, ssns: ssns);
				var noupdate = (int)0;
				var update = (int) 0;
				var ud2Match = (int)0;
				var ud2Update = (int)0;
				var ud2Noupdate = (int)0;
				list.ForEach(e =>
				{
					var e1 = udemployees.First(e2 => e2.CompanyEmployeeNo == e.Empno);
					var ud2E = ud2Employees.FirstOrDefault(e2 => e2.SSN == e1.SSN && e2.CompanyEmployeeNo == e1.CompanyEmployeeNo);
					if (e1.CarryOver != e.Carryover)
					{
						e1.CarryOver = e.Carryover;
						var acc = udaccumulations.First(e2 => e2.EmployeeId == e1.Id);
						if (acc.Accumulations.Count == 1)
						{
							var sl = acc.Accumulations.First();
							sl.CarryOver = e.Carryover;
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
					if(ud2E != null && ud2E.CarryOver!=e.Carryover)
					{
						ud2Match++;
						ud2E.CarryOver = e.Carryover;
						var acc = ud2Accumulations.First(e2 => e2.EmployeeId == ud2E.Id);
						if (acc.Accumulations.Count == 1)
						{
							var sl = acc.Accumulations.First();
							sl.CarryOver = e.Carryover;
							payrollService.UpdateEmployeeAccumulation(sl, sl.FiscalStart, sl.FiscalEnd, e1.Id);
							ud2Update++;

						}
						else
						{
							ud2Noupdate++;
						}
						ud2E.UserName = "System";
						companyservice.SaveEmployee(ud2E, false);
					}
					
				});
				Console.WriteLine("Total: {0}", list.Count);
				Console.WriteLine("Update: {0}", update);
				Console.WriteLine("No Update: {0}", noupdate);
				Console.WriteLine("Total: {0}", ud2Match);
				Console.WriteLine("Update: {0}", ud2Update);
				Console.WriteLine("No Update: {0}", ud2Noupdate);

			}
		}

		private static void SeparateInvoiceTaxesDelayed(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var readerService = scope.Resolve<IReaderService>();
				var payrollService = scope.Resolve<IPayrollService>();
				var companyRepository = scope.Resolve<ICompanyRepository>();

				var invoices = readerService.GetPayrollInvoices(status: new List<InvoiceStatus> { InvoiceStatus.OnHold }, paymentStatuses: new List<PaymentStatus>(), paymentMethods: new List<InvoicePaymentMethod>());	
				invoices.ForEach(i =>
				{
					i.Status = InvoiceStatus.Delivered;
					i.TaxesDelayed = true;
					var i1 = payrollService.SavePayrollInvoice(i);
					Console.WriteLine("New Status {0}", i1.Status.GetDbName());
				});
			
			}
		}


		private static void FixAccumulationCycleAndYtd(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var readerService = scope.Resolve<IReaderService>();
				var payrollRepository = scope.Resolve<IPayrollRepository>();
				var companyRepository = scope.Resolve<ICompanyRepository>();

				var payCheckList = new List<PayCheck>();
				var empList = new List<HrMaxx.OnlinePayroll.Models.Employee>();
                var leaveCycleEmployees = new List<LeaveCycleEmployee>
                {
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("979CF583-4796-496F-A414-A6ED0156EBFB"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("227DCBC0-2C8E-4116-9A4C-A6FA00B1688D"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("887F0FC6-B720-4AE2-A8CA-A6ED01536FC7"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("C8225E66-9FB6-408E-AB75-A6ED01537062"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("F4B84B3A-536E-4C0F-B23A-A75B00A6310A"),
                        OldFiscalStart = new DateTime(2017, 4, 21),
                        NewFiscalStart = new DateTime(2017, 4, 20)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("B86121A9-C69A-4E0C-BDA6-A75B00A8403C"),
                        OldFiscalStart = new DateTime(2017, 4, 21),
                        NewFiscalStart = new DateTime(2017, 4, 20)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("4245E431-73EB-4A93-975C-A76F009B41A7"),
                        OldFiscalStart = new DateTime(2017, 5, 11),
                        NewFiscalStart = new DateTime(2017, 5, 10)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("F842C501-FE89-4EF4-9731-A76F009CF259"),
                        OldFiscalStart = new DateTime(2017, 5, 11),
                        NewFiscalStart = new DateTime(2017, 5, 10)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("94C36C7B-8EF3-419C-AD04-A73100B59254"),
                        OldFiscalStart = new DateTime(2017, 3, 10),
                        NewFiscalStart = new DateTime(2017, 3, 9)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("CFA22B90-2206-4C32-A234-A777009C156C"),
                        OldFiscalStart = new DateTime(2017, 5, 19),
                        NewFiscalStart = new DateTime(2017, 5, 18)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("D0855437-8643-4E50-AA93-A784009A597B"),
                        OldFiscalStart = new DateTime(2017, 6, 1),
                        NewFiscalStart = new DateTime(2017, 5, 31)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("89762729-1560-4A73-8A27-A6ED01579909"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("66D0F241-FFD0-487D-8AC1-A70700E42FA5"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("9105FD21-4EF7-4877-A3B7-A72300879337"),
                        OldFiscalStart = new DateTime(2017, 2, 24),
                        NewFiscalStart = new DateTime(2017, 2, 23)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("415ED0BF-8BFF-4C1A-8732-A72300890B3B"),
                        OldFiscalStart = new DateTime(2017, 2, 24),
                        NewFiscalStart = new DateTime(2017, 2, 23)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("CD16FF42-2439-49E4-817C-A73700FB1B9D"),
                        OldFiscalStart = new DateTime(2017, 3, 16),
                        NewFiscalStart = new DateTime(2017, 3, 15)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("717E808E-E60D-4FED-A95E-A73700FCB2FF"),
                        OldFiscalStart = new DateTime(2017, 3, 16),
                        NewFiscalStart = new DateTime(2017, 3, 15)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("C7AA35AA-5549-40F2-A34A-A73700FE71C9"),
                        OldFiscalStart = new DateTime(2017, 3, 16),
                        NewFiscalStart = new DateTime(2017, 3, 15)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("BAEE375C-F54E-4B09-877C-A73E0105EC72"),
                        OldFiscalStart = new DateTime(2017, 3, 23),
                        NewFiscalStart = new DateTime(2017, 3, 22)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("4B303004-3B13-4C3B-AAFE-A74D00E74319"),
                        OldFiscalStart = new DateTime(2017, 4, 7),
                        NewFiscalStart = new DateTime(2017, 4, 6)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("C65C5E51-B298-4AE9-A04A-A6ED0152A55E"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("EBA50AEA-511A-4439-8BB4-A6ED0152A5E1"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("E06C5FED-E33F-42A0-B863-A70800C79529"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("95EF384F-3863-4096-8868-A75500C1ABAD"),
                        OldFiscalStart = new DateTime(2017, 4, 15),
                        NewFiscalStart = new DateTime(2017, 4, 14)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("F0CA2BA2-0230-41B0-9F9D-A76300C009A9"),
                        OldFiscalStart = new DateTime(2017, 4, 29),
                        NewFiscalStart = new DateTime(2017, 4, 28)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("855D176A-A6A2-4F02-A8C7-A76A00C45630"),
                        OldFiscalStart = new DateTime(2017, 5, 6),
                        NewFiscalStart = new DateTime(2017, 5, 5)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("052A360E-3926-439A-9C5E-A76D00CAC32C"),
                        OldFiscalStart = new DateTime(2017, 5, 9),
                        NewFiscalStart = new DateTime(2017, 5, 8)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("FF127E53-CD60-4A8C-9370-A77500BDFD37"),
                        OldFiscalStart = new DateTime(2017, 5, 17),
                        NewFiscalStart = new DateTime(2017, 5, 16)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("F7B77F52-7C04-4563-9CCC-A77500BE97E3"),
                        OldFiscalStart = new DateTime(2017, 5, 17),
                        NewFiscalStart = new DateTime(2017, 5, 16)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("DFCFBD0E-5BB2-444A-B19F-A77500BF54A6"),
                        OldFiscalStart = new DateTime(2017, 5, 17),
                        NewFiscalStart = new DateTime(2017, 5, 16)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("0E80A5B5-9F6A-4FA0-A691-A77E00FCF11D"),
                        OldFiscalStart = new DateTime(2017, 5, 26),
                        NewFiscalStart = new DateTime(2017, 5, 25)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("0504755A-4246-4D44-8206-A70F00A09A2B"),
                        OldFiscalStart = new DateTime(2017, 2, 24),
                        NewFiscalStart = new DateTime(2017, 2, 23)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("170C8802-BCC8-4675-99F1-A70F00A5B303"),
                        OldFiscalStart = new DateTime(2017, 2, 24),
                        NewFiscalStart = new DateTime(2017, 2, 23)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("9E927320-ACCD-41AE-85BA-A71300D76550"),
                        OldFiscalStart = new DateTime(2017, 2, 8),
                        NewFiscalStart = new DateTime(2017, 2, 7)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("153C9CD4-CA57-4F8E-9BF8-A71600C61B84"),
                        OldFiscalStart = new DateTime(2017, 2, 11),
                        NewFiscalStart = new DateTime(2017, 2, 10)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("97665A9E-8EFE-4F13-A3E8-A73700D4B525"),
                        OldFiscalStart = new DateTime(2017, 3, 16),
                        NewFiscalStart = new DateTime(2017, 3, 15)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("CAA5D056-B313-4DAC-8F98-A73F00C22A3A"),
                        OldFiscalStart = new DateTime(2017, 3, 24),
                        NewFiscalStart = new DateTime(2017, 3, 23)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("3A9031F8-8223-4384-A5E2-A73F00CC784F"),
                        OldFiscalStart = new DateTime(2017, 3, 24),
                        NewFiscalStart = new DateTime(2017, 3, 23)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("7908685D-606D-49D1-B952-A75B00A57BAC"),
                        OldFiscalStart = new DateTime(2017, 4, 21),
                        NewFiscalStart = new DateTime(2017, 4, 20)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("91A09021-11D2-4568-A8F9-A76800AD9D02"),
                        OldFiscalStart = new DateTime(2017, 5, 4),
                        NewFiscalStart = new DateTime(2017, 5, 3)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("0504755A-4246-4D44-8206-A70F00A09A2B"),
                        OldFiscalStart = new DateTime(2017, 2, 4),
                        NewFiscalStart = new DateTime(2017, 2, 3)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("170C8802-BCC8-4675-99F1-A70F00A5B303"),
                        OldFiscalStart = new DateTime(2017, 2, 4),
                        NewFiscalStart = new DateTime(2017, 2, 3)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("B02EF90E-F8EB-4C19-B4CE-A77D00B4357C"),
                        OldFiscalStart = new DateTime(2017, 5, 25),
                        NewFiscalStart = new DateTime(2017, 5, 24)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("C91414C0-302F-4B4D-B14B-6AD98BE4AA0C"),
                        OldFiscalStart = new DateTime(2017, 3, 30),
                        NewFiscalStart = new DateTime(2017, 3, 29)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("370D3D17-0101-4D37-A523-AD91FCB4D605"),
                        OldFiscalStart = new DateTime(2017, 2, 16),
                        NewFiscalStart = new DateTime(2017, 2, 15)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("B569C675-3ABA-4B98-A9BC-A6F300A2B232"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("EF37F268-36D0-450E-A01B-A75300BE35FB"),
                        OldFiscalStart = new DateTime(2017, 4, 13),
                        NewFiscalStart = new DateTime(2017, 4, 12)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("FACB2B60-D3B9-47B6-BFEE-A73900B728DB"),
                        OldFiscalStart = new DateTime(2017, 3, 18),
                        NewFiscalStart = new DateTime(2017, 3, 17)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("B596133B-5527-4FFC-B9C3-A70F00B41811"),
                        OldFiscalStart = new DateTime(2017, 2, 4),
                        NewFiscalStart = new DateTime(2017, 2, 3)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("C090DB1C-8006-4F9A-B8BB-A73900B777FB"),
                        OldFiscalStart = new DateTime(2017, 3, 18),
                        NewFiscalStart = new DateTime(2017, 3, 17)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("F463F9AC-E9C2-4075-81D3-A73700BEAA6A"),
                        OldFiscalStart = new DateTime(2017, 3, 16),
                        NewFiscalStart = new DateTime(2017, 3, 15)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("C3C12366-63F0-4C00-83E6-A70F00AC7051"),
                        OldFiscalStart = new DateTime(2017, 2, 4),
                        NewFiscalStart = new DateTime(2017, 2, 3)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("6493EE1E-DA0E-4DE1-B1B4-A72200A07E28"),
                        OldFiscalStart = new DateTime(2017, 2, 23),
                        NewFiscalStart = new DateTime(2017, 2, 22)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("4564AC4D-53CF-4F08-AB11-A72200A10F69"),
                        OldFiscalStart = new DateTime(2017, 2, 23),
                        NewFiscalStart = new DateTime(2017, 2, 22)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("DF20DC67-F205-4BFE-B127-A74400B2F2DC"),
                        OldFiscalStart = new DateTime(2017, 3, 29),
                        NewFiscalStart = new DateTime(2017, 3, 28)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("902786B7-04CD-4635-A83A-A77C00BFF83B"),
                        OldFiscalStart = new DateTime(2017, 5, 24),
                        NewFiscalStart = new DateTime(2017, 5, 23)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("96CCE43E-1581-4DFC-A404-A6ED014ECE97"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("0ABFC7EF-468D-44CF-8B44-A6ED014ED45B"),
                        OldFiscalStart = new DateTime(2017, 1, 3),
                        NewFiscalStart = new DateTime(2017, 1, 2)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("0ABFC7EF-468D-44CF-8B44-A6ED014ED45B"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("7A9C47C6-A53F-4526-BA3A-A72300CDFA74"),
                        OldFiscalStart = new DateTime(2017, 2, 24),
                        NewFiscalStart = new DateTime(2017, 2, 23)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("A76BF856-4568-4204-A639-A72800BA47FE"),
                        OldFiscalStart = new DateTime(2017, 3, 1),
                        NewFiscalStart = new DateTime(2017, 2, 28)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("E19F3385-27A4-46EA-975E-A72800BADD34"),
                        OldFiscalStart = new DateTime(2017, 3, 1),
                        NewFiscalStart = new DateTime(2017, 2, 28)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("C9764B07-E85A-4E95-9C27-A72800BBBB92"),
                        OldFiscalStart = new DateTime(2017, 3, 1),
                        NewFiscalStart = new DateTime(2017, 2, 28)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("E2AAAF0B-0154-4B54-BCD9-A77B00B6FE18"),
                        OldFiscalStart = new DateTime(2017, 5, 23),
                        NewFiscalStart = new DateTime(2017, 5, 22)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("F4212E23-14CE-40FD-A910-A6ED01596803"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("60E6F47B-6383-4803-9A1F-A6ED0159688B"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("3A0AD396-868A-49D5-9BEE-A73700CA0876"),
                        OldFiscalStart = new DateTime(2017, 3, 16),
                        NewFiscalStart = new DateTime(2017, 3, 15)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("73017F37-6E1F-4FA0-B85E-A76D00B218E8"),
                        OldFiscalStart = new DateTime(2017, 5, 9),
                        NewFiscalStart = new DateTime(2017, 5, 8)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("D7961F8F-1B45-49F2-AD0B-A6ED0158C337"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("9CCCBB53-5264-4832-942F-A70D00BC67C9"),
                        OldFiscalStart = new DateTime(2017, 2, 2),
                        NewFiscalStart = new DateTime(2017, 2, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("FB976F09-085F-4C07-B425-A74B00B00B95"),
                        OldFiscalStart = new DateTime(2017, 4, 5),
                        NewFiscalStart = new DateTime(2017, 4, 4)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("19CAC5C4-6961-439C-925A-A77500A52117"),
                        OldFiscalStart = new DateTime(2017, 5, 17),
                        NewFiscalStart = new DateTime(2017, 5, 16)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("2FD88FDC-3CAA-48D8-8708-A73500B38578"),
                        OldFiscalStart = new DateTime(2017, 3, 14),
                        NewFiscalStart = new DateTime(2017, 3, 13)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("A757BD06-4B4D-4253-9AEF-A70F00C55707"),
                        OldFiscalStart = new DateTime(2017, 2, 5),
                        NewFiscalStart = new DateTime(2017, 2, 4)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("09A7BB5A-4480-4907-9D54-A77400B68DE3"),
                        OldFiscalStart = new DateTime(2017, 5, 16),
                        NewFiscalStart = new DateTime(2017, 5, 15)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("F3FE723E-6FB2-41AE-8685-A75800A61E9B"),
                        OldFiscalStart = new DateTime(2017, 4, 18),
                        NewFiscalStart = new DateTime(2017, 4, 17)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("77056273-94E3-45BE-96EA-A76E009D7FC2"),
                        OldFiscalStart = new DateTime(2017, 5, 10),
                        NewFiscalStart = new DateTime(2017, 5, 9)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("59015FD0-B437-4FD1-82C9-A72A00F53D2E"),
                        OldFiscalStart = new DateTime(2017, 3, 3),
                        NewFiscalStart = new DateTime(2017, 3, 2)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("841C34DA-3059-40B7-B2B5-A74400B7DDF1"),
                        OldFiscalStart = new DateTime(2017, 3, 29),
                        NewFiscalStart = new DateTime(2017, 3, 28)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("8A8E4A5A-3F5A-4C7A-AB69-A74400B96A85"),
                        OldFiscalStart = new DateTime(2017, 3, 29),
                        NewFiscalStart = new DateTime(2017, 3, 28)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("D4D9FA54-3990-4884-8AF2-A74400BBBA81"),
                        OldFiscalStart = new DateTime(2017, 3, 29),
                        NewFiscalStart = new DateTime(2017, 3, 28)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("2703B5B0-9EE0-47F9-9ADA-A74E00A29D05"),
                        OldFiscalStart = new DateTime(2017, 4, 8),
                        NewFiscalStart = new DateTime(2017, 4, 7)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("72760DA1-EF67-48BD-8B47-A74E00A3CFA1"),
                        OldFiscalStart = new DateTime(2017, 4, 8),
                        NewFiscalStart = new DateTime(2017, 4, 7)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("093A37DE-BB81-4B96-8E0D-A74E00A50ED0"),
                        OldFiscalStart = new DateTime(2017, 4, 8),
                        NewFiscalStart = new DateTime(2017, 4, 7)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("F42A232B-42E4-498D-B876-A75300AA7175"),
                        OldFiscalStart = new DateTime(2017, 4, 13),
                        NewFiscalStart = new DateTime(2017, 4, 12)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("E9CB7D56-E2D7-4152-B6CF-C10838928999"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("A49B5E5D-D8A9-481E-887C-8B0AFC0CEE6B"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("6E3F724B-4DD2-43A0-BC95-A71C00BE32C8"),
                        OldFiscalStart = new DateTime(2017, 2, 17),
                        NewFiscalStart = new DateTime(2017, 2, 16)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("5134A09A-AA3A-4E57-B3A1-A71C00BF1833"),
                        OldFiscalStart = new DateTime(2017, 2, 17),
                        NewFiscalStart = new DateTime(2017, 2, 16)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("20C78637-7495-4C04-B0AC-A6ED014DB432"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("0675E56F-D18F-483C-8BEF-A6ED014F1E20"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("4A5E1F6F-6194-467C-8B24-A73100D80D8B"),
                        OldFiscalStart = new DateTime(2017, 3, 10),
                        NewFiscalStart = new DateTime(2017, 3, 9)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("0273CCF5-8DE0-4836-9FBE-A77700B2B7FE"),
                        OldFiscalStart = new DateTime(2017, 5, 19),
                        NewFiscalStart = new DateTime(2017, 5, 18)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("64F5E859-591A-417B-9A0D-A77D00CCF102"),
                        OldFiscalStart = new DateTime(2017, 5, 25),
                        NewFiscalStart = new DateTime(2017, 5, 24)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("08E7DE3E-C496-4FAC-A557-A6ED015635C6"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("3CBE1010-3837-46B7-B6A6-A77E00AD75B4"),
                        OldFiscalStart = new DateTime(2017, 5, 26),
                        NewFiscalStart = new DateTime(2017, 5, 25)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("F1FA9B13-4B02-417F-9077-A74C00A3BFC9"),
                        OldFiscalStart = new DateTime(2017, 4, 6),
                        NewFiscalStart = new DateTime(2017, 4, 5)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("9AC07F4B-7184-4E3C-AA09-A71300C10A71"),
                        OldFiscalStart = new DateTime(2017, 2, 8),
                        NewFiscalStart = new DateTime(2017, 2, 7)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("728EC1A4-2277-4669-ADAF-A74300BF52CC"),
                        OldFiscalStart = new DateTime(2017, 3, 28),
                        NewFiscalStart = new DateTime(2017, 3, 27)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("90794DF7-56E7-4C4C-A782-A72900B0004F"),
                        OldFiscalStart = new DateTime(2017, 3, 2),
                        NewFiscalStart = new DateTime(2017, 3, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("28E9AA5F-84F5-4C73-9471-A72900B099CC"),
                        OldFiscalStart = new DateTime(2017, 3, 3),
                        NewFiscalStart = new DateTime(2017, 3, 2)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("807E3E79-5691-441F-9C54-A72900B1906A"),
                        OldFiscalStart = new DateTime(2017, 3, 2),
                        NewFiscalStart = new DateTime(2017, 3, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("A1D5CDA1-5B5F-4FDD-9D68-A6FA00BB854E"),
                        OldFiscalStart = new DateTime(2017, 2, 9),
                        NewFiscalStart = new DateTime(2017, 2, 8)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("B1028404-E822-4925-A865-A6ED01524532"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("CE258729-392D-48A2-8110-A72400B29037"),
                        OldFiscalStart = new DateTime(2017, 2, 25),
                        NewFiscalStart = new DateTime(2017, 2, 24)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("AAF9DDD5-DF66-4DFF-BD04-A72400B33650"),
                        OldFiscalStart = new DateTime(2017, 2, 25),
                        NewFiscalStart = new DateTime(2017, 2, 24)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("5160D8D7-E506-4160-9A9B-A72400B389EF"),
                        OldFiscalStart = new DateTime(2017, 2, 25),
                        NewFiscalStart = new DateTime(2017, 2, 24)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("05D86BC8-193C-496E-8CC0-A747009FE4DE"),
                        OldFiscalStart = new DateTime(2017, 4, 1),
                        NewFiscalStart = new DateTime(2017, 3, 31)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("50CC6F76-0C4F-444C-814E-A74700A05533"),
                        OldFiscalStart = new DateTime(2017, 4, 1),
                        NewFiscalStart = new DateTime(2017, 3, 31)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("3273C719-D9A1-4A44-A0B3-A6ED01561671"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("AC4A3AFE-0032-4D32-BEF1-A78C00AD9C18"),
                        OldFiscalStart = new DateTime(2017, 6, 9),
                        NewFiscalStart = new DateTime(2017, 6, 8)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("6C446D0D-990F-444F-9189-A73600C2C223"),
                        OldFiscalStart = new DateTime(2017, 3, 15),
                        NewFiscalStart = new DateTime(2017, 3, 14)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("A118DE32-D1B8-40E4-B898-A73800AA2E11"),
                        OldFiscalStart = new DateTime(2017, 3, 17),
                        NewFiscalStart = new DateTime(2017, 3, 16)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("8A7D3E12-DE70-4CF1-803D-A6ED014E6F56"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("604F8D61-D5DC-4CCE-AE76-A77C00A73854"),
                        OldFiscalStart = new DateTime(2017, 5, 24),
                        NewFiscalStart = new DateTime(2017, 5, 23)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("90661B59-5FF9-4AB2-9CDC-A78300BC6EAD"),
                        OldFiscalStart = new DateTime(2017, 5, 31),
                        NewFiscalStart = new DateTime(2017, 5, 30)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("3EC6A9CE-BCF8-48AF-B793-A70100D15BFF"),
                        OldFiscalStart = new DateTime(2017, 1, 21),
                        NewFiscalStart = new DateTime(2017, 1, 20)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("EA782E25-EB42-4EFB-98D3-A740009AAE57"),
                        OldFiscalStart = new DateTime(2017, 3, 25),
                        NewFiscalStart = new DateTime(2017, 3, 24)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("EA782E25-EB42-4EFB-98D3-A740009AAE57"),
                        OldFiscalStart = new DateTime(2017, 3, 26),
                        NewFiscalStart = new DateTime(2017, 3, 25)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("E0BD5273-49BF-43D9-B8D2-A740009B05A6"),
                        OldFiscalStart = new DateTime(2017, 3, 25),
                        NewFiscalStart = new DateTime(2017, 3, 24)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("E0BD5273-49BF-43D9-B8D2-A740009B05A6"),
                        OldFiscalStart = new DateTime(2017, 3, 26),
                        NewFiscalStart = new DateTime(2017, 3, 25)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("EC11947E-C1C8-4298-BD28-A6F900AC51F9"),
                        OldFiscalStart = new DateTime(2016, 7, 8),
                        NewFiscalStart = new DateTime(2016, 7, 7)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("4018353B-99BE-47BE-B12F-A74C00F77FCB"),
                        OldFiscalStart = new DateTime(2017, 4, 6),
                        NewFiscalStart = new DateTime(2017, 4, 5)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("6B81C4C4-1497-4FB2-9DE4-A74500A75BBE"),
                        OldFiscalStart = new DateTime(2017, 3, 30),
                        NewFiscalStart = new DateTime(2017, 3, 29)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("651C753F-8472-4E77-BE5D-A74500A7FD14"),
                        OldFiscalStart = new DateTime(2017, 3, 30),
                        NewFiscalStart = new DateTime(2017, 3, 29)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("676E335C-BE39-4B3B-98EA-A74500A9AB58"),
                        OldFiscalStart = new DateTime(2017, 3, 30),
                        NewFiscalStart = new DateTime(2017, 3, 29)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("CDBAD246-53CE-40F1-B494-A74500AA4766"),
                        OldFiscalStart = new DateTime(2017, 3, 30),
                        NewFiscalStart = new DateTime(2017, 3, 29)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("BCA5CC20-DC37-4857-932C-A72800F8329F"),
                        OldFiscalStart = new DateTime(2017, 3, 2),
                        NewFiscalStart = new DateTime(2017, 3, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("9CD6606E-E9D7-428C-9CB4-A76200B5DFF9"),
                        OldFiscalStart = new DateTime(2017, 4, 28),
                        NewFiscalStart = new DateTime(2017, 4, 27)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("A34CD49B-2BBE-4437-A82D-A75C00AA5AFE"),
                        OldFiscalStart = new DateTime(2017, 4, 22),
                        NewFiscalStart = new DateTime(2017, 4, 21)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("0085887D-F732-4021-8D84-A75C00BF76CC"),
                        OldFiscalStart = new DateTime(2017, 4, 22),
                        NewFiscalStart = new DateTime(2017, 4, 21)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("11D08777-A636-42D6-BB57-A74C00C31D25"),
                        OldFiscalStart = new DateTime(2017, 4, 6),
                        NewFiscalStart = new DateTime(2017, 4, 5)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("A71740E1-96A0-4251-BA64-A74C00C3EB38"),
                        OldFiscalStart = new DateTime(2017, 4, 6),
                        NewFiscalStart = new DateTime(2017, 4, 5)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("6EA89209-BBBA-48B1-A9E4-A74C00C43F7C"),
                        OldFiscalStart = new DateTime(2017, 4, 6),
                        NewFiscalStart = new DateTime(2017, 4, 5)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("8DC86F1D-D1E9-4C12-8A52-A74C00C49123"),
                        OldFiscalStart = new DateTime(2017, 4, 6),
                        NewFiscalStart = new DateTime(2017, 4, 5)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("A2786CC0-2C77-4184-A865-A74C00C50EAF"),
                        OldFiscalStart = new DateTime(2017, 4, 6),
                        NewFiscalStart = new DateTime(2017, 4, 5)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("33F9CB38-925E-4857-9256-A74C01032EEF"),
                        OldFiscalStart = new DateTime(2017, 4, 6),
                        NewFiscalStart = new DateTime(2017, 4, 5)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("FB070A3A-3076-4B48-BBB7-A74C01074925"),
                        OldFiscalStart = new DateTime(2017, 4, 6),
                        NewFiscalStart = new DateTime(2017, 4, 5)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("E9D93ACD-6FD7-4B49-B3A5-A716009A27A8"),
                        OldFiscalStart = new DateTime(2017, 2, 11),
                        NewFiscalStart = new DateTime(2017, 2, 10)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("5D756EBD-6CC2-47BB-96B8-A71600A53F10"),
                        OldFiscalStart = new DateTime(2017, 2, 11),
                        NewFiscalStart = new DateTime(2017, 2, 10)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("126DF2B1-CB38-4939-84FC-A6ED014CC3B6"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("49ED700F-1A28-42FD-85DA-A76600C43492"),
                        OldFiscalStart = new DateTime(2017, 5, 2),
                        NewFiscalStart = new DateTime(2017, 5, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("52BAB27B-6750-44A7-9ADF-A72300A93953"),
                        OldFiscalStart = new DateTime(2017, 2, 24),
                        NewFiscalStart = new DateTime(2017, 2, 23)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("A41498C8-DC64-4884-AEA9-A6ED0159F928"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("C9979ADA-4A30-40A8-8816-4038855DFAE9"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("833BF5C6-0C1C-451B-B3E4-6380CB6EE638"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("2488907E-927E-45FF-97F0-B87321512700"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("95B5FFD1-2232-466E-BDC0-A73600BFD5FE"),
                        OldFiscalStart = new DateTime(2017, 2, 13),
                        NewFiscalStart = new DateTime(2017, 2, 12)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("829514DB-37C5-420B-B018-A75A01011A95"),
                        OldFiscalStart = new DateTime(2017, 4, 20),
                        NewFiscalStart = new DateTime(2017, 4, 19)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("F4C2507B-DAC4-4E8E-9D91-A75A010177A9"),
                        OldFiscalStart = new DateTime(2017, 4, 20),
                        NewFiscalStart = new DateTime(2017, 4, 19)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("F48FB93A-9377-497E-A8CE-A75A0102FBE2"),
                        OldFiscalStart = new DateTime(2017, 4, 20),
                        NewFiscalStart = new DateTime(2017, 4, 19)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("DC83F028-F9E9-4D15-89C7-A73100B496BC"),
                        OldFiscalStart = new DateTime(2017, 3, 11),
                        NewFiscalStart = new DateTime(2017, 3, 10)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("B0E74CF6-D73B-4E91-88FE-A73100B78FFD"),
                        OldFiscalStart = new DateTime(2017, 3, 11),
                        NewFiscalStart = new DateTime(2017, 3, 10)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("C4EEAEC3-7F81-42A8-895A-A73200ABCE0E"),
                        OldFiscalStart = new DateTime(2017, 3, 12),
                        NewFiscalStart = new DateTime(2017, 3, 11)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("3F52F21D-3984-4AC0-8077-A73200AF05F3"),
                        OldFiscalStart = new DateTime(2017, 3, 13),
                        NewFiscalStart = new DateTime(2017, 3, 12)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("1D5B6E85-2F00-4745-8CCB-A70E00829592"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("3660DB19-F1FF-4EB2-9D02-A76300A389D4"),
                        OldFiscalStart = new DateTime(2017, 4, 29),
                        NewFiscalStart = new DateTime(2017, 4, 28)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("F4BFD81A-056E-4814-8B99-A7710115B072"),
                        OldFiscalStart = new DateTime(2017, 5, 13),
                        NewFiscalStart = new DateTime(2017, 5, 12)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("90E963BA-2694-4FC6-9C2E-A7710116D45D"),
                        OldFiscalStart = new DateTime(2017, 5, 13),
                        NewFiscalStart = new DateTime(2017, 5, 12)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("BBF05FF3-F43D-4DB1-A973-A771011720FD"),
                        OldFiscalStart = new DateTime(2017, 5, 13),
                        NewFiscalStart = new DateTime(2017, 5, 12)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("BCEA660A-ABD9-4A04-BEF3-CCD37BB0EF0F"),
                        OldFiscalStart = new DateTime(2017, 5, 10),
                        NewFiscalStart = new DateTime(2017, 5, 9)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("308DE758-0C08-455F-846A-A70E00F3D705"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("2F67003E-B02E-491E-885C-A71200D175B9"),
                        OldFiscalStart = new DateTime(2017, 2, 7),
                        NewFiscalStart = new DateTime(2017, 2, 6)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("CF0E7F8D-5D58-41C5-9C0E-A6ED0154416F"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("718DCC70-CE87-4C89-B630-A78600A28F4D"),
                        OldFiscalStart = new DateTime(2017, 6, 3),
                        NewFiscalStart = new DateTime(2017, 6, 2)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("073B408D-5155-4E25-AC61-A78600A380BE"),
                        OldFiscalStart = new DateTime(2017, 6, 3),
                        NewFiscalStart = new DateTime(2017, 6, 2)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("99948087-C5AA-4EFE-867F-A78600A44C62"),
                        OldFiscalStart = new DateTime(2017, 6, 3),
                        NewFiscalStart = new DateTime(2017, 6, 2)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("5D550BFB-4507-409A-B500-A74300C32F79"),
                        OldFiscalStart = new DateTime(2017, 3, 28),
                        NewFiscalStart = new DateTime(2017, 3, 27)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("005B053D-97FE-4484-A51E-A74300C386D5"),
                        OldFiscalStart = new DateTime(2017, 3, 28),
                        NewFiscalStart = new DateTime(2017, 3, 27)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("0460CDA0-1EE3-4296-A1C2-A72E00AFCA3E"),
                        OldFiscalStart = new DateTime(2017, 3, 7),
                        NewFiscalStart = new DateTime(2017, 3, 6)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("3AED00FD-4874-4C65-98D0-A71C00D080D2"),
                        OldFiscalStart = new DateTime(2017, 2, 17),
                        NewFiscalStart = new DateTime(2017, 2, 16)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("B016D29F-6953-4C06-A58A-A73700C6DB3C"),
                        OldFiscalStart = new DateTime(2017, 3, 16),
                        NewFiscalStart = new DateTime(2017, 3, 15)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("510731E9-E547-40DF-9D46-A6ED014C9546"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("D8B6C3F9-0290-444B-BF35-A6ED014C9664"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("DBA2F0EF-0FBC-4C3D-8909-A6ED014C9761"),
                        OldFiscalStart = new DateTime(2017, 1, 3),
                        NewFiscalStart = new DateTime(2017, 1, 2)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("DBA2F0EF-0FBC-4C3D-8909-A6ED014C9761"),
                        OldFiscalStart = new DateTime(2017, 1, 3),
                        NewFiscalStart = new DateTime(2017, 1, 2)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("244F6BF9-1F51-4861-96A4-A6ED014C9B84"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("89DA998C-8A6A-490A-AACA-A77801024A31"),
                        OldFiscalStart = new DateTime(2017, 5, 20),
                        NewFiscalStart = new DateTime(2017, 5, 19)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("B23D4696-78EC-4419-8C43-A77801029D64"),
                        OldFiscalStart = new DateTime(2017, 5, 20),
                        NewFiscalStart = new DateTime(2017, 5, 19)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("182097DF-6288-4AC6-B89E-A75500C0A909"),
                        OldFiscalStart = new DateTime(2017, 4, 15),
                        NewFiscalStart = new DateTime(2017, 4, 14)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("EFC342F7-9DDF-490C-A71F-A6ED01598365"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("7CC1C593-2B23-4936-BEFD-A6ED0159866F"),
                        OldFiscalStart = new DateTime(2017, 1, 3),
                        NewFiscalStart = new DateTime(2017, 1, 2)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("7CC1C593-2B23-4936-BEFD-A6ED0159866F"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("F91D5945-1CBF-48E6-9868-A6F200C0421C"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("3CC78AD6-F7FA-428B-B204-A6F200C92118"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("E66D12DD-B8A1-4936-8375-A70E00BE656D"),
                        OldFiscalStart = new DateTime(2017, 2, 3),
                        NewFiscalStart = new DateTime(2017, 2, 2)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("4D947614-C846-4C7B-815C-A73200BE9293"),
                        OldFiscalStart = new DateTime(2017, 3, 11),
                        NewFiscalStart = new DateTime(2017, 3, 10)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("C4BDF1DA-BCD5-4F47-BEE8-A74E00A386C6"),
                        OldFiscalStart = new DateTime(2017, 4, 8),
                        NewFiscalStart = new DateTime(2017, 4, 7)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("5C4E9145-82BD-4BFB-AD81-A76A00BC2C77"),
                        OldFiscalStart = new DateTime(2017, 5, 6),
                        NewFiscalStart = new DateTime(2017, 5, 5)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("CEF9D8C7-0B95-4EDB-9315-A77800ACF9B5"),
                        OldFiscalStart = new DateTime(2017, 5, 20),
                        NewFiscalStart = new DateTime(2017, 5, 19)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("6EAFD111-6E48-4D73-9813-A75F00CD86D9"),
                        OldFiscalStart = new DateTime(2017, 4, 25),
                        NewFiscalStart = new DateTime(2017, 4, 24)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("94A6E8C3-E6D9-43D9-8866-A77E00C2A951"),
                        OldFiscalStart = new DateTime(2017, 5, 26),
                        NewFiscalStart = new DateTime(2017, 5, 25)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("F70C14D0-69A2-4A7D-B5CB-A6ED014DC961"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("68C6CA96-EF5C-4903-B289-A6ED014DC9BB"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("09909B25-B817-48BE-AA06-A76D00A1D7E3"),
                        OldFiscalStart = new DateTime(2017, 5, 9),
                        NewFiscalStart = new DateTime(2017, 5, 8)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("242FA9A1-0828-4757-B172-A76F00EB89BF"),
                        OldFiscalStart = new DateTime(2017, 5, 11),
                        NewFiscalStart = new DateTime(2017, 5, 10)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("94E255BD-69A8-4C47-8632-A6F900D83BE0"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("C9E85E0E-8857-4230-B5BD-A72A00BC955D"),
                        OldFiscalStart = new DateTime(2017, 3, 3),
                        NewFiscalStart = new DateTime(2017, 3, 2)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("DF494F55-40A4-4C33-841C-A72A00BDBCA6"),
                        OldFiscalStart = new DateTime(2017, 3, 3),
                        NewFiscalStart = new DateTime(2017, 3, 2)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("80BE45AC-741F-4AAA-87DD-A74E00A17397"),
                        OldFiscalStart = new DateTime(2017, 4, 8),
                        NewFiscalStart = new DateTime(2017, 4, 7)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("81FC9388-E34B-46B0-9C7F-A77D00BC4B04"),
                        OldFiscalStart = new DateTime(2017, 5, 25),
                        NewFiscalStart = new DateTime(2017, 5, 24)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("B4B728DC-4705-446A-ABFD-A77D00BD0CD0"),
                        OldFiscalStart = new DateTime(2017, 5, 25),
                        NewFiscalStart = new DateTime(2017, 5, 24)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("BA27A17B-B453-46E0-8C14-A6ED014F0B8D"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("0B69C05E-ADCE-4001-B2E5-A77600A61C87"),
                        OldFiscalStart = new DateTime(2017, 5, 18),
                        NewFiscalStart = new DateTime(2017, 5, 17)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("4FE78800-0E9F-4E40-ACDF-A75C00B7167F"),
                        OldFiscalStart = new DateTime(2017, 4, 22),
                        NewFiscalStart = new DateTime(2017, 4, 21)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("C6AA3FB3-3469-4E05-B638-A6ED014B797E"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("06480A85-707F-45E1-87CC-A74700AE0D88"),
                        OldFiscalStart = new DateTime(2017, 4, 1),
                        NewFiscalStart = new DateTime(2017, 3, 31)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("AF71039C-ABF8-4A6D-9607-A73100ABCB45"),
                        OldFiscalStart = new DateTime(2017, 3, 10),
                        NewFiscalStart = new DateTime(2017, 3, 9)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("68CE5847-5B51-47B1-94B9-A75B00C0D14C"),
                        OldFiscalStart = new DateTime(2017, 4, 21),
                        NewFiscalStart = new DateTime(2017, 4, 20)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("39A3597B-774B-44E7-9133-A78C00A87D72"),
                        OldFiscalStart = new DateTime(2017, 6, 9),
                        NewFiscalStart = new DateTime(2017, 6, 8)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("387197AA-D033-4DB0-8A6E-A6ED0154DB92"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("888FD876-FB34-4009-95B0-A6ED0154DFE4"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("7104C20A-F3E8-4220-8DC7-A6ED0154EAE5"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("BB53FDE8-D4AB-4346-89BD-A6ED0154FB56"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("9A01F0EE-1E96-412F-A087-A76100D5C609"),
                        OldFiscalStart = new DateTime(2017, 4, 27),
                        NewFiscalStart = new DateTime(2017, 4, 26)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("2C11A9D9-1002-4956-9164-A71B00BFF5F4"),
                        OldFiscalStart = new DateTime(2017, 2, 16),
                        NewFiscalStart = new DateTime(2017, 2, 15)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("135C108F-E9D8-4881-B199-A72900B69FEA"),
                        OldFiscalStart = new DateTime(2017, 3, 2),
                        NewFiscalStart = new DateTime(2017, 3, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("8A4796ED-8E5B-4637-A64D-A76E01135AD5"),
                        OldFiscalStart = new DateTime(2017, 5, 10),
                        NewFiscalStart = new DateTime(2017, 5, 9)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("017C6698-A871-4C36-BCD4-A76E0113CEA3"),
                        OldFiscalStart = new DateTime(2017, 5, 10),
                        NewFiscalStart = new DateTime(2017, 5, 9)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("4E4D3FC2-6654-4D34-96C9-A76E0114D228"),
                        OldFiscalStart = new DateTime(2017, 5, 10),
                        NewFiscalStart = new DateTime(2017, 5, 9)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("8C15BA59-808A-4E38-B245-A78400AACD2E"),
                        OldFiscalStart = new DateTime(2017, 6, 1),
                        NewFiscalStart = new DateTime(2017, 5, 31)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("5D310AD5-4B66-423D-AD54-A6ED015674B5"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("AA0C65AF-BE0C-41C8-B41B-A7470110F2E9"),
                        OldFiscalStart = new DateTime(2017, 4, 1),
                        NewFiscalStart = new DateTime(2017, 3, 31)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("7858A641-4951-4B85-A06B-A76A00C4B3ED"),
                        OldFiscalStart = new DateTime(2017, 5, 6),
                        NewFiscalStart = new DateTime(2017, 5, 5)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("E5FA3F38-DC81-4F92-80A1-A78500BAE69B"),
                        OldFiscalStart = new DateTime(2017, 6, 2),
                        NewFiscalStart = new DateTime(2017, 6, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("4284C0D5-8B7B-4C8E-886F-A79000B55299"),
                        OldFiscalStart = new DateTime(2017, 6, 13),
                        NewFiscalStart = new DateTime(2017, 6, 12)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("B98DA369-48D5-4007-92FB-A79E009E59F1"),
                        OldFiscalStart = new DateTime(2017, 6, 27),
                        NewFiscalStart = new DateTime(2017, 6, 26)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("808A594E-3870-4C87-AD84-A73200A9CE67"),
                        OldFiscalStart = new DateTime(2017, 3, 11),
                        NewFiscalStart = new DateTime(2017, 3, 10)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("DDC3ED4F-6AEF-474C-80D4-A77000FBA473"),
                        OldFiscalStart = new DateTime(2017, 5, 12),
                        NewFiscalStart = new DateTime(2017, 5, 11)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("A5E69A6F-0C16-42D9-9D13-A76600ED0AC0"),
                        OldFiscalStart = new DateTime(2017, 5, 2),
                        NewFiscalStart = new DateTime(2017, 5, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("1B16E501-6383-48B3-81F8-A6ED014B54F4"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("6BB52FD2-C741-4E9F-B253-A6ED01596A57"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("6EA3EA15-86C0-45EB-A7BA-11C3835F98CE"),
                        OldFiscalStart = new DateTime(2017, 4, 11),
                        NewFiscalStart = new DateTime(2017, 4, 10)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("89A73068-3FD9-431E-8B10-A78600B5B946"),
                        OldFiscalStart = new DateTime(2017, 6, 3),
                        NewFiscalStart = new DateTime(2017, 6, 2)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("549DB64D-FA13-4FAF-B6FD-A7A000A9AC10"),
                        OldFiscalStart = new DateTime(2017, 6, 29),
                        NewFiscalStart = new DateTime(2017, 6, 28)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("DE7EE3B3-E85A-4056-A90A-A71300C17EE9"),
                        OldFiscalStart = new DateTime(2017, 2, 9),
                        NewFiscalStart = new DateTime(2017, 2, 8)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("44C7F7FE-66CE-417B-BE42-A73200ADA46E"),
                        OldFiscalStart = new DateTime(2017, 3, 12),
                        NewFiscalStart = new DateTime(2017, 3, 11)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("2036F061-FBD1-48B2-A748-A78B0098CC40"),
                        OldFiscalStart = new DateTime(2017, 6, 8),
                        NewFiscalStart = new DateTime(2017, 6, 7)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("D5B793B2-2F7E-4F94-9409-A70C00B234EE"),
                        OldFiscalStart = new DateTime(2017, 1, 3),
                        NewFiscalStart = new DateTime(2017, 1, 2)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("AFAB215C-19FD-4B01-BF4B-A6F200D6A706"),
                        OldFiscalStart = new DateTime(2017, 1, 2),
                        NewFiscalStart = new DateTime(2017, 1, 1)
                    },
                    new LeaveCycleEmployee
                    {
                        EmployeeId = new Guid("38DEC00D-0DDF-44AC-A5CD-A76F00EC7B74"),
                        OldFiscalStart = new DateTime(2017, 5, 11),
                        NewFiscalStart = new DateTime(2017, 5, 10)
                    }
                };







                leaveCycleEmployees.ForEach(e =>
				{
					var employee = companyRepository.GetEmployeeById(e.EmployeeId);
					
					if (employee.SickLeaveHireDate.Date != e.NewFiscalStart.Date)
					{
						employee.SickLeaveHireDate = e.NewFiscalStart.Date;
						empList.Add(employee);
					}

					var annualLimit = employee.CompanyId == new Guid("A931428F-705A-4EC9-AE6E-A6ED01575C58") ||
														employee.CompanyId == new Guid("9471FF28-FEAF-4F67-9A9B-A6ED0158DB28")
						? (decimal)48
						: (decimal)24;
					var checks = readerService.GetPayChecks(employeeId: e.EmployeeId);
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
					payCheckList.ForEach(payrollRepository.UpdatePayCheckSickLeaveAccumulation);
					empList.ForEach(e =>
					{
						companyRepository.SaveEmployee(e);
						Console.WriteLine("E {0}, {1}, {2}",e.CompanyEmployeeNo, e.FullName, e.Id);
					});
					txn.Complete();
				}
			}
		}


		private static void FixAccumulationCycleAndYtdForPeo(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var readerService = scope.Resolve<IReaderService>();
				var payrollRepository = scope.Resolve<IPayrollRepository>();
				var companyRepository = scope.Resolve<ICompanyRepository>();

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
					var employee = companyRepository.GetEmployeeById(e.EmployeeId);
					var company = readerService.GetCompany(employee.CompanyId);
					employee.SickLeaveHireDate = e.NewFiscalStart.Date;
					employee.CarryOver = e.CarryOver;
					empList.Add(employee);

					var newFiscalEndDate = e.NewFiscalStart.AddYears(1).AddDays(-1).Date;
					var checks = readerService.GetEmployeePayChecks(e.EmployeeId);
					
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
									//a.FiscalStart = CalculateFiscalStartDate(employee.SickLeaveHireDate.Date, p.PayDay).Date;
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
					payCheckList.ForEach(payrollRepository.UpdatePayCheckSickLeaveAccumulation);
					empList.ForEach(e =>
					{
						companyRepository.SaveEmployeeSickLeaveAndCarryOver(e);
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
				var taxationService = scope.Resolve<ITaxationService>();
				var taxTables = taxationService.GetTaxTables(2019);
				var taxTablesContext = taxationService.GetTaxTablesByContext();
				var differentTaxYearRates = taxTables.Taxes.Where(t => taxTablesContext.Taxes.All(t1 => !t.Equals(t1))).ToList();
				var differentFit = taxTables.FITTaxTable.Where(t => taxTablesContext.FITTaxTable.All(t1 => !t.Equals(t1))).ToList();
				var differentSit = taxTables.CASITTaxTable.Where(t => taxTablesContext.CASITTaxTable.All(t1 => !t.Equals(t1))).ToList();
				var differentSitLow = taxTables.CASITLowIncomeTaxTable.Where(t => taxTablesContext.CASITLowIncomeTaxTable.All(t1 => !t.Equals(t1))).ToList();
				var differentFitw = taxTables.FitWithholdingAllowanceTable.Where(t => taxTablesContext.FitWithholdingAllowanceTable.All(t1 => !t.Equals(t1))).ToList();
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
				var readerService = scope.Resolve<IReaderService>();
				var payrollRepository = scope.Resolve<IPayrollRepository>();
				var mapper = scope.Resolve<IMapper>();
				using (var txn = TransactionScopeHelper.TransactionNoTimeout())
				{
					var claims = payrollRepository.GetInvoiceDeliveryClaims(null, null);
					claims.ForEach(id =>
					{
						id.InvoiceSummaries = mapper.Map<List<PayrollInvoice>, List<InvoiceSummaryForDelivery>>(id.Invoices);
						id.Invoices = null;
					});
					payrollRepository.UpdateInvoiceDeliveryData(claims);
					txn.Complete();
				}
			}
		}

		private static void FixPayCheckYtd(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var readerService = scope.Resolve<IReaderService>();
				var payrollRepository = scope.Resolve<IPayrollRepository>();
				var counter = (int) 0;
				var eacounter = (int) 0;
				var taxcounter = (int) 0;
				var year = Convert.ToInt32(Console.ReadLine());
				var payrolls = readerService.GetPayrolls(null, excludeVoids:1, startDate: new DateTime(year,1,1), endDate:new DateTime(year, 12,31));
				payrolls.OrderBy(p=>p.PayDay).ToList().ForEach(payroll =>
				{
					var employeeAccumulations = readerService.GetAccumulations(company: payroll.Company.Id,
						startdate: new DateTime(payroll.PayDay.Year, 1, 1), enddate: payroll.PayDay, 
						ssns: payroll.PayChecks.Select(pc => pc.Employee.SSN).Aggregate(string.Empty, (current, m) => current + Crypto.Encrypt(m) + ","));
					payroll.PayChecks.ForEach(pc =>
					{
						var fit = pc.Taxes.First(t => t.Tax.Code == "FIT");
						var ea = employeeAccumulations.FirstOrDefault(e => e.EmployeeId.Value == pc.Employee.Id || e.SSNVal==pc.Employee.SSN);
						if (ea != null)
						{
							var eafit = ea.Taxes.FirstOrDefault(t => t.Tax.Code == "FIT");
							if (eafit != null)
							{
								if (fit.YTDWage != (eafit.YTDWage))
								{
									Console.WriteLine("{0} -- {1}", pc.Id, ++counter);
									fit.YTDWage = eafit.YTDWage;
								}
							}
							else
							{
								Console.WriteLine("Tax Missing {0}--{1}", pc.Id, ++taxcounter);
							}
						}
						else
						{
							Console.WriteLine("EA Missing {0}--{1}", pc.Id, ++eacounter);
						}
						
					});
				});

				
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
				var readerService = scope.Resolve<IReaderService>();
				var payrollRepository = scope.Resolve<IPayrollRepository>();
				var taxationService = scope.Resolve<ITaxationService>();
				var hostService = scope.Resolve<IHostService>();
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

				

				var checksWithFutaWageIssue = 0;
				var checksProcessed = 0;
				
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
						var payroll = readerService.GetPayroll(p1);
						var employeeAccumulations = readerService.GetAccumulations(company: payroll.Company.Id,
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
							var host = hostService.GetHost(payroll.Company.HostId);
							var taxes = taxationService.ProcessTaxes(payroll.Company, pc, pc.PayDay, pc.GrossWage, host.Company, ea);
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

							
							var updateAccumulation = false;


							if (sbfutawage != futawage || ettwage != sbettwage || sbsuiwage != uiwage)
							{
								
								pc.Taxes.First(t => t.Tax.Code.Equals("SUI")).TaxableWage = suitax.TaxableWage;
								pc.Taxes.First(t => t.Tax.Code.Equals("SUI")).Amount = suitax.Amount;
								pc.Taxes.First(t => t.Tax.Code.Equals("ETT")).TaxableWage = etttax.TaxableWage;
								pc.Taxes.First(t => t.Tax.Code.Equals("ETT")).Amount = etttax.Amount;
								pc.Taxes.First(t => t.Tax.Code.Equals("FUTA")).TaxableWage = futatax.TaxableWage;
								pc.Taxes.First(t => t.Tax.Code.Equals("FUTA")).Amount = futatax.Amount;
								Console.WriteLine("{0},{1},{2},{3},{4}", payroll.Company.Id, payroll.Company.Name.Replace(",", string.Empty), payroll.Id, pc.Id, pc.Employee.FullName);
								taxupdate.Add(pc);
								checksWithFutaWageIssue++;
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

					
					Console.WriteLine("Checks with futa wage issues: " + checksWithFutaWageIssue);
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
							payrollRepository.FixPayCheckTaxes(taxupdate);
						if (accupdate.Any())
							payrollRepository.FixPayCheckAccumulations(accupdate);
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

		private static void FixPayrollYtd(IContainer container)
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
				var readerService = scope.Resolve<IReaderService>();
				var payrollRepository = scope.Resolve<IPayrollRepository>();
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
						var payroll = readerService.GetPayroll(p1);
						var employeeAccumulations = readerService.GetAccumulations(company: payroll.Company.Id,
						startdate: new DateTime(payroll.PayDay.Year, 1, 1), enddate: payroll.PayDay);
						
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
							payrollRepository.UpdatePayCheckYTD(pc);
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




			foreach (var payType in accumulatedPayTypes)
			{
				var fiscalStartDate = CalculateFiscalStartDate(paycheck.Employee.SickLeaveHireDate, paycheck.PayDay, payType);
				var fiscalEndDate = fiscalStartDate.AddYears(1).AddDays(-1);

				if (!payType.CompanyManaged)
				{

					var currentAccumulaiton = employeeAccumulation.Accumulations != null &&
																		employeeAccumulation.Accumulations.Any(
																			ac =>
																				ac.PayTypeId == payType.PayType.Id && ac.FiscalStart == fiscalStartDate &&
																				ac.FiscalEnd == fiscalEndDate)
						? employeeAccumulation.Accumulations.Where(
							ac => ac.PayTypeId == payType.PayType.Id && ac.FiscalStart == fiscalStartDate && ac.FiscalEnd == fiscalEndDate)
							.OrderBy(ac => ac.FiscalStart)
							.Last()
						: null;
					var previousAccumulations = employeeAccumulation.Accumulations != null &&
																		employeeAccumulation.Accumulations.Any(
																			ac =>
																				ac.PayTypeId == payType.PayType.Id && ac.FiscalStart < fiscalStartDate &&
																				ac.FiscalEnd < fiscalEndDate)
						? employeeAccumulation.Accumulations.Where(
							ac => ac.PayTypeId == payType.PayType.Id && ac.FiscalStart < fiscalStartDate && ac.FiscalEnd < fiscalEndDate)
							.ToList()
						: null;


					var carryOver = paycheck.Employee.CarryOver;
					carryOver += previousAccumulations != null
						? previousAccumulations.Sum(ac => ac.YTDFiscal - ac.YTDUsed)
						: 0;

					var ytdAccumulation = (decimal)0;
					var ytdUsed = (decimal)0;

					if (currentAccumulaiton != null)
					{
						ytdAccumulation = currentAccumulaiton.YTDFiscal;
						ytdUsed = currentAccumulaiton.YTDUsed;
						//carryOver = accum.CarryOver;

					}

					if (ytdAccumulation > payType.AnnualLimit)
						ytdAccumulation = payType.AnnualLimit;

					var thisCheckValue = CalculatePayTypeAccumulation(paycheck, payType, ytdAccumulation);
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
						CarryOver = Math.Round(carryOver, 2, MidpointRounding.AwayFromZero)
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
			else if (employee.PayType == EmployeeType.PieceWork || employee.PayType == EmployeeType.JobCost)
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

		private static decimal CalculatePayTypeAccumulation(PayCheck paycheck, AccumulatedPayType payType, decimal ytd)
		{
			if (payType.IsLumpSum)
			{
				return payType.AnnualLimit - ytd;
			}

			if (paycheck.Employee.PayType == EmployeeType.Hourly || paycheck.Employee.PayType == EmployeeType.PieceWork)
			{
				return paycheck.PayCodes.Sum(pc => pc.Hours + pc.OvertimeHours) * payType.RatePerHour;
			}
			else
			{
				if (paycheck.Employee.Rate <= 0)
					return 0;
				var val = (paycheck.Salary / paycheck.Employee.Rate) * (40 * 52 / 365) * payType.RatePerHour;
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

		private static DateTime CalculateFiscalStartDate(DateTime hireDate, DateTime payDay, AccumulatedPayType payType)
		{
			if (payType.IsLumpSum)
				return new DateTime(payDay.Year, 1, 1).Date;
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

		public class MissingSl
		{
			public Guid CompanyId { get; set; }
			public Guid EmployeeId { get; set; }
			public int CompanyEmployeeNo { get; set; }
			public decimal MissingVal { get; set; }
			public decimal MissingUsed { get; set; }
			public decimal Carryover { get; set; }
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
			public int Empno { get; set; }
			public decimal Carryover { get; set; }
		}

		public class InvoiceFix 
		{
			public Guid Id { get; set; }
			public Guid SourceCompany { get; set; }
		}
	}
}
