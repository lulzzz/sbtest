using System;
using System.Collections.Generic;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using Magnum;
using Persits.PDF;

namespace HrMaxx.Common.Services.PDF
{
	public class PDFService : BaseService, IPDFService
	{
		private readonly IDocumentService _documentService;
		private readonly IFileRepository _fileRepository;
		private readonly string _filePath;
		private readonly string _templatePath;

		public PDFService(IDocumentService documentService, IFileRepository fileRepository, string filePath, string templatePath)
		{
			_documentService = documentService;
			_fileRepository = fileRepository;
			_filePath = filePath;
			_templatePath = templatePath;
		}

		public FileDto Print(PDFModel model)
		{
			try
			{
				PdfManager objPDF = new PdfManager();

				// Create new document.
				var objDoc = objPDF.OpenDocument(_templatePath + model.Template);
				
				// Obtain font.
				var objFont = objDoc.Fonts["Helvetica"];
				var objFontBold = objDoc.Fonts["Helvetica-Bold"];
				objDoc.Form.RemoveXFA();
				foreach (var field in model.NormalFontFields)
				{
					if (field.Key.Equals("MICR"))
					{
						var micrFont = objDoc.Fonts.LoadFromFile(_templatePath + "micro.ttf");
						var objField = objDoc.Form.FindField(field.Key);
						if (objField != null)
							objField.SetFieldValue(field.Value, micrFont);
					}
					else
					{
						var objField = objDoc.Form.FindField(field.Key);
						if (objField != null)
							objField.SetFieldValue(field.Value, objFont);	
					}
					
				}
				foreach (var field in model.BoldFontFields)
				{
						var objField = objDoc.Form.FindField(field.Key);
						if (objField != null)
							objField.SetFieldValue(field.Value, objFontBold);
				}
				

				// Save, generate unique file name to avoid overwriting existing file.
				string strFilename = objDoc.Save(string.Format("{0}{1}", _filePath, model.Name), false);
				objDoc.Close();
				Guid target = Guid.Empty;
				int test = 0;
				;
				var pdfdoc = new EntityDocumentAttachment
				{
					EntityId	= Guid.TryParse(model.TargetId.ToString(), out target)? target : int.TryParse(model.TargetId.ToString(), out test) ? Int2Guid(test) : CombGuid.Generate(),
					EntityTypeId = (int)model.TargetType,
					FileExtension = "PDF",
					MimeType = "application/pdf",
					OriginalFileName = model.Name.Split('.')[0],
					SourceFileName = strFilename
				};
				var doc = _documentService.AddEntityPDF(pdfdoc, model.DocumentId);
				return _documentService.GetDocument(doc.Id);

			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX, " Print PDF for " + model.TargetId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public FileDto AppendAllDocuments(Guid identifier, string fileName, List<Guid> documents)
		{
			try
			{
				PdfManager objPDF = new PdfManager();
				// Create new document.
				var objDoc = objPDF.CreateDocument();
				var pdfPath = _filePath.Replace("PDFTemp/", string.Empty);
				foreach (var document in documents)
				{
					var pdf = objPDF.OpenDocument(pdfPath + document + ".pdf");
					objDoc.AppendDocument(pdf);
				}
				string strFilename = objDoc.Save(string.Format("{0}{1}", _filePath, fileName), true);
				objDoc.Close();
				var fileData = _documentService.GetFileBytesByPath(string.Format("{0}{1}", _filePath, fileName));
				_fileRepository.DeleteTargetFile(string.Format("{0}{1}", _filePath, fileName));
				return new FileDto
				{
					DocumentId = identifier,
					Data = fileData,
					Filename = fileName.Split('.')[0],
					DocumentExtension = ".pdf",
					MimeType = "application/pdf"
				};
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX, " Print PDF for " +fileName);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private Guid Int2Guid(int value)
		{
			byte[] bytes = new byte[16];
			BitConverter.GetBytes(value).CopyTo(bytes, 0);
			return new Guid(bytes);
		}
	}
}