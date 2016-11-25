using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
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
		public FileDto GetImportTemplate(string fileName, List<string> columms, List<List<string>> rowList, bool hasSampleRow)
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
			foreach (var row in rowList)
			{
				rowCounter++;
				colummCounter = 1;
				foreach (var str in row)
				{
					e.SetCellValue(rowCounter, colummCounter++, str);
				}
			}
			if (hasSampleRow)
			{
				e.SetRowColor(2, null, Color.Red);
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

		public List<ExcelRead> GetExcelData(FileInfo file, int startingRow)
		{
			var result = new List<ExcelRead>();
			using (var xl = new Infrastructure.Excel.Excel(file))
			{
				var workSheet = xl.Worksheet;
				
				var end = workSheet.Dimension.End;
				for (int row = startingRow; row <= end.Row; row++)
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

		public FileDto GetImportTemplateCSV(string californiaeddexportCsv, List<string> list, List<List<string>> rowList, bool b)
		{
			var csv = new StringBuilder();
			csv.Append(rowList.Aggregate(string.Empty, (current, m) => current + m.First() + Environment.NewLine));
			var _filename = _filePath + californiaeddexportCsv.Replace(".csv", string.Format("{0}.csv", DateTime.Now.Ticks));
			File.WriteAllText(_filename, csv.ToString());
			var returnVal = new FileDto()
			{
				Data = File.ReadAllBytes(_filename),
				DocumentExtension = "csv", Filename = californiaeddexportCsv, MimeType = "application/octet-stream"
			};
			File.Delete(_filename);
			return returnVal;
		}

		public List<ExcelRead> GetExcelDataWithMap(FileInfo file, int startingRow, ImportMap importMap)
		{
			var result = new List<ExcelRead>();
			using (var xl = new Infrastructure.Excel.Excel(file))
			{
				var workSheet = xl.Worksheet;

				var end = workSheet.Dimension.End;
				for (int row = startingRow; row <= end.Row; row++)
				{ // Row by row...
					var erow = new ExcelRead { Row = row, Values = new List<KeyValuePair<string, string>>() };
					for (int col = 1; col <= end.Column; col++)
					{ // ... Cell by cell...
						var match = importMap.ColumnMap.FirstOrDefault(cm => cm.Value == col);
						if (!string.IsNullOrWhiteSpace(match.Key))
						{
							var cellValue = workSheet.Cells[row, col].Text; // This got me the actual value I needed.
							var header = match.Key;
							erow.Values.Add(new KeyValuePair<string, string>(header.ToLower(), cellValue));
						}
						

					}
					result.Add(erow);
				}


			}
			return result;
		}
	}
}
