using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Infrastructure.Mapping;
using Magnum;


namespace HrMaxx.Common.Repository.Documents
{
	public class DocumentRepository : IDocumentRepository
	{
		private readonly CommonEntities _dbContext;
		private readonly IMapper _mapper;

		public DocumentRepository(IMapper mapper, CommonEntities dbContext)
		{
			_mapper = mapper;
			_dbContext = dbContext;
		}

		public DocumentDto GetDocument(Guid documentID)
		{
			Document document = _dbContext.Documents.FirstOrDefault(id => id.DocumentID.Equals(documentID));
			return _mapper.Map<Document, DocumentDto>(document);
		}

		public EntityIDDto SaveDocument(SaveDocumentDto document)
		{
			string[] filename = document.FileName.Split('.');

			var doc = new Document {DocumentID = CombGuid.Generate(), DocumentName = filename[0], DocumentExt = filename[1]};

			_dbContext.Documents.Add(doc);
			_dbContext.SaveChanges();

			Guid SavedID = doc.DocumentID;

			return new EntityIDDto {ID = SavedID};
		}

		public List<DocumentDto> GetAllDocuments()
		{
			List<Document> documents = _dbContext.Documents.ToList();
			return _mapper.Map<List<Document>, List<DocumentDto>>(documents);
		}

		public void DeleteDocument(Guid documentId)
		{
			Document document = _dbContext.Documents.FirstOrDefault(d => d.DocumentID.Equals(documentId));
			if (document != null)
			{
				_dbContext.Documents.Remove(document);
				_dbContext.SaveChanges();
			}
		}
	}
}