using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using Newtonsoft.Json;

namespace HrMaxx.Common.Models
{
	public class DocumentType
	{
		public int Id { get; set; }
		public string Name { get; set; }
		public int Category { get; set; }
		public Enum.DocumentCategory DocCategoryType { get { return (DocumentCategory) Category; } }
		public bool CollectMetaData { get; set; }
		public bool RequiresSubTypes { get; set; }
	}

	public class CompanyDocumentSubType
	{
		public int Id { get; set; }
		public string Name { get; set; }
		public DocumentType Category { get; set; }
		public bool IsEmployeeRequired { get; set; }
		public bool TrackAccess { get; set; }
		public Guid CompanyId { get; set; }
		
	}

	public class EmployeeDocument
	{
		public int Id { get; set; }
		public CompanyDocumentSubType SubType { get; set; }
		public Guid EmployeeId { get; set; }
		public Guid CompanyId { get; set; }
		public DateTime DateUploaded { get; set; }
		public string UploadedBy { get; set; }
		public Guid? DocumentId { get; set; }
	}

	public class EmployeeDocumentAccess
	{
		public int Id { get; set; }
		public CompanyDocumentSubType Type { get; set; }
		public Guid EmployeeId { get; set; }
		public Guid DocumentId { get; set; }
		public DateTime FirstAccessed { get; set; }
		public DateTime LastAccessed { get; set; }
	}

	public class DocumentServiceMetaData
	{
		public List<DocumentType> Types { get; set; }
		public List<CompanyDocumentSubType> CompanyDocumentSubTypes { get; set; }
		public List<EntityRelationDocument> Docs { get; set; }

		public List<DocumentDto> Documents
		{
			get
			{
				var docs = Docs.Select(d => d.Document).ToList();
				docs.ForEach(d=>d.Type = Types.First(c=>c.Id==(int)d.DocumentType));
				return docs;
			}
		}
	}

	public class EntityRelationDocument
	{
		public int EntityRelationId { get; set; }
		public int SourceEntityTypeId { get; set; }
		public int TargetEntityTypeId { get; set; }
		public System.Guid SourceEntityId { get; set; }
		public System.Guid TargetEntityId { get; set; }
		public string TargetObject { get; set; }

		public DocumentDto Document
		{
			get
			{
				return JsonConvert.DeserializeObject<DocumentDto>(TargetObject);
			}
		}
	}
}
