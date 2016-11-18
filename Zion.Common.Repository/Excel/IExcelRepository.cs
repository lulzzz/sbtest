using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.OnlinePayroll.Models;


namespace HrMaxx.Common.Repository.Excel
{
	public interface IExcelRepository
	{
		FileDto GetImportTemplate(string fileName, List<string> columms, List<List<string>> rowList, bool b);

		List<ExcelRead> GetExcelData(FileInfo file, int startingRow);

		FileDto GetImportTemplateCSV(string californiaeddexportCsv, List<string> list, List<List<string>> rowList, bool b);
	}
}
