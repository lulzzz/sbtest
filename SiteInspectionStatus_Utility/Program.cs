using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web.UI;
using Autofac;
using HrMaxx.Infrastructure.Mapping;
using HrMaxxAPI.Code.IOC;
using LinqToExcel;
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

			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.RepositoriesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.MappingModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.ServicesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.CommandHandlerModule>();

			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.RepositoriesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.MappingModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.ServicesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.CommandHandlerModule>();
			
			var container = builder.Build();
			ImportData(container);
			
			
			Console.WriteLine("Utility run finished for ");
		}


		private static void ImportData(IContainer container)
		{
			using (var scope = container.BeginLifetimeScope())
			{
				var excelFile = new ExcelQueryFactory("C:\\Users\\sherj\\Desktop\\import data.xlsx");
				var hosts = from a in excelFile.Worksheet(0) select a;
				var companies = from c in excelFile.Worksheet<Company>("2Company") select c;
				var companydeductions = from a in excelFile.Worksheet(2) select a;
				var companyworkercompensations = from a in excelFile.Worksheet(3) select a;
				var companytaxrates = from a in excelFile.Worksheet(4) select a;
				var companybankaccoutns = from a in excelFile.Worksheet(5) select a;
				var employees = from a in excelFile.Worksheet(6) select a;
				var employeebankaccounts = from a in excelFile.Worksheet(7) select a;

				

			}
		}

		
	}
}
