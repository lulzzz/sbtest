using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using Magnum;
using Magnum.Extensions;
using PdfSharp.Pdf.IO;
using Persits.PDF;
using PdfDocument = Persits.PDF.PdfDocument;
using PdfReader = PdfSharp.Pdf.IO.PdfReader;

namespace HrMaxx.Common.Services.PDF
{
	public class PDFService : BaseService, IPDFService
	{
		
		private readonly string _filePath;
		private readonly string _templatePath;
		private const string ReportNotAvailable = "The report template is not available yet";

		public PDFService(string filePath, string templatePath)
		{
			_filePath = filePath;
			_templatePath = templatePath;
		}

		public FileDto Print(string fileName, List<PDFModel> models)
		{
			try
			{
				var returnDoc = new PdfSharp.Pdf.PdfDocument();
				var objPDF = new PdfManager();
				var docs = new List<FileDto>();
				models.ForEach(model =>
				{
					var objDoc = objPDF.OpenDocument(_templatePath + model.Template);
					var objFont = objDoc.Fonts["Helvetica"];
					var objFontBold = objDoc.Fonts["Helvetica-Bold"];
					// Obtain font.
					
					objDoc.Form.RemoveXFA();
					var fileFields = objDoc.Form.Fields;
					for (var m = 1; m <= fileFields.Count; m++)
					{
						var objField = fileFields[m];
						var normalField = model.NormalFontFields.FirstOrDefault(nf => nf.Key.ToLower().Equals(objField.FieldName.ToLower()));
 						var boldField = model.BoldFontFields.FirstOrDefault(nf => nf.Key.ToLower().Equals(objField.FieldName.ToLower()));
						if (normalField.Key!=null && normalField.Value!=null)
						{
							if (normalField.Key.Equals("MICR"))
							{
								var micrFont = objDoc.Fonts.LoadFromFile(_templatePath + "micro.ttf");
								objField.SetFieldValue(normalField.Value, micrFont);
							}
							else
							{
								objField.SetFieldValue(normalField.Value, objFont);
								
							}	
						}
						else if (boldField.Key != null && boldField.Value != null)
						{
							objField.SetFieldValue(boldField.Value, objFontBold);
						}
						else
						{
							if (string.IsNullOrWhiteSpace(objField.FieldValue))
								objField.SetFieldValue(string.Empty, objFont);	
						}
					}
					
					if (model.Signature != null)
					{
						var sign = objDoc.OpenImage(model.Signature.Path);
						var page = objDoc.Pages[1];
						var param = objPDF.CreateParam();

						param["x"] = model.Signature.X;
						param["y"] = model.Signature.Y;
						param["ScaleX"] = model.Signature.ScaleX;
						param["ScaleY"] = model.Signature.ScaleY;
						page.Canvas.DrawImage(sign, param);
					}
					docs.Add(new FileDto(){Data=objDoc.SaveToMemory()}); 
					objDoc.Close();
					
					

				});
				return AppendAllDocuments(Guid.Empty, fileName, docs);
				}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX, " Print multi page PDF" );
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public FileDto Print(PDFModel model)
		{
			try
			{
				var objPDF = new PdfManager();

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
						if (objField != null && field.Value!=null)
							objField.SetFieldValue(field.Value, objFont);	
					}
					
				}
				foreach (var field in model.BoldFontFields)
				{
						var objField = objDoc.Form.FindField(field.Key);
						if (objField != null)
							objField.SetFieldValue(field.Value, objFontBold);
				}

				if (model.Signature != null)
				{
					var sign = objDoc.OpenImage(model.Signature.Path);
					var page = objDoc.Pages[1];
					var param = objPDF.CreateParam();

					param["x"] = model.Signature.X;
					param["y"] = model.Signature.Y;
					param["ScaleX"] = model.Signature.ScaleX;
					param["ScaleY"] = model.Signature.ScaleY;
					page.Canvas.DrawImage(sign, param);
				}
				
				string strFilename = string.Format("{0}", model.Name);
				var content = objDoc.SaveToMemory();
				objDoc.Close();
				

				return new FileDto
				{
					Data = content,
					Filename = strFilename.Split('.')[0],
					DocumentExtension = ".pdf",
					MimeType = "application/pdf"
				};

			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX, " Print PDF for " + model.TargetId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		public FileDto AppendAllDocuments(Guid identifier, string fileName, List<FileDto> documents)
		{
			try
			{
				var docs = new List<PdfSharp.Pdf.PdfDocument>();
				var pdfPath = _filePath.Replace("PDFTemp/", string.Empty);
				var objDoc = new PdfSharp.Pdf.PdfDocument();
				var docCount = 0;
				foreach (var document in documents)
				{
					using (var stream = new MemoryStream(document.Data))
					{
						var objDoc1 = PdfReader.Open(stream, PdfDocumentOpenMode.Import);
						int count = objDoc1.PageCount;
						for (int idx = 0; idx < count; idx++)
						{
							var page = objDoc1.Pages[idx];
							objDoc.AddPage(page);
							//objDoc.InsertPage(docCount, page);
						}
						docCount++;
					}
					
				}
				byte[] fileContents = null;

				using (var stream = new MemoryStream())
				{
					objDoc.Save(stream, true);
					fileContents = stream.ToArray();
				}
				return new FileDto
				{
					Data = fileContents,
					Filename = fileName.Split('.')[0],
					DocumentExtension = ".pdf",
					MimeType = "application/pdf"
				};

			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX, " Print PDF for " + fileName);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		public FileDto AppendAllDocuments(Guid identifier, string fileName, List<Guid> documents, byte[] data)
		{
			try
			{
				//var docs = new List<PdfDocument>();
				//var objPDF = new PdfManager();
				//// Create new document.
				//var objDoc = objPDF.CreateDocument();
				//var pdfPath = _filePath.Replace("PDFTemp/", string.Empty);
				
				//if(data.Length>0)
				//	objDoc.AppendDocument(objPDF.OpenDocument(data));
				
				//foreach (var document in documents)
				//{
				//	var objDoc1 = objPDF.OpenDocument(pdfPath + document + ".pdf");
				//	docs.Add(objDoc1);
				//	objDoc.AppendDocument(objDoc1);
				//}
				//var resultBytes = objDoc.SaveToMemory();
				
				//objDoc.Close();
				//docs.ForEach(d => d.Close());
				
				//return new FileDto
				//{
				//	Data = resultBytes,
				//	Filename = fileName.Split('.')[0],
				//	DocumentExtension = ".pdf",
				//	MimeType = "application/pdf"
				//};

				
				var docs = new List<PdfSharp.Pdf.PdfDocument>();
				var objDoc = new PdfSharp.Pdf.PdfDocument();
				var pdfPath = _filePath.Replace("PDFTemp/", string.Empty);
				var docCount = 1;
				foreach (var document in documents)
				{
					var objDoc1 = PdfReader.Open(pdfPath + document + ".pdf", PdfDocumentOpenMode.Import);
					int count = objDoc1.PageCount;
					for (int idx = 0; idx < count; idx++)
					{
						var page = objDoc1.Pages[idx];
						objDoc.InsertPage(docCount, page);
					}
					docCount++;
				}
				var payrollFile = pdfPath + identifier + ".pdf";
				//objDoc.Save(payrollFile);

				//byte[] fileContents = _fileRepository.GetFileBytesByPath(payrollFile);
				byte[] fileContents = null;

				using (var stream = new MemoryStream())
				{
					objDoc.Save(stream, true);
					fileContents = stream.ToArray();
				}
				return new FileDto
				{
					Data = fileContents,
					Filename = fileName.Split('.')[0],
					DocumentExtension = ".pdf",
					MimeType = "application/pdf"
				};
				

				/* iTextsharp printing
				var outputMS = new MemoryStream();
				var document = new iTextSharp.text.Document();
				var writer = new PdfCopy(document, outputMS);
				PdfImportedPage page = null;
				var pdfPath = _filePath.Replace("PDFTemp/", string.Empty);
				document.Open();

				foreach (var doc in documents)
				{
					var reader = new iTextSharp.text.pdf.PdfReader(pdfPath + doc + ".pdf");
					int n = reader.NumberOfPages;

					for (int i = 1; i <= n; i++)
					{
						page = writer.GetImportedPage(reader, i);
						writer.AddPage(page);
					}

					//PRAcroForm form = reader.AcroForm;
					//if (form != null)
					//	writer.CopyDocumentFields(reader);
				}

				document.Close();
				return new FileDto
				{
					Data = outputMS.ToArray(),
					Filename = fileName.Split('.')[0],
					DocumentExtension = ".pdf",
					MimeType = "application/pdf"
				};
				 */
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX, " Print PDF for " +fileName);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public FileDto PrintReport(ReportTransformed pdfModels, bool saveToDisk = false)
		{
			try
			{
				var objPDF = new PdfManager();
				var counter = 0;
				PdfDocument objDoc = objPDF.CreateDocument();
				var docs = new List<FileDto>();
				foreach (var report in pdfModels.Reports)
				{
					
					if (!string.IsNullOrWhiteSpace(report.ReportType) && report.ReportType.ToLower().Equals("html"))
					{
						objDoc.ImportFromUrl(report.HtmlData.OuterXml);
					}
					else
					{
						objDoc = objPDF.OpenDocument(_templatePath + report.TemplatePath + report.Template);
						if (objDoc == null)
							throw new Exception(ReportNotAvailable);
						// Obtain font.
						var objFont = objDoc.Fonts["Helvetica"];
						//objDoc.Form.RemoveXFA();
						foreach (var field in report.Fields)
						{
							if (field.Type.Equals("Bullet") && !string.IsNullOrWhiteSpace(field.Value) && !string.IsNullOrWhiteSpace(field.Name))
							{
								var bullet = objDoc.OpenImage(_templatePath + "colored bullet.bmp");
								var page = objDoc.Pages[1];
								var param = objPDF.CreateParam();

								param["x"] = (float)Convert.ToDouble(field.Name);
								param["y"] = (float)Convert.ToDouble(field.Value);
								param["ScaleX"] = (float)0.7;
								param["ScaleY"] = (float)0.7;
								page.Canvas.DrawImage(bullet, param);
							}
							else
							{
								var objField = objDoc.Form.FindField(field.Name);
								if (objField != null)
								{
									if (field.Type == "Text")
									{
										objField.SetFieldValue(field.Value.Replace("\\N", Environment.NewLine).Replace("\\n", Environment.NewLine), objFont);
									}
									else
									{
										if (!string.IsNullOrWhiteSpace(field.Value) && (field.Value.ToLower().Equals("on") || field.Value.ToLower().Equals("yes")))
										{
											objField.SetFieldValue(objField.FieldOnValue, null);
										}

									}
								}
							}


						}
					}
					docs.Add(new FileDto{Data= objDoc.SaveToMemory()});
					
					objDoc.Close();
					objDoc.Dispose();
					
					counter++;
				}
				return AppendAllDocuments(Guid.Empty, pdfModels.Name, docs);
				
			}
			catch (Exception e)
			{
				var message = string.Empty;
				if (e.Message == ReportNotAvailable)
					message = e.Message;
				else
					message = string.Format(CommonStringResources.ERROR_FailedToSaveX, " Print PDF for report");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public FileDto GetTemplateFile(string baseFile, int year, string name)
		{
			var objPDF = new PdfManager();
			try
			{
				var objDoc = objPDF.OpenDocument(string.Format("{2}{0}-{1}.pdf", baseFile, year, _templatePath));
				var bytes = objDoc.SaveToMemory();
				return new FileDto
				{
					Data = bytes,
					Filename = string.Format("Result-{0}{1}", name, DateTime.Now.Millisecond),
					DocumentExtension = ".pdf",
					MimeType = "application/pdf"
				};
			}
			catch (Exception)
			{
			}
			
			
				var objDoc1 = objPDF.OpenDocument(string.Format("{1}{0}.pdf", baseFile, _templatePath));
				var bytes1 = objDoc1.SaveToMemory();
				return new FileDto
				{
					Data = bytes1,
					Filename = string.Format("Result-{0}{1}", name, DateTime.Now.Millisecond),
					DocumentExtension = ".pdf",
					MimeType = "application/pdf"
				};
			
		}

		public FileDto PrintHtml(Report report)
		{
			try
			{
				var objPDF = new PdfManager();
				var objDoc = objPDF.CreateDocument();
				var param = objPDF.CreateParam();

				
				param["RightMargin"] = (float)20;
				param["LeftMargin"] = (float)20;
				
				if (report.ReportType.ToLower().Equals("html"))
				{
					objDoc.ImportFromUrl(report.HtmlData.OuterXml, param);
					
				}
				
				var result = objDoc.SaveToMemory();

					objDoc.Close();
					objDoc.Dispose();

				return new FileDto
				{
					Data = result,
					Filename = report.Template,
					DocumentExtension = ".pdf",
					MimeType = "application/pdf"
				};
			}
			catch (Exception e)
			{
				var message = string.Empty;
				if (e.Message == ReportNotAvailable)
					message = e.Message;
				else
					message = string.Format(CommonStringResources.ERROR_FailedToSaveX, " Print PDF for report");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public FileDto PrintHtmls(List<Report> reports)
		{
			try
			{
				var objPDF = new PdfManager();
				var finalDoc = objPDF.CreateDocument();
				var param = objPDF.CreateParam();


				param["RightMargin"] = (float)20;
				param["LeftMargin"] = (float)20;

				reports.ForEach(r =>
				{
					var objDoc = objPDF.CreateDocument();
					if (r.ReportType.ToLower().Equals("html"))
					{
						objDoc.ImportFromUrl(r.HtmlData.OuterXml, param);
						
					}
					var result = objDoc.SaveToMemory();

					objDoc.Close();
					objDoc.Dispose();
					finalDoc.AppendDocument(objPDF.OpenDocument(result));
				});
				
				return new FileDto
				{
					Data = finalDoc.SaveToMemory(),
					Filename = reports.First().Template,
					DocumentExtension = ".pdf",
					MimeType = "application/pdf"
				};
			}
			catch (Exception e)
			{
				var message = string.Empty;
				if (e.Message == ReportNotAvailable)
					message = e.Message;
				else
					message = string.Format(CommonStringResources.ERROR_FailedToSaveX, " Print PDF for report");
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