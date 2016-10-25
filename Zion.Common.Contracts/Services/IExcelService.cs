using System;
using System.Collections.Generic;
using System.IO;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;

namespace HrMaxx.Common.Contracts.Services
{
	public interface IExcelService
	{
		FileDto GetEmployeeImportTemplate(Guid companyId);
		List<ExcelRead> ImportEmployees(FileInfo readAllBytes);
		FileDto GetTimesheetImportTemplate(Guid companyId, List<string> payTypes);
	}
}
