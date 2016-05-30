using System;
using System.Collections.Generic;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Repository.Documents;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;

namespace HrMaxx.Common.Services.Document
{
	public class DocumentService : BaseService, IDocumentService
	{
		private readonly IDocumentRepository _documentRepository;
		private readonly IFileRepository _fileRepository;

		public DocumentService(IFileRepository fileRepository, IDocumentRepository documentRepository)
		{
			_fileRepository = fileRepository;
			_documentRepository = documentRepository;
		}

		public List<DocumentDto> GetAllDocuments()
		{
			try
			{
				return _documentRepository.GetAllDocuments();
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, " all documents");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public DocumentDto GetDocumentInfo(Guid documentID)
		{
			try
			{
				DocumentDto document = _documentRepository.GetDocument(documentID);
				document.DocumentPath = _fileRepository.GetDocumentLocation(document.DocumentPath);
				return document;
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, "Document");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public EntityIDDto SaveDocument(SaveDocumentDto document)
		{
			try
			{
				if (document.FileName.ToLower().Contains(".jpg") || document.FileName.ToLower().Contains(".jpeg") ||
				    document.FileName.ToLower().Contains(".png") || document.FileName.ToLower().Contains(".gif") ||
				    document.FileName.ToLower().Contains(".tif") || document.FileName.ToLower().Contains(".tiff") ||
				    document.FileName.ToLower().Contains(".bmp"))
				{
					document.FileName = document.FileName.Split('.')[0] + ".jpg";
				}
				return _documentRepository.SaveDocument(document);
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX, "Document");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void MoveDocument(MoveDocumentDto document, bool addWatermark = false)
		{
			
					_fileRepository.MoveFile(document.SourceFileName, document.DestinationFileName);
			
		}


		public FileDto GetDocument(Guid documentID)
		{
			try
			{
				DocumentDto document = _documentRepository.GetDocument(documentID);
				byte[] fileData = _fileRepository.GetFile(documentID + "." + document.DocumentExtension);
				return new FileDto
				{
					DocumentId = documentID,
					Data = fileData,
					Filename = document.Filename,
					DocumentExtension = document.DocumentExtension
				};
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, "File");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public byte[] GetFileBytesByPath(string documentPath)
		{
			try
			{
				return _fileRepository.GetFileBytesByPath(documentPath);
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, "File");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void DeleteDestinationFile(string documentPath)
		{
			try
			{
				_fileRepository.DeleteDestinationFile(documentPath);
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, "File");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public string CreateDirectory(string dirName)
		{
			return _fileRepository.CreateDirectory(dirName);
		}

		public void DeleteDirectory(string dirName)
		{
			_fileRepository.DeleteDirectory(dirName);
		}

		public void CopyFile(string source, string destination)
		{
			_fileRepository.CopyFile(source, destination);
		}

		public byte[] ZipDirectory(string source, string fileName)
		{
			return _fileRepository.ZipDirectory(source, fileName);
		}

		public List<string> GetStoredFiles()
		{
			return _fileRepository.GetDirectoryFiles();
		}

		public void MoveAnnotatedDocument(MoveDocumentDto document)
		{
			try
			{
				_fileRepository.MoveDestinationFile(document.SourceFileName, document.DestinationFileName);
			}
			catch (Exception e)
			{
				string message = CommonStringResources.ERROR_FailedToMoveDocument;
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void SaveUserImage(string user, string image)
		{
			try
			{
				_fileRepository.SaveUserImage(user, image.Substring(image.IndexOf(", ") + 1));
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX, " user's image");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void MoveDocument(MoveDocumentDto document, DateTime lastModified, bool addWatermark = false)
		{
			
					_fileRepository.MoveFile(document.SourceFileName, document.DestinationFileName);
			
		}

		public void DeleteDocument(Guid documentId)
		{
			try
			{
				_documentRepository.DeleteDocument(documentId);
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX, " delete document");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

	
	}
}