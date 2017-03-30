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
using HrMaxx.Common.Repository.Security;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Mapping;
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
				default:
					break;
			}

			Console.WriteLine("Utility run finished for ");
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
										pcaccum.CarryOver = ac.CarryOver;
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

					var carryOver = (decimal)0;

					if (employeeAccumulation.Accumulations != null && employeeAccumulation.Accumulations.Any(ac => ac.PayTypeId == payType.PayType.Id))
					{
						var accum = employeeAccumulation.Accumulations.First(ac => ac.PayTypeId == payType.PayType.Id);
						ytdAccumulation = accum.YTDFiscal;
						ytdUsed = accum.YTDUsed;
						carryOver = accum.CarryOver;

					}
					else if (employeeAccumulation.PreviousAccumulations != null && employeeAccumulation.PreviousAccumulations.Any(ac => ac.PayTypeId == payType.PayType.Id))
					{
						carryOver = employeeAccumulation.PreviousAccumulations.First(ac => ac.PayTypeId == payType.PayType.Id).Available;

					}
					else
					{
						carryOver = paycheck.Employee.CarryOver;
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
			if (employee.PayType == EmployeeType.Salary || employee.PayType == EmployeeType.JobCost)
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
	}
}
