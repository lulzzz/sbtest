﻿using System;
using System.Collections.Generic;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;

namespace HrMaxx.Common.Contracts.Services
{
	public interface IDocumentService
	{
		FileDto GetDocument(Guid documentID);
		IList<DocumentDto> GetAllDocuments();
		void MoveDocument(MoveDocumentDto document, bool addWatermark = false);
		byte[] GetFileBytesByPath(string documentPath);
		string CreateDirectory(string dirName);
		void DeleteDirectory(string dirName);
		void CopyFile(string source, string destination);
		byte[] ZipDirectory(string source, string fileName);
		IList<string> GetStoredFiles();
		void MoveAnnotatedDocument(MoveDocumentDto moveDocumentDto);
		void SaveUserImage(string user, string image);
		void MoveDocument(MoveDocumentDto document, DateTime lastModified, bool addWatermark = false);

		IList<DocumentDto> GetEntityDocuments(int entityType, Guid entityId);
		DocumentDto AddEntityDocument(EntityDocumentAttachment document);
		void DeleteEntityDocument(int entityTypeId, Guid entityId, Guid documentId);
	}
}