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
using HrMaxx.OnlinePayroll.Services.Mappers;
using HrMaxxAPI.Code.IOC;
using HrMaxxAPI.Resources.Common;
using Magnum;
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

			Console.WriteLine("Staring Migration " + DateTime.Now.ToShortTimeString());
			ImportOPData(container);
			Console.WriteLine("Finished Migration " + DateTime.Now.ToShortTimeString());
			//var command = Convert.ToInt32(Console.ReadLine());
		}
		private static void ImportOPData(IContainer container)
		{
			//CopyBaseData(container);
			//ImportHosts(container);
			//ImportCompanies(container);
			//ImportCompanyContract(container);
			//ImportCompanyAccounts(container);
			//ImportCompanyVendors(container);
			//ImportEmployees(container);
			ImportUsers(container);

		}

		private static void ImportUsers(IContainer scope)
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
					appUser.Role = new UserRole() { RoleId = (int)RoleTypeEnum.CompanyManager, RoleName = RoleTypeEnum.Company.GetDbName() };
				else if (u.LevelID == 2)
					appUser.Role = new UserRole() { RoleId = (int)RoleTypeEnum.HostStaff, RoleName = RoleTypeEnum.HostStaff.GetDbName() };
				else if (u.LevelID == 1)
					appUser.Role = new UserRole() { RoleId = (int)RoleTypeEnum.Host, RoleName = RoleTypeEnum.Host.GetDbName() };
				appUsers.Add(appUser);
			});

			try
			{
				var client = new RestClient(ConfigurationManager.AppSettings["ZionAPIUrl"] + "MigrateUsers");
				appUsers.ForEach(appUser =>
				{
					
					var request = new RestRequest(Method.POST);
					request.AddHeader("Authorization", "bearer iAWXH5_uozJZjC7aMjMDXQMhiPw0yDOn859zEMWyweT3yqA_kdTSl90PjmVmuI9u2ccOe8HxKn95KmGIVqFETWPpW8t0SXZ6jHgC6DJXZSHlG5Ql7WSZDjC4gLeArbrErfRVrQdX5EE7_1LgVt_h0jbGTL29RXtM82kPHIxHDviplwT5gSWd-DIOlaIq1F2lOMOW5qFgXOaxfigAho794U744vHY_zsE3MgmtilZMbCZ-EtbERC54Z_sRkGabahcI57jW3pnF4aJv6LPVSeZ2Pj_2NjxnPTgcfHw21Z1LZ54HucjK_sw6YlUA6xCFmvwfuXUm7k86pkUx73f7CZexJ8DuB8uv031cWdY1mDYy1HxoXirnweQRW5C3B2xB12-vcxsP3TzZOufU-a2IeSfn0ROpwK9nk2v5Ekqc_U2fABpJIuNpqZiq83Rg5EZt1mleYNFS9XqPQN9yqxzjS31t8EETxJMpTH6h4NI4Ux49KWSVBmWCsXu4emIMZv633TSVenPV-Q8Fj5pJm-tda_HSyelWmd1NbztsmFimvaTb1h6sW43aky3wPSMI8Iec9AUX47BxZ4nDa345iCpNYE6J0I-uz0PMtEdEG7DNYw-de9c8-rr2ZKlr2I51WYSyErvJoP_sWUbyJ0QU3tj1cz_fiB6ZR62lGo9F95jU_oEfnR4snpkW3cVynkJd8bDmIambsEm28FQP-a5LoTk-VGu2GfJw-771sWKC8WsJKmw4AlGh_voSCAxSRLcb1-j7-jfKTpuJsHbHdUek3bXnUEjy0Sdm9nzfuTGzpFgGfqmPci9B7DNoAxBQpzATVAqLh00WG96NC5aXYJfUzGwUWMyquNZulRtMPymPMyhvqFDtA7QSo_8lGTJ53i5cg3-qvNdRngNZ-ZfADESZdlL8s5yhZTbCxDfh_tTN0e9rcZl_nH5AZ8ymmQLWEWjDRHAtv736btKqD7PR95p5sOmXSKZzx9xb5kue6Gs9ci237wG5_EgNgASOx5UDLKUo1UZP-yvwPLMzxjk2A0tp38O8I9AkqsZOKcpiPv1St2lV5P95_TuBK1FUrzYzq7CIJjStHjdyKRC0L-UoaetJzjhrk6Y0fKGAXLFV3ShoyC1d2LK7FRQKQQIkOMEGknBD-FMSHWS_smjXyL4geJQvWIaNQ4saKkAwnaCTED5ipWHM1G9M7CrnUpK4BaK2wIFlG_k-sI1MGvwgM1Uxq0cdP9u5uf3hfNlyfC1hG33SKE5gfvb0OHHhY47E6MUFSJ29-znkf_NrndbaFOELBEuV5i6fJfJG9TwFkPIkNiyqTx6_ai7ZgSmtbEDhQu17YywCtspaP4l4myc3a1beGKj-cKm9QO_Roay27C9a5QclXSonrONVOrN7DhgG_V0SL2dyOIQo-OsMWOGYoCPlA1AGM54C3PaYo_EmeIx-LoPenah5JD4Qi0");
					request.AddHeader("Content-Type", "application/json");
					request.AddParameter("application/json; charset=utf-8", JsonConvert.SerializeObject(appUser), ParameterType.RequestBody);
					request.RequestFormat = DataFormat.Json;
					var response1 = client.Execute(request);
					if (response1.StatusCode == HttpStatusCode.OK)
					{
						
					}
				});
					
				

			}
			catch (Exception e)
			{


			}
			write.ExecuteQuery("Update aspnetusers set emailconfirmed=1;insert into AspNetUserClaims(UserId, ClaimType, ClaimValue)  " +
																	"select u.Id, cl.ClaimType, 1 from AspNetUsers u, AspNetUserRoles ur, AspNetRoles r, PaxolFeatureClaim cl " +
																	"where u.Id=ur.UserId and ur.RoleId=r.Id and cl.AccessLevel<=r.Id " +
																	"and not exists(select 'x' from AspNetUserClaims where UserId=u.Id and ClaimType=cl.ClaimType)");
				
		}

		private static void ImportEmployees(IContainer scope)
		{
			var read = scope.Resolve<IOPReadRepository>();
			var write = scope.Resolve<IWriteRepository>();
			var companyservice = scope.Resolve<IReaderService>();
			var companies = companyservice.GetCompanies(null, null, null);
			
			if (!users.Any())
			{
				users = read.GetQueryData<UserAccount>(Queries.users);
				contacts = read.GetQueryData<Contact>(Queries.contacts);
			}
			if (!CompanyList.Any())
				CompanyList = read.GetQueryData<HrMaxx.OnlinePayroll.Models.DataModel.Company>(Queries.pxcompanies);
			
			var mapper = scope.Resolve<IMapper>();
			var employees = read.GetQueryData<Employee>(Queries.employees);
			
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
				
				var ept = employeepaytypess.Where(ep => ep.EmployeeId == e.EmployeeID).ToList();
				ept.ForEach(ep => mapped.Compensations.Add(new HrMaxx.OnlinePayroll.Models.EmployeePayType()
				{
					Amount = ep.Amount, PayType = payTypes.First(pt=>pt.Id==ep.OtherTypeId)
				}));
				var epr = employeepayratess.Where(ep => ep.EmployeeId == e.EmployeeID).ToList();
				epr.ForEach(ep => mapped.PayCodes.Add(company.PayCodes.First(cpc=>cpc.Description.Equals(ep.PayRateDescription) && cpc.HourlyRate==ep.PayRateAmount)));
				mapped.WorkerCompensation = company.WorkerCompensations.FirstOrDefault(wc => wc.Code == e.WCJobClass);
				mapped.UserName = e.LastUpdatedBy == 0 ? "System" : users.First(u => u.UserID == e.LastUpdatedBy).UserFullName;
				var mc = contacts.First(c => c.EntityTypeID == 3 && c.EntityID == e.EmployeeID);
				mapped.Contact = new HrMaxx.Common.Models.Dtos.Contact()
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
				mapped.SickLeaveHireDate = mapped.HireDate;
				
				employeeList.Add(mapped);


			});
			var dbmapped = mapper.Map<List<HrMaxx.OnlinePayroll.Models.Employee>, List<HrMaxx.OnlinePayroll.Models.DataModel.Employee>>(employeeList);
			using (var txn = TransactionScopeHelper.Transaction())
			{
				write.SaveEmployees(dbmapped);
				txn.Complete();
			}
			
		}

		private static void ImportCompanyVendors(IContainer scope)
		{
			var read = scope.Resolve<IOPReadRepository>();
			var write = scope.Resolve<IWriteRepository>();
			var common = scope.Resolve<ICommonService>();
			var userservice = scope.Resolve<IUserService>();

			if (!users.Any())
			{
				users = read.GetQueryData<UserAccount>(Queries.users);
				//contacts = read.GetQueryData<Contact>(Queries.contacts);
			}
			if (!CompanyList.Any())
				CompanyList = read.GetQueryData<HrMaxx.OnlinePayroll.Models.DataModel.Company>(Queries.pxcompanies);
			var mapper = scope.Resolve<IMapper>();
			var vendors = read.GetQueryData<Vendors>(Queries.vendors);
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
			var test = dbvendors.Where(v => v.StatusId < 1 || v.StatusId > 3).ToList();
			write.SaveVendors(dbvendors);

		}

		private static void ImportCompanyAccounts(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var read = scope.Resolve<IOPReadRepository>();
				var write = scope.Resolve<IWriteRepository>();
				const string tmpSt = "insert into AccountTemplate values(1,2,'Bank',null);update OnlinePayroll.dbo.COA_SubTypeLookup set AccountName='Bank' where COA_SubTypeID=1;";
				const string tmpEd = "update CompanyAccount set TemplateId=null where Type=1 and SubType=2;delete from AccountTemplate where Type=1 and SubType=2;Update OnlinePayroll.dbo.COA_SubTypeLookup set AccountName=null where COA_SubTypeID=1;";
				const string accountsql = "set identity_insert CompanyAccount On;" +
				                          "insert into CompanyAccount(Id, CompanyId, Type, SubType, Name, TaxCode, TemplateId, OpeningBalance, BankAccountId, LastModified, LastModifiedBy, UsedInPayroll, UsedInInvoiceDeposit)" +
				                          "select cc.coaid, (select Id from company where CompanyIntId=cc.CompanyID), act.Type, act.SubType, cc.COAName, act.TaxCode, act.Id, " +
																	"cc.OpeningBalance, " +
				                          "case when act.Type=1 and act.SubType=2 then (select accountid from onlinepayroll.dbo.BankAccount where entitytypeid=5 and EntityId=coaid) else null end, " +
				                          "getdate(),'System Import'," +
																	"case when act.Type=1 and act.SubType=2 and exists (select 'x' from onlinepayroll.dbo.BankAccount where entitytypeid=5 and EntityId=coaid and PayrollFlag='Y') then 1 else 0 end" +
				                          ",0 " +
				                          "from OnlinePayroll.dbo.COA_Company cc, " +
				                          "(select id, type, accounttemplate.subtype, name, accounttemplate.taxcode, COA_SubTypeID " +
				                          "from AccountTemplate, OnlinePayroll.dbo.COA_SubTypeLookup where name=AccountName collate Latin1_General_CI_AS and Type=COA_TypeID) act " +
				                          "where cc.COA_SubTypeID=act.COA_SubTypeID;" +
				                          "set identity_insert CompanyAccount Off;";
				const string banksql = "set identity_insert BankAccount On; " +
				                       "insert into BankAccount(Id, EntityTypeId, EntityId, AccountType, BankName, AccountName, AccountNumber, RoutingNumber, LastModified, LastModifiedBy, FractionId) " +
				                       "select AccountId, 2, (select Id from company where CompanyIntId=(select companyid from OnlinePayroll.dbo.COA_Company where coaid=EntityID)), " +
				                       "case when AccountType='Checking' then 1 else 2 end, BankName, BankName, AccountNumber, RoutingNumber, ba.LastUpdateDate, ba.LastUpdateBy,null " +
															 "from OnlinePayroll.dbo.BankAccount ba, OnlinePayroll.dbo.COA_Company cc " +
				                       "where ba.EntityID=cc.COAID and EntityTypeID=5 and cc.COA_SubTypeID=1;" +
				                       "set identity_insert BankAccount Off;";
				using (var txn = TransactionScopeHelper.Transaction())
				{
					write.ExecuteQuery(banksql);
					write.ExecuteQuery(tmpSt);
					write.ExecuteQuery(accountsql);
					write.ExecuteQuery(tmpEd);
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
					host.UserName = users.First(u => u.UserID.ToString() == host.UserName).UserFullName;
					host.HomePage = new HostHomePage
					{
						Profile = c.WebOverview,
						Services = string.Concat(c.OurService, c.WebNews)
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
					}));
					txn.Complete();
					hostList = dbhosts;
				}
				
			}
			

		}
		private static void ImportCompanies(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var read = scope.Resolve<IOPReadRepository>();
				var write = scope.Resolve<IWriteRepository>();
				var common = scope.Resolve<ICommonService>();
				if (!users.Any())
				{
					users = read.GetQueryData<UserAccount>(Queries.users);
				}
				if(!contacts.Any())
					contacts = read.GetQueryData<Contact>(Queries.contacts);
				if (!hostList.Any())
					hostList = read.GetQueryData<HrMaxx.OnlinePayroll.Models.DataModel.Host>(Queries.pxhosts);
				var data = read.GetQueryData<Company>(Queries.company);
				var mapper = scope.Resolve<IMapper>();
				var companies = mapper.Map<List<Company>, List<HrMaxx.OnlinePayroll.Models.Company>>(data);
				data.ForEach(c =>
				{
					var company = companies.First(h => h.CompanyIntId == c.CompanyID);
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
						StateId = ((USStates)HrMaaxxSecurity.GetEnumFromHrMaxxName<USStates>(mc.State)).GetDbId().Value,
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
							Address =company.CompanyAddress
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
					company.States.Add(new CompanyTaxState()
					{
						CountryId = 1,
						State = new State() { Abbreviation = USStates.California.GetHrMaxxName(), StateId = USStates.California.GetDbId().Value, StateName = USStates.California.GetDbName()},
						StateEIN = Crypto.Decrypt(data.First(opc=>opc.CompanyID==company.CompanyIntId).SEIN).Replace("-", string.Empty),
						StatePIN = string.IsNullOrWhiteSpace(Crypto.Decrypt(data.First(opc => opc.CompanyID == company.CompanyIntId).STPIN)) ? "0000" : Crypto.Decrypt(data.First(opc => opc.CompanyID == company.CompanyIntId).STPIN),
						Id=0

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
				write.SaveCompanyAssociatedData();

			}


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
		private static void ImportCompanyContract(IContainer container)
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
					CompanyList = read.GetQueryData<HrMaxx.OnlinePayroll.Models.DataModel.Company>(Queries.pxcompanies);
				var subs = read.GetQueryData<Subscription>(Queries.subsscription);
				
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
							PrePaidSubscriptionOption = PrePaidSubscriptionOption.Gold,
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
