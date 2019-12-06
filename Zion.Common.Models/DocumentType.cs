using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
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
		public DocumentType DocumentType { get; set; }
		public bool IsEmployeeRequired { get; set; }
		public bool TrackAccess { get; set; }
		public Guid CompanyId { get; set; }
		
	}

	public class EmployeeDocument
	{
		public int Id { get; set; }
		public CompanyDocumentSubType CompanyDocumentSubType { get; set; }
		public Guid EmployeeId { get; set; }
		public Guid CompanyId { get; set; }
		public DateTime? DateUploaded { get; set; }
		public string UploadedBy { get; set; }
		public Guid? DocumentId { get; set; }
		public Document Document { get; set; }
		public string CompanyName { get; set; }
		public string EmployeeName { get; set; }
		public string HostName { get; set; }
	}

	public class EmployeeDocumentAccess
	{
		public int? Id { get; set; }
		public CompanyDocumentSubType CompanyDocumentSubType { get; set; }
		public Guid? EmployeeId { get; set; }
		public Guid DocumentId { get; set; }
		public DateTime? FirstAccessed { get; set; }
		public DateTime? LastAccessed { get; set; }
		public Document Document { get; set; }
		public string CompanyName { get; set; }
		public string EmployeeName { get; set; }
		public string HostName { get; set; }
	}

	public class EmployeeDocumentMetaData
	{
		public List<EmployeeDocumentAccess> EmployeeDocumentAccesses { get; set; }
		public List<EmployeeDocument> EmployeeDocumentRequirements { get; set; } 
	}
	public class DocumentServiceMetaData
	{
		public List<DocumentType> Types { get; set; }
		public List<CompanyDocumentSubType> CompanyDocumentSubTypes { get; set; }
		public List<Document> Docs { get; set; }

		public List<Document> Documents
		{
			get
			{
				Docs.ForEach(d =>
				{
					d.DocumentType = Types.First(c => c.Id == (int) d.Type);
					if (d.CompanyDocumentSubType.HasValue)
						d.SubType = CompanyDocumentSubTypes.FirstOrDefault(st => st.Id == d.CompanyDocumentSubType);
				});
				return Docs;
			}
		}
	}

	public class Document
	{
		public int Id { get; set; }
		public int SourceEntityTypeId { get; set; }
		public System.Guid SourceEntityId { get; set; }
		public System.Guid TargetEntityId { get; set; }
		public string TargetObject { get; set; }
		public int Type { get; set; }
		public int? CompanyDocumentSubType { get; set; }
		public DocumentType DocumentType { get; set; }
		public CompanyDocumentSubType SubType { get; set; }
		public DateTime Uploaded { get; set; }
		public string UploadedBy { get; set; }

		public DocumentDto DocumentDto
		{
			get
			{
				return JsonConvert.DeserializeObject<DocumentDto>(TargetObject);
			}
		}
		public string DocumentName { get { return DocumentDto.DocumentName; } }

        public string Path {
            get
            {
                return $"{((EntityTypeEnum) SourceEntityTypeId).GetDbName()}\\{((DocType)Type).GetDbName()}\\{DocumentDto.Doc}";
            }
        }
	}

}
