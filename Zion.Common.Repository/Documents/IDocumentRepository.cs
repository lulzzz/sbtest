using System;
using System.Collections.Generic;
using HrMaxx.Common.Models.Dtos;

namespace HrMaxx.Common.Repository.Documents
{
	public interface IDocumentRepository
	{
		DocumentDto GetDocument(Guid documentID);
		EntityIDDto SaveDocument(SaveDocumentDto document);
		void DeleteDocument(Guid documentId);
		List<DocumentDto> GetAllDocuments();
	}
}