using System;
using System.Collections.Generic;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;

namespace HrMaxx.Common.Contracts.Services
{
	public interface IDocumentService
	{
		FileDto GetDocument(Guid documentID);
		
		void MoveDocument(MoveDocumentDto document, bool addWatermark = false);
		byte[] GetFileBytesByPath(string documentPath);
		string CreateDirectory(string dirName);
		void DeleteDirectory(string dirName);
		void CopyFile(string source, string destination);
		byte[] ZipDirectory(string source, string fileName, bool delete = true);
		IList<string> GetStoredFiles();
		void MoveAnnotatedDocument(MoveDocumentDto moveDocumentDto);
		void SaveUserImage(string user, string image);
		void MoveDocument(MoveDocumentDto document, DateTime lastModified, bool addWatermark = false);

        Document AddEntityDocument(EntityDocumentAttachment document);
        void DeleteEntityDocument(int entityTypeId, Guid entityId, Guid documentId);
		FileDto GetDocumentById(Guid documentId, string extension , string fileName);

        void DeleteEmployeeDocument(Guid employeeId, Guid documentId);
        void PurgeDocuments(int days);
    }
}