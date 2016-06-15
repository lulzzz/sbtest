using System;
using System.Collections.Generic;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.Infrastructure.Transactions;
using MassTransit.Configurators;

namespace HrMaxx.Common.Services.Document
{
	public class DocumentService : BaseService, IDocumentService
	{
		private readonly ICommonService _commonService;
		private readonly IFileRepository _fileRepository;

		public DocumentService(IFileRepository fileRepository, ICommonService commonService)
		{
			_fileRepository = fileRepository;
			_commonService = commonService;
		}

		public IList<DocumentDto> GetAllDocuments()
		{
			try
			{
				return _commonService.GetAllTargets<DocumentDto>(EntityTypeEnum.Document);
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, " all documents");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

	

		public void MoveDocument(MoveDocumentDto document, bool addWatermark = false)
		{
			
					_fileRepository.MoveFile(document.SourceFileName, document.DestinationFileName);
			
		}


		public FileDto GetDocument(Guid documentId)
		{
			try
			{
				var document = _commonService.GetTargetEntity<DocumentDto>(EntityTypeEnum.Document, documentId);
				byte[] fileData = _fileRepository.GetFile(documentId + "." + document.DocumentExtension);
				return new FileDto
				{
					DocumentId = documentId,
					Data = fileData,
					Filename = document.Filename,
					DocumentExtension = document.DocumentExtension,
					MimeType = document.MimeType
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

		public IList<string> GetStoredFiles()
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

		public IList<DocumentDto> GetEntityDocuments(int entityType, Guid entityId)
		{
			try
			{
				return _commonService.GetRelatedEntities<DocumentDto>((EntityTypeEnum) entityType, EntityTypeEnum.Document,
					entityId);
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, string.Format(" get documents for entity {0} {1}", entityType, entityId));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public DocumentDto AddEntityDocument(EntityDocumentAttachment doc)
		{
			try
			{
				DocumentDto document = Mapper.Map<EntityDocumentAttachment, DocumentDto>(doc);
				
				using (var txn = TransactionScopeHelper.Transaction())
				{
					MoveDocument(new MoveDocumentDto
					{
						SourceFileName = doc.SourceFileName,
						DestinationFileName = document.Id + "." + doc.FileExtension
					});
					_commonService.AddEntityRelation<DocumentDto>((EntityTypeEnum) doc.EntityTypeId, EntityTypeEnum.Document, doc.EntityId,
						document);
					txn.Complete();
				}
				return document;

			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX, string.Format(" save document for entity {0}-{1}", doc.EntityTypeId, doc.EntityId));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void DeleteEntityDocument(int entityTypeId, Guid entityId, Guid documentId)
		{
			try
			{
				var doc = _commonService.GetTargetEntity<DocumentDto>(EntityTypeEnum.Document, documentId);
				_commonService.DeleteEntityRelation((EntityTypeEnum)entityTypeId, EntityTypeEnum.Document, entityId, documentId);
				_fileRepository.DeleteDestinationFile(doc.Id + "." + doc.DocumentExtension);
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX, string.Format(" save document for entity {0}-{1}-{2}", entityTypeId, entityId, documentId));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}


	
	}
}