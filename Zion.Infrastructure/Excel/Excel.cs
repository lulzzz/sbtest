using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using OfficeOpenXml;
using OfficeOpenXml.Style;

namespace HrMaxx.Infrastructure.Excel
{
	public class Cell
	{
		public int X { get; set; }

		public string Column { get; set; }

		public int Y { get; set; }

		public object Value { get; set; }
	}

	/// <summary>
	///   Summary description for Excel
	/// </summary>
	public class Excel : IDisposable
	{
		private bool _disposed;
		private FileInfo _file;
		private ExcelPackage _package;
		private bool _saved;
		private bool _tempfile;
		private ExcelWorksheet _worksheet;
		private string _temporaryPath;

		/// <summary>
		///   Create instance of excel class
		/// </summary>
		/// <param name="filename">Name of excel file to open.  A new file is created if not specified</param>
		public Excel(string path, string filename = "")
		{
			_temporaryPath = path;
			if (!string.IsNullOrEmpty(filename))
			{
				_file = new FileInfo(filename);
				if (!_file.Exists)
					throw new FileNotFoundException(filename + " doesn't exist");
				_package = new ExcelPackage(_file);
				_worksheet = _package.Workbook.Worksheets[1];
			}
			else
			{
				CreateNewSpreadsheet();
			}
		}

		public Excel(FileInfo file, bool allowMultiplesheets = false)
		{
			if (file.Exists)
			{
				_package = new ExcelPackage(file);
				if(!allowMultiplesheets && _package.Workbook.Worksheets.Count!=1)
					throw new Exception("File contains multiple sheets");
				_worksheet = _package.Workbook.Worksheets[1];
				
			}
			else
			{
				throw new FileLoadException();
			}
		}
		
		public ExcelWorksheet Worksheet
		{
			get { return _worksheet; }
		}

		public int RowCount
		{
			get { return _worksheet.Dimension.End.Row; }
		}

		public int ColCount
		{
			get { return _worksheet.Dimension.End.Column; }
		}

		private string TemporaryPath
		{
			get { return _temporaryPath; }
		}

		public List<ExcelWorksheet> Worksheets
		{
			get { return _package.Workbook.Worksheets.ToList(); }
		}

		public void Dispose()
		{
			Dispose(true);
			// This object will be cleaned up by the Dispose method. 
			// Therefore, you should call GC.SupressFinalize to 
			// take this object off the finalization queue 
			// and prevent finalization code for this object 
			// from executing a second time.
			GC.SuppressFinalize(this);
		}

		public Cell FindCellWithData(string fromColumn, string toColumn, string data, bool exactMatch = false)
		{
			IEnumerable<ExcelRangeBase> q =
				(from cell in _worksheet.Cells[1, char.ToUpper(fromColumn[0]) - 64, 1000, char.ToUpper(toColumn[0]) - 64]
					select cell);
			q = exactMatch ? q.Where(n => data == n.Text) : q.Where(n => data.Contains(n.Text));

			ExcelRangeBase c = q.FirstOrDefault();
			return c != null
				? new Cell
				{
					Value = c.Value,
					Column = c.Address.Substring(0, 1),
					X = char.ToUpper(c.Address.Substring(0, 1)[0]) - 64,
					Y = Convert.ToInt32(c.Address.Substring(1, c.Address.Length - 1))
				}
				: null;
		}

		public List<Cell> FindCellsWithData(string fromColumn, string toColumn, string data, bool exactMatch = false)
		{
			IEnumerable<ExcelRangeBase> q =
				(from cell in _worksheet.Cells[1, char.ToUpper(fromColumn[0]) - 64, 1000, char.ToUpper(toColumn[0]) - 64]
					select cell);
			q = exactMatch ? q.Where(n => data == n.Text) : q.Where(n => data.Contains(n.Text));


			return q.Select(c => new Cell
			{
				Value = c.Value,
				Column = c.Address.Substring(0, 1),
				X = char.ToUpper(c.Address.Substring(0, 1)[0]) - 64,
				Y = Convert.ToInt32(c.Address.Substring(1, c.Address.Length - 1))
			}).ToList();
		}

		/// <summary>
		///   Save current excel file
		/// </summary>
		/// <param name="filename">Full path and filename to save file as</param>
		public FileInfo Save(string filename = "")
		{
			if (!string.IsNullOrEmpty(filename))
			{
				var f = new FileInfo(filename);
				_package.SaveAs(f);
				if (_file == null)
					_file = f;
				return f;
			}

			_package.Save();
			_saved = true;
			return _file;
		}

		public byte[] Save()
		{
			
			using (var ms = new MemoryStream())
			{
				_package.SaveAs(ms);
				return ms.ToArray();
			}
		}

		/// <summary>
		///   Set the value for the given cell in the current worksheet
		/// </summary>
		/// <param name="y">The row to effect</param>
		/// <param name="x">The column to effect</param>
		/// <param name="value">The value to put in the cell</param>
		public void SetCellValue(int y, int x, object value)
		{
			try
			{
				_worksheet.Cells[y, x].Value = value;
			}
			catch (Exception e)
			{
				throw e;
			}
		}

		public void DeleteRows(int firstRow, int lastRow)
		{
			for (int j = firstRow; j <= lastRow; ++j)
			{
				for (int i = 0; i < ColCount; ++i)
				{
					_worksheet.Cells[j, i].Formula = "";
				}
			}

			_worksheet.DeleteRow(firstRow, lastRow - firstRow);
		}

		public void DeleteRow(int row)
		{
			_worksheet.DeleteRow(row, 1, true);
		}

		public void SetCellValue(int y, string x, object value)
		{
			try
			{
				_worksheet.Cells[y, char.ToUpper(x[0]) - 64].Value = value;
			}
			catch (Exception e)
			{
				throw e;
			}
		}

		public void SetCellFormula(int y, string x, object value)
		{
			try
			{
				_worksheet.Cells[y, char.ToUpper(x[0]) - 64].Formula = value.ToString();
			}
			catch (Exception e)
			{
				throw e;
			}
		}

		public void SetCellFormula(int y, int x, object value)
		{
			try
			{
				_worksheet.Cells[y, x].Formula = value.ToString();
			}
			catch (Exception e)
			{
				throw e;
			}
		}

		public void SetCellNumber(int y, int x)
		{
			_worksheet.Cells[y, x].Style.Numberformat.Format = "0.00";
		}

		/// <summary>
		/// </summary>
		/// <param name="y">The row to access</param>
		/// <param name="x">The column to access</param>
		/// <returns>The value (as an object) stored in the given cell</returns>
		public object GetCellValue(int y, int x)
		{
			try
			{
				return _worksheet.Cells[y, x].Value;
			}
			catch (Exception e)
			{
				throw e;
			}
		}

		public object GetCellValue(int y, string x)
		{
			try
			{
				return _worksheet.Cells[y, char.ToUpper(x[0]) - 64].Value;
			}
			catch (Exception e)
			{
				throw e;
			}
		}


		public string GetCellText(int y, int x)
		{
			try
			{
				return _worksheet.Cells[y, x].Text;
			}
			catch (Exception e)
			{
				throw e;
			}
		}

		public string GetCellText(int y, string x)
		{
			try
			{
				return _worksheet.Cells[y, char.ToUpper(x[0]) - 64].Text;
			}
			catch (Exception e)
			{
				throw e;
			}
		}

		public void SetCellFontSize(int y, string x, float size)
		{
			try
			{
				_worksheet.Cells[y, char.ToUpper(x[0]) - 64].Style.Font.Size = size;
			}
			catch (Exception e)
			{
				throw e;
			}
		}

		public void SetCellFontSize(int y, int x, float size)
		{
			try
			{
				_worksheet.Cells[y, x].Style.Font.Size = size;
			}
			catch (Exception e)
			{
				throw e;
			}
		}

		/// <summary>
		///   Set the given cell in the current worksheet to bold
		/// </summary>
		/// <param name="y">The row to effect</param>
		/// <param name="x">The column to effect</param>
		public void SetCellBold(int y, int x)
		{
			try
			{
				_worksheet.Cells[y, x].Style.Font.Bold = true;
			}
			catch (Exception e)
			{
				throw e;
			}
		}

		public void SetBackColor(int y, int x, Color color)
		{
			try
			{
				_worksheet.Cells[y, x].Style.Fill.PatternType = ExcelFillStyle.Solid;
				_worksheet.Cells[y, x].Style.Fill.BackgroundColor.SetColor(color);
			}
			catch (Exception e)
			{
				throw e;
			}
		}

		public void SetCellColor(int y, int x, Color color)
		{
			try
			{
				_worksheet.Cells[y, x].Style.Font.Color.SetColor(color);
			}
			catch (Exception e)
			{
				throw e;
			}
		}

		public void SetCellColor(int y, string x, Color color)
		{
			SetCellColor(y, char.ToUpper(x[0]) - 64, color);
		}

		public void SetCellBold(int y, string x)
		{
			SetCellBold(y, char.ToUpper(x[0]) - 64);
		}

		public void SetCellWrap(int y, int x)
		{
			_worksheet.Cells[y, x].Style.WrapText = true;
		}

		public void SetCellWrap(int y, string x)
		{
			SetCellWrap(y, char.ToUpper(x[0]) - 64);
		}

		/// <summary>
		///   Set the given cell in the current worksheet to center
		/// </summary>
		/// <param name="y">The row to effect</param>
		/// <param name="x">The column to effect</param>
		public void SetTextCenterHz(int y, int x)
		{
			try
			{
				_worksheet.Cells[y, x].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
			}
			catch (Exception e)
			{
				throw e;
			}
		}

		/// <summary>
		///   Set the given cell in the current worksheet to right
		/// </summary>
		/// <param name="y">The row to effect</param>
		/// <param name="x">The column to effect</param>
		public void SetTextRightHz(int y, int x)
		{
			try
			{
				_worksheet.Cells[y, x].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
			}
			catch (Exception e)
			{
				throw e;
			}
		}

		/// <summary>
		///   Set the Sheet Name
		/// </summary>
		public void SetSheetName(string sheetName)
		{
			try
			{
				_worksheet.Name = sheetName;
			}
			catch (Exception e)
			{
				throw e;
			}
		}

		/// <summary>
		///   Set a column in the current _worksheet to be in dateformat
		///   Format is given as current short date pattern
		/// </summary>
		/// <param name="col"></param>
		public void SetColumnDate(int col)
		{
			_worksheet.Column(col).Style.Numberformat.Format = DateTimeFormatInfo.CurrentInfo.ShortDatePattern;
		}


		/// <summary>
		///   Set a column background color
		/// </summary>
		/// <param name="col"></param>
		public void SetColumnColor(int col, Color color)
		{
			_worksheet.Column(col).Style.Fill.PatternType = ExcelFillStyle.Solid;
			_worksheet.Column(col).Style.Fill.BackgroundColor.SetColor(color);
		}

		/// <summary>
		///   Set a column width
		/// </summary>
		/// <param name="col"></param>
		public void SetColumnWidth(int col, double width)
		{
			_worksheet.Column(col).Width = width;
		}

		/// <summary>
		///   Set a row background color
		/// </summary>
		/// <param name="col"></param>
		public void SetRowColor(int row, Color? color, Color foreColor)
		{
			
			if (color.HasValue)
			{
				_worksheet.Row(row).Style.Fill.PatternType = ExcelFillStyle.Solid;
				_worksheet.Row(row).Style.Fill.BackgroundColor.SetColor(color.Value);
			}
				
			_worksheet.Row(row).Style.Font.Color.SetColor(foreColor);
		}

		/// <summary>
		///   Set a row height
		/// </summary>
		/// <param name="col"></param>
		public void SetRowHeight(int row, double height)
		{
			_worksheet.Row(row).Height = height;
		}

		/// <summary>
		///   Create a new spreadsheet and store in temporary folder
		/// </summary>
		private void CreateNewSpreadsheet()
		{
			// Ensure temporary folder has been set
			if (string.IsNullOrEmpty(TemporaryPath))
				throw new Exception("TempPath key value has not been set in sharedweb.config file");

			//DirectoryInfo d = CreateTempFolder();
			_file = new FileInfo(TemporaryPath + "/temp.xlsx");

			_package = new ExcelPackage(_file);
			_tempfile = true;
		}

		private DirectoryInfo CreateTempFolder()
		{
			// Ensure temporary folder has been set
			if (string.IsNullOrEmpty(TemporaryPath))
				throw new Exception("TempPath key value has not been set in sharedweb.config file");

			string temporaryFilePath = TemporaryPath;
			string subPath = Guid.NewGuid().ToString();
			DirectoryInfo d = Directory.CreateDirectory(temporaryFilePath + subPath);
			return d;
		}

		public void AddWorksheet(string title)
		{
			_package.Workbook.Worksheets.Add(title);
			SetCurrentWorksheet(title);
		}
		/// <summary>
		///   Set the current worksheet being accessed by the class
		/// </summary>
		/// <param name="id"></param>
		/// <returns></returns>
		public bool SetCurrentWorksheet(int id)
		{
			try
			{
				if (_package.Workbook.Worksheets.Count >= id)
				{
					_worksheet = _package.Workbook.Worksheets[id];
				}
				return true;
			}
			catch (Exception)
			{
				return false;
			}
		}

		public bool SetCurrentWorksheet(string title)
		{
			try
			{
				_worksheet = _package.Workbook.Worksheets[title];
				return true;
			}
			catch (Exception)
			{
				return false;
			}
		}

		public string GetCurrentWorkSheetName()
		{
			return _worksheet.Name;
		}

		public int GetWorkSheetCount()
		{
			return _package.Workbook.Worksheets.Count;
		}

		/// <summary>
		///   Inserts new row after the given cell in the current worksheet
		/// </summary>
		/// <param name="y">The row to effect</param>
		public bool InsertNewRow(int y)
		{
			try
			{
				_worksheet.InsertRow(y, 1);
				return true;
			}
			catch
			{
				return false;
			}
		}

		/// <summary>
		///   The cells in the range are merged
		/// </summary>
		/// <param name="strMergeRange">Merge Range</param>
		public bool MergeCells(string strMergeRange)
		{
			try
			{
				_worksheet.Cells[strMergeRange].Merge = true;
				return true;
			}
			catch (Exception e)
			{
				return false;
				throw e;
			}
		}

		/// <summary>
		///   The cells in the range are merged
		/// </summary>
		/// <param name="FromRow">FromRow</param>
		/// <param name="FromCol">FromCol</param>
		/// <param name="ToRow">ToRow</param>
		/// <param name="ToCol">ToCol</param>
		public bool MergeCells(int FromRow, int FromCol, int ToRow, int ToCol)
		{
			try
			{
				//_worksheet.Cells["A1:C1"].Merge = true;
				//return true;
				using (ExcelRange excelRange = _worksheet.Cells[FromRow, FromCol, ToRow, ToCol])
				{
					return excelRange.Merge;
				}
			}
			catch (Exception e)
			{
				return false;
				throw e;
			}
		}

		/// <summary>
		///   Return the file as a stream of bytes
		///   Useful for returning to browser
		/// </summary>
		/// <returns></returns>
		public byte[] ReadFile()
		{
			FileInfo fi = null;
			FileStream f;
			if (_tempfile)
			{
				if (!_saved)
					Save();
				f = _file.OpenRead();
			}
			else
			{
				fi = Save(CreateTempFolder().FullName + "\\temp.xlsx");
				f = fi.OpenRead();
			}

			var b = new byte[f.Length];
			f.Read(b, 0, (int) f.Length);
			f.Close();
			if (fi != null && fi.Directory != null)
			{
				fi.Directory.Delete(true);
			}
			return b;
		}

		/// <summary>
		///   Delete the file created by the constructor (doesn't remove any files saved with saveas
		/// </summary>
		private void DeleteCreatedFile()
		{
			if (_package != null && _file != null && _file.DirectoryName != null && Directory.Exists(_file.DirectoryName))
			{
				try
				{
					Directory.Delete(_file.DirectoryName, true);
				}
				catch (Exception)
				{
				}
			}
		}

		/// <summary>
		///   Close the excel package opened and delete any temporary files
		/// </summary>
		private void Close()
		{
			if (_package != null)
			{
				if (_tempfile)
					DeleteCreatedFile();
				_package.Dispose();
				_package = null;
				_worksheet = null;
				_file = null;
			}
		}

		// Implement IDisposable. 

		// Dispose(bool disposing) executes in two distinct scenarios. 
		// If disposing equals true, the method has been called directly 
		// or indirectly by a user's code. Managed and unmanaged resources 
		// can be disposed. 
		// If disposing equals false, the method has been called by the 
		// runtime from inside the finalizer and you should not reference 
		// other objects. Only unmanaged resources can be disposed. 
		protected virtual void Dispose(bool disposing)
		{
			// Check to see if Dispose has already been called. 
			if (!_disposed)
			{
				// If disposing equals true, dispose all managed 
				// and unmanaged resources. 
				if (disposing)
				{
					Close();
				}

				// Call the appropriate methods to clean up 
				// unmanaged resources here. 
				// If disposing is false, 
				// only the following code is executed.

				// Note disposing has been done.
				_disposed = true;
			}
		}

		~Excel()
		{
			// Do not re-create Dispose clean-up code here. 
			// Calling Dispose(false) is optimal in terms of 
			// readability and maintainability.
			Dispose(false);
		}
	}
}