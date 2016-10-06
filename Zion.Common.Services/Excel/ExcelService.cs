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
				return _excelRepository.GetImportTemplate(company.Name + "_EmployeeImport.xlsx", columnList);
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, " generate employee import template for " + companyId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<ExcelRead> ImportEmployees(FileInfo file)
		{
			try
			{
				
				var error = string.Empty;
				var data = _excelRepository.GetExcelData(file);

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
		

		
	}
}