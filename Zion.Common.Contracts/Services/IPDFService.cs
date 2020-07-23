using System;
using System.Collections.Generic;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Mementos;

namespace HrMaxx.Common.Contracts.Services
{
	public interface IPDFService
	{
		FileDto Print(string fileName, List<PDFModel> models);
		FileDto Print(PDFModel model);
		FileDto AppendAllDocuments(Guid name, string fileName, List<Guid> documents, byte[] data);
		FileDto PrintReport(ReportTransformed pdfModels, bool saveToDisk = false, string path = "");
		FileDto GetTemplateFile(string baseFile, int year, string w4);
		FileDto PrintHtml(Report report);
		FileDto PrintHtmls(List<Report> reports, bool saveToDisk, string path);
		FileDto AppendAllDocuments(Guid name, string fileName, List<FileDto> documents, bool saveToDisk = false, string path = "");
		void PrintPayrollPack(string dir, List<PDFModel> models);
	}
}