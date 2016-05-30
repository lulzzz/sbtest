using System;
using System.Collections.Generic;
using HrMaxx.Common.Models.Dtos;

namespace HrMaxx.Common.Contracts.Services
{
	public interface IDocumentService
	{
		FileDto GetDocument(Guid documentID);
		List<DocumentDto> GetAllDocuments();
		DocumentDto GetDocumentInfo(Guid documentID);
		EntityIDDto SaveDocument(SaveDocumentDto document);
		void MoveDocument(MoveDocumentDto document, bool addWatermark = false);
		byte[] GetFileBytesByPath(string documentPath);
		void DeleteDestinationFile(string documentPath);
		string CreateDirectory(string dirName);
		void DeleteDirectory(string dirName);
		void CopyFile(string source, string destination);
		byte[] ZipDirectory(string source, string fileName);
		void DeleteDocument(Guid documentId);
		List<string> GetStoredFiles();
		void MoveAnnotatedDocument(MoveDocumentDto moveDocumentDto);
		void SaveUserImage(string user, string image);
		void MoveDocument(MoveDocumentDto document, DateTime lastModified, bool addWatermark = false);
	}
}