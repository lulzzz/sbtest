using System;
using System.Collections.Generic;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Mementos;

namespace HrMaxx.Common.Contracts.Services
{
	public interface IPDFService
	{
		FileDto Print(PDFModel model);
		FileDto AppendAllDocuments(Guid name, string fileName, List<Guid> documents);
	}
}