using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using OfficeOpenXml;

namespace HrMaxx.Common.Repository.Excel
{
	public class ExcelRepository : IExcelRepository
	{
		private readonly string _filePath;
		public ExcelRepository(string filePath)
		{
			_filePath = filePath;
		}
		public FileDto GetImportTemplate(string fileName, List<string> columms)
		{
			var e = new Infrastructure.Excel.Excel(_filePath);
			e.AddWorksheet("Sheet1");
			int rowCounter = 1;
			int colummCounter = 1;
			
			foreach (var columm in columms)
			{
				e.SetCellValue(rowCounter, colummCounter++, columm);
				e.SetCellBold(rowCounter, colummCounter-1);
			}
			var file = e.Save();
			return new FileDto
			{
				Data = file,
				Filename = fileName,
				DocumentExtension = ".xlsx",
				MimeType = "application/octet-stream"
			};
		}

		public List<ExcelRead> GetExcelData(FileInfo file)
		{
			var result = new List<ExcelRead>();
			using (var xl = new Infrastructure.Excel.Excel(file))
			{
				var workSheet = xl.Worksheet;
				
				var end = workSheet.Dimension.End;
				for (int row = 2; row <= end.Row; row++)
				{ // Row by row...
					var erow = new ExcelRead {Row = row, Values=new List<KeyValuePair<string, string>>()};
					for (int col = 1; col <= end.Column; col++)
					{ // ... Cell by cell...
						var cellValue = workSheet.Cells[row, col].Text; // This got me the actual value I needed.
						var header = workSheet.Cells[1, col].Text; // This got me the actual value I needed.
						erow.Values.Add(new KeyValuePair<string, string>(header.ToLower(), cellValue));
						
					}
					result.Add(erow);
				}
				

			}
			return result;
		}

	
	}
}
