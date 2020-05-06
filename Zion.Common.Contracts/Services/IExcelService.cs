﻿using System;
using System.Collections.Generic;
using System.IO;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;

namespace HrMaxx.Common.Contracts.Services
{
	public interface IExcelService
	{
		FileDto GetEmployeeImportTemplate(Guid companyId);
		List<ExcelRead> ImportFromExcel(FileInfo readAllBytes, int i);
		FileDto GetTimesheetImportTemplate(Guid companyId, List<string> payTypes);
		FileDto GetCaliforniaEDDExport();
		List<ExcelRead> ImportWithMap(FileInfo file, ImportMap importMap, string fileName, bool allowmultiplesheets = false);
		FileDto GetExcelFile(string name, List<string> columns, List<List<string>> rows, bool hasSampleRows = false);

	}
}
