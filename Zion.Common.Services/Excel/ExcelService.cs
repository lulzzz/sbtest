using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Repository.Excel;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using Magnum;
using Persits.PDF;

namespace HrMaxx.Common.Services.Excel
{
	public class ExcelService : BaseService, IExcelService
	{
		private readonly ICompanyService _companyService;
		private readonly IExcelRepository _excelRepository;

		public ExcelService(ICompanyService companyService, IExcelRepository excelRepository)
		{
			_companyService = companyService;
			_excelRepository = excelRepository;
		}


		public FileDto GetEmployeeImportTemplate(Guid companyId)
		{
			try
			{
				var company = _companyService.GetCompanyById(companyId);
				var columnList = new List<string> {"SSN", "First Name", "Middle Initial", "Last Name", "Email", "Phone", "Mobile", "Fax", "Address", "City", "Address State", "Zip", "Zip Extension", "Gender", "Birth Date", "Hire Date", "Department", "Employee No", "WC Job Class"};
				columnList.AddRange(new List<string>{"Payroll Schedule", "Pay Type", "Base Salary"});
				company.PayCodes.ForEach(pc=>columnList.Add(pc.Description));
				columnList.AddRange(new List<string>{"Tax Status", "Federal Filing Status", "Federal Exemptions", "Federal Additional Amount", "State", "State Filing Status", "State Exemptions", "State Additional Amount"});
				var sampleRow = new List<string>() { "123-45-6789", string.Empty, string.Empty, string.Empty, "x@y.com", "949-555-1212 or 9495551212", "949-555-1212 or 9495551212", "949-555-1212 or 9495551212", string.Empty, string.Empty, "CA or California", "12345", "1234", string.Empty, "MM/DD/YYYY", "MM/DD/YYYY", string.Empty, string.Empty, string.Empty };
				sampleRow.AddRange(new List<string>() { "1/2/3/4 OR Weekly/Bi-Weekly/Semi-Monthly/Monthly", "Salary/Hourly/Piece-Work", "0.00" });
				company.PayCodes.ForEach(pc => sampleRow.Add(string.Empty));
				sampleRow.AddRange(new List<string>(){"1 OR 2", "1/2/3 OR S/M/H", "1 - 10", "0.00", "CA or California", "1/2/3 OR S/M/H", "1 - 10", "0.00"});

				return _excelRepository.GetImportTemplate(company.Name + "_EmployeeImport.xlsx", columnList, new List<List<string>>(){sampleRow}, true);
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, " generate employee import template for " + companyId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<ExcelRead> ImportEmployees(FileInfo file, int startingRow)
		{
			try
			{
				
				var error = string.Empty;
				var data = _excelRepository.GetExcelData(file, startingRow);

				if (!data.Any())
				{
					error += "No Data available to import<br/>";
				}
				if (!string.IsNullOrWhiteSpace(error))
					throw new Exception(error);

				return data;
				
				
				
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX, " failed to read employee import data");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(e.Message, e);
			}
		}

		public FileDto GetTimesheetImportTemplate(Guid companyId, List<string> payTypes)
		{
			var company = _companyService.GetCompanyById(companyId);
			var employees = _companyService.GetEmployeeList(companyId);
			var columnList = new List<string> { "SSN", "Employee No", "Salary", "Base Rate", "Base Rate Hours", "Base Rate Overtime" };
			var rowList = new List<List<string>>();
			company.PayCodes.ForEach(pc =>
			{
				columnList.Add(pc.Code + " Hours");
				columnList.Add(pc.Code + " Overtime");
			});
			columnList.AddRange(payTypes);
			employees.Where(e=>e.StatusId==StatusOption.Active).ToList().ForEach(e =>
			{
				var row = new List<string>();
				row.Add(string.Format("{0}-{1}-{2}",e.SSN.Substring(0,3), e.SSN.Substring(3,2), e.SSN.Substring(5,4)));
				row.Add(e.EmployeeNo);
				if(e.PayType==EmployeeType.Salary)
					row.Add(e.Rate.ToString());
				rowList.Add(row);
			});
			return _excelRepository.GetImportTemplate(company.Name + "_TimesheetImport.xlsx", columnList, rowList, false);
		}
	}
}